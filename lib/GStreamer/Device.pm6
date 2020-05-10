use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;
use GStreamer::Raw::Device;

use GStreamer::Object;
use GStreamer::Structure;

use GStreamer::Caps;
use GStreamer::Element;

our subset GstDeviceAncestry is export of Mu
  where GstDevice | GstObject;

class GStreamer::Device is GStreamer::Object {
  use GLib::Roles::Signals::Generic;

  has GstDevice $!d;

  submethod BUILD (:$device) {
    self.setDevice($device);
  }

  method setDevice (GstDeviceAncestry $_) {
    my $to-parent;

    $!d = do {
      when GstDevice {
        $to-parent = cast(GstObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstDevice, $_);
      }
    }
    self.setGstObject($to-parent);
  }

  method GStreamer::Raw::Types::GstDevice
    is also<GstDevice>
  { $!d }

  method new (GstDeviceAncestry $device) {
    $device ?? self.bless( :$device ) !! Nil;
  }

  # Is originally:
  # GstDevice, gpointer
  method removed {
    self.connect($!d, 'removed');
  }

  method create_element (Str $name, :$raw = False) is also<create-element> {
    my $e = gst_device_create_element($!d, $name);

    $e ??
      ( $raw ?? $e !! GStreamer::Element.new($e) )
      !!
      Nil;
  }

  method get_caps (:$raw = False) is also<get-caps> {
    my $c = gst_device_get_caps($!d);

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

  method get_device_class is also<get-device-class> {
    gst_device_get_device_class($!d);
  }

  method get_display_name is also<get-display-name> {
    gst_device_get_display_name($!d);
  }

  method get_properties (:$raw = False) is also<get-properties> {
    my $p = gst_device_get_properties($!d);

    $p ??
      ( $raw ?? $p !! GStreamer::Structure.new($p) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_device_get_type, $n, $t );
  }

  proto method has_classes (|)
      is also<has-classes>
  { * }

  proto method has_classesv (|)
      is also<has-classesv>
  { * }

  multi method has_classes (Str() $classes) {
    so gst_device_has_classes($!d, $classes);
  }
  multi method has_classes (Str @classes) {
    self.has_classesv(@classes);
  }

  multi method has_classesv (@classes) {
    samewith( resolve-gstrv(@classes) );
  }
  multi method has_classesv (CArray[Str] $classes) {
    so gst_device_has_classesv($!d, $classes);
  }

  method reconfigure_element (GstElement() $element)
    is also<reconfigure-element>
  {
    so gst_device_reconfigure_element($!d, $element);
  }

}
