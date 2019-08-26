use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::Message;

use GTK::Compat::Value;

class GStreamer::Message {
  has GstMessage $!m;

  submethod BUILD (:$message) {
    $!m = $message;
  }

  # Consider a method new with slurpy positional and named arguments to
  # act as a shortcut to the numerous options we have here.

  multi method new (
    GstObject() $src,
    GstStructure() $structure,
    :$application is required
  ) {
    GStreamer::Message.new_application($src, $structure);
  }
  method new_application (GstObject() $src, GstStructure() $structure) {
    self.bless( message => gst_message_new_application($src, $structure) );
  }

  multi method new (
    GstObject() $src,
    Int() $running_time,
    :async-done(:$async_done) is required
  ) {
    GStreamer::Message.new_async_done($src, $running_time);
  }
  method new_async_done (
    GstObject() $src,
    Int() $running_time # GstClockTime $running_time
  ) {
    self.bless( message => gst_message_new_async_done($src, $running_time) );
  }

  multi method new (
    GstObject() $src,
    :async-start(:$async_start) is required
  ) {
    GStreamer::Message.new_async_start($src);
  }
  method new_async_start {
    self.bless( message => gst_message_new_async_start($src) );
  }

  method new (
    GstObject() $src,
    Int() $percent
    :$buffering is required
  ) {
    GStreamer::Message.new_buffering($src, $percent);
  }
  method new_buffering (
    GstObject() $src,
    Int() $percent # gint $percent
  ) {
    self.bless( message => gst_message_new_buffering($src, $percent) );
  }

  method new (
    GstObject() $src,
    :clock-lost(:$clock_lost) is required
  ) {
    GStreamer::Message.new_clock_lost($src, $clock);
  }
  method new_clock_lost (GstObject() $src, GstClock() $clock) {
    self.bless( message => gst_message_new_clock_lost($src, $clock) );
  }

  multi method new (
    GstObject() $src,
    GstClock $clock,
    Int() $ready, # gboolean $ready
    :clock-provide(:$clock_provide) is required
  ) {
    GStreamer::Message.new_clock_provide($src, $clock, $ready);
  }
  method new_clock_provide (
    GstObject() $src,
    GstClock $clock,
    Int() $ready # gboolean $ready
  ) {
    self.bless(
      message => gst_message_new_clock_provide($src, $clock, $ready.so.Int)
    );
  }

  multi method new (
    Int() $type, # GstMessageType $type
    GstObject $src,
    GstStructure() $structure,
    :$custom is required
  ) {
    GStreamer::Message.new_custom($type, $src, $structure);
  }
  method new_custom (
    Int() $type, # GstMessageType $type
    GstObject $src,
    GstStructure() $structure = GstStructure
  ) {
    self.bless( message => gst_message_new_custom($type, $src, $structure) );
  }

  multi method new (
    GstObject() $src,
    GstDevice() $device,
    :device-added(:$device_added) is required
  ) {
    GStreamer::Messaeg.new_device_added($src, $device);
  }
  method new_device_added (GstObject() $src, GstDevice() $device) {
    self.bless( message => gst_message_new_device_added($src, $device) );
  }

  multi method new (
    GstObject() $src,
    GstDevice() $device,
    GstDevice() $changed_device,
    :device-changed(:$device_changed) is required
  ) {
    GStreamer::Message.new_device_changed($src, $device, $changed_device);
  }
  method new_device_changed (
    GstObject() $src,
    GstDevice() $device,
    GstDevice() $changed_device
  ) {
    self.bless(
      message => gst_message_new_device_changed($src, $device, $changed_device)
    );
  }

  multi method new (
    GstObject() $src,
    GstDevice() $device,
    :device-removed(:$device_removed) is required
  ) {
    GStreamer::Message.new_device_removed($src, $device);
  }
  method new_device_removed (GstObject() $src, GstDevice() $device) {
    self.bless( message => gst_message_new_device_removed($src, $device) );
  }

  multi method new (
    GstObject() $src,
    :duration-changed(:$duration_changed) is required
  ) {
    GStreamer::Message.new_duration_changed($src);
  }
  method new_duration_changed (GstObject() $src) {
    self.bless( message => gst_message_new_duration_changed($src) );
  }

  multi method new (
    GstObject() $src,
    GstStructure() $structure,
    :$element is required
  ) {
    GStreamer::Message.new_element($src, $structure);
  }
  method new_element (GstObject() $src, GstStructure() $structure) {
    self.bless( message => gst_message_new_element($src, $structure) );
  }

  multi method new (
    GstObject() $src,
    :$eos is required
  ) {
    GStreamer::Message.new_eos($src);
  }
  method new_eos (GstObject() $src) {
    self.bless( message => gst_message_new_eos($src) );
  }

  multi method new (
    GstObject() $src,
    GError $error,
    Str $debug,
    :$error is required
  ) {
    GStreamer::Message.new_error($src, $error, $debug);
  }
  method new_error (
    GstObject() $src,
    GError $error,
    Str $debug
  ) {
    self.bless( message => gst_message_new_error($src, $error, $debug) );
  }

  multi method new (
    GstObject() $src,
    GError $error,
    Str() $debug,
    GstStructure() $details,
    :error-with-details(:$error_with_details) is required
  ) {
    GStreamer::Message.new_error_with_details($src, $error, $debug, $details);
  }
  method new_error_with_details (
    GstObject() $src,
    GError $error,
    Str() $debug,
    GstStructure() $details
  ) {
    self.bless(
      message => gst_message_new_error_with_details(
        $src,
        $error,
        $debug,
        $details
      )
    );
  }

  multi method new (
    GstObject() $src,
    GstContext() $context,
    :have-context(:$have_context) is required
  ) {
    GStreamer::Message.new_have_context($src, $context);
  }
  method new_have_context (GstObject() $src, GstContext() $context) {
    self.bless( message => gst_message_new_have_context($src, $context) );
  }

  multi method new (
    GstObject() $src,
    GError $error,
    Str() $debug,
    :$info is required
  ) {
    GStreamer::Message.new_info($src, $error, $debug);
  }
  method new_info (GstObject() $src, GError $error, Str() $debug) {
    self.bless( message => gst_message_new_info($src, $error, $debug) );
  }

  multi method new (
    GstObject() $src,
    GError $error,
    Str() $debug,
    GstStructure() $details,
    :info-with-details(:$info_with_details) is required
  ) {
    GStreamer::Message.new_info_with_details($src, $error, $debug, $details);
  }
  method new_info_with_details (
    GstObject() $src,
    GError $error,
    Str() $debug,
    GstStructure() $details,
  ) {
    self.bless(
      message => gst_message_new_info_with_details(
        $src,
        $error,
        $debug,
        $details
      )
    );
  }

  multi method new (
    GstObject() $src,
    :$latency is required
  ) {
    GStreamer::Message.new_latency($src);
  }
  method new_latency (GstObject() $src) {
    self.bless( message => gst_message_new_latency($src) );
  }

  multi method new (
    GstObject() $src,
    Str() $context_type,
    :need-context(:$need_context) is required
  ) {
    GStreamer::Message.new_need_context($src, $context_type);
  }
  method new_need_context (GstObject() $src, Str() $context_type) {
    self.bless( message => gst_message_new_need_context($src, $context_type) );
  }

  multi method new (
    GstObject() $src,
    GstClock() $clock,
    :$clock is required
  ) {
    GStreamer::Message.new($src, $clock);
  }
  method new_new_clock (GstObject() $src, GstClock() $clock) {
    self.bless( message => gst_message_new_new_clock($src, $clock) );
  }

  multi method new (
    GstObject() $src,
    Int() $type, # GstProgressType $type,
    Str() $code,
    Str() $text,
    :$progress is required
  ) {
    GStreamer::Message.new_progress($src, $type, $code, $text);
  }
  method new_progress (
    GstObject() $src,
    Int() $type, # GstProgressType $type,
    Str() $code,
    Str() $text
  ) {
    self.bless(
      message => gst_message_new_progress($src, $type, $code, $text)
    );
  }

  multi method new (
    GstObject() $src,
    Str() $property_name,
    GValue() $val,
    :property-notify(:$property_notify) is required
  ) {
    GStreamer::Message.new_property_notify($src, $property_name, $val);
  }
  method new_property_notify (
    GstObject() $src,
    Str() $property_name,
    GValue() $val
  ) {
    self.bless(
      message => gst_message_new_property_notify($src, $property_name, $val)
    );
  }

  multi method new (
    GstObject() $src,
    Int() $live,        # gboolean $live,
    Int() $running_time, # guint64 $running_time,
    Int() $stream_time,  # guint64 $stream_time,
    Int() $timestamp,    # guint64 $timestamp,
    Int() $duration,     # guint64 $duration
    :$qos is required
  ) {
    GStreamer::Message.new_qos(
      $src,
      $live,
      $running_time,
      $stream_time,
      $timestamp,
      $duration
    );
  }
  method new_qos (
    GstObject() $src,
    Int() $live,        # gboolean $live,
    Int() $running_time, # guint64 $running_time,
    Int() $stream_time,  # guint64 $stream_time,
    Int() $timestamp,    # guint64 $timestamp,
    Int() $duration      # guint64 $duration
  ) {
    self.bless(
      message => gst_message_new_qos(
        $src,
        $live,
        $running_time,
        $stream_time,
        $timestamp,
        $duration
      )
    );
  }

  multi method new (
    GstObject() $src,
    Str() $location,
    GstTagList() $tag_list,
    GstStructure() $entry_struct,
    :$redirect is required
  ) {
    GStreamer::Message.new(
      $src,
      $location,
      $tag_list,
      $entry_struct
    );
  }
  method new_redirect (
    GstObject() $src,
    Str() $location,
    GstTagList() $tag_list,
    GstStructure() $entry_struct
  ) {
    self.bless(
      message => gst_message_new_redirect(
        $src,
        $location,
        $tag_list,
        $entry_struct
      )
    );
  }

  multi method new (
    GstObject() $src,
    GstState() $state,
    :request-state(:$request_state) is required
  ) {
    GStreamer::Messaeg.new_request_state($src, $state);
  }
  method new_request_state (GstObject() $src, GstState() $state) {
    self.bless( message => gst_message_new_request_state($src, $state) );
  }

  multi method new (
    GstObject() $src,
    Int() $running_time, # GstClockTime $running_time
    :reset-time(:$reset_time) is required
  ) {
    GStreamer::Message.new_reset_time($src, $running_time);
  }
  method new_reset_time (
    GstObject() $src,
    Int() $running_time # GstClockTime $running_time
  ) {
    self.bless( message => gst_message_new_reset_time($src, $running_time) );
  }

  multi method new (
    GstObject() $src,
    GstFormat() $format,
    Int() $position, # gint64 $position
    :segment-done(:$segment_done) is required
  ) {
    GStreamer::Message.new_segment_done($src, $format, $position);
  }
  method new_segment_done (
    GstObject() $src,
    GstFormat() $format,
    Int() $position # gint64 $position
  ) {
    self.bless(
      message => gst_message_new_segment_done($src, $format, $position)
    );
  }

  multi method new (
    GstObject() $src,
    GstFormat() $format,
    Int() $position # gint64 $position
    :segment-start(:$segment_start) is required
  ) {
    GStreamer::Message.new_segment_start($src, $format, $position);
  }
  method new_segment_start (
    GstObject() $src,
    GstFormat() $format,
    Int() $position # gint64 $position
  ) {
    self.bless(
      message => gst_message_new_segment_start($src, $format, $position)
    );
  }

  multi method new (
    GstObject() $src,
    GstState $oldstate,
    GstState $newstate,
    GstState $pending,
    :state-changed(:$state_changed) is required
  ) {
    GStreamer::Message.new_state_changed(
      $src,
      $oldstate,
      $newstate,
      $pending
    );
  }
  method new_state_changed (
    GstObject() $src,
    GstState $oldstate,
    GstState $newstate,
    GstState $pending
  ) {
    self.bless(
      message => gst_message_new_state_changed(
        $src,
        $oldstate,
        $newstate,
        $pending
      )
    );
  }

  multi method new (
    GstObject() $src,
    :state-dirty(:$state_dirty) is required
  ) {
    GStreamer::Message.new_state_dirty($src);
  }
  method new_state_dirty (GstObject() $src)  {
    self.bless( message => gst_message_new_state_dirty($src) );
  }

  multi method new (
    GstObject() $src,
    GstFormat() $format,
    Int() $amount,       # guint64 $amount,
    Int() $rate,         # gdouble $rate,
    Int() $flush,        # gboolean $flush,
    Int() $intermediate, # gboolean $intermediate,
    Int() $duration,     # guint64 $duration,
    Int() $eos,          # gboolean $eos
    :step-done(:$step_done) is required
  ) {
    GStreamer::Message.new_step_done(
      $src,
      $format,
      $amount,
      $rate,
      $flush,
      $intermediate,
      $duration,
      $eos
    );
  }
  method new_step_done (
    GstObject() $src,
    GstFormat() $format,
    Int() $amount,       # guint64 $amount,
    Int() $rate,         # gdouble $rate,
    Int() $flush,        # gboolean $flush,
    Int() $intermediate, # gboolean $intermediate,
    Int() $duration,     # guint64 $duration,
    Int() $eos           # gboolean $eos
  ) {
    self.bless(
      message => gst_message_new_step_done(
        $src,
        $format,
        $amount,
        $rate,
        $flush,
        $intermediate,
        $duration,
        $eos
      )
    );
  }

  multi method new (
    GstObject() $src,
    Int() $active,       # gboolean $active,
    GstFormat() $format,
    Int() $amount,       # guint64 $amount,
    Int() $rate,         # gdouble $rate,
    Int() $flush,        # gboolean $flush,
    Int() $intermediate, # gboolean $intermediate
    :step-start(:$step_start) is required
  ) {
    GStreamer::Message.new_step_start(
      $src,
      $active,
      $format,
      $amount,
      $rate,
      $flush,
      $intermediate
    );
  }
  method new_step_start (
    GstObject() $src,
    Int() $active,       # gboolean $active,
    GstFormat() $format,
    Int() $amount,       # guint64 $amount,
    Int() $rate,         # gdouble $rate,
    Int() $flush,        # gboolean $flush,
    Int() $intermediate  # gboolean $intermediate
  ) {
    self.bless(
      message => gst_message_new_step_start(
        $src,
        $active,
        $format,
        $amount,
        $rate,
        $flush,
        $intermediate
      )
    );
  }

  multi method new (
    GstObject() $src,
    GstStreamCollection() $collection,
    :stream-collection(:$stream_collection) is required
  ) {
    GStreamer::Message.new_stream_collection($src, $collection);
  }
  method new_stream_collection (
    GstObject() $src,
    GstStreamCollection() $collection
  ) {
    self.bless(
      message => gst_message_new_stream_collection($src, $collection)
    );
  }

  multi method new (
    GstObject() $src,
    :stream-start(:$stream_start) is required
  ) {
    GStreamer::Message.new_stream_start($src);
  }
  method new_stream_start (GstObject() $src) {
    self.bless( message => gst_message_new_stream_start($src) );
  }

  multi method new (
    GstObject() $src,
    Int() $type, # GstStreamStatusType $type,
    GstElement() $owner,
    :stream-status(:$stream_status) is required
  ) {
    GStreamer::Message.new_stream_status($src, $type, $owner);
  }
  method new_stream_status (
    GstObject() $src,
    Int() $type, # GstStreamStatusType $type,
    GstElement() $owner
  ) {
    self.bless(
      message => gst_message_new_stream_status($src, $type, $owner)
    );
  }

  multi method new (
    GstObject() $src,
    GstStreamCollection() $collection,
    :stream-selected(:$stream_selected) is required
  ) {
    GStreamer::Message.new_streams_selected($src, $collection);
  }
  method new_streams_selected (
    GstObject() $src,
    GstStreamCollection() $collection
  ) {
    self.bless(
      message => gst_message_new_streams_selected($src, $collection)
    );
  }

  multi method new (
    GstObject() $src,
    Int() $type,       # GstStructureChangeType $type,
    GstElement $owner,
    Int() $busy,       # gboolean $busy
    :structure-change(:$structure_change) is required
  ) {
    GStreamer::Message.new_structure_change($src, $type, $owner, $busy);
  }
  method new_structure_change (
    GstObject() $src,
    Int() $type,       # GstStructureChangeType $type,
    GstElement $owner,
    Int() $busy        # gboolean $busy
  ) {
    self.bless(
      message => gst_message_new_structure_change($src, $type, $owner, $busy)
    );
  }

  multi method new (
    GstObject() $src,
    GstTagList() $tag_list,
    :$tag is required
  ) {
    GStreamer::Message.new_tag($src, $tag_list);
  }
  method new_tag (GstObject() $src, GstTagList() $tag_list) {
    self.bless( message => gst_message_new_tag($src, $tag_list) );
  }

  multi method new (
    GstObject() $src,
    GstToc() $toc,
    Int() $updated,   # gboolean $updated
    :$toc is required
  ) {
    GStreamer::Message.new_toc($src, $toc, $updated);
  }
  method new_toc (
    GstObject() $src,
    GstToc() $toc,
    Int() $updated    # gboolean $updated
  ) {
    self.bless( message => gst_message_new_toc($src, $toc, $updated) );
  }

  multi method new (
    GstObject() $src,
    GError $error,
    Str() $debug,
    :$warning is required
  ) {
    GStreamer::Message.new_warning($src, $error, $debug);
  }
  method new_warning (GstObject() $src, GError $error, Str() $debug) {
    self.bless( message => gst_message_new_warning($src, $error, $debug) );
  }

  multi method new (
    GstObject() $src,
    GError $error,
    Str() $debug,
    GstStructure() $details,
    :warning-with-details(:$warning_with_details) is required
  ) {
    GStreamer::Message.new_warning_with_details(
      $src,
      $error,
      $debug,
      $details
    );
  }
  method new_warning_with_details (
    GstObject() $src,
    GError $error,
    Str() $debug,
    GstStructure() $details
  ) {
    self.bless(
      message => gst_message_new_warning_with_details(
        $src,
        $error,
        $debug,
        $details
      )
    );
  }

  method seqnum is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_message_get_seqnum($!m);
      },
      STORE => sub ($, Int() $seqnum is copy) {
        gst_message_set_seqnum($!m, $seqnum);
      }
    );
  }

  method stream_status_object (:$raw = False) is rw {
    Proxy.new(
      FETCH => sub ($) {
        my $v = gst_message_get_stream_status_object($!m);

        $v ??
          ( $raw ?? $v !! GTK::Compat::Value.new($v) )
          !!
          Nil;
      },
      STORE => sub ($, GValue() $object is copy) {
        gst_message_set_stream_status_object($!m, $object);
      }
    );
  }

  method add_redirect_entry (
    Str() $location,
    GstTagList() $tag_list,
    GstStructure() $entry_struct
  ) {
    gst_message_add_redirect_entry($!m, $location, $tag_list, $entry_struct);
  }

  method get_num_redirect_entries {
    gst_message_get_num_redirect_entries($!m);
  }

  method get_structure (:$raw = False) {
    gst_message_get_structure($!m);
    # ADD OBJECT CREATION CODE
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_message_get_type, $n, $t );
  }

  method has_name (Str $name) {
    so gst_message_has_name($!m, $name);
  }

  proto method parse_async_done (|)
  { * }

  multi method parse_async_done {
    samewith($ct);
  }
  multi method parse_async_done ($running_time is rw) {
    my gint $r = 0;
    gst_message_parse_async_done($!m, $r);
    $running_time = $r
  }


  method parse_buffering ($percent is rw)
    my gint $p = 0;
    gst_message_parse_buffering($!m, $p);
    $percent = $0;
  }

  proto method parse_buffering_stats (|)
  { * }

  multi method parse_buffering_stats (
    my @a = 0 xx 4;
    samewith(|@a);
  }
  multi method parse_buffering_stats (
    $mode           is rw,
    $avg_in         is rw,
    $avg_out        is rw,
    $buffering_left is rw
  ) {
    my guint $m = 0;
    my gint ($ai, $ao) = 0 xx 2;
    my gint64 $bl = 0;

    gst_message_parse_buffering_stats($!m, $m, $ai, $ao, $bl);
    ($mode, $avg_in, $avg_out, $buffering_left) = ($m, $ai, $ao, $bl);
  }

  proto method parse_clock_lost (|)
  { * }

  multi method parse_clock_lost {
    samewith(GstClock.new)
  }
  multi method parse_clock_lost ($clock is rw) {
    my $ca = CArray[Pointer[GstClock]].new;

    $ca[0] = GstClock.new;
    gst_message_parse_clock_lost($!m, $ca);
    $clock = $c
  }

  proto method parse_clock_provide (|)
  { * }

  multi method parse_clock_provide {
    my ($c, $r);
    samewith($c, $r);
  }
  multi method parse_clock_provide (
    $clock is rw,
    $ready is rw
  ) {
    my gboolean $r = 0;
    my $ca = CArray[Pointer[GstClock]].new;

    $ca[0] = GstClock.new;
    gst_message_parse_clock_provide($!m, $ca, $r);
    ($clock, $ready) = ($ca, $r);
  }

  proto method parse_context_type (|)
  { * }

  method parse_context_type {
    my $ct;
    samewith($ct);
  }
  method parse_context_type ($context_type is rw) {
    my $ct = CArray[Str].new;
    gst_message_parse_context_type($!m, $ct);
    $context_type = $ct[0];
  }

  proto method parse_device_added (|)
  { * }

  multi method parse_device_added {
    my $d;
    samewith($d);
  }
  multi method parse_device_added ($device is rw) {
    my $d = CArray[Pointer[GstDevice]].new;

    $d[0] = GstDevice.new;
    gst_message_parse_device_added($!m, $d);
    $device = $d[0];
  }

  proto method parse_device_changed (|)
  { * }

  multi method parse_device_changed {
    my ($d, $cd);
    samewith($c, $cd);
  }
  multi method parse_device_changed (
    $device         is rw,
    $changed_device is rw
  ) {
    my $d = CArray[Pointer[GstDevice]].new;

    ($d[0], $d[1]) = GstDevice.new xx 2;
    gst_message_parse_device_changed($!m, $d[0], $d[1]);
    ($device, $changed_device) = ($d[0], $d[1]);
  }

  proto method parse_device_removed (|)
  { * }

  multi method parse_device_removed {
    my $d;
    samewith($d);
  }
  method parse_device_removed ($device is rw) {
    my $d = CArray[Pointer[GstDevice]].new;

    $d[0] = GstDevice.new;
    gst_message_parse_device_removed($!m, $device);
  }

  method parse_error (CArray[Pointer[GError]] $gerror, Str $debug) {
    gst_message_parse_error($!m, $gerror, $debug);
  }

  method parse_error_details (GstStructure $structure) {
    gst_message_parse_error_details($!m, $structure);
  }

  method parse_group_id (guint $group_id) {
    gst_message_parse_group_id($!m, $group_id);
  }

  method parse_have_context (GstContext $context) {
    gst_message_parse_have_context($!m, $context);
  }

  method parse_info (CArray[Pointer[GError]] $gerror, Str $debug) {
    gst_message_parse_info($!m, $gerror, $debug);
  }

  method parse_info_details (GstStructure $structure) {
    gst_message_parse_info_details($!m, $structure);
  }

  method parse_new_clock (GstClock $clock) {
    gst_message_parse_new_clock($!m, $clock);
  }

  method parse_progress (GstProgressType $type, Str $code, Str $text) {
    gst_message_parse_progress($!m, $type, $code, $text);
  }

  method parse_property_notify (GstObject $object, Str $property_name, GValue $property_value) {
    gst_message_parse_property_notify($!m, $object, $property_name, $property_value);
  }

  method parse_qos (gboolean $live, guint64 $running_time, guint64 $stream_time, guint64 $timestamp, guint64 $duration) {
    gst_message_parse_qos($!m, $live, $running_time, $stream_time, $timestamp, $duration);
  }

  method parse_qos_stats (GstFormat $format, guint64 $processed, guint64 $dropped) {
    gst_message_parse_qos_stats($!m, $format, $processed, $dropped);
  }

  method parse_qos_values (gint64 $jitter, gdouble $proportion, gint $quality) {
    gst_message_parse_qos_values($!m, $jitter, $proportion, $quality);
  }

  method parse_redirect_entry (gsize $entry_index, Str $location, GstTagList $tag_list, GstStructure $entry_struct) {
    gst_message_parse_redirect_entry($!m, $entry_index, $location, $tag_list, $entry_struct);
  }

  method parse_request_state (GstState $state) {
    gst_message_parse_request_state($!m, $state);
  }

  method parse_reset_time (GstClockTime $running_time) {
    gst_message_parse_reset_time($!m, $running_time);
  }

  method parse_segment_done (GstFormat $format, gint64 $position) {
    gst_message_parse_segment_done($!m, $format, $position);
  }

  method parse_segment_start (GstFormat $format, gint64 $position) {
    gst_message_parse_segment_start($!m, $format, $position);
  }

  method parse_state_changed (GstState $oldstate, GstState $newstate, GstState $pending) {
    gst_message_parse_state_changed($!m, $oldstate, $newstate, $pending);
  }

  method parse_step_done (GstFormat $format, guint64 $amount, gdouble $rate, gboolean $flush, gboolean $intermediate, guint64 $duration, gboolean $eos) {
    gst_message_parse_step_done($!m, $format, $amount, $rate, $flush, $intermediate, $duration, $eos);
  }

  method parse_step_start (gboolean $active, GstFormat $format, guint64 $amount, gdouble $rate, gboolean $flush, gboolean $intermediate) {
    gst_message_parse_step_start($!m, $active, $format, $amount, $rate, $flush, $intermediate);
  }

  method parse_stream_collection (GstStreamCollection $collection) {
    gst_message_parse_stream_collection($!m, $collection);
  }

  method parse_stream_status (GstStreamStatusType $type, GstElement $owner) {
    gst_message_parse_stream_status($!m, $type, $owner);
  }

  method parse_streams_selected (GstStreamCollection $collection) {
    gst_message_parse_streams_selected($!m, $collection);
  }

  method parse_structure_change (GstStructureChangeType $type, GstElement $owner, gboolean $busy) {
    gst_message_parse_structure_change($!m, $type, $owner, $busy);
  }

  method parse_tag (GstTagList $tag_list) {
    gst_message_parse_tag($!m, $tag_list);
  }

  method parse_toc (GstToc $toc, gboolean $updated) {
    gst_message_parse_toc($!m, $toc, $updated);
  }

  method parse_warning (CArray[Pointer[GError]] $gerror, Str $debug) {
    gst_message_parse_warning($!m, $gerror, $debug);
  }

  method parse_warning_details (GstStructure() $structure) {
    gst_message_parse_warning_details($!m, $structure);
  }

  # Look at macro for gst_message_ref and gst_message_unref

  method set_buffering_stats (
    Int() $mode,           # GstBufferingMode $mode,
    Int() $avg_in,         # gint $avg_in,
    Int() $avg_out,        # gint $avg_out,
    Int() $buffering_left  # gint64 $buffering_left
  ) {
    gst_message_set_buffering_stats(
      $!m,
      $mode,
      $avg_in,
      $avg_out,
      $buffering_left
    );
  }

  method set_group_id (
    Int() $group_id # guint $group_id
  ) {
    gst_message_set_group_id($!m, $group_id);
  }

  method set_qos_stats (
    GstFormat() $format,
    Int() $processed,  # guint64 $processed,
    Int() $dropped     # guint64 $dropped
  ) {
    gst_message_set_qos_stats($!m, $format, $processed, $dropped);
  }

  method set_qos_values (
    Int() $jitter,     # gint64 $jitter,
    Num() $proportion, # gdouble $proportion,
    Int() $quality     # gint $quality
  ) {
    gst_message_set_qos_values($!m, $jitter, $proportion, $quality);
  }

  method streams_selected_add (GstStream() $stream) {
    gst_message_streams_selected_add($!m, $stream);
  }

  method streams_selected_get_size {
    gst_message_streams_selected_get_size($!m);
  }

  method streams_selected_get_stream (
    Int() $idx # guint $idx
  ) {
    gst_message_streams_selected_get_stream($!m, $idx);
  }

  method type_get_name (
    GStreamer::Message:U:
    Int() $type # GstMessageType
  ) {
    gst_message_type_get_name($type);
  }

  method type_to_quark (
    GStreamer::Message:U:
    Int() $type # GstMessageType
  ) {
    gst_message_type_to_quark($type);
  }

  method writable_structure (:$raw = False) {
    gst_message_writable_structure($!m);
    # ADD OBJECT CREATION CODE
  }

  # Save for when GstMessage is converted to CStruct
  # method message_type {
  #   GstMessageType($!m.type);
  # }

}
