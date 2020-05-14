use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Structs;
use GStreamer::Raw::Audio::Enums;
use GStreamer::Raw::Audio::Structs;

### /usr/include/gstreamer-1.0/gst/audio/audio-converter.h

sub gst_audio_converter_convert (
  GstAudioConverter $convert,
  GstAudioConverterFlags $flags,
  gpointer $in,
  gsize $in_size,
  gpointer $out,
  gsize $out_size
)
  returns uint32
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_converter_free (GstAudioConverter $convert)
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_converter_get_config (
  GstAudioConverter $convert,
  gint $in_rate is rw,
  gint $out_rate is rw
)
  returns GstStructure
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_converter_get_in_frames (
  GstAudioConverter $convert,
  gsize $out_frames
)
  returns gsize
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_converter_get_max_latency (GstAudioConverter $convert)
  returns gsize
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_converter_get_out_frames (
  GstAudioConverter $convert,
  gsize $in_frames
)
  returns gsize
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_converter_get_type ()
  returns GType
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_converter_is_passthrough (GstAudioConverter $convert)
  returns uint32
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_converter_new (
  GstAudioConverterFlags $flags,
  GstAudioInfo $in_info,
  GstAudioInfo $out_info,
  GstStructure $config
)
  returns GstAudioConverter
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_converter_reset (GstAudioConverter $convert)
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_converter_samples (
  GstAudioConverter $convert,
  GstAudioConverterFlags $flags,
  gpointer $in,
  gsize $in_frames,
  gpointer $out,
  gsize $out_frames
)
  returns uint32
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_converter_supports_inplace (GstAudioConverter $convert)
  returns uint32
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_converter_update_config (
  GstAudioConverter $convert,
  gint $in_rate,
  gint $out_rate,
  GstStructure $config
)
  returns uint32
  is native(gstreamer-audio)
  is export
{ * }
