use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Enums;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::Video::TimeCode;

### /usr/include/gstreamer-1.0/gst/video/gstvideotimecode.h

sub gst_video_time_code_add_frames (GstVideoTimeCode $tc, gint64 $frames)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_time_code_add_interval (
  GstVideoTimeCode $tc,
  GstVideoTimeCodeInterval $tc_inter
)
  returns GstVideoTimeCode
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_time_code_clear (GstVideoTimeCode $tc)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_time_code_compare (GstVideoTimeCode $tc1, GstVideoTimeCode $tc2)
  returns gint
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_time_code_copy (GstVideoTimeCode $tc)
  returns GstVideoTimeCode
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_time_code_frames_since_daily_jam (GstVideoTimeCode $tc)
  returns guint64
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_time_code_free (GstVideoTimeCode $tc)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_time_code_increment_frame (GstVideoTimeCode $tc)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_time_code_init (
  GstVideoTimeCode $tc,
  guint $fps_n,
  guint $fps_d,
  GDateTime $latest_daily_jam,
  GstVideoTimeCodeFlags $flags,
  guint $hours,
  guint $minutes,
  guint $seconds,
  guint $frames,
  guint $field_count
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_time_code_init_from_date_time_full (
  GstVideoTimeCode $tc,
  guint $fps_n,
  guint $fps_d,
  GDateTime $dt,
  GstVideoTimeCodeFlags $flags,
  guint $field_count
)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_time_code_interval_clear (GstVideoTimeCodeInterval $tc)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_time_code_interval_copy (GstVideoTimeCodeInterval $tc)
  returns GstVideoTimeCodeInterval
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_time_code_interval_free (GstVideoTimeCodeInterval $tc)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_time_code_interval_get_type ()
  returns GType
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_time_code_interval_init (
  GstVideoTimeCodeInterval $tc,
  guint $hours,
  guint $minutes,
  guint $seconds,
  guint $frames
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_time_code_interval_new (
  guint $hours,
  guint $minutes,
  guint $seconds,
  guint $frames
)
  returns GstVideoTimeCodeInterval
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_time_code_interval_new_from_string (Str $tc_inter_str)
  returns GstVideoTimeCodeInterval
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_time_code_is_valid (GstVideoTimeCode $tc)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_time_code_new (
  guint $fps_n,
  guint $fps_d,
  GDateTime $latest_daily_jam,
  GstVideoTimeCodeFlags $flags,
  guint $hours,
  guint $minutes,
  guint $seconds,
  guint $frames,
  guint $field_count
)
  returns GstVideoTimeCode
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_time_code_new_empty ()
  returns GstVideoTimeCode
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_time_code_new_from_date_time_full (
  guint $fps_n,
  guint $fps_d,
  GDateTime $dt,
  GstVideoTimeCodeFlags $flags,
  guint $field_count
)
  returns GstVideoTimeCode
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_time_code_new_from_string (Str $tc_str)
  returns GstVideoTimeCode
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_time_code_nsec_since_daily_jam (GstVideoTimeCode $tc)
  returns guint64
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_time_code_to_date_time (GstVideoTimeCode $tc)
  returns GDateTime
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_time_code_to_string (GstVideoTimeCode $tc)
  returns Str
  is native(gstreamer-video)
  is export
{ * }
