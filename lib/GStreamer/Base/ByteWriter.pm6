use v6.c;

use NativeCall;

use GStreamer::Raw::Types;
use GStreamer::Raw::Base::ByteWriter;

use GStreamer::Buffer;
use GStreamer::Base::ByteReader;

our subset GstByteWriterAncestry is export of Mu
  where GstByteWriter | GstByteReader;

class GStreamer::Base::ByteWriter is GStreamer::Base::ByteReader {
  has GstByteWriter $!bw handles <alloc_size fixed owned>;

  submethod BUILD (:$byte-writer) {
    self.setGstByteWriter($byte-writer);
  }

  method setGstByteWriter (GstByteWriterAncestry $_) {
    my $to-parent;

    $!bw = do {
      when GstByteWriter {
        $to-parent = cast(GstByteReader, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstByteWriter, $_);
      }
    }

    self.setGstByreReader($to-parent);
  }

  method GStreamer::Raw::Structs::GstByteWriter
  #  is also<GstByteWriter>
  { $!bw }

  multi method new (GstByteWriter :$byte-writer) {
    $byte-writer ?? self.bless( :$byte-writer ) !! Nil;
  }
  multi method new {
    my $byte-writer = gst_byte_writer_new();

    $byte-writer ?? self.bless( :$byte-writer ) !! Nil;
  }

  proto method new_with_data (|)
  { * }

  multi method new (Buf() $d, Int() $initialized, :$data is required) {
    self.new_with_data($d, $initialized);
  }
  multi method new_with_data (Buf() $data, Int() $initialized) {
    samewith( cast(Pointer, $data), $initialized );
  }
  multi method new_with_data (
    CArray[uint8] $data,
    Int() $size,
    Int() $initialized
  ) {
    samewith( cast(Pointer, $data), $size, $initialized );
  }
  multi method new_with_data (Pointer $data, Int() $size, Int() $initialized) {
    my guint $s = $size;
    my gboolean $i = $initialized.so.Int;
    my $byte-writer = gst_byte_writer_new_with_data($data, $s, $i);

    $byte-writer ?? self.bless( :$byte-writer ) !! Nil;
  }

  method new_with_size (Int() $size, Int() $fixed) {
    my guint $s = $size;
    my gboolean $f = $fixed.so.Int;
    my $byte-writer = gst_byte_writer_new_with_size($s, $f);

    $byte-writer ?? self.bless( :$byte-writer ) !! Nil;
  }

  method ensure_free_space (Int() $size) {
    my guint $s = $size;

    gst_byte_writer_ensure_free_space($!bw, $size);
  }

  method fill (Int() $value, Int() $size) {
    my guint $s = $size;
    my guint8 $v = $value;

    so gst_byte_writer_fill($!bw, $v, $size);
  }

  multi method free {
    GStreamer::Base::ByteWriter.free($!bw);
  }
  multi method free (GStreamer::Base::ByteWriter:U: GstByteWriter $w) {
    gst_byte_writer_free($w);
  }

  proto method free_and_get_buffer (|)
  { * }

  multi method free_and_get_buffer (:$raw = False) {
    GStreamer::Base::ByteWriter.free_and_get_buffer($!bw, :$raw);
  }
  multi method free_and_get_buffer (
    GStreamer::Base::ByteWriter:U:
    GstByteWriter $w,
    :$raw = False
  ) {
    my $b = gst_byte_writer_free_and_get_buffer($w);

    $b ??
      ( $raw ?? $b !! GStreamer::Buffer.new($b) )
      !!
      Nil;
  }

  proto method free_and_get_data (|)
  { * }

  multi method free_and_get_data {
    GStreamer::Base::ByteWriter.free_and_get_data($!bw);
  }
  multi method free_and_get_data (
    GStreamer::Base::ByteWriter:U:
    GstByteWriter $w
  ) {
    gst_byte_writer_free_and_get_data($w);
  }

  method get_remaining {
    gst_byte_writer_get_remaining($!bw);
  }

  multi method init {
    GStreamer::Base::ByteWriter.init($!bw);
  }
  multi method init (GStreamer::Base::ByteWriter:U: GstByteWriter $w) {
    gst_byte_writer_init($w);
  }

  proto method init_with_data (|)
  { * }

  multi method init_with_data (Buf() $data, Int() $initialized) {
    samewith( cast($data, Pointer), $data.bytes, $initialized );
  }
  multi method init_with_data (
    CArray[uint8] $data,
    Int() $size,
    Int() $initialized
  ) {
    samewith( cast($data, Pointer), $size, $initialized );
  }
  multi method init_with_data (
    Pointer $data,
    Int() $size,
    Int() $initialized
  ) {
    GStreamer::Base::ByteWriter.init_with_data(
      $!bw,
      $data,
      $size,
      $initialized
    );
  }
  multi method init_with_data (
    GStreamer::Base::ByteWriter:U:
    GstByteWriter $w,
    Pointer $data,
    Int() $size,
    Int() $initialized
  ) {
    my guint $s = $size;
    my gboolean $i = $initialized.so.Int;

    gst_byte_writer_init_with_data($w, $data, $s, $i);
  }

  proto method init_with_size (|)
  { * }

  multi method init_with_size (Int() $size, Int() $fixed) {
    GStreamer::Base::ByteWriter.init_with_size($!bw, $size, $fixed);
  }
  multi method init_with_size (
    GStreamer::Base::ByteWriter:U:
    GstByteWriter $w,
    Int() $size,
    Int() $fixed
  ) {
    my guint $s = $size;
    my gboolean $f = $fixed.so.Int;

    gst_byte_writer_init_with_size($w, $size, $fixed);
  }

  method put_buffer (
    GstBuffer() $buffer,
    Int() $offset,
    Int() $size = -1
  ) {
    my gssize $s = $size;
    my gsize $o = $offset;

    so gst_byte_writer_put_buffer($!bw, $buffer, $offset, $size);
  }

  proto method put_data (|)
  { * }

  multi method put_data (Buf() $data) {
    samewith( cast(Pointer, $data), $data.bytes );
  }
  multi method put_data (CArray[guint8] $data, Int() $size) {
    samewith( cast(Pointer, $data), $size );
  }
  multi method put_data (Pointer $data, Int() $size) {
    my guint $s = $size;

    gst_byte_writer_put_data($!bw, $data, $s);
  }

  method put_float (
    $bits,
    Num() $val,
    :little-endian(:little_endian(:$le)) is copy,
    :big-endian(:big_endian(:$be))       is copy
  ) {
    die '$bits must be either 32 or 64!' unless $bits == (32, 64).any;

    ($be, $le) = getEndian unless $le || $be;

    if ($bits == 32) {
      return self.put_float32_be($val) if $be;
      return self.put_float32_le($val) if $le;
    } else {
      return self.put_float64_be($val) if $be;
      return self.put_float64_le($val) if $le;
    }
  }

  method put_float32_be (Num() $val) {
    my gfloat $v = $val;

    so gst_byte_writer_put_float32_be($!bw, $v);
  }

  method put_float32_le (Num() $val) {
    my gfloat $v = $val;

    so gst_byte_writer_put_float32_le($!bw, $v);
  }

  method put_float64_be (Num() $val) {
    my gdouble $v = $val;

    so gst_byte_writer_put_float64_be($!bw, $v);
  }

  method put_float64_le (Num() $val) {
    my gdouble $v = $val;

    so gst_byte_writer_put_float64_le($!bw, $v);
  }

  method get_int (
    $bits,
    Int() $val,
    :little-endian(:little_endian(:$le)) is copy,
    :big-endian(:big_endian(:$be))       is copy
  ) {
    die '$bits must be either 32 or 64!' unless $bits == (8, 16, 24, 32, 64).any;

    ($be, $le) = getEndian unless $le || $be;

    do given $bits {
      when 8  { return self.put_int8($val) }
      when 16 { return self.put_int16_be($val) if $be;
                return self.put_int16_le($val) if $le; }
      when 24 { return self.put_int24_be($val) if $be;
                return self.put_int24_le($val) if $le; }
      when 32 { return self.put_int32_be($val) if $be;
                return self.put_int32_le($val) if $le; }
      when 64 { return self.put_int64_be($val) if $be;
                return self.put_int64_le($val) if $le; }
    }
  }

  method put_int16_be (Int() $val) {
    my gint16 $v = $val;

    so gst_byte_writer_put_int16_be($!bw, $v);
  }

  method put_int16_le (Int() $val) {
    my gint16 $v = $val;

    so gst_byte_writer_put_int16_le($!bw, $v);
  }

  method put_int24_be (Int() $val) {
    my gint32 $v = $val;

    so gst_byte_writer_put_int24_be($!bw, $v);
  }

  method put_int24_le (Int() $val) {
    my gint32 $v = $val;

    so gst_byte_writer_put_int24_le($!bw, $v);
  }

  method put_int32_be (Int() $val) {
    my gint32 $v = $val;

    so gst_byte_writer_put_int32_be($!bw, $v);
  }

  method put_int32_le (Int() $val) {
    my gint32 $v = $val;

    so gst_byte_writer_put_int32_le($!bw, $v);
  }

  method put_int64_be (Int() $val) {
    my gint64 $v = $val;

    so gst_byte_writer_put_int64_be($!bw, $v);
  }

  method put_int64_le (Int() $val) {
    my gint64 $v = $val;

    so gst_byte_writer_put_int64_le($!bw, $v);
  }

  method put_int8 (Int() $val) {
    my guint8 $v = $val;

    gst_byte_writer_put_int8($!bw, $v);
  }

  proto method put_string_utf16 (|)
  { * }

  multi method put_string_utf16 (Buf() $data, :$buf is required) {
    samewith( cast(Pointer, $data), :pointer );
  }
  multi method put_string_utf16 (Str() $data, :string(:$str) is required) {
    samewith( cast( Pointer, $data.encode('utf16') ), :pointer );
  }
  multi method put_string_utf16 (CArray[guint16] $data) {
    samewith( cast(Pointer, $data), :pointer );
  }
  multi method put_string_utf16 (Pointer $data, :$pointer is required) {
    gst_byte_writer_put_string_utf16($!bw, $data);
  }

  proto method put_string_utf32 (|)
  { * }

  multi method put_string_utf32 (Buf() $data, :$buf is required) {
    samewith( cast(Pointer, $data), :pointer );
  }
  multi method put_string_utf32 (Str() $data) {
    samewith( cast( Pointer, $data.encode('utf16') ), :pointer );
  }
  multi method put_string_utf32 (CArray[guint32] $data) {
    samewith( cast(Pointer, $data), :pointer );
  }
  multi method put_string_utf32 (Pointer $data, :$pointer is required) {
    gst_byte_writer_put_string_utf32($!bw, $data);
  }

  proto method put_string_utf8 (|)
  { * }

  multi method put_string_utf8 (Buf() $data, :$buf is required) {
    samewith( cast(Pointer, $data), :pointer );
  }
  multi method put_string_utf8 (Str() $data) {
    samewith( cast( Pointer, $data.encode('utf8') ), :pointer );
  }
  multi method put_string_utf8 (CArray[guint8] $data) {
    samewith( cast(Pointer, $data), :pointer );
  }
  multi method put_string_utf8 (Pointer $data, :$pointer is required) {
    gst_byte_writer_put_string_utf8($!bw, $data);
  }

  method put_uint (
    $bits,
    Int() $val,
    :little-endian(:little_endian(:$le)) is copy,
    :big-endian(:big_endian(:$be))       is copy
  ) {
    die '$bits must be either 32 or 64!' unless $bits == (8, 16, 24, 32, 64).any;

    ($be, $le) = getEndian unless $le || $be;

    do given $bits {
      when 8  { return self.put_uint8($val) }
      when 16 { return self.put_uint16_be($val) if $be;
                return self.put_uint16_le($val) if $le; }
      when 24 { return self.put_uint24_be($val) if $be;
                return self.put_uint24_le($val) if $le; }
      when 32 { return self.put_uint32_be($val) if $be;
                return self.put_uint32_le($val) if $le; }
      when 64 { return self.put_uint64_be($val) if $be;
                return self.put_uint64_le($val) if $le; }
    }
  }

  method put_uint16_be (Num() $val) {
    my guint16 $v = $val;

    so gst_byte_writer_put_uint16_be($!bw, $v);
  }

  method put_uint16_le (Int() $val) {
    my guint16 $v = $val;

    so gst_byte_writer_put_uint16_le($!bw, $v);
  }

  method put_uint24_be (Int() $val) {
    my guint32 $v = $val;

    so gst_byte_writer_put_uint24_be($!bw, $v);
  }

  method put_uint24_le (Int() $val) {
    my guint32 $v = $val;

    so gst_byte_writer_put_uint24_le($!bw, $v);
  }

  method put_uint32_be (Int() $val) {
    my guint32 $v = $val;

    so gst_byte_writer_put_uint32_be($!bw, $v);
  }

  method put_uint32_le (Int() $val) {
    my guint32 $v = $val;

    so gst_byte_writer_put_uint32_le($!bw, $v);
  }

  method put_uint64_be (Int() $val) {
    my guint64 $v = $val;

    so gst_byte_writer_put_uint64_be($!bw, $v);
  }

  method put_uint64_le (Int() $val) {
    my guint64 $v = $val;

    so gst_byte_writer_put_uint64_le($!bw, $v);
  }

  method put_uint8 (Int() $val) {
    my guint8 $v = $val;

    gst_byte_writer_put_uint8($!bw, $v);
  }

  method reset {
    gst_byte_writer_reset($!bw);
  }

  method reset_and_get_buffer (:$raw = False) {
    my $b = gst_byte_writer_reset_and_get_buffer($!bw);

    $b ??
      ( $raw ?? $b !! GStreamer::Buffer.new($b) )
      !!
      Nil;
  }

  method reset_and_get_data {
    gst_byte_writer_reset_and_get_data($!bw);
  }

}
