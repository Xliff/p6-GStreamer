use v6.c;

use NativeCall;
use Method::Also;

use GStreamer::Raw::Types;

class GStreamer::Video::Dither {
  has GstVideoDither $!vd;

  submethod BUILD (:$dither) {
    $!vd = $dither;
  }

  method GStreamer::Raw::Definitions::GstVideoDither
    is also<GstVideoDither>
  { $!vd }

  multi method free {
    GStreamer::Video::Dither.free($!vd);
  }
  multi method free (GStreamer::Video::Dither:U: $dither) {
    gst_video_dither_free($dither);
  }

  method line (gpointer $line, Int() $x, Int() $y, Int() $width) {
    my guint ($xx, $yy, $w) = ($x, $y, $width);

    gst_video_dither_line($!vd, $line, $xx, $yy, $w);
  }

}

### /usr/include/gstreamer-1.0/gst/video/video-dither.h

sub gst_video_dither_free (GstVideoDither $dither)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_dither_line (GstVideoDither $dither, gpointer $line, guint $x, guint $y, guint $width)
  is native(gstreamer-video)
  is export
{ * }
