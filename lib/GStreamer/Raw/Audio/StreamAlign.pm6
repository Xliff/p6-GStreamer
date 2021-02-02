use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Enums;
use GStreamer::Raw::Definitions;

unit package GStreamer::Raw::Audio::StreamAlign;

### /usr/include/gstreamer-1.0/gst/audio/gstaudiostreamalign.h

sub gst_audio_stream_align_copy (GstAudioStreamAlign $align)
  returns GstAudioStreamAlign
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_stream_align_free (GstAudioStreamAlign $align)
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_stream_align_get_alignment_threshold (GstAudioStreamAlign $align)
  returns GstClockTime
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_stream_align_get_discont_wait (GstAudioStreamAlign $align)
  returns GstClockTime
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_stream_align_get_rate (GstAudioStreamAlign $align)
  returns gint
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_stream_align_get_samples_since_discont (
  GstAudioStreamAlign $align
)
  returns guint64
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_stream_align_get_timestamp_at_discont (
  GstAudioStreamAlign $align
)
  returns GstClockTime
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_stream_align_get_type ()
  returns GType
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_stream_align_mark_discont (GstAudioStreamAlign $align)
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_stream_align_new (
  gint $rate,
  GstClockTime $alignment_threshold,
  GstClockTime $discont_wait
)
  returns GstAudioStreamAlign
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_stream_align_process (
  GstAudioStreamAlign $align,
  gboolean $discont,
  GstClockTime $timestamp,
  guint $n_samples,
  GstClockTime $out_timestamp is rw,
  GstClockTime $out_duration is rw,
  guint64 $out_sample_position is rw
)
  returns uint32
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_stream_align_set_alignment_threshold (
  GstAudioStreamAlign $align,
  GstClockTime $alignment_threshold
)
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_stream_align_set_discont_wait (
  GstAudioStreamAlign $align,
  GstClockTime $discont_wait
)
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_stream_align_set_rate (GstAudioStreamAlign $align, gint $rate)
  is native(gstreamer-audio)
  is export
{ * }
