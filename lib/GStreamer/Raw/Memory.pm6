use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Enums;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::Memory;

### /usr/include/gstreamer-1.0/gst/gstmemory.h

sub gst_memory_copy (GstMemory $mem, gssize $offset, gssize $size)
  returns GstMemory
  is native(gstreamer-video)
  is export
{ * }

sub gst_memory_get_sizes (
  GstMemory $mem,
  gsize $offset is rw,
  gsize $maxsize is rw
)
  returns gsize
  is native(gstreamer-video)
  is export
{ * }

sub gst_memory_get_type ()
  returns GType
  is native(gstreamer-video)
  is export
{ * }

sub gst_memory_init (
  GstMemory $mem,
  GstMemoryFlags $flags,
  GstAllocator $allocator,
  GstMemory $parent,
  gsize $maxsize,
  gsize $align,
  gsize $offset,
  gsize $size
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_memory_is_span (GstMemory $mem1, GstMemory $mem2, gsize $offset)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_memory_is_type (GstMemory $mem, Str $mem_type)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_memory_make_mapped (
  GstMemory $mem,
  GstMapInfo $info,
  GstMapFlags $flags
)
  returns GstMemory
  is native(gstreamer-video)
  is export
{ * }

sub gst_memory_map (GstMemory $mem, GstMapInfo $info, GstMapFlags $flags)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_memory_resize (GstMemory $mem, gssize $offset, gsize $size)
  is native(gstreamer-video)
  is export
{ * }

sub gst_memory_share (GstMemory $mem, gssize $offset, gssize $size)
  returns GstMemory
  is native(gstreamer-video)
  is export
{ * }

sub gst_memory_unmap (GstMemory $mem, GstMapInfo $info)
  is native(gstreamer-video)
  is export
{ * }

### /usr/include/gstreamer-1.0/gst/gstallocator.h

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
