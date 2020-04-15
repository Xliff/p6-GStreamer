use v6.c;

use NativeCall;
use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Element;
use GStreamer::Raw::Utils;

use GStreamer::Bus;
use GStreamer::Clock;
use GStreamer::Context;
use GStreamer::Iterator;
use GStreamer::Object;
use GStreamer::Pad;
use GStreamer::PadTemplate;

use GStreamer::Roles::Signals::Element;

our subset GstElementAncestry is export of Mu
  where GstElement | GstObject;

class GStreamer::Element is GStreamer::Object {
  also does GStreamer::Roles::Signals::Element;

  has GstElement $!e is implementor;

  submethod BUILD (:$element) {
    self.setElement($element) if $element.defined;
  }

  method setElement(GstElementAncestry $_) {
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

  method GStreamer::Raw::Structs::GstElement
    is also<GstElement>
  { $!e }

  method new (GstElementAncestry $element) {
    $element ?? self.bless( :$element ) !! Nil;
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
    my $c = gst_element_get_clock($!e);

    $c ??
      ( $raw ?? $c !! GStreamer::Clock.new($c) )
      !!
      Nil;
  }

  method get_context (Str() $context_type, :$raw = False)
    is also<get-context>
  {
    my $c = gst_element_get_context($!e, $context_type);

    $c ??
      ( $raw ?? $c !! GStreamer::Context.new($c) )
      !!
      Nil;
  }

  method get_context_unlocked (Str() $context_type, :$raw = False)
    is also<get-context-unlocked>
  {
    my $c = gst_element_get_context_unlocked($!e, $context_type);

    $c ??
      ( $raw ?? $c !! GStreamer::Context.new($c) )
      !!
      Nil;
  }

  method get_contexts (:$glist = False, :$raw = False)
    is also<
      get-contexts
      contexts
    >
  {
    my $cl = gst_element_get_contexts($!e);

    return Nil unless $cl;
    return $cl if $glist;

    $cl = GLib::GList.new($cl) but GLib::Roles::ListData[GstContext];
    $raw ?? $cl.Array !! $cl.Array.map({ GStreamer::Context.new($_) });
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

  method get_pad_template (Str() $name, :$raw = False)
    is also<get-pad-template>
  {
    my $p = gst_element_get_pad_template($!e, $name);

    $p ??
      ( $raw ?? $p !! GStreamer::PadTemplate.new($p) )
      !!
      Nil;
  }

  method get_pad_template_list (:$glist = False, :$raw = False)
    is also<get-pad-template-list>
  {
    my $tl = gst_element_get_pad_template_list($!e);

    return Nil unless $tl;
    return $tl if $glist;

    $tl = GLib::GList.new($tl) but GLib::Roles::ListData[GstPadTemplate];
    $raw ?? $tl.Array !! $tl.Array.map({ GStreamer::PadTemplate.new($_) });
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

  # cw: Check for rw prams. You know they are.
  method get_state (
    Int() $state,    # GstState $state,
    Int() $pending,  # GstState $pending,
    Int() $timeout   # GstClockTime $timeout
  )
    is also<get-state>
  {
    gst_element_get_state($!e, $state, $pending, $timeout);
  }

  method get_static_pad (Str() $name, :$raw = False) is also<get-static-pad> {
    my $sp = gst_element_get_static_pad($!e, $name);

    $sp ??
      ( $raw ?? $sp !! GStreamer::Pad.new($sp) )
      !!
      Nil;
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

  method make_from_uri (
    GStreamer::Element:U:
    Int() $type,
    Str() $uri,
    Str() $elementname,
    CArray[Pointer[GError]] $error = gerror,
    :$raw = False
  )
    is also<gst-element-make-from-uri>
  {
    my GstURIType $t = $type;

    clear_error;
    my $e = gst_element_make_from_uri($type, $uri, $elementname, $error);
    set_error($error);

    $e ??
      ( $raw ?? $e !! GStreamer::Element.new($e) )
      !!
      Nil;
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
    so gst_element_post_message($!e, $message);
  }

  method provide_clock (:$raw = False) is also<provide-clock> {
    my $c = gst_element_provide_clock($!e);

    $c ??
      ( $raw ?? $c !! GStreamer::Clock.new($c) )
      !!
      Nil;
  }

  method query (GstQuery() $query) {
    so gst_element_query($!e, $query);
  }

  method release_request_pad (GstPad() $pad) is also<release-request-pad> {
    gst_element_release_request_pad($!e, $pad);
  }

  method remove_pad (GstPad() $pad) is also<remove-pad> {
    so gst_element_remove_pad($!e, $pad);
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
    GstCaps() $caps,
    :$raw = False
  )
    is also<request-pad>
  {
    my $p = gst_element_request_pad($!e, $templ, $name, $caps);

    $p ??
      ( $raw ?? $p !! GStreamer::Pad.new($p) )
      !!
      Nil;
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
    so gst_element_seek(
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
    so gst_element_send_event($!e, $event);
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
    so gst_element_set_clock($!e, $clock);
  }

  method set_context (GstContext() $context) is also<set-context> {
    gst_element_set_context($!e, $context);
  }

  method set_locked_state (Int() $locked_state) is also<set-locked-state> {
    so gst_element_set_locked_state($!e, $locked_state);
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
    GstStateChangeReturnEnum( gst_element_set_state($!e, $state) );
  }

  method sync_state_with_parent is also<sync-state-with-parent> {
    so gst_element_sync_state_with_parent($!e);
  }

  # From gstutils.h

  method create_all_pads is also<create-all-pads> {
    gst_element_create_all_pads($!e);
  }

  method get_compatible_pad (GstPad() $pad, GstCaps() $caps, :$raw = False)
    is also<get-compatible-pad>
  {
    my $p = gst_element_get_compatible_pad($!e, $pad, $caps);

    $p ??
      ( $raw ?? $p !! GStreamer::Pad.new($p) )
      !!
      Nil;
  }

  method get_compatible_pad_template (GstPadTemplate() $template, :$raw = False)
    is also<get-compatible-pad-template>
  {
    my $pt = gst_element_get_compatible_pad_template($!e, $template);

    $pt ??
      ( $raw ?? $pt !! GStreamer::PadTemplate.new($pt) )
      !!
      Nil;
  }

  method link (GstElement() $dest) {
    so gst_element_link($!e, $dest);
  }

  method link_many (*@e) is also<link-many> {
    my $dieMsg = qq:to/DIE/.&nocr;
      Items passed to GStreamer::Element.link_many must be {''
      }GStreamer::Element compatible!
      DIE

    die $dieMsg unless @e.all ~~ (GStreamer::Element, GstElement).any;

    my $aok = True;
    for @e {
      $aok = False unless self.link($_);
    }
    $aok;
  }

  method link_filtered (GstElement() $dest, GstCaps() $filter)
    is also<link-filtered>
  {
    so gst_element_link_filtered($!e, $dest, $filter);
  }

  method link_pads (Str() $srcpadname, GstElement() $dest, Str() $destpadname)
    is also<link-pads>
  {
    so gst_element_link_pads($!e, $srcpadname, $dest, $destpadname);
  }

  method link_pads_filtered (
    Str() $srcpadname,
    GstElement() $dest,
    Str() $destpadname,
    GstCaps() $filter
  )
    is also<link-pads-filtered>
  {
    so gst_element_link_pads_filtered(
      $!e,
      $srcpadname,
      $dest,
      $destpadname,
      $filter
    );
  }

  method link_pads_full (
    Str() $srcpadname,
    GstElement() $dest,
    Str() $destpadname,
    Int() $flags
  )
    is also<link-pads-full>
  {
    my GstPadLinkCheck $f = $flags;

    gst_element_link_pads_full($!e, $srcpadname, $dest, $destpadname, $f);
  }

  proto method query_convert (|)
    is also<query-convert>
  { * }

  multi method query_convert (
    Int() $src_format,
    Int() $src_val,
    Int() $dest_format
  ) {
    my $rv = samewith($src_format, $src_val, $dest_format, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method query_convert (
    GstFormat $src_format,
    gint64 $src_val,
    GstFormat $dest_format,
    $dest_val is rw,
    :$all = False;
  ) {
    my GstFormat ($sf, $df) = ($src_format, $dest_format);
    my gint64 $dv = 0;
    my $rv = so gst_element_query_convert(
      $!e,
      $src_format,
      $src_val,
      $dest_format,
      $dv
    );

    $dest_val = $dv;
    $all.not ?? $rv !! ($rv, $dest_val);
  }

  proto method query_duration (|)
    is also<query-duration>
  { * }

  multi method query_duration (Int() $format) {
    my $rv = samewith($format, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method query_duration (Int() $format, $duration is rw, :$all = False) {
    my guint64 $d = 0;
    my $rv = so gst_element_query_duration($!e, $format, $d);

    $duration = $d;
    $all.not ?? $rv !! ($rv, $duration);
  }


  proto method query_position (|)
    is also<query-position>
  { * }

  multi method query_position (Int() $format) {
    my $rv = samewith($format, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method query_position (Int() $format, $cur is rw, :$all = False) {
    my GstFormat $f = $format;
    my guint64 $c = 0;
    my $rv = so gst_element_query_position($!e, $f, $c);

    $cur = $c;
    $all.not ?? $rv !! ($rv, $cur);
  }

  method seek_simple (
    Int() $format,
    Int() $seek_flags,
    Int() $seek_pos
  )
    is also<seek-simple>
  {
    my GstFormat $f = $format;
    my GstSeekFlags $sf = $seek_flags;
    my gint64 $sp = $seek_pos;

    so gst_element_seek_simple($!e, $f, $sf, $sp);
  }

  method state_change_return_get_name (
    GStreamer::Element:U:
    Int() $stateChangeReturn
  )
    is also<state-change-return-get-name>
  {
    gst_element_state_change_return_get_name($stateChangeReturn);
  }

  method state_get_name (GStreamer::Element:U: Int() $state)
    is also<state-get-name>
  {
    gst_element_state_get_name($state);
  }

  method unlink (GstElement() $dest) {
    gst_element_unlink($!e, $dest);
  }

  method unlink_pads (Str $srcpadname, GstElement() $dest, Str() $destpadname)
    is also<unlink-pads>
  {
    gst_element_unlink_pads($!e, $srcpadname, $dest, $destpadname);
  }

}
