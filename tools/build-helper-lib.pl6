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
  :$subdirs is required       #= Comma separated list of sub-directories to process
) {

  say "»»»» Working in $directory";

  my @so-files;
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

        say "\t\tChecking {$pd} ...";

        # Check .libs *.so for LOCAL symbols.
        my @locals;
        for $pd.dir( test => { $pd.add($_).extension eq 'so'} ) {
          my $re = qqx{readelf -s --wide $_};

          for $re.lines {
            next unless .trim;

            my @f = .split(/\s+/);
            # Should also check for the magic _get_type!
            @locals.push: @f[8] if [&&](
              @f[5] eq 'LOCAL',
              @f[8].ends-with('_get_type')
            );
          }
        }

        my %resolver;
        if @locals {
          # Now scan all .o files for anything found in @locals
          for $pd.dir( test => {$pd.add($_).extension eq 'o'} ) -> $obj-io {
            my $nm = qqx{nm -s $obj-io};

            for $nm.lines {
              next unless .trim;

              my @f = .split(/\s+/);

              if @f[2] eq @locals.any {
                my ($k, $v) = @locals.grep( * eq @f[2] ).kv;

                #say "L: { @f[2] } / {@f[1]} / {$k // 'NOT FOUND'}";

                # Check if routine is defined in this module.
                if $k.defined && @f[1] eq 'T' {
                  %resolver{ @locals[$k] } = $obj-io;
                  @locals .= splice($k, 0);
                }
              }
            }
          }
        }

        if @locals {
          say "\t\t\tThe following routines were not found in the object files:";
          .say for @locals.map( "\t\t\t\t" ~ * );
        }

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
            %resolver.keys.sort.map({ "GType global_{$_}();\n" }).join("\n");

          # Create and write out C implementation.
          my $c-defs = qq:to/C/ ~ "\n";
            #include "glib-object.h"
            #include "{$h-io.basename}"
            C

          for %resolver.keys.sort {
            $c-defs ~= qq:to/C-FUNC/;
              GType global_{$_}() \{
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
          @gcc.append(%resolver.values.map( *.Str ).sort);
          @gcc.append( $gobj-ldflags.split(/\s+/) );
          @gcc .= grep( *.chars );

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
          my $nc-defs  = qq:to/NC-PRE/;
            use NativeCall;

            constant {$plugin-base} = \%?RESOURCES<plugins/lib/{$plugin-base}>
            NC-PRE

          my $cmd = «
            hMethodMaker
            --bland
            --output=subs
            "--lib={$plugin-base}"
            $h-io
          ».join(' ');
          $nc-defs ~= qqx{$cmd};

          $mod-io.spurt: $nc-defs;
        }
      }
    }
  }

  # Add libs to a META6.json
  if $metafile.e {
    my $meta = $metafile.IO.slurp;
    $meta ~~ s[ '"resources":' \s* '[' ~ ']' <-[ \] ]>+ ] =
      "resources: [\n{ @so-files.map({ "\t\"$_\"" }).join(",\n")}\n    ]";
    $metafile.rename( $metafile.extension('bak') );
    $metafile.spurt: $meta;
  }

}
