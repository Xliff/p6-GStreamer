use v6.c;


use GStreamer::Raw::Types;
use GStreamer::Raw::Segment;

class GStreamer::Segment {
  has GstSegment $!s;

  submethod BUILD (:$segment) {
    $!s = $segment;
  }

  method GStreamer::Raw::Types::GstSegment
  { $!s }

  multi method new (GstSegment $segment) {
    self.bless( :$segment );
  }
  multi method new {
    self.bless( segment => gst_segment_new() );
  }

  proto method clip (|)
  { * }

  multi method clip (Int() $format, Int() $start, Int() $stop) {
    samewith($format, $start, $stop, $, $);
  }
  multi method clip (
    Int() $format,
    Int() $start,
    Int() $stop,
    $clip_start is rw,
    $clip_stop  is rw
  ) {
    my GstFormat $f = $format;
    my guint ($st, $sp) = ($start, $stop);
    my guint64 ($cst, $csp) = 0 xx 2;
    my $rc = gst_segment_clip($!s, $f, $st, $sp, $cst, $csp);

    ($clip_start, $clip_stop) = ($cst, $csp);
    ($clip_start, $clip_stop, $rc);
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

  method copy_into (GstSegment() $dest) {
    gst_segment_copy_into($!s, $dest);
  }

  proto method do_seek (|)
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
    samewith(
      $rate,
      $format,
      $flags,
      $start_type,
      $start,
      $stop_type,
      $stop,
      $,
      :$all
    );
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
    my $rc = gst_segment_do_seek($!s, $r, $fo, $fl, $stt, $st, $spt, $sp, $u);

    $update = $u;
    $all.not ?? $update !! ($update, $rc);
  }

  multi method free {
    GStreamer::Segment.free($!s);
  }
  multi method free (GStreamer::Segment:U: GstSegment $f) {
    gst_segment_free($f);
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_segment_get_type, $n, $t );
  }

  method init (GStreamer::Segment:U: GstSegment() $tr, GstFormat $format) {
    my GstFormat $f = $format;

    gst_segment_init($tr, $f);
  }

  proto method is_equal (|)
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

  method offset_running_time (Int() $format, Int() $offset) {
    my GstFormat $f = $format;
    my gint64 $o = $offset;

    gst_segment_offset_running_time($!s, $f, $o);
  }

  method position_from_running_time (Int() $format, Int() $running_time) {
    my GstFormat $f = $format;
    my gint64 $rt = $running_time;

    gst_segment_position_from_running_time($!s, $f, $rt);
  }

  proto method position_from_running_time_full (|)
  { * }

  multi method position_from_running_time_full (
    Int() $format,
    Int() $running_time,
    :$all = False
  ) {
    samewith($format, $running_time, $, :$all);
  }
  multi method position_from_running_time_full (
    GstFormat $format,
    guint64 $running_time,
    $position is rw,
    :$all = False
  ) {
    my GstFormat $f = $format;
    my gint64 ($rt, $p) = ($running_time, 0);
    my $rc = gst_segment_position_from_running_time_full($!s, $f, $rt, $p);

    $position = $p;
    $all.not ?? $position !! ($position, $rc);
  }

  method position_from_stream_time (
    Int() $format,
    Int() $stream_time
  ) {
    my GstFormat $f = $format;
    my gint64 $st = $stream_time;

    gst_segment_position_from_stream_time($!s, $f, $st);
  }

  proto method position_from_stream_time_full (|)
  { * }

  multi method position_from_stream_time_full (
    Int() $format,
    Int() $stream_time,
    :$all = False
  ) {
    samewith($format, $stream_time, $, :$all);
  }
  multi method position_from_stream_time_full (
    Int() $format,
    Int() $stream_time,
    $position is rw,
    :$all = False
  ) {
    my GstFormat $f = $format;
    my gint64 ($st, $p) = ($stream_time, 0);
    my $rc = gst_segment_position_from_stream_time_full($!s, $f, $st, $p);

    $position = $p;
    $all.not ?? $position !! ($position, $rc);
  }

  method set_running_time (Int() $format, Int() $running_time) {
    my GstFormat $f = $format;
    my guint64 $rt = $running_time;

    gst_segment_set_running_time($!s, $f, $rt);
  }

  method to_running_time (Int() $format, Int() $position) {
    my GstFormat $f = $format;
    my guint64 $p = $position;

    gst_segment_to_running_time($!s, $f, $p);
  }

  proto method to_running_time_full (|)
  { * }

  multi method to_running_time_full (
    Int() $format,
    Int() $position,
    :$all = False
  ) {
    samewith($format, $position, $, :$all);
  }
  multi method to_running_time_full (
    GstFormat $format,
    guint64 $position,
    $running_time is rw,
    $all = False;
  ) {
    my GstFormat $f = $format;
    my guint64 ($p, $rt) = ($position, 0);
    my $rc = gst_segment_to_running_time_full($!s, $format, $position, $rt);

    $running_time = $rt;
    $all.not ?? $running_time !! ($running_time, $rc);
  }

  method to_stream_time (Int() $format, Int() $position) {
    my GstFormat $f = $format;
    my guint64 $p = $position;

    gst_segment_to_stream_time($!s, $f, $p);
  }

  proto method to_stream_time_full (|)
  { * }

  multi method to_stream_time_full (
    Int() $format,
    Int() $position,
    :$all = False
  ) {
    samewith($format, $position, $, :$all);
  }
  multi method to_stream_time_full (
    Int() $format,
    Int() $position,
    Int() $stream_time,
    :$all = False
  ) {
    my GstFormat $f = $format;
    my guint64 ($p, $st) = ($position, 0);
    my $rc = gst_segment_to_stream_time_full($!s, $f, $p, $st);

    $stream_time = $st;
    $all.not ?? $stream_time !! ($stream_time, $rc);
  }

}
