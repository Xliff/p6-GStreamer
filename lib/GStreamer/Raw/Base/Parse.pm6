use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Enums;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::Base::Parse;

### /usr/include/gstreamer-1.0/gst/base/gstbaseparse.h

sub gst_base_parse_add_index_entry (
  GstBaseParse $parse,
  guint64 $offset,
  GstClockTime $ts,
  gboolean $key,
  gboolean $force
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_parse_convert_default (
  GstBaseParse $parse,
  GstFormat $src_format,
  gint64 $src_value,
  GstFormat $dest_format,
  gint64 $dest_value is rw
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_parse_drain (GstBaseParse $parse)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_parse_finish_frame (
  GstBaseParse $parse,
  GstBaseParseFrame $frame,
  gint $size
)
  returns GstFlowReturn
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_parse_frame_copy (GstBaseParseFrame $frame)
  returns GstBaseParseFrame
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_parse_frame_free (GstBaseParseFrame $frame)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_parse_frame_get_type ()
  returns GType
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_parse_frame_init (GstBaseParseFrame $frame)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_parse_frame_new (
  GstBuffer $buffer,
  GstBaseParseFrameFlags $flags,
  gint $overhead
)
  returns GstBaseParseFrame
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_parse_get_type ()
  returns GType
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_parse_merge_tags (
  GstBaseParse $parse,
  GstTagList $tags,
  GstTagMergeMode $mode
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_parse_push_frame (GstBaseParse $parse, GstBaseParseFrame $frame)
  returns GstFlowReturn
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_parse_set_average_bitrate (GstBaseParse $parse, guint $bitrate)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_parse_set_duration (
  GstBaseParse $parse,
  GstFormat $fmt,
  gint64 $duration,
  gint $interval
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_parse_set_frame_rate (
  GstBaseParse $parse,
  guint $fps_num,
  guint $fps_den,
  guint $lead_in,
  guint $lead_out
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_parse_set_has_timing_info (
  GstBaseParse $parse,
  gboolean $has_timing
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_parse_set_infer_ts (GstBaseParse $parse, gboolean $infer_ts)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_parse_set_latency (
  GstBaseParse $parse,
  GstClockTime $min_latency,
  GstClockTime $max_latency
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_parse_set_min_frame_size (GstBaseParse $parse, guint $min_size)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_parse_set_passthrough (GstBaseParse $parse, gboolean $passthrough)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_parse_set_pts_interpolation (
  GstBaseParse $parse,
  gboolean $pts_interpolate
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_parse_set_syncable (GstBaseParse $parse, gboolean $syncable)
  is native(gstreamer-base)
  is export
{ * }

sub gst_base_parse_set_ts_at_offset (GstBaseParse $parse, gsize $offset)
  is native(gstreamer-base)
  is export
{ * }
