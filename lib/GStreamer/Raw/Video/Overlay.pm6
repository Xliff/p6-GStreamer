use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Object;
use GLib::Raw::Structs;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::Video::Overlay;

### /usr/src/gst-plugins-base-1.20.3/gst-libs/gst/video/videooverlay.h

sub gst_video_overlay_expose (GstVideoOverlay $overlay)
  is      native(gstreamer-video)
  is      export
{ * }

sub gst_video_overlay_got_window_handle (
  GstVideoOverlay $overlay,
  guintptr        $handle
)
  is      native(gstreamer-video)
  is      export
{ * }

sub gst_is_video_overlay_prepare_window_handle_message (GstMessage $msg)
  returns uint32
  is      native(gstreamer-video)
  is      export
{ * }

sub gst_video_overlay_handle_events (
  GstVideoOverlay $overlay,
  gboolean        $handle_events
)
  is      native(gstreamer-video)
  is      export
{ * }

# sub gst_video_overlay_install_properties (
#   GObjectClass $oclass,
#   gint         $last_prop_id
# )
#   is      native(gstreamer-video)
#   is      export
# { * }

sub gst_video_overlay_prepare_window_handle (GstVideoOverlay $overlay)
  is      native(gstreamer-video)
  is      export
{ * }

sub gst_video_overlay_set_property (
  GObject $object,
  gint    $last_prop_id,
  guint   $property_id,
  GValue  $value
)
  returns uint32
  is      native(gstreamer-video)
  is      export
{ * }

sub gst_video_overlay_set_render_rectangle (
  GstVideoOverlay $overlay,
  gint            $x,
  gint            $y,
  gint            $width,
  gint            $height
)
  returns uint32
  is      native(gstreamer-video)
  is      export
{ * }

sub gst_video_overlay_set_window_handle (
  GstVideoOverlay $overlay,
  guintptr        $handle
)
  is      native(gstreamer-video)
  is      export
{ * }
