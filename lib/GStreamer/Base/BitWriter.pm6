use v6.c;

use NativeCall;

use GStreamer::Raw::Types;
use GStreamer::Raw::Base::BitWriter;

use GStreamer::Buffer;

class GStreamer::Base::BitWriter {
  has GstBitWriter $!bw;

  submethod BUILD (:$writer) {
    $!bw = $writer;
  }

  method GStreamer::Raw::Sturucts::GstBitWriter
  { $!bw }

  method new {
    my $writer = gst_bit_writer_new();

    return Nil unless $writer;

    GStreamer::Base::BitWriter.init($writer);

    self.bless( :$writer );
  }

  method init (GStreamer::Base::BitWriter:U: $writer) {
    gst_bit_writer_init($writer);
  }

  method new_with_data (
    CArray[guint8] $data,
    Int() $size,
    Int() $initialized
  ) {
    my guint $s = $size;
    my gboolean $i = $initialized.so.Int;
    my $writer = gst_bit_writer_new_with_data($data, $s, $i);

    return Nil unless $writer;

    GStreamer::Base::BitWriter.init_with_data(
      $writer,
      $data,
      $size,
      $initialized
    );
    self.bless( :$writer );
  }

  method init_with_data (
    GStreamer::Base::BitWriter:U:
    GstBitWriter() $writer,
    CArray[guint8] $data,
    Int() $size,
    Int() $initialized
  ) {
    unless $writer && $data {
      warn 'Cannot init without $data or $writer in .init_with_data!';
      return;
    }

    my guint $s = $size;
    my gboolean $i = $initialized.so.Int;

    gst_bit_writer_init_with_data($writer, $data, $s, $i);
  }

  method new_with_size (Int() $size, Int() $fixed) {
    my guint $s = $size;
    my gboolean $f = $fixed.so.Int;

    gst_bit_writer_new_with_size($s, $f);
  }

  method init_with_size (
    GStreamer::Base::BitWriter:U:
    GstBitWriter() $writer,
    Int() $size,
    Int() $fixed
  ) {
    return unless $writer;

    my guint $s = $size;
    my gboolean $f = $fixed.so.Int;

    gst_bit_writer_init_with_size($writer, $size, $fixed);
  }

  method align_bytes (Int() $trailing_bit) {
    die '$trailing_bit MUST be a 0 or 1!' unless $trailing_bit == (0, 1).any;

    my guint $t = $trailing_bit;

    gst_bit_writer_align_bytes($!bw, $t);
  }

  multi method free {
    samewith($!bw);
  }
  multi method free (GStreamer::Base::BitWriter:U: GstBitWriter $writer) {
    gst_bit_writer_free($writer);
  }

  method free_and_get_buffer ($raw = False) {
    my $b = gst_bit_writer_free_and_get_buffer($!bw);

    $b ??
      ( $raw ?? $b !! GStreamer::Buffer.new($b) )
      !!
      Nil;
  }

  method free_and_get_data {
    my $d = gst_bit_writer_free_and_get_data($!bw);

    $d ?? $d !! Nil;
  }

  method get_data {
    my $d = gst_bit_writer_get_data($!bw);

    $d ?? $d !! Nil;
  }

  method get_remaining {
    gst_bit_writer_get_remaining($!bw);
  }

  method get_size {
    gst_bit_writer_get_size($!bw);
  }

  method put_bits_uint16 (Int() $value, Int() $nbits) {
    my guint16 $v = $value;
    my guint $n = $nbits;

    gst_bit_writer_put_bits_uint16($!bw, $value, $nbits);
  }

  method put_bits_uint32 (Int() $value, Int() $nbits) {
    my guint8 $v = $value;
    my guint $n = $nbits;

    gst_bit_writer_put_bits_uint32($!bw, $v, $n);
  }

  method put_bits_uint64 (Int() $value, Int() $nbits) {
    my guint8 $v = $value;
    my guint $n = $nbits;

    gst_bit_writer_put_bits_uint64($!bw, $value, $nbits);
  }

  method put_bits_uint8 (Int() $value, Int() $nbits) {
    my guint8 $v = $value;
    my guint $n = $nbits;

    gst_bit_writer_put_bits_uint8($!bw, $v, $n);
  }

  method put_bytes (CArray[guint8] $data, Int() $nbytes) {
    my guint $n = $nbytes;

    gst_bit_writer_put_bytes($!bw, $data, $n);
  }

  method reset {
    gst_bit_writer_reset($!bw);
  }

  method reset_and_get_buffer (:$raw = False) {
    my $b = gst_bit_writer_reset_and_get_buffer($!bw);

    $b ??
      ( $raw ?? $b !! GStreamer::Buffer.new($b) )
      !!
      Nil;
  }

  method reset_and_get_data {
    my $d = gst_bit_writer_reset_and_get_data($!bw);

    $d ?? $d !! Nil;
  }

  method set_pos (Int() $pos) {
    my guint $p = $pos;

    gst_bit_writer_set_pos($!bw, $p);
  }

}
