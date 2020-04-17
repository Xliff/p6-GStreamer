use v6.c;

use NativeCall;

use GStreamer::Raw::Types;
use GStreamer::Raw::Base::Adapter;

use GLib::Roles::Object;

our subset GstAdapterAncestry is export of Mu
  where GstAdapter | GObject;

class GStreamer::Base::Adapter {
  also does GLib::Roles::Object;

  has GstAdapter $!a;

  submethod BUILD (:$adapter) {
    self.setGstAdapter($adapter);
  }

  method setGstAdapter (GstAdapterAncestry $_) {
    my $to-parent;

    $!a = do  {
      when GstAdapter {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstAdapter, $_);
      }
    }
    self!setObject($to-parent);
  }

  method GStreamer::Raw::Structs::GstAdapter
  { $!a }

  multi method new (GstAdapterAncestry $adapter) {
    $adapter ?? self.bless( :$adapter ) !! Nil;
  }
  multi method new {
    my $adapter = gst_adapter_new();

    $adapter ?? self.bless( :$adapter ) !! Nil;
  }

  method available {
    gst_adapter_available($!a);
  }

  method available_fast {
    gst_adapter_available_fast($!a);
  }

  method clear {
    gst_adapter_clear($!a);
  }

  # Start here.
  multi method copy (Int() $offset, Int() $size) {
    samewith($, $offset, $size);
  }
  multi method copy ($dest is rw, Int() $offset, Int() $size) {
    my gsize ($o, $s) = ($offset, $size);
    my $d = CArray[uint8].allocate($size);

    gst_adapter_copy($!a, $d, $o, $s);
    $dest = $d;
  }

  method copy_bytes (Int() $offset, Int() $size, :$raw = False) {
    my gsize ($o, $s) = ($offset, $size);

    my $b = gst_adapter_copy_bytes($!a, $offset, $size);

    $b ??
      ( $raw ?? $b !! GLib::Bytes.new($b) )
      !!
      Nil;
  }

  method distance_from_discont {
    gst_adapter_distance_from_discont($!a);
  }

  method dts_at_discont {
    gst_adapter_dts_at_discont($!a);
  }

  method flush (gsize $flush) {
    gst_adapter_flush($!a, $flush);
  }

  method get_buffer (Int() $nbytes, :$raw = False) {
    my gsize $n = $nbytes;
    my $b = gst_adapter_get_buffer($!a, $n);

    $b ??
      ( $raw ?? $b !! GStreamer::Buffer.new($b) )
      !!
      Nil;
  }

  method get_buffer_fast (Int() $nbytes, :$raw = False) {
    my gsize $n = $nbytes;
    my $b = gst_adapter_get_buffer_fast($!a, $n);

    $b ??
      ( $raw ?? $b !! GStreamer::Buffer.new($b) )
      !!
      Nil;
  }

  method get_buffer_list (Int() $nbytes, :$raw = False) {
    my gsize $n = $nbytes;
    my $bl = gst_adapter_get_buffer_list($!a, $n);

    $bl ??
      ( $raw ?? $bl !! GStreamer::BufferList.new($bl) )
      !!
      Nil;
  }

  method get_list (Int() $nbytes, :$glist = False, :$raw = False) {
    my gsize $n = $nbytes;
    my $l = gst_adapter_get_list($!a, $n);

    return Nil unless $l;
    return $l if $glist && $raw;

    $l = GLib::GList.new($l) but GLib::Roles::ListData[GstBuffer];
    return $l if $glist;

    $raw ?? $l.Array !! $l.Array.map({ GStreamer::Buffer.new($_) });
  }

  method map (Int() $size) {
    my gsize $s = $size;

    gst_adapter_map($!a, $s);
  }

  method masked_scan_uint32 (
    Int() $mask,
    Int() $pattern,
    Int() $offset,
    Int() $size
  ) {
    my guint32 ($m, $p) = ($mask, $pattern);
    my gsize ($o, $s) = ($offset, $size);

    gst_adapter_masked_scan_uint32($!a, $m, $p, $o, $s);
  }

  proto method masked_scan_uint32_peek (|)
  { * }

  multi method masked_scan_uint32_peek (
    Int() $mask,
    Int() $pattern,
    Int() $offset,
    Int() $size,
  ) {
    samewith($mask, $pattern, $offset, $size, $, :all);
  }
  multi method masked_scan_uint32_peek (
    Int() $mask,
    Int() $pattern,
    Int() $offset,
    Int() $size,
    Int() $value is rw,
    :$all = False
  ) {
    my guint32 ($m, $p, $v) = ($mask, $pattern, 0);
    my gsize ($o, $s) = ($offset, $size);
    my $rv = gst_adapter_masked_scan_uint32_peek($!a, $m, $p, $o, $s, $v);

    $value = $v;
    $all.not ?? $rv !! ($rv, $value);
  }

  method offset_at_discont {
    gst_adapter_offset_at_discont($!a);
  }


  proto method prev_dts (|)
  { * }

  multi method prev_dts {
    samewith($);
  }
  multi method prev_dts ($distance is rw) {
    my guint64 $d = 0;

    gst_adapter_prev_dts($!a, $d);
    $distance = $d;
  }

  proto method prev_dts_at_offset (|)
  { * }

  multi method prev_dts_at_offset (Int() $offset) {
    samewith($offset, $, :all);
  }
  multi method prev_dts_at_offset (
    Int() $offset,
    $distance is rw,
    :$all = False
  ) {
    my gsize $o = $offset;
    my guint64 $d = 0;

    my $rv = gst_adapter_prev_dts_at_offset($!a, $o, $d);
    $distance = $d;
    $all.not ?? $rv !! ($rv, $distance);
  }

  proto method prev_offset (|)
  { * }

  multi method prev_offset {
    samewith($, :all);
  }
  multi method prev_offset (Int() $distance is rw, :$all = False) {
    my guint64 $d = 0;
    my $rv = gst_adapter_prev_offset($!a, $d);

    $distance = $d;
    $all.not ?? $rv !! ($rv, $distance);
  }

  proto method prev_pts (|)
  { * }

  multi method prev_pts {
    samewith($, :all);
  }
  multi method prev_pts ($distance is rw, :$all = False) {
    my guint64 $d = 0;
    my $rv = gst_adapter_prev_pts($!a, $d);

    $distance = $d;
    $all.not ?? $rv !! ($rv, $distance);
  }

  proto method prev_pts_at_offset (|)
  { * }

  multi method prev_pts_at_offset (Int() $offset) {
    samewith($offset, $, :all);
  }
  multi method prev_pts_at_offset (
    Int() $offset,
    Int() $distance is rw,
    :$all = False
  ) {
    my gsize $o = $offset;
    my guint64 $d = 0;
    my $rv = gst_adapter_prev_pts_at_offset($!a, $o, $d);

    $distance = $d;
    $all.not ?? $rv !! ($rv, $distance);
  }

  method pts_at_discont {
    gst_adapter_pts_at_discont($!a);
  }

  method push (GstBuffer() $buf) {
    gst_adapter_push($!a, $buf);
  }

  method take (Int() $nbytes) {
    my gsize $n = $nbytes;

    gst_adapter_take($!a, $n);
  }

  method take_buffer (Int() $nbytes, :$raw = False) {
    my gsize $n = $nbytes;
    my $b = gst_adapter_take_buffer($!a, $n);

    $b ??
      ( $raw ?? $b !! GStreamer::Buffer.new($b) )
      !!
      Nil;
  }

  method take_buffer_fast (Int() $nbytes, :$raw = False) {
    my gsize $n = $nbytes;
    my $b = gst_adapter_take_buffer_fast($!a, $n);

    $b ??
      ( $raw ?? $b !! GStreamer::Buffer.new($b) )
      !!
      Nil;
  }

  method take_buffer_list (Int() $nbytes, :$raw = False) {
    my gsize $n = $nbytes;
    my $bl = gst_adapter_take_buffer_list($!a, $nbytes);

    $bl ??
      ( $raw ?? $bl !! GStreamer::BufferList.new($bl) )
      !!
      Nil;
  }

  method take_list (Int() $nbytes, :$glist = False, :$raw = False;) {
    my $l = gst_adapter_take_list($!a, $nbytes);

    return Nil unless $l;
    return $l if $glist && $raw;

    $l = GLib::GList.new($l) but GLib::Roles::ListData[GstBuffer];
    return $l if $glist;

    $raw ?? $l.Array !! $l.Array.map({ GStreamer::Buffer.new($_) });
  }

  method unmap {
    gst_adapter_unmap($!a);
  }

}
