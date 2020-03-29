use v6.c;

use NativeCall;


use GStreamer::Raw::Types;

unit package GStreamer::Raw::DeviceProvider;

sub gst_device_provider_can_monitor (GstDeviceProvider $provider)
  returns uint32
  is native(gstreamer)
  is export
{ * }

# sub gst_device_provider_class_add_metadata (GstDeviceProviderClass $klass, Str $key, Str $value)
#   is native(gstreamer)
#   is export
# { * }
#
# sub gst_device_provider_class_add_static_metadata (GstDeviceProviderClass $klass, Str $key, Str $value)
#   is native(gstreamer)
#   is export
# { * }
#
# sub gst_device_provider_class_get_metadata (GstDeviceProviderClass $klass, Str $key)
#   returns Str
#   is native(gstreamer)
#   is export
# { * }
#
# sub gst_device_provider_class_set_metadata (GstDeviceProviderClass $klass, Str $longname, Str $classification, Str $description, Str $author)
#   is native(gstreamer)
#   is export
# { * }
#
# sub gst_device_provider_class_set_static_metadata (GstDeviceProviderClass $klass, Str $longname, Str $classification, Str $description, Str $author)
#   is native(gstreamer)
#   is export
# { * }

sub gst_device_provider_device_add (
  GstDeviceProvider $provider,
  GstDevice $device
)
  is native(gstreamer)
  is export
{ * }

sub gst_device_provider_device_changed (
  GstDeviceProvider $provider,
  GstDevice $device,
  GstDevice $changed_device
)
  is native(gstreamer)
  is export
{ * }

sub gst_device_provider_device_remove (
  GstDeviceProvider $provider,
  GstDevice $device
)
  is native(gstreamer)
  is export
{ * }

sub gst_device_provider_get_bus (GstDeviceProvider $provider)
  returns GstBus
  is native(gstreamer)
  is export
{ * }

sub gst_device_provider_get_devices (GstDeviceProvider $provider)
  returns GList
  is native(gstreamer)
  is export
{ * }

sub gst_device_provider_get_factory (GstDeviceProvider $provider)
  returns GstDeviceProviderFactory
  is native(gstreamer)
  is export
{ * }

sub gst_device_provider_get_hidden_providers (GstDeviceProvider $provider)
  returns CArray[Str]
  is native(gstreamer)
  is export
{ * }

sub gst_device_provider_get_metadata (GstDeviceProvider $provider, Str $key)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_device_provider_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_device_provider_hide_provider (GstDeviceProvider $provider, Str $name)
  is native(gstreamer)
  is export
{ * }

sub gst_device_provider_start (GstDeviceProvider $provider)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_device_provider_stop (GstDeviceProvider $provider)
  is native(gstreamer)
  is export
{ * }

sub gst_device_provider_unhide_provider (
  GstDeviceProvider $provider,
  Str $name
)
  is native(gstreamer)
  is export
{ * }
