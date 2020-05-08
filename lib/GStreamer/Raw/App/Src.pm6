use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Enums;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::App::Src;

### /usr/include/gstreamer-1.0/gst/app/gstappsrc.h

sub gst_app_src_end_of_stream (GstAppSrc $appsrc)
  returns GstFlowReturn
  is native(gstreamer-app)
  is export
{ * }

sub gst_app_src_get_caps (GstAppSrc $appsrc)
  returns GstCaps
  is native(gstreamer-app)
  is export
{ * }

sub gst_app_src_get_current_level_bytes (GstAppSrc $appsrc)
  returns guint64
  is native(gstreamer-app)
  is export
{ * }

sub gst_app_src_get_duration (GstAppSrc $appsrc)
  returns GstClockTime
  is native(gstreamer-app)
  is export
{ * }

sub gst_app_src_get_emit_signals (GstAppSrc $appsrc)
  returns uint32
  is native(gstreamer-app)
  is export
{ * }

sub gst_app_src_get_latency (
  GstAppSrc $appsrc,
  guint64 $min is rw,
  guint64 $max is rw
)
  is native(gstreamer-app)
  is export
{ * }

sub gst_app_src_get_max_bytes (GstAppSrc $appsrc)
  returns guint64
  is native(gstreamer-app)
  is export
{ * }

sub gst_app_src_get_size (GstAppSrc $appsrc)
  returns gint64
  is native(gstreamer-app)
  is export
{ * }

sub gst_app_src_get_stream_type (GstAppSrc $appsrc)
  returns GstAppStreamType
  is native(gstreamer-app)
  is export
{ * }

sub gst_app_src_get_type ()
  returns GType
  is native(gstreamer-app)
  is export
{ * }

sub gst_app_src_push_buffer (GstAppSrc $appsrc, GstBuffer $buffer)
  returns GstFlowReturn
  is native(gstreamer-app)
  is export
{ * }

sub gst_app_src_push_buffer_list (
  GstAppSrc $appsrc,
  GstBufferList $buffer_list
)
  returns GstFlowReturn
  is native(gstreamer-app)
  is export
{ * }

sub gst_app_src_push_sample (GstAppSrc $appsrc, GstSample $sample)
  returns GstFlowReturn
  is native(gstreamer-app)
  is export
{ * }

sub gst_app_src_set_callbacks (
  GstAppSrc $appsrc,
  GstAppSrcCallbacks $callbacks,
  gpointer $user_data,
  GDestroyNotify $notify
)
  is native(gstreamer-app)
  is export
{ * }

sub gst_app_src_set_caps (GstAppSrc $appsrc, GstCaps $caps)
  is native(gstreamer-app)
  is export
{ * }

sub gst_app_src_set_duration (GstAppSrc $appsrc, GstClockTime $duration)
  is native(gstreamer-app)
  is export
{ * }

sub gst_app_src_set_emit_signals (GstAppSrc $appsrc, gboolean $emit)
  is native(gstreamer-app)
  is export
{ * }

sub gst_app_src_set_latency (GstAppSrc $appsrc, guint64 $min, guint64 $max)
  is native(gstreamer-app)
  is export
{ * }

sub gst_app_src_set_max_bytes (GstAppSrc $appsrc, guint64 $max)
  is native(gstreamer-app)
  is export
{ * }

sub gst_app_src_set_size (GstAppSrc $appsrc, gint64 $size)
  is native(gstreamer-app)
  is export
{ * }

sub gst_app_src_set_stream_type (GstAppSrc $appsrc, GstAppStreamType $type)
  is native(gstreamer-app)
  is export
{ * }
