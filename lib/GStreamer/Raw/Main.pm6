use v6.c;

use NativeCall;


use GStreamer::Raw::Types;

unit package GStreamer::Raw::Main;

sub gst_deinit ()
  is native(gstreamer)
  is export
{ * }

sub gst_get_main_executable_path ()
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_init_get_option_group ()
  returns GOptionGroup
  is native(gstreamer)
  is export
{ * }

sub gst_is_initialized ()
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_registry_fork_is_enabled ()
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_registry_fork_set_enabled (gboolean $enabled)
  is native(gstreamer)
  is export
{ * }

sub gst_segtrap_is_enabled ()
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_segtrap_set_enabled (gboolean $enabled)
  is native(gstreamer)
  is export
{ * }

sub gst_update_registry ()
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_version (
  guint $major is rw,
  guint $minor is rw,
  guint $micro is rw,
  guint $nano  is rw
)
  is native(gstreamer)
  is export
{ * }

sub gst_version_string ()
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_init (
  gint $argc is rw,
  CArray[Str] $argv
)
  is native(gstreamer)
  is export
{ * }

sub gst_init_check (
  gint $argc is rw,
  CArray[Str] $argv,
  CArray[Pointer[GError]] $error
)
  returns gboolean
  is native(gstreamer)
  is export
{ * }
