use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::Base::ByteWriter;

### /usr/include/gstreamer-1.0/gst/base/gstbytewriter.h

sub gst_byte_writer_ensure_free_space (GstByteWriter $writer, guint $size)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_fill (GstByteWriter $writer, guint8 $value, guint $size)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_free (GstByteWriter $writer)
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_free_and_get_buffer (GstByteWriter $writer)
  returns GstBuffer
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_free_and_get_data (GstByteWriter $writer)
  returns guint8
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_get_remaining (GstByteWriter $writer)
  returns guint
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_init (GstByteWriter $writer)
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_init_with_data (
  GstByteWriter $writer,
  Pointer $data,
  guint $size,
  gboolean $initialized
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_init_with_size (
  GstByteWriter $writer,
  guint $size,
  gboolean $fixed
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_new ()
  returns GstByteWriter
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_new_with_data (
  Pointer $data,
  guint $size,
  gboolean $initialized
)
  returns GstByteWriter
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_new_with_size (guint $size, gboolean $fixed)
  returns GstByteWriter
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_put_buffer (
  GstByteWriter $writer,
  GstBuffer $buffer,
  gsize $offset,
  gssize $size
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_put_data (
  GstByteWriter $writer,
  Pointer $data,
  guint $size
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_put_float32_be (GstByteWriter $writer, gfloat $val)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_put_float32_le (GstByteWriter $writer, gfloat $val)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_put_float64_be (GstByteWriter $writer, gdouble $val)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_put_float64_le (GstByteWriter $writer, gdouble $val)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_put_int16_be (GstByteWriter $writer, gint16 $val)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_put_int16_le (GstByteWriter $writer, gint16 $val)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_put_int24_be (GstByteWriter $writer, gint32 $val)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_put_int24_le (GstByteWriter $writer, gint32 $val)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_put_int32_be (GstByteWriter $writer, gint32 $val)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_put_int32_le (GstByteWriter $writer, gint32 $val)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_put_int64_be (GstByteWriter $writer, gint64 $val)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_put_int64_le (GstByteWriter $writer, gint64 $val)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_put_int8 (GstByteWriter $writer, gint8 $val)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_put_string_utf16 (
  GstByteWriter $writer,
  Pointer $data                # CArray[guint16] $data
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_put_string_utf32 (
  GstByteWriter $writer,
  Pointer $data                # CArray[guint32] $data
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_put_string_utf8 (
  GstByteWriter $writer,
  Pointer $data                # Str
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_put_uint16_be (GstByteWriter $writer, guint16 $val)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_put_uint16_le (GstByteWriter $writer, guint16 $val)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_put_uint24_be (GstByteWriter $writer, guint32 $val)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_put_uint24_le (GstByteWriter $writer, guint32 $val)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_put_uint32_be (GstByteWriter $writer, guint32 $val)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_put_uint32_le (GstByteWriter $writer, guint32 $val)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_put_uint64_be (GstByteWriter $writer, guint64 $val)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_put_uint64_le (GstByteWriter $writer, guint64 $val)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_put_uint8 (GstByteWriter $writer, guint8 $val)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_reset (GstByteWriter $writer)
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_reset_and_get_buffer (GstByteWriter $writer)
  returns GstBuffer
  is native(gstreamer-base)
  is export
{ * }

sub gst_byte_writer_reset_and_get_data (GstByteWriter $writer)
  returns CArray[guint8]
  is native(gstreamer-base)
  is export
{ * }
