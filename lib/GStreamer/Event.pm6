use v6.c;

use Method::Also;
use NativeCall;


use GStreamer::Raw::Types;
use GStreamer::Raw::Event;

use GStreamer::MiniObject;

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

  method GStreamer::Raw::Types::GstEvent
    is also<GstEvent>
  { $!e }

  # method new_buffer_size (gint64 $minsize, gint64 $maxsize, gboolean $async) is also<new-buffer-size> {
  #   gst_event_new_buffer_size($!e, $minsize, $maxsize, $async);
  # }
  #
  # method new_caps is also<new-caps> {
  #   gst_event_new_caps($!e);
  # }
  #
  # method new_custom (GstStructure() $structure) is also<new-custom> {
  #   gst_event_new_custom($!e, $structure);
  # }
  #
  # method new_eos is also<new-eos> {
  #   gst_event_new_eos($!e);
  # }
  #
  # method new_flush_start is also<new-flush-start> {
  #   gst_event_new_flush_start($!e);
  # }
  #
  # method new_flush_stop is also<new-flush-stop> {
  #   gst_event_new_flush_stop($!e);
  # }
  #
  # method new_gap (GstClockTime $duration) is also<new-gap> {
  #   gst_event_new_gap($!e, $duration);
  # }
  #
  # method new_latency is also<new-latency> {
  #   gst_event_new_latency($!e);
  # }
  #
  # method new_navigation is also<new-navigation> {
  #   gst_event_new_navigation($!e);
  # }
  #
  # method new_protection (GstBuffer() $data, Str() $origin) is also<new-protection> {
  #   gst_event_new_protection($!e, $data, $origin);
  # }
  #
  # method new_qos (
  #   gdouble $proportion,
  #   GstClockTimeDiff $diff,
  #   GstClockTime $timestamp
  # ) is also<new-qos> {
  #   gst_event_new_qos($!e, $proportion, $diff, $timestamp);
  # }
  #
  # method new_reconfigure is also<new-reconfigure> {
  #   gst_event_new_reconfigure($!e);
  # }

  multi method new (
    Num() $rate,
    Int() $format,
    Int() $flags,
    Int() $start_type,
    Int() $start,
    Int() $stop_type,
    Int() $stop,
    :$seek is required
  ) {
    ::?CLASS.new_seek(
      $rate,
      $format,
      $flags,
      $start_type,
      $start,
      $stop_type,
      $stop
    );
  }
  method new_seek (
    Num() $rate,
    Int() $format,
    Int() $flags,
    Int() $start_type,
    Int() $start,
    Int() $stop_type,
    Int() $stop
  )
    is also<new-seek>
  {
    my gdouble $r = $rate;
    my GstFormat $f = $format;
    my GstSeekFlags $fl = $flags;
    my GstSeekType ($stt, $spt) = ($start_type, $stop_type);
    my gint64 ($st, $sp) = ($start, $stop);

    self.bless( event => gst_event_new_seek($r, $f, $f, $stt, $st, $spt, $sp) );
  }

  # method new_segment is also<new-segment> {
  #   gst_event_new_segment($!e);
  # }
  #
  # method new_segment_done (gint64 $position) is also<new-segment-done> {
  #   gst_event_new_segment_done($!e, $position);
  # }
  #
  # method new_select_streams is also<new-select-streams> {
  #   gst_event_new_select_streams($!e);
  # }
  #
  # method new_sink_message (GstMessage() $msg) is also<new-sink-message> {
  #   gst_event_new_sink_message($!e, $msg);
  # }

  multi method new (
    Int() $format,
    Int() $amount,
    Num() $rate,
    Int() $flush,
    Int() $intermediate,
    :$step is required
  ) {
    GStreamer::Event.new_step($format, $amount, $rate, $flush, $intermediate);
  }
  method new_step (
    Int() $format,
    Int() $amount,
    Num() $rate,
    Int() $flush,
    Int() $intermediate
  )
    is also<new-step>
  {
    my GstFormat $f = $format;
    my guint64 $a = $amount;
    my gdouble $r = $rate;
    my gboolean ($fl, $i) = ($flush, $intermediate);

    self.bless( event => gst_event_new_step($f, $a, $r, $fl, $i) );
  }

  # method new_stream_collection is also<new-stream-collection> {
  #   gst_event_new_stream_collection($!e);
  # }
  #
  # method new_stream_group_done is also<new-stream-group-done> {
  #   gst_event_new_stream_group_done($!e);
  # }
  #
  # method new_stream_start is also<new-stream-start> {
  #   gst_event_new_stream_start($!e);
  # }
  #
  # method new_tag is also<new-tag> {
  #   gst_event_new_tag($!e);
  # }
  #
  # method new_toc (gboolean $updated) is also<new-toc> {
  #   gst_event_new_toc($!e, $updated);
  # }
  #
  # method new_toc_select is also<new-toc-select> {
  #   gst_event_new_toc_select($!e);
  # }

  method running_time_offset is rw is also<running-time-offset> {
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

  method copy_segment (GstSegment() $segment) is also<copy-segment> {
    gst_event_copy_segment($!e, $segment);
  }

  method get_structure is also<get-structure> {
    gst_event_get_structure($!e);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_event_get_type, $n, $t );
  }

  method has_name (Str() $name) is also<has-name> {
    so gst_event_has_name($!e, $name);
  }

  method parse_buffer_size (
    GstFormat $format,
    gint64 $minsize,
    gint64 $maxsize,
    gboolean $async
  ) is also<parse-buffer-size> {
    gst_event_parse_buffer_size($!e, $format, $minsize, $maxsize, $async);
  }

  method parse_caps (GstCaps() $caps) is also<parse-caps> {
    gst_event_parse_caps($!e, $caps);
  }

  method parse_flush_stop (gboolean $reset_time) is also<parse-flush-stop> {
    gst_event_parse_flush_stop($!e, $reset_time);
  }

  method parse_gap (GstClockTime $timestamp, GstClockTime $duration)
    is also<parse-gap>
  {
    gst_event_parse_gap($!e, $timestamp, $duration);
  }

  proto method parse_group_id
    is also<parse-group-id>
  { * }

  multi method parse_group_id (:$all = False)  {
    samewith($, :$all)
  }
  multi method parse_group_id ($group_id is rw, :$all = False) {
    my guint $g = 0;
    my $rc = gst_event_parse_group_id($!e, $g);

    $group_id = $rc ?? $g !! Nil;
    $all.not ?? $group_id !! ($group_id, $rc);
  }

  method parse_latency (GstClockTime $latency) is also<parse-latency> {
    gst_event_parse_latency($!e, $latency);
  }

  method parse_protection (Str() $system_id, GstBuffer() $data, Str() $origin)
    is also<parse-protection>
  {
    gst_event_parse_protection($!e, $system_id, $data, $origin);
  }

  method parse_qos (
    GstQOSType $type,
    gdouble $proportion,
    GstClockTimeDiff $diff,
    GstClockTime $timestamp
  )
    is also<parse-qos>
  {
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
  )
    is also<parse-seek>
  {
    gst_event_parse_seek($!e, $rate, $format, $flags, $start_type, $start, $stop_type, $stop);
  }

  method parse_seek_trickmode_interval (GstClockTime $interval)
    is also<parse-seek-trickmode-interval>
  {
    gst_event_parse_seek_trickmode_interval($!e, $interval);
  }

  method parse_segment (GstSegment $segment) is also<parse-segment> {
    gst_event_parse_segment($!e, $segment);
  }

  method parse_segment_done (GstFormat $format, gint64 $position)
    is also<parse-segment-done>
  {
    gst_event_parse_segment_done($!e, $format, $position);
  }

  method parse_select_streams (CArray[Pointer[GList]] $streams)
    is also<parse-select-streams>
  {
    gst_event_parse_select_streams($!e, $streams);
  }

  method parse_sink_message (CArray[Pointer[GstMessage]] $msg)
  is also<parse-sink-message>
{
    gst_event_parse_sink_message($!e, $msg);
  }

  method parse_step (
    GstFormat $format,
    guint64 $amount,
    gdouble $rate,
    gboolean $flush,
    gboolean $intermediate
  )
    is also<parse-step>
  {
    gst_event_parse_step($!e, $format, $amount, $rate, $flush, $intermediate);
  }

  method parse_stream (CArray[Pointer[GstStream]] $stream)
    is also<parse-stream>
  {
    gst_event_parse_stream($!e, $stream);
  }

  method parse_stream_collection (
    CArray[Pointer[GstStreamCollection]] $collection
  )
    is also<parse-stream-collection>
  {
    gst_event_parse_stream_collection($!e, $collection);
  }

  method parse_stream_flags (CArray[GstStreamFlags] $flags)
    is also<parse-stream-flags>
  {
    gst_event_parse_stream_flags($!e, $flags);
  }

  method parse_stream_group_done (guint $group_id)
    is also<parse-stream-group-done>
  {
    gst_event_parse_stream_group_done($!e, $group_id);
  }

  method parse_stream_start (Str() $stream_id) is also<parse-stream-start> {
    gst_event_parse_stream_start($!e, $stream_id);
  }

  method parse_tag (GstTagList() $taglist) is also<parse-tag> {
    gst_event_parse_tag($!e, $taglist);
  }

  method parse_toc (GstToc() $toc, gboolean $updated) is also<parse-toc> {
    gst_event_parse_toc($!e, $toc, $updated);
  }

  method parse_toc_select (Str() $uid) is also<parse-toc-select> {
    gst_event_parse_toc_select($!e, $uid);
  }

  method set_group_id (guint $group_id) is also<set-group-id> {
    gst_event_set_group_id($!e, $group_id);
  }

  method set_seek_trickmode_interval (GstClockTime $interval)
    is also<set-seek-trickmode-interval>
  {
    gst_event_set_seek_trickmode_interval($!e, $interval);
  }

  method set_stream (GstStream() $stream) is also<set-stream> {
    gst_event_set_stream($!e, $stream);
  }

  method set_stream_flags (GstStreamFlags $flags) is also<set-stream-flags> {
    gst_event_set_stream_flags($!e, $flags);
  }

  method type_get_flags (guint $t) is also<type-get-flags> {
    gst_event_type_get_flags($t);
  }

  method type_get_name (guint $t) is also<type-get-name> {
    gst_event_type_get_name($t);
  }

  method type_to_quark (guint $t) is also<type-to-quark> {
    gst_event_type_to_quark($t);
  }

  method writable_structure is also<writable-structure> {
    gst_event_writable_structure($!e);
  }


}
