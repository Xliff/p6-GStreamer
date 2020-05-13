use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::App::Sink;

use GStreamer::Base::Sink;
use GStreamer::Caps;
use GStreamer::Sample;

use GStreamer::App::Roles::Signals::Sink;

our subset GstAppSinkAncestry is export of Mu
  where GstAppSink | GstBaseSinkAncestry;

class GStreamer::App::Sink is GStreamer::Base::Sink {
  also does GStreamer::App::Roles::Signals::Sink;

  has GstAppSink $!as;

  submethod BUILD (:$app-sink) {
    self.setGstAppSink($app-sink);
  }

  method setGstAppSink(GstAppSinkAncestry $_) {
    my $to-parent;

    $!as = do {
      when GstAppSink {
        $to-parent = cast(GstBaseSink, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstAppSink, $_);
      }
    }
    self.setGstElement($to-parent);
  }

  method GStreamer::Raw::Structs::GstAppSink
    is also<GstAppSink>
  { $!as }

  method new (GstAppSinkAncestry $app-sink) {
    $app-sink ?? self.bless( :$app-sink ) !! Nil;
  }

  method caps (:$raw = False) is rw {
    Proxy.new:
      FETCH => -> $               { self.get_caps(:$raw) },
      STORE => -> $, GstCaps() \c { self.set_caps(c)     };
  }

  method drop is rw {
    Proxy.new:
      FETCH => -> $           { self.get_drop    },
      STORE => -> $, Int() \i { self.set_drop(i) };
  }

  method emit_signals is rw is also<emit-signals> {
    Proxy.new:
      FETCH => -> $           { self.get_emit_signals    },
      STORE => -> $, Int() \i { self.set_emit_signals(i) };
  }

  method max_buffers is rw is also<max-buffers> {
    Proxy.new:
      FETCH => -> $           { self.get_max_buffers    },
      STORE => -> $, Int() \i { self.set_max_buffers(i) };
  }

  method wait_on_eos is rw is also<wait-on-eos> {
    Proxy.new:
      FETCH => -> $           { self.get_wait_on_eos    },
      STORE => -> $, Int() \i { self.set_wait_on_eos(i) };
  }

  # Is originally:
  # GstAppSink, gpointer
  method eos {
    self.connect($!as, 'eos');
  }

  # Is originally:
  # GstAppSink, gpointer --> GstFlowReturn
  method new-preroll is also<new_preroll> {
    self.connect-uint-rGstFlowReturn($!as, 'new-preroll');
  }

  # Is originally:
  # GstAppSink, gpointer --> GstFlowReturn
  method new-sample is also<new_sample> {
    self.connect-uint-rGstFlowReturn($!as, 'new-sample');
  }

  # Is originally:
  # GstAppSink, gpointer --> GstSample
  method pull-preroll {
    self.connect-rGstSample($!as, 'pull-preroll');
  }

  # Is originally:
  # GstAppSink, gpointer --> GstSample
  method pull-sample {
    self.connect-rGstSample($!as, 'pull-sample');
  }

  # Is originally:
  # GstAppSink, guint64, gpointer --> GstSample
  method try-pull-preroll {
    self.connect-ulong-rGstSample($!as, 'try-pull-preroll');
  }

  # Is originally:
  # GstAppSink, guint64, gpointer --> GstSample
  method try-pull-sample {
    self.connect-ulong-rGstSample($!as, 'try-pull-sample');
  }

  method get_buffer_list_support is also<get-buffer-list-support> {
    so gst_app_sink_get_buffer_list_support($!as);
  }

  method get_caps (:$raw = False) is also<get-caps> {
    my $c = gst_app_sink_get_caps($!as);

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

  method get_drop is also<get-drop> {
    so gst_app_sink_get_drop($!as);
  }

  method get_emit_signals is also<get-emit-signals> {
    so gst_app_sink_get_emit_signals($!as);
  }

  method get_max_buffers is also<get-max-buffers> {
    gst_app_sink_get_max_buffers($!as);
  }

  method get_wait_on_eos is also<get-wait-on-eos> {
    so gst_app_sink_get_wait_on_eos($!as);
  }

  method is_eos is also<is-eos> {
    so gst_app_sink_is_eos($!as);
  }

  method pull_preroll (:$raw = False) {
    my $ps = gst_app_sink_pull_preroll($!as);

    $ps ??
      ( $raw ?? $ps !! GStreamer::Sample.new($ps) )
      !!
      Nil;
  }

  method pull_sample (:$raw = False) {
    my $s = gst_app_sink_pull_sample($!as);

    $s ??
      ( $raw ?? $s !! GStreamer::Sample.new($s) )
      !!
      Nil;
  }

  method set_buffer_list_support (Int() $enable_lists)
    is also<set-buffer-list-support>
  {
    my gboolean $e = $enable_lists.so.Int;

    gst_app_sink_set_buffer_list_support($!as, $e);
  }

  method set_callbacks (
    GstAppSinkCallbacks $callbacks,
    gpointer $user_data    = gpointer,
    GDestroyNotify $notify = gpointer
  )
    is also<set-callbacks>
  {
    gst_app_sink_set_callbacks($!as, $callbacks, $user_data, $notify);
  }

  method set_caps (GstCaps() $caps) is also<set-caps> {
    gst_app_sink_set_caps($!as, $caps);
  }

  method set_drop (Int() $drop) is also<set-drop> {
    my gboolean $d = $drop.so.Int;

    gst_app_sink_set_drop($!as, $d);
  }

  method set_emit_signals (Int() $emit) is also<set-emit-signals> {
    my gboolean $e = $emit.so.Int;

    gst_app_sink_set_emit_signals($!as, $e);
  }

  method set_max_buffers (Int() $max) is also<set-max-buffers> {
    my guint $m = $max;

    gst_app_sink_set_max_buffers($!as, $m);
  }

  method set_wait_on_eos (Int() $wait) is also<set-wait-on-eos> {
    my gboolean $w = $wait.so.Int;

    gst_app_sink_set_wait_on_eos($!as, $w);
  }

  method try_pull_preroll (Int() $timeout) {
    my GstClockTime $t = $timeout;

    gst_app_sink_try_pull_preroll($!as, $t);
  }

  method try_pull_sample (Int() $timeout) {
    my GstClockTime $t = $timeout;

    gst_app_sink_try_pull_sample($!as, $t);
  }

}
