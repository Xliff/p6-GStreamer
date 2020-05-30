use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::Preset;

### /usr/include/gstreamer-1.0/gst/gstpreset.h

sub gst_preset_delete_preset (GstPreset $preset, Str $name)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_preset_get_app_dir ()
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_preset_get_meta (
  GstPreset $preset,
  Str $name,
  Str $tag,
  CArray[Str] $value
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_preset_get_preset_names (GstPreset $preset)
  returns CArray[Str]
  is native(gstreamer)
  is export
{ * }

sub gst_preset_get_property_names (GstPreset $preset)
  returns CArray[Str]
  is native(gstreamer)
  is export
{ * }

sub gst_preset_is_editable (GstPreset $preset)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_preset_load_preset (GstPreset $preset, Str $name)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_preset_rename_preset (GstPreset $preset, Str $old_name, Str $new_name)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_preset_save_preset (GstPreset $preset, Str $name)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_preset_set_app_dir (Str $app_dir)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_preset_set_meta (GstPreset $preset, Str $name, Str $tag, Str $value)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_preset_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }
