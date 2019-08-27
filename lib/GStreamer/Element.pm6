use v6.c;

use Method::Also;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::Element;
use GStreamer::Raw::Utils;

use GStreamer::Object;

use GStreamer::Roles::Signals::Element;

our ElementAncestry is export of Mu
  where GstElement | GstObject;

class GStreamer::Element is GStreamer::Object {
  also does GStreamer::Roles::Signals::Element;

  has GstElement $!e;

  submethod BUILD (ElementAncestry :$element) {
    self.setGStreamerElement($elefment) if $element;
  }

  method setGStreamerElement(ElementAncestry $_) {
    my $to-parent;

    $!e = do  {
      when GstElement {
        $to-parent = cast(GstObject, $element);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstElement, $_);
      }
    }
    self.setGStreamerObject($to-parent);
  }

  method GStreamer::Raw::Types::GstElement
    is also<GstElement>
  { $!e }

  # Is originally:
  # GstElement, gpointer --> void
  method no-more-pads {
    self.connect($!e, 'no-more-pads');
  }

  # Is originally:
  # GstElement, GstPad, gpointer --> void
  method pad-added {
    self.connect-pad($!e, 'pad-added');
  }

  # Is originally:
  # GstElement, GstPad, gpointer --> void
  method pad-removed {
    self.connect-pad($!e, 'pad-removed');
  }

  method abort_state is also<abort-state> {
    gst_element_abort_state($!e);
  }

  method add_pad (GstPad() $pad) is also<add-pad> {
    gst_element_add_pad($!e, $pad);
  }

  # add-property(..., :notify, :deep) ?
  method add_property_deep_notify_watch (
    Str $property_name,
    gboolean $include_value
  )
    is also<add-property-deep-notify-watch>
  {
    gst_element_add_property_deep_notify_watch($!e, $property_name, $include_value);
  }

  method add_property_notify_watch (
    Str $property_name,
    gboolean $include_value
  )
    is also<add-property-notify-watch>
  {
    gst_element_add_property_notify_watch($!e, $property_name, $include_value);
  }

  method call_async (
    GstElementCallAsyncFunc $func,
    gpointer $user_data,
    GDestroyNotify $destroy_notify
  )
    is also<call-async>
  {
    gst_element_call_async($!e, $func, $user_data, $destroy_notify);
  }

  method change_state (GstStateChange $transition) is also<change-state> {
    gst_element_change_state($!e, $transition);
  }

  method continue_state (GstStateChangeReturn $ret) is also<continue-state> {
    gst_element_continue_state($!e, $ret);
  }

  method foreach_pad (
    GstElementForeachPadFunc $func,
    gpointer $user_data = gpointer
  )
    is also<foreach-pad>
  {
    gst_element_foreach_pad($!e, $func, $user_data);
  }

  method foreach_sink_pad (
    GstElementForeachPadFunc $func,
    gpointer $user_data = gpointer
  )
    is also<foreach-sink-pad>
  {
    gst_element_foreach_sink_pad($!e, $func, $user_data);
  }

  method foreach_src_pad (
    GstElementForeachPadFunc $func,
    gpointer $user_data = gpointer
  )
    is also<foreach-src-pad>
  {
    gst_element_foreach_src_pad($!e, $func, $user_data);
  }

  method get_base_time is also<get-base-time> {
    gst_element_get_base_time($!e);
  }

  method get_bus is also<get-bus> {
    gst_element_get_bus($!e);
  }

  method get_clock is also<get-clock> {
    gst_element_get_clock($!e);
  }

  method get_context (Str $context_type) is also<get-context> {
    gst_element_get_context($!e, $context_type);
  }

  method get_context_unlocked (Str $context_type)
    is also<get-context-unlocked>
  {
    gst_element_get_context_unlocked($!e, $context_type);
  }

  method get_contexts is also<get-contexts> {
    gst_element_get_contexts($!e);
  }

  method get_factory is also<get-factory> {
    gst_element_get_factory($!e);
  }

  method get_metadata (Str $key) is also<get-metadata> {
    gst_element_get_metadata($!e, $key);
  }

  method get_pad_template (Str $name) is also<get-pad-template> {
    gst_element_get_pad_template($!e, $name);
  }

  method get_pad_template_list is also<get-pad-template-list> {
    gst_element_get_pad_template_list($!e);
  }

  method get_request_pad (Str $name) is also<get-request-pad> {
    gst_element_get_request_pad($!e, $name);
  }

  method get_start_time is also<get-start-time> {
    gst_element_get_start_time($!e);
  }

  method get_state (
    Int() $state,    # GstState $state,
    Int() $pending,  # GstState $pending,
    Int() $timeout   # GstClockTime $timeout
  )
    is also<get-state>
  {
    gst_element_get_state($!e, $state, $pending, $timeout);
  }

  method get_static_pad (Str $name) is also<get-static-pad> {
    gst_element_get_static_pad($!e, $name);
  }

  method get_type is also<get-type> {
    state ($n, $t);
    unstable_get_type( self.^name, &gst_element_get_type, $n, $t );
  }

  method is_locked_state is also<is-locked-state> {
    so gst_element_is_locked_state($!e);
  }

  method iterate_pads (:$raw = False) is also<iterate-pads> {
    my $p = gst_element_iterate_pads($!e);

    $p ??
      ( $raw ?? $p ?? GStreamer::Iterator.new($p) )
      !!
      Nil;
  }

  method iterate_sink_pads (:$raw = False ) is also<iterate-sink-pads> {
    my $sp = gst_element_iterate_sink_pads($!e);

    $sp ??
      ( $raw ?? $sp ?? GStreamer::Iterator.new($sp) )
      !!
      Nil;
  }

  method iterate_src_pads (:$raw = False) is also<iterate-src-pads> {
    my $sp = gst_element_iterate_src_pads($!e);

    $sp ??
      ( $raw ?? $sp ?? GStreamer::Iterator.new($sp) )
      !!
      Nil;
  }

  method lost_state is also<lost-state> {
    gst_element_lost_state($!e);
  }

  method message_full (
    GstMessageType $type,
    GQuark $domain,
    gint $code,
    Str $text,
    Str $debug,
    Str $file,
    Str $function,
    gint $line
  )
    is also<message-full>
  {
    gst_element_message_full(
      $!e,
      $type,
      $domain,
      $code,
      $text,
      $debug,
      $file,
      $function,
      $line
    );
  }

  method message_full_with_details (
    GstMessageType $type,
    GQuark $domain,
    gint $code,
    Str $text,
    Str $debug,
    Str $file,
    Str $function,
    gint $line,
    GstStructure $structure
  )
    is also<message-full-with-details>
  {
    gst_element_message_full_with_details(
      $!e,
      $type,
      $domain,
      $code,
      $text,
      $debug,
      $file,
      $function,
      $line,
      $structure
    );
  }

  method no_more_pads is also<no-more-pads> {
    gst_element_no_more_pads($!e);
  }

  method post_message (GstMessage() $message) is also<post-message> {
    gst_element_post_message($!e, $message);
  }

  method provide_clock is also<provide-clock> {
    gst_element_provide_clock($!e);
  }

  method query (GstQuery $query) {
    gst_element_query($!e, $query);
  }

  method release_request_pad (GstPad() $pad) is also<release-request-pad> {
    gst_element_release_request_pad($!e, $pad);
  }

  method remove_pad (GstPad() $pad) is also<remove-pad> {
    gst_element_remove_pad($!e, $pad);
  }

  method remove_property_notify_watch (gulong $watch_id)
    is also<remove-property-notify-watch>
  {
    gst_element_remove_property_notify_watch($!e, $watch_id);
  }

  method request_pad (GstPadTemplate $templ, Str $name, GstCaps $caps)
    is also<request-pad>
  {
    gst_element_request_pad($!e, $templ, $name, $caps);
  }

  method seek (
    gdouble $rate,
    GstFormat $format,
    GstSeekFlags $flags,
    GstSeekType $start_type,
    gint64 $start,
    GstSeekType $stop_type,
    gint64 $stop
  ) {
    gst_element_seek(
      $!e,
      $rate,
      $format,
      $flags,
      $start_type,
      $start,
      $stop_type,
      $stop
    );
  }

  method send_event (GstEvent() $event) is also<send-event> {
    gst_element_send_event($!e, $event);
  }

  method set_base_time (GstClockTime $time) is also<set-base-time> {
    gst_element_set_base_time($!e, $time);
  }

  method set_bus (GstBus() $bus) is also<set-bus> {
    gst_element_set_bus($!e, $bus);
  }

  method set_clock (GstClock() $clock) is also<set-clock> {
    gst_element_set_clock($!e, $clock);
  }

  method set_context (GstContext() $context) is also<set-context> {
    gst_element_set_context($!e, $context);
  }

  method set_locked_state (gboolean $locked_state) is also<set-locked-state> {
    gst_element_set_locked_state($!e, $locked_state);
  }

  method set_start_time (GstClockTime $time) is also<set-start-time> {
    gst_element_set_start_time($!e, $time);
  }

  method set_state (GstState $state) is also<set-state> {
    gst_element_set_state($!e, $state);
  }

  method sync_state_with_parent is also<sync-state-with-parent> {
    gst_element_sync_state_with_parent($!e);
  }

  # From gstutils.h

  method create_all_pads is also<create-all-pads> {
    gst_element_create_all_pads($!e);
  }

  method get_compatible_pad (GstPad $pad, GstCaps $caps)
    is also<get-compatible-pad>
  {
    gst_element_get_compatible_pad($!e, $pad, $caps);
  }

  method get_compatible_pad_template (GstPadTemplate $compattempl)
    is also<get-compatible-pad-template>
  {
    gst_element_get_compatible_pad_template($!e, $compattempl);
  }

  method link (GstElement() $dest) {
    gst_element_link($!e, $dest);
  }

  method link_many (*@e) is also<link-many> {
    my $dieMsg = qq:to/DIE/.&nocr;
      Items passed to GStreamer::Element.link_many must be GStreamer::Element
      compatible!
      DIE

    die $dieMsg unless @e.all ~~ (GStreamer::Element, GstElement).any;
    self.link($_) for @e;
  }

  method link_filtered (GstElement $dest, GstCaps $filter)
    is also<link-filtered>
  {
    gst_element_link_filtered($!e, $dest, $filter);
  }

  method link_pads (Str $srcpadname, GstElement $dest, Str $destpadname)
    is also<link-pads>
  {
    gst_element_link_pads($!e, $srcpadname, $dest, $destpadname);
  }

  method link_pads_filtered (
    Str $srcpadname,
    GstElement $dest,
    Str $destpadname,
    GstCaps $filter
  )
    is also<link-pads-filtered>
  {
    gst_element_link_pads_filtered(
      $!e,
      $srcpadname,
      $dest,
      $destpadname,
      $filter
    );
  }

  method link_pads_full (
    Str $srcpadname,
    GstElement $dest,
    Str $destpadname,
    GstPadLinkCheck $flags
  )
    is also<link-pads-full>
  {
    gst_element_link_pads_full($!e, $srcpadname, $dest, $destpadname, $flags);
  }

  method query_convert (
    GstFormat $src_format,
    gint64 $src_val,
    GstFormat $dest_format,
    gint64 $dest_val
  )
    is also<query-convert>
  {
    gst_element_query_convert(
      $!e,
      $src_format,
      $src_val,
      $dest_format,
      $dest_val
    );
  }

  method query_duration (GstFormat $format, gint64 $duration)
    is also<query-duration>
  {
    gst_element_query_duration($!e, $format, $duration);
  }

  method query_position (GstFormat $format, gint64 $cur)
    is also<query-position>
  {
    gst_element_query_position($!e, $format, $cur);
  }

  method seek_simple (
    GstFormat $format,
    GstSeekFlags $seek_flags,
    gint64 $seek_pos
  )
    is also<seek-simple>
  {
    gst_element_seek_simple($!e, $format, $seek_flags, $seek_pos);
  }

  method state_change_return_get_name is also<state-change-return-get-name> {
    gst_element_state_change_return_get_name($!e);
  }

  method state_get_name is also<state-get-name> {
    gst_element_state_get_name($!e);
  }

  method unlink (GstElement $dest) {
    gst_element_unlink($!e, $dest);
  }

  method unlink_pads (Str $srcpadname, GstElement $dest, Str $destpadname)
    is also<unlink-pads>
  {
    gst_element_unlink_pads($!e, $srcpadname, $dest, $destpadname);
  }

}
