use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

unit package GStreamer::Raw::Allocator;

### /usr/include/gstreamer-1.0/gst/gstallocator.h

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

sub gst_allocator_register (Str $name, GstAllocator $allocator)
  is native(gstreamer)
  is export
{ * }

sub gst_allocator_set_default (GstAllocator $allocator)
  is native(gstreamer)
  is export
{ * }
