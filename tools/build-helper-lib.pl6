#!/usr/bin/env perl6

my $metafile = "META6.json".IO;

# Need test for DIRECT subdirs.
sub subdirs (IO::Path $dir, :$all = False) {
  $dir.dir(
    test => {
      $dir.add($_).d &&
      ($all || $_ ne <. ..>.any)
    }
  );
}

sub MAIN (
  $directory,                 #= Top level plugin directory
  :$subdirs is required,      #= Comma separated list of sub-directories to process
  :$package                   #= Optional namespace for detected plugins
) {
  my $plugin-package = $*SPEC.splitdir($directory)[* - 1].tc;

  say "»»»» Working in $directory";

  my (@so-files, @pm-files);
  my $gobj-cflags  = qqx{pkg-config gobject-2.0 --cflags};
  my $gobj-ldflags = qqx{pkg-config gobject-2.0 --libs};
  my $dir = $directory.IO;

  for $subdirs.split(',') -> $sd {
    my $d = $sd.trim;

    # Check sub-dirs of $d
    for $dir.add($d).&subdirs -> $opd {
      next if $opd.basename eq <. ..>.any;

      say "\tProcessing { $opd }";

      for $opd.&subdirs -> $pd {
        # ONLY check .libs dir!
        next unless $pd.absolute.ends-with('.libs');

        my @o-io = $pd.dir( test => {$pd.add($_).extension eq 'o'} );

        say "\t\tChecking {$pd} ...";

        # Check .libs *.so for LOCAL symbols.
        my (%resolver, @locals);
        for $pd.dir( test => { $pd.add($_).extension eq 'so'} ) {
          my $re = qqx{readelf -s --wide $_};

          for $re.lines {
            next unless .trim;

            my @f = .split(/\s+/);
            # Should also check for the magic _get_type!
            if @f[5] eq 'LOCAL' && @f[8].ends-with('_get_type') {
              @locals.push: @f[8];
              %resolver{ @locals[* - 1] } = 1;
            }
          }
        }



        # Due to various unforseen issues, it's better to just compile the
        # helper with ALL of the .o files found in a plugin's directory, to
        # insure that it compiles properly!!

        # BEGIN ---------------- XXX --- unforseen issues with this approach!
        # if @locals {
        #   # Now scan all .o files for anything found in @locals
        #   my @o-io = $pd.dir( test => {$pd.add($_).extension eq 'o'} );
        #   for @o-io -> $obj-io {
        #     my $nm = qqx{nm -s $obj-io};
        #
        #     for $nm.lines {
        #       next unless .trim;
        #
        #       my @f = .split(/\s+/);
        #
        #       if @f[2] eq @locals.any {
        #         my ($k, $v) = @locals.kv.rotor(2).grep({ .[1] eq @f[2] }).flat;
        #
        #         # say "L: { @f[2] } / {@f[1]} / {$k // 'NOT FOUND'}";
        #
        #         # Check if routine is defined in this module.
        #         if $k.defined && @f[1] eq <T t>.any {
        #           # say "K: { @locals[$k] }";
        #           %resolver{ @locals[$k] }.push: $obj-io;
        #           @locals.splice($k, 1);
        #         }
        #       }
        #     }
        #   }
        # }
        #
        # if @locals {
        #   say "\t\t\tThe following routines were not found in the object files:";
        #   .say for @locals.map( "\t\t\t\t" ~ * );
        # }
        # - EMD --------------- XXX --- unforseen issues with this approach!

        my @dirs = (do gather for $*SPEC.splitdir( $pd.absolute ).reverse {
          take $_;
          last if $_ eq $sd;
        }).skip(1).reverse;

        my $lpd = $*CWD.add('resources').add('plugins');
        $lpd .= add($_) for @dirs;

        my $bn = $*SPEC.splitdir($lpd)[* - 1];
        if %resolver.keys {
          my ($h-io, $c-io, $so-io, $mod-io)
            = <h c so pm6>.map({ $lpd.add("{$bn}.{$_}") });

          # Create and write out header file.
          $lpd.mkdir;
          $h-io.spurt:
            %resolver.keys.sort.map({ "GType global_{$_}(void);\n\n" }).join("\n");

          # Create and write out C implementation.
          my $c-defs = qq:to/C/ ~ "\n";
            #include "glib-object.h"
            #include "{$h-io.basename}"
            C

          for %resolver.keys.sort {
            $c-defs ~= qq:to/C-FUNC/;
              GType global_{$_}(void) \{
                {$_}();
              \}
              C-FUNC
            $c-defs ~= "\n";
          }
          $c-io.spurt: $c-defs;

          # Compile C file into shared lib
          my @gcc = «
            gcc
            $c-io
            -o
            $so-io
            -shared
            -fPIC
            "-I{$h-io.dirname}"
            -Wno-implicit-function-declaration
          »;
          @gcc.append( $gobj-cflags.split(/\s+/) );
          @gcc.append(@o-io);
          @gcc.append( $gobj-ldflags.split(/\s+/) );
          @gcc .= grep( *.chars );

          #@gcc.join(' ').say;

          my $proc = Proc::Async.new( |@gcc, :out );
          react {
            # split input on \r\n, \n, and \r
            whenever $proc.stdout.lines { .say }
            # chunks
            whenever $proc.stderr       { .say }

            whenever $proc.start {
              exit if .exitcode;
              @so-files.push: $so-io.relative( $*CWD );
              done;
            }
          }

          # Output NativeCall definitions.
          my $plugin-base = $so-io.extension('').basename;
          my $plugin-package = "GStreamer::Plugins::{
            $package ?? "{$package}::{$plugin-base}" !! "{$plugin-base}"
          }";
          my $nc-defs  = qq:to/NC-PRE/;
            use NativeCall;

            unit package {$plugin-package};

            constant {$plugin-base} = \%?RESOURCES<plugins/lib/{$plugin-base}/{$plugin-base}>;
            \n
            NC-PRE

          my $cmd = «
            hMethodMaker
            --bland
            --output=subs
            --no-headers
            "--lib={$plugin-base}"
            $h-io
          ».join(' ');
          $nc-defs ~= qqx{$cmd};

          $mod-io.spurt: $nc-defs;
          @pm-files.push: ($mod-io, $plugin-package);
        }
      }
    }
  }

  # Add libs to a META6.json
  if $metafile.e {
    my $meta = $metafile.IO.slurp;

    my regex resources {
      '"resources":' \s* '[' ~ ']' <-[ \] ]>+
    }
    my regex provides {
      '"provides":' \s* '{' ~ '}' (<-[ \} ]>+)
    }
    sub ol {
      $^a.map({ "        \"$_\"" }).join(",\n");
    }

    # Extract provides section and add in plugin modules.
    if $meta ~~ &provides {
      # Grab existing content.
      my @provides = $/[0].Str.lines.map( * ~ "\n");
      # Add comma to prepare for new entries.
      @provides.pop unless @provides[*-1].trim;
      @provides[* - 1] = @provides[* - 1].trim-trailing.chomp ~ ',';
      # Add new entries,
      @pm-files .= map({ qq<      "{$_[1]}": "{$_[0].relative($*CWD)}",\n>});
      # Fix up new entries before appending.
      #   - Prepend newline on first entry
      @pm-files[0].substr-rw(0, 0) = "\n ";
      #   - Remove trailing comma
      @pm-files[* - 1] .= chop;
      @provides.append: @pm-files;
      # Replace section.
      $meta ~~ s[ <provides> ] =
        "\"provides\": \{\n{ @provides.lines.join("\n") }\n    \}";
    }

    # Write out resources directive.
    $meta ~~ s[ <resources> ] =
      "\"resources\": [\n{ @so-files.&ol }\n    ]";
    $metafile.rename( $metafile.extension('bak') );
    $metafile.spurt: $meta;
  }

}
