use v6.c;

use GStreamer::Raw::Types;

unit package GStreamer::Raw::Registry;

### /usr/include/gstreamer-1.0/gst/gstregistry.h

sub gst_registry_add_feature (GstRegistry $registry, GstPluginFeature $feature)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_registry_add_plugin (GstRegistry $registry, GstPlugin $plugin)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_registry_check_feature_version (
  GstRegistry $registry,
  Str $feature_name,
  guint $min_major,
  guint $min_minor,
  guint $min_micro
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_registry_feature_filter (
  GstRegistry $registry,
  &filter (GstPluginFeature, gpointer --> gboolean),
  gboolean $first,
  gpointer $user_data
)
  returns GList
  is native(gstreamer)
  is export
{ * }

sub gst_registry_find_feature (GstRegistry $registry, Str $name, GType $type)
  returns GstPluginFeature
  is native(gstreamer)
  is export
{ * }

sub gst_registry_find_plugin (GstRegistry $registry, Str $name)
  returns GstPlugin
  is native(gstreamer)
  is export
{ * }

sub gst_registry_get ()
  returns GstRegistry
  is native(gstreamer)
  is export
{ * }

sub gst_registry_get_feature_list (GstRegistry $registry, GType $type)
  returns GList
  is native(gstreamer)
  is export
{ * }

sub gst_registry_get_feature_list_by_plugin (GstRegistry $registry, Str $name)
  returns GList
  is native(gstreamer)
  is export
{ * }

sub gst_registry_get_feature_list_cookie (GstRegistry $registry)
  returns guint32
  is native(gstreamer)
  is export
{ * }

sub gst_registry_get_plugin_list (GstRegistry $registry)
  returns GList
  is native(gstreamer)
  is export
{ * }

sub gst_registry_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_registry_lookup (GstRegistry $registry, Str $filename)
  returns GstPlugin
  is native(gstreamer)
  is export
{ * }

sub gst_registry_lookup_feature (GstRegistry $registry, Str $name)
  returns GstPluginFeature
  is native(gstreamer)
  is export
{ * }

sub gst_registry_plugin_filter (
  GstRegistry $registry,
  &filter (GstPlugin, gpointer --> gboolean),
  gboolean $first,
  gpointer $user_data
)
  returns GList
  is native(gstreamer)
  is export
{ * }

sub gst_registry_remove_feature (
  GstRegistry $registry,
  GstPluginFeature $feature
)
  is native(gstreamer)
  is export
{ * }

sub gst_registry_remove_plugin (GstRegistry $registry, GstPlugin $plugin)
  is native(gstreamer)
  is export
{ * }

sub gst_registry_scan_path (GstRegistry $registry, Str $path)
  returns uint32
  is native(gstreamer)
  is export
{ * }
