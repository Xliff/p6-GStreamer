use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Structs;

### /usr/include/gstreamer-1.0/gst/base/gstbasetransform.h

sub gst_base_transform_get_allocator (
  GstBaseTransform $trans,
  CArray[Pointer[GstAllocator]] $allocator,
  GstAllocationParams $params is rw
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_transform_get_buffer_pool (GstBaseTransform $trans)
  returns GstBufferPool
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_transform_get_type ()
  returns GType
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_transform_is_in_place (GstBaseTransform $trans)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_transform_is_passthrough (GstBaseTransform $trans)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_transform_is_qos_enabled (GstBaseTransform $trans)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_transform_reconfigure_sink (GstBaseTransform $trans)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_transform_reconfigure_src (GstBaseTransform $trans)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_transform_set_gap_aware (
  GstBaseTransform $trans,
  gboolean $gap_aware
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_transform_set_in_place (
  GstBaseTransform $trans,
  gboolean $in_place
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_transform_set_passthrough (
  GstBaseTransform $trans,
  gboolean $passthrough
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_transform_set_prefer_passthrough (
  GstBaseTransform $trans,
  gboolean $prefer_passthrough
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_transform_set_qos_enabled (
  GstBaseTransform $trans,
  gboolean $enabled
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_transform_update_qos (
  GstBaseTransform $trans,
  gdouble $proportion,
  GstClockTimeDiff $diff,
  GstClockTime $timestamp
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_transform_update_src_caps (
  GstBaseTransform $trans,
  GstCaps $updated_caps
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }
