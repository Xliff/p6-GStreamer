use v6.c;

use GTK::Raw::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::Buffer;

use GStreamer::MiniObject;

class GStreamer::Buffer is GStreamer::MiniObject {
  has GstBuffer $!b;

  method GStreamer::Raw::Types::GstBuffer {
  { $!b }

  method new {
    gst_buffer_new();
  }

  method new_allocate (gsize $size, GstAllocationParams $params) {
    gst_buffer_new_allocate($!b, $size, $params);
  }

  method new_wrapped (gsize $size) {
    gst_buffer_new_wrapped($!b, $size);
  }

  method new_wrapped_bytes {
    gst_buffer_new_wrapped_bytes($!b);
  }

  method new_wrapped_full (
    gpointer $data,
    gsize $maxsize,
    gsize $offset,
    gsize $size,
    gpointer $user_data,
    GDestroyNotify $notify
  ) {
    gst_buffer_new_wrapped_full($!b, $data, $maxsize, $offset, $size, $user_data, $notify);
  }

  method flags is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_buffer_get_flags($!b);
      },
      STORE => sub ($, $flags is copy) {
        gst_buffer_set_flags($!b, $flags);
      }
    );
  }

  method size is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_buffer_get_size($!b);
      },
      STORE => sub ($, $size is copy) {
        gst_buffer_set_size($!b, $size);
      }
    );
  }

  method add_meta (GstMetaInfo $info, gpointer $params) {
    gst_buffer_add_meta($!b, $info, $params);
  }

  method add_parent_buffer_meta (GstBuffer $ref) {
    gst_buffer_add_parent_buffer_meta($!b, $ref);
  }

  method add_reference_timestamp_meta (
    GstCaps $reference,
    GstClockTime $timestamp,
    GstClockTime $duration
  ) {
    gst_buffer_add_reference_timestamp_meta($!b, $reference, $timestamp, $duration);
  }

  method append (GstBuffer $buf2) {
    gst_buffer_append($!b, $buf2);
  }

  method append_memory (GstMemory $mem) {
    gst_buffer_append_memory($!b, $mem);
  }

  method append_region (GstBuffer $buf2, gssize $offset, gssize $size) {
    gst_buffer_append_region($!b, $buf2, $offset, $size);
  }

  method copy_deep {
    gst_buffer_copy_deep($!b);
  }

  method copy_into (
    GstBuffer $src,
    GstBufferCopyFlags $flags,
    gsize $offset,
    gsize $size
  ) {
    gst_buffer_copy_into($!b, $src, $flags, $offset, $size);
  }

  method copy_region (GstBufferCopyFlags $flags, gsize $offset, gsize $size) {
    gst_buffer_copy_region($!b, $flags, $offset, $size);
  }

  method extract (gsize $offset, gpointer $dest, gsize $size) {
    gst_buffer_extract($!b, $offset, $dest, $size);
  }

  method extract_dup (
    gsize $offset,
    gsize $size,
    gpointer $dest,
    gsize $dest_size
  ) {
    gst_buffer_extract_dup($!b, $offset, $size, $dest, $dest_size);
  }

  method fill (gsize $offset, gconstpointer $src, gsize $size) {
    gst_buffer_fill($!b, $offset, $src, $size);
  }

  method find_memory (
    gsize $offset,
    gsize $size,
    guint $idx,
    guint $length,
    gsize $skip
  ) {
    gst_buffer_find_memory($!b, $offset, $size, $idx, $length, $skip);
  }

  method foreach_meta (GstBufferForeachMetaFunc $func, gpointer $user_data) {
    gst_buffer_foreach_meta($!b, $func, $user_data);
  }

  method get_all_memory {
    gst_buffer_get_all_memory($!b);
  }

  method get_max_memory {
    gst_buffer_get_max_memory($!b);
  }

  method get_memory (guint $idx) {
    gst_buffer_get_memory($!b, $idx);
  }

  method get_memory_range (guint $idx, gint $length) {
    gst_buffer_get_memory_range($!b, $idx, $length);
  }

  method get_meta (GType $api) {
    gst_buffer_get_meta($!b, $api);
  }

  method get_n_meta (GType $api_type) {
    gst_buffer_get_n_meta($!b, $api_type);
  }

  method get_reference_timestamp_meta (GstCaps $reference) {
    gst_buffer_get_reference_timestamp_meta($!b, $reference);
  }

  method get_sizes (gsize $offset, gsize $maxsize) {
    gst_buffer_get_sizes($!b, $offset, $maxsize);
  }

  method get_sizes_range (
    guint $idx,
    gint $length,
    gsize $offset,
    gsize $maxsize
  ) {
    gst_buffer_get_sizes_range($!b, $idx, $length, $offset, $maxsize);
  }

  method get_type {
    gst_buffer_get_type();
  }

  method gst_parent_buffer_meta_api_get_type {
    gst_parent_buffer_meta_api_get_type();
  }

  method gst_parent_buffer_meta_get_info {
    gst_parent_buffer_meta_get_info($!b);
  }

  method gst_reference_timestamp_meta_api_get_type {
    gst_reference_timestamp_meta_api_get_type();
  }

  method gst_reference_timestamp_meta_get_info {
    gst_reference_timestamp_meta_get_info($!b);
  }

  method has_flags (GstBufferFlags $flags) {
    gst_buffer_has_flags($!b, $flags);
  }

  method insert_memory (gint $idx, GstMemory $mem) {
    gst_buffer_insert_memory($!b, $idx, $mem);
  }

  method is_all_memory_writable {
    gst_buffer_is_all_memory_writable($!b);
  }

  method is_memory_range_writable (guint $idx, gint $length) {
    gst_buffer_is_memory_range_writable($!b, $idx, $length);
  }

  method iterate_meta (gpointer $state) {
    gst_buffer_iterate_meta($!b, $state);
  }

  method iterate_meta_filtered (gpointer $state, GType $meta_api_type) {
    gst_buffer_iterate_meta_filtered($!b, $state, $meta_api_type);
  }

  method map (GstMapInfo $info, GstMapFlags $flags) {
    gst_buffer_map($!b, $info, $flags);
  }

  method map_range (
    guint $idx,
    gint $length,
    GstMapInfo $info,
    GstMapFlags $flags
  ) {
    gst_buffer_map_range($!b, $idx, $length, $info, $flags);
  }

  method memcmp (gsize $offset, gconstpointer $mem, gsize $size) {
    gst_buffer_memcmp($!b, $offset, $mem, $size);
  }

  method memset (gsize $offset, guint8 $val, gsize $size) {
    gst_buffer_memset($!b, $offset, $val, $size);
  }

  method n_memory {
    gst_buffer_n_memory($!b);
  }

  method peek_memory (guint $idx) {
    gst_buffer_peek_memory($!b, $idx);
  }

  method prepend_memory (GstMemory $mem) {
    gst_buffer_prepend_memory($!b, $mem);
  }

  method remove_all_memory {
    gst_buffer_remove_all_memory($!b);
  }

  method remove_memory (guint $idx) {
    gst_buffer_remove_memory($!b, $idx);
  }

  method remove_memory_range (guint $idx, gint $length) {
    gst_buffer_remove_memory_range($!b, $idx, $length);
  }

  method remove_meta (GstMeta $meta) {
    gst_buffer_remove_meta($!b, $meta);
  }

  method replace_all_memory (GstMemory $mem) {
    gst_buffer_replace_all_memory($!b, $mem);
  }

  method replace_memory (guint $idx, GstMemory $mem) {
    gst_buffer_replace_memory($!b, $idx, $mem);
  }

  method replace_memory_range (guint $idx, gint $length, GstMemory $mem) {
    gst_buffer_replace_memory_range($!b, $idx, $length, $mem);
  }

  method resize (gssize $offset, gssize $size) {
    gst_buffer_resize($!b, $offset, $size);
  }

  method resize_range (
    guint $idx,
    gint $length,
    gssize $offset,
    gssize $size
  ) {
    gst_buffer_resize_range($!b, $idx, $length, $offset, $size);
  }

  method unmap (GstMapInfo $info) {
    gst_buffer_unmap($!b, $info);
  }

  method unset_flags (GstBufferFlags $flags) {
    gst_buffer_unset_flags($!b, $flags);
  }

}
