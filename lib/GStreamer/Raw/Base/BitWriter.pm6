use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

unit package GStreamer::Base::Raw::BitWriter;

### /usr/include/gstreamer-1.0/gst/base/gstbitwriter.h

sub gst_bit_writer_align_bytes (GstBitWriter $bitwriter, guint8 $trailing_bit)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_writer_free (GstBitWriter $bitwriter)
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_writer_free_and_get_buffer (GstBitWriter $bitwriter)
  returns GstBuffer
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_writer_free_and_get_data (GstBitWriter $bitwriter)
  returns CArray[guint8]
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_writer_get_data (GstBitWriter $bitwriter)
  returns CArray[guint8]
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_writer_get_remaining (GstBitWriter $bitwriter)
  returns guint
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_writer_get_size (GstBitWriter $bitwriter)
  returns guint
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_writer_init (GstBitWriter $bitwriter)
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_writer_init_with_data (
  GstBitWriter $bitwriter,
  CArray[guint8] $data,
  guint $size,
  gboolean $initialized
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_writer_init_with_size (
  GstBitWriter $bitwriter,
  guint32 $size,
  gboolean $fixed
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_writer_new ()
  returns GstBitWriter
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_writer_new_with_data (
  guint8 $data is rw,
  guint $size,
  gboolean $initialized
)
  returns GstBitWriter
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_writer_new_with_size (guint32 $size, gboolean $fixed)
  returns GstBitWriter
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_writer_put_bits_uint16 (
  GstBitWriter $bitwriter,
  CArray[guint16] $value,
  guint $nbits
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_writer_put_bits_uint32 (
  GstBitWriter $bitwriter,
  guint32 $value,
  guint $nbits
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_writer_put_bits_uint64 (
  GstBitWriter $bitwriter,
  guint64 $value,
  guint $nbits
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_writer_put_bits_uint8 (
  GstBitWriter $bitwriter,
  guint8 $value,
  guint $nbits
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_writer_put_bytes (
  GstBitWriter $bitwriter,
  CArray[guint8] $data is rw,
  guint $nbytes
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_writer_reset (GstBitWriter $bitwriter)
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_writer_reset_and_get_buffer (GstBitWriter $bitwriter)
  returns GstBuffer
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_writer_reset_and_get_data (GstBitWriter $bitwriter)
  returns CArray[guint8]
  is native(gstreamer-base)
  is export
{ * }

sub gst_bit_writer_set_pos (GstBitWriter $bitwriter, guint $pos)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }
