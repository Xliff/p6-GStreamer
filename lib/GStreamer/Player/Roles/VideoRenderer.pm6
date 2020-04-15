use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

use GStreamer::Element;

role GStreamer::Player::Roles::VideoRenderer {
  has GstPlayerVideoRenderer $!vr;

  method roleInit-VideoRenderer {
    my \i = findProperImplementor(self.^attributes);

    $!vr = cast(GstPlayerVideoRenderer, i.get_value(self) );
  }

  method GStreamer::Raw::Definitions::GstPlayerVideoRenderer
  { $!vr }

  method dispatch (GstPlayer() $player, :$raw = False) {
    my $e = create_video_sink($!vr, $player);

    $e ??
      ( $raw ?? $e !! GStreamer::Element.new($e) )
      !!
      Nil;
  }

}

sub create_video_sink (GstPlayerVideoRenderer $r, GstPlayer $p)
  is native(gstreamer-video)
{ * }
