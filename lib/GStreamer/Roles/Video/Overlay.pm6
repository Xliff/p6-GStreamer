use v6.c;

use GLib::Raw::Traits;
use GStreamer::Raw::Types;
use GStreamer::Raw::Video::Overlay;

use GLib::Roles::Object;
use GLib::Roles::Implementor;

role GStreamer::Roles::Video::Overlay {

  has GstVideoOverlay $!gst-vo is implementor;

  method roleInit-GstVideoOverlay {
    return if $!gst-vo;

    my \i = findProperImplementor(self.^attributes);

    $!gst-vo = cast( GstVideoOverlay, i.get_value(self) );
  }

  method GStreamer::Raw::Definitions::GstVideoOverlay
  { $!gst-vo }
  method GstVideoOverlay
  { $!gst-vo }

  method expose {
    gst_video_overlay_expose($!gst-vo);
  }

  multi method got_window_handle (Int() $handle) {
    samewith( newCArray(guint, $handle) );
  }
  multi method got_window_handle (guintptr $handle) {
    gst_video_overlay_got_window_handle($!gst-vo, $handle);
  }

  method is_video_overlay_prepare_window_handle_message (
    GstMessage() $message
  )
    is static
  {
    gst_is_video_overlay_prepare_window_handle_message($message);
  }

  method handle_events (Int() $handle_events) {
    my gboolean $h = $handle_events.so.Int;

    gst_video_overlay_handle_events($!gst-vo, $h);
  }

  method prepare_window_handle {
    gst_video_overlay_prepare_window_handle($!gst-vo);
  }

  # method set_property (
  #   GObject $object,
  #   gint    $last_prop_id,
  #   guint   $property_id,
  #   GValue  $value
  # ) {
  #   gst_video_overlay_set_property($!gst-vo, $last_prop_id, $property_id, $value);
  # }

  method set_render_rectangle (
    Int() $x,
    Int() $y,
    Int() $width,
    Int() $height
  ) {
    my gint ($xx, $yy, $w, $h) = ($x, $y, $width, $height);

    gst_video_overlay_set_render_rectangle($!gst-vo, $xx, $yy, $w, $h);
  }

  proto method set_window_handle (|)
  { * }

  multi method set_window_handle (Int() $handle) {
    samewith( newCArray(guint, $handle) );
  }
  multi method set_window_handle (guintptr $handle) {
    gst_video_overlay_set_window_handle($!gst-vo, $handle);
  }

}


our subset GstVideoOverlayAncestry is export of Mu
  where GstVideoOverlay | GObject;

class GStreamer::Video::Overlay {
  also does GLib::Roles::Object;
  also does GStreamer::Roles::Video::Overlay;

  submethod BUILD ( :$gst-video-overlay ) {
    self.setGstVideoOverlay($gst-video-overlay) if $gst-video-overlay;
  }

  method setGstVideoOverlay (GstVideoOverlayAncestry $_) {
    my $to-parent;

    $!gst-vo = do {
      when GstVideoOverlay {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstVideoOverlay, $_);
      }
    }
    self!setObject($to-parent);
  }

  multi method new (
     $gst-video-overlay where * ~~ GstVideoOverlayAncestry,

    :$ref = True
  ) {
    return unless $gst-video-overlay;

    my $o = self.bless( :$gst-video-overlay );
    $o.ref if $ref;
    $o;
  }

}
