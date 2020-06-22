use v6.c;

use GStreamer::Raw::Types;
use GStreamer::Raw::App::Src;

use GStreamer::Base::Src;
use GStreamer::Caps;

our subset GstAppSrcAncestry is export of Mu
  where GstAppSrc | GstBaseSrcAncestry;

class GStreamer::App::Src is GStreamer::Base::Src {
  has GstAppSrc $!as;

  # Type: gboolean
  method block is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('block', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_BOOLEAN );
        $gv.boolean = $val;
        self.prop_set('block', $gv);
      }
    );
  }

  # Type: GstCaps
  method caps (:$raw = False) is rw  {
    Proxy.new:
      FETCH => -> $                         { self.get_caps(:$raw) }
      STORE => -> $, GstCaps() $val is copy { self.set_caps($val)  }
  }

  # Type: guint64
  method current-level-bytes is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('current-level-bytes', $gv)
        );
        $gv.uint64;
      },
      STORE => -> $, Int() $val is copy {
        warn 'current-level-bytes does not allow writing'
      }
    );
  }

  # Type: guint64
  method duration is rw  {
    Proxy.new:
      FETCH => -> $                           { self.get_duration }
      STORE => -> $, GstClockTime \ct is copy { self.set_duration(ct)  }
  }

  # Type: gboolean
  method emit-signals is rw  {
    Proxy.new:
      FETCH => -> $                   { self.get_emit_signals    }
      STORE => -> $, Int() \v is copy { self.set_emit_signals(v) }
  }

  # Type: GstFormat
  method format is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('format', $gv)
        );
        GstFormatEnum( $gv.enum )
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT );
        $gv.uint = $val;
        self.prop_set('format', $gv);
      }
    );
  }

  # Type: gboolean
  method is-live is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('is-live', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_BOOLEAN );
        $gv.boolean = $val;
        self.prop_set('is-live', $gv);
      }
    );
  }

  # Type: gint64
  method max-latency is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('max-latency', $gv)
        );
        $gv.int64;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_INT64 );
        $gv.int64 = $val;
        self.prop_set('max-latency', $gv);
      }
    );
  }

  # Type: gint64
  method min-latency is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('min-latency', $gv)
        );
        $gv.int64;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_INT64 );
        $gv.int64 = $val;
        self.prop_set('min-latency', $gv);
      }
    );
  }

  # Type: guint
  method min-percent is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('min-percent', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT );
        $gv.uint = $val;
        self.prop_set('min-percent', $gv);
      }
    );
  }

    # Is originally:
  # GstAppSrc, gpointer --> GstFlowReturn
  method end-of-stream (:$signal is required) {
    self.connect-end-of-stream($!as);
  }

  # Is originally:
  # gpointer --> GstAppSrc
  method enough-data {
    self.connect-enough-data($!as);
  }

  # Is originally:
  # guint, gpointer --> GstAppSrc
  method need-data {
    self.connect-need-data($!as);
  }

  # Is originally:
  # GstAppSrc, GstBuffer, gpointer --> GstFlowReturn
  method push-buffer {
    self.connect-push-buffer($!as);
  }

  # Is originally:
  # GstAppSrc, GstSample, gpointer --> GstFlowReturn
  method push-sample {
    self.connect-push-sample($!as);
  }

  # Is originally:
  # GstAppSrc, guint64, gpointer --> gboolean
  method seek-data {
    self.connect-long-ruint32($!as, 'seek-data');
  }

  method end_of_stream {
    GstFlowReturnEnum( gst_app_src_end_of_stream($!as) );
  }

  method get_caps (:$raw = False) {
    my $c = gst_app_src_get_caps($!as);

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

  method get_current_level_bytes {
    gst_app_src_get_current_level_bytes($!as);
  }

  method get_duration {
    gst_app_src_get_duration($!as);
  }

  method get_emit_signals {
    so gst_app_src_get_emit_signals($!as);
  }

  method get_latency ($min is rw, $max is rw) {
    my guint64 ($mn, $mx) = 0 xx 2;

    gst_app_src_get_latency($!as, $mn, $mx);
    ($min, $max) = ($mn, $mx);
  }

  method get_max_bytes {
    gst_app_src_get_max_bytes($!as);
  }

  method get_size {
    gst_app_src_get_size($!as);
  }

  method get_stream_type {
    GstAppStreamTypeEnum( gst_app_src_get_stream_type($!as) );
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_app_src_get_type, $n, $t );
  }

  method push_buffer (GstBuffer() $buffer) {
    GstFlowReturnEnum( gst_app_src_push_buffer($!as, $buffer) );
  }

  method push_buffer_list (GstBufferList() $buffer_list) {
    GstFlowReturnEnum( gst_app_src_push_buffer_list($!as, $buffer_list) );
  }

  method push_sample (GstSample() $sample) {
    GstFlowReturnEnum( gst_app_src_push_sample($!as, $sample) );
  }

  method set_callbacks (
    GstAppSrcCallbacks $callbacks,
    gpointer $user_data    = gpointer,
    GDestroyNotify $notify = gpointer
  ) {
    gst_app_src_set_callbacks($!as, $callbacks, $user_data, $notify);
  }

  method set_caps (GstCaps() $caps) {
    gst_app_src_set_caps($!as, $caps);
  }

  method set_duration (GstClockTime $duration) {
    gst_app_src_set_duration($!as, $duration);
  }

  method set_emit_signals (Int() $emit) {
    my gboolean $e = $emit.so.Int;

    gst_app_src_set_emit_signals($!as, $e);
  }

  method set_latency (Int() $min, Int() $max) {
    my guint64 ($mn, $mx) = ($min, $max);

    gst_app_src_set_latency($!as, $mn, $mx);
  }

  method set_max_bytes (Int() $max) {
    my guint64 $m = $max;

    gst_app_src_set_max_bytes($!as, $m);
  }

  method set_size (Int() $size) {
    my guint64 $s = $size;

    gst_app_src_set_size($!as, $size);
  }

  method set_stream_type (GstAppStreamType $type) {
    my GstAppStreamType $t = $type;

    gst_app_src_set_stream_type($!as, $t);
  }

}
