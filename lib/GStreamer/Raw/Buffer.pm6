use v6.c;

use GTK::Compat::Types;
use GStreamer::Raw;:Types;

unit package GStreamer::Raw::Buffer;

sub gst_buffer_add_meta (
  GstBuffer $buffer,
  GstMetaInfo $info,
  gpointer $params
)
  returns GstMeta
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_add_parent_buffer_meta (GstBuffer $buffer, GstBuffer $ref)
  returns GstParentBufferMeta
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_add_reference_timestamp_meta (
  GstBuffer $buffer,
  GstCaps $reference,
  GstClockTime $timestamp,
  GstClockTime $duration
)
  returns GstReferenceTimestampMeta
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_append (GstBuffer $buf1, GstBuffer $buf2)
  returns GstBuffer
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_append_memory (GstBuffer $buffer, GstMemory $mem)
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_append_region (
  GstBuffer $buf1,
  GstBuffer $buf2,
  gssize $offset,
  gssize $size
)
  returns GstBuffer
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_copy_deep (GstBuffer $buf)
  returns GstBuffer
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_copy_into (
  GstBuffer $dest,
  GstBuffer $src,
  GstBufferCopyFlags $flags,
  gsize $offset,
  gsize $size
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_copy_region (
  GstBuffer $parent,
  GstBufferCopyFlags $flags,
  gsize $offset,
  gsize $size
)
  returns GstBuffer
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_extract (
  GstBuffer $buffer,
  gsize $offset,
  gpointer $dest,
  gsize $size
)
  returns gsize
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_extract_dup (
  GstBuffer $buffer,
  gsize $offset,
  gsize $size,
  gpointer $dest,
  gsize $dest_size is rw
)
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_fill (
  GstBuffer $buffer,
  gsize $offset,
  gconstpointer $src,
  gsize $size
)
  returns gsize
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_find_memory (
  GstBuffer $buffer,
  gsize $offset,
  gsize $size,
  guint $idx    is rw,
  guint $length is rw,
  gsize $skip   is rw
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_foreach_meta (
  GstBuffer $buffer,
  GstBufferForeachMetaFunc $func,
  gpointer $user_data
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_get_all_memory (GstBuffer $buffer)
  returns GstMemory
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_get_max_memory ()
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_get_memory (GstBuffer $buffer, guint $idx)
  returns GstMemory
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_get_memory_range (GstBuffer $buffer, guint $idx, gint $length)
  returns GstMemory
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_get_meta (GstBuffer $buffer, GType $api)
  returns GstMeta
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_get_n_meta (GstBuffer $buffer, GType $api_type)
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_get_reference_timestamp_meta (
  GstBuffer $buffer,
  GstCaps $reference
)
  returns GstReferenceTimestampMeta
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_get_sizes (
  GstBuffer $buffer,
  gsize $offset  is rw,
  gsize $maxsize is rw
)
  returns gsize
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_get_sizes_range (
  GstBuffer $buffer,
  guint $idx,
  gint $length,
  gsize $offset  is rw,
  gsize $maxsize is rw
)
  returns gsize
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_parent_buffer_meta_api_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_parent_buffer_meta_get_info ()
  returns GstMetaInfo
  is native(gstreamer)
  is export
{ * }

sub gst_reference_timestamp_meta_api_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_reference_timestamp_meta_get_info ()
  returns GstMetaInfo
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_has_flags (GstBuffer $buffer, GstBufferFlags $flags)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_insert_memory (GstBuffer $buffer, gint $idx, GstMemory $mem)
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_is_all_memory_writable (GstBuffer $buffer)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_is_memory_range_writable (
  GstBuffer $buffer,
  guint $idx,
  gint $length
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_iterate_meta (GstBuffer $buffer, gpointer $state)
  returns GstMeta
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_iterate_meta_filtered (
  GstBuffer $buffer,
  gpointer $state,
  GType $meta_api_type
)
  returns GstMeta
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_map (GstBuffer $buffer, GstMapInfo $info, GstMapFlags $flags)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_map_range (
  GstBuffer $buffer,
  guint $idx,
  gint $length,
  GstMapInfo $info,
  GstMapFlags $flags
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_memcmp (
  GstBuffer $buffer,
  gsize $offset,
  gconstpointer $mem,
  gsize $size
)
  returns gint
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_memset (
  GstBuffer $buffer,
  gsize $offset,
  guint8 $val,
  gsize $size
)
  returns gsize
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_n_memory (GstBuffer $buffer)
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_new ()
  returns GstBuffer
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_new_allocate (
  GstAllocator $allocator,
  gsize $size,
  GstAllocationParams $params
)
  returns GstBuffer
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_new_wrapped (gpointer $data, gsize $size)
  returns GstBuffer
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_new_wrapped_bytes (GBytes $bytes)
  returns GstBuffer
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_new_wrapped_full (
  GstMemoryFlags $flags,
  gpointer $data,
  gsize $maxsize,
  gsize $offset,
  gsize $size,
  gpointer $user_data,
  GDestroyNotify $notify
)
  returns GstBuffer
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_peek_memory (GstBuffer $buffer, guint $idx)
  returns GstMemory
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_prepend_memory (GstBuffer $buffer, GstMemory $mem)
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_remove_all_memory (GstBuffer $buffer)
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_remove_memory (GstBuffer $buffer, guint $idx)
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_remove_memory_range (
  GstBuffer $buffer,
  guint $idx,
  gint $length
)
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_remove_meta (GstBuffer $buffer, GstMeta $meta)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_replace_all_memory (GstBuffer $buffer, GstMemory $mem)
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_replace_memory (GstBuffer $buffer, guint $idx, GstMemory $mem)
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_replace_memory_range (
  GstBuffer $buffer,
  guint $idx,
  gint $length,
  GstMemory $mem
)
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_resize (GstBuffer $buffer, gssize $offset, gssize $size)
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_resize_range (
  GstBuffer $buffer,
  guint $idx,
  gint $length,
  gssize $offset,
  gssize $size
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_unmap (GstBuffer $buffer, GstMapInfo $info)
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_unset_flags (GstBuffer $buffer, GstBufferFlags $flags)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_get_flags (GstBuffer $buffer)
  returns GstBufferFlags
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_get_size (GstBuffer $buffer)
  returns gsize
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_set_flags (GstBuffer $buffer, GstBufferFlags $flags)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_set_size (GstBuffer $buffer, gssize $size)
  is native(gstreamer)
  is export
{ * }
