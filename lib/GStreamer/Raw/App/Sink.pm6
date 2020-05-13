use v6.c;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::App::Sink;

### /usr/include/gstreamer-1.0/gst/app/gstappsink.h

sub gst_app_sink_get_buffer_list_support (GstAppSink $appsink)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_app_sink_get_caps (GstAppSink $appsink)
  returns GstCaps
  is native(gstreamer-video)
  is export
{ * }

sub gst_app_sink_get_drop (GstAppSink $appsink)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_app_sink_get_emit_signals (GstAppSink $appsink)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_app_sink_get_max_buffers (GstAppSink $appsink)
  returns guint
  is native(gstreamer-video)
  is export
{ * }

sub gst_app_sink_get_wait_on_eos (GstAppSink $appsink)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_app_sink_is_eos (GstAppSink $appsink)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_app_sink_pull_preroll (GstAppSink $appsink)
  returns GstSample
  is native(gstreamer-video)
  is export
{ * }

sub gst_app_sink_pull_sample (GstAppSink $appsink)
  returns GstSample
  is native(gstreamer-video)
  is export
{ * }

sub gst_app_sink_set_buffer_list_support (
  GstAppSink $appsink,
  gboolean $enable_lists
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_app_sink_set_callbacks (
  GstAppSink $appsink,
  GstAppSinkCallbacks $callbacks,
  gpointer $user_data,
  GDestroyNotify $notify
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_app_sink_set_caps (GstAppSink $appsink, GstCaps $caps)
  is native(gstreamer-video)
  is export
{ * }

sub gst_app_sink_set_drop (GstAppSink $appsink, gboolean $drop)
  is native(gstreamer-video)
  is export
{ * }

sub gst_app_sink_set_emit_signals (GstAppSink $appsink, gboolean $emit)
  is native(gstreamer-video)
  is export
{ * }

sub gst_app_sink_set_max_buffers (GstAppSink $appsink, guint $max)
  is native(gstreamer-video)
  is export
{ * }

sub gst_app_sink_set_wait_on_eos (GstAppSink $appsink, gboolean $wait)
  is native(gstreamer-video)
  is export
{ * }

sub gst_app_sink_try_pull_preroll (GstAppSink $appsink, GstClockTime $timeout)
  returns GstSample
  is native(gstreamer-video)
  is export
{ * }

sub gst_app_sink_try_pull_sample (GstAppSink $appsink, GstClockTime $timeout)
  returns GstSample
  is native(gstreamer-video)
  is export
{ * }
