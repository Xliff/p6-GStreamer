use v6.c;

use NativeCall;

use GLib::Raw::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::Audio::Structs;

unit package GStreamer::Raw::Audio::RingBuffer;

### /usr/include/gstreamer-1.0/gst/audio/gstaudioringbuffer.h

sub gst_audio_ring_buffer_acquire (
  GstAudioRingBuffer $buf,
  GstAudioRingBufferSpec $spec
)
  returns uint32
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_activate (GstAudioRingBuffer $buf, gboolean $active)
  returns uint32
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_advance (GstAudioRingBuffer $buf, guint $advance)
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_clear (GstAudioRingBuffer $buf, gint $segment)
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_clear_all (GstAudioRingBuffer $buf)
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_close_device (GstAudioRingBuffer $buf)
  returns uint32
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_commit (
  GstAudioRingBuffer $buf,
  guint64 $sample is rw,
  Pointer $data,
  gint $in_samples,
  gint $out_samples,
  gint $accum is rw
)
  returns guint
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_convert (
  GstAudioRingBuffer $buf,
  GstFormat $src_fmt,
  gint64 $src_val,
  GstFormat $dest_fmt,
  gint64 $dest_val is rw
)
  returns uint32
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_delay (GstAudioRingBuffer $buf)
  returns guint
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_device_is_open (GstAudioRingBuffer $buf)
  returns uint32
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_get_type ()
  returns GType
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_is_acquired (GstAudioRingBuffer $buf)
  returns uint32
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_is_active (GstAudioRingBuffer $buf)
  returns uint32
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_is_flushing (GstAudioRingBuffer $buf)
  returns uint32
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_may_start (
  GstAudioRingBuffer $buf,
  gboolean $allowed
)
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_open_device (GstAudioRingBuffer $buf)
  returns uint32
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_pause (GstAudioRingBuffer $buf)
  returns uint32
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_prepare_read (
  GstAudioRingBuffer $buf,
  gint $segment is rw,
  CArray[CArray[guint8]] $readptr,
  gint $len is rw
)
  returns uint32
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_read (
  GstAudioRingBuffer $buf,
  guint64 $sample,
  Pointer $data,
  guint $len,
  GstClockTime $timestamp is rw
)
  returns guint
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_release (GstAudioRingBuffer $buf)
  returns uint32
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_samples_done (GstAudioRingBuffer $buf)
  returns guint64
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_set_callback (
  GstAudioRingBuffer $buf,
  &cb (GstAudioRingBuffer, CArray[guint8], guint, gpointer),
  gpointer $user_data
)
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_set_callback_full (
  GstAudioRingBuffer $buf,
  &cb (GstAudioRingBuffer, CArray[guint8], guint, gpointer),
  gpointer $user_data,
  GDestroyNotify $notify
)
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_set_channel_positions (
  GstAudioRingBuffer $buf,
  GstAudioChannelPosition $position
)
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_set_flushing (
  GstAudioRingBuffer $buf,
  gboolean $flushing
)
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_set_sample (GstAudioRingBuffer $buf, guint64 $sample)
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_set_timestamp (
  GstAudioRingBuffer $buf,
  gint $readseg,
  GstClockTime $timestamp
)
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_start (GstAudioRingBuffer $buf)
  returns uint32
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_ring_buffer_stop (GstAudioRingBuffer $buf)
  returns uint32
  is native(gstreamer-audio)
  is export
{ * }
