use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::Base::QueueArray;


### /usr/include/gstreamer-1.0/gst/base/gstqueuearray.h

sub gst_queue_array_clear (GstQueueArray $array)
  is native(gstreamer-base)
  is export
{ * }

sub gst_queue_array_drop_element (GstQueueArray $array, guint $idx)
  returns Pointer
  is native(gstreamer-base)
  is export
{ * }

sub gst_queue_array_drop_struct (
  GstQueueArray $array,
  guint $idx,
  gpointer $p_struct
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_queue_array_find (
  GstQueueArray $array,
  GCompareFunc $func,
  gpointer $data
)
  returns guint
  is native(gstreamer-base)
  is export
{ * }

sub gst_queue_array_free (GstQueueArray $array)
  is native(gstreamer-base)
  is export
{ * }

sub gst_queue_array_get_length (GstQueueArray $array)
  returns guint
  is native(gstreamer-base)
  is export
{ * }

sub gst_queue_array_is_empty (GstQueueArray $array)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_queue_array_new (guint $initial_size)
  returns GstQueueArray
  is native(gstreamer-base)
  is export
{ * }

sub gst_queue_array_new_for_struct (gsize $struct_size, guint $initial_size)
  returns GstQueueArray
  is native(gstreamer-base)
  is export
{ * }

sub gst_queue_array_peek_head (GstQueueArray $array)
  returns Pointer
  is native(gstreamer-base)
  is export
{ * }

sub gst_queue_array_peek_head_struct (GstQueueArray $array)
  returns Pointer
  is native(gstreamer-base)
  is export
{ * }

sub gst_queue_array_peek_nth (GstQueueArray $array, guint $idx)
  returns Pointer
  is native(gstreamer-base)
  is export
{ * }

sub gst_queue_array_peek_nth_struct (GstQueueArray $array, guint $idx)
  returns Pointer
  is native(gstreamer-base)
  is export
{ * }

sub gst_queue_array_peek_tail (GstQueueArray $array)
  returns Pointer
  is native(gstreamer-base)
  is export
{ * }

sub gst_queue_array_peek_tail_struct (GstQueueArray $array)
  returns Pointer
  is native(gstreamer-base)
  is export
{ * }

sub gst_queue_array_pop_head (GstQueueArray $array)
  returns Pointer
  is native(gstreamer-base)
  is export
{ * }

sub gst_queue_array_pop_head_struct (GstQueueArray $array)
  returns Pointer
  is native(gstreamer-base)
  is export
{ * }

sub gst_queue_array_pop_tail (GstQueueArray $array)
  returns Pointer
  is native(gstreamer-base)
  is export
{ * }

sub gst_queue_array_pop_tail_struct (GstQueueArray $array)
  returns Pointer
  is native(gstreamer-base)
  is export
{ * }

sub gst_queue_array_push_tail (GstQueueArray $array, gpointer $data)
  is native(gstreamer-base)
  is export
{ * }

sub gst_queue_array_push_tail_struct (GstQueueArray $array, gpointer $p_struct)
  is native(gstreamer-base)
  is export
{ * }

sub gst_queue_array_set_clear_func (
  GstQueueArray $array,
  GDestroyNotify $clear_func
)
  is native(gstreamer-base)
  is export
{ * }
