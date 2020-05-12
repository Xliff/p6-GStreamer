use v6.c;

use GStreamer::Raw::Types;
use GStreamer::Raw::Video::Event;

use GStreamer::Event;

class GStreamer::Video::Event is GStreamer::Event {

  multi method new (
    Int() $timestamp,
    Int() $stream_time,
    Int() $running_time,
    Int() $all_headers,
    Int() $count,
    :dfku(
      :down(:downstream(
        :downstream_force_key_unit(:$downstream-force-key-unit)
      ))
    ) is required
  ) {
    self.new_downstream_force_key_unit(
      $timestamp,
      $stream_time,
      $running_time,
      $all_headers,
      $count
    );
  }
  method new_downstream_force_key_unit (
    Int() $timestamp,
    Int() $stream_time,
    Int() $running_time,
    Int() $all_headers,
    Int() $count
  ) {
    my GstClockTime ($t, $st, $rt) =
      ($timestamp,  $stream_time,  $running_time);
    my gboolean $a = $all_headers.so.Int;
    my guint $c = $count;
    my $event = gst_video_event_new_downstream_force_key_unit(
      self.GstEvent,
      $t,
      $st,
      $rt,
      $a,
      $c
    );

    $event ?? self.bless( :$event ) !! Nil;
  }

  multi method new (Int() $in_still, :still_frame(:$still-frame) is required) {
    self.new_still_frame($in_still);
  }
  method new_still_frame (Int() $in_still) {
    my gboolean $i = $in_still.so.Int;
    my $event = gst_video_event_new_still_frame(self.GstEvent, $i);

    $event ?? self.bless( :$event ) !! Nil;
  }

  multi method new (
    Int() $running_time,
    Int() $all_headers,
    Int() $count,
    :ufku(
      :up(:upstream(
        :upstream_force_key_unit(:$upstream-force-key-unit)
      ))
    ) is required
  ) {
    self.new_upstream_force_key_unit($running_time, $all_headers, $count);
  }
  method new_upstream_force_key_unit (
    Int() $running_time,
    Int() $all_headers,
    Int() $count
  ) {
    my GstClockTime $rt = $running_time;
    my gboolean $a = $all_headers.so.Int;
    my guint $c = $count;
    my $event =
      gst_video_event_new_upstream_force_key_unit(self.GstEvent, $rt, $a, $c);

    $event ?? self.bless( :$event ) !! Nil;
  }

  method is_force_key_unit {
    so gst_video_event_is_force_key_unit(self.GstEvent);
  }

  proto method parse_downstream_force_key_unit (|)
  { * }

  multi method parse_downstream_force_key_unit {
    my $rv = samewith($, $, $, $, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method parse_downstream_force_key_unit (
    $timestamp    is rw,
    $stream_time  is rw,
    $running_time is rw,
    $all_headers  is rw,
    $count        is rw,
    :$all = False
  ) {
    my GstClockTime ($t, $st, $rt) = 0 xx 3;
    my gboolean $a = 0;
    my guint $c = 0;
    my $rv = gst_video_event_parse_downstream_force_key_unit(
      self.GstEvent,
      $t,
      $st,
      $rt,
      $a,
      $c
    );

    ($timestamp, $stream_time, $running_time, $all_headers, $count) =
      ($t, $st, $rt, $a.so, $c);
    $all.not ?? $rv !! (
      $rv,
      $timestamp,
      $stream_time,
      $running_time,
      $all_headers,
      $count
    );
  }

  proto method parse_still_frame (|)
  { * }

  multi method parse_still_frame {
    my $rv = samewith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method parse_still_frame ($in_still is rw, :$all = False) {
    my gboolean $i = 0;
    my $rv = gst_video_event_parse_still_frame(self.GstEvent, $i);

    $in_still = $i.so.Int;
    $all.not ?? $rv !! ($rv, $in_still);
  }

  proto method parse_upstream_force_key_unit (|)
  { * }

  multi method parse_upstream_force_key_unit {
    my $rv = samewith($, $, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method parse_upstream_force_key_unit (
    $running_time is rw,
    $all_headers  is rw,
    $count        is rw,
    :$all = False
  ) {
    my GstClockTime $r = 0;
    my gboolean $a = 0;
    my guint $c = 0;
    my $rv = gst_video_event_parse_upstream_force_key_unit(
      self.GstEvent,
      $r,
      $a,
      $c
    );

    ($running_time, $all_headers, $count) = ($r, $a.so, $count);
    $all.not ?? $rv !! ($rv, $running_time, $all_headers, $count);
  }

}
