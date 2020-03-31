use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

unit package GStreamer::Raw::DeviceProviderFactory;

### /usr/include/gstreamer-1.0/gst/gstdeviceproviderfactory.h

sub gst_device_provider_factory_find (Str $name)
  returns GstDeviceProviderFactory
  is native(gstreamer)
  is export
{ * }

sub gst_device_provider_factory_get (GstDeviceProviderFactory $factory)
  returns GstDeviceProvider
  is native(gstreamer)
  is export
{ * }

sub gst_device_provider_factory_get_by_name (Str $factoryname)
  returns GstDeviceProvider
  is native(gstreamer)
  is export
{ * }

sub gst_device_provider_factory_get_device_provider_type (
  GstDeviceProviderFactory $factory
)
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_device_provider_factory_get_metadata (
  GstDeviceProviderFactory $factory,
  Str $key
)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_device_provider_factory_get_metadata_keys (
  GstDeviceProviderFactory $factory
)
  returns CArray[Str]
  is native(gstreamer)
  is export
{ * }

sub gst_device_provider_factory_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_device_provider_factory_has_classes (
  GstDeviceProviderFactory $factory,
  Str $classes
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_device_provider_factory_has_classesv (
  GstDeviceProviderFactory $factory,
  CArray[Str] $classes
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_device_provider_factory_list_get_device_providers (GstRank $minrank)
  returns GList
  is native(gstreamer)
  is export
{ * }
