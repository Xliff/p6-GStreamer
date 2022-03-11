use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Pad;
use GStreamer::Raw::Utils;

use GStreamer::Caps;
use GStreamer::Object;
use GStreamer::Iterator;

our subset GstPadAncestry is export of Mu
  where GstPad | GstObject;

class GStreamer::Pad is GStreamer::Object {
  has GstPad $!p handles <padtemplate>;

  submethod BUILD (:$pad) {
    self.setPad($pad);
  }

  method setPad (GstPadAncestry $_) {
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

  method GStreamer::Raw::Structs::GstPad
    is also<GstPad>
  { $!p }

  multi method new (GstPad $pad) {
    $pad ?? self.bless( :$pad ) !! Nil
  }
  multi method new (Str() $name, Int() $direction) {
    my GstPadDirection $d = $direction;
    my $pad = gst_pad_new($name, $d);

    $pad ?? self.bless( :$pad ) !! Nil
  }

  method new_from_static_template (
    GstStaticPadTemplate() $splate,
    Str() $name
  )
    is also<new-from-static-template>
  {
    my $pad = gst_pad_new_from_static_template($splate, $name);

    $pad ?? self.bless( :$pad ) !! Nil
  }

  method new_from_template (GstPadTemplate() $plate, Str() $name)
    is also<new-from-template>
  {
    my $pad = gst_pad_new_from_template($plate, $name);

    $pad ?? self.bless( :$pad ) !! Nil
  }

  method element_private is rw is also<element-private> {
    Proxy.new(
      FETCH => sub ($) {
        gst_pad_get_element_private($!p);
      },
      STORE => sub ($, $priv is copy) {
        my gpointer $ptr = do given $priv {
          when gpointer       { $_ }
          when GStreamer::Pad { .GstPad.p }
          when GstPad         { .p }

          default {
            die 'Invalid value passed to element_private!'
          }
        }
        gst_pad_set_element_private($!p, $ptr);
      }
    );
  }

  method offset is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_pad_get_offset($!p);
      },
      STORE => sub ($, Int() $offset is copy) {
        my gint64 $o = $offset;

        gst_pad_set_offset($!p, $o);
      }
    );
  }

  method activate_mode (GstPadMode() $mode, Int() $active)
    is also<activate-mode>
  {
    so gst_pad_activate_mode($!p, $mode, $active);
  }

  method add_probe (
    Int() $mask,
    GstPadProbeCallback $callback,
    gpointer $user_data          = gpointer,
    GDestroyNotify $destroy_data = gpointer
  )
    is also<add-probe>
  {
    my GstPadProbeType $m = $mask;

    gst_pad_add_probe($!p, $m, $callback, $user_data, $destroy_data);
  }

  method can_link (GstPad() $sinkpad) is also<can-link> {
    so gst_pad_can_link($!p, $sinkpad);
  }

  method chain (GstBuffer() $buffer) {
    GstFlowReturnEnum( gst_pad_chain($!p, $buffer) );
  }

  method chain_list (GstBufferList() $list) is also<chain-list> {
    GstFlowReturnEnum( gst_pad_chain_list($!p, $list) );
  }

  method check_reconfigure is also<check-reconfigure> {
    so gst_pad_check_reconfigure($!p);
  }

  method create_stream_id (
    GstElement() $parent,
    Str() $stream_id
  )
    is also<create-stream-id>
  {
    gst_pad_create_stream_id($!p, $parent, $stream_id);
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

  method get_allowed_caps (:$raw = False)
    is also<
      get-allowed-caps
      allowed_caps
      allowed-caps
    >
  {
    my $c = gst_pad_get_allowed_caps($!p);

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

  method get_current_caps (:$raw = False)
    is also<
      get-current-caps
      current_caps
      current-caps
    >
  {
    my $c = gst_pad_get_current_caps($!p);

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

  method get_direction
    is also<
      get-direction
      direction
    >
  {
    GstPadDirectionEnum( gst_pad_get_direction($!p) );
  }

  method get_last_flow_return
    is also<
      get-last-flow-return
      last_flow_return
      last-flow-return
    >
  {
    GstFlowReturnEnum( gst_pad_get_last_flow_return($!p) );
  }

  method get_pad_template (:$raw = False)
    is also<
      get-pad-template
      pad_template
      pad-template
    >
  {
    my $pt = gst_pad_get_pad_template($!p);

    $pt ??
      ( $raw ?? $pt !! ::('GStreamer::PadTemplate').new($pt) )
      !!
      Nil;
  }

  method get_pad_template_caps (:$raw = False)
    is also<
      get-pad-template-caps
      pad_template_caps
      pad-template-caps
    >
  {
    my $c = gst_pad_get_pad_template_caps($!p);

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

  method get_parent (:$raw = False)
    is also<
      get-parent
      parent
    >
  {
    my $pe = gst_pad_get_parent_element($!p);

    $pe ??
      ( $raw ?? $pe !! ::('GStreamer::Element').new($pe) )
      !!
      Nil;
  }

  method get_peer (:$raw = False)
    is also<
      get-peer
      peer
    >
  {
    my $p = gst_pad_get_peer($!p);

    $p ??
      ( $raw ?? $p !! GStreamer::Pad.new($p) )
      !!
      Nil;
  }

  method get_range (
    Int() $offset,
    Int() $size,
    GstBuffer() $buffer
  )
    is also<get-range>
  {
    my guint64 $o = $offset;
    my guint $s = $size;

    gst_pad_get_range($!p, $o, $s, $buffer);
  }

  method get_sticky_event (
    Int() $event_type,
    Int() $idx
  )
    is also<get-sticky-event>
  {
    my GstEventType $et = $event_type;
    my guint $i = $idx;

    gst_pad_get_sticky_event($!p, $et, $i);
  }

  method get_task_state
    is also<
      get-task-state
      task_state
      task-state
    >
  {
    GstTaskStateEnum( gst_pad_get_task_state($!p) );
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_pad_get_type, $n, $t );
  }


  # ↓ MOVE TO GSTREAMER::RAW::TYPES
  # method gst_flow_get_name is also<gst-flow-get-name> {
  #   gst_flow_get_name();
  # }
  # method flow_to_quark is also<flow-to-quark> {
  #   gst_flow_to_quark();
  # }
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
    GstPadLinkReturnEnum( gst_pad_link($!p, $sinkpad) );
  }

  method link_full (
    GstPad() $sinkpad,
    Int() $flags
  )
    is also<link-full>
  {
    my GstPadLinkCheck $f = $flags;

    GstPadLinkReturnEnum( gst_pad_link_full($!p, $sinkpad, $f) );
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

  # GStreamer::PadProbeInfo
  # method probe_info_get_buffer (
  #   GStreamer::Pad:U:
  #   GstProbeInfo() $i,
  #   :$raw = False
  # )
  #   is also<probe-info-get-buffer>
  # {
  #   gst_pad_probe_info_get_buffer($i);
  #   # ADD OBJECT CREATION CODE for GStreamer::Buffer
  # }
  #
  # method probe_info_get_buffer_list (
  #   GStreamer::Pad:U:
  #   GstProbeInfo() $i,
  #   :$raw = False
  # )
  #   is also<probe-info-get-buffer-list>
  # {
  #   gst_pad_probe_info_get_buffer_list($!p);
  #   # ADD OBJECT CREATION CODE for GStreamer::BufferList
  # }
  #
  # method probe_info_get_event (
  #   GStreamer::Pad:U:
  #   GstProbeInfo() $i,
  #   :$raw = False
  # )
  #   is also<probe-info-get-event>
  # {
  #   gst_pad_probe_info_get_event($!p);
  #   # ADD OBJECT CREATION CODE for GStreamer::Event
  # }
  #
  # method probe_info_get_query (
  #   GStreamer::Pad:U:
  #   GstProbeInfo() $i,
  #   :$raw = False
  # )
  #   is also<probe-info-get-query>
  # {
  #   gst_pad_probe_info_get_query($!p);
  #   # ADD OBJECT CREATION CODE for GStreamer::Query
  # }

  method pull_range (
    Int() $offset,
    Int() $size,
    GstBuffer() $buffer
  )
    is also<pull-range>
  {
    my guint64 $o = $offset;
    my guint $s = $size;

    GstFlowReturnEnum( gst_pad_pull_range($!p, $o, $s, $buffer) );
  }

  method push (GstBuffer() $buffer) {
    GstFlowReturnEnum( gst_pad_push($!p, $buffer) );
  }

  method push_event (GstEvent() $event) is also<push-event> {
    so gst_pad_push_event($!p, $event);
  }

  method push_list (GstBufferList() $list) is also<push-list> {
    GstFlowReturnEnum( gst_pad_push_list($!p, $list) );
  }

  method query (GstQuery() $query) {
    so gst_pad_query($!p, $query);
  }

  method query_default (GstObject() $parent, GstQuery() $query)
    is also<query-default>
  {
    so gst_pad_query_default($!p, $parent, $query);
  }

  proto method query_caps (|)
    is also<query-caps>
  { * }

  multi method query_caps {
    samewith(GstCaps);
  }
  multi method query_caps (GstCaps() $filter, :$raw = False) {
    my $c = gst_pad_query_caps($!p, $filter);

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

  method remove_probe (
    Int() $id
  )
    is also<remove-probe>
  {
    my guint64 $i = $id;

    gst_pad_remove_probe($!p, $i);
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
    Int() $active
  )
    is also<set-active>
  {
    my gboolean $a = $active.so.Int;

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
    GstFlowReturnEnum( gst_pad_store_sticky_event($!p, $event) );
  }

  method unlink (GstPad() $sinkpad) {
    so gst_pad_unlink($!p, $sinkpad);
  }

  # From GStreamer::Raw::gst_util_seqnum_next

  proto method query_convert(|)
    is also<query-convert>
  { * }

  multi method query_convert (
    Int() $src_format,
    Int() $src_val,
    Int() $dest_format,
  ) {
    my $rv =  callwith($src_format, $src_val, $dest_format, $, :all);
    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method query_convert (
    Int() $src_format,
    Int() $src_val,
    Int() $dest_format,
    $dest_val is rw,
    :$all = False
  ) {
    my GstFormat ($sf, $df) = ($src_format, $dest_format);
    my gint64 ($sv, $dv) = ($src_val, 0);

    my $rv = gst_pad_query_convert($!p, $sf, $sv, $df, $dv);
    $dest_val = $rv ?? $dv !! Nil;
    $all.not ?? $dest_val !! ($rv, $dest_val);
  }

  proto method query_duration (|)
    is also<query-duration>
  { * }

  multi method query_duration (Int() $format) {
    my $rv = callwith($format, $, :all);
    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method query_duration (
    Int() $format,
    $duration is rw,
    :$all = False
  ) {
    my GstFormat $f = $format;
    my guint64 $d = 0;
    my $rv = gst_pad_query_duration($!p, $f, $d);

    $duration = $rv  ?? $d !! Nil;
    $all.not ?? $duration !! ($rv, $duration);
  }

  proto method query_position (|)
    is also<query-position>
  { * }

  multi method query_position (Int() $format) {
    my $rv = callwith($format, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method query_position (
    Int() $format,
    $position is rw,
    :$all = False
  ) {
    my GstFormat $f = $format;
    my gint64 $c = 0;
    my $rv = gst_pad_query_position ($!p, $f, $c);

    $position = $rv ?? $c !! Nil;
    $all.not ?? $position !! ($rv, $position);
  }

}
