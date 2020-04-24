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
    # my gboolean $s = $scaling;
    #
    # gst_video_sink_center_rect($!vs, $dst, $result, $scaling);
    die q:to/NYI/;
      center_rect is NYI due to a NativeCall deficiency. As soon as that
      is corrected, then support for this method will be enabled.

      If this routine is important to your work, then please show your support
      of the following Rakudo PR:
        https://github.com/rakudo/rakudo/pull/2648
      NYI
  }

}

### /usr/include/gstreamer-1.0/gst/video/gstvideosink.h

sub gst_video_sink_center_rect (
  GstVideoRectangle $src,
  GstVideoRectangle $dst,
  GstVideoRectangle $result,
  gboolean $scaling
)
  is native(gstreamer-video)
  is export
{ * }
