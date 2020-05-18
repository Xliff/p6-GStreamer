use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;

use GStreamer::Base::Transform;

# cw: This class has virtual methods, thie manipulation of which would require GTK-Class
#     support, which is NYI, upstream
#
#     This class definition is left as a placeholder, until then.

our subset GstVideoFilterAncestry is export of Mu
  where GstVideoFilter | GstBaseTransformAncestry;

class GStreamer::Video::Filter is GStreamer::Base::Transform {
  has GstVideoFilter $!vf;

  submethod BUILD (:$video-filter) {
    self.setGstVideoFilter($video-filter);
  }

  method setGstVideoFilter (GstVideoFilterAncestry $_) {
    my $to-parent;

    $!vf = do {
      when GstVideoFilter {
        $to-parent = cast(GstBaseTransform, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstVideoFilter, $_);
      }
    }
    self.setGstBaseTransform($to-parent);
  }

  method GStreamer::Raw::Structs::GstVideoFilter
    is also<GstVideoFilter>
  { $!vf }

  method new (GstVideoFilterAncestry $video-filter) {
    $video-filter ?? self.bless( :$video-filter ) !! Nil;
  }

}

sub gst_video_filter_get_type ()
  returns GType
  is native(gstreamer-video)
  is export
{ * }
