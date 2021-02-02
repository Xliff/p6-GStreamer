use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Enums;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::Base::DataQueue;

### /usr/include/gstreamer-1.0/gst/base/gstdataqueue.h

sub gst_data_queue_drop_head (GstDataQueue $queue, GType $type)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_data_queue_flush (GstDataQueue $queue)
  is native(gstreamer-base)
  is export
{ * }

sub gst_data_queue_get_level (GstDataQueue $queue, GstDataQueueSize $level)
  is native(gstreamer-base)
  is export
{ * }

sub gst_data_queue_is_empty (GstDataQueue $queue)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_data_queue_is_full (GstDataQueue $queue)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_data_queue_limits_changed (GstDataQueue $queue)
  is native(gstreamer-base)
  is export
{ * }

sub gst_data_queue_new (
  &checkfull (GstDataQueue, guint, guint, guint64, gpointer --> gboolean),
  &fullcallback (GstDataQueue, gpointer),
  &emptycallback (GstDataQueue, gpointer),
  gpointer $checkdata
)
  returns GstDataQueue
  is native(gstreamer-base)
  is export
{ * }

sub gst_data_queue_peek (GstDataQueue $queue, GstDataQueueItem $item)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_data_queue_pop (GstDataQueue $queue, GstDataQueueItem $item)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_data_queue_push (GstDataQueue $queue, GstDataQueueItem $item)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_data_queue_push_force (GstDataQueue $queue, GstDataQueueItem $item)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_data_queue_set_flushing (GstDataQueue $queue, gboolean $flushing)
  is native(gstreamer-base)
  is export
{ * }
