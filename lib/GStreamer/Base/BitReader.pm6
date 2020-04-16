use v6.c;

use NativeCall;

use GStreamer::Raw::Types;
use GStreamer::Raw::Base::BitReader;

class GStreamer::Base::BitReader {
  has GstBitReader $!br handles <data size byte bit>;

  submethod BUILD (:$reader) {
    $!br = $reader;
  }

  method GStreamer::Raw::Structs::GstBitReader
  { $!br }

  method new (CArray[guint8] $data, Int() $size) {
    my guint $s = $size;
    my $reader = gst_bit_reader_new($data, $s);

    return Nil unless $reader;

    my $o = self.bless( :$reader );
    $o.init($data, $s);
    $o;
  }

  method init (CArray[guint8] $data, Int() $size) {
    my guint $s = $size;

    gst_bit_reader_init($!br, $data, $s);
  }

  multi method free {
    GStreamer::Base::BitReader.free($!br);
  }
  multi method free (GStreamer::Base::BitReader:U: $reader) {
    gst_bit_reader_free($reader);
  }

  proto method get_bits_uint16 (|)
  { * }

  multi  method get_bits_uint16 (Int() $nbits) {
    my $rv = samewith($, $nbits, :all);

    $rv[0] ?? $rv[0] !! Nil;
  }
  multi method get_bits_uint16 ($val is rw, Int() $nbits, :$all = False) {
    my guint $n = $nbits;

    $val = CArray[uint16].allocate($n / 16);

    my $rv = gst_bit_reader_get_bits_uint16($!br, $val, $n);
    $all.not ?? $rv !! ($rv, $val);
  }


  proto method get_bits_uint32 (|)
  { * }

  multi  method get_bits_uint32 (Int() $nbits) {
    my $rv = samewith($, $nbits, :all);

    $rv[0] ?? $rv[0] !! Nil;
  }
  multi method get_bits_uint32 ($val is rw, Int() $nbits, :$all = False) {
    my guint $n = $nbits;

    $val = CArray[uint32].allocate($n / 32);

    my $rv = gst_bit_reader_get_bits_uint32($!br, $val, $n);
    $all.not ?? $rv !! ($rv, $val);
  }


  proto method get_bits_uint64 (|)
  { * }

  multi  method get_bits_uint64 (Int() $nbits) {
    my $rv = samewith($, $nbits, :all);

    $rv[0] ?? $rv[0] !! Nil;
  }
  multi method get_bits_uint64 ($val is rw, Int() $nbits, :$all = False) {
    my guint $n = $nbits;

    $val = CArray[uint64].allocate($n / 64);

    my $rv = gst_bit_reader_get_bits_uint16($!br, $val, $n);
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method get_bits_uint8 (|)
  { * }

  multi  method get_bits_uint8 (Int() $nbits) {
    my $rv = samewith($, $nbits, :all);

    $rv[0] ?? $rv[0] !! Nil;
  }
  multi method get_bits_uint8 ($val is rw, Int() $nbits, :$all = False) {
    my guint $n = $nbits;

    $val = CArray[uint8].allocate($n / 8);

    my $rv = gst_bit_reader_get_bits_uint16($!br, $val, $n);
    $all.not ?? $rv !! ($rv, $val);
  }

  method get_pos {
    gst_bit_reader_get_pos($!br);
  }

  method get_remaining {
    gst_bit_reader_get_remaining($!br);
  }

  method get_size {
    gst_bit_reader_get_size($!br);
  }

  proto method peek_bits_uint16 (Int() $nbits)
  { * }

  multi method peek_bits_uint16 (Int() $nbits) {
    my $rv = samewith($, $nbits, :all);

    $rv[0] ?? $rv[0] !! Nil;
  }
  multi method peek_bits_uint16 ($val is rw, Int() $nbits, :$all = False) {
    my guint $n = $nbits;

    $val = CArray[uint16].allocate($n / 16);

    my $rv = gst_bit_reader_peek_bits_uint16($!br, $val, $n);
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method peek_bits_uint32 (Int() $nbits)
  { * }

  multi method peek_bits_uint32 (Int() $nbits) {
    my $rv = samewith($, $nbits, :all);

    $rv[0] ?? $rv[0] !! Nil;
  }
  multi method peek_bits_uint32 ($val is rw, Int() $nbits, :$all = False) {
    my guint $n = $nbits;

    $val = CArray[uint32].allocate($n / 32);

    my $rv = gst_bit_reader_peek_bits_uint32($!br, $val, $n);
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method peek_bits_uint64 (Int() $nbits)
  { * }

  multi method peek_bits_uint64 (Int() $nbits) {
    my $rv = samewith($, $nbits, :all);

    $rv[0] ?? $rv[0] !! Nil;
  }
  multi method peek_bits_uint64 ($val is rw, Int() $nbits, :$all = False) {
    my guint $n = $nbits;

    $val = CArray[uint64].allocate($n / 64);

    my $rv = gst_bit_reader_peek_bits_uint64($!br, $val, $n);
    $all.not ?? $rv !! ($rv, $val);
  }

  proto method peek_bits_uint8 (Int() $nbits)
  { * }

  multi method peek_bits_uint8 (Int() $nbits) {
    my $rv = samewith($, $nbits, :all);

    $rv[0] ?? $rv[0] !! Nil;
  }
  multi method peek_bits_uint8 ($val is rw, Int() $nbits, :$all = False) {
    my guint $n = $nbits;

    $val = CArray[uint8].allocate($n / 8);

    my $rv = gst_bit_reader_peek_bits_uint8($!br, $val, $n);
    $all.not ?? $rv !! ($rv, $val);
  }

  method set_pos (Int() $pos) {
    my guint $p = $pos;

    gst_bit_reader_set_pos($!br, $p);
  }

  method skip (Int() $nbits) {
    my guint $n = $nbits;

    gst_bit_reader_skip($!br, $n);
  }

  method skip_unchecked (Int() $nbits) {
    my guint $n = $nbits;

    $!br.bit += $n;
    $!br.byte += $!br.bit / 8;
    $!br.bit = $!br.bit % 8;
  }

  method skip_to_byte {
    gst_bit_reader_skip_to_byte($!br);
  }

  method skip_to_byte_unchecked {
    return unless $!br.bit;
    $!br.bit = 0;
    $!br.byte++;
  }

  # NYI
  #
  # gst_bit_reader_peek_bits_uint*_unchecked
  #   AND
  # gst_bit_reader_git_bits_uint*_unchecked

}
