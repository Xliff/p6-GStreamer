use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Audio::Enums;
use GStreamer::Raw::Audio::Structs;

### /usr/include/gstreamer-1.0/gst/audio/gstaudiobasesrc.h

sub gst_audio_base_src_create_ringbuffer (GstAudioBaseSrc $src)
  returns GstAudioRingBuffer
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_base_src_get_provide_clock (GstAudioBaseSrc $src)
  returns uint32
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_base_src_get_slave_method (GstAudioBaseSrc $src)
  returns GstAudioBaseSrcSlaveMethod
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_base_src_get_type ()
  returns GType
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_base_src_set_provide_clock (
  GstAudioBaseSrc $src,
  gboolean $provide
)
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_base_src_set_slave_method (
  GstAudioBaseSrc $src,
  GstAudioBaseSrcSlaveMethod $method
)
  is native(gstreamer-audio)
  is export
{ * }
