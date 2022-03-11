use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

unit package GStreamer::Raw::Clock;

sub gst_clock_add_observation (
  GstClock     $clock,
  GstClockTime $slave,
  GstClockTime $master,
  gdouble      $r_squared is rw
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_clock_add_observation_unapplied (
  GstClock     $clock,
  GstClockTime $slave,
  GstClockTime $master,
  gdouble      $r_squared,
  GstClockTime $internal,
  GstClockTime $external,
  GstClockTime $rate_num,
  GstClockTime $rate_denom
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_clock_adjust_unlocked (GstClock $clock, GstClockTime $internal)
  returns GstClockTime
  is native(gstreamer)
  is export
{ * }

sub gst_clock_adjust_with_calibration (
  GstClock     $clock,
  GstClockTime $internal_target,
  GstClockTime $cinternal,
  GstClockTime $cexternal,
  GstClockTime $cnum,
  GstClockTime $cdenom
)
  returns GstClockTime
  is native(gstreamer)
  is export
{ * }

sub gst_clock_get_calibration (
  GstClock     $clock,
  GstClockTime $internal   is rw,
  GstClockTime $external   is rw,
  GstClockTime $rate_num   is rw,
  GstClockTime $rate_denom is rw
)
  is native(gstreamer)
  is export
{ * }

sub gst_clock_get_internal_time (GstClock $clock)
  returns GstClockTime
  is native(gstreamer)
  is export
{ * }

sub gst_clock_get_time (GstClock $clock)
  returns GstClockTime
  is native(gstreamer)
  is export
{ * }

sub gst_clock_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_clock_id_compare_func (gconstpointer $id1, gconstpointer $id2)
  returns gint
  is native(gstreamer)
  is export
{ * }

sub gst_clock_id_get_clock (GstClockID $id)
  returns GstClock
  is native(gstreamer)
  is export
{ * }

sub gst_clock_id_get_time (GstClockID $id)
  returns GstClockTime
  is native(gstreamer)
  is export
{ * }

sub gst_clock_id_ref (GstClockID $id)
  returns GstClockID
  is native(gstreamer)
  is export
{ * }

sub gst_clock_id_unref (GstClockID $id)
  is native(gstreamer)
  is export
{ * }

sub gst_clock_id_unschedule (GstClockID $id)
  is native(gstreamer)
  is export
{ * }

sub gst_clock_id_uses_clock (GstClockID $id, GstClock $clock)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_clock_id_wait (GstClockID $id, GstClockTimeDiff $jitter)
  returns GstClockReturn
  is native(gstreamer)
  is export
{ * }

sub gst_clock_id_wait_async (
  GstClockID $id,
  &func (GstClock, GstClockTime, GstClockID, gpointer --> gboolean),
  gpointer $user_data,
  GDestroyNotify $destroy_data
)
  returns GstClockReturn
  is native(gstreamer)
  is export
{ * }

sub gst_clock_is_synced (GstClock $clock)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_clock_new_periodic_id (
  GstClock     $clock,
  GstClockTime $start_time,
  GstClockTime $interval
)
  returns GstClockID
  is native(gstreamer)
  is export
{ * }

sub gst_clock_new_single_shot_id (GstClock $clock, GstClockTime $time)
  returns GstClockID
  is native(gstreamer)
  is export
{ * }

sub gst_clock_periodic_id_reinit (
  GstClock     $clock,
  GstClockID   $id,
  GstClockTime $start_time,
  GstClockTime $interval
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_clock_set_calibration (
  GstClock     $clock,
  GstClockTime $internal,
  GstClockTime $external,
  GstClockTime $rate_num,
  GstClockTime $rate_denom
)
  is native(gstreamer)
  is export
{ * }

sub gst_clock_set_synced (GstClock $clock, gboolean $synced)
  is native(gstreamer)
  is export
{ * }

sub gst_clock_single_shot_id_reinit (
  GstClock     $clock,
  GstClockID   $id,
  GstClockTime $time
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_clock_unadjust_unlocked (GstClock $clock, GstClockTime $external)
  returns GstClockTime
  is native(gstreamer)
  is export
{ * }

sub gst_clock_unadjust_with_calibration (
  GstClock     $clock,
  GstClockTime $external_target,
  GstClockTime $cinternal,
  GstClockTime $cexternal,
  GstClockTime $cnum,
  GstClockTime $cdenom
)
  returns GstClockTime
  is native(gstreamer)
  is export
{ * }

sub gst_clock_wait_for_sync (GstClock $clock, GstClockTime $timeout)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_clock_get_master (GstClock $clock)
  returns GstClock
  is native(gstreamer)
  is export
{ * }

sub gst_clock_get_resolution (GstClock $clock)
  returns GstClockTime
  is native(gstreamer)
  is export
{ * }

sub gst_clock_get_timeout (GstClock $clock)
  returns GstClockTime
  is native(gstreamer)
  is export
{ * }

sub gst_clock_set_master (GstClock $clock, GstClock $master)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_clock_set_resolution (GstClock $clock, GstClockTime $resolution)
  returns GstClockTime
  is native(gstreamer)
  is export
{ * }

sub gst_clock_set_timeout (GstClock $clock, GstClockTime $timeout)
  is native(gstreamer)
  is export
{ * }
