use v6.c;

use NativeCall;


use GStreamer::Raw::Types;

unit package GStreamer::Raw::DeviceMonitor;

sub gst_device_monitor_add_filter (
  GstDeviceMonitor $monitor,
  Str $classes,
  GstCaps $caps
)
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_device_monitor_get_bus (GstDeviceMonitor $monitor)
  returns GstBus
  is native(gstreamer)
  is export
{ * }

sub gst_device_monitor_get_devices (GstDeviceMonitor $monitor)
  returns GList
  is native(gstreamer)
  is export
{ * }

sub gst_device_monitor_get_providers (GstDeviceMonitor $monitor)
  returns CArray[Str]
  is native(gstreamer)
  is export
{ * }

sub gst_device_monitor_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_device_monitor_new ()
  returns GstDeviceMonitor
  is native(gstreamer)
  is export
{ * }

sub gst_device_monitor_remove_filter (
  GstDeviceMonitor $monitor,
  guint $filter_id
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_device_monitor_start (GstDeviceMonitor $monitor)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_device_monitor_stop (GstDeviceMonitor $monitor)
  is native(gstreamer)
  is export
{ * }

sub gst_device_monitor_get_show_all_devices (GstDeviceMonitor $monitor)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_device_monitor_set_show_all_devices (
  GstDeviceMonitor $monitor,
  gboolean $show_all
)
  is native(gstreamer)
  is export
{ * }
