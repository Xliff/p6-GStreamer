use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Structs;

unit package GStreamer::Base::Raw::BitReader;

### /usr/include/gstreamer-1.0/gst/base/gstbitreader.h

sub gst_bit_reader_free (GstBitReader $reader)
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_reader_get_bits_uint16 (
  GstBitReader $reader,
  guint16 $val is rw,
  guint $nbits
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_reader_get_bits_uint32 (
  GstBitReader $reader,
  guint32 $val is rw,
  guint $nbits
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_reader_get_bits_uint64 (
  GstBitReader $reader,
  guint64 $val is rw,
  guint $nbits
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_reader_get_bits_uint8 (
  GstBitReader $reader,
  guint8 $val is rw,
  guint $nbits
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_reader_get_pos (GstBitReader $reader)
  returns guint
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_reader_get_remaining (GstBitReader $reader)
  returns guint
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_reader_get_size (GstBitReader $reader)
  returns guint
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_reader_init (GstBitReader $reader, guint8 $data is rw, guint $size)
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_reader_new (guint8 $data is rw, guint $size)
  returns CArray[GstBitReader]
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_reader_peek_bits_uint16 (
  GstBitReader $reader,
  guint16 $val is rw,
  guint $nbits
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_reader_peek_bits_uint32 (
  GstBitReader $reader,
  guint32 $val is rw,
  guint $nbits
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_reader_peek_bits_uint64 (
  GstBitReader $reader,
  guint64 $val is rw,
  guint $nbits
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_reader_peek_bits_uint8 (
  GstBitReader $reader,
  guint8 $val is rw,
  guint $nbits
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_reader_set_pos (GstBitReader $reader, guint $pos)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_reader_skip (GstBitReader $reader, guint $nbits)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_reader_skip_to_byte (GstBitReader $reader)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }
