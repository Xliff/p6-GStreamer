use v6.c;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::Buffer;

use GStreamer::MiniObject;

our subset BufferAncestry is export of Mu
  where GstBuffer | GstMiniObject;

class GStreamer::Buffer is GStreamer::MiniObject {
  has GstBuffer $!b;

  submethod BUILD (:$buffer) {
    self.setBuffer($buffer);
  }

  method setBuffer (BufferAncestry $_) {
    my $to-parent;

    $!b = do {
      when GstBuffer {
        $to-parent = cast(GstMiniObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstBuffer, $_);
      }
    }
    self.setGstMiniObject($to-parent);
  }

  method GStreamer::Raw::Types::GstBuffer
  { $!b }

  multi method new (GstBuffer $buffer) {
    self.bless( :$buffer );
  }
  multi method new {
    self.bless( buffer => gst_buffer_new() );
  }

  multi method new (
    GstAllocator() $alloc,
    Int() $size,
    GstAllocationParams() $params,
    :$allocator is required
  ) {
    GStreamer::Buffer.new_allocate($alloc, $size, $params);
  }
  method new_allocate (
    GstAllocator() $allocator,
    Int() $size,
    GstAllocationParams() $params
  ) {
    my gsize $s = $size;

    self.bless( buffer => gst_buffer_new_allocate($allocator, $s, $params) );
  }

  multi method new (
    gpointer $data,
    Int() $size,
    :$wrapped is required
  ) {
    GStreamer::Buffer.new_wrapped($data, $size);
  }
  method new_wrapped (gpointer $data, Int() $size) {
    my gsize $s = $size;

    self.bless( buffer => gst_buffer_new_wrapped($data, $size) );
  }

  multi method new (
    GBytes() $bytes,
    :wrapped-bytes(:$wrapped_bytes) is required
  ) {
    GStreamer::Buffer.new_wrapped_bytes($bytes);
  }
  method new_wrapped_bytes (GBytes() $bytes) {
    gst_buffer_new_wrapped_bytes($bytes);
  }

  multi method new (
    gpointer $data,
    Int() $maxsize,
    Int() $offset,
    Int() $size,
    gpointer $user_data    = gpointer,
    GDestroyNotify $notify = gpointer,
    :wrapped-full(:full($wrapped_full)) is required
  ) {
    GStreamer::Buffer.new_wrapped_full(
      $data,
      $maxsize,
      $offset,
      $size,
      $user_data,
      $notify
    );
  }
  method new_wrapped_full (
    gpointer $data,
    Int() $maxsize,
    Int() $offset,
    Int() $size,
    gpointer $user_data    = gpointer,
    GDestroyNotify $notify = gpointer
  ) {
    my gsize ($m, $o, $s) = 0 xx 3;
    gst_buffer_new_wrapped_full($!b, $data, $m, $o, $s, $user_data, $notify);
  }

  method flags is rw {
    Proxy.new(
      FETCH => sub ($) {
        GstBufferFlagsEnum( gst_buffer_get_flags($!b) );
      },
      STORE => sub ($, Int() $flags is copy) {
        my GstBufferFlags $f = $flags;

        gst_buffer_set_flags($!b, $f);
      }
    );
  }

  method size is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_buffer_get_size($!b);
      },
      STORE => sub ($, Int() $size is copy) {
        gst_buffer_set_size($!b, $size);
      }
    );
  }

  method add_meta (GstMetaInfo $info, gpointer $params) {
    gst_buffer_add_meta($!b, $info, $params);
  }

  method add_parent_buffer_meta (GstBuffer() $ref) {
    gst_buffer_add_parent_buffer_meta($!b, $ref);
  }

  method add_reference_timestamp_meta (
    GstCaps() $reference,
    Int() $timestamp,
    Int() $duration
  ) {
    my GstClockTime ($t, $d) = ($timestamp, $duration);

    gst_buffer_add_reference_timestamp_meta($!b, $reference, $t, $d);
  }

  multi method append (GstBuffer() $buf2) {
    GStreamer::Buffer.append($!b, $buf2);
  }
  multi method append (
    GStreamer::Buffer:U:
    GstBuffer() $buf1, GstBuffer() $buf2
  ) {
    gst_buffer_append($buf1, $buf2);
  }

  method append_memory (GstMemory() $mem) {
    gst_buffer_append_memory($!b, $mem);
  }

  proto method append_region (|)
  { * }

  multi method append_region (GstBuffer() $buf2, Int() $offset, Int() $size) {
    GStreamer::Buffer.append_region($!b, $buf2, $offset, $size);
  }
  multi method append_region (
    GStreamer::Buffer:U:
    GstBuffer() $buf2,
    Int() $offset,
    Int() $size
  ) {
    my gssize ($o, $s) = ($offset, $size);
    gst_buffer_append_region($!b, $buf2, $o, $s);
  }

  multi method copy (:$raw = False) {
    GStreamer::Buffer.copy($!b, :$raw);
  }
  multi method copy (GStreamer::Buffer:U: GstBuffer() $cpy, :$raw) {
    my $c = cast(
      GstBuffer,
      GStreamer::MiniObject.copy( cast(GstMiniObject, $cpy) )
    );

    $c ??
      ( $raw ?? $c !! GStreamer::Buffer.new($c) )
      !!
      Nil;
  }


  proto method copy_deep (|)
  { * }

  multi method copy_deep (:$raw = False) {
    GStreamer::Buffer.copy_deep($!b, :$raw);
  }
  multi method copy_deep (GStreamer::Buffer:U: GstBuffer() $cd, :$raw = False) {
    my $c = gst_buffer_copy_deep($!b);

    $cd ??
      ( $raw ?? $cd !! GStreamer::Buffer.new($cd) )
      !!
      Nil;
  }

  method copy_into (
    GstBuffer $src,
    Int() $flags,
    Int() $offset,
    Int() $size
  ) {
    my GstBufferCopyFlags $f = $flags;
    my gsize ($o, $s) = ($offset, $size);

    so gst_buffer_copy_into($!b, $src, $flags, $offset, $size);
  }

  proto method copy_region (|)
  { * }

  multi method copy_region (
    Int() $flags,
    Int() $offset,
    Int() $size,
    :$raw = False
  ) {
    GStreamer::Buffer.copy_region($!b, $flags, $offset, $size, :$raw);
  }
  multi method copy_region (
    GstBuffer() $parent,
    Int() $flags,
    Int() $offset,
    Int() $size,
    :$raw = False;
  ) {
    my GstBufferCopyFlags $f = $flags;
    my gsize ($o, $s) = ($offset, $size);
    my $b = gst_buffer_copy_region($!b, $f, $o, $s);

    $b ??
      ( $raw ?? $b !! GStreamer::Buffer.new($b) )
      !!
      Nil;
  }

  method extract (Int() $offset, gpointer $dest, Int() $size) {
    my gsize ($o, $s) = ($offset, $size);

    gst_buffer_extract($!b, $o, $dest, $s);
  }

  method extract_dup (
    Int() $offset,
    Int() $size,
    gpointer $dest,
    Int() $dest_size
  ) {
    my gsize ($o, $s, $d) = ($offset, $size, $dest_size);

    gst_buffer_extract_dup($!b, $o, $s, $dest, $d);
  }

  method fill (Int() $offset, gpointer $src, Int() $size) {
    my gsize ($o, $s) = ($offset, $size);

    gst_buffer_fill($!b, $offset, $src, $size);
  }

  proto method find_memory (|)
  { * }

  multi method find_memory (
    Int() $offset,
    Int() $size,
  ) {
    samewith($offset, $size, $, $, $);
  }
  multi method find_memory (
    Int() $offset,
    Int() $size,
    Int() $idx,
    $length is rw,
    $skip   is rw
  ) {
    my guint ($i, $l) = 0 xx 2;
    my gsize $s = 0;

    my $rc = gst_buffer_find_memory($!b, $offset, $size, $i, $l, $s);
    ($idx, $length, $skip) = ($i, $l, $s);
    ($idx, $length, $skip, $rc)
  }

  method foreach_meta (
    GstBufferForeachMetaFunc $func,
    gpointer $user_data = gpointer
  ) {
    gst_buffer_foreach_meta($!b, $func, $user_data);
  }

  method get_all_memory ($raw = False) {
    my $m = gst_buffer_get_all_memory($!b);

    $m ??
      ( $raw ?? $m !! GStreamer::Memory.new($m) )
      !!
      Nil;
  }

  method get_max_memory ( GStreamer::Buffer:U: ) {
    GstBufferFlagsEnum( gst_buffer_get_max_memory() );
  }

  method get_memory (Int() $idx, :$raw = False) {
    my guint $i = $idx;
    my $m = gst_buffer_get_memory($!b, $i);

    $m ??
      ( $raw ?? $m !! GStreamer::Memory.new($m) )
      !!
      Nil;
  }

  method get_memory_range (Int() $idx, Int() $length, :$raw = False) {
    my guint ($i, $l) = ($idx, $length);
    my $m = gst_buffer_get_memory_range($!b, $idx, $length);

    $m ??
      ( $raw ?? $m !! GStreamer::Memory.new($m) )
      !!
      Nil;
  }

  method get_meta (Int() $api) {
    my GType $a = $api;

    gst_buffer_get_meta($!b, $a);
  }

  method get_n_meta (GType $api) {
    my GType $a = $api;

    gst_buffer_get_n_meta($!b, $a);
  }

  method get_reference_timestamp_meta (GstCaps() $reference) {
    gst_buffer_get_reference_timestamp_meta($!b, $reference);
  }

  proto method get_sizes (|)
  { * }

  multi method get_sizes (:$all = False) {
    samewith($, $, :$all);
  }
  multi method get_sizes ($offset is rw, $maxsize is rw, :$all) {
    my gsize ($o, $m)  = 0 xx 2;

    my $s = gst_buffer_get_sizes($!b, $o, $m);
    ($offset, $maxsize) = ($o, $m);
    $all.not ?? $s !! ($s, $o, $m);
  }

  proto method get_sizes_range (|)
  { * }

  multi method get_sizes_range (
    Int() $idx,
    Int() $length,
    :$all = False
  ) {
    samewith($idx, $length, $, $, :$all);
  }
  multi method get_sizes_range (
    guint $idx,
    gint $length,
    $offset  is rw,
    $maxsize is rw,
    :$all = False
  ) {
    my guint $i = $idx;
    my gint $l = $length;
    my gsize ($o, $m) = 0 xx 2;
    my $rc = gst_buffer_get_sizes_range($!b, $i, $l, $o, $m);

    ($offset, $maxsize) = ($o, $m);
    $all.not ?? $rc !! ($rc, $offset, $maxsize);
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_buffer_get_type, $n, $t );
  }

  # To implement, later.
  # method gst_parent_buffer_meta_api_get_type {
  #   gst_parent_buffer_meta_api_get_type();
  # }
  #
  # method gst_parent_buffer_meta_get_info {
  #   gst_parent_buffer_meta_get_info($!b);
  # }
  #
  # method gst_reference_timestamp_meta_api_get_type {
  #   gst_reference_timestamp_meta_api_get_type();
  # }
  #
  # method gst_reference_timestamp_meta_get_info {
  #   gst_reference_timestamp_meta_get_info($!b);
  # }

  method has_flags (Int() $flags) {
    my GstBufferFlags $f = $flags;

    so gst_buffer_has_flags($!b, $f);
  }

  method insert_memory (Int() $idx, GstMemory() $mem) {
    my gint $i = $idx;

    gst_buffer_insert_memory($!b, $i, $mem);
  }

  method is_all_memory_writable {
    so gst_buffer_is_all_memory_writable($!b);
  }

  method is_memory_range_writable (Int() $idx, Int() $length) {
    my guint $i = $idx;
    my gint $l = $length;

    so gst_buffer_is_memory_range_writable($!b, $i, $l);
  }

  method iterate_meta (gpointer $state, :$raw = False;) {
    my $m = gst_buffer_iterate_meta($!b, $state);

    $m ??
      ( $raw ?? $m !! GStreamer::Meta.new($m) )
      !!
      Nil;
  }

  method iterate_meta_filtered (
    gpointer $state,
    Int() $meta_api_type,
    :$raw = False
  ) {
    my GType $m = $meta_api_type;
    my $meta = gst_buffer_iterate_meta_filtered($!b, $state, $m);

    $meta ??
      ( $raw ?? $meta !! GStreamer::Meta.new($meta) )
      !!
      Nil;
  }

  method map (GstMapInfo() $info, Int() $flags) {
    my GstMapFlags $f = $flags;

    so gst_buffer_map($!b, $info, $flags);
  }

  method map_range (
    Int() $idx,
    Int() $length,
    GstMapInfo() $info,
    Int() $flags
  ) {
    my GstMapFlags $f = $flags;
    my guint $i = $idx;
    my gint $l = $length;

    so gst_buffer_map_range($!b, $idx, $l, $i, $f);
  }

  method memcmp (Int() $offset, gconstpointer $mem, Int() $size) {
    my gsize ($o, $s) = ($offset, $size);

    gst_buffer_memcmp($!b, $o, $mem, $s);
  }

  method memset (
    Int() $offset,
    Int() $val where * ~ 0..255,
    Int() $size
  ) {
    my gsize ($o, $s) = ($offset, $size);
    my guint8 $v = $val;

    gst_buffer_memset($!b, $o, $v, $s);
  }

  method n_memory {
    gst_buffer_n_memory($!b);
  }

  method peek_memory (Int() $idx, :$raw = False) {
    my guint $i = $idx;
    my $m = gst_buffer_peek_memory($!b, $i);

    $m ??
      ( $raw ?? $m !! GStreamer::Memory.new($m) )
      !!
      Nil;
  }

  method prepend_memory (GstMemory() $mem) {
    gst_buffer_prepend_memory($!b, $mem);
  }

  method remove_all_memory {
    gst_buffer_remove_all_memory($!b);
  }

  method remove_memory (Int() $idx) {
    my guint $i = $idx;

    gst_buffer_remove_memory($!b, $i);
  }

  method remove_memory_range (Int() $idx, Int() $length) {
    my guint $i = $idx;
    my gint $l = $length;

    gst_buffer_remove_memory_range($!b, $i, $l);
  }

  method remove_meta (GstMeta() $meta) {
    so gst_buffer_remove_meta($!b, $meta);
  }

  method replace_all_memory (GstMemory() $mem) {
    gst_buffer_replace_all_memory($!b, $mem);
  }

  method replace_memory (Int() $idx, GstMemory() $mem) {
    my guint $i = $idx;

    gst_buffer_replace_memory($!b, $idx, $mem);
  }

  method replace_memory_range (Int() $idx, Int() $length, GstMemory() $mem) {
    my guint $i = $idx;
    my gint $l = $length;

    gst_buffer_replace_memory_range($!b, $idx, $length, $mem);
  }

  method resize (Int() $offset, Int() $size) {
    my gssize ($o, $s) = ($offset, $size);

    gst_buffer_resize($!b, $o, $s);
  }

  method resize_range (
    Int() $idx,
    Int() $length,
    Int() $offset,
    Int() $size
  ) {
    my guint $i = $idx;
    my gint $l = $length;
    my gssize ($o, $s) = ($offset, $size);

    gst_buffer_resize_range($!b, $idx, $l, $o, $s);
  }

  method unmap (GstMapInfo() $info) {
    gst_buffer_unmap($!b, $info);
  }

  method unset_flags (GstBufferFlags $flags) {
    my GstBufferFlags $f = $flags;

    gst_buffer_unset_flags($!b, $f);
  }

}
