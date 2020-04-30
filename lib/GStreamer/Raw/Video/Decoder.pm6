use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Enums;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::Video::Decoder;

### /usr/include/gstreamer-1.0/gst/video/gstvideodecoder.h

sub gst_video_decoder_get_type ()
  returns GType
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_add_to_frame (GstVideoDecoder $decoder, gint $n_bytes)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_allocate_output_buffer (GstVideoDecoder $decoder)
  returns GstBuffer
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_allocate_output_frame (
  GstVideoDecoder $decoder,
  GstVideoCodecFrame $frame
)
  returns GstFlowReturn
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_allocate_output_frame_with_params (
  GstVideoDecoder $decoder,
  GstVideoCodecFrame $frame,
  GstBufferPoolAcquireParams $params
)
  returns GstFlowReturn
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_drop_frame (
  GstVideoDecoder $dec,
  GstVideoCodecFrame $frame
)
  returns GstFlowReturn
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_finish_frame (
  GstVideoDecoder $decoder,
  GstVideoCodecFrame $frame
)
  returns GstFlowReturn
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_get_allocator (
  GstVideoDecoder $decoder,
  CArray[Pointer[GstAllocator]] $allocator,
  GstAllocationParams $params is rw
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_get_buffer_pool (GstVideoDecoder $decoder)
  returns GstBufferPool
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_get_estimate_rate (GstVideoDecoder $dec)
  returns gint
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_get_frame (GstVideoDecoder $decoder, gint $frame_number)
  returns GstVideoCodecFrame
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_get_frames (GstVideoDecoder $decoder)
  returns GList
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_get_latency (
  GstVideoDecoder $decoder,
  GstClockTime $min_latency,
  GstClockTime $max_latency
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_get_max_decode_time (
  GstVideoDecoder $decoder,
  GstVideoCodecFrame $frame
)
  returns GstClockTimeDiff
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_get_max_errors (GstVideoDecoder $dec)
  returns gint
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_get_needs_format (GstVideoDecoder $dec)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_get_oldest_frame (GstVideoDecoder $decoder)
  returns GstVideoCodecFrame
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_get_output_state (GstVideoDecoder $decoder)
  returns GstVideoCodecState
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_get_packetized (GstVideoDecoder $decoder)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_get_pending_frame_size (GstVideoDecoder $decoder)
  returns gsize
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_get_qos_proportion (GstVideoDecoder $decoder)
  returns gdouble
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_have_frame (GstVideoDecoder $decoder)
  returns GstFlowReturn
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_merge_tags (
  GstVideoDecoder $decoder,
  GstTagList $tags,
  GstTagMergeMode $mode
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_negotiate (GstVideoDecoder $decoder)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_proxy_getcaps (
  GstVideoDecoder $decoder,
  GstCaps $caps,
  GstCaps $filter
)
  returns GstCaps
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_release_frame (
  GstVideoDecoder $dec,
  GstVideoCodecFrame $frame
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_set_estimate_rate (
  GstVideoDecoder $dec,
  gboolean $enabled
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_set_interlaced_output_state (
  GstVideoDecoder $decoder,
  GstVideoFormat $fmt,
  GstVideoInterlaceMode $mode,
  guint $width,
  guint $height,
  GstVideoCodecState $reference
)
  returns GstVideoCodecState
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_set_latency (
  GstVideoDecoder $decoder,
  GstClockTime $min_latency,
  GstClockTime $max_latency
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_set_max_errors (GstVideoDecoder $dec, gint $num)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_set_needs_format (
  GstVideoDecoder $dec,
  gboolean $enabled
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_set_output_state (
  GstVideoDecoder $decoder,
  GstVideoFormat $fmt,
  guint $width,
  guint $height,
  GstVideoCodecState $reference
)
  returns GstVideoCodecState
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_set_packetized (
  GstVideoDecoder $decoder,
  gboolean $packetized
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_decoder_set_use_default_pad_acceptcaps (
  GstVideoDecoder $decoder,
  gboolean $use
)
  is native(gstreamer-video)
  is export
{ * }
