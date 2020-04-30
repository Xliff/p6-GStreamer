use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Enums;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::Video::Encoder;

### /usr/include/gstreamer-1.0/gst/video/gstvideoencoder.h

sub gst_video_encoder_get_type ()
  returns GType
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_encoder_allocate_output_buffer (
  GstVideoEncoder $encoder,
  gsize $size
)
  returns GstBuffer
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_encoder_allocate_output_frame (
  GstVideoEncoder $encoder,
  GstVideoCodecFrame $frame,
  gsize $size
)
  returns GstFlowReturn
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_encoder_finish_frame (
  GstVideoEncoder $encoder,
  GstVideoCodecFrame $frame
)
  returns GstFlowReturn
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_encoder_get_allocator (
  GstVideoEncoder $encoder,
  GstAllocator $allocator,
  GstAllocationParams $params
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_encoder_get_frame (GstVideoEncoder $encoder, gint $frame_number)
  returns GstVideoCodecFrame
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_encoder_get_frames (GstVideoEncoder $encoder)
  returns GList
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_encoder_get_latency (
  GstVideoEncoder $encoder,
  GstClockTime $min_latency,
  GstClockTime $max_latency
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_encoder_get_max_encode_time (
  GstVideoEncoder $encoder,
  GstVideoCodecFrame $frame
)
  returns GstClockTimeDiff
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_encoder_get_oldest_frame (GstVideoEncoder $encoder)
  returns GstVideoCodecFrame
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_encoder_get_output_state (GstVideoEncoder $encoder)
  returns GstVideoCodecState
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_encoder_is_qos_enabled (GstVideoEncoder $encoder)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_encoder_merge_tags (
  GstVideoEncoder $encoder,
  GstTagList $tags,
  GstTagMergeMode $mode
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_encoder_negotiate (GstVideoEncoder $encoder)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_encoder_proxy_getcaps (
  GstVideoEncoder $enc,
  GstCaps $caps,
  GstCaps $filter
)
  returns GstCaps
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_encoder_set_headers (GstVideoEncoder $encoder, GList $headers)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_encoder_set_latency (
  GstVideoEncoder $encoder,
  GstClockTime $min_latency,
  GstClockTime $max_latency
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_encoder_set_min_pts (
  GstVideoEncoder $encoder,
  GstClockTime $min_pts
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_encoder_set_output_state (
  GstVideoEncoder $encoder,
  GstCaps $caps,
  GstVideoCodecState $reference
)
  returns GstVideoCodecState
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_encoder_set_qos_enabled (
  GstVideoEncoder $encoder,
  gboolean $enabled
)
  is native(gstreamer-video)
  is export
{ * }
