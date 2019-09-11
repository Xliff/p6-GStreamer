use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GStreamer::Raw::Types;

unit package GStreamer::Raw::AtomicQueue;

sub gst_atomic_queue_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_atomic_queue_length (GstAtomicQueue $queue)
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_atomic_queue_new (guint $initial_size)
  returns GstAtomicQueue
  is native(gstreamer)
  is export
{ * }

sub gst_atomic_queue_peek (GstAtomicQueue $queue)
  returns Pointer
  is native(gstreamer)
  is export
{ * }

sub gst_atomic_queue_pop (GstAtomicQueue $queue)
  returns Pointer
  is native(gstreamer)
  is export
{ * }

sub gst_atomic_queue_push (GstAtomicQueue $queue, gpointer $data)
  is native(gstreamer)
  is export
{ * }

sub gst_atomic_queue_ref (GstAtomicQueue $queue)
  is native(gstreamer)
  is export
{ * }

sub gst_atomic_queue_unref (GstAtomicQueue $queue)
  is native(gstreamer)
  is export
{ * }
