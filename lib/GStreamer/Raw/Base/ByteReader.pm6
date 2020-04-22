use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::Base::ByteReader;

### /usr/include/gstreamer-1.0/gst/base/gstbytereader.h

sub gst_byte_reader_dup_data (
  GstByteReader $reader,
  guint $size,
  CArray[CArray[guint8]] $val
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_dup_string_utf16 (GstByteReader $reader, guint16 $str)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_dup_string_utf32 (GstByteReader $reader, guint32 $str)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_dup_string_utf8 (GstByteReader $reader, Str $str)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_free (GstByteReader $reader)
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_data (GstByteReader $reader, guint $size, guint8 $val)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_float32_be (GstByteReader $reader, gfloat $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_float32_le (GstByteReader $reader, gfloat $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_float64_be (GstByteReader $reader, gdouble $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_float64_le (GstByteReader $reader, gdouble $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_int16_be (GstByteReader $reader, gint16 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_int16_le (GstByteReader $reader, gint16 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_int24_be (GstByteReader $reader, gint32 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_int24_le (GstByteReader $reader, gint32 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_int32_be (GstByteReader $reader, gint32 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_int32_le (GstByteReader $reader, gint32 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_int64_be (GstByteReader $reader, gint64 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_int64_le (GstByteReader $reader, gint64 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_int8 (GstByteReader $reader, gint8 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_pos (GstByteReader $reader)
  returns guint
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_remaining (GstByteReader $reader)
  returns guint
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_size (GstByteReader $reader)
  returns guint
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_string_utf8 (GstByteReader $reader, Str $str)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_sub_reader (
  GstByteReader $reader,
  GstByteReader $sub_reader,
  guint $size
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_uint16_be (GstByteReader $reader, guint16 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_uint16_le (GstByteReader $reader, guint16 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_uint24_be (GstByteReader $reader, guint32 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_uint24_le (GstByteReader $reader, guint32 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_uint32_be (GstByteReader $reader, guint32 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_uint32_le (GstByteReader $reader, guint32 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_uint64_be (GstByteReader $reader, guint64 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_uint64_le (GstByteReader $reader, guint64 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_get_uint8 (GstByteReader $reader, guint8 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_init (
  GstByteReader $reader,
  guint8 $data is rw,
  guint $size
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_masked_scan_uint32 (
  GstByteReader $reader,
  guint32 $mask,
  guint32 $pattern,
  guint $offset,
  guint $size
)
  returns guint
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_masked_scan_uint32_peek (
  GstByteReader $reader,
  guint32 $mask,
  guint32 $pattern,
  guint $offset,
  guint $size,
  guint32 $value is rw
)
  returns guint
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_new (guint8 $data is rw, guint $size)
  returns CArray[GstByteReader]
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_peek_data (GstByteReader $reader, guint $size, guint8 $val)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_peek_float32_be (GstByteReader $reader, gfloat $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_peek_float32_le (GstByteReader $reader, gfloat $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_peek_float64_be (GstByteReader $reader, gdouble $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_peek_float64_le (GstByteReader $reader, gdouble $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_peek_int16_be (GstByteReader $reader, gint16 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_peek_int16_le (GstByteReader $reader, gint16 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_peek_int24_be (GstByteReader $reader, gint32 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_peek_int24_le (GstByteReader $reader, gint32 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_peek_int32_be (GstByteReader $reader, gint32 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_peek_int32_le (GstByteReader $reader, gint32 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_peek_int64_be (GstByteReader $reader, gint64 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_peek_int64_le (GstByteReader $reader, gint64 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_peek_int8 (GstByteReader $reader, gint8 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_peek_string_utf8 (GstByteReader $reader, Str $str)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_peek_sub_reader (
  GstByteReader $reader,
  GstByteReader $sub_reader,
  guint $size
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_peek_uint16_be (GstByteReader $reader, guint16 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_peek_uint16_le (GstByteReader $reader, guint16 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_peek_uint24_be (GstByteReader $reader, guint32 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_peek_uint24_le (GstByteReader $reader, guint32 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_peek_uint32_be (GstByteReader $reader, guint32 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_peek_uint32_le (GstByteReader $reader, guint32 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_peek_uint64_be (GstByteReader $reader, guint64 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_peek_uint64_le (GstByteReader $reader, guint64 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_peek_uint8 (GstByteReader $reader, guint8 $val is rw)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_set_pos (GstByteReader $reader, guint $pos)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_skip (GstByteReader $reader, guint $nbytes)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_skip_string_utf16 (GstByteReader $reader)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_skip_string_utf32 (GstByteReader $reader)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_reader_skip_string_utf8 (GstByteReader $reader)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }
