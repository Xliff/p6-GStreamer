use v6.c;

use NativeCall;

use GStreamer::Raw::Types;
use GStreamer::Raw::Base::ByteReader;

class GStreamer::Base::ByteReader {
  has GstByteReader $!br handles <data size byte>;

  submethod BUILD (:$byte-reader) {
    $!br = $byte-reader;
  }

  method GStreamer::Raw::Structs::GstByteReader
  { $!br }

  multi method new (@data) {
    samewith( ArrayToCArray(guint8, @data), @data.elems );
  }
  multi method new (CArray[guint8] $data, Int() $size) {
    my guint $s = $size;
    my $byte-reader = gst_byte_reader_new($data, $s);

    $byte-reader ?? self.bless( :$byte-reader ) !! Nil;
  }

  proto method dup_data (Int() $size)
  { * }

  multi method dup_data (Int() $size) {
    my $rv = samewith($size, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method dup_data (Int() $size, $val is rw, :$all = False) {
    my guint $s = $size;
    my $va = CArray[CArray[guint8]].new;
    $va[0] = CArray[guint8];

    my $rv = gst_byte_reader_dup_data($!br, $s, $va);
    $val = $va;
    $all.not ?? $rv !! ($rv, $val);
  }


  proto method dup_string_utf16 (|)
  { * }

  multi method dup_string_utf16 {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method dup_string_utf16 ($str is rw, :$all = False) {
    my $sa = CArray[CArray[guint16]].new;
    $sa[0] = CArray[guint16];

    my $rv = so gst_byte_reader_dup_string_utf16($!br, $sa);

    # XXX - For these values that are transfer-full, they should all
    # be punned with a role that calls the appropriate free method in DESTROY
    #
    # Ala:
    #
    # role Disposal[F] { submethod DESTROY { F() }; }
    #
    # Which will call the subroutine specified by F when GC'd, and the below
    # would read:
    #
    # $str = $sa but Disposal[&g_free] # ...instead
    $str = $sa;
    $all.not ?? $rv !! ($rv, $str);
  }


  proto method dup_string_utf32 (|)
  { * }

  multi method dup_string_utf32 {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method dup_string_utf32 ($str is rw, :$all = False) {
    my $sa = CArray[CArray[guint32]].new;
    $sa[0] = CArray[guint32];

    my $rv = so gst_byte_reader_dup_string_utf32($!br, $sa);
    $str = $sa;
    $all.not ?? $rv !! ($rv, $str);
  }

  proto method dup_str_utf8 (|)
  { * }

  multi method dup_str_utf8 {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method dup_string_utf8 ($str is rw, :$all = False) {
    my $sa = CArray[CArray[guint8]].new;
    $sa[0] = CArray[guint8];

    my $rv = so gst_byte_reader_dup_string_utf8($!br, $str);
    $str = $sa;
    $all.not ?? $rv !! ($rv, $str);
  }

  method free {
    gst_byte_reader_free($!br);
  }

  proto method get_data (|)
  { * }

  multi method get_data (Int() $size) {
    my $rv = samewith($size, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_data (Int() $size, $val is rw, :$all = False) {
    my guint $s = $size;
    my $va = CArray[CArray[guint8]].new;
    $va[0] = CArray[guint8];

    my $rv = so gst_byte_reader_get_data($!br, $size, $va);
    $val = $va;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method get_float32_be (|)
  { * }

  multi method get_float32_be {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_float32_be ($val is rw, :$all = False) {
    my gfloat $v = 0e0;
    my $rv = so gst_byte_reader_get_float32_be($!br, $val);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method get_float32_le (|)
  { * }

  multi method get_float32_le {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_float32_le ($val is rw, :$all = False) {
    my gfloat $v = 0e0;
    my $rv = so gst_byte_reader_get_float32_le($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method get_float64_be (|)
  { * }

  multi method get_float64_be {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_float64_be ($val is rw, :$all = False) {
    my gdouble $v = 0e0;
    my $rv = so gst_byte_reader_get_float64_be($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method get_float64_le (|)
  { * }

  multi method get_float64_le {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_float64_le ($val is rw, :$all = False) {
    my gdouble $v = 0e0;
    my $rv = so gst_byte_reader_get_float64_le($!br, $val);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method get_int16_be (|)
  { * }

  multi method get_int16_be {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_int16_be ($val is rw, :$all = False) {
    my gint16 $v = 0;
    my $rv = so gst_byte_reader_get_int16_be($!br, $val);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method get_int16_le (|)
  { * }

  multi method get_int16_le {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_int16_le ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_get_int16_le($!br, $val);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method get_int24_be (|)
  { * }

  multi method get_int24_be {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_int24_be ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_get_int24_be($!br, $val);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method get_int24_le (|)
  { * }

  multi method get_int24_le {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_int24_le ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_get_int24_le($!br, $val);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method get_int32_be (|)
  { * }

  multi method get_int32_be {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_int32_be ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_get_int32_be($!br, $val);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method get_int32_le (|)
  { * }

  multi method get_int32_le {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_int32_le ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_get_int32_le($!br, $val);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method get_int64_be (|)
  { * }

  multi method get_int64_be {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_int64_be ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_get_int64_be($!br, $val);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method get_int64_le (|)
  { * }

  multi method get_int64_le {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_int64_le ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_get_int64_le($!br, $val);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method get_int8 (|)
  { * }

  multi method get_int8 {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_int8 ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_get_int8($!br, $val);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  method get_pos {
    gst_byte_reader_get_pos($!br);
  }

  method get_remaining {
    gst_byte_reader_get_remaining($!br);
  }

  method get_size {
    gst_byte_reader_get_size($!br);
  }

  proto method get_string_utf8 (|)
  { * }

  multi method get_string_utf8 {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_string_utf8 ($str is rw, :$all = False) {
    my $sa = CArray[Str].new;
    $sa[0] = Str;

    my $rv = so gst_byte_reader_get_string_utf8($!br, $sa);
    $str = $sa[0] ?? $sa[0] !! Nil;
    $all.not ?? $rv !! ($rv, $str);
  }

  proto method get_sub_reader (|)
  { * }

  multi method get_sub_reader (Int() $size, :$raw = False) {
    my $sr = GstByteReader.new;
    my $rv = samewith($sr, $size);

    return Nil unless $rv;

    $sr = GStreamer::ByteReader.new($sr) unless $raw;
    $sr;
  }
  multi method get_sub_reader (
    GstByteReader() $sub_reader,
    Int() $size,
  ) {
    my guint $s = $size;

    so gst_byte_reader_get_sub_reader($!br, $sub_reader, $s);
  }

  proto method get_uint16_be (|)
  { * }

  multi method get_uint16_be {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_uint16_be ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_get_uint16_be($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method get_uint16_le (|)
  { * }

  multi method get_uint16_le {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_uint16_le ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_get_uint16_le($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method get_uint24_be (|)
  { * }

  multi method get_uint24_be {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_uint24_be ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_get_uint24_be($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method get_uint24_le (|)
  { * }

  multi method get_uint24_le {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_uint24_le ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_get_uint24_le($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method get_uint32_be (|)
  { * }

  multi method get_uint32_be {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_uint32_be ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_get_uint32_be($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method get_uint32_le (|)
  { * }

  multi method get_uint32_le {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_uint32_le ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_get_uint32_le($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method get_uint64_be (|)
  { * }

  multi method get_uint64_be {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_uint64_be ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_get_uint64_be($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method get_uint64_le (|)
  { * }

  multi method get_uint64_le {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_uint64_le ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_get_uint64_le($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method get_uint8 (|)
  { * }

  multi method get_uint8 {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_uint8 ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_get_uint8($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  multi method init (@data) {
    samewith( ArrayToCArray(guint8, @data), @data.elems );
  }
  multi method init (CArray[guint8] $data, Int() $size) {
    GStreamer::Base::ByteReader($!br, $data, $size);
  }
  multi method init (
    GStreamer::Base::ByteReader:U:
    CArray[guint8] $data,
    Int() $size
  ) {
    my guint $s = $size;

    gst_byte_reader_init($!br, $data, $s);
  }

  method masked_scan_uint32 (
    Int() $mask,
    Int() $pattern,
    Int() $offset,
    Int() $size
  ) {
    my guint32 ($m, $p) = ($mask, $pattern);
    my guint ($o, $s) = ($offset, $size);

    gst_byte_reader_masked_scan_uint32($!br, $m, $p, $o, $s);
  }

  method masked_scan_uint32_peek (
    Int() $mask,
    Int() $pattern,
    Int() $offset,
    Int() $size,
    $value is rw
  ) {
    my guint32 $v = 0;
    my guint32 ($m, $p) = ($mask, $pattern);
    my guint ($o, $s) = ($offset, $size);
    my &sup := &gst_byte_reader_masked_scan_uint32_peek;
    my $mo = &sup($!br, $m, $p, $o, $s, $v);

    $value = $v;
    ($mo, $value);
  }


  proto method peek_data (|)
  { * }

  multi method peek_data (Int() $size) {
    my $rv = samewith($size, $);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method peek_data (Int() $size, $val is rw, :$all = False) {
    my guint $s = $size;
    my $v = CArray[CArray[guint8]].new;
    $v[0] = CArray[guint8];

    my $rv = so gst_byte_reader_peek_data($!br, $size, $v);
    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method peek_float32_be (|)
  { * }

  multi method peek_float32_be {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method peek_float32_be ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_peek_float32_be($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method peek_float32_le (|)
  { * }

  multi method peek_float32_le {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method peek_float32_le ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_peek_float32_le($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method peek_float64_be (|)
  { * }

  multi method peek_float64_be {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method peek_float64_be ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_peek_float64_be($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method peek_float64_le (|)
  { * }

  multi method peek_float64_le {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method peek_float64_le ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_peek_float64_le($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method peek_int16_be (|)
  { * }

  multi method peek_int16_be {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method peek_int16_be ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_peek_int16_be($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method peek_int16_le (|)
  { * }

  multi method peek_int16_le {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method peek_int16_le ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_peek_int16_le($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }


  proto method peek_int24_be (|)
  { * }

  multi method peek_int24_be {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method peek_int24_be ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_peek_int24_be($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }


  proto method peek_int24_le (|)
  { * }

  multi method peek_int24_le {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method peek_int24_le ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_peek_int24_le($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }


  proto method peek_int32_be (|)
  { * }

  multi method peek_int32_be {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method peek_int32_be ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_peek_int32_be($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }


  proto method peek_int32_le (|)
  { * }

  multi method peek_int32_le {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method peek_int32_le ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_peek_int32_le($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }


  proto method peek_int64_be (|)
  { * }

  multi method peek_int64_be {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method peek_int64_be ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_peek_int64_be($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }


  proto method peek_int64_le (|)
  { * }

  multi method peek_int64_le {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method peek_int64_le ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_peek_int64_le($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }


  proto method peek_int8 (|)
  { * }

  multi method peek_int8 {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method peek_int8 ($val is rw, :$all = False) {
    my $v = 0;
    my $rv = so gst_byte_reader_peek_int8($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }


  proto method peek_string_utf8 (|)
  { * }

  multi method peek_string_utf8 {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method peek_string_utf8 ($str is rw, :$all = False) {
    my $sa = CArray[Str].new;
    $sa[0] = Str;

    my $rv = so gst_byte_reader_peek_string_utf8($!br, $sa);
    $str = $sa[0] ?? $sa[0] !! Nil;
    $all.not ?? $rv  !! ($rv, $str);
  }

  proto method peek_sub_reader (|)
  { * }

  multi method peek_sub_reader (Int() $size, :$raw = False) {
    my $sr = GstByteReader.new;
    my $rv = samewith($sr, $size);

    return Nil unless $rv;

    $sr = GStreamer::ByteReader.new($sr) unless $raw;
    $sr;
  }
  multi method peek_sub_reader (GstByteReader() $sub_reader, Int() $size) {
    my guint $s = $size;

    gst_byte_reader_peek_sub_reader($!br, $sub_reader, $s);
  }

  proto method peek_uint16_be (|)
  { * }

  multi method peek_uint16_be {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method peek_uint16_be ($val is rw, :$all = False) {
    my guint16 $v = 0;
    my $rv = so gst_byte_reader_peek_uint16_be($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method peek_uint16_le (|)
  { * }

  multi method peek_uint16_le {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method peek_uint16_le ($val is rw, :$all = False) {
    my guint16 $v = 0;
    my $rv = so gst_byte_reader_peek_uint16_le($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method peek_uint24_be (|)
  { * }

  multi method peek_uint24_be {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method peek_uint24_be ($val is rw, :$all = False) {
    my guint32 $v = 0;
    my $rv = so gst_byte_reader_peek_uint24_be($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method peek_uint24_le (|)
  { * }

  multi method peek_uint24_le {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method peek_uint24_le ($val is rw, :$all = False) {
    my guint32 $v = 0;
    my $rv = so gst_byte_reader_peek_uint24_le($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method peek_uint32_be (|)
  { * }

  multi method peek_uint32_be {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method peek_uint32_be ($val is rw, :$all = False) {
    my guint32 $v = 0;
    my $rv = so gst_byte_reader_peek_uint32_be($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method peek_uint32_le (|)
  { * }

  multi method peek_uint32_le {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method peek_uint32_le ($val is rw, :$all = False) {
    my guint32 $v = 0;
    my $rv = so gst_byte_reader_peek_uint32_le($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method peek_uint64_be (|)
  { * }

  multi method peek_uint64_be {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method peek_uint64_be ($val is rw, :$all = False) {
    my guint64 $v = 0;
    my $rv = so gst_byte_reader_peek_uint64_be($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method peek_uint64_le (|)
  { * }

  multi method peek_uint64_le {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method peek_uint64_le ($val is rw, :$all = False) {
    my guint64 $v = 0;
    my $rv = so gst_byte_reader_peek_uint64_le($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method peek_uint8 (|)
  { * }

  multi method peek_uint8 {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method peek_uint8 ($val is rw, :$all = False) {
    my guint8 $v = 0;
    my $rv = so gst_byte_reader_peek_uint8($!br, $v);

    $val = $v;
    $all.not ?? $rv !! ($rv, $val);
  }

  method set_pos (Int() $pos) {
    my guint $p =  $pos;

    so gst_byte_reader_set_pos($!br, $p);
  }

  method skip (Int() $nbytes) {
    my guint $n = $nbytes;

    so gst_byte_reader_skip($!br, $n);
  }

  method skip_string_utf16 {
    so gst_byte_reader_skip_string_utf16($!br);
  }

  method skip_string_utf32 {
    so gst_byte_reader_skip_string_utf32($!br);
  }

  method skip_string_utf8 {
    so gst_byte_reader_skip_string_utf8($!br);
  }

}
