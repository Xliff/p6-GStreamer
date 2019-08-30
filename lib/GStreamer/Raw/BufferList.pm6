use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GStreamer::Raw::Types;

unit package GStreamer::Raw::BufferList;

sub gst_buffer_list_calculate_size (GstBufferList $list)
  returns gsize
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_list_copy_deep (GstBufferList $list)
  returns GstBufferList
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_list_foreach (
  GstBufferList $list,
  GstBufferListFunc $func,
  gpointer $user_data
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_list_get (GstBufferList $list, guint $idx)
  returns GstBuffer
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_list_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_list_get_writable (GstBufferList $list, guint $idx)
  returns GstBuffer
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_list_insert (GstBufferList $list, gint $idx, GstBuffer $buffer)
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_list_length (GstBufferList $list)
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_list_new ()
  returns GstBufferList
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_list_new_sized (guint $size)
  returns GstBufferList
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_list_remove (GstBufferList $list, guint $idx, guint $length)
  is native(gstreamer)
  is export
{ * }
