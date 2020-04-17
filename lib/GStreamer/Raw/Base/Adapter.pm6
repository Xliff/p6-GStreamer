use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::Base::Adapter;

### /usr/include/gstreamer-1.0/gst/base/gstadapter.h

sub gst_adapter_available (GstAdapter $adapter)
  returns gsize
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_available_fast (GstAdapter $adapter)
  returns gsize
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_clear (GstAdapter $adapter)
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_copy (
  GstAdapter $adapter,
  gpointer $dest,
  gsize $offset,
  gsize $size
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_copy_bytes (GstAdapter $adapter, gsize $offset, gsize $size)
  returns GBytes
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_distance_from_discont (GstAdapter $adapter)
  returns guint64
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_dts_at_discont (GstAdapter $adapter)
  returns GstClockTime
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_flush (GstAdapter $adapter, gsize $flush)
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_get_buffer (GstAdapter $adapter, gsize $nbytes)
  returns GstBuffer
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_get_buffer_fast (GstAdapter $adapter, gsize $nbytes)
  returns GstBuffer
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_get_buffer_list (GstAdapter $adapter, gsize $nbytes)
  returns GstBufferList
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_get_list (GstAdapter $adapter, gsize $nbytes)
  returns GList
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_map (GstAdapter $adapter, gsize $size)
  returns gconstpointer
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_masked_scan_uint32 (
  GstAdapter $adapter,
  guint32 $mask,
  guint32 $pattern,
  gsize $offset,
  gsize $size
)
  returns gssize
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_masked_scan_uint32_peek (
  GstAdapter $adapter,
  guint32 $mask,
  guint32 $pattern,
  gsize $offset,
  gsize $size,
  guint32 $value is rw
)
  returns gssize
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_new ()
  returns GstAdapter
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_offset_at_discont (GstAdapter $adapter)
  returns guint64
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_prev_dts (GstAdapter $adapter, guint64 $distance is rw)
  returns GstClockTime
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_prev_dts_at_offset (
  GstAdapter $adapter,
  gsize $offset,
  uint64 $distance is rw
)
  returns GstClockTime
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_prev_offset (GstAdapter $adapter, guint64 $distance is rw)
  returns guint64
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_prev_pts (GstAdapter $adapter, guint64 $distance is rw)
  returns GstClockTime
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_prev_pts_at_offset (
  GstAdapter $adapter,
  gsize $offset,
  guint64 $distance is rw
)
  returns GstClockTime
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_pts_at_discont (GstAdapter $adapter)
  returns GstClockTime
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_push (GstAdapter $adapter, GstBuffer $buf)
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_take (GstAdapter $adapter, gsize $nbytes)
  returns CArray[uint8]
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_take_buffer (GstAdapter $adapter, gsize $nbytes)
  returns GstBuffer
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_take_buffer_fast (GstAdapter $adapter, gsize $nbytes)
  returns GstBuffer
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_take_buffer_list (GstAdapter $adapter, gsize $nbytes)
  returns GstBufferList
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_take_list (GstAdapter $adapter, gsize $nbytes)
  returns GList
  is native(gstreamer-base)
  is export
{ * }

sub gst_adapter_unmap (GstAdapter $adapter)
  is native(gstreamer-base)
  is export
{ * }
