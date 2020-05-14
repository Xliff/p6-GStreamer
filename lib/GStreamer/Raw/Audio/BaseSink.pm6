use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Structs;
use GStreamer::Raw::Audio::Enums;
use GStreamer::Raw::Audio::Structs;

### /usr/include/gstreamer-1.0/gst/audio/gstaudiobasesink.h

sub gst_audio_base_sink_create_ringbuffer (GstAudioBaseSink $sink)
  returns GstAudioRingBuffer
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_base_sink_get_alignment_threshold (GstAudioBaseSink $sink)
  returns GstClockTime
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_base_sink_get_discont_wait (GstAudioBaseSink $sink)
  returns GstClockTime
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_base_sink_get_drift_tolerance (GstAudioBaseSink $sink)
  returns gint64
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_base_sink_get_provide_clock (GstAudioBaseSink $sink)
  returns uint32
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_base_sink_get_slave_method (GstAudioBaseSink $sink)
  returns GstAudioBaseSinkSlaveMethod
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_base_sink_get_type ()
  returns GType
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_base_sink_report_device_failure (GstAudioBaseSink $sink)
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_base_sink_set_alignment_threshold (
  GstAudioBaseSink $sink,
  GstClockTime $alignment_threshold
)
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_base_sink_set_custom_slaving_callback (
  GstAudioBaseSink $sink,
  &callback (
    GstAudioBaseSink,
    GstClockTime,
    GstClockTime,
    GstClockTimeDiff,
    GstAudioBaseSinkDiscontReason
  ),
  gpointer $user_data,
  GDestroyNotify $notify
)
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_base_sink_set_discont_wait (
  GstAudioBaseSink $sink,
  GstClockTime $discont_wait
)
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_base_sink_set_drift_tolerance (
  GstAudioBaseSink $sink,
  gint64 $drift_tolerance
)
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_base_sink_set_provide_clock (
  GstAudioBaseSink $sink,
  gboolean $provide
)
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_base_sink_set_slave_method (
  GstAudioBaseSink $sink,
  GstAudioBaseSinkSlaveMethod $method
)
  is native(gstreamer-audio)
  is export
{ * }
