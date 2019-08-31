my $tags;
my regex tag-name { <[A..Z_]>+ }
my regex value    { <["']> ~ <["']> (.+?) }

sub get-tags($t = $tags, :$new = False) {
  my $m = $new ??
    $tags ~~ m:g/ 'constant' \s* <tag-name> \s* 'is export =' \s* <value> / !!
    $tags ~~ m:g/ '#define' \s* <tag-name> \s* <value> /;

  gather for $m.Array {
    take .<tag-name> => .<value>[0].Str
  }
}

$tags = '/usr/include/gstreamer-1.0/gst/gsttaglist.h'.IO.slurp;
my %orig-tags = do { get-tags };

$tags = '/home/cbwood/Projects/p6-GStreamer/lib/GStreamer/Raw/Tags.pm6'.IO.slurp;
my %new-tags = do { get-tags(:new) };

for %orig-tags.pairs.sort( *.key ) {
  if %new-tags{.key}:exists {
    say "{ .key } does not match value of '{ %new-tags{.key} }' in .pm6"
      if .value ne %new-tags{.key};
  } else {
    say "{ .key } does not exist in .pm6":
  }
}
