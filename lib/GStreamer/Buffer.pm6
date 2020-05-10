use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Buffer;

use GStreamer::MiniObject;

#use GStreamer::Memory;
#use GStreamer::Meta;

our subset GstBufferAncestry is export of Mu
  where GstBuffer | GstMiniObject;

class GStreamer::Buffer is GStreamer::MiniObject {
  has GstBuffer $!b;

  submethod BUILD (:$buffer) {
    self.setBuffer($buffer);
  }

  method setBuffer (GstBufferAncestry $_) {
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
    is also<GstBuffer>
  { $!b }

  multi method new (GstBufferAncestry $buffer) {
    $buffer ?? self.bless( :$buffer ) !! Nil;
  }
  multi method new {
    my $buffer = gst_buffer_new();

    $buffer ?? self.bless( :$buffer ) !! Nil;
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
  )
    is also<new-allocate>
  {
    my gsize $s = $size;
    my $buffer = gst_buffer_new_allocate($allocator, $s, $params);

    $buffer ?? self.bless( :$buffer ) !! Nil;
  }

  multi method new (
    gpointer $data,
    Int() $size,
    :$wrapped is required
  ) {
    GStreamer::Buffer.new_wrapped($data, $size);
  }
  method new_wrapped (gpointer $data, Int() $size) is also<new-wrapped> {
    my gsize $s = $size;
    my $buffer = gst_buffer_new_wrapped($data, $size);

    $buffer ?? self.bless( :$buffer ) !! Nil;
  }

  multi method new (
    GBytes() $bytes,
    :wrapped-bytes(:$wrapped_bytes) is required
  ) {
    GStreamer::Buffer.new_wrapped_bytes($bytes);
  }
  method new_wrapped_bytes (GBytes() $bytes) is also<new-wrapped-bytes> {
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
    Int() $flags,
    gpointer $data,
    Int() $maxsize,
    Int() $offset,
    Int() $size,
    gpointer $user_data    = gpointer,
    GDestroyNotify $notify = gpointer
  )
    is also<new-wrapped-full>
  {
    my GstMemoryFlags $f = $flags;
    my gsize ($m, $o, $s) = 0 xx 3;
    my $buffer = gst_buffer_new_wrapped_full(
      $f,
      $data,
      $m,
      $o,
      $s,
      $user_data,
      $notify
    );

    $buffer ?? self.bless( :$buffer ) !! Nil;
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

  method add_meta (GstMetaInfo $info, gpointer $params) is also<add-meta> {
    gst_buffer_add_meta($!b, $info, $params);
  }

  method add_parent_buffer_meta (GstBuffer() $ref)
    is also<add-parent-buffer-meta>
  {
    gst_buffer_add_parent_buffer_meta($!b, $ref);
  }

  method add_reference_timestamp_meta (
    GstCaps() $reference,
    Int() $timestamp,
    Int() $duration
  )
    is also<add-reference-timestamp-meta>
  {
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

  method append_memory (GstMemory() $mem) is also<append-memory> {
    gst_buffer_append_memory($!b, $mem);
  }

  proto method append_region (|)
      is also<append-region>
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

  # Does not exist in library!
  # multi method copy (:$raw = False) {
  #   GStreamer::Buffer.copy($!b, :$raw);
  # }
  # multi method copy (GStreamer::Buffer:U: GstBuffer() $cpy, :$raw = False) {
  #   my $c = gst_buffer_copy($cpy);
  #
  #   $c ??
  #     ( $raw ?? $c !! GStreamer::Buffer.new($c) )
  #     !!
  #     GstBuffer;
  # }

  proto method copy_deep (|)
      is also<
        copy-deep
        copy
      >
  { * }

  # cw: ALL copy constructors should probably follow this behavior!
  # - 2020-3-30
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
  )
    is also<copy-into>
  {
    my GstBufferCopyFlags $f = $flags;
    my gsize ($o, $s) = ($offset, $size);

    so gst_buffer_copy_into($!b, $src, $flags, $offset, $size);
  }

  proto method copy_region (|)
      is also<copy-region>
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
  )
    is also<extract-dup>
  {
    my gsize ($o, $s, $d) = ($offset, $size, $dest_size);

    gst_buffer_extract_dup($!b, $o, $s, $dest, $d);
  }

  method fill (Int() $offset, gpointer $src, Int() $size) {
    my gsize ($o, $s) = ($offset, $size);

    gst_buffer_fill($!b, $offset, $src, $size);
  }

  proto method find_memory (|)
      is also<find-memory>
  { * }

  multi method find_memory (
    Int() $offset,
    Int() $size,
  ) {
    my $rv = callwith($offset, $size, $, $, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method find_memory (
    Int() $offset,
    Int() $size,
    Int() $idx,
    $length is rw,
    $skip   is rw,
    :$all = False
  ) {
    my guint ($i, $l) = 0 xx 2;
    my gsize $s = 0;

    my $rv = gst_buffer_find_memory($!b, $offset, $size, $i, $l, $s);
    ($idx, $length, $skip) = ($i, $l, $s);
    $all.not ?? $rv !! ($rv, $idx, $length, $skip);
  }

  method foreach_meta (
    GstBufferForeachMetaFunc $func,
    gpointer $user_data = gpointer
  )
    is also<foreach-meta>
  {
    gst_buffer_foreach_meta($!b, $func, $user_data);
  }

  method get_all_memory ($raw = False) is also<get-all-memory> {
    my $m = gst_buffer_get_all_memory($!b);

    $m ??
      ( $raw ?? $m !! GStreamer::Memory.new($m) )
      !!
      Nil;
  }

  method get_max_memory ( GStreamer::Buffer:U: ) is also<get-max-memory> {
    GstBufferFlagsEnum( gst_buffer_get_max_memory() );
  }

  method get_memory (Int() $idx, :$raw = False) is also<get-memory> {
    my guint $i = $idx;
    my $m = gst_buffer_get_memory($!b, $i);

    $m ??
      ( $raw ?? $m !! GStreamer::Memory.new($m) )
      !!
      Nil;
  }

  method get_memory_range (Int() $idx, Int() $length, :$raw = False)
    is also<get-memory-range>
  {
    my guint ($i, $l) = ($idx, $length);
    my $m = gst_buffer_get_memory_range($!b, $idx, $length);

    $m ??
      ( $raw ?? $m !! GStreamer::Memory.new($m) )
      !!
      Nil;
  }

  method get_meta (Int() $api) is also<get-meta> {
    my GType $a = $api;

    gst_buffer_get_meta($!b, $a);
  }

  method get_n_meta (GType $api) is also<get-n-meta> {
    my GType $a = $api;

    gst_buffer_get_n_meta($!b, $a);
  }

  method get_reference_timestamp_meta (GstCaps() $reference)
    is also<get-reference-timestamp-meta>
  {
    gst_buffer_get_reference_timestamp_meta($!b, $reference);
  }

  proto method get_sizes (|)
      is also<get-sizes>
  { * }

  multi method get_sizes {
    samewith($, $, :all);
  }
  multi method get_sizes ($offset is rw, $maxsize is rw, :$all = False) {
    my gsize ($o, $m)  = 0 xx 2;

    my $s = gst_buffer_get_sizes($!b, $o, $m);
    ($offset, $maxsize) = ($o, $m);
    $all.not ?? $s !! ($s, $o, $m);
  }

  proto method get_sizes_range (|)
      is also<get-sizes-range>
  { * }

  multi method get_sizes_range (
    Int() $idx,
    Int() $length,
  ) {
    my $rv = callwith($idx, $length, $, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
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
    my $rv = gst_buffer_get_sizes_range($!b, $i, $l, $o, $m);

    ($offset, $maxsize) = ($o, $m);
    $all.not ?? $rv !! ($rv, $offset, $maxsize);
  }

  method get_type is also<get-type> {
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

  method has_flags (Int() $flags) is also<has-flags> {
    my GstBufferFlags $f = $flags;

    so gst_buffer_has_flags($!b, $f);
  }

  method insert_memory (Int() $idx, GstMemory() $mem) is also<insert-memory> {
    my gint $i = $idx;

    gst_buffer_insert_memory($!b, $i, $mem);
  }

  method is_all_memory_writable is also<is-all-memory-writable> {
    so gst_buffer_is_all_memory_writable($!b);
  }

  method is_memory_range_writable (Int() $idx, Int() $length)
    is also<is-memory-range-writable>
  {
    my guint $i = $idx;
    my gint $l = $length;

    so gst_buffer_is_memory_range_writable($!b, $i, $l);
  }

  method iterate_meta (gpointer $state, :$raw = False;) is also<iterate-meta> {
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
  )
    is also<iterate-meta-filtered>
  {
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
  )
    is also<map-range>
  {
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

  method n_memory is also<n-memory> {
    gst_buffer_n_memory($!b);
  }

  method peek_memory (Int() $idx, :$raw = False) is also<peek-memory> {
    my guint $i = $idx;
    my $m = gst_buffer_peek_memory($!b, $i);

    $m ??
      ( $raw ?? $m !! GStreamer::Memory.new($m) )
      !!
      Nil;
  }

  method prepend_memory (GstMemory() $mem) is also<prepend-memory> {
    gst_buffer_prepend_memory($!b, $mem);
  }

  method remove_all_memory is also<remove-all-memory> {
    gst_buffer_remove_all_memory($!b);
  }

  method remove_memory (Int() $idx) is also<remove-memory> {
    my guint $i = $idx;

    gst_buffer_remove_memory($!b, $i);
  }

  method remove_memory_range (Int() $idx, Int() $length)
    is also<remove-memory-range>
  {
    my guint $i = $idx;
    my gint $l = $length;

    gst_buffer_remove_memory_range($!b, $i, $l);
  }

  method remove_meta (GstMeta() $meta) is also<remove-meta> {
    so gst_buffer_remove_meta($!b, $meta);
  }

  method replace_all_memory (GstMemory() $mem) is also<replace-all-memory> {
    gst_buffer_replace_all_memory($!b, $mem);
  }

  method replace_memory (Int() $idx, GstMemory() $mem)
    is also<replace-memory>
  {
    my guint $i = $idx;

    gst_buffer_replace_memory($!b, $idx, $mem);
  }

  method replace_memory_range (Int() $idx, Int() $length, GstMemory() $mem)
    is also<replace-memory-range>
  {
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
  )
    is also<resize-range>
  {
    my guint $i = $idx;
    my gint $l = $length;
    my gssize ($o, $s) = ($offset, $size);

    gst_buffer_resize_range($!b, $idx, $l, $o, $s);
  }

  method unmap (GstMapInfo() $info) {
    gst_buffer_unmap($!b, $info);
  }

  method unset_flags (GstBufferFlags $flags) is also<unset-flags> {
    my GstBufferFlags $f = $flags;

    gst_buffer_unset_flags($!b, $f);
  }

}



augment class GStreamer::Value {

  method get_buffer (:$raw = False) {
    my $b = cast(GstBuffer, self.boxed);

    $b = GStreamer::Buffer.new($b) unless $raw;
    $b;
  }

  method set_buffer (GstBuffer() $b) {
    self.boxed = $b;
  }

  method new_with_buffer (
    GStreamer::Value:U:
    GstBuffer() $b
  ) {
    my $v = GLib::Value( GStreamer::Buffer.get_type );

    $v.boxed = $b;
    $v;
  }

  multi method new (GstBuffer() $b, :$buffer is required) {
    GStreamer::Value.new_with_buffer($b);
  }

  proto method take_buffer (|)
  { * }

  multi method take_buffer (:$raw = False) {
    my $b = GstBuffer.new;

    samewith($b, :$raw);
  }
  multi method take_buffer ($buffer is rw, :$raw) {
    self.take_boxed($buffer);

    $b = GStreamer::Buffer.new($b) unless $raw;
    $b;
  }

}
