sub MAIN ($filename, :$remove='gtk-') {

  my regex trait-def {
    'is' \s+ $<trait>=\w+ [
      '<' .+? '>' |
      '(' .+? ')'
    ]?
  }

  my token method-name {
    <-[\s(]>+
  }

  my regex method-start {
    ^^ \s* ('multi' \s+)? 'method' \s+ <method-name>
  }
  my rule method-def {
    <method-start> $<traits>=(<trait-def> % \s+)? '{'
  }


  my $contents = $filename.IO.slurp;
  my $results  = $contents ~~ /<method-def>/;

  for $results.reverse {
    my $contents-rw := $contents.substr-rw( .start, .end - .start );

    my $mn  = .<method-start><method-name>;
    my $rmn = $mn.subst($remove, '');

    sub alias ($s) {
      $s.trans( '-_' => '_-', )
    }

    my @aliases = ($mn.&alias, $rmn, $rmn.&alias);


  }
}
