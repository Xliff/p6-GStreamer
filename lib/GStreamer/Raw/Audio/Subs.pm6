use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Audio::Enums;
use GStreamer::Raw::Audio::Structs;

unit package GStreamer::Raw::Audio::Subs;

sub sprintf-GstAudioFormatPack (
  Blob,
  Str,
  & (GstAudioFormatInfo, GstAudioPackFlags, Pointer, Pointer, gint),
  gpointer
)
  returns int64
  is export
  is native
  is symbol('sprintf')
{ * }
