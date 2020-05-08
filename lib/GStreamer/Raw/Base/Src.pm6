use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Enums;
use GStreamer::Raw::Structs;

unit package GStreamer::Base::Src;

### /usr/include/gstreamer-1.0/gst/base/gstbasesrc.h

sub gst_base_src_get_allocator (
  GstBaseSrc $src,
  CArray[Pointer[GstAllocator]] $allocator,
  GstAllocationParams $params is rw
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_src_get_blocksize (GstBaseSrc $src)
  returns guint
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_src_get_buffer_pool (GstBaseSrc $src)
  returns GstBufferPool
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_src_get_do_timestamp (GstBaseSrc $src)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_src_get_type ()
  returns GType
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_src_is_async (GstBaseSrc $src)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_src_is_live (GstBaseSrc $src)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_src_new_seamless_segment (
  GstBaseSrc $src,
  gint64 $start,
  gint64 $stop,
  gint64 $time
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_src_query_latency (
  GstBaseSrc $src,
  gboolean $live,
  GstClockTime $min_latency,
  GstClockTime $max_latency
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_src_set_async (GstBaseSrc $src, gboolean $async)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_src_set_automatic_eos (GstBaseSrc $src, gboolean $automatic_eos)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_src_set_blocksize (GstBaseSrc $src, guint $blocksize)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_src_set_caps (GstBaseSrc $src, GstCaps $caps)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_src_set_do_timestamp (GstBaseSrc $src, gboolean $timestamp)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_src_set_dynamic_size (GstBaseSrc $src, gboolean $dynamic)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_src_set_format (GstBaseSrc $src, GstFormat $format)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_src_set_live (GstBaseSrc $src, gboolean $live)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_src_start_complete (GstBaseSrc $basesrc, GstFlowReturn $ret)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_src_start_wait (GstBaseSrc $basesrc)
  returns GstFlowReturn
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_src_submit_buffer_list (
  GstBaseSrc $src,
  GstBufferList $buffer_list
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_src_wait_playing (GstBaseSrc $src)
  returns GstFlowReturn
  is native(gstreamer-base)
  is export
{ * }
