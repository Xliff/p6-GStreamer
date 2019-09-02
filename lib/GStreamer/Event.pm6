use v6.c;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::Event;

use VStreamer::MiniObject;

our subset EventAncestry is export of Mu
  where GstEvent | GstMiniObject;

class GStreamer::Event is GStreamer::MiniObject {
  has GstEvent $!e;

  submethod BUILD (:$event) {
    self.setEvent($event);
  }

  method setEvent(EventAncestry $_) {
    my $to-parent;

    $!e = do {
      when GstEvent {
        $to-parent = cast(GstMiniObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstEvent, $_);
      }
    }
    self.setMiniObject($to-parent);
  }

  method new_buffer_size (gint64 $minsize, gint64 $maxsize, gboolean $async) {
    gst_event_new_buffer_size($!e, $minsize, $maxsize, $async);
  }

  method new_caps {
    gst_event_new_caps($!e);
  }

  method new_custom (GstStructure() $structure) {
    gst_event_new_custom($!e, $structure);
  }

  method new_eos {
    gst_event_new_eos($!e);
  }

  method new_flush_start {
    gst_event_new_flush_start($!e);
  }

  method new_flush_stop {
    gst_event_new_flush_stop($!e);
  }

  method new_gap (GstClockTime $duration) {
    gst_event_new_gap($!e, $duration);
  }

  method new_latency {
    gst_event_new_latency($!e);
  }

  method new_navigation {
    gst_event_new_navigation($!e);
  }

  method new_protection (GstBuffer() $data, Str() $origin) {
    gst_event_new_protection($!e, $data, $origin);
  }

  method new_qos (
    gdouble $proportion,
    GstClockTimeDiff $diff,
    GstClockTime $timestamp
  ) {
    gst_event_new_qos($!e, $proportion, $diff, $timestamp);
  }

  method new_reconfigure {
    gst_event_new_reconfigure($!e);
  }

  method new_seek (
    GstFormat $format,
    GstSeekFlags $flags,
    GstSeekType $start_type,
    gint64 $start,
    GstSeekType $stop_type,
    gint64 $stop
  ) {
    gst_event_new_seek($!e, $format, $flags, $start_type, $start, $stop_type, $stop);
  }

  method new_segment {
    gst_event_new_segment($!e);
  }

  method new_segment_done (gint64 $position) {
    gst_event_new_segment_done($!e, $position);
  }

  method new_select_streams {
    gst_event_new_select_streams($!e);
  }

  method new_sink_message (GstMessage() $msg) {
    gst_event_new_sink_message($!e, $msg);
  }

  method new_step (
    guint64 $amount,
    gdouble $rate,
    gboolean $flush,
    gboolean $intermediate
  ) {
    gst_event_new_step($!e, $amount, $rate, $flush, $intermediate);
  }

  method new_stream_collection {
    gst_event_new_stream_collection($!e);
  }

  method new_stream_group_done {
    gst_event_new_stream_group_done($!e);
  }

  method new_stream_start {
    gst_event_new_stream_start($!e);
  }

  method new_tag {
    gst_event_new_tag($!e);
  }

  method new_toc (gboolean $updated) {
    gst_event_new_toc($!e, $updated);
  }

  method new_toc_select {
    gst_event_new_toc_select($!e);
  }

  method running_time_offset is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_event_get_running_time_offset($!e);
      },
      STORE => sub ($, Int() $offset is copy) {
        my guint64 $o = $offset;

        gst_event_set_running_time_offset($!e, $o);
      }
    );
  }

  method seqnum is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_event_get_seqnum($!e);
      },
      STORE => sub ($, Int() $seqnum is copy) {
        my guint $sn = $seqnum;

        gst_event_set_seqnum($!e, $sn);
      }
    );
  }

  method copy_segment (GstSegment() $segment) {
    gst_event_copy_segment($!e, $segment);
  }

  method get_structure {
    gst_event_get_structure($!e);
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_event_get_type, $n, $t );
  }

  method has_name (Str() $name) {
    so gst_event_has_name($!e, $name);
  }

  method parse_buffer_size (
    GstFormat $format,
    gint64 $minsize,
    gint64 $maxsize,
    gboolean $async
  ) {
    gst_event_parse_buffer_size($!e, $format, $minsize, $maxsize, $async);
  }

  method parse_caps (GstCaps() $caps) {
    gst_event_parse_caps($!e, $caps);
  }

  method parse_flush_stop (gboolean $reset_time) {
    gst_event_parse_flush_stop($!e, $reset_time);
  }

  method parse_gap (GstClockTime $timestamp, GstClockTime $duration) {
    gst_event_parse_gap($!e, $timestamp, $duration);
  }

  proto method parse_group_id
  { * }

  method parse_group_id (:$all = False) {
    samewith($, :$all)
  }
  method parse_group_id ($group_id is rw, :$all = False) {
    my guint $g = 0
    my $rc = gst_event_parse_group_id($!e, $g);

    $group_id = $rc ?? $g !! Nil;
    $all.not ?? $group_id !! ($group_id, $rc);
  }

  method parse_latency (GstClockTime $latency) {
    gst_event_parse_latency($!e, $latency);
  }

  method parse_protection (Str() $system_id, GstBuffer() $data, Str() $origin) {
    gst_event_parse_protection($!e, $system_id, $data, $origin);
  }

  method parse_qos (
    GstQOSType $type,
    gdouble $proportion,
    GstClockTimeDiff $diff,
    GstClockTime $timestamp
  ) {
    gst_event_parse_qos($!e, $type, $proportion, $diff, $timestamp);
  }

  method parse_seek (
    gdouble $rate,
    GstFormat $format,
    GstSeekFlags $flags,
    GstSeekType $start_type,
    gint64 $start,
    GstSeekType $stop_type,
    gint64 $stop
  ) {
    gst_event_parse_seek($!e, $rate, $format, $flags, $start_type, $start, $stop_type, $stop);
  }

  method parse_seek_trickmode_interval (GstClockTime $interval) {
    gst_event_parse_seek_trickmode_interval($!e, $interval);
  }

  method parse_segment (GstSegment $segment) {
    gst_event_parse_segment($!e, $segment);
  }

  method parse_segment_done (GstFormat $format, gint64 $position) {
    gst_event_parse_segment_done($!e, $format, $position);
  }

  method parse_select_streams (GList $streams) {
    gst_event_parse_select_streams($!e, $streams);
  }

  method parse_sink_message (GstMessage $msg) {
    gst_event_parse_sink_message($!e, $msg);
  }

  method parse_step (
    GstFormat $format,
    guint64 $amount,
    gdouble $rate,
    gboolean $flush,
    gboolean $intermediate
  ) {
    gst_event_parse_step($!e, $format, $amount, $rate, $flush, $intermediate);
  }

  method parse_stream (GstStream $stream) {
    gst_event_parse_stream($!e, $stream);
  }

  method parse_stream_collection (GstStreamCollection() $collection) {
    gst_event_parse_stream_collection($!e, $collection);
  }

  method parse_stream_flags (GstStreamFlags $flags) {
    gst_event_parse_stream_flags($!e, $flags);
  }

  method parse_stream_group_done (guint $group_id) {
    gst_event_parse_stream_group_done($!e, $group_id);
  }

  method parse_stream_start (Str() $stream_id) {
    gst_event_parse_stream_start($!e, $stream_id);
  }

  method parse_tag (GstTagList() $taglist) {
    gst_event_parse_tag($!e, $taglist);
  }

  method parse_toc (GstToc() $toc, gboolean $updated) {
    gst_event_parse_toc($!e, $toc, $updated);
  }

  method parse_toc_select (Str() $uid) {
    gst_event_parse_toc_select($!e, $uid);
  }

  method set_group_id (guint $group_id) {
    gst_event_set_group_id($!e, $group_id);
  }

  method set_seek_trickmode_interval (GstClockTime $interval) {
    gst_event_set_seek_trickmode_interval($!e, $interval);
  }

  method set_stream (GstStream() $stream) {
    gst_event_set_stream($!e, $stream);
  }

  method set_stream_flags (GstStreamFlags $flags) {
    gst_event_set_stream_flags($!e, $flags);
  }

  method type_get_flags {
    gst_event_type_get_flags($!e);
  }

  method type_get_name {
    gst_event_type_get_name($!e);
  }

  method type_to_quark {
    gst_event_type_to_quark($!e);
  }

  method writable_structure {
    gst_event_writable_structure($!e);
  }


}
