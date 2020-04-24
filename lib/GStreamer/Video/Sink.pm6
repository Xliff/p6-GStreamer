use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;

use GStreamer::Base::BaseSink;

our subset GstVideoSinkAncestry is export of Mu
  where GstVideoSink | GstBaseSinkAncestry;

class GStreamer::Video::Sink is GStreamer::Base::BaseSink {
  has GstVideoSink $!vs;

  submethod BUILD (:$video-sink) {
    self.setGstVideoSink($video-sink);
  }

  method setGstVideoSink(GstVideoSinkAncestry $_) {
    my $to-parent;

    $!vs = do {
      when GstVideoSink {
        $to-parent = cast(GstBaseSink, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstVideoSink, $_);
      }
    }
    self.setGstBaseSink($to-parent);
  }

  method GStreamer::Raw::Structs::GstVideoSink
    is also<GstVideoSink>
  { $!vs }

  method new (GstVideoSinkAncestry $video-sink) {
    $video-sink ?? self.bless( :$video-sink ) !! Nil;
  }

  method center_rect (
    GstVideoRectangle $src,       # NON-POINTER
    GstVideoRectangle $dst,       # NON-POINTER
    GstVideoRectangle $result,
    Int() $scaling
  ) is also<center-rect> {
    my gboolean $s = $scaling;

    # See comments below.
    # Special thanks to scovit++, whose workaround I am currently employing.
    # For details, see:
    #   https://colabti.org/irclogger/irclogger_log/raku-dev?date=2020-04-24#l316
    gst_video_sink_center_rect(
      $src.x +< 32 + $src.y,
      $src.w +< 32 + $src.h,
      $dst.x +< 32 + $dst.y,
      $dst.w +< 32 + $dst.y,
      $result,
      $scaling
    );
  }

}

### /usr/include/gstreamer-1.0/gst/video/gstvideosink.h

# Due to a libffi limitation, passing structs by value is currently not allowed
# in rakudo.
# sub gst_video_sink_center_rect (
#   GstVideoRectangle $src,     # PASS-BY-VALUE!
#   GstVideoRectangle $dst,     # PASS-BY-VALUE!
#   GstVideoRectangle $result,
#   gboolean $scaling
# )
#   is native(gstreamer-video)
#   is export
# { * }
#
# Therefore, we must resort to trickery!
sub gst_video_sink_center_rect(
  int64, int64, # GstVideoRectangle
  int64, int64, # GstVideoRectangle
  GstVideoRectangle $result,
  gboolean $scaling
)
  is native(gstreamer-video)
  is export
{ * }
