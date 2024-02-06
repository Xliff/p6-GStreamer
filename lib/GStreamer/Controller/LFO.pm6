use v6.c;

use NativeCall;
use Method::Also;

use GStreamer::Raw::Types;

use GLib::Value;
use GStreamer::ControlSource;

our subset GstLFOControlSourceAncestry is export of Mu
  where GstLFOControlSource | GstControlSourceAncestry;

class GStreamer::Controller::LFO is GStreamer::ControlSource {
  has GstLFOControlSource $!lcs;

  submethod BUILD (:$lfo-source) {
    self.setGstLFOControlSource($lfo-source) if $lfo-source;
  }

  method setGstLFOControlSource(GstLFOControlSourceAncestry $_) {
    my $to-parent;

    $!lcs = do {
      when GstLFOControlSource {
        $to-parent = cast(GstControlSource, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstLFOControlSource, $_);
      }
    }
    self.setGstControlSource($to-parent);
  }

  method GStreamer::Raw::Controller::Structs::GstLFOControlSource
    is also<GstLFOControlSource>
  { $!lcs }

  multi method new (GstLFOControlSourceAncestry $lfo-source) {
    $lfo-source ?? self.bless( :$lfo-source ) !! Nil;
  }
  multi method new {
    my $lfo-source = gst_lfo_control_source_new();

    $lfo-source ?? self.bless( :$lfo-source ) !! Nil;
  }

  # Type: gdouble
  method amplitude is rw  {
    my $gv = GLib::Value.new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('amplitude', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('amplitude', $gv);
      }
    );
  }

  # Type: gdouble
  method frequency is rw  {
    my $gv = GLib::Value.new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('frequency', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('frequency', $gv);
      }
    );
  }

  # Type: gdouble
  method offset is rw  {
    my $gv = GLib::Value.new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('offset', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('offset', $gv);
      }
    );
  }

  # Type: guint64
  method timeshift is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT64 );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('timeshift', $gv)
        );
        $gv.uint64;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint64 = $val;
        self.prop_set('timeshift', $gv);
      }
    );
  }

  # Type: GstLFOWaveform
  method waveform is rw  {
    my $gv = GLib::Value.new( GLib::Value.typeFromEnum(GstLFOWaveform) );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('waveform', $gv)
        );
        GstLFOWaveformEnum( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv.valueFromEnum(GstLFOWaveform) = $val;
        self.prop_set('waveform', $gv);
      }
    );
  }

}


### /usr/include/gstreamer-1.0/gst/controller/gstlfocontrolsource.h

sub gst_lfo_control_source_new ()
  returns GstControlSource
  is native(gstreamer-controller)
  is export
{ * }
