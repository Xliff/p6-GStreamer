use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

unit package GStreamer::Raw::Plugin;

sub gst_plugin_add_dependency (
  GstPlugin $plugin,
  Str $env_vars,
  Str $paths,
  Str $names,
  guint $flags # GstPluginDependencyFlags $flags
)
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_add_dependency_simple (
  GstPlugin $plugin,
  Str $env_vars,
  Str $paths,
  Str $names,
  guint $flags # GstPluginDependencyFlags $flags
)
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_error_quark ()
  returns GQuark
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_get_description (GstPlugin $plugin)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_get_filename (GstPlugin $plugin)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_get_license (GstPlugin $plugin)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_get_name (GstPlugin $plugin)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_get_origin (GstPlugin $plugin)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_get_package (GstPlugin $plugin)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_get_release_date_string (GstPlugin $plugin)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_get_source (GstPlugin $plugin)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_get_version (GstPlugin $plugin)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_is_loaded (GstPlugin $plugin)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_list_free (GList $list)
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_load (GstPlugin $plugin)
  returns GstPlugin
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_load_by_name (Str $name)
  returns GstPlugin
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_load_file (Str $filename, CArray[Pointer[GError]] $error)
  returns GstPlugin
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_register_static (
  gint $major_version,
  gint $minor_version,
  Str $name,
  Str $description,
  GstPluginInitFunc $init_func,
  Str $version,
  Str $license,
  Str $source,
  Str $package,
  Str $origin
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_register_static_full (
  gint $major_version,
  gint $minor_version,
  Str $name,
  Str $description,
  GstPluginInitFullFunc $init_full_func,
  Str $version,
  Str $license,
  Str $source,
  Str $package,
  Str $origin,
  gpointer $user_data
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_get_cache_data (GstPlugin $plugin)
  returns GstStructure
  is native(gstreamer)
  is export
{ * }

sub gst_plugin_set_cache_data (GstPlugin $plugin, GstStructure $cache_data)
  is native(gstreamer)
  is export
{ * }
