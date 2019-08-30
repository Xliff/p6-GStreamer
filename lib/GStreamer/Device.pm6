use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::Device;

use GStreamer::Object;

#use GStreamer::Caps;
use GStreamer::Element;

our subset DeviceAncestry is export of Mu
  where GstDevice | GstObject;

class GStreamer::Device is GStreamer::Object {
  has GstDevice $!d;

  submethod BUILD (:$device) {
    self.setDevice($device);
  }

  method setDevice (DeviceAncestry $_) {
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
  { $!d }

  method new (GstDevice $device) {
    self.bless( :$device )
  }

  method create_element (Str $name, :$raw = False) {
    my $e = gst_device_create_element($!d, $name);

    $e ??
      ( $raw ?? $e !! GStreamer::Element.new($e) )
      !!
      Nil;
  }

  method get_caps (:$raw = False) {
    my $c = gst_device_get_caps($!d);

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

  method get_device_class {
    gst_device_get_device_class($!d);
  }

  method get_display_name {
    gst_device_get_display_name($!d);
  }

  method get_properties (:$raw = False) {
    my $p = gst_device_get_properties($!d);

    $p ??
      ( $raw ?? $p !! GStreamer::Structure.new )
      !!
      Nil;
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_device_get_type, $n, $t );
  }

  proto method has_classes (|)
  { * }

  proto method has_classesv (|)
  { * }

  multi method has_classes (Str() $classes) {
    so gst_device_has_classes($!d, $classes);
  }
  multi method has_classes (Str @classes) {
    self.has_classesv(@classes);
  }

  multi method has_classesv (@classes) {
    my $ca = CArray[Str].new;

    my $n = @classes.elems;
    $ca[$_] = @classes[$_] for ^$n;
    $ca[$n] = Str;
    samewith($ca);
  }
  multi method has_classesv (CArray[Str] $classes) {
    so gst_device_has_classesv($!d, $classes);
  }

  method reconfigure_element (GstElement() $element) {
    so gst_device_reconfigure_element($!d, $element);
  }

}
