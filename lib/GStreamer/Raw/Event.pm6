use v6.c;

use GTK::Compat::Types;
use GStreamer::Raw::Types;

unit package GStreamer::Raw::Event;

sub gst_event_copy_segment (GstEvent $event, GstSegment $segment)
  is native(gstreamer)
  is export
{ * }

sub gst_event_get_structure (GstEvent $event)
  returns GstStructure
  is native(gstreamer)
  is export
{ * }

sub gst_event_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_event_has_name (GstEvent $event, Str $name)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_event_new_buffer_size (
  GstFormat $format,
  gint64 $minsize,
  gint64 $maxsize,
  gboolean $async
)
  returns GstEvent
  is native(gstreamer)
  is export
{ * }

sub gst_event_new_caps (GstCaps $caps)
  returns GstEvent
  is native(gstreamer)
  is export
{ * }

sub gst_event_new_custom (GstEventType $type, GstStructure $structure)
  returns GstEvent
  is native(gstreamer)
  is export
{ * }

sub gst_event_new_eos ()
  returns GstEvent
  is native(gstreamer)
  is export
{ * }

sub gst_event_new_flush_start ()
  returns GstEvent
  is native(gstreamer)
  is export
{ * }

sub gst_event_new_flush_stop (gboolean $reset_time)
  returns GstEvent
  is native(gstreamer)
  is export
{ * }

sub gst_event_new_gap (GstClockTime $timestamp, GstClockTime $duration)
  returns GstEvent
  is native(gstreamer)
  is export
{ * }

sub gst_event_new_latency (GstClockTime $latency)
  returns GstEvent
  is native(gstreamer)
  is export
{ * }

sub gst_event_new_navigation (GstStructure $structure)
  returns GstEvent
  is native(gstreamer)
  is export
{ * }

sub gst_event_new_protection (Str $system_id, GstBuffer $data, Str $origin)
  returns GstEvent
  is native(gstreamer)
  is export
{ * }

sub gst_event_new_qos (
  GstQOSType $type,
  gdouble $proportion,
  GstClockTimeDiff $diff,
  GstClockTime $timestamp
)
  returns GstEvent
  is native(gstreamer)
  is export
{ * }

sub gst_event_new_reconfigure ()
  returns GstEvent
  is native(gstreamer)
  is export
{ * }

sub gst_event_new_seek (
  gdouble $rate,
  GstFormat $format,
  GstSeekFlags $flags,
  GstSeekType $start_type,
  gint64 $start,
  GstSeekType $stop_type,
  gint64 $stop
)
  returns GstEvent
  is native(gstreamer)
  is export
{ * }

sub gst_event_new_segment (GstSegment $segment)
  returns GstEvent
  is native(gstreamer)
  is export
{ * }

sub gst_event_new_segment_done (GstFormat $format, gint64 $position)
  returns GstEvent
  is native(gstreamer)
  is export
{ * }

sub gst_event_new_select_streams (GList $streams)
  returns GstEvent
  is native(gstreamer)
  is export
{ * }

sub gst_event_new_sink_message (Str $name, GstMessage $msg)
  returns GstEvent
  is native(gstreamer)
  is export
{ * }

sub gst_event_new_step (
  GstFormat $format,
  guint64 $amount,
  gdouble $rate,
  gboolean $flush,
  gboolean $intermediate
)
  returns GstEvent
  is native(gstreamer)
  is export
{ * }

sub gst_event_new_stream_collection (GstStreamCollection $collection)
  returns GstEvent
  is native(gstreamer)
  is export
{ * }

sub gst_event_new_stream_group_done (guint $group_id)
  returns GstEvent
  is native(gstreamer)
  is export
{ * }

sub gst_event_new_stream_start (Str $stream_id)
  returns GstEvent
  is native(gstreamer)
  is export
{ * }

sub gst_event_new_tag (GstTagList $taglist)
  returns GstEvent
  is native(gstreamer)
  is export
{ * }

sub gst_event_new_toc (GstToc $toc, gboolean $updated)
  returns GstEvent
  is native(gstreamer)
  is export
{ * }

sub gst_event_new_toc_select (Str $uid)
  returns GstEvent
  is native(gstreamer)
  is export
{ * }

sub gst_event_parse_buffer_size (
  GstEvent $event,
  GstFormat $formatis rw,
  gint64 $minsize  is rw,
  gint64 $maxsize  is rw,
  gboolean $async  is rw
)
  is native(gstreamer)
  is export
{ * }

sub gst_event_parse_caps (GstEvent $event, GstCaps $caps is rw)
  is native(gstreamer)
  is export
{ * }

sub gst_event_parse_flush_stop (GstEvent $event, gboolean $reset_time is rw)
  is native(gstreamer)
  is export
{ * }

sub gst_event_parse_gap (
  GstEvent $event,
  GstClockTime $timestamp is rw,
  GstClockTime $duration  is rw
)
  is native(gstreamer)
  is export
{ * }

sub gst_event_parse_group_id (GstEvent $event, guint $group_id is rw)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_event_parse_latency (GstEvent $event, GstClockTime $latency is rw)
  is native(gstreamer)
  is export
{ * }

sub gst_event_parse_protection (
  GstEvent $event,
  CArray[Str] $system_id ,
  CArray[Pointer[GstBuffer]] $data,
  CArray[Str] $origin
)
  is native(gstreamer)
  is export
{ * }

sub gst_event_parse_qos (
  GstEvent $event,
  GstQOSType $type        is rw,
  gdouble $proportion     is rw,
  GstClockTimeDiff $diff  is rw,
  GstClockTime $timestamp is rw
)
  is native(gstreamer)
  is export
{ * }

sub gst_event_parse_seek (
  GstEvent $event,
  gdouble $rate           is rw,
  GstFormat $format       is rw,
  GstSeekFlags $flags     is rw,
  GstSeekType $start_type is rw,
  gint64 $start           is rw,
  GstSeekType $stop_type  is rw,
  gint64 $stop            is rw
)
  is native(gstreamer)
  is export
{ * }

sub gst_event_parse_seek_trickmode_interval (
  GstEvent $event,
  GstClockTime $interval is rw
)
  is native(gstreamer)
  is export
{ * }

sub gst_event_parse_segment (GstEvent $event, GstSegment $segment is rw)
  is native(gstreamer)
  is export
{ * }

sub gst_event_parse_segment_done (
  GstEvent $event,
  GstFormat $format is rw,
  gint64 $position  is rw
)
  is native(gstreamer)
  is export
{ * }

sub gst_event_parse_select_streams (
  GstEvent $event,
  CArray[Pointer[GList]] $streams
)
  is native(gstreamer)
  is export
{ * }

sub gst_event_parse_sink_message (
  GstEvent $event,
  CArray[Pointer[GstMessage]] $msg
)
  is native(gstreamer)
  is export
{ * }

sub gst_event_parse_step (
  GstEvent $event,
  GstFormat $format      is rw,
  guint64 $amount        is rw,
  gdouble $rate          is rw,
  gboolean $flush        is rw,
  gboolean $intermediate is rw
)
  is native(gstreamer)
  is export
{ * }

sub gst_event_parse_stream (
  GstEvent $event,
  CArray[Pointer[GstStream]] $stream
)
  is native(gstreamer)
  is export
{ * }

sub gst_event_parse_stream_collection (
  GstEvent $event,
  CArray[Pointer[GstStreamCollection]] $collection
)
  is native(gstreamer)
  is export
{ * }

sub gst_event_parse_stream_flags (
  GstEvent $event,
  CArray[GstStreamFlags] $flags
)
  is native(gstreamer)
  is export
{ * }

sub gst_event_parse_stream_group_done (
  GstEvent $event,
  guint $group_id is rw
)
  is native(gstreamer)
  is export
{ * }

sub gst_event_parse_stream_start (
  GstEvent $event,
  CArray[Str] $stream_id
)
  is native(gstreamer)
  is export
{ * }

sub gst_event_parse_tag (
  GstEvent $event,
  CArray[Pointer[GstTagList]] $taglist
)
  is native(gstreamer)
  is export
{ * }

sub gst_event_parse_toc (
  GstEvent $event,
  CArray[Pointer[GstToc]] $toc,
  gboolean $updated is rw
)
  is native(gstreamer)
  is export
{ * }

sub gst_event_parse_toc_select (
  GstEvent $event,
  CArray[Str] $uid
)
  is native(gstreamer)
  is export
{ * }

sub gst_event_set_group_id (GstEvent $event, guint $group_id)
  is native(gstreamer)
  is export
{ * }

sub gst_event_set_seek_trickmode_interval (
  GstEvent $event,
  GstClockTime $interval
)
  is native(gstreamer)
  is export
{ * }

sub gst_event_set_stream (GstEvent $event, GstStream $stream)
  is native(gstreamer)
  is export
{ * }

sub gst_event_set_stream_flags (GstEvent $event, GstStreamFlags $flags)
  is native(gstreamer)
  is export
{ * }

sub gst_event_type_get_flags (GstEventType $type)
  returns GstEventTypeFlags
  is native(gstreamer)
  is export
{ * }

sub gst_event_type_get_name (GstEventType $type)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_event_type_to_quark (GstEventType $type)
  returns GQuark
  is native(gstreamer)
  is export
{ * }

sub gst_event_writable_structure (GstEvent $event)
  returns GstStructure
  is native(gstreamer)
  is export
{ * }

sub gst_event_get_running_time_offset (GstEvent $event)
  returns gint64
  is native(gstreamer)
  is export
{ * }

sub gst_event_get_seqnum (GstEvent $event)
  returns guint32
  is native(gstreamer)
  is export
{ * }

sub gst_event_set_running_time_offset (GstEvent $event, gint64 $offset)
  is native(gstreamer)
  is export
{ * }

sub gst_event_set_seqnum (GstEvent $event, guint32 $seqnum)
  is native(gstreamer)
  is export
{ * }
