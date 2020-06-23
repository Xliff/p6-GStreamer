use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Segment;

class GStreamer::Segment {
  has GstSegment $!s;

  submethod BUILD (:$segment) {
    $!s = $segment;
  }

  method GStreamer::Raw::Structs::GstSegment
    is also<GstSegment>
  { $!s }

  multi method new (GstSegment $segment) {
    $segment ?? self.bless( :$segment ) !! Nil;
  }
  multi method new {
    my $segment = gst_segment_new();

    $segment ?? self.bless( :$segment ) !! Nil;
  }

  proto method clip (|)
  { * }

  multi method clip (Int() $format, Int() $start, Int() $stop) {
    my $rv = callwith($format, $start, $stop, $, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method clip (
    Int() $format,
    Int() $start,
    Int() $stop,
    $clip_start is rw,
    $clip_stop  is rw,
    :$all = False;
  ) {
    my GstFormat $f = $format;
    my guint ($st, $sp) = ($start, $stop);
    my guint64 ($cst, $csp) = 0 xx 2;
    my $rv = gst_segment_clip($!s, $f, $st, $sp, $cst, $csp);

    ($clip_start, $clip_stop) = ($cst, $csp);

    $all.not ?? $rv !! ($rv, $clip_start, $clip_stop);
  }

  multi method copy (:$raw = False) {
    GStreamer::Segment.copy($!s, :$raw);
  }
  multi method copy (GStreamer::Segment:U: GstSegment() $c, :$raw = False) {
    my $sc = gst_segment_copy($c);

    $sc ??
      ( $raw ?? $sc !! GStreamer::Segment.new($sc) )
      !!
      Nil;
  }

  method copy_into (GstSegment() $dest) is also<copy-into> {
    gst_segment_copy_into($!s, $dest);
  }

  proto method do_seek (|)
      is also<do-seek>
  { * }

  multi method do_seek (
    Num() $rate,
    Int() $format,
    Int() $flags,
    Int() $start_type,
    Int() $start,
    Int() $stop_type,
    Int() $stop,
    :$all = False;
  ) {
    my $rv = callwith(
      $rate,
      $format,
      $flags,
      $start_type,
      $start,
      $stop_type,
      $stop,
      $,
      :all
    );

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method do_seek (
    Num() $rate,
    Int() $format,
    Int() $flags,
    Int() $start_type,
    Int() $start,
    Int() $stop_type,
    Int() $stop,
    $update is rw,
    :$all = False
  ) {
    my gdouble $r = 0e0;
    my GstFormat $fo = 0;
    my GstSeekFlags $fl = 0;
    my GstSeekType ($stt, $spt) = 0 xx 2;
    my guint64 ($st, $sp) = 0 xx 2;
    my gboolean $u = 0;

    # Done for two lines rather than too-many.
    my &ds := &gst_segment_do_seek;
    my $rv = so &ds($!s, $r, $fo, $fl, $stt, $st, $spt, $sp, $u);

    $update = $u;
    $all.not ?? $rv !! ($rv, $update);
  }

  multi method free {
    GStreamer::Segment.free($!s);
  }
  multi method free (GStreamer::Segment:U: GstSegment $f) {
    gst_segment_free($f);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_segment_get_type, $n, $t );
  }

  method init (GStreamer::Segment:U: GstSegment() $tr, GstFormat $format) {
    my GstFormat $f = $format;

    gst_segment_init($tr, $f);
  }

  proto method is_equal (|)
      is also<is-equal>
  { * }

  multi method is_equal (GstSegment $s2) {
    GStreamer::Segment.is_equal($!s, $s2)
  }
  multi method is_equal (
    GStreamer::Segment:U:
    GstSegment() $s1, GstSegment() $s2
  ) {
    so gst_segment_is_equal($s1, $s1);
  }

  method offset_running_time (Int() $format, Int() $offset)
    is also<offset-running-time>
  {
    my GstFormat $f = $format;
    my gint64 $o = $offset;

    gst_segment_offset_running_time($!s, $f, $o);
  }

  method position_from_running_time (Int() $format, Int() $running_time)
    is also<position-from-running-time>
  {
    my GstFormat $f = $format;
    my gint64 $rt = $running_time;

    gst_segment_position_from_running_time($!s, $f, $rt);
  }

  proto method position_from_running_time_full (|)
      is also<position-from-running-time-full>
  { * }

  multi method position_from_running_time_full (
    Int() $format,
    Int() $running_time,
  ) {
    my $rv = callwith($format, $running_time, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method position_from_running_time_full (
    GstFormat $format,
    guint64 $running_time,
    $position is rw,
    :$all = False
  ) {
    my GstFormat $f = $format;
    my gint64 ($rt, $p) = ($running_time, 0);
    my $rv = so gst_segment_position_from_running_time_full($!s, $f, $rt, $p);

    $position = $p;
    $all.not ?? $rv !! ($rv, $position);
  }

  method position_from_stream_time (
    Int() $format,
    Int() $stream_time
  )
    is also<position-from-stream-time>
  {
    my GstFormat $f = $format;
    my gint64 $st = $stream_time;

    gst_segment_position_from_stream_time($!s, $f, $st);
  }

  proto method position_from_stream_time_full (|)
      is also<position-from-stream-time-full>
  { * }

  multi method position_from_stream_time_full (
    Int() $format,
    Int() $stream_time,
  ) {
    my $rv = callwith($format, $stream_time, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method position_from_stream_time_full (
    Int() $format,
    Int() $stream_time,
    $position is rw,
    :$all = False
  ) {
    my GstFormat $f = $format;
    my gint64 ($st, $p) = ($stream_time, 0);
    my $rv = so gst_segment_position_from_stream_time_full($!s, $f, $st, $p);

    $position = $p;
    $all.not ?? $rv !! ($rv, $position);
  }

  method set_running_time (Int() $format, Int() $running_time)
    is also<set-running-time>
  {
    my GstFormat $f = $format;
    my guint64 $rt = $running_time;

    gst_segment_set_running_time($!s, $f, $rt);
  }

  method to_running_time (Int() $format, Int() $position)
    is also<to-running-time>
  {
    my GstFormat $f = $format;
    my guint64 $p = $position;

    gst_segment_to_running_time($!s, $f, $p);
  }

  proto method to_running_time_full (|)
      is also<to-running-time-full>
  { * }

  multi method to_running_time_full (
    Int() $format,
    Int() $position,
  ) {
    my $rv = callwith($format, $position, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method to_running_time_full (
    GstFormat $format,
    guint64 $position,
    $running_time is rw,
    $all = False;
  ) {
    my GstFormat $f = $format;
    my guint64 ($p, $rt) = ($position, 0);
    my $rv = so gst_segment_to_running_time_full($!s, $format, $position, $rt);

    $running_time = $rt;
    $all.not ?? $rv !! ($rv, $running_time);
  }

  method to_stream_time (Int() $format, Int() $position)
    is also<to-stream-time>
  {
    my GstFormat $f = $format;
    my guint64 $p = $position;

    gst_segment_to_stream_time($!s, $f, $p);
  }

  proto method to_stream_time_full (|)
      is also<to-stream-time-full>
  { * }

  multi method to_stream_time_full (
    Int() $format,
    Int() $position,
  ) {
    samewith($format, $position, $, :all);
  }
  multi method to_stream_time_full (
    Int() $format,
    Int() $position,
    $stream_time is rw,
    :$all = False
  ) {
    my GstFormat $f = $format;
    my guint64 ($p, $st) = ($position, 0);
    my $rv = so gst_segment_to_stream_time_full($!s, $f, $p, $st);

    $stream_time = $st;
    $all.not ?? $rv !! ($rv, $stream_time);
  }

}
