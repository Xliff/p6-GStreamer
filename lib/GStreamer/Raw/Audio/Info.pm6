use v6.c;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Enums;
use GStreamer::Raw::Structs;
use GStreamer::Raw::Audio::Enums;
use GStreamer::Raw::Audio::Structs;

### /usr/include/gstreamer-1.0/gst/audio/audio-info.h

sub gst_audio_info_convert (
  GstAudioInfo $info,
  GstFormat $src_fmt,
  gint64 $src_val,
  GstFormat $dest_fmt,
  gint64 $dest_val is rw
)
  returns uint32
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_info_copy (GstAudioInfo $info)
  returns GstAudioInfo
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_info_free (GstAudioInfo $info)
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_info_from_caps (GstAudioInfo $info, GstCaps $caps)
  returns uint32
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_info_get_type ()
  returns GType
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_info_init (GstAudioInfo $info)
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_info_is_equal (GstAudioInfo $info, GstAudioInfo $other)
  returns uint32
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_info_new ()
  returns GstAudioInfo
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_info_set_format (
  GstAudioInfo $info,
  GstAudioFormat $format,
  gint $rate,
  gint $channels,
  GstAudioChannelPosition $position
)
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_info_to_caps (GstAudioInfo $info)
  returns GstCaps
  is native(gstreamer-audio)
  is export
{ * }
