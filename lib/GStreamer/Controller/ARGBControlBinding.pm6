use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

our subset GstARGBControlBindingAncestry is export of Mu
  where GstARGBControlBinding | GstControlBinding;

class GStreamer::Controller::ARGBControlBinding
  is GStreamer::ControlBinding
{
  has GstARGBControlBinding $!argb-b;

  submethod BUILD (:$argb-binding) {
    self.setGstARGBControlBinding($argb-binding);
  }

  method setGstARGBControlBinding (GstARGBControlBindingAncestry $_) {
    my $to-parent;

    $argb-b = do {
      when GstARGBControlBinding {
        $to-parent = cast(GstControlBinding, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstARGBControlBinding, $_);
      }
    }
    self.setGstControlBinding($to-parent);
  }

  method GStreamer::Raw::Structs::GstARGBControlBinding
    is also<GstARGBControlBinding>
  { $argb-b }

  multi method new (GstARGBControlBindingAncestry $argb-binding) {
    $argb-binding ?? self.bless( :$argb-binding ) !! Nil;
  }
  multi method new (
    Str() $property_name,
    GstControlSource() $cs_a,
    GstControlSource() $cs_r,
    GstControlSource() $cs_g,
    GstControlSource() $cs_b
  ) {
    my $argb-binding = gst_argb_control_binding_new(
      $property_name,
      $cs_a,
      $cs_r,
      $cs_g,
      $cs_b
    );
  }

    # Type: GstControlSource
  method control-source-a is rw  {
    my $gv = GLib::Value.new( GStreamer::ControlSource.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('control-source-a', $gv)
        );

        my $o = $gv.object;
        return Nil unless $o;

        $o = cast(GstControlSource, $o);
        return $o if $raw;

        GStreamer::ControlSource.new($o);
      },
      STORE => -> $, GstControlSource() $val is copy {
        $gv.object = $val;
        self.prop_set('control-source-a', $gv);
      }
    );
  }

  # Type: GstControlSource
  method control-source-b is rw  {
    my $gv = GLib::Value.new( GStreamer::ControlSource.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('control-source-b', $gv)
        );

        my $o = $gv.object;
        return Nil unless $o;

        $o = cast(GstControlSource, $o);
        return $o if $raw;

        GStreamer::ControlSource.new($o);
      },
      STORE => -> $, GstControlSource() $val is copy {
        $gv.object = $val;
        self.prop_set('control-source-b', $gv);
      }
    );
  }

  # Type: GstControlSource
  method control-source-g is rw  {
    my $gv = GLib::Value.new( GStreamer::ControlSource.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('control-source-g', $gv)
        );

        my $o = $gv.object;
        return Nil unless $o;

        $o = cast(GstControlSource, $o);
        return $o if $raw;

        GStreamer::ControlSource.new($o);
      },
      STORE => -> $, GstControlSource() $val is copy {
        $gv.object = $val;
        self.prop_set('control-source-g', $gv);
      }
    );
  }

  # Type: GstControlSource
  method control-source-r is rw  {
    my $gv = GLib::Value.new( GStreamer::ControlSource.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('control-source-r', $gv)
        );

        my $o = $gv.object;
        return Nil unless $o;

        $o = cast(GstControlSource, $o);
        return $o if $raw;

        GStreamer::ControlSource.new($o);
      },
      STORE => -> $, GstControlSource() $val is copy {
        $gv.object = $val;
        self.prop_set('control-source-r', $gv);
      }
    );
  }

}

### /usr/include/gstreamer-1.0/gst/controller/gstargbcontrolbinding.h

sub gst_argb_control_binding_new (GstObject $object, Str $property_name, GstControlSource $cs_a, GstControlSource $cs_r, GstControlSource $cs_g, GstControlSource $cs_b)
  returns GstControlBinding
  is native(gstreamer-controller)
  is export
{ * }
