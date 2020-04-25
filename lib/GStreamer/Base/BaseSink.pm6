use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Base::BaseSink;

use GStreamer::Element;
use GStreamer::Sample;
use GStreamer::Structure;

our subset GstBaseSinkAncestry is export of Mu
  where GstBaseSink | GstElementAncestry;

class GStreamer::Base::BaseSink is GStreamer::Element {
  has GstBaseSink $!bs;

  submethod BUILD (:$base-sink) {
    self.setGstBaseSink($base-sink);
  }

  method setGstBaseSink(GstBaseSinkAncestry $_) {
    my $to-parent;

    $!bs = do {
      when GstBaseSink {
        $to-parent = cast(GstElement, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstBaseSink, $_);
      }
    }
    self.setGstElement($to-parent);
  }

  method GStreamer::Raw::Structs::GstBaseSink
    is also<GstBaseSink>
  { $!bs }

  method new (GstBaseSinkAncestry $base-sink) {
    $base-sink ?? self.bless( :$base-sink ) !! Nil;
  }

  # Type: gboolean
  method async is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('async', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_BOOLEAN );
        $gv.boolean = $val;
        self.prop_set('async', $gv);
      }
    );
  }

  # Type: gboolean
  method enable-last-sample is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('enable-last-sample', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_BOOLEAN );
        $gv.boolean = $val;
        self.prop_set('enable-last-sample', $gv);
      }
    );
  }

  # Type: GstStructure
  method stats (:$raw = False) is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('stats', $gv)
        );

        return Nil unless $gv.object;

        my $s = cast(GstStructure, $gv.object);
        $raw ?? $s !! GStreamer::Structure.new($s);
      },
      STORE => -> $,  $val is copy {
        warn 'stats does not allow writing'
      }
    );
  }

  method do_preroll (GstMiniObject() $obj) is also<do-preroll> {
    GstFlowReturnEnum( gst_base_sink_do_preroll($!bs, $obj) );
  }

  method get_blocksize
    is also<
      get-blocksize
      blocksize
    >
  {
    gst_base_sink_get_blocksize($!bs);
  }

  method get_drop_out_of_segment
    is also<
      get-drop-out-of-segment
      drop_out_of_segment
      drop-out-of-segment
    >
  {
    so gst_base_sink_get_drop_out_of_segment($!bs);
  }

  method get_last_sample (:$raw = False)
    is also<
      get-last-sample
      last_sample
      last-sample
    >
  {
    my $s = gst_base_sink_get_last_sample($!bs);

    $s ??
      ( $raw ?? $s !! GStreamer::Sample.new($s) )
      !!
      Nil;
  }

  method get_latency
    is also<
      get-latency
      latency
    >
  {
    gst_base_sink_get_latency($!bs);
  }

  method get_max_bitrate
    is also<
      get-max-bitrate
      max_bitrate
      max-bitrate
    >
  {
    gst_base_sink_get_max_bitrate($!bs);
  }

  method get_max_lateness
    is also<
      get-max-lateness
      max_lateness
      max-lateness
    >
  {
    gst_base_sink_get_max_lateness($!bs);
  }

  method get_processing_deadline
    is also<
      get-processing-deadline
      processing_deadline
      processing-deadline
    >
  {
    gst_base_sink_get_processing_deadline($!bs);
  }

  method get_render_delay
    is also<
      get-render-delay
      render_delay
      render-delay
    >
  {
    gst_base_sink_get_render_delay($!bs);
  }

  method get_sync
    is also<
      get-sync
      sync
    >
  {
    so gst_base_sink_get_sync($!bs);
  }

  method get_throttle_time
    is also<
      get-throttle-time
      throttle_time
      throttle-time
    >
  {
    gst_base_sink_get_throttle_time($!bs);
  }

  method get_ts_offset
    is also<
      get-ts-offset
      ts_offset
      ts-offset
    >
  {
    gst_base_sink_get_ts_offset($!bs);
  }

  method is_async_enabled
    is also<
      is-async-enabled
      async_enabled
      async-enabled
    >
  {
    so gst_base_sink_is_async_enabled($!bs);
  }

  method is_last_sample_enabled
    is also<
      is-last-sample-enabled
      last_sample_enabled
      last-sample-enabled
    >
  {
    so gst_base_sink_is_last_sample_enabled($!bs);
  }

  method is_qos_enabled
    is also<
      is-qos-enabled
      qos_enabled
      qos-enabled
    >
  {
    so gst_base_sink_is_qos_enabled($!bs);
  }

  proto method query_latency (|)
      is also<query-latency>
  { * }

  multi method query_latency {
    my $rv = samewith($, $, $, $, :all);

    $rv ?? $rv.skip(1) !! Nil;
  }
  multi method query_latency (
    $live          is rw,
    $upstream_live is rw,
    $min_latency   is rw,
    $max_latency   is rw,
    :$all = False
  ) {
    my gboolean ($l, $u) = 0 xx 2;
    my GstClockTime ($mnl, $mxl) = 0 xx 2;

    my $rv = gst_base_sink_query_latency($!bs, $l, $u, $mnl, $mxl);
    ($live, $upstream_live, $min_latency, $max_latency) =
      ($l.so, $u.so, $mnl, $mxl);
    $all.not ?? $rv
             !! ($rv, $live, $upstream_live, $min_latency, $max_latency);
  }

  method set_async_enabled (Int() $enabled) is also<set-async-enabled> {
    my gboolean $e = $enabled.so.Int;

    gst_base_sink_set_async_enabled($!bs, $enabled);
  }

  method set_blocksize (Int() $blocksize) is also<set-blocksize> {
    my guint $b = $blocksize;

    gst_base_sink_set_blocksize($!bs, $b);
  }

  method set_drop_out_of_segment (Int() $drop_out_of_segment)
    is also<set-drop-out-of-segment>
  {
    my gboolean $d = $drop_out_of_segment.so.Int;

    gst_base_sink_set_drop_out_of_segment($!bs, $d);
  }

  method set_last_sample_enabled (Int() $enabled)
    is also<set-last-sample-enabled>
  {
    my gboolean $e = $enabled.so.Int;

    gst_base_sink_set_last_sample_enabled($!bs, $e);
  }

  method set_max_bitrate (guint64 $max_bitrate) is also<set-max-bitrate> {
    my guint64 $m = $max_bitrate;

    gst_base_sink_set_max_bitrate($!bs, $m);
  }

  method set_max_lateness (gint64 $max_lateness) is also<set-max-lateness> {
    my guint64 $m = $max_lateness;

    gst_base_sink_set_max_lateness($!bs, $m);
  }

  method set_processing_deadline (Int() $processing_deadline)
    is also<set-processing-deadline>
  {
    my GstClockTime $p = $processing_deadline;

    gst_base_sink_set_processing_deadline($!bs, $processing_deadline);
  }

  method set_qos_enabled (Int() $enabled) is also<set-qos-enabled> {
    my gboolean $e = $enabled.so.Int;

    gst_base_sink_set_qos_enabled($!bs, $e);
  }

  method set_render_delay (Int() $delay) is also<set-render-delay> {
    my GstClockTime $d = $delay;

    gst_base_sink_set_render_delay($!bs, $d);
  }

  method set_sync (Int() $sync) is also<set-sync> {
    my gboolean $s = $sync.so.Int;

    gst_base_sink_set_sync($!bs, $s);
  }

  method set_throttle_time (Int() $throttle) is also<set-throttle-time> {
    my guint64 $t = $throttle;

    gst_base_sink_set_throttle_time($!bs, $t);
  }

  method set_ts_offset (Int() $offset) is also<set-ts-offset> {
    my GstClockTimeDiff $o = $offset;

    gst_base_sink_set_ts_offset($!bs, $o);
  }

  method wait (Int() $time, Int() $jitter) {
    my GstClockTime $t = $time;
    my GstClockTimeDiff $j = $jitter;

    GstFlowReturnEnum( gst_base_sink_wait($!bs, $t, $j) );
  }

  method wait_clock (Int() $time, Int() $jitter) is also<wait-clock> {
    my GstClockTime $t = $time;
    my GstClockTimeDiff $j = $jitter;

    GstClockReturnEnum( gst_base_sink_wait_clock($!bs, $t, $j) );
  }

  method wait_preroll is also<wait-preroll> {
    GstFlowReturnEnum( gst_base_sink_wait_preroll($!bs) );
  }

}
