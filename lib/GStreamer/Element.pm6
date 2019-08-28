use v6.c;

use Method::Also;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::Element;
use GStreamer::Raw::Utils;

use GStreamer::Object;
use GStreamer::Bus;
use GStreamer::Pad;

use GStreamer::Roles::Signals::Element;

our subset ElementAncestry is export of Mu
  where GstElement | GstObject;

class GStreamer::Element is GStreamer::Object {
  also does GStreamer::Roles::Signals::Element;

  has GstElement $!e;

  submethod BUILD (:$element) {
    self.setElement($element) if $element.defined;
  }

  method setElement(ElementAncestry $_) {
    my $to-parent;

    $!e = do  {
      when GstElement {
        $to-parent = cast(GstObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstElement, $_);
      }
    }
    self.setGstObject($to-parent);
  }

  method GStreamer::Raw::Types::GstElement
    is also<GstElement>
  { $!e }

  method new (GstElement $element) {
    self.bless( :$element );
  }

  # Is originally:
  # GstElement, gpointer --> void
  method no-more-pads is also<no_more_pads> {
    self.connect($!e.p, 'no-more-pads');
  }

  # Is originally:
  # GstElement, GstPad, gpointer --> void
  method pad-added is also<pad_added> {
    self.connect-pad($!e.p, 'pad-added');
  }

  # Is originally:
  # GstElement, GstPad, gpointer --> void
  method pad-removed is also<pad_removed> {
    self.connect-pad($!e.p, 'pad-removed');
  }

  method abort_state is also<abort-state> {
    gst_element_abort_state($!e);
  }

  method add_pad (GstPad() $pad) is also<add-pad> {
    gst_element_add_pad($!e, $pad);
  }

  # add-property(..., :notify, :deep) ?
  method add_property_deep_notify_watch (
    Str() $property_name,
    Int() $include_value
  )
    is also<add-property-deep-notify-watch>
  {
    gst_element_add_property_deep_notify_watch(
      $!e,
      $property_name,
      $include_value
    );
  }

  method add_property_notify_watch (
    Str() $property_name,
    Int() $include_value
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

  method change_state (
    Int() $transition # GstStateChange $transition
  )
    is also<change-state>
  {
    gst_element_change_state($!e, $transition);
  }

  method continue_state (
    Int() $ret       # GstStateChangeReturn $ret
  )
    is also<continue-state>
  {
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

  method get_base_time
    is also<
      get-base-time
      base_time
      base-time
    >
  {
    gst_element_get_base_time($!e);
  }

  method get_bus (:$raw = False)
    is also<
      get-bus
      bus
    >
  {
    my $b = gst_element_get_bus($!e);

    $b ??
      ( $raw ?? $b !! GStreamer::Bus.new($b) )
      !!
      Nil;
  }

  method get_clock (:$raw = False)
    is also<
      get-clock
      clock
    >
  {
    gst_element_get_clock($!e);
    # ADD OBJECT CREATION
  }

  method get_context (Str $context_type) is also<get-context>
  {
    gst_element_get_context($!e, $context_type);
    # ADD OBJECT CREATION
  }

  method get_context_unlocked (Str $context_type)
    is also<get-context-unlocked>
  {
    gst_element_get_context_unlocked($!e, $context_type);
    # ADD OBJECT CREATION
  }

  method get_contexts (:$raw = False)
    is also<
      get-contexts
      contexts
    >
  {
    gst_element_get_contexts($!e);
    # ADD OBJECT CREATION
  }

  method get_factory (:$raw = False)
    is also<
      get-factory
      factory
    >
  {
    my $f = gst_element_get_factory($!e);

    $f ??
      ( $raw ?? $f !! ::('GST::ElementFactory').new($f) )
      !!
      Nil;
  }

  method get_metadata (Str() $key) is also<get-metadata> {
    gst_element_get_metadata($!e, $key);
  }

  method get_pad_template (Str() $name) is also<get-pad-template> {
    gst_element_get_pad_template($!e, $name);
    # ADD OBJECT CREATION
  }

  method get_pad_template_list (:$raw = False)
    is also<get-pad-template-list>
  {
    my $tl = gst_element_get_pad_template_list($!e)
      but
      GTK::Compat::Roles::ListData[GstPadTemplate];

    # ADD OBJECT CREATION
    $tl;
  }

  method get_request_pad (Str() $name, :$raw = False)
    is also<get-request-pad>
  {
    my $p = gst_element_get_request_pad($!e, $name);

    $p ??
      ( $raw ?? $p !! GStreamer::Pad.new($p) )
      !!
      Nil;
  }

  method get_start_time
    is also<
      get-start-time
      start_time
      start-time
    >
  {
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

  method get_static_pad (Str() $name) is also<get-static-pad> {
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
      ( $raw ?? $p !! GStreamer::Iterator.new($p) )
      !!
      Nil;
  }

  method iterate_sink_pads (:$raw = False ) is also<iterate-sink-pads> {
    my $sp = gst_element_iterate_sink_pads($!e);

    $sp ??
      ( $raw ?? $sp !! GStreamer::Iterator.new($sp) )
      !!
      Nil;
  }

  method iterate_src_pads (:$raw = False) is also<iterate-src-pads> {
    my $sp = gst_element_iterate_src_pads($!e);

    $sp ??
      ( $raw ?? $sp !! GStreamer::Iterator.new($sp) )
      !!
      Nil;
  }

  method lost_state is also<lost-state> {
    gst_element_lost_state($!e);
  }

  method message_full (
    Int() $type,
    GQuark $domain,
    Int() $code,     # gint $code,
    Str() $text,
    Str() $debug,
    Str() $file,
    Str() $function,
    Int() $line      # gint $line
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
    Int() $type,
    GQuark $domain,
    Int() $code,
    Str() $text,
    Str() $debug,
    Str() $file,
    Str() $function,
    Int() $line,
    GstStructure() $structure
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

  method emit_no_more_pads is also<emit-no-more-pads> {
    gst_element_no_more_pads($!e);
  }

  method post_message (GstMessage() $message) is also<post-message> {
    gst_element_post_message($!e, $message);
  }

  method provide_clock is also<provide-clock> {
    gst_element_provide_clock($!e);
  }

  method query (GstQuery() $query) {
    gst_element_query($!e, $query);
  }

  method release_request_pad (GstPad() $pad) is also<release-request-pad> {
    gst_element_release_request_pad($!e, $pad);
  }

  method remove_pad (GstPad() $pad) is also<remove-pad> {
    gst_element_remove_pad($!e, $pad);
  }

  method remove_property_notify_watch (
    Int() $watch_id # gulong $watch_id
  )
    is also<remove-property-notify-watch>
  {
    gst_element_remove_property_notify_watch($!e, $watch_id);
  }

  method request_pad (
    GstPadTemplate() $templ,
    Str() $name,
    GstCaps() $caps
  )
    is also<request-pad>
  {
    gst_element_request_pad($!e, $templ, $name, $caps);
  }

  method seek (
    Num() $rate,       # gdouble
    GstFormat() $format,
    Int() $flags,      # GstSeekFlags $flags,
    Int() $start_type, # GstSeekType $start_type,
    Int() $start,      # uint64
    Int() $stop_type,  # GstSeekType $stop_type,
    Int() $stop        # uint64
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

  method set_base_time (
    Int() $time      # GstClockTime $time
  )
    is also<set-base-time>
  {
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

  method set_locked_state (Int() $locked_state) is also<set-locked-state> {
    gst_element_set_locked_state($!e, $locked_state);
  }

  method set_start_time (
    Int() $time      # GstClockTime $time
  )
    is also<set-start-time>
  {
    gst_element_set_start_time($!e, $time);
  }

  method set_state (
    Int() $state     # GstState $state
  )
    is also<set-state>
  {
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
