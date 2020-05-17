use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Audio::BaseSink;

use GStreamer::Audio::RingBuffer;
use GStreamer::Base::Sink;

our subset GstAudioBaseSinkAncestry is export of Mu
  where GstAudioBaseSink | GstBaseSinkAncestry;

class GStreamer::Audio::BaseSink is GStreamer::Base::Sink {
  has GstAudioBaseSink $!abs;

  submethod BUILD (:$audio-base-sink) {
    self.setGstAudioBaseSink($audio-base-sink);
  }

  method setGstAudioBaseSink(GstAudioBaseSinkAncestry $_) {
    my $to-parent;

    $!abs = do {
      when GstAudioBaseSink {
        $to-parent = cast(GstBaseSink, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstAudioBaseSink, $_);
      }
    }
    self.setGstElement($to-parent);
  }

  method GStreamer::Raw::Structs::GstAudioBaseSink
    is also<GstAudioBaseSink>
  { $!abs }

  method new (GstAudioBaseSinkAncestry $audio-base-sink) {
    $audio-base-sink ?? self.bless( :$audio-base-sink ) !! Nil;
  }

  # Type: gint64
  method buffer-time is rw  is also<buffer_time> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('buffer-time', $gv)
        );
        $gv.int64;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_INT64 );
        $gv.int64 = $val;
        self.prop_set('buffer-time', $gv);
      }
    );
  }

  # Type: gboolean
  method can-activate-pull is rw is also<can_activate_pull> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('can-activate-pull', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_BOOLEAN );
        $gv.boolean = $val;
        self.prop_set('can-activate-pull', $gv);
      }
    );
  }

  # Type: gint64
  method latency-time is rw is also<latency_time> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('latency-time', $gv)
        );
        $gv.int64;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_INT64 );
        $gv.int64 = $val;
        self.prop_set('latency-time', $gv);
      }
    );
  }

  method alignment_threshold is rw is also<alignment-threshold> {
    Proxy.new:
      FETCH => -> $           { self.get_alignment_threshold },
      STORE => -> $, Int() \i { self.set_alignment_threshold(i) };
  }

  method discont_wait is rw is also<discont-wait> {
    Proxy.new:
      FETCH => -> $           { self.get_discont_wait },
      STORE => -> $, Int() \i { self.set_discont_wait(i) };
  }

  method drift_tolerance is rw is also<drift-tolerance> {
    Proxy.new:
      FETCH => -> $           { self.get_drift_tolerance },
      STORE => -> $, Int() \i { self.set_drift_tolerance(i) };
  }

  method provide_clock is rw is also<provide-clock> {
    Proxy.new:
      FETCH => -> $           { self.get_provide_clock },
      STORE => -> $, Int() \i { self.set_provide_clock(i) };
  }

  method slave_method is rw is also<slave-method> {
    Proxy.new:
      FETCH => -> $           { self.get_slave_method },
      STORE => -> $, Int() \i { self.set_slave_method(i) };
  }

  method create_ringbuffer (:$raw = False) is also<create-ringbuffer> {
    my $r = gst_audio_base_sink_create_ringbuffer($!abs);

    $r ??
      ( $raw ?? $r !! GStreamer::Audio::RingBuffer.new($r) )
      !!
      Nil;
  }

  method get_alignment_threshold is also<get-alignment-threshold> {
    gst_audio_base_sink_get_alignment_threshold($!abs);
  }

  method get_discont_wait is also<get-discont-wait> {
    gst_audio_base_sink_get_discont_wait($!abs);
  }

  method get_drift_tolerance is also<get-drift-tolerance> {
    gst_audio_base_sink_get_drift_tolerance($!abs);
  }

  method get_provide_clock is also<get-provide-clock> {
    so gst_audio_base_sink_get_provide_clock($!abs);
  }

  method get_slave_method is also<get-slave-method> {
    GstAudioBaseSinkSlaveMethodEnum(
      gst_audio_base_sink_get_slave_method($!abs)
    );
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_audio_base_sink_get_type, $n, $t );
  }

  method report_device_failure is also<report-device-failure> {
    gst_audio_base_sink_report_device_failure($!abs);
  }

  method set_alignment_threshold (Int() $alignment_threshold)
    is also<set-alignment-threshold>
  {
    my GstClockTime $a = $alignment_threshold;

    gst_audio_base_sink_set_alignment_threshold($!abs, $a);
  }

  method set_custom_slaving_callback (
    &callback,
    gpointer $user_data    = gpointer,
    GDestroyNotify $notify = gpointer
  )
    is also<set-custom-slaving-callback>
  {
    gst_audio_base_sink_set_custom_slaving_callback(
      $!abs,
      &callback,
      $user_data,
      $notify
    );
  }

  method set_discont_wait (Int() $discont_wait) is also<set-discont-wait> {
    my GstClockTime $d = $discont_wait;

    gst_audio_base_sink_set_discont_wait($!abs, $d);
  }

  method set_drift_tolerance (Int() $drift_tolerance)
    is also<set-drift-tolerance>
  {
    my gint64 $d = $drift_tolerance;

    gst_audio_base_sink_set_drift_tolerance($!abs, $d);
  }

  method set_provide_clock (Int() $provide) is also<set-provide-clock> {
    my gboolean $p = $provide.so.Int;

    gst_audio_base_sink_set_provide_clock($!abs, $p);
  }

  method set_slave_method (Int() $method) is also<set-slave-method> {
    my GstAudioBaseSinkSlaveMethod $m = $method;

    gst_audio_base_sink_set_slave_method($!abs, $m);
  }

}
