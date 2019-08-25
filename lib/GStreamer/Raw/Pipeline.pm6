use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GStreamer::Raw::Types;

unit package GStreamer::Raw::Pipeline;

sub gst_pipeline_auto_clock (GstPipeline $pipeline)
  is native(gstreamer)
  is export
{ * }

sub gst_pipeline_get_bus (GstPipeline $pipeline)
  returns GstBus
  is native(gstreamer)
  is export
{ * }

sub gst_pipeline_get_pipeline_clock (GstPipeline $pipeline)
  returns GstClock
  is native(gstreamer)
  is export
{ * }

sub gst_pipeline_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_pipeline_new (Str $name)
  returns GstElement
  is native(gstreamer)
  is export
{ * }

sub gst_pipeline_use_clock (GstPipeline $pipeline, GstClock $clock)
  is native(gstreamer)
  is export
{ * }

sub gst_pipeline_get_auto_flush_bus (GstPipeline $pipeline)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pipeline_get_clock (GstPipeline $pipeline)
  returns GstClock
  is native(gstreamer)
  is export
{ * }

sub gst_pipeline_get_delay (GstPipeline $pipeline)
  returns GstClockTime
  is native(gstreamer)
  is export
{ * }

sub gst_pipeline_get_latency (GstPipeline $pipeline)
  returns GstClockTime
  is native(gstreamer)
  is export
{ * }

sub gst_pipeline_set_auto_flush_bus (GstPipeline $pipeline, gboolean $auto_flush)
  is native(gstreamer)
  is export
{ * }

sub gst_pipeline_set_clock (GstPipeline $pipeline, GstClock $clock)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pipeline_set_delay (GstPipeline $pipeline, GstClockTime $delay)
  is native(gstreamer)
  is export
{ * }

sub gst_pipeline_set_latency (GstPipeline $pipeline, GstClockTime $latency)
  is native(gstreamer)
  is export
{ * }
