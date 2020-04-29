use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Video::TimeCode;

class GStreamer::Video::TimeCode {
  has GstVideoTimeCode $!tc;

  submethod BUILD (:$timecode) {
    $!tc = $timecode;
  }

  method GStreamer::Raw::Structs::GstVideoTimeCode
    is also<GstVideoTimeCode>
  { $!tc }

  multi method new (GstVideoTimeCode $timecode) {
    $timecode ?? self.bless( :$timecode ) !! Nil;
  }
  multi method new (
    Int() $fps_n,
    Int() $fps_d,
    GDateTime() $latest_daily_jam,
    Int() $flags,
    Int() $hours,
    Int() $minutes,
    Int() $seconds,
    Int() $frames,
    Int() $field_count
  ) {
    my guint ($n, $d, $h, $m, $s, $f, $fc) =
      ($fps_n, $fps_d, $hours, $minutes, $seconds, $frames, $field_count);
    my GDateTime $ldj = $latest_daily_jam;
    my GstVideoTimeCodeFlags $fl = $flags,
    my $timecode =
      gst_video_time_code_new($!tc, $n, $d, $ldj, $fl, $h, $m, $s, $f, $fc);

    $timecode ?? self.bless( :$timecode ) !! Nil;
  }

  method new_empty is also<new-empty> {
    my $timecode = gst_video_time_code_new_empty();

    $timecode ?? self.bless( :$timecode ) !! Nil;
  }

  method new_from_date_time_full (
    Int() $fps_n,
    Int() $fps_d,
    GDateTime() $dt,
    Int() $flags,
    Int() $field_count
  )
    is also<new-from-date-time-full>
  {
    my guint ($n, $d, $fc) = ($fps_n, $fps_d, $field_count);
    my GstVideoTimeCodeFlags $fl = $flags;
    my $timecode =
      gst_video_time_code_new_from_date_time_full($n, $d, $dt, $fl, $fc);

    $timecode ?? self.bless( :$timecode ) !! Nil;
  }

  method new_from_string (Str() $string) is also<new-from-string> {
    my $timecode = gst_video_time_code_new_from_string($string);

    $timecode ?? self.bless( :$timecode ) !! Nil;
  }

  method add_frames (Int() $frames) is also<add-frames> {
    my gint64 $f = $frames;

    gst_video_time_code_add_frames($!tc, $f);
  }

  method add_interval (GstVideoTimeCodeInterval() $tc_inter, :$raw = False)
    is also<add-interval>
  {
    my $tc = gst_video_time_code_add_interval($!tc, $tc_inter);

    $tc ??
      ( $raw ?? $tc !! GStreamer::Video::TimeCode.new($tc) )
      !!
      Nil
  }

  method clear {
    gst_video_time_code_clear($!tc);
  }

  method compare (GstVideoTimeCode() $tc2) {
    gst_video_time_code_compare($!tc, $tc2);
  }

  method copy (:$raw = False) {
    my $tc = gst_video_time_code_copy($!tc);

    $tc ??
      ( $raw ?? $tc !! GStreamer::Video::TimeCode.new($tc) )
      !!
      Nil
  }

  method frames_since_daily_jam is also<frames-since-daily-jam> {
    gst_video_time_code_frames_since_daily_jam($!tc);
  }

  multi method free {
    GStreamer::Video::TimeCode.free($!tc);
  }
  multi method free (
    GStreamer::Video::TimeCode:U:
    GstVideoTimeCode $tc
  ) {
    gst_video_time_code_free($tc);
  }

  method increment_frame is also<increment-frame> {
    gst_video_time_code_increment_frame($!tc);
  }

  multi method init (
    Int() $fps_n,
    Int() $fps_d,
    GDateTime() $latest_daily_jam,
    Int() $flags,
    Int() $hours,
    Int() $minutes,
    Int() $seconds,
    Int() $frames,
    Int() $field_count
  ) {
    samewith(
      $!tc,
      $fps_n,
      $fps_d,
      $latest_daily_jam,
      $flags,
      $hours,
      $minutes,
      $seconds,
      $frames,
      $field_count
    );
  }
  multi method init (
    GStreamer::Video::TimeCode:U:
    GstVideoTimeCode $tc,
    Int() $fps_n,
    Int() $fps_d,
    GDateTime() $latest_daily_jam,
    Int() $flags,
    Int() $hours,
    Int() $minutes,
    Int() $seconds,
    Int() $frames,
    Int() $field_count
  ) {
    my guint ($n, $d, $h, $m, $s, $f, $fc) =
      ($fps_n, $fps_d, $hours, $minutes, $seconds, $frames, $field_count);
    my GDateTime $ldj = $latest_daily_jam;
    my GstVideoTimeCodeFlags $fl = $flags,

    gst_video_time_code_init($!tc, $n, $d, $ldj, $fl, $h, $m, $s, $f, $fc);
  }

  proto method init_from_date_time_full (|)
    is also<init-from-date-time-full>
  { * }

  multi method init_from_date_time_full (
    Int() $fps_n,
    Int() $fps_d,
    GDateTime() $dt,
    Int() $flags,
    Int() $field_count
  ) {
    GStreamer::Video::TimeCode.init_from_date_time_full(
      $!tc,
      $fps_n,
      $fps_d,
      $dt,
      $flags,
      $field_count
    );
  }
  multi method init_from_date_time_full (
    GStreamer::Video::TimeCode:U:
    GstVideoTimeCode $tc,
    Int() $fps_n,
    Int() $fps_d,
    GDateTime() $dt,
    Int() $flags,
    Int() $field_count
  ) {
    my gint ($n, $d, $fc) = ($fps_n, $fps_d, $fc);
    my GstVideoTimeCodeFlags $fl = $flags;

    gst_video_time_code_init_from_date_time_full($tc, $n, $d, $dt, $fl, $fc);

  }
  method is_valid is also<is-valid> {
    so gst_video_time_code_is_valid($!tc);
  }

  method nsec_since_daily_jam is also<nsec-since-daily-jam> {
    gst_video_time_code_nsec_since_daily_jam($!tc);
  }

  method to_date_time (:$raw = False) is also<to-date-time> {
    my $dt = gst_video_time_code_to_date_time($!tc);

    $dt ??
      ( $raw ?? $dt !! GLib::DateTime.new($dt) )
      !!
      Nil
  }

  method to_string
    is also<
      to-string
      Str
    >
  {
    gst_video_time_code_to_string($!tc);
  }

}

class GStreamer::Video::TimeCode::Interval {
  has GstVideoTimeCodeInterval $!tci;

  submethod BUILD (:$interval) {
    $!tci = $interval;
  }

  method GStreamer::Raw::Structs::GstVideoTimeCodeInterval
    is also<GstVideoTimeCodeInterval>
  { $!tci }

  method new (
    Int() $hours,
    Int() $minutes,
    Int() $seconds,
    Int() $frames
  ) {
    my guint ($h, $m, $s, $f) = ($hours, $minutes, $seconds, $frames);
    my $interval = gst_video_time_code_interval_new($h, $m, $s, $f);

    $interval ?? self.bless( :$interval ) !! Nil;
  }

  method new_from_string (Str() $string) is also<new-from-string> {
    my $interval = gst_video_time_code_interval_new_from_string($string);

    $interval ?? self.bless( :$interval ) !! Nil;
  }

  method clear {
    gst_video_time_code_interval_clear($!tci);
  }

  method copy (:$raw = False) {
    my $i = gst_video_time_code_interval_copy($!tci);

    $i ??
      ( $raw ?? $i !! GStreamer::Video::TimeCode::Interval.new($i) )
      !!
      Nil;
  }

  multi method free {
    GStreamer::Video::TimeCode::Interval.free($!tci)
  }
  multi method free (
    GStreamer::Video::TimeCode::Interval:U:
    GstVideoTimeCodeInterval $i
  ) {
    gst_video_time_code_interval_free($!tci);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &gst_video_time_code_interval_get_type,
      $n,
      $t
    );
  }

  multi method init (
    Int() $hours,
    Int() $minutes,
    Int() $seconds,
    Int() $frames
  ) {
    samewith($!tci, $hours, $minutes, $seconds, $frames);
  }
  multi method init (
    GStreamer::Video::TimeCode::Interval:U:
    GstVideoTimeCodeInterval $tci,
    Int() $hours,
    Int() $minutes,
    Int() $seconds,
    Int() $frames
  ) {
    my guint ($h, $m, $s, $f) = ($hours, $minutes, $seconds, $frames);

    gst_video_time_code_interval_init($tci, $h, $m, $s, $f);
  }

}
