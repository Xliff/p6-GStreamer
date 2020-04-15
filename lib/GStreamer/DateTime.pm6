use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::DateTime;

use GLib::DateTime;

# BOXED

class GStreamer::DateTime {
  has GstDateTime $!dt;

  submethod BUILD (:$datetime) {
    $!dt = $datetime;
  }

  method GStreamer::Raw::Types::GstDateTime
    is also<GstDateTime>
  { $!dt }

  multi method new (GstDateTime $datetime) {
    $datetime ?? self.bless( :$datetime ) !! Nil;
  }
  multi method new (
    Num() $tzoffset,
    Int() $year,
    Int() $month,
    Int() $day,
    Int() $hour,
    Int() $minute,
    Num() $seconds
  ) {
    my gfloat $tz = $tzoffset;
    my gint ($y, $m, $d, $h, $mn) =
      ($year, $month, $day, $hour, $minute, $seconds);
    my gdouble $s = $seconds;
    my $datetime = gst_date_time_new($tz, $y, $m, $d, $h, $mn, $s);

    $datetime ?? self.bless( :$datetime ) !! Nil;
  }

  method new_from_g_date_time (GDateTime() $dt) is also<new-from-g-date-time> {
    my $datetime = gst_date_time_new_from_g_date_time($dt);

    $datetime ?? self.bless( :$datetime ) !! Nil;
  }

  method new_from_iso8601_string (Str() $datestr)
    is also<new-from-iso8601-string>
  {
    my $datetime = gst_date_time_new_from_iso8601_string($datestr);

    $datetime ?? self.bless( :$datetime ) !! Nil;
  }

  method new_from_unix_epoch_local_time (Int() $local-epoch)
    is also<new-from-unix-epoch-local-time>
  {
    my gint64 $le = $local-epoch;
    my $datetime = gst_date_time_new_from_unix_epoch_local_time($le);

    $datetime ?? self.bless( :$datetime ) !! Nil;
  }

  method new_from_unix_epoch_utc (Int() $epoch)
    is also<new-from-unix-epoch-utc>
  {
    my gint64 $e = $epoch;
    my $datetime = gst_date_time_new_from_unix_epoch_utc($e);

    $datetime ?? self.bless( :$datetime ) !! Nil;
  }

  method new_local_time (
    Int() $year,
    Int() $month,
    Int() $day,
    Int() $hour,
    Int() $minute,
    Num() $seconds
  )
    is also<new-local-time>
  {
    my gint ($y, $m, $d, $h, $mn) = ($year, $month, $day, $hour, $minute);
    my gdouble $s = $seconds;
    my $datetime = gst_date_time_new_local_time($y, $m, $d, $h, $mn, $s);

    $datetime ?? self.bless( :$datetime ) !! Nil;
  }

  method new_now_local_time is also<new-now-local-time> {
    my $datetime = gst_date_time_new_now_local_time();

    $datetime ?? self.bless( :$datetime ) !! Nil;
  }

  method new_now_utc is also<new-now-utc> {
    my $datetime = gst_date_time_new_now_utc();

    $datetime ?? self.bless( :$datetime ) !! Nil;
  }

  method new_y (Int() $y) is also<new-y> {
    my $datetime = gst_date_time_new_y($y);

    $datetime ?? self.bless( :$datetime ) !! Nil;
  }

  method new_ym (Int() $year, Int() $month) is also<new-ym> {
    my gint ($y, $m) = ($year, $month);
    my $datetime = gst_date_time_new_ym($y, $m);

    $datetime ?? self.bless( :$datetime ) !! Nil;
  }

  method new_ymd (Int() $year, Int() $month, Int() $day) is also<new-ymd> {
    my gint ($y, $m, $d) = ($year, $month, $day);
    my $datetime = gst_date_time_new_ymd($!dt, $y, $m, $d);

    $datetime ?? self.bless( :$datetime ) !! Nil;
  }

  method get_day
    is also<
      get-day
      day
    >
  {
    gst_date_time_get_day($!dt);
  }

  method get_hour
    is also<
      get-hour
      hour
      hr
    >
  {
    gst_date_time_get_hour($!dt);
  }

  method get_microsecond
    is also<
      get-microsecond
      microsecond
      μsecond
      μsec
    >
  {
    gst_date_time_get_microsecond($!dt);
  }

  method get_minute
    is also<
      get-minute
      minute
      min
    >
  {
    gst_date_time_get_minute($!dt);
  }

  method get_month
    is also<
      get-month
      month
      mon
    >
  {
    gst_date_time_get_month($!dt);
  }

  method get_second
    is also<
      get-second
      second
      sec
    >
  {
    gst_date_time_get_second($!dt);
  }

  method get_time_zone_offset
    is also<
      get-time-zone-offset
      time_zone_offset
      time-zone-offset
      tz
    >
  {
    gst_date_time_get_time_zone_offset($!dt);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_date_time_get_type, $n, $t );
  }

  method get_year
    is also<
      get-year
      year
    >
  {
    gst_date_time_get_year($!dt);
  }

  method has_day is also<has-day> {
    so gst_date_time_has_day($!dt);
  }

  method has_month is also<has-month> {
    so gst_date_time_has_month($!dt);
  }

  method has_second is also<has-second> {
    so gst_date_time_has_second($!dt);
  }

  method has_time is also<has-time> {
    so gst_date_time_has_time($!dt);
  }

  method has_year is also<has-year> {
    so gst_date_time_has_year($!dt);
  }

  method ref is also<upref> {
    gst_date_time_ref($!dt);
    self;
  }

  method to_g_date_time (:$raw = False) is also<to-g-date-time> {
    my $gdt = gst_date_time_to_g_date_time($!dt);

    $gdt ??
      ( $raw ?? $gdt !! GLib::DateTime.new($gdt) )
      !!
      Nil;
  }

  method to_iso8601_string is also<to-iso8601-string> {
    gst_date_time_to_iso8601_string($!dt);
  }

  method unref is also<downref> {
    gst_date_time_unref($!dt);
  }

}
