use v6.c;

use NativeCall;


use GStreamer::Raw::Types;

unit package GStreamer::Raw::DateTime;

sub gst_date_time_get_day (GstDateTime $datetime)
  returns gint
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_get_hour (GstDateTime $datetime)
  returns gint
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_get_microsecond (GstDateTime $datetime)
  returns gint
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_get_minute (GstDateTime $datetime)
  returns gint
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_get_month (GstDateTime $datetime)
  returns gint
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_get_second (GstDateTime $datetime)
  returns gint
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_get_time_zone_offset (GstDateTime $datetime)
  returns gfloat
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_get_year (GstDateTime $datetime)
  returns gint
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_has_day (GstDateTime $datetime)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_has_month (GstDateTime $datetime)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_has_second (GstDateTime $datetime)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_has_time (GstDateTime $datetime)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_has_year (GstDateTime $datetime)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_new (
  gfloat $tzoffset,
  gint $year,
  gint $month,
  gint $day,
  gint $hour,
  gint $minute,
  gdouble $seconds
)
  returns GstDateTime
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_new_from_g_date_time (GDateTime $dt)
  returns GstDateTime
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_new_from_iso8601_string (Str $string)
  returns GstDateTime
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_new_from_unix_epoch_local_time (gint64 $secs)
  returns GstDateTime
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_new_from_unix_epoch_utc (gint64 $secs)
  returns GstDateTime
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_new_local_time (
  gint $year,
  gint $month,
  gint $day,
  gint $hour,
  gint $minute,
  gdouble $seconds
)
  returns GstDateTime
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_new_now_local_time ()
  returns GstDateTime
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_new_now_utc ()
  returns GstDateTime
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_new_y (gint $year)
  returns GstDateTime
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_new_ym (gint $year, gint $month)
  returns GstDateTime
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_new_ymd (gint $year, gint $month, gint $day)
  returns GstDateTime
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_ref (GstDateTime $datetime)
  returns GstDateTime
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_to_g_date_time (GstDateTime $datetime)
  returns GDateTime
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_to_iso8601_string (GstDateTime $datetime)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_date_time_unref (GstDateTime $datetime)
  is native(gstreamer)
  is export
{ * }
