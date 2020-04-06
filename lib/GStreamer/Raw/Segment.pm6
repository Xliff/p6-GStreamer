use v6.c;

use NativeCall;


use GStreamer::Raw::Types;

unit package GStreamer::Raw::Segment;

sub gst_segment_clip (
  GstSegment $segment,
  GstFormat $format,
  guint64 $start,
  guint64 $stop,
  guint64 $clip_start is rw,
  guint64 $clip_stop  is rw
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_segment_copy (GstSegment $segment)
  returns GstSegment
  is native(gstreamer)
  is export
{ * }

sub gst_segment_copy_into (GstSegment $src, GstSegment $dest)
  is native(gstreamer)
  is export
{ * }

sub gst_segment_do_seek (
  GstSegment $segment,
  gdouble $rate,
  GstFormat $format,
  GstSeekFlags $flags,
  GstSeekType $start_type,
  guint64 $start,
  GstSeekType $stop_type,
  guint64 $stop,
  gboolean $update is rw
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_segment_free (GstSegment $segment)
  is native(gstreamer)
  is export
{ * }

sub gst_segment_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_segment_init (GstSegment $segment, GstFormat $format)
  is native(gstreamer)
  is export
{ * }

sub gst_segment_is_equal (GstSegment $s0, GstSegment $s1)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_segment_new ()
  returns GstSegment
  is native(gstreamer)
  is export
{ * }

sub gst_segment_offset_running_time (
  GstSegment $segment,
  GstFormat $format,
    gint64 $offset
  )
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_segment_position_from_running_time (
  GstSegment $segment,
  GstFormat $format,
  guint64 $running_time
)
  returns guint64
  is native(gstreamer)
  is export
{ * }

sub gst_segment_position_from_running_time_full (
  GstSegment $segment,
  GstFormat $format,
  guint64 $running_time,
  guint64 $position is rw
)
  returns gint
  is native(gstreamer)
  is export
{ * }

sub gst_segment_position_from_stream_time (
  GstSegment $segment,
  GstFormat $format,
  guint64 $stream_time
)
  returns guint64
  is native(gstreamer)
  is export
{ * }

sub gst_segment_position_from_stream_time_full (
  GstSegment $segment,
  GstFormat $format,
  guint64 $stream_time,
  guint64 $position is rw
)
  returns gint
  is native(gstreamer)
  is export
{ * }

sub gst_segment_set_running_time (
  GstSegment $segment,
  GstFormat $format,
  guint64 $running_time
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_segment_to_running_time (
  GstSegment $segment,
  GstFormat $format,
  guint64 $position
)
  returns guint64
  is native(gstreamer)
  is export
{ * }

sub gst_segment_to_running_time_full (
  GstSegment $segment,
  GstFormat $format,
  guint64 $position,
  guint64 $running_time is rw
)
  returns gint
  is native(gstreamer)
  is export
{ * }

sub gst_segment_to_stream_time (
  GstSegment $segment,
  GstFormat $format,
  guint64 $position
)
  returns guint64
  is native(gstreamer)
  is export
{ * }

sub gst_segment_to_stream_time_full (
  GstSegment $segment,
  GstFormat $format,
  guint64 $position,
  guint64 $stream_time is rw
)
  returns gint
  is native(gstreamer)
  is export
{ * }
