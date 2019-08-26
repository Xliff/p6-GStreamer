use v6.c;

use Method::Also;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::Pad;

use GStreamer::Object;
use GStreamer::Iterator;

our subset PadAncestry is export of Mu
  where GstPad | GstObject;

class GStreamer::Pad is GStreamer::Object {
  has GstPad $!p;

  submethod BUILD (:$pad) {
    self.setPad($pad);
  }

  method setPad (GstAncestry $_) {
    my $to-parent;

    $!p = do {
      when GstPad {
        $to-parent = cast(GstObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstPad, $_);
      }
    }
    self.setGstObject($to-parent);
  }

  method GStreamer::Raw::Types::GstPad
    is also<GstPad>
  { $!p }

  multi method new (GstPad $pad) {
    self.bless( :$pad );
  }
  method new (Str() $name, Int() $direction) {
    self.bless( pad => gst_pad_new($name, $direction) );
  }

  method new_from_static_template (
    GstStaticPadTemplate() $splate,
    Str() $name
  )
    is also<new-from-static-template>
  {
    self.bless( pad => gst_pad_new_from_static_template($splate, $name) );
  }

  method new_from_template (GstPadTemplate() $plate, Str() $name)
    is also<new-from-template>
  {
    self.bless( pad => gst_pad_new_from_template($plate, $name) );
  }

  method element_private is rw is also<element-private> {
    Proxy.new(
      FETCH => sub ($) {
        gst_pad_get_element_private($!p);
      },
      STORE => sub ($, gpointer $priv is copy) {
        gst_pad_set_element_private($!p, $priv);
      }
    );
  }

  method offset is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_pad_get_offset($!p);
      },
      STORE => sub ($, $offset is copy) {
        gst_pad_set_offset($!p, $offset);
      }
    );
  }

  method activate_mode (GstPadMode() $mode, Int() $active)
    is also<activate-mode>
  {
    gst_pad_activate_mode($!p, $mode, $active);
  }

  method add_probe (
    Int() $mask,                   # GstPadProbeType $mask,
    GstPadProbeCallback $callback,
    gpointer $user_data          = gpointer,
    GDestroyNotify $destroy_data = gpointer
  )
    is also<add-probe>
  {
    gst_pad_add_probe($!p, $mask, $callback, $user_data, $destroy_data);
  }

  method can_link (GstPad() $sinkpad) is also<can-link> {
    gst_pad_can_link($!p, $sinkpad);
  }

  method chain (GstBuffer() $buffer) {
    GstFlowReturn( gst_pad_chain($!p, $buffer) );
  }

  method chain_list (GstBufferList() $list) is also<chain-list> {
    GstFlowReturn( gst_pad_chain_list($!p, $list) );
  }

  method check_reconfigure is also<check-reconfigure> {
    gst_pad_check_reconfigure($!p);
  }

  method event_default (GstObject() $parent, GstEvent() $event)
    is also<event-default>
  {
    so gst_pad_event_default($!p, $parent, $event);
  }

  method forward (
    GstPadForwardFunction $forward,
    gpointer $user_data = gpointer
  ) {
    so gst_pad_forward($!p, $forward, $user_data);
  }

  method get_allowed_caps (:$raw = False) is also<get-allowed-caps> {
    gst_pad_get_allowed_caps($!p);
    # ADD OBJECT CREATION CODE
  }

  method get_current_caps (:$raw = False) is also<get-current-caps> {
    gst_pad_get_current_caps($!p);
    # ADD OBJECT CREATION CODE
  }

  method get_direction is also<get-direction> {
    GstPadDirection( gst_pad_get_direction($!p) );
  }

  method get_last_flow_return is also<get-last-flow-return> {
    GstFlowReturn( gst_pad_get_last_flow_return($!p) );
  }

  method get_pad_template (:$raw = False) is also<get-pad-template> {
    gst_pad_get_pad_template($!p);
    # ADD OBJECT CREATION CODE
  }

  method get_pad_template_caps (:$raw = False) is also<get-pad-template-caps> {
    gst_pad_get_pad_template_caps($!p);
    # ADD OBJECT CREATION CODE
  }

  method get_peer  (:$raw = False) is also<get-peer> {
    my $p = gst_pad_get_peer($!p);

    $p ??
      ( $raw ?? $p !! GStreamer::Pad.new($p) )
      !!
      Nil;
  }

  method get_range (
    Int() $offset, # guint64 $offset,
    Int() $size,   # guint $size,
    GstBuffer() $buffer
  )
    is also<get-range>
  {
    gst_pad_get_range($!p, $offset, $size, $buffer);
  }

  method get_sticky_event (
    Int() $event_type, # GstEventType $event_type,
    Int() $idx         # guint $idx
  )
    is also<get-sticky-event>
  {
    gst_pad_get_sticky_event($!p, $event_type, $idx);
  }

  method get_task_state is also<get-task-state> {
    GstTaskState( gst_pad_get_task_state($!p) );
  }

  method get_type is also<get-type> {
    state ($n, $t)

    unstable_get_type( self.^name, &gst_pad_get_type, $n, $t );
  }

  method gst_flow_get_name is also<gst-flow-get-name> {
    gst_flow_get_name();
  }

  # ↓ MOVE TO GSTREAMER::RAW::TYPES
  method flow_to_quark is also<flow-to-quark> {
    gst_flow_to_quark();
  }
  # ↑ MOVE TO GSTREAMER::RAW::TYPES

  method has_current_caps is also<has-current-caps> {
    so gst_pad_has_current_caps($!p);
  }

  method is_active is also<is-active> {
    so gst_pad_is_active($!p);
  }

  method is_blocked is also<is-blocked> {
    so gst_pad_is_blocked($!p);
  }

  method is_blocking is also<is-blocking> {
    so gst_pad_is_blocking($!p);
  }

  method is_linked is also<is-linked> {
    so gst_pad_is_linked($!p);
  }

  method iterate_internal_links (:$raw = False)
    is also<iterate-internal-links>
  {
    my $i = gst_pad_iterate_internal_links($!p);

    $i ??
      ( $raw ?? $i !! GStreamer::Iterator.new($i) )
      !!
      Nil;
  }

  method iterate_internal_links_default (GstObject() $parent, :$raw = False)
    is also<iterate-internal-links-default>
  {
    my $i = gst_pad_iterate_internal_links_default($!p, $parent);

    $i ??
      ( $raw ?? $i !! GStreamer::Iterator.new($i) )
      !!
      Nil;
  }

  method link (GstPad() $sinkpad) {
    GstPadLinkReturn( gst_pad_link($!p, $sinkpad) );
  }

  method link_full (
    GstPad() $sinkpad,
    Int() $flags      # GstPadLinkCheck $flags
  )
    is also<link-full>
  {
    GstPadLinkReturn( gst_pad_link_full($!p, $sinkpad, $flags) );
  }

  method link_get_name is also<link-get-name> {
    gst_pad_link_get_name($!p);
  }

  method mark_reconfigure is also<mark-reconfigure> {
    gst_pad_mark_reconfigure($!p);
  }

  method mode_get_name is also<mode-get-name> {
    gst_pad_mode_get_name($!p);
  }

  method needs_reconfigure is also<needs-reconfigure> {
    so gst_pad_needs_reconfigure($!p);
  }

  method pause_task is also<pause-task> {
    so gst_pad_pause_task($!p);
  }

  method peer_query (GstQuery() $query) is also<peer-query> {
    so gst_pad_peer_query($!p, $query);
  }

  method probe_info_get_buffer (
    GStreamer::Pad:U:
    GstProbeInfo() $i,
    :$raw = False
  )
    is also<probe-info-get-buffer>
  {
    gst_pad_probe_info_get_buffer($i);
    # ADD OBJECT CREATION CODE for GStreamer::Buffer
  }

  method probe_info_get_buffer_list (
    GStreamer::Pad:U:
    GstProbeInfo() $i,
    :$raw = False
  )
    is also<probe-info-get-buffer-list>
  {
    gst_pad_probe_info_get_buffer_list($!p);
    # ADD OBJECT CREATION CODE for GStreamer::BufferList
  }

  method probe_info_get_event (
    GStreamer::Pad:U:
    GstProbeInfo() $i,
    :$raw = False
  )
    is also<probe-info-get-event>
  {
    gst_pad_probe_info_get_event($!p);
    # ADD OBJECT CREATION CODE for GStreamer::Event
  }

  method probe_info_get_query (
    GStreamer::Pad:U:
    GstProbeInfo() $i,
    :$raw = False
  )
    is also<probe-info-get-query>
  {
    gst_pad_probe_info_get_query($!p);
    # ADD OBJECT CREATION CODE for GStreamer::Query
  }

  method pull_range (
    Int() $offset,       # guint64 $offset,
    Int() $size,         # guint $size,
    GstBuffer() $buffer
  )
    is also<pull-range>
  {
    GstFlowReturn( gst_pad_pull_range($!p, $offset, $size, $buffer) );
  }

  method push (GstBuffer() $buffer) {
    GstFlowReturn( gst_pad_push($!p, $buffer) );
  }

  method push_event (GstEvent() $event) is also<push-event> {
    so gst_pad_push_event($!p, $event);
  }

  method push_list (GstBufferList() $list) is also<push-list> {
    GstFlowReturn( gst_pad_push_list($!p, $list) );
  }

  method query (GstQuery() $query) {
    so gst_pad_query($!p, $query);
  }

  method query_default (GstObject() $parent, GstQuery() $query)
    is also<query-default>
  {
    so gst_pad_query_default($!p, $parent, $query);
  }

  method remove_probe (
    Int() $id # uint64
  )
    is also<remove-probe>
  {
    gst_pad_remove_probe($!p, $id);
  }

  method send_event (GstEvent() $event) is also<send-event> {
    so gst_pad_send_event($!p, $event);
  }

  method set_activate_function_full (
    GstPadActivateFunction $activate,
    gpointer $user_data              = gpointer,
    GDestroyNotify $notify           = gpointer
  )
    is also<set-activate-function-full>
  {
    gst_pad_set_activate_function_full($!p, $activate, $user_data, $notify);
  }

  method set_activatemode_function_full (
    GstPadActivateModeFunction $activatemode,
    gpointer $user_data                      = gpointer,
    GDestroyNotify $notify                   = gpointer
  )
    is also<set-activatemode-function-full>
  {
    gst_pad_set_activatemode_function_full(
      $!p,
      $activatemode,
      $user_data,
      $notify
    );
  }

  method set_active (
    Int() $active # gboolean $active
  )
    is also<set-active>
  {
    so gst_pad_set_active($!p, $active);
  }

  method set_chain_function_full (
    GstPadChainFunction $chain,
    gpointer $user_data        = gpointer,
    GDestroyNotify $notify     = gpointer
  )
    is also<set-chain-function-full>
  {
    gst_pad_set_chain_function_full($!p, $chain, $user_data, $notify);
  }

  method set_chain_list_function_full (
    GstPadChainListFunction $chainlist,
    gpointer $user_data                = gpointer,
    GDestroyNotify $notify             = gpointer
  )
    is also<set-chain-list-function-full>
  {
    gst_pad_set_chain_list_function_full($!p, $chainlist, $user_data, $notify);
  }

  method set_event_full_function_full (
    GstPadEventFullFunction $event,
    gpointer $user_data            = gpointer,
    GDestroyNotify $notify         = gpointer
  )
    is also<set-event-full-function-full>
  {
    gst_pad_set_event_full_function_full($!p, $event, $user_data, $notify);
  }

  method set_event_function_full (
    GstPadEventFunction $event,
    gpointer $user_data        = gpointer,
    GDestroyNotify $notify     = gpointer
  )
    is also<set-event-function-full>
  {
    gst_pad_set_event_function_full($!p, $event, $user_data, $notify);
  }

  method set_getrange_function_full (
    GstPadGetRangeFunction $get,
    gpointer $user_data         = gpointer,
    GDestroyNotify $notify      = gpointer
  )
    is also<set-getrange-function-full>
  {
    gst_pad_set_getrange_function_full($!p, $get, $user_data, $notify);
  }

  method set_iterate_internal_links_function_full (
    GstPadIterIntLinkFunction $iterintlink,
    gpointer $user_data                    = gpointer,
    GDestroyNotify $notify                 = gpointer
  )
    is also<set-iterate-internal-links-function-full>
  {
    gst_pad_set_iterate_internal_links_function_full(
      $!p,
      $iterintlink,
      $user_data,
      $notify
    );
  }

  method set_link_function_full (
    GstPadLinkFunction $link,
    gpointer $user_data       = gpointer,
    GDestroyNotify $notify    = gpointer
  )
    is also<set-link-function-full>
  {
    gst_pad_set_link_function_full($!p, $link, $user_data, $notify);
  }

  method set_query_function_full (
    GstPadQueryFunction $query,
    gpointer $user_data        = gpointer,
    GDestroyNotify $notify     = gpointer
  )
    is also<set-query-function-full>
  {
    gst_pad_set_query_function_full($!p, $query, $user_data, $notify);
  }

  method set_unlink_function_full (
    GstPadUnlinkFunction $unlink,
    gpointer $user_data          = gpointer,
    GDestroyNotify $notify       = gpointer
  )
    is also<set-unlink-function-full>
  {
    gst_pad_set_unlink_function_full($!p, $unlink, $user_data, $notify);
  }

  method start_task (
    GstTaskFunction $func,
    gpointer $user_data    = gpointer,
    GDestroyNotify $notify = gpointer
  )
    is also<start-task>
  {
    so gst_pad_start_task($!p, $func, $user_data, $notify);
  }

  method sticky_events_foreach (
    GstPadStickyEventsForeachFunction $foreach_func,
    gpointer $user_data = gpointer
  )
    is also<sticky-events-foreach>
  {
    gst_pad_sticky_events_foreach($!p, $foreach_func, $user_data);
  }

  method stop_task is also<stop-task> {
    so gst_pad_stop_task($!p);
  }

  method store_sticky_event (GstEvent() $event) is also<store-sticky-event> {
    GstFlowReturn( gst_pad_store_sticky_event($!p, $event) );
  }

  method unlink (GstPad() $sinkpad) {
    so gst_pad_unlink($!p, $sinkpad);
  }

}
