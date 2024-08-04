use v6;

use lib <../scripts scripts>;

use GTKScripts;
use Template::Mustache;

my $template = "lib/GSK/Node/Transform.pm6".IO.slurp.lines[11..50];

$template = $template.join("\n");
$template ~~ s:g/'Transform'/\{\{uv\}\}/;
$template ~~ s:g/'transform'/\{\{lv\}\}/;
$template ~~ s:g/'$!gsk-tn'/\{\{iv\}\}/;

my @defs;
for find-files("lib/GSK/Node") {
  next if .basename eq 'Transform.pm6';
  next if .basename.ends-with('bak');

  my $contents = .slurp;

  next unless $contents.lines[9].starts-with('class');

  my $nodes = .Str.split('.').head.split( $*SPEC.dir-sep ).skip(3).cache;
  $nodes .= rotate(1) if $nodes.elems > 1 && $nodes.head ne 'GL';
  say "{ $nodes.gist } ({ $nodes.elems })";

  my $iv = '$!gsk-' ~ $nodes.map( *.lc.comb.head ).join('') ~ 'n';
  my $uv = $nodes.join('');
  say "Processing { .absolute }";
  $contents ~~ s:g/'method '\w+'_node_'/method /;
  $contents ~~ s:g/' (GskRenderNode'.+?')'//;
  $contents ~~ s:g/'$node'/{$iv}/;

  my @lines = $contents.lines;
  @lines.splice($_, 1) for (8..13).reverse;

  my $replacement = Template::Mustache.render(
    $template,
    {
        :$uv,
        :$iv,
        lv => $nodes.map( *.lc ).join('-')
    }
  );

  .rename("{ .Str }.fix.bak");

  @lines = |@lines[^9], |$replacement.lines,
           '',
           |@lines[9..*].map('  ' ~ *),
           '',
           '}';

  my $new-contents = @lines.join("\n");
  $new-contents.say;

  .spurt($new-contents);
  exit;
}
