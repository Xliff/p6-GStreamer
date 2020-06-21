use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Structs;
use GStreamer::Raw::Audio::Structs;

### /usr/include/gstreamer-1.0/gst/audio/gstaudioclock.h

sub gst_audio_clock_adjust (GstAudioClock $clock, GstClockTime $time)
  returns GstClockTime
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_clock_get_time (GstAudioClock $clock)
  returns GstClockTime
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_clock_invalidate (GstAudioClock $clock)
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_clock_new (
  Str $name,
  &func (GstClock, gpointer --> GstClockTime),
  gpointer $user_data,
  GDestroyNotify $destroy_notify
)
  returns GstClock
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_clock_reset (GstAudioClock $clock, GstClockTime $time)
  is native(gstreamer-audio)
  is export
{ * }
