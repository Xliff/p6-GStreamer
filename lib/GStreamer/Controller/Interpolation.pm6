use v6.c;

use NativeCall;
use Method::Also;

use GStreamer::Raw::Types;

use GLib::Value;
use GStreamer::Controller::TimedValue;

our subset GstInterpolationControlSourceAncestry is export of Mu
  where GstInterpolationControlSource | GstTimedValueControlSourceAncestry;

class GStreamer::Controller::Interpolation
  is GStreamer::Controller::TimedValue
{
  has GstInterpolationControlSource $!tvcs;

  submethod BUILD (:$interpolation-source) {
    self.setGstInterpolationSource($interpolation-source);
  }

  method setGstInterpolationSource(GstInterpolationControlSourceAncestry $_) {
    my $to-parent;

    $!tvcs = do {
      when GstInterpolationControlSource {
        $to-parent = cast(GstTimedValueControlSource, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstInterpolationControlSource, $_);
      }
    }
    self.setGstTimedValueControlSource($to-parent);
  }

  method GStreamer::Raw::Structs::GstInterpolationControlSource
    is also<GstInterpolationControlSource>
  { $!tvcs }

  multi method new (
    GstInterpolationControlSourceAncestry $interpolation-source
  ) {
    $interpolation-source ?? self.bless( :$interpolation-source ) !! Nil;
  }
  multi method new {
    my $interpolation-source = gst_interpolation_control_source_new();

    $interpolation-source ?? self.bless( :$interpolation-source ) !! Nil;
  }

  # Type: GstInterpolationMode
  method mode is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('mode', $gv)
        );
        GstInterpolationModeEnum( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( GLib::Value.typeFromEnum(GstInterpolationMode) );
        $gv.valueFromEnum(GstInterpolationMode) = $val;
        self.prop_set('mode', $gv);
      }
    );
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &gst_interpolation_control_source_get_type,
      $n,
      $t
    );
  }

}

### /usr/include/gstreamer-1.0/gst/controller/gstinterpolationcontrolsource.h

sub gst_interpolation_control_source_new ()
  returns GstInterpolationControlSource
  is      native(gstreamer-controller)
  is      export
{ * }

sub gst_interpolation_control_source_get_type ()
  returns GType
  is      native(gstreamer-controller)
  is      export
{ * }
