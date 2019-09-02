use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GStreamer::Raw::Types;

unit package GStreamer::Roles::Plugins::Raw::Playbin;

constant GstAutoplugSelectResult is export := guint32;
our enum GstAutoplugSelectResultEnum is export <
    GST_AUTOPLUG_SELECT_TRY
    GST_AUTOPLUG_SELECT_EXPOSE
    GST_AUTOPLUG_SELECT_SKIP
>;

constant GstPlayFlags is export := guint32;
our enum GstPlayFlagsEnum is export (
  GST_PLAY_FLAG_VIDEO             => 1,
  GST_PLAY_FLAG_AUDIO             => (1 +< 1),
  GST_PLAY_FLAG_TEXT              => (1 +< 2),
  GST_PLAY_FLAG_VIS               => (1 +< 3),
  GST_PLAY_FLAG_SOFT_VOLUME       => (1 +< 4),
  GST_PLAY_FLAG_NATIVE_AUDIO      => (1 +< 5),
  GST_PLAY_FLAG_NATIVE_VIDEO      => (1 +< 6),
  GST_PLAY_FLAG_DOWNLOAD          => (1 +< 7),
  GST_PLAY_FLAG_BUFFERING         => (1 +< 8),
  GST_PLAY_FLAG_DEINTERLACE       => (1 +< 9),
  GST_PLAY_FLAG_SOFT_COLORBALANCE => (1 +< 10),
  GST_PLAY_FLAG_FORCE_FILTERS     => (1 +< 11),
);

constant GstPlaySinkType is export := guint32;
our enum GstPlaySinkTypeEnum is export (
    GST_PLAY_SINK_TYPE_AUDIO     =>  0,
    GST_PLAY_SINK_TYPE_AUDIO_RAW =>  1,
    GST_PLAY_SINK_TYPE_VIDEO     =>  2,
    GST_PLAY_SINK_TYPE_VIDEO_RAW =>  3,
    GST_PLAY_SINK_TYPE_TEXT      =>  4,
    GST_PLAY_SINK_TYPE_LAST      =>  5,
    GST_PLAY_SINK_TYPE_FLUSHING  =>  6,
);

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
  is native('gobject-2.0')
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
  is native('gobject-2.0')
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
  is native('gobject-2.0')
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
  is native('gobject-2.0')
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
  is native('gobject-2.0')
  is symbol('g_signal_connect_object')
  { * }
