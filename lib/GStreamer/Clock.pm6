use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Clock;

use GStreamer::Object;

use GLib::Roles::Signals::Generic;

our subset GstClockAncestry is export of Mu
  where GstClock | GstObject;

class GStreamer::Clock::ID { ... }

class GStreamer::Clock is GStreamer::Object {
  also does GLib::Roles::Signals::Generic;

  has GstClock $!c;

  submethod BUILD (:$clock) {
    self.setClock($clock) if $clock.defined;
  }

  method setClock(GstClockAncestry $clock) {
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

  method new (GstClockAncestry $clock) {
    $clock ?? self.bless(:$clock) !! Nil;
  }

  # Signature: GstClock, gboolean, gpointer
  method synced {
    self.connect-uint('synced');
  }

  # Type: gint
  method window-size is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('window-size', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_INT );
        $gv.int = $val;
        self.prop_set('window-size', $gv);
      }
    );
  }

  # Type: gint
  method window-threshold is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('window-threshold', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_INT );
        $gv.int = $val;
        self.prop_set('window-threshold', $gv);
      }
    );
  }

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
  ) {
    my $rv = samewith($slave, $master, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method add_observation (
    Int() $slave,
    Int() $master,
    $r_squared is rw,
    :$all = False
  ) {
    my uint64 ($s, $m) = ($slave, $master);
    my gdouble $rs = 0e0;

    my $rv = so gst_clock_add_observation($!c, $s, $m, $rs);
    $r_squared = $rs;
    $all.not ?? $rv !! ($rv, $r_squared);
  }

  proto method add_observation_unapplied (|)
    is also<add-observation-unapplied>
  { * }

  multi method add_observation_unapplied (
    Int() $slave,
    Int() $master
  ) {
    my $rv = callwith($slave, $master, $, $, $, $, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method add_observation_unapplied (
    Int() $slave,
    Int() $master,
    $r_squared  is rw,
    $internal   is rw,
    $external   is rw,
    $rate_num   is rw,
    $rate_denom is rw,
    :$all = False
  )
  {
    my GstClockTime ($s, $m) = ($slave, $master);
    my GstClockTime ($i, $e, $rn, $rd) = 0 xx 4;
    my gdouble $rs = 0e0;

    my &aou = &gst_clock_add_observation_unapplied;
    my $rv = &aou($!c, $s, $m, $rs, $i, $e, $rn, $rd);

    ($internal, $external, $rate_num, $rate_denom) = ($i, $e, $rn, $rd);
    $all.not ?? $rv !! ($rv, $internal, $external, $rate_num, $rate_denom);
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
    samewith($, $, $, $)
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

  method is_synced is also<is-synced> {
    so gst_clock_is_synced($!c);
  }

  multi method set_calibration (
    Int() $internal,
    Int() $external,
    Int() $rate_num,
    Int() $rate_denom
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

  # cw: This interface is not yet fixed
  multi method create_single_shot_id (:$in is required, :$raw = False) {
    self.creater_single_shot_id($in, :$raw, :delta);
  }
  multi method create_single_shot_id (
    Int() $time is copy,
    :$raw = False,
    :$delta = False
  )
    is also<create-single-shot-id>
  {
    $time += self.time unless $delta;
    my $cid = GStreamer::Clock::ID.new_single_shot_id($!c, $time);

    $cid ??
      ( $raw ?? $cid.GstClockID !! $cid )
      !!
      Nil;
  }

  method create_periodic_id (Int() $start_time, Int() $interval, :$raw = False)
    is also<create-periodic-id>
  {
    my $cid = GStreamer::Clock::ID.new_periodic_id($!c, $start_time, $interval);

    $cid ??
      ( $raw ?? $cid.GstClockID !! $cid )
      !!
      Nil;
  }

}

class GStreamer::Clock::ID {
  has GstClockID $!cid;
  has $!periodic = False;

  submethod BUILD (:$clock-id, :$periodic = False) {
    $!cid = $clock-id;
    $!periodic = $periodic;
  }

  method GStreamer::Raw::Definitions::GstClockID
    is also<GstClockID>
  { $!cid }

  method new (GstClockID $clock-id, :$periodic = Nil) {
    $clock-id ?? self.bless( :$clock-id, :$periodic ) !! Nil;
  }

  method new_periodic_id (
    GstClock() $clock,
    Int() $start_time,
    Int() $interval
  )
    is also<new-periodic-id>
  {
    my GstClockTime ($st, $i) = ($start_time, $interval);
    my $clock-id = gst_clock_new_periodic_id($clock, $st, $i);

    $clock-id ?? self.bless( :$clock-id, :periodic ) !! Nil;
  }

  method new_single_shot_id (GstClock() $clock, Int() $time)
    is also<new-single-shot-id>
  {
    my GstClockTime $t = $time;
    my $clock-id = gst_clock_new_single_shot_id($clock, $t);

    $clock-id ?? self.bless( :$clock-id ) !! Nil;
  }

  method periodic_id_reinit (
    Int() $start_time,
    Int() $interval
  )
    is also<periodic-id-reinit>
  {
    unless $!periodic {
      warn 'ClockID is not periodic. Skipping...';
      return;
    }

    my GstClockTime ($st, $i) = ($start_time, $interval);

    so gst_clock_periodic_id_reinit(
      self.get_clock(:raw),
      $!cid,
      $start_time,
      $interval
    );
  }

  method single_shot_id_reinit (GstClockID $id, Int() $time)
    is also<single-shot-id-reinit>
  {
    if $!periodic {
      warn 'ClockID is periodic. Skipping...';
      return;
    }
    my GstClockTime $t = $time;

    so gst_clock_single_shot_id_reinit(
      self.get_clock(:raw),
      $!cid,
      $time
    );
  }

  method compare_func (GstClockID $id2) is also<compare-func> {
    gst_clock_id_compare_func($!cid, $id2);
  }

  method get_clock (:$raw = False)
    is also<
      get-clock
      clock
    >
  {
    my $c = gst_clock_id_get_clock($!cid);

    $c ??
      ( $raw ?? $c !! GStreamer::Clock.new($c) )
      !!
      Nil;
  }

  method get_time
    is also<
      get-time
      time
    >
  {
    gst_clock_id_get_time($!cid);
  }

  method ref {
    gst_clock_id_ref($!cid);
    self
  }

  method unref {
    gst_clock_id_unref($!cid);
  }

  method unschedule {
    gst_clock_id_unschedule($!cid);
  }

  method uses_clock (GstClock() $clock) is also<uses-clock> {
    so gst_clock_id_uses_clock($!cid, $clock);
  }

  multi method wait {
    samewith($);
  }
  multi method wait ($jitter is rw) {
    my GstClockTimeDiff $j = 0;
    my $wr = gst_clock_id_wait($!cid, $j);

    ( GstClockReturnEnum($wr), $jitter = $j );
  }

  method wait_async (
    &func,
    gpointer $user_data          = gpointer,
    GDestroyNotify $destroy_data = gpointer
  )
    is also<wait-async>
  {
    GstClockReturnEnum(
      gst_clock_id_wait_async($!cid, &func, $user_data, $destroy_data)
    )
  }

}
