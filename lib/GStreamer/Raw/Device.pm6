use v6.c;

use GTK::Compat::Types;
use GStreamer::Raw::Types;

unit package GStreamer::Raw::Device;

sub gst_device_create_element (GstDevice $device, Str $name)
  returns GstElement
  is native(gstreamer)
  is export
{ * }

sub gst_device_get_caps (GstDevice $device)
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

sub gst_device_get_device_class (GstDevice $device)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_device_get_display_name (GstDevice $device)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_device_get_properties (GstDevice $device)
  returns GstStructure
  is native(gstreamer)
  is export
{ * }

sub gst_device_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_device_has_classes (GstDevice $device, Str $classes)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_device_has_classesv (GstDevice $device, Str $classes)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_device_reconfigure_element (GstDevice $device, GstElement $element)
  returns uint32
  is native(gstreamer)
  is export
{ * }
