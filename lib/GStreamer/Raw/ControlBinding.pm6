use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::ControlBinding;

### /usr/include/gstreamer-1.0/gst/gstcontrolbinding.h

sub gst_control_binding_get_g_value_array (
  GstControlBinding $binding,
  GstClockTime $timestamp,
  GstClockTime $interval,
  guint $n_values,
  Pointer $values
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_control_binding_get_value (
  GstControlBinding $binding,
  GstClockTime $timestamp
)
  returns GValue
  is native(gstreamer)
  is export
{ * }

sub gst_control_binding_get_value_array (
  GstControlBinding $binding,
  GstClockTime $timestamp,
  GstClockTime $interval,
  guint $n_values,
  gpointer $values
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_control_binding_is_disabled (GstControlBinding $binding)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_control_binding_set_disabled (
  GstControlBinding $binding,
  gboolean $disabled
)
  is native(gstreamer)
  is export
{ * }

sub gst_control_binding_sync_values (
  GstControlBinding $binding,
  GstObject $object,
  GstClockTime $timestamp,
  GstClockTime $last_sync
)
  returns uint32
  is native(gstreamer)
  is export
{ * }
