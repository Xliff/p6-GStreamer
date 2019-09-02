use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GStreamer::Raw::Types;

unit package GStreamer::Raw::Allocator;

sub gst_allocator_alloc (
  GstAllocator $allocator,
  gsize $size,
  Pointer $params
)
  returns GstMemory
  is native(gstreamer)
  is export
{ * }

sub gst_allocator_find (Str $name)
  returns GstAllocator
  is native(gstreamer)
  is export
{ * }

sub gst_allocator_free (GstAllocator $allocator, GstMemory $memory)
  is native(gstreamer)
  is export
{ * }

sub gst_allocator_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_allocation_params_copy (GstAllocationParams $params)
  returns GstAllocationParams
  is native(gstreamer)
  is export
{ * }

sub gst_allocation_params_free (GstAllocationParams $params)
  is native(gstreamer)
  is export
{ * }

sub gst_allocation_params_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_allocation_params_init (GstAllocationParams $params)
  is native(gstreamer)
  is export
{ * }

sub gst_memory_new_wrapped (
  GstMemoryFlags $flags,
  gpointer $data,
  gsize $maxsize,
  gsize $offset,
  gsize $size,
  gpointer $user_data,
  GDestroyNotify $notify
)
  returns GstMemory
  is native(gstreamer)
  is export
{ * }

sub gst_allocator_register (Str $name, GstAllocator $allocator)
  is native(gstreamer)
  is export
{ * }

sub gst_allocator_set_default (GstAllocator $allocator)
  is native(gstreamer)
  is export
{ * }
