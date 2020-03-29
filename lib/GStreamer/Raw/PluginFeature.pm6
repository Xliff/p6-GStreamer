use v6.c;

use NativeCall;


use GStreamer::Raw::Types;

unit package GStreamer::Raw::PluginFeature;

sub gst_plugin_feature_check_version (
  GstPluginFeature $feature,
  guint $min_major,
  guint $min_minor,
  guint $min_micro
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_feature_get_plugin (GstPluginFeature $feature)
  returns GstPlugin
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_feature_get_plugin_name (GstPluginFeature $feature)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_feature_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_feature_list_copy (GList $list)
  returns GList
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_feature_list_debug (GList $list)
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_feature_list_free (GList $list)
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_feature_load (GstPluginFeature $feature)
  returns GstPluginFeature
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_feature_rank_compare_func (
  GstPluginFeature $p1,
  GstPluginFeature $p2
)
  returns gint
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_feature_get_rank (GstPluginFeature $feature)
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_feature_set_rank (GstPluginFeature $feature, guint $rank)
  is native(gstreamer)
  is export
{ * }
