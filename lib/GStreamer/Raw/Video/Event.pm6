use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::Video::Event;

### /usr/include/gstreamer-1.0/gst/video/video-event.h

sub gst_video_event_is_force_key_unit (GstEvent $event)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_event_new_downstream_force_key_unit (
  GstClockTime $timestamp,
  GstClockTime $stream_time,
  GstClockTime $running_time,
  gboolean $all_headers,
  guint $count
)
  returns GstEvent
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_event_new_still_frame (gboolean $in_still)
  returns GstEvent
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_event_new_upstream_force_key_unit (
  GstClockTime $running_time,
  gboolean $all_headers,
  guint $count
)
  returns GstEvent
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_event_parse_downstream_force_key_unit (
  GstEvent $event            is rw,
  GstClockTime $timestamp    is rw,
  GstClockTime $stream_time  is rw,
  GstClockTime $running_time is rw,
  gboolean $all_headers      is rw,
  guint $count               is rw
)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_event_parse_still_frame (GstEvent $event, gboolean $in_still)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_event_parse_upstream_force_key_unit (
  GstEvent $event,
  GstClockTime $running_time is rw,
  gboolean $all_headers is rw,
  guint $count is rw
)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }
