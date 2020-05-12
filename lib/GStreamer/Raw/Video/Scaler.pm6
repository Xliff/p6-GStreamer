use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Enums;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::Video::Scaler;

### /usr/include/gstreamer-1.0/gst/video/video-scaler.h

sub gst_video_scaler_2d (
  GstVideoScaler $hscale,
  GstVideoScaler $vscale,
  GstVideoFormat $format,
  gpointer $src,
  gint $src_stride,
  gpointer $dest,
  gint $dest_stride,
  guint $x,
  guint $y,
  guint $width,
  guint $height
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_scaler_combine_packed_YUV (
  GstVideoScaler $y_scale,
  GstVideoScaler $uv_scale,
  GstVideoFormat $in_format,
  GstVideoFormat $out_format
)
  returns GstVideoScaler
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_scaler_free (GstVideoScaler $scale)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_scaler_get_coeff (
  GstVideoScaler $scale,
  guint $out_offset,
  guint $in_offset is rw,
  guint $n_taps    is rw
)
  returns CArray[gdouble]
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_scaler_get_max_taps (GstVideoScaler $scale)
  returns guint
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_scaler_horizontal (
  GstVideoScaler $scale,
  GstVideoFormat $format,
  gpointer $src,
  gpointer $dest,                   # Better as, but less flexible: CArray[guint8] $dest,
  guint $dest_offset,
  guint $width
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_scaler_new (
  GstVideoResamplerMethod $method,
  GstVideoScalerFlags $flags,
  guint $n_taps,
  guint $in_size,
  guint $out_size,
  GstStructure $options
)
  returns GstVideoScaler
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_scaler_vertical (
  GstVideoScaler $scale,
  GstVideoFormat $format,
  CArray[gpointer] $src_lines,
  gpointer $dest,                   # Better as, but less flexible: CArray[guint8] $dest,
  guint $dest_offset,
  guint $width
)
  is native(gstreamer-video)
  is export
{ * }
