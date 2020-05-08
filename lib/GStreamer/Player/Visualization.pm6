use v6.c;

use NativeCall;
use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Player::Visualization;

class GStreamer::Player::Visualization {
  has GstPlayerVisualization $!v handles <name description>;

  submethod BUILD (:$vis) {
    $!v = $vis;
  }

  method GStreamer::Raw::Structs::GstPlayerVisualization
    is also<GstPlayerVisualization>
  { $!v }

  method new (GstPlayerVisualization $vis) {
    $vis ?? self.bless( :$vis ) !! Nil;
  }

  method copy {
    gst_player_visualization_copy($!v);
  }

  multi method free {
    GStreamer::Player::Visualization.free($!v);
  }
  multi method free (GStreamer::Player::Visualization:U: gpointer $tf) {
    gst_player_visualization_free($tf);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &gst_player_visualization_get_type,
      $n,
      $t
    );
  }

}

use GLib::Roles::StaticClass;

class GStreamer::Player::Visualizations {
  also does GLib::Roles::StaticClass;

  method get (:$list = False, :$raw = False) {
    my $vl = gst_player_visualizations_get();

    return Nil unless $vl;
    return $vl if $list;

    my @vl = CArrayToArray(Pointer[GstPlayerVisualization], $vl);
    @vl = @vl.map({ .defined ?? .deref !! GstPlayerVisualization });
    @vl = @vl.map({ GStreamer::Player::Visualization.new($_) }) unless $raw;
    # Might need to copy each before free!
    #self!free($vl);
    @vl;
  }

  method !free (
    CArray[Pointer[GstPlayerVisualization]] $vizlist
  ) {
    gst_player_visualizations_free($vizlist);
  }

}
