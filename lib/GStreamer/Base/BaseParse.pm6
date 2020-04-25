use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Base::BaseParse;

use GStreamer::Element;

our subset GstBaseParseAncestry is export of Mu
  where GstBaseParse | GstElementAncestry;

class GStreamer::Base::BaseParse is GStreamer::Element {
  has GstBaseParse $!bp;

  submethod BUILD (:$aggregator-pad) {
    self.setBaseParse($aggregator-pad);
  }

  method setBaseParse(GstBaseParseAncestry $_) {
    my $to-parent;

    $!bp = do  {
      when GstBaseParse {
        $to-parent = cast(GstElement, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstBaseParse, $_);
      }
    }
    self.setGstElement($to-parent);
  }

  method GStreamer::Raw::Structs::GstBaseParse
    is also<GstBaseParse>
  { $!bp }

  method new (GstBaseParseAncestry $base-parse ) {
    $base-parse ?? self.bless( :$base-parse ) !! Nil;
  }

  # Type: gboolean
  method disable_passthrough is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('disable_passthrough', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_BOOLEAN );
        $gv.boolean = $val;
        self.prop_set('disable_passthrough', $gv);
      }
    );
  }

  method add_index_entry (
    Int() $offset,
    Int() $ts,
    Int() $key,
    Int() $force
  )
    is also<add-index-entry>
  {
    my guint64 $o = $offset;
    my GstClockTime $t = $ts;
    my gboolean ($k, $f) = ($key, $force).map( *.so.Int );

    so gst_base_parse_add_index_entry($!bp, $o, $t, $k, $f);
  }

  proto method convert_default (|)
      is also<convert-default>
  { * }

  multi method convert_default (
    Int() $src_format,
    Int() $src_value,
    Int() $dest_format
  ) {
    my $rv = samewith($src_format, $src_value, $dest_format, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method convert_default (
    Int() $src_format,
    Int() $src_value,
    Int() $dest_format,
    $dest_value is rw,
    :$all = False
  ) {
    my GstFormat ($sf, $df) = ($src_format, $dest_format);
    my guint64 ($sv, $dv) = ($src_value, 0);

    my $rv = so gst_base_parse_convert_default($!bp, $sf, $sv, $df, $dv);
    $dest_value = $dv;
    $all.not ?? $rv !! ($rv, $dest_value);
  }

  method drain {
    gst_base_parse_drain($!bp);
  }

  method finish_frame (GstBaseParseFrame() $frame, Int() $size)
    is also<finish-frame>
  {
    my gint $s = $size;

    GstFlowReturnEnum( gst_base_parse_finish_frame($!bp, $frame, $s) );
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_base_parse_get_type, $n, $t );
  }

  proto method merge_tags (|)
      is also<merge-tags>
  { * }

  multi method merge_tags (Int() $mode) {
    samewith(GstTagList, $mode);
  }
  multi method merge_tags (GstTagList() $tags, Int() $mode) {
    my GstTagMergeMode $m = $mode;

    gst_base_parse_merge_tags($!bp, $tags, $m);
  }

  method push_frame (GstBaseParseFrame() $frame) is also<push-frame> {
    GstFlowReturnEnum( gst_base_parse_push_frame($!bp, $frame) );
  }

  method set_average_bitrate (Int() $bitrate) is also<set-average-bitrate> {
    my guint $b = $bitrate;

    gst_base_parse_set_average_bitrate($!bp, $b);
  }

  method set_duration (Int() $fmt, Int() $duration, Int() $interval)
    is also<set-duration>
  {
    my GstFormat $f = $fmt;
    my gint64 $d = $duration;
    my gint $i = $interval;

    gst_base_parse_set_duration($!bp, $f, $d, $i);
  }

  method set_frame_rate (
    Int() $fps_num,
    Int() $fps_den,
    Int() $lead_in,
    Int() $lead_out
  )
    is also<set-frame-rate>
  {
    my gint ($fn, $fd, $li, $lo) = ($fps_num, $fps_den, $lead_in, $lead_out);

    gst_base_parse_set_frame_rate($!bp, $fn, $fd, $li, $lo);
  }

  method set_has_timing_info (Int() $has_timing) is also<set-has-timing-info> {
    my gboolean $h = $has_timing.so.Int;

    gst_base_parse_set_has_timing_info($!bp, $h);
  }

  method set_infer_ts (Int() $infer_ts) is also<set-infer-ts> {
    my gboolean $i = $infer_ts.so.Int;

    gst_base_parse_set_infer_ts($!bp, $i);
  }

  method set_latency (Int() $min_latency, Int() $max_latency)
    is also<set-latency>
  {
    my GstClockTime ($mnl, $mxl) = ($min_latency, $max_latency);

    gst_base_parse_set_latency($!bp, $mnl, $mxl);
  }

  method set_min_frame_size (Int() $min_size) is also<set-min-frame-size> {
    my guint $m = $min_size;

    gst_base_parse_set_min_frame_size($!bp, $m);
  }

  method set_passthrough (Int() $passthrough) is also<set-passthrough> {
    my gboolean $p = $passthrough.so.Int;

    gst_base_parse_set_passthrough($!bp, $p);
  }

  method set_pts_interpolation (Int() $pts_interpolate)
    is also<set-pts-interpolation>
  {
    my gboolean $p = $pts_interpolate.so.Int;

    gst_base_parse_set_pts_interpolation($!bp, $p);
  }

  method set_syncable (gboolean $syncable) is also<set-syncable> {
    my gboolean $s = $syncable.so.Int;

    gst_base_parse_set_syncable($!bp, $s);
  }

  method set_ts_at_offset (Int() $offset) is also<set-ts-at-offset> {
    my gsize $o = $offset;

    gst_base_parse_set_ts_at_offset($!bp, $o);  }

}


class GStreamer::Base::BaseParseFrame {
  has GstBaseParseFrame $!bpf;

  method GStreamer::Raw::Structs::GstBaseParseFrame
    is also<GstBaseParseFrame>
  { $!bpf }

  multi method new (GstBaseParseFrame $parse-frame) {
    $parse-frame ?? self.bless( :$parse-frame ) !! Nil;
  }
  multi method new (GstBuffer() $buffer, Int() $flags, Int() $overhead) {
    my GstBaseParseFrameFlags $f = $flags;
    my gint $o = $overhead;
    my $parse-frame = gst_base_parse_frame_new($buffer, $f, $o);

    $parse-frame ?? self.bless( :$parse-frame ) !! Nil;
  }

  method copy (:$raw = False) {
    my $c = gst_base_parse_frame_copy($!bpf);

    $c ??
      ( $raw ?? $c !! GStreamer::Base::BaseParseFrame.new($c) )
      !!
      Nil;
  }

  method free {
    gst_base_parse_frame_free($!bpf);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_base_parse_frame_get_type, $n, $t );
  }

  method init (GStreamer::Base::BaseParseFrame:U: GstBaseParseFrame $f) {
    gst_base_parse_frame_init($f);
  }

}
