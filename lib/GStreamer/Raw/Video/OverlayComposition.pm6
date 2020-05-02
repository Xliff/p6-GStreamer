use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Enums;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::Video::OverlayComposition;

### /usr/include/gstreamer-1.0/gst/video/video-overlay-composition.h

sub gst_buffer_add_video_overlay_composition_meta (
  GstBuffer $buf,
  GstVideoOverlayComposition $comp
)
  returns GstVideoOverlayCompositionMeta
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_overlay_composition_add_rectangle (
  GstVideoOverlayComposition $comp,
  GstVideoOverlayRectangle $rectangle
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_overlay_composition_blend (
  GstVideoOverlayComposition $comp,
  GstVideoFrame $video_buf
)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_overlay_composition_copy (GstVideoOverlayComposition $comp)
  returns GstVideoOverlayComposition
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_overlay_composition_get_rectangle (
  GstVideoOverlayComposition $comp,
  guint $n
)
  returns GstVideoOverlayRectangle
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_overlay_composition_get_seqnum (GstVideoOverlayComposition $comp)
  returns guint
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_overlay_composition_get_type ()
  returns GType
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_overlay_composition_make_writable (
  GstVideoOverlayComposition $comp
)
  returns GstVideoOverlayComposition
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_overlay_composition_n_rectangles (
  GstVideoOverlayComposition $comp
)
  returns guint
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_overlay_composition_new (GstVideoOverlayRectangle $rectangle)
  returns GstVideoOverlayComposition
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_overlay_rectangle_copy (GstVideoOverlayRectangle $rectangle)
  returns GstVideoOverlayRectangle
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_overlay_rectangle_get_flags (GstVideoOverlayRectangle $rectangle)
  returns GstVideoOverlayFormatFlags
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_overlay_rectangle_get_global_alpha (
  GstVideoOverlayRectangle $rectangle
)
  returns gfloat
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_overlay_rectangle_get_pixels_argb (
  GstVideoOverlayRectangle $rectangle,
  GstVideoOverlayFormatFlags $flags
)
  returns GstBuffer
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_overlay_rectangle_get_pixels_ayuv (
  GstVideoOverlayRectangle $rectangle,
  GstVideoOverlayFormatFlags $flags
)
  returns GstBuffer
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_overlay_rectangle_get_pixels_raw (
  GstVideoOverlayRectangle $rectangle,
  GstVideoOverlayFormatFlags $flags
)
  returns GstBuffer
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_overlay_rectangle_get_pixels_unscaled_argb (
  GstVideoOverlayRectangle $rectangle,
  GstVideoOverlayFormatFlags $flags
)
  returns GstBuffer
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_overlay_rectangle_get_pixels_unscaled_ayuv (
  GstVideoOverlayRectangle $rectangle,
  GstVideoOverlayFormatFlags $flags
)
  returns GstBuffer
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_overlay_rectangle_get_pixels_unscaled_raw (
  GstVideoOverlayRectangle $rectangle,
  GstVideoOverlayFormatFlags $flags
)
  returns GstBuffer
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_overlay_rectangle_get_render_rectangle (
  GstVideoOverlayRectangle $rectangle,
  gint $render_x is rw,
  gint $render_y is rw,
  guint $render_width is rw,
  guint $render_height is rw
)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_overlay_rectangle_get_seqnum (
  GstVideoOverlayRectangle $rectangle
)
  returns guint
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_overlay_rectangle_set_global_alpha (
  GstVideoOverlayRectangle $rectangle,
  gfloat $global_alpha
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_overlay_rectangle_set_render_rectangle (
  GstVideoOverlayRectangle $rectangle,
  gint $render_x,
  gint $render_y,
  guint $render_width,
  guint $render_height
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_overlay_rectangle_new_raw (
  GstBuffer $pixels,
  gint $render_x,
  gint $render_y,
  guint $render_width,
  guint $render_height,
  GstVideoOverlayFormatFlags $flags
)
  returns GstVideoOverlayRectangle
  is native(gstreamer-video)
  is export
{ * }
