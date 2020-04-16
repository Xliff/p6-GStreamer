# my $metafile = "META6.json".IO;
# my $meta = $metafile.IO.slurp;
#
# my regex resources {
#   '"resources":' \s* '[' ~ ']' <-[ \] ]>+
# }
# my regex provides {
#   '"provides":' \s* '{' ~ '}' (<-[ \} ]>+)
# }
# sub out-lines {
#   $^a.map({ "      \"$_\"" }).join(",\n");
# }
#
# if $meta ~~ &provides {
#   # Grab existing content.
#   my @provides = $/[0].Str.lines;
#   @provides.pop unless @provides[*-1].trim;
#   # Add comma to prepare for new entries.
#   @provides[* - 1] = @provides[* - 1].trim-trailing.chomp ~ ',';
#   .say for @provides;
# }

my $def = 'GType global_gst_alsasrc_get_type(void);';

my token      p { '*'+ }
my token      t { <[\w _]>+ }
my rule    type { 'const'? $<n>=\w+ <p>? }
my rule     var { <t> }
my rule returns { :!s 'const '? <t> \s* <p>? }

my rule func_def {
  <returns>
  $<sub>=[ \w+ ]
  [
    '(void)'
    |
    '(' [ <type> <var> ]+ % [ \s* ',' \s* ] ')'
  ]
  (\s* (<[A..Z]>+)+ %% '_')?';'
}

my $m = $def ~~ &func_def;
$m.gist.say;
