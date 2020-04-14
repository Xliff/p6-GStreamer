use v6.c;

use Method::Also;
use NativeCall;

use GStreamer::Raw::Types;
use GStreamer::Raw::Event;

use GLib::GList;
use GStreamer::Buffer;
use GStreamer::Caps;
use GStreamer::Message;
use GStreamer::MiniObject;
use GStreamer::Segment;
use GStreamer::Stream;
use GStreamer::StreamCollection;
use GStreamer::Structure;
use GStreamer::TagList;
use GStreamer::Toc;

use GLib::Roles::ListData;


our subset GstEventAncestry is export of Mu
  where GstEvent | GstMiniObject;

class GStreamer::Event is GStreamer::MiniObject {
  has GstEvent $!e;

  submethod BUILD (:$event) {
    self.setEvent($event);
  }

  method setEvent(GstEventAncestry $_) {
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

  method GStreamer::Raw::Definitions::GstEvent
    is also<GstEvent>
  { $!e }

  # Prevent attempts to use superclass constructors.
  proto method new (|)
  { * }

  multi method new (GstEventAncestry $event) {
    $event ?? self.bless(:$event) !! Nil;
  }

  multi method new (
    Int() $format,
    Int() $minsize,
    Int() $maxsize,
    Int() $async,
    :buffer_size(:$buffer-size) is required
  ) {
    self.new_buffer_size($format, $minsize, $maxsize, $async);
  }
  method new_buffer_size (
    Int() $format,
    Int() $minsize,
    Int() $maxsize,
    Int() $async
  )
    is also<new-buffer-size>
  {
    my GstEvent $f = $format;
    my gint64 ($mn, $mx) = ($minsize, $maxsize);
    my gboolean $a = $async.so.Int;

    my $event = gst_event_new_buffer_size($!e, $mn, $mx, $a);

    $event ?? self.bless(:$event) !! Nil;
  }

  multi method new (GstCaps() $c, :$caps is required) {
    self.new_caps($c);
  }
  method new_caps (GstCaps() $c) is also<new-caps> {
    my $event = gst_event_new_caps($c);

    $event ?? self.bless(:$event) !! Nil;
  }

  multi method new (
    Int() $event_type,
    GstStructure() $structure,
    :$custom is required
  ) {
    self.new_custom($event_type, $structure);
  }
  method new_custom (
    Int() $event_type,
    GstStructure() $structure
  )
    is also<new-custom>
  {
    my $event = gst_event_new_custom($!e, $structure);

    $event ?? self.bless(:$event) !! Nil;
  }

  multi method new (:$eos is required) {
    self.new_eos;
  }
  method new_eos is also<new-eos> {
    my $event = gst_event_new_eos();

    $event ?? self.bless(:$event) !! Nil;
  }

  multi method new (
    :flush_start(:$flush-start) is required
  ) {
    self.new_flush_start;
  }
  method new_flush_start is also<new-flush-start> {
    my $event = gst_event_new_flush_start();

    $event ?? self.bless(:$event) !! Nil;
  }

  multi method new (
    :flush_stop(:$flush-stop) is required
  ) {
    self.new_flush_stop;
  }
  method new_flush_stop is also<new-flush-stop> {
    my $event = gst_event_new_flush_stop($!e);

    $event ?? self.bless(:$event) !! Nil;
  }

  multi method new (Int() $duration, :$gap is required) {
    self.new_gap($duration);
  }
  method new_gap ( $duration) is also<new-gap> {
    my GstClockTime $d = $duration;
    my $event = gst_event_new_gap($!e, $d);

    $event ?? self.bless(:$event) !! Nil;
  }

  multi method new (Int() $lat, :$latency is required) {
    self.new_latency($lat);
  }
  method new_latency (Int() $latency) is also<new-latency> {
    my gint64 $l = $latency;
    my $event = gst_event_new_latency($l);

    $event ?? self.bless(:$event) !! Nil;
  }

  multi method new (
    GstStructure() $structure,
    :nav(:$navigation) is required
  ) {
    self.new_navigation($structure);
  }
  method new_navigation (GstStructure $structure) is also<new-navigation> {
    my $event = gst_event_new_navigation($structure);

    $event ?? self.bless(:$event) !! Nil;
  }

  multi method new (
    Str() $system_id,
    GstBuffer() $data,
    Str() $origin,
    :$protection is required
  ) {
    self.new_protection($system_id, $data, $origin);
  }
  method new_protection (Str() $system_id, GstBuffer() $data, Str() $origin)
    is also<new-protection>
  {
    my $event = gst_event_new_protection($system_id, $data, $origin);

    $event ?? self.bless(:$event) !! Nil;
  }

  multi method new (
    Int() $qos_type,
    Num() $proportion,
    Int() $diff,
    Int() $timestamp,
    :$qos is required
  ) {
    self.new_qos($qos_type, $proportion, $diff, $timestamp);
  }
  method new_qos (
    Int() $qos_type,
    Num() $proportion,
    Int() $diff,
    Int() $timestamp
  )
    is also<new-qos>
  {
    my GstQOSType $q = $qos_type;
    my gdouble $p = $proportion;
    my GstClockTimeDiff $d = $diff;
    my GstClockTime $t = $timestamp;
    my $event = gst_event_new_qos($q, $proportion, $diff, $timestamp);

    $event ?? self.bless(:$event) !! Nil;
  }

  multi method new (:$reconfigure is required) {
    self.new_reconfigure;
  }
  method new_reconfigure is also<new-reconfigure> {
    my $event = gst_event_new_reconfigure();

    $event ?? self.bless(:$event) !! Nil;
  }

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
    self.new_seek(
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
    my $event = gst_event_new_seek($r, $f, $f, $stt, $st, $spt, $sp);

    $event ?? self.bless(:$event) !! Nil;
  }

  multi method new (GstSegment() $seg, :$segment is required) {
    self.new_segment($seg);
  }
  method new_segment (GstSegment() $segment) is also<new-segment> {
    my $event = gst_event_new_segment($segment);

    $event ?? self.bless(:$event) !! Nil;
  }

  multi method new (
    Int() $position,
    :segment_done(:$segment-done) is required
  ) {
    self.new_segment_done($position);
  }
  method new_segment_done (Int() $position) is also<new-segment-done> {
    my gint64 $p = $position;
    my $event = gst_event_new_segment_done($!e, $p);

    $event ?? self.bless(:$event) !! Nil;
  }

  multi method new (
    @streams,
    :select_streams(:$select-streams) is required
  ) {
    self.new_select_streams( GLib::GList.new(@streams) );
  }
  multi method new (
    GList() $streams,
    :select_streams(:$select-streams) is required
  ) {
    self.new_select_streams($streams);
  }
  method new_select_streams (GList() $streams) is also<new-select-streams> {
    my $event = gst_event_new_select_streams($streams);

    $event ?? self.bless(:$event) !! Nil;
  }

  multi method new (
    GstMessage() $msg,
    :sink_message(:$sink-message) is required
  ) {
    self.new_sink_message($msg);
  }
  method new_sink_message (GstMessage() $msg) is also<new-sink-message> {
    my $event = gst_event_new_sink_message($msg);

    $event ?? self.bless(:$event) !! Nil;
  }

  multi method new (
    Int() $format,
    Int() $amount,
    Num() $rate,
    Int() $flush,
    Int() $intermediate,
    :$step is required
  ) {
    self.new_step($format, $amount, $rate, $flush, $intermediate);
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
    my $event = gst_event_new_step($f, $a, $r, $fl, $i);

    $event ?? self.bless(:$event) !! Nil;
  }

  multi method new (
    GstStreamCollection() $collection,
    :stream_collection(:$stream-collection) is required
  ) {
    self.new_stream_collection($collection);
  }
  method new_stream_collection (
    GstStreamCollection() $collection
  )
    is also<new-stream-collection>
  {
    my $event = gst_event_new_stream_collection($collection);

    $event ?? self.bless(:$event) !! Nil;
  }

  multi method new (:stream_group_done(:$stream-group-done) is required) {
    self.new_stream_group_done;
  }
  method new_stream_group_done is also<new-stream-group-done> {
    my $event = gst_event_new_stream_group_done($!e);

    $event ?? self.bless(:$event) !! Nil;
  }

  multi method new (
    Str() $stream_id,
    :stream_start(:$stream-start) is required
  ) {
    self.new_stream_start;
  }
  method new_stream_start (Str() $stream_id) is also<new-stream-start> {
    my $event = gst_event_new_stream_start($stream_id);

    $event ?? self.bless(:$event) !! Nil;
  }

  multi method new (GstTagList() $tags, :$tag is required) {
    self.new_tag($tags);
  }
  method new_tag (GstTagList $tags) is also<new-tag> {
    my $event = gst_event_new_tag($tags);

    $event ?? self.bless(:$event) !! Nil;
  }

  multi method new (GstToc() $t, Int() $updated, :$toc is required) {
    self.new_toc($t);
  }
  method new_toc (GstToc() $toc, Int() $updated) is also<new-toc> {
    my gboolean $u = $updated.so.Int;
    my $event = gst_event_new_toc($toc, $u);

    $event ?? self.bless(:$event) !! Nil;
  }

  multi method new (
    Str() $uid,
    :toc_select(:$toc-select) is required
  ) {
    self.new_toc_select($uid);
  }
  method new_toc_select (Str() $uid) is also<new-toc-select> {
    my $event = gst_event_new_toc_select($uid);

    $event ?? self.bless(:$event) !! Nil;
  }

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

  proto method copy_segment (|)
    is also<copy-segment>
  { * }

  multi method copy_segment (:$raw = False) {
    my $s = GstSegment.new;

    self.copy_segment($s);

    $s ??
      ( $raw ?? $s !! GStreamer::Segment.new($s) )
      !!
      Nil;
  }
  multi method copy_segment (GstSegment() $segment)  {
    gst_event_copy_segment($!e, $segment);
  }

  method get_structure (:$raw = False) is also<get-structure> {
    my $s = gst_event_get_structure($!e);

    $s ??
      ( $raw ?? $s !! GStreamer::Structure.new($s) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_event_get_type, $n, $t );
  }

  method has_name (Str() $name) is also<has-name> {
    so gst_event_has_name($!e, $name);
  }

  proto method parse_buffer_size (|)
    is also<parse-buffer-size>
  { * }

  multi method parse_buffer_size {
    samewith($, $, $, $);
  }
  multi method parse_buffer_size (
    $format  is rw,
    $minsize is rw,
    $maxsize is rw,
    $async   is rw
  ) {
    my GstFormat $f = $format;
    my gint64 ($mn, $mx) = ($minsize, $maxsize);
    my gboolean $a = $async.so.Int;

    gst_event_parse_buffer_size($!e, $f, $mn, $mx, $a);
    ($format, $minsize, $maxsize, $async) = (
      GstFormatEnum($f),
      $mn,
      $mx,
      $a.so
    );
  }

  proto method parse_caps (|)
    is also<parse-caps>
  { * }

  multi method parse_caps (:$raw = False) {
    samewith($, :$raw);
  }
  multi method parse_caps (
    $caps is rw,
    :$raw = False
  ) {
    my $ca = CArray[GstCaps].new;
    $ca[0] = GstCaps;

    gst_event_parse_caps($!e, $ca);

    $caps = $ca[0] ??
      ( $raw ?? $ca[0] !! GStreamer::Caps.new( $ca[0] ) )
      !!
      GstCaps
  }

  proto method parse_flush_stop
    is also<parse-flush-stop>
  { * }

  multi method parse_flush_stop {
    samewith($);
  }
  multi method parse_flush_stop ($reset_time is rw) {
    my gboolean $r = 0;

    gst_event_parse_flush_stop($!e, $r);
    $reset_time = $r.so.Int;
  }

  proto method parse_gap
    is also<parse-gap>
  { * }

  multi method parse_gap {
    samewith($, $);
  }
  multi method parse_gap ($timestamp is rw, $duration is rw) {
    my GstClockTime ($t, $d) =

    gst_event_parse_gap($!e, $t, $d);
    ($timestamp, $duration) = ($t, $d)
  }

  proto method parse_group_id
    is also<parse-group-id>
  { * }

  multi method parse_group_id {
    my $rv = callwith($, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method parse_group_id ($group_id is rw, :$all = False) {
    my guint $g = 0;
    my $rv  = gst_event_parse_group_id($!e, $g);

    $group_id = $g;
    $all.not ?? $group_id !! ($rv, $group_id);
  }

  proto method parse_latency (|)
    is also<parse-latency>
  { * }

  multi method parse_latency {
    samewith($);
  }
  multi method parse_latency ($latency is rw) {
    my GstClockTime $l = 0;

    gst_event_parse_latency($!e, $l);
    $latency = $l
  }

  proto method parse_protection (|)
    is also<parse-protection>
  { * }

  multi method parse_protection (:$raw = False) {
    samewith($, $, $, :$raw);
  }
  multi method parse_protection (
    $system_id is rw,
    $data      is rw,
    $origin    is rw,
    :$raw = False
  ) {
    my ($s, $o) = CArray[Str].new xx 2;
    my $da = CArray[Pointer[GstBuffer]].new;

    $s[0] = $o[0] = Str;
    $da[0] = Pointer[GstBuffer];

    gst_event_parse_protection($!e, $s, $da, $o);

    return GstBuffer unless $data[0];

    my $d = $da[0].deref;
    ($system_id, $data, $origin) = (
      $s[0] // Str,
      $raw ?? $d !! GStreamer::Buffer.new($d),
      $o[0] // Str
    );
  }

  proto method parse_qos (|)
    is also<parse-qos>
  { * }

  multi method parse_qos {
    samewith($, $, $, $);
  }
  multi method parse_qos (
    $type       is rw,
    $proportion is rw,
    $diff       is rw,
    $timestamp  is rw
  ) {
    my GstQOSType $t = 0;
    my gdouble $p = 0e0;
    my GstClockTimeDiff $d = 0;
    my GstClockTime $ts = 0;

    gst_event_parse_qos($!e, $t, $p, $d, $ts);
    ($type, $proportion, $diff, $timestamp) =
      ( GstQOSTypeEnum($t), $p, $d, $ts );
  }

  proto method parse_seek (|)
    is also<parse-seek>
  { * }

  multi method parse_seek {
    samewith($, $, $, $, $, $, $);
  }
  multi method parse_seek (
    $rate       is rw,
    $format     is rw,
    $flags      is rw,
    $start_type is rw,
    $start      is rw,
    $stop_type  is rw,
    $stop       is rw
  ) {
    my gdouble $r = 0e0;
    my GstFormat $f = 0;
    my GstSeekFlags $fl = 0;
    my GstSeekType ($stt, $spt) = 0 xx 2;
    my gint64 ($st, $sp) = 0 xx 2;

    gst_event_parse_seek($!e, $r, $f, $fl, $stt, $st, $spt, $sp);
    ($rate, $format, $flags, $start_type, $start, $stop_type, $stop) = (
      $r,
      GstFormatEnum($f),
      $fl,
      GstSeekTypeEnum($stt),
      $st,
      GstSeekTypeEnum($spt),
      $sp
    );
  }

  proto method parse_seek_trickmode_interval (|)
    is also<parse-seek-trickmode-interval>
  { * }

  multi method parse_seek_trickmode_interval {
    samewith($);
  }
  multi method parse_seek_trickmode_interval ($interval is rw) {
    my GstClockTime $i = 0;

    gst_event_parse_seek_trickmode_interval($!e, $i);
    $interval = $i;
  }

  proto method parse_segment (|)
    is also<parse-segment>
  { * }

  multi method parse_segment (:$raw = False) {
    samewith($, :$raw)
  }
  multi method parse_segment (
    $segment is rw,
    :$raw = False
  ) {
    my $sa = CArray[Pointer[GstSegment]].new;
    $sa[0] = Pointer[GstSegment];

    gst_event_parse_segment($!e, $sa);

    return GstSegment unless $sa[0];

    my $s = $sa[0].deref;
    $raw ?? $s !! GStreamer::Segment.new($s);
  }

  proto method parse_segment_done (|)
    is also<parse-segment-done>
  { * }

  multi method parse_segment_done {
    samewith($, $);
  }
  multi method parse_segment_done (
    $format is rw,
    $position is rw
  ) {
    my GstFormat $f = 0;
    my gint64 $p = 0;

    gst_event_parse_segment_done($!e, $f, $p);
    ($format, $position) = ( GstFormatEnum($f), $p );
  }

  proto method parse_select_streams (|)
    is also<parse-select-streams>
  { * }

  multi method parse_select_streams {
    samewith($);
  }
  multi method parse_select_streams ($streams is rw) {
    my $la = CArray[Pointer[GList]].new;
    $la[0] = Pointer[GList];

    gst_event_parse_select_streams($!e, $streams);

    return Nil unless $streams[0];

    my $s = $streams[0].deref;
    $s = GLib::GList($s) but GLib::Roles::ListData[Str];
    $streams = $s.Array;
  }

  proto method parse_sink_message (|)
    is also<parse-sink-message>
  { * }

  multi method parse_sink_message (:$raw = False) {
    samewith($, :$raw);
  }
  multi method parse_sink_message ($msg is rw, :$raw) {
    my $ma = CArray[Pointer[GstMessage]].new;
    $ma[0] = Pointer[GstMessage];

    gst_event_parse_sink_message($!e, $ma);

    return GstMessage unless $msg[0];

    my $m = $msg[0].deref;
    $msg = $raw ?? $m !! GStreamer::Message.new($m);
  }

  proto method parse_step (|)
    is also<parse-step>
  { * }

  multi method parse_step {
    samewith($, $, $, $, $);
  }
  multi method parse_step (
    $format       is rw,
    $amount       is rw,
    $rate         is rw,
    $flush        is rw,
    $intermediate is rw
  ) {
    my GstFormat $f = 0;
    my guint64 $a = 0;
    my gdouble $r = 0e0;
    my gboolean ($fl, $i) = (0, 0);

    gst_event_parse_step($!e, $f, $a, $r, $fl, $i);
    ($format, $amount, $rate, $flush, $intermediate) =
      ( GstFormatEnum($f), $a, $r, $fl.so.Int, $i.so.Int );
  }

  proto method parse_stream (|)
    is also<parse-stream>
  { * }

  multi method parse_stream (:$raw = False) {
    samewith($, :$raw);
  }
  multi method parse_stream (
    $stream is rw,
    :$raw = False
  ) {
    my $sa = CArray[GstStream].new;
    $sa[0] = GstStream;

    gst_event_parse_stream($!e, $sa);

    $stream = $sa[0] ??
      ( $raw ?? $sa[0] !! GStreamer::Stream.new( $sa[0] ) )
      !!
      Nil;
  }

  proto method parse_stream_collection (|)
    is also<parse-stream-collection>
  { * }

  multi method parse_stream_collection (:$raw = False) {
    samewith($, :$raw);
  }
  multi method parse_stream_collection (
    $collection is rw,
    :$raw = False
  ) {
    my $col = CArray[GstStreamCollection].new;
    $col[0] = GstStreamCollection;

    gst_event_parse_stream_collection($!e, $col);

    $collection = $col[0] ??
      ( $raw ?? $col[0] !! GStreamer::StreamCollection.new( $col[0] ) )
      !!
      Nil;
  }

  proto method parse_stream_flags (|)
    is also<parse-stream-flags>
  { * }

  multi method parse_stream_flags {
    samewith($);
  }
  multi method parse_stream_flags ($flags is rw) {
    my GstStreamFlags $f = 0;

    gst_event_parse_stream_flags($!e, $f);
    $flags = $f;
  }

  multi method parse_stream_group_done {
    samewith($);
  }
  multi method parse_stream_group_done ($group_id is rw)
    is also<parse-stream-group-done>
  {
    my guint $g = 0;

    gst_event_parse_stream_group_done($!e, $g);
    $group_id = $g;
  }

  proto method parse_stream_start (|)
    is also<parse-stream-start>
  { * }

  multi method parse_stream_start {
    samewith($);
  }
  multi method parse_stream_start ($stream_id is rw)  {
    my $sa = CArray[Str].new;
    $sa[0] = Str;

    gst_event_parse_stream_start($!e, $sa);

    $stream_id = $sa[0] ?? $sa[0] !! Nil;
  }

  proto method parse_tag (|)
    is also<parse-tag>
  { * }

  multi method parse_tag (:$raw = False) {
    samewith($, :$raw);
  }
  multi method parse_tag ($taglist is rw, :$raw = False)  {
    my $ta = CArray[Pointer[GstTagList]].new;
    $ta[0] = Pointer[GstTagList];

    gst_event_parse_tag($!e, $ta);

    return GstTagList unless $ta[0];

    my $t = $ta[0].deref;
    $taglist = $raw ?? $t !! GStreamer::TagList.new($t);
  }

  proto method parse_toc (|)
    is also<parse-toc>
  { * }

  multi method parse_toc (:$raw = False) {
    samewith($, $, :$raw);
  }
  multi method parse_toc ($toc is rw, $updated is rw, :$raw = False)
  {
    my gboolean $u = 0;
    my $ta = CArray[Pointer[GstToc]].new;
    $ta[0] = Pointer[GstToc];

    gst_event_parse_toc($!e, $ta, $u);

    my $t = $ta[0] ?? $ta[0] !! Nil;

    ($toc, $updated) = (
      $raw ?? $t !! GStreamer::Toc.new($t),
      $u.so.Int
    );

  }

  proto method parse_toc_select (|)
    is also<parse-toc-select>
  { * }

  multi method parse_toc_select {
    samewith($);
  }
  multi method parse_toc_select ($uid is rw)  {
    my $ua = CArray[Str].new;
    $ua[0] = Str;

    gst_event_parse_toc_select($!e, $ua);
    $uid = $ua[0] // Str;
  }

  method set_group_id (Int() $group_id) is also<set-group-id> {
    my guint $g = $group_id;

    gst_event_set_group_id($!e, $g);
  }

  method set_seek_trickmode_interval (Int() $interval)
    is also<set-seek-trickmode-interval>
  {
    my GstClockTime $i = $interval;

    gst_event_set_seek_trickmode_interval($!e, $i);
  }

  method set_stream (GstStream() $stream) is also<set-stream> {
    gst_event_set_stream($!e, $stream);
  }

  method set_stream_flags (Int() $flags) is also<set-stream-flags> {
    my GstStreamFlags $f = $flags;

    gst_event_set_stream_flags($!e, $f);
  }

  method type_get_flags (GStreamer::Event:U: Int() $type)
    is also<type-get-flags>
  {
    my guint $t = $type;

    gst_event_type_get_flags($t);
  }

  method type_get_name (GStreamer::Event:U: Int() $type)
    is also<type-get-name>
  {
    my guint $t = $type;

    gst_event_type_get_name($t);
  }

  method type_to_quark (GStreamer::Event:U: Int() $type)
    is also<type-to-quark>
  {
    my guint $t = $type;

    gst_event_type_to_quark($t);
  }

  method writable_structure (:$raw = False) is also<writable-structure> {
    my $s = gst_event_writable_structure($!e);

    $s ??
      ( $raw ?? $s !! GStreamer::Structure.new($s) )
      !!
      Nil;
  }

}
