use v6.c;

use GTK::Compat::Types;
use GStreamer::Raw::Types;

unit package GStreamer::Raw::Object;

sub gst_object_add_control_binding (
  GstObject $object,
  GstControlBinding $binding
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_object_check_uniqueness (GList $list, Str $name)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_object_default_deep_notify (
  GObject $object,
  GstObject $orig,
  GParamSpec $pspec,
  Str $excluded_props
)
  is native(gstreamer)
  is export
{ * }

sub gst_object_get_control_binding (GstObject $object, Str $property_name)
  returns GstControlBinding
  is native(gstreamer)
  is export
{ * }

sub gst_object_get_g_value_array (
  GstObject $object,
  Str $property_name,
  GstClockTime $timestamp,
  GstClockTime $interval,
  guint $n_values,
  GValue $values
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_object_get_path_string (GstObject $object)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_object_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_object_get_value (
  GstObject $object,
  Str $property_name,
  GstClockTime $timestamp
)
  returns GValue
  is native(gstreamer)
  is export
{ * }

sub gst_object_get_value_array (
  GstObject $object,
  Str $property_name,
  GstClockTime $timestamp,
  GstClockTime $interval,
  guint $n_values,
  gpointer $values
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_clear_object (GstObject $object_ptr)
  is native(gstreamer)
  is export
{ * }

sub gst_object_has_active_control_bindings (GstObject $object)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_object_has_as_ancestor (GstObject $object, GstObject $ancestor)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_object_has_as_parent (GstObject $object, GstObject $parent)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_object_ref (gpointer $object)
  returns Pointer
  is native(gstreamer)
  is export
{ * }

sub gst_object_ref_sink (gpointer $object)
  returns Pointer
  is native(gstreamer)
  is export
{ * }

sub gst_object_remove_control_binding (
  GstObject $object,
  GstControlBinding $binding
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_object_replace (GstObject $oldobj, GstObject $newobj)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_object_set_control_binding_disabled (
  GstObject $object,
  Str $property_name,
  gboolean $disabled
)
  is native(gstreamer)
  is export
{ * }

sub gst_object_set_control_bindings_disabled (
  GstObject $object,
  gboolean $disabled
)
  is native(gstreamer)
  is export
{ * }

sub gst_object_suggest_next_sync (GstObject $object)
  returns GstClockTime
  is native(gstreamer)
  is export
{ * }

sub gst_object_sync_values (GstObject $object, GstClockTime $timestamp)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_object_unparent (GstObject $object)
  is native(gstreamer)
  is export
{ * }

sub gst_object_unref (gpointer $object)
  is native(gstreamer)
  is export
{ * }

sub gst_object_get_control_rate (GstObject $object)
  returns GstClockTime
  is native(gstreamer)
  is export
{ * }

sub gst_object_get_name (GstObject $object)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_object_get_parent (GstObject $object)
  returns GstObject
  is native(gstreamer)
  is export
{ * }

sub gst_object_set_control_rate (
  GstObject $object,
  GstClockTime $control_rate
)
  is native(gstreamer)
  is export
{ * }

sub gst_object_set_name (GstObject $object, Str $name)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_object_set_parent (GstObject $object, GstObject $parent)
  returns uint32
  is native(gstreamer)
  is export
{ * }
