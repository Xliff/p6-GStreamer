#!/usr/bin/env perl6
use v6.c;

use LWP::Simple;
#use Mojo::DOM:from<Perl5>;
use DOM::Tiny;

use lib <scripts .>;

use GTKScripts;

my @really-strings = <
  char      gchar
  uchar     guchar
  chararray gchararray
  unichar
  string    gstring
>;

my @gtypes = <
  boolean
  int      uint
  long     ulong
  int64    uint64
  double
  float
  string
  pointer
>;

sub get-vtype-rw ($gtype) {
  my ($vtype-r, $vtype-w);
  my $i = ' ' x 6;
  if $gtype ne '-type-' {
    $_ = $*types;
    my $u = S/^ 'g'//;
    if $u eq @really-strings.any {
      $u = 'string';
    }

    $vtype-r = $i ~ '$gv.' ~ $u ~ ';';
    $vtype-w = '$gv.' ~ $u ~ ' = $val;';
  } else {
    $vtype-r = $i ~ '#$gv.TYPE';
    $vtype-w = '#$gv.TYPE = $val;';
  }

  ($vtype-r, $vtype-w);
}

sub getType {
  do given $*types {
    when 'gboolean' | 'boolean' { $*co = 'Int()'; 'G_TYPE_BOOLEAN' }
    when 'gint'     | 'int'     { $*co = 'Int()'; 'G_TYPE_INT'     }
    when 'gint64'   | 'int64'   { $*co = 'Int()'; 'G_TYPE_INT64'   }
    when 'guint64'  | 'uint64'  { $*co = 'Int()'; 'G_TYPE_UINT64'  }
    when 'guint'    | 'uint'    { $*co = 'Int()'; 'G_TYPE_UINT'    }
    when 'glong'    | 'long'    { $*co = 'Int()'; 'G_TYPE_LONG'    }
    when 'gulong'   | 'ulong'   { $*co = 'Int()'; 'G_TYPE_ULONG'   }
    when 'gdouble'  | 'double'  { $*co = 'Num()'; 'G_TYPE_DOUBLE'  }
    when 'gfloat'   | 'float'   { $*co = 'Num()'; 'G_TYPE_FLOAT'   }

    when 'gpointer' | 'pointer' {                 'G_TYPE_POINTER' }

    when @really-strings.any    { $*co = 'Str()'; 'G_TYPE_STRING'  }

    default {
      '-type-'
    }
  }
}

my %methods;

sub genSub ($mn, $rw, $gtype, $dep, $vtype-r, $vtype-w) {
  my %c;

  # say "MN: $mn, RW: { $rw.map( "'" ~ * ~ "'" ).join(', ') }";

  with $rw {
    %c<read> =
      #"\t  \$gv = GLib::Value.new(\n" ~
      ' ' x 6 ~ "self.prop_get('{ $mn }', \$gv);\n" ~
      #' ' x 6 ~ ");\n" ~
      $vtype-r
    if $rw.any eq 'read';

    # say "R: { so($rw.any eq 'read') }";

    %c<write> =
      "{ $vtype-w }\n" ~
      ' ' x 6 ~ "self.prop_set(\'{ $mn }\', \$gv);"
    if $rw.any eq 'write';

    # say "W: { so($rw.any eq 'write') }";

    %c<write> = "warn '{ $mn } is a construct-only attribute'"
      if $rw.any eq 'construct';
  }

  %c<write> //= "warn '{ $mn } does not allow writing'";

  # Remember to emit a returned value, or the STORE will not work.
  # Read warnings should appear behind a DEBUG sentinel.
  %c<read>  //= qq:to/READ/;
warn '{ $mn } does not allow reading' if \$DEBUG;
{ ' ' x 6 }{ $gtype eq 'G_TYPE_STRING' ?? "''" !! '0' };
READ

  my $deprecated = '';
  if $dep {
    $deprecated = ' is DEPRECATED';
    $deprecated ~= "({$dep})" unless $dep ~~ Bool;
  };

  %methods{$mn} = qq:to/METH/;
    # Type: { $*types }
    method $mn is rw { $deprecated } is g-property \{
      my \$gv = GLib::Value.new( { $gtype } );
      Proxy.new(
        FETCH => sub (\$) \{
          { %c<read>.trim }
        \},
        STORE => -> \$, { $*co // '' } \$val is copy \{
          { %c<write> }
        \}
      );
    \}
    METH

  %methods{$mn}.say;
  %methods{$mn}
}

sub generateFromDOM ($dom, $control, $var) {
  my $v = "\$\!$var";

  #my $sig-div = $dom.find('div.refsect1 a').to_array.List.grep(
  #  *.attr('name') eq "{ $control }.signal-details"
  #)[0].parent;
  for '.property-details', '.style-properties', '#properties' -> $pd {
    my $found = False;

    quietly {
      for $dom.find('div.refsect1 a') -> $e {
        #say "Searching for: { $control }{ $pd }...";
        if $e && $e.attr('name') eq "{ $control }{ $pd }" {
          $found = $e.parent;
          last;
        }
      }
    }

    unless $found {
      say "Could not find { $pd } section for { $control }";
      next;
    }
    if $found && $pd eq '.style-properties' {
      say 'Retrieval of style properties NYI';
      next;
    }

    for $found.find('div h3 code') -> $e {
      (my $mn = $e.text) ~~ s:g/<[“”"]>//;

      my $pre = $e.parent.parent.find('pre').tail;
      my @t = $pre.find('span.type');
      my @i = $pre.parent.find('p');
      my @w = $pre.parent.find('div.warning');
      my ($dep, $rw);

      for @i {
        if .text ~~ /
          'Flags'? ': '
          ('Read' | 'Write' | 'Construct')+ % ' / '
        / {
          $rw = $/[0].map( *.lc ).Array;
        }
      }
      # Due to the variety of types, this isn't the only place to look...
      unless $rw.defined {
        if $pre.text ~~ /
          'Flags'? ': '
          ('Read' | 'Write' | 'Construct')+ % ' / '
        / {
          $rw = $/[0].map( *.lc ).Array;
        }
      }

      for @w {
        $dep = so .all_text ~~ /'deprecated'/;
        if $dep {
          .all_text ~~ /'Use' (.+?) 'instead'/;
          with $/ {
            $dep = $/[0] with $/[0];
          }
        }
      }

      my (%c, $*co);
      my $*types = @t.map(*.text.trim).join(', ');
      my $gtype  = getType;

      genSub( $mn, $rw, $gtype, $dep, |get-vtype-rw($gtype) )
    }
  }
}

sub generateFromFile (
   $type-prefix,
   $control      is copy,
   $var,
  :$control-name
) {
  say "Loading: { $control }";
  $control = $control.subst('file://', '');

  my $control-type = do if $control-name.not {
    # First part must come from header (.h) file
    my $contents = $control.ends-with('.h') ??
      $control.IO.slurp !!
      $control.IO.extension('h').IO.slurp;

    my token start-decls {
      'G_DECLARE_FINAL_TYPE'    | 'G_DECLARE_DERIVABLE_TYPE'
      'G_DEFINE_TYPE_WITH_CODE'
    }

    my $search = $contents ~~ /
      'G_TYPE_CHECK_INSTANCE_CAST' .+? $<t>=[ <{ $type-prefix }> \w+ ] ')' $$ |
      ^^  <start-decls> \s* '(' $<t>=[ <{ $type-prefix }> \w+ ]
    /;

    $/<t> ?? $/<t>.Str !! 'Dzl'
  } else {
    $control-name
  }

  # Final part must come from implementation (.c) file
  my $contents = $control.ends-with('.c') ??
    $control.IO.slurp !!
    $control.IO.extension('c').IO.slurp;

  my $search = $contents ~~ m:g/
    'g_param_spec_' (\w+) <?{ $0.Str eq <ref unref>.none }> <.ws>? '(' <.ws>?
      $<params>=[
        [ $<p>=<-[,]>+? ]+ % ','
      ]
      <.ws>? ');'
  /;

  my %properties;
  for $search.sort( *.<p>[0].Str ) {

    #.gist.say;

    my $prop-name = .<p>[0].Str;

    my $rw = (
      do gather for .<p>.tail
                        .lc
                        .split(/ <.ws> '|' <.ws> /)
        -> $_ is copy
     {
        my @perms;

        # say "RW-P: $_";

        s:g/\W//;
        s/ 'writ'» /write/;

        @perms.push: 'read'           if .ends-with('_read'  | '_readable');
        @perms.push: 'write'          if .ends-with('_write' | '_writable');
        @perms.append: |<read write>  if .ends-with('readwrite');

        if +@perms {
          take $_ for @perms;
        }
      }
    ).cache;

    #say "RW: { $rw.gist }";

    my $*co;
    my $type = my $*types = .[0].Str;
    $type = do if $type eq @gtypes.any {
      $*types = $type;
      getType
    } else {
      my $pre = .<p>[3] // '';
      $*types = $type-prefix ~ $pre.split('_')
                                   .skip(2)
                                   .map( *.lc.tc )
                                   .join;
    }

    my $dep = False;

    genSub(
      $prop-name.subst('"', '', :g),
      $rw,
      $type,
      $dep,
      |get-vtype-rw($type)
    )
  }
}

sub MAIN (
  $control           is copy,
  :$var              is copy = 'w',
  :$prefix           is copy = "https://developer.gnome.org/gtk3/stable/",
  :$type-prefix              = %config<struct-prefix> // %config<struct_prefix> //
                               %config<type-prefix>   // %config<type_prefix>   // %config<prefix>,
  :$control-name
) {
  # If it's a URL, then try to pick it apart
  my $ext = '';
  $control ~~ / ^ $<con>=[ 'http's? | 'file' ] '://' /;
  given $/<con> {
    when 'file' | $control.ends-with('.c') {
      die 'Must specify --type-prefix!' unless $type-prefix;
      $control = %config<include-directory>.IO.add($control).absolute
	unless $control.starts-with('/');

      generateFromFile($type-prefix, $control, $var, :$control-name);
    }

    when 'http' | 'https' | $control.ends-with('.html') {
      my $new_prefix = $/.Str;
      my $new_control = $new_prefix.split('/')[* - 1];
      $new_control ~~ s/ '.' (.+?) $//;
      $ext = ".{ $/[0] }";
      $new_prefix ~~ s| '/' <-[/]>+? $|/|;
      ($prefix, $control) = ($new_prefix.trim, $type-prefix // $new_control.trim);

      my $uri = "{ $prefix }{ $control }{ $ext }";
      say "Retrieving: $uri";
      my $dom = DOM::Tiny.parse(
        do {
          when $prefix.starts-with('http' | 'https') {
            LWP::Simple.new.get($uri)
          }

          when $prefix.starts-with('file') {
            $uri.subst('file://', '').IO.slurp
          }
        }
      );

      generateFromDOM($dom, $control, $var);
    }

    say "Attempting with prefix = { $prefix } control = { $control }";
  }

  #.value.say for %methods.pairs.sort( *.key );
}
