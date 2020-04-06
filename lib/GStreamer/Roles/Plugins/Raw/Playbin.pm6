use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

unit package GStreamer::Roles::Plugins::Raw::Playbin;

constant playback = 'gstplayback';

# GstPlayBin, GstCaps, gpointer --> GstSample
sub g-connect-convert-sample(
  GObject $app,
  Str $name,
  &handler (GObject, GstCaps, Pointer --> GstSample),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is export
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }

# GstPlayBin, gint, gpointer --> GstTagList
sub g-connect-get-tags(
  GObject $app,
  Str $name,
  &handler (GObject, gint, Pointer --> GstTagList),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is export
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }

# GstPlayBin, gint, gpointer --> GstPad
sub g-connect-get-pad(
  GObject $app,
  Str $name,
  &handler (GObject, gint, Pointer --> GstPad),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is export
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }

# GstPlayBin, GstElement, gpointer
sub g-connect-source-setup(
  GObject $app,
  Str $name,
  &handler (GObject, GstElement, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is export
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }

# GstPlayBin, gint, gpointer
sub g-connect-tags-changed(
  GObject $app,
  Str $name,
  &handler (GObject, gint, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is export
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }

sub g-signal-emit-get-tags (
  Pointer $instance,
  Str $detailed_signal,
  guint $index,
  CArray[Pointer[GstTagList]] $taglist
)
  is export
  is native(gobject)
  is symbol('g_signal_emit_by_name')
{ * }

sub gst_play_flags_get_type ()
  returns GType
  is export
  is native(playback)
{ * }
