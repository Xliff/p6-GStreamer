use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Enums;
use GStreamer::Raw::Structs;

### /usr/include/gstreamer-1.0/gst/video/video-format.h

sub gst_video_format_from_masks (
  gint $depth,
  gint $bpp,
  gint $endianness,
  guint $red_mask,
  guint $green_mask,
  guint $blue_mask,
  guint $alpha_mask
)
  returns GstVideoFormat
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_format_from_fourcc (guint32 $fourcc)
  returns GstVideoFormat
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_format_from_string (Str $format)
  returns GstVideoFormat
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_format_get_info (GstVideoFormat $format)
  returns GstVideoFormatInfo
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_format_get_palette (GstVideoFormat $format, gsize $size)
  returns Pointer
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_format_to_fourcc (GstVideoFormat $format)
  returns guint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_format_to_string (GstVideoFormat $format)
  returns Str
  is native(gstreamer-video)
  is export
{ * }
