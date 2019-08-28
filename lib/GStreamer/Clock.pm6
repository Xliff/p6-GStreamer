use v6.c;

use Method::Also;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::Clock;

use GStreamer::Object;

our subset ClockAncestry is export of Mu
  where GstClock | GstObject;

class GStreamer::Clock is GStreamer::Object {
  has GstClock $!c;

  submethod BUILD (:$clock) {
    self.setClock($clock) if $clock.defined;
  }

  method setClock(ClockAncestry $clock) {
    my $to-parent;
    $!c = do {
      when GstClock {
        $to-parent = cast(GstObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstClock, $_);
      }
    }
    self.setGstObject($to-parent);
  }

  method GStreamer::Raw::Types::GstClock
    is also<GstClock>
  { $!c }

  method master (:$raw = False) is rw {
    Proxy.new(
      FETCH => sub ($) {
        my $c = gst_clock_get_master($!c);

        $c ??
          ( $raw ?? $c !! GStreamer::Clock.new($c) )
          !!
          Nil;
      },
      STORE => sub ($, GstClock() $master is copy) {
        gst_clock_set_master($!c, $master);
      }
    );
  }

  method resolution is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_clock_get_resolution($!c);
      },
      STORE => sub ($, Int() $resolution is copy) {
        my uint64 $r = $resolution;
        gst_clock_set_resolution($!c, $r);
      }
    );
  }

  method timeout is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_clock_get_timeout($!c);
      },
      STORE => sub ($, Int() $timeout is copy) {
        my uint64 $t = $timeout;
        gst_clock_set_timeout($!c, $t);
      }
    );
  }

  proto method add_observation (|)
    is also<add-observation>
  { * }

  multi method add_observation(
    Int() $slave,
    Int() $master,
    :$all = False
  ) {
    samewith($slave, $master, $, :$all);
  }
  multi method add_observation (
    Int() $slave,
    Int() $master,
    $r_squared is rw,
    :$all = False
  ) {
    my uint64 ($s, $m) = ($slave, $master);
    my gdouble $rs = 0e0;

    my $rc = so gst_clock_add_observation($!c, $s, $m, $rs);
    $r_squared = $rs;
    $all.not ?? $r_squared !! ($r_squared, $rc);
  }

  method add_observation_unapplied (
    Int() $slave,
    Int() $master,
    Num() $r_squared,
    Int() $internal,
    Int() $external,
    Int() $rate_num,
    Int() $rate_denom
  )
    is also<add-observation-unapplied>
  {
    my ($s, $m, $i, $e, $rn, $rd) =
      ($slave, $master, $internal, $external, $rate_num, $rate_denom);
    my gdouble $rs = $r_squared;

    gst_clock_add_observation_unapplied($!c, $s, $m, $rs, $i, $e, $rn, $rd);
  }

  method adjust_unlocked (Int() $internal) is also<adjust-unlocked> {
    my uint64 $i = $internal;
    gst_clock_adjust_unlocked($!c, $i);
  }

  method adjust_with_calibration (
    Num() $internal_target,
    Num() $cinternal,
    Num() $cexternal,
    Num() $cnum,
    Num() $cdenom
  )
    is also<adjust-with-calibration>
  {
    my uint64 ($i, $ci, $ce, $cn, $cd) =
      ($internal_target, $cinternal, $cexternal, $cnum, $cdenom);

    gst_clock_adjust_with_calibration($!c, $i, $ci, $ce, $cn, $cd);
  }

  proto method get_calibration (|)
    is also<get-calibration>
  { * }

  multi method get_calibration is also<calibration> {
    my ($i, $e, $rn, $rd);

    samewith($i, $e, $rn, $rd)
  }
  multi method get_calibration (
    $internal   is rw,
    $external   is rw,
    $rate_num   is rw,
    $rate_denom is rw
  ) {
    my uint64 ($i, $e, $rn, $rd) = 0 xx 4;

    gst_clock_get_calibration($!c, $i, $e, $rn, $rd);
    ($internal, $external, $rate_num, $rate_denom) = ($i, $e, $rn, $rd);
  }

  method get_internal_time
    is also<
      get-internal-time
      internal_time
      internal-time
    >
  {
    gst_clock_get_internal_time($!c);
  }

  method get_time
    is also<
      get-time
      time
    >
  {
    gst_clock_get_time($!c);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_clock_get_type, $n, $t );
  }

  # method id_compare_func (gconstpointer $id2) {
  #   gst_clock_id_compare_func($!c, $id2);
  # }
  #
  # method id_get_clock {
  #   gst_clock_id_get_clock($!c);
  # }
  #
  # method id_get_time {
  #   gst_clock_id_get_time($!c);
  # }
  #
  # method id_ref {
  #   gst_clock_id_ref($!c);
  # }
  #
  # method id_unref {
  #   gst_clock_id_unref($!c);
  # }
  #
  # method id_unschedule {
  #   gst_clock_id_unschedule($!c);
  # }
  #
  # method id_uses_clock (GstClock $clock) {
  #   gst_clock_id_uses_clock($!c, $clock);
  # }
  #
  # method id_wait (GstClockTimeDiff $jitter) {
  #   gst_clock_id_wait($!c, $jitter);
  # }
  #
  # method id_wait_async (GstClockCallback $func, gpointer $user_data, GDestroyNotify $destroy_data) {
  #   gst_clock_id_wait_async($!c, $func, $user_data, $destroy_data);
  # }

  method is_synced is also<is-synced> {
    so gst_clock_is_synced($!c);
  }

  # method new_periodic_id (GstClockTime $start_time, GstClockTime $interval) {
  #   gst_clock_new_periodic_id($!c, $start_time, $interval);
  # }

  # method new_single_shot_id (GstClockTime $time) {
  #   gst_clock_new_single_shot_id($!c, $time);
  # }
  #
  # method periodic_id_reinit (
  #   GstClockID $id,
  #   GstClockTime $start_time,
  #   GstClockTime $interval
  # ) {
  #   gst_clock_periodic_id_reinit($!c, $id, $start_time, $interval);
  # }

  method set_calibration (
    Int() $internal    is rw,
    Int() $external    is rw,
    Int() $rate_num    is rw,
    Int() $rate_denom  is rw
  )
    is also<set-calibration>
  {
    my uint64 ($i, $e, $rn, $rd) =
      ($internal, $external, $rate_num, $rate_denom);

    gst_clock_set_calibration($!c, $i, $e, $rn, $rd);
  }

  method set_synced (Int() $synced) is also<set-synced> {
    my gboolean $s = $synced.so.Int;

    gst_clock_set_synced($!c, $s);
  }

  # method single_shot_id_reinit (GstClockID $id, GstClockTime $time) {
  #   gst_clock_single_shot_id_reinit($!c, $id, $time);
  # }

  method unadjust_unlocked (Int() $external) is also<unadjust-unlocked> {
    my uint64 $e = $external;

    gst_clock_unadjust_unlocked($!c, $e);
  }

  method unadjust_with_calibration (
    Int() $external_target,
    Int() $cinternal,
    Int() $cexternal,
    Int() $cnum,
    Int() $cdenom
  )
    is also<unadjust-with-calibration>
  {
    my ($e, $ci, $ce, $cn, $cd) =
      ($external_target, $cinternal, $cexternal, $cnum, $cdenom);

    gst_clock_unadjust_with_calibration($!c, $e, $ci, $ce, $cn, $cd);
  }

  method wait_for_sync (Int() $timeout) is also<wait-for-sync> {
    my uint64 $t = $timeout;

    gst_clock_wait_for_sync($!c, $t);
  }

}
