use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;

use GStreamer::Base::Src;

our subset GstPushSrcAncestry is export of Mu
  where GstPushSrc | GstBaseSrcAncestry;

class GStreamer::Base::PushSrc is GStreamer::Base::Src {
  has GstPushSrc $!ps handles <src_pad>;

  submethod BUILD (:$push-src) {
    self.setGstPushSrc($push-src) if $push-src;
  }

  method setGstPushSrc (GstPushSrcAncestry $_) {
    my $to-parent;

    $!ps = do {
      when GstPushSrc {
        $to-parent = cast(GstBaseSrc, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstPushSrc, $_);
      }
    }
    self.setGstElement($to-parent);
  }

  method GStreamer::Raw::Structs::GstPushSrc
    is also<GstPushSrc>
  { $!ps }

  method new (GstPushSrcAncestry $push-src) {
    $push-src ?? self.bless( :$push-src ) !! Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_push_src_get_type, $n, $t );
  }
}

### /usr/include/gstreamer-1.0/gst/base/gstpushsrc.h

sub gst_push_src_get_type ()
  returns GType
  is native(gstreamer-base)
  is export
{ * }
