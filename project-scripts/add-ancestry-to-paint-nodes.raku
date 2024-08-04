use v6;

use lib <. scripts>;

use GTKScripts;

sub MAIN (
  $file,
  :var(:$initvar) = 'object-var',
  :$parent,
  :$prefix        = %config<prefix>,
  :$commit
) {
  my $fio      = $file.IO;
  my $contents = $fio.slurp;

  my token classname { [ \w+ ]+ % '::' [':' [\w+'<'.+?'>']+ % ':' ]? }
  my token typename  { \w+ }

  my rule also-does {
    'also' 'does' <classname> ';'
  }

  my rule classdef  {
    'class' <classname> ['is' <classname>]? '{'
       <also-does>*
       'has' <typename> ('$!'<[\w\-]>+) 'is implementor;'
  }

  my $matches = $contents ~~ m:g/<classdef>/;

  for $matches.map( *<classdef> ).reverse[] {
    #.gist.say;
    #say "{ .from } - { .to }";

    my $class-def := $contents.substr-rw( .from, ( .to - .from ) - 2 );

    my $tn = .<typename>.Str;
    my ($pa, $sp) = do if $parent ne 'GObject' {
      ($parent ~ 'Ancestry', '.set' ~ $parent)
    } else {
      ('GObject', '!setObject');
    }
    $class-def = qq:to/ANCESTRY/;

    our subset { $tn }Ancestry is export of Mu
      where { $tn } | { $pa };

    { $class-def.chomp }
      submethod BUILD ( :\${ $initvar } ) \{
        self.set{ $tn }(\${ $initvar })
          if \${ $initvar }
      \}

      method set{ $tn } ({ $tn }Ancestry \$_) \{
        my \$to-parent;

        { .[0] } = do \{
          when { $tn } \{
            \$to-parent = cast({ $parent }, \$_);
            \$_;
          \}

          default \{
            \$to-parent = \$_;
            cast({ $tn }, \$_);
          \}
        \}
        self{ $sp }(\$to-parent);
      \}

      method { $prefix }::Raw::Definitions::{ $tn }
      \{ { .[0] } \}

      multi method new (\${ $initvar } where * ~~ {
      $tn }Ancestry , :\$ref = True) \{
        return unless \${ $initvar };

        my \$o = self.bless( :\${ $initvar } );
        \$o.ref if \$ref;
        \$o;
      \}

    ANCESTRY

  }

  if $commit {
    $fio.rename( $fio.absolute ~ '.ancestry.bak' );
    $fio.spurt($contents);
    exit 0;
  }

  $contents.say;
}
