use v6.c;

use Method::Also;

use NativeCall;


use GStreamer::Raw::Types;
use GStreamer::Raw::Message;

use GStreamer::Raw::Subs;

use GLib::Value;

use GStreamer::MiniObject;

use GStreamer::Element;
use GStreamer::Clock;
use GStreamer::Context;
use GStreamer::Device;
use GStreamer::Object;
use GStreamer::StreamCollection;
use GStreamer::Structure;
use GStreamer::TagList;
use GStreamer::Toc;

class GStreamer::Message is GStreamer::MiniObject {
  has GstMessage $!m handles <type src timestamp>;

  submethod BUILD (:$message) {
    self.setMiniObject( cast(GstMiniObject, $!m = $message) );
  }

  multi method new (GstMessage $message) {
    self.bless( :$message ) if $message.defined;
  }
  multi method new (
    GstObject() $src,
    GstStructure() $structure,
    :$application is required
  ) {
    GStreamer::Message.new_application($src, $structure);
  }
  method new_application (GstObject() $src, GstStructure() $structure)
    is also<new-application>
  {
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
  )
    is also<new-async-done>
  {
    self.bless( message => gst_message_new_async_done($src, $running_time) );
  }

  multi method new (
    GstObject() $src,
    :async-start(:$async_start) is required
  ) {
    GStreamer::Message.new_async_start($src);
  }
  method new_async_start (GstObject() $src) is also<new-async-start> {
    self.bless( message => gst_message_new_async_start($src) );
  }

  multi method new (
    GstObject() $src,
    Int() $percent,
    :$buffering is required
  ) {
    GStreamer::Message.new_buffering($src, $percent);
  }
  method new_buffering (
    GstObject() $src,
    Int() $percent # gint $percent
  )
    is also<new-buffering>
  {
    self.bless( message => gst_message_new_buffering($src, $percent) );
  }

  multi method new (
    GstObject() $src,
    GstClock() $clock,
    :clock-lost(:$clock_lost) is required
  ) {
    GStreamer::Message.new_clock_lost($src, $clock);
  }
  method new_clock_lost (GstObject() $src, GstClock() $clock)
    is also<new-clock-lost>
  {
    self.bless( message => gst_message_new_clock_lost($src, $clock) );
  }

  multi method new (
    GstObject() $src,
    GstClock() $clock,
    Int() $ready, # gboolean $ready
    :clock-provide(:$clock_provide) is required
  ) {
    GStreamer::Message.new_clock_provide($src, $clock, $ready);
  }
  method new_clock_provide (
    GstObject() $src,
    GstClock $clock,
    Int() $ready # gboolean $ready
  )
    is also<new-clock-provide>
  {
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
  )
    is also<new-custom>
  {
    self.bless( message => gst_message_new_custom($type, $src, $structure) );
  }

  multi method new (
    GstObject() $src,
    GstDevice() $device,
    :device-added(:$device_added) is required
  ) {
    GStreamer::Message.new_device_added($src, $device);
  }
  method new_device_added (GstObject() $src, GstDevice() $device)
    is also<new-device-added>
  {
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
  )
    is also<new-device-changed>
  {
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
  method new_device_removed (GstObject() $src, GstDevice() $device)
    is also<new-device-removed>
  {
    self.bless( message => gst_message_new_device_removed($src, $device) );
  }

  multi method new (
    GstObject() $src,
    :duration-changed(:$duration_changed) is required
  ) {
    GStreamer::Message.new_duration_changed($src);
  }
  method new_duration_changed (GstObject() $src)
    is also<new-duration-changed>
  {
    self.bless( message => gst_message_new_duration_changed($src) );
  }

  multi method new (
    GstObject() $src,
    GstStructure() $structure,
    :$element is required
  ) {
    GStreamer::Message.new_element($src, $structure);
  }
  method new_element (GstObject() $src, GstStructure() $structure)
    is also<new-element>
  {
    self.bless( message => gst_message_new_element($src, $structure) );
  }

  multi method new (
    GstObject() $src,
    :$eos is required
  ) {
    GStreamer::Message.new_eos($src);
  }
  method new_eos (GstObject() $src) is also<new-eos> {
    self.bless( message => gst_message_new_eos($src) );
  }

  multi method new (
    GstObject() $src,
    GError $gerror,
    Str $debug,
    :$error is required
  ) {
    GStreamer::Message.new_error($src, $gerror, $debug);
  }
  method new_error (
    GstObject() $src,
    GError $error,
    Str $debug
  )
    is also<new-error>
  {
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
  )
    is also<new-error-with-details>
  {
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
  method new_have_context (GstObject() $src, GstContext() $context)
    is also<new-have-context>
  {
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
  method new_info (GstObject() $src, GError $error, Str() $debug)
    is also<new-info>
  {
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
  )
    is also<new-info-with-details>
  {
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
  method new_latency (GstObject() $src) is also<new-latency> {
    self.bless( message => gst_message_new_latency($src) );
  }

  multi method new (
    GstObject() $src,
    Str() $context_type,
    :need-context(:$need_context) is required
  ) {
    GStreamer::Message.new_need_context($src, $context_type);
  }
  method new_need_context (GstObject() $src, Str() $context_type)
    is also<new-need-context>
  {
    self.bless( message => gst_message_new_need_context($src, $context_type) );
  }

  multi method new (
    GstObject() $src,
    GstClock() $new-clock,
    :new-clock(:$new_clock) is required
  ) {
    GStreamer::Message.new($src, $new-clock);
  }
  method new_new_clock (GstObject() $src, GstClock() $clock)
    is also<new-new-clock>
  {
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
  )
    is also<new-progress>
  {
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
  )
    is also<new-property-notify>
  {
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
  )
    is also<new-qos>
  {
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
  )
    is also<new-redirect>
  {
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
    GStreamer::Message.new_request_state($src, $state);
  }
  method new_request_state (GstObject() $src, GstState() $state)
    is also<new-request-state>
  {
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
  )
    is also<new-reset-time>
  {
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
  )
    is also<new-segment-done>
  {
    self.bless(
      message => gst_message_new_segment_done($src, $format, $position)
    );
  }

  multi method new (
    GstObject() $src,
    GstFormat() $format,
    Int() $position, # gint64 $position
    :segment-start(:$segment_start) is required
  ) {
    GStreamer::Message.new_segment_start($src, $format, $position);
  }
  method new_segment_start (
    GstObject() $src,
    GstFormat() $format,
    Int() $position # gint64 $position
  )
    is also<new-segment-start>
  {
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
  )
    is also<new-state-changed>
  {
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
  method new_state_dirty (GstObject() $src)
    is also<new-state-dirty>
  {
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
  )
    is also<new-step-done>
  {
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
  )
    is also<new-step-start>
  {
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
  )
    is also<new-stream-collection>
  {
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
  method new_stream_start (GstObject() $src) is also<new-stream-start> {
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
  )
    is also<new-stream-status>
  {
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
  )
    is also<new-streams-selected>
  {
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
  )
    is also<new-structure-change>
  {
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
  method new_tag (GstObject() $src, GstTagList() $tag_list) is also<new-tag> {
    self.bless( message => gst_message_new_tag($src, $tag_list) );
  }

  multi method new (
    GstObject() $src,
    GstToc() $new-toc,
    Int() $updated,   # gboolean $updated
    :$toc is required
  ) {
    GStreamer::Message.new_toc($src, $new-toc, $updated);
  }
  method new_toc (
    GstObject() $src,
    GstToc() $toc,
    Int() $updated    # gboolean $updated
  )
    is also<new-toc>
  {
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
  method new_warning (GstObject() $src, GError $error, Str() $debug)
    is also<new-warning>
  {
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
  )
    is also<new-warning-with-details>
  {
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

  method stream_status_object (:$raw = False) is rw
    is also<stream-status-object>
  {
    Proxy.new(
      FETCH => sub ($) {
        my $v = gst_message_get_stream_status_object($!m);

        $v ??
          ( $raw ?? $v !! GLib::Value.new($v) )
          !!
          Nil;
      },
      STORE => sub ($, GValue() $object is copy) {
        gst_message_set_stream_status_object($!m, $object);
      }
    );
  }

  method get_src (:$raw = False) is also<get-src> {
    $!m.src ??
      ( $raw ?? $!m.src !! GStreamer::Object.new($!m.src) )
      !!
      Nil;
  }

  method add_redirect_entry (
    Str() $location,
    GstTagList() $tag_list,
    GstStructure() $entry_struct
  )
    is also<add-redirect-entry>
  {
    gst_message_add_redirect_entry($!m, $location, $tag_list, $entry_struct);
  }

  method get_num_redirect_entries is also<get-num-redirect-entries> {
    gst_message_get_num_redirect_entries($!m);
  }

  method get_structure (:$raw = False) is also<get-structure> {
    gst_message_get_structure($!m);
    # ADD OBJECT CREATION CODE
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_message_get_type, $n, $t );
  }

  method has_name (Str $name) is also<has-name> {
    so gst_message_has_name($!m, $name);
  }

  proto method parse_async_done (|)
    is also<parse-async-done>
  { * }

  multi method parse_async_done {
    samewith($);
  }
  multi method parse_async_done ($running_time is rw) {
    my gint $r = 0;

    gst_message_parse_async_done($!m, $r);
    $running_time = $r;
  }

  proto method parse_buffering (|)
    is also<parse-buffering>
  { * }

  multi method parse_buffering  {
    samewith($);
  }
  multi method parse_buffering ($percent is rw) {
    my gint $p = 0;
    gst_message_parse_buffering($!m, $p);
    $percent = $p;
  }

  proto method parse_buffering_stats (|)
    is also<parse-buffering-stats>
  { * }

  multi method parse_buffering_stats  {
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
    ($mode, $avg_in, $avg_out, $buffering_left) =
      ($m, $ai, $ao, $bl);
  }

  proto method parse_clock_lost (|)
    is also<parse-clock-lost>
  { * }

  multi method parse_clock_lost (:$raw = False) {
    samewith($,:$raw)
  }
  multi method parse_clock_lost ($clock is rw, :$raw = False) {
    my $ca = CArray[Pointer[GstClock]].new;

    $ca[0] = Pointer[GstClock].new;
    gst_message_parse_clock_lost($!m, $ca);
    ($clock) = ppr($ca);
    $clock = GStreamer::Clock.new($clock) unless $raw;
    $clock;
  }

  proto method parse_clock_provide (|)
    is also<parse-clock-provide>
  { * }

  multi method parse_clock_provide (:$raw = False) {
    my ($c, $r);
    samewith($c, $r, :$raw);
  }
  multi method parse_clock_provide (
    $clock is rw,
    $ready is rw,
    :$raw = False
  ) {
    my gboolean $r = 0;
    my $ca = CArray[Pointer[GstClock]].new;

    $ca[0] = Pointer[GstClock].new;
    gst_message_parse_clock_provide($!m, $ca, $r);
    ($clock, $ready) = ppr($ca, $r);
    $clock = GStreamer::Clock.new($clock) unless $raw;
    ($clock, $ready)
  }

  proto method parse_context_type (|)
    is also<parse-context-type>
  { * }

  multi method parse_context_type (:$all = False) {
    samewith($, :$all);
  }
  multi method parse_context_type ($context_type is rw, :$all = False) {
    my $ct = CArray[Str].new;

    my $rc = gst_message_parse_context_type($!m, $ct);
    $context_type = $rc ?? ppr($ct) !! Nil;
    $all.not ?? $context_type !! ($context_type, $rc);
  }

  proto method parse_device_added (|)
    is also<parse-device-added>
  { * }

  multi method parse_device_added (:$raw = False) {
    samewith($, :$raw);
  }
  multi method parse_device_added (
    $device is rw,
    :$all = False,
    :$raw = False
  ) {
    my $d = CArray[Pointer[GstDevice]].new;

    $d[0] = Pointer[GstDevice].new;
    gst_message_parse_device_added($!m, $d);
    ($device) = ppr($d);
    $device = GStreamer::Device.new($device) unless $raw;
    $device;
  }

  proto method parse_device_changed (|)
    is also<parse-device-changed>
  { * }

  multi method parse_device_changed (:$raw = False) {
    samewith($, $, :$raw);
  }
  multi method parse_device_changed (
    $device         is rw,
    $changed_device is rw,
    :$raw = False
  ) {
    my  $da = CArray[Pointer[GstDevice]].new;
    my $cda = CArray[Pointer[GstDevice]].new;

    ($da[0], $cda[0]) = Pointer[GstDevice].new xx 2;
    gst_message_parse_device_changed($!m, $da, $cda);
    ($device, $changed_device) = ppr( $da, $cda );
    unless $raw {
      $device         = GStreamer::Device.new($device);
      $changed_device = GStreamer::Device.new($changed_device);
    }
    ($device, $changed_device)
  }

  proto method parse_device_removed (|)
    is also<parse-device-removed>
  { * }

  multi method parse_device_removed (:$raw = False) {
    samewith($, :$raw);
  }
  multi method parse_device_removed (
    $device is rw,
    :$raw = False
  ) {
    my $d = CArray[Pointer[GstDevice]].new;

    $d[0] = Pointer[GstDevice].new;
    gst_message_parse_device_removed($!m, $device);
    ($device) = ppr( $d );
    $device = GStreamer::Device.new($device) unless $raw;
    $device;
  }

  proto method parse_error (|)
    is also<parse-error>
  { * }

  multi method parse_error  {
    samewith($, $);
  }
  multi method parse_error ($gerror is rw, $debug is rw) {
    my $ge = CArray[Pointer[GError]].new;
    my $d = CArray[Str].new;

    $ge[0] = Pointer[GError].new;
    gst_message_parse_error($!m, $ge, $d);
    ($gerror, $debug) = ppr($ge, $d);
  }

  proto method parse_error_details
    is also<parse-error-details>
  { * }

  multi method parse_error_details (:$all = False, :$raw = False) {
    samewith($, :$all, :$raw);
  }
  multi method parse_error_details (
    $structure is rw,
    :$all = False,
    :$raw = False
  ) {
    my $s = CArray[Pointer[GstStructure]].new;

    $s[0] = Pointer[GstStructure].new;
    gst_message_parse_error_details($!m, $s);
    ($structure) = ppr( $s );
    $structure = GStreamer::Structure.new($structure) unless $raw;
    $all.not ?? $structure !! ($structure, $all);
  }

  proto method parse_group_id (|)
    is also<parse-group-id>
  { * }

  multi method parse_group_id (:$all = False) {
    samewith($, :$all);
  }
  multi method parse_group_id ($group_id is rw, :$all = False) {
    my $g = 0;

    my $rc = gst_message_parse_group_id($!m, $g);
    $group_id = $rc ?? $g !! Nil;
    $all.not ?? $group_id !! ($group_id, $rc);
  }

  proto method parse_have_context (|)
    is also<parse-have-context>
  { * }

  multi method parse_have_context (:$raw = False) {
    samewith($, :$raw);
  }
  multi method parse_have_context (
    $context is rw,
    :$all = False,
    :$raw = False
  ) {
    my $c = CArray[Pointer[GstContext]].new;

    $c[0] = Pointer[GstContext].new;
    gst_message_parse_have_context($!m, $c);
    ($context) = ppr( $c );
    $context = GStreamer::Context.new($context) unless $raw;
    $context;
  }

  proto method parse_info (|)
    is also<parse-info>
  { * }

  multi method parse_info  {
    samewith($, $);
  }
  multi method parse_info ($gerror is rw, $debug is rw) {
    my $ge = CArray[Pointer[GError]].new;
    my $d = CArray[Str].new;

    $ge[0] = Pointer[GError].new;
    gst_message_parse_info($!m, $gerror, $debug);
    ($gerror, $debug) = ppr( $ge, $d );
    ($gerror, $debug);
  }

  proto method parse_info_details (|)
    is also<parse-info-details>
  { * }

  multi method parse_info_details (:$all = False, :$raw = False) {
    samewith($);
  }
  multi method parse_info_details (
    $structure is rw,
    :$all = False,
    :$raw = False
  ) {
    my $s = CArray[Pointer[GstStructure]].new;

    $s[0] = Pointer[GstStructure].new;
    my $rc = gst_message_parse_info_details($!m, $s);
    if $rc {
      ($structure) = ppr( $s );
      $structure = GStreamer::Structure.new($structure) unless $raw;
    } else {
      $structure = Nil;
    }
    $all.not ?? $structure !! ($structure, $rc);
  }

  proto method parse_new_clock (|)
    is also<parse-new-clock>
  { * }

  multi method parse_new_clock (:$raw = False) {
    samewith($,:$raw);
  }
  multi method parse_new_clock ($clock is rw, :$raw = False) {
    my $c = CArray[Pointer[GstClock]].new;

    $c[0] = Pointer[GstClock].new;
    gst_message_parse_new_clock($!m, $c);
    ($clock) = ppr($c);
    $clock = GStreamer::Clock.new($clock) unless $raw;
    $clock;
  }

  proto method parse_progress (|)
    is also<parse-progress>
  { * }

  multi method parse_progress {
    samewith($, $, $);
  }
  multi method parse_progress ($type is rw, Str $code is rw, Str $text is rw) {
    my GstProgressType $ty = 0;
    my ($c, $t) = CArray[Str].new xx 2;

    my $rc = gst_message_parse_progress($!m, $ty, $c, $t);
    ($type, $code, $text) = ppr($ty, $c, $t);
    ($type, $code, $text)
  }

  proto method parse_property_notify (|)
    is also<parse-property-notify>
  { * }

  multi method parse_property_notify (:$raw = False) {
    samewith($, $, $);
  }
  multi method parse_property_notify (
    $object is rw,
    $property_name is rw,
    $property_value is rw,
    :$raw = False
  ) {
    my $o = CArray[Pointer[GstObject]].new;
    my $pn = CArray[Str].new;
    my $pv = CArray[Pointer[GValue]].new;

    ($o[0], $pv[0]) = (Pointer[GstObject].new, Pointer[GValue].new);
    gst_message_parse_property_notify($!m, $o, $pn, $pv);
    ($object, $property_name, $property_value) = ppr( $o, $pn, $pv );
    unless $raw {
      $object = GStreamer::Object.new($object);
      $property_value = GLib::Value.new($property_value);
    }
    ($object, $property_name, $property_value);
  }

  proto method parse_qos (|)
    is also<parse-qos>
  { * }

  multi method parse_qos {
    my ($l, $r, $s, $t, $d);
    samewith($l, $r, $s, $t, $d);
  }
  multi method parse_qos (
    $live         is rw,
    $running_time is rw,
    $stream_time  is rw,
    $timestamp    is rw,
    $duration     is rw
  ) {
    my gboolean $l = 0;
    my guint64 ($r, $s, $t, $d) = 4 xx 0;

    my $rc = gst_message_parse_qos($!m, $l, $r, $s, $t, $d);
    ($live, $running_time, $stream_time, $timestamp, $duration)
      = ($l, $r, $s, $t, $d);
    ($live, $running_time, $stream_time, $timestamp, $duration)
  }

  proto method parse_qos_stats (|)
    is also<parse-qos-stats>
  { * }

  multi method parse_qos_stats {
    my ($f, $p, $d);
    samewith($f, $p, $d);
  }
  multi method parse_qos_stats (
    $format    is rw,
    $processed is rw,
    $dropped   is rw
  ) {
    my GstFormat $f = 0;
    my guint64 ($p, $d) = 0;

    my $rc = gst_message_parse_qos_stats($!m, $f, $p, $d);
    ($format, $processed, $dropped) = ($f, $p, $d);
  }

  proto method parse_qos_values (|)
    is also<parse-qos-values>
  { * }

  multi method parse_qos_values {
    my ($j, $p ,$q);
    samewith($j, $p ,$q);
  }
  multi method parse_qos_values (
    $jitter     is rw,
    $proportion is rw,
    $quality    is rw
  ) {
    my gint64 $j = 0;
    my gdouble $p = 0e0;
    my gint $q = 0;

    gst_message_parse_qos_values($!m, $j, $p, $q);
    ($jitter, $proportion, $quality) = ($j, $p, $q);
  }

  proto method parse_redirect_entry (|)
    is also<parse-redirect-entry>
  { * }

  multi method parse_redirect_entry (:$raw = False) {
    my ($ei, $l, $tl, $es);
    samewith($ei, $l, $tl, $es, :$raw);
  }
  multi method parse_redirect_entry (
    $entry_index  is rw,
    $location     is rw,
    $tag_list     is rw,
    $entry_struct is rw,
    :$raw = False
  ) {
    my gsize $ei = 0;
    my $l = CArray[Str].new;
    my $tl = CArray[Pointer[GstTagList]].new;
    my $es = CArray[Pointer[GstStructure]].new;

    ($tl[0], $es[0]) = (Pointer[GstTagList].new, Pointer[GstStructure].new);
    gst_message_parse_redirect_entry($!m, $ei, $l, $tl, $es);
    ($entry_index, $location, $tag_list, $entry_struct) =
      ppr($ei, $l, $tl, $es);
    unless $raw {
      $tag_list = GStreamer::TagList.new($tag_list);
      $entry_struct = GStreamer::Structure.new($entry_struct);
    }
    ($entry_index, $location, $tag_list, $entry_struct)
  }

  proto method parse_request_state (|)
    is also<parse-request-state>
  { * }

  multi method parse_request_state {
    samewith($);
  }
  multi method parse_request_state ($state is rw) {
    my GstState $s = 0;

    gst_message_parse_request_state($!m, $s);
    $state = $s;
  }

  proto method parse_reset_time (|)
    is also<parse-reset-time>
  { * }

  multi method parse_reset_time{
    samewith($);
  }
  multi method parse_reset_time ($running_time is rw) {
    my guint $rt = 0;

    gst_message_parse_reset_time($!m, $rt);
    $running_time = $rt;
  }

  proto method parse_segment_done (|)
    is also<parse-segment-done>
  { * }

  multi method parse_segment_done {
    samewith($, $);
  }
  multi method parse_segment_done ($format is rw, $position is rw) {
    my GstFormat $f = 0;
    my gint64 $p = 0;

    gst_message_parse_segment_done($!m, $f, $p);
    ($format, $position) = ($f, $p)
  }

  proto method parse_segment_start (|)
    is also<parse-segment-start>
  { * }

  multi method parse_segment_start {
    samewith($, $);
  }
  multi method parse_segment_start ($format is rw, $position is rw) {
    my GstFormat $f = 0;
    my gint64 $p = 0;

    my $rc = gst_message_parse_segment_start($!m, $format, $position);
    ($format, $position) = ($f, $p);
  }

  proto method parse_state_changed (|)
    is also<parse-state-changed>
  { * }

  multi method parse_state_changed {
    samewith($, $, $);
  }
  multi method parse_state_changed (
    $oldstate is rw,
    $newstate is rw,
    $pending  is rw
  ) {
    my GstState ($o, $n, $p) = 0 xx 3;

    my $rc = gst_message_parse_state_changed($!m, $o, $n, $p);
    ($oldstate, $newstate, $pending) = ppr($o, $n, $p);
  }

  proto method parse_step_done (|)
    is also<parse-step-done>
  { * }

  multi method parse_step_done {
    samewith($, $, $, $, $, $, $);
  }
  multi method parse_step_done (
    $format       is rw,
    $amount       is rw,
    $rate         is rw,
    $flush        is rw,
    $intermediate is rw,
    $duration     is rw,
    $eos          is rw
  ) {
    my GstState $f = 0;
    my guint64 ($a, $d) = 0 xx 2;
    my gdouble $r = 0e0;
    my gboolean ($fl, $l, $i, $e) = 0 xx 4;

    gst_message_parse_step_done($!m, $f, $a, $r, $fl, $i, $d, $e);
    ($format, $amount, $rate, $flush, $intermediate, $duration, $eos)
      = ($f, $a, $r, $fl, $i, $d, $e);
    ($format, $amount, $rate, $flush, $intermediate, $duration, $eos);
  }

  proto method parse_step_start (|)
    is also<parse-step-start>
  { * }

  multi method parse_step_start {
    samewith($, $, $, $, $, $);
  }
  multi method parse_step_start (
    $active        is rw,
    $format        is rw,
    $amount        is rw,
    $rate          is rw,
    $flush         is rw,
    $intermediate  is rw
  ) {
    my gboolean ($a, $fl, $i) = 0 xx 3;
    my guint64 $am = 0;
    my GstState $f = 0;
    my gdouble $r = 0e0;

    gst_message_parse_step_start($!m, $a, $f, $am, $r, $fl, $i);
    ($active, $format, $amount, $rate, $flush, $intermediate) =
      ($a, $f, $am, $r, $fl, $i);
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
    my $c = CArray[Pointer[GstStreamCollection]].new;

    $c[0] = Pointer[GstStreamCollection];
    gst_message_parse_stream_collection($!m, $collection);

    ($collection) = ppr($c);
    $collection = GStreamer::StreamCollection.new($collection) unless $raw;
    $collection;
  }

  proto method parse_stream_status (|)
    is also<parse-stream-status>
  { * }

  multi method parse_stream_status (:$raw = False) {
    samewith($, $);
  }
  multi method parse_stream_status ($type is rw, $owner is rw, :$raw = False) {
    my guint $t = 0;
    my $o = CArray[Pointer[GstElement]].new;

    $o[0] = Pointer[GstElement].new;
    gst_message_parse_stream_status($!m, $t, $o);
    ($type, $owner) = ppr($t, $o);
    $owner = GStreamer::Element.new($owner) unless $raw;
    ($type, $owner)
  }

  proto method parse_streams_selected (|)
    is also<parse-streams-selected>
  { * }

  multi method parse_streams_selected (:$raw = False) {
    samewith($, :$raw);
  }
  multi method parse_streams_selected (
    $collection is rw,
    :$raw = False
  ) {
    my $c = CArray[Pointer[GstStreamCollection]].new;

    $c[0] = Pointer[GstStreamCollection].new;
    gst_message_parse_streams_selected($!m, $c);
    ($collection) = ppr($c);
    $collection = GStreamer::StreamCollection.new($collection) unless $raw;
    $collection
  }

  proto method parse_structure_change (|)
    is also<parse-structure-change>
  { * }

  multi method parse_structure_change (:$raw = False) {
    samewith($, $, $, :$raw);
  }
  multi method parse_structure_change (
    $type  is rw,
    $owner is rw,
    $busy  is rw,
    :$raw = False
  ) {
    my guint ($t, $b) = 0 xx 2;
    my $o = CArray[Pointer[GstElement]].new;

    $o[0] = Pointer[GstElement].new;
    gst_message_parse_structure_change($!m, $t, $o, $b);
    ($type, $owner, $busy) = ppr($t, $o, $b);
    $owner = GStreamer::Element.new($owner) unless $raw;
    ($type, $owner, $busy);
  }

  proto method parse_tag (|)
    is also<parse-tag>
  { * }

  multi method parse_tag (:$raw = False) {
    samewith($, :$raw);
  }
  multi method parse_tag ($tag_list is rw, :$raw = False) {
    my $t = CArray[Pointer[GstTagList]].new;

    $t[0] = Pointer[GstTagList].new;
    gst_message_parse_tag($!m, $t);
    ($tag_list) = ppr( $t );
    $tag_list = GStreamer::TagList.new($tag_list) unless $raw;
  }

  proto method parse_toc (|)
    is also<parse-toc>
  { * }

  multi method parse_toc (:$raw = False) {
    samewith($, $, :$raw);
  }
  multi method parse_toc ($toc is rw, $updated is rw, :$raw = False) {
    my $t = CArray[Pointer[GstToc]].new;
    my gboolean $u = 0;

    $t[0] = Pointer[GstToc].new;
    gst_message_parse_toc($!m, $toc, $updated);
    ($toc, $updated) = ppr($t, $u);
    $toc = GStreamer::Toc.new($toc) unless $raw;
    ($toc, $updated);
  }

  proto method parse_warning (|)
    is also<parse-warning>
  { * }

  multi method parse_warning {
    samewith($, $);
  }
  multi method parse_warning ($gerror is rw, $debug is rw) {
    my $ge = CArray[Pointer[GError]].new;
    my $d = CArray[Str].new;

    $ge[0] = Pointer[GError].new;
    gst_message_parse_warning($!m, $ge, $d);
    ($gerror, $debug) = ppr( $ge, $d );
  }

  proto method parse_warning_details (|)
    is also<parse-warning-details>
  { * }

  multi parse_warning_details (:$raw = False) {
    samewith($);
  }
  multi method parse_warning_details (
    $structure is rw
    :$raw = False
  ) {
    my $s = CArray[Pointer[GstStructure]].new;

    $s[0] = Pointer[GstStructure].new;
    gst_message_parse_warning_details($!m, $s);
    ($structure) = ppr($s);
    $structure = GStreamer::Structure.new($structure) unless $raw;
    $structure;
  }

  # Look at macro for gst_message_ref and gst_message_unref

  method set_buffering_stats (
    Int() $mode,           # GstBufferingMode $mode,
    Int() $avg_in,         # gint $avg_in,
    Int() $avg_out,        # gint $avg_out,
    Int() $buffering_left  # gint64 $buffering_left
  )
    is also<set-buffering-stats>
  {
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
  )
    is also<set-group-id>
  {
    gst_message_set_group_id($!m, $group_id);
  }

  method set_qos_stats (
    GstFormat() $format,
    Int() $processed,  # guint64 $processed,
    Int() $dropped     # guint64 $dropped
  )
    is also<set-qos-stats>
  {
    gst_message_set_qos_stats($!m, $format, $processed, $dropped);
  }

  method set_qos_values (
    Int() $jitter,     # gint64 $jitter,
    Num() $proportion, # gdouble $proportion,
    Int() $quality     # gint $quality
  )
    is also<set-qos-values>
  {
    gst_message_set_qos_values($!m, $jitter, $proportion, $quality);
  }

  method streams_selected_add (GstStream() $stream)
    is also<streams-selected-add>
  {
    gst_message_streams_selected_add($!m, $stream);
  }

  method streams_selected_get_size is also<streams-selected-get-size> {
    gst_message_streams_selected_get_size($!m);
  }

  method streams_selected_get_stream (
    Int() $idx # guint $idx
  )
    is also<streams-selected-get-stream>
  {
    gst_message_streams_selected_get_stream($!m, $idx);
  }

  method type_get_name (
    GStreamer::Message:U:
    Int() $type # GstMessageType
  )
    is also<type-get-name>
  {
    gst_message_type_get_name($type);
  }

  method type_to_quark (
    GStreamer::Message:U:
    Int() $type # GstMessageType
  )
    is also<type-to-quark>
  {
    gst_message_type_to_quark($type);
  }

  method writable_structure (:$raw = False)
    is also<writable-structure>
  {
    gst_message_writable_structure($!m);
    # ADD OBJECT CREATION CODE
  }

  # Save for when GstMessage is converted to CStruct
  # method message_type {
  #   GstMessageType($!m.type);
  # }

}
