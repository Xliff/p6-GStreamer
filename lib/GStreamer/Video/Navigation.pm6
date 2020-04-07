use v6.c;

use NativeCall;
use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Video::Navigation;

use GStreamer::Message;
use GStreamer::Query;

use GLib::Roles::StaticClass;

class GStreamer::Video::Navigation::Event {
  also does GLib::Roles::StaticClass;

  method get_type (GstEvent() $e) is also<get-type> {
    GstNavigationEventTypeEnum( gst_navigation_event_get_type($e) );
  }

  proto method parse_command (|)
      is also<parse-command>
  { * }

  multi method parse_command (GstEvent() $event) {
    my $rv = samewith($event, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method parse_command (
    GstEvent() $event,
    $command is rw,
    :$all = False
  ) {
    my GstNavigationCommand $c = 0;

    my $rv = gst_navigation_event_parse_command($event, $c);
    $command = $c;
    $all.not ?? $rv !! ($rv, $command);
  }

  proto method parse_key_event (|)
      is also<parse-key-event>
  { * }

  multi method parse_key_event (GstEvent() $event) {
    my $rv = samewith($event, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method parse_key_event (
    GstEvent() $event,
    $key is rw,
    :$all = False
  ) {
    my $k = CArray[Str].new;
    $k[0] = Str;

    my $rv = gst_navigation_event_parse_key_event($event, $k);
    $key = CStringArrayToArray( ppr($k) );
    $all.not ?? $rv !! ($rv, $key);
  }

  proto method parse_mouse_button_event (|)
      is also<parse-mouse-button-event>
  { * }

  multi method parse_mouse_button_event (GstEvent() $event) {
    my $rv = samewith($event, $, $, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method parse_mouse_button_event (
    GstEvent() $event,
    $button is rw,
    $x      is rw,
    $y      is rw,
    :$all = False
  ) {
    my gint $b = 0;
    my gdouble ($xx, $yy) = 0 xx 2;
    my &epmbe := &gst_navigation_event_parse_mouse_button_event;
    my $rv = &epmbe($event, $b, $xx, $yy);

    ($button, $x, $y) = ($b, $xx, $yy);
    $all.not ?? $rv !! ($rv, $button, $x, $y);
  }

  proto method parse_mouse_move_event (|)
      is also<parse-mouse-move-event>
  { * }

  multi method parse_mouse_move_event (GstEvent() $event) {
    my $rv = samewith($event, $, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method parse_mouse_move_event (
    GstEvent() $event,
    $x is rw,
    $y is rw,
    :$all = False
  ) {
    my gdouble ($xx, $yy) = ($x, $y);
    my $rv = gst_navigation_event_parse_mouse_move_event($event, $xx, $yy);

    ($x, $y) = ($xx, $yy);
    $all.not ?? $rv !! ($rv, $x, $y);
  }
}

class GStreamer::Video::Navigation::Message {
  also does GLib::Roles::StaticClass;

  method new_angles_changed (
    GstObject() $src,
    Int() $cur_angle,
    Int() $n_angles,
    :$raw = False
  )
    is also<new-angles-changed>
  {
    my gint ($ca, $na) = ($cur_angle, $n_angles);

    my $m = gst_navigation_message_new_angles_changed($src, $ca, $na);

    $m ??
      ( $raw ?? $m !! GStreamer::Message.new($m) )
      !!
      GstMessage;
  }

  method new_commands_changed (GstObject() $src, :$raw = False)
    is also<new-commands-changed>
  {
    my $m = gst_navigation_message_new_commands_changed($src);

    $m ??
      ( $raw ?? $m !! GStreamer::Message.new($m) )
      !!
      GstMessage;
  }

  method new_event (GstObject() $src, GstEvent() $event, :$raw = False)
    is also<new-event>
  {
    my $m = gst_navigation_message_new_event($src, $event);

    $m ??
      ( $raw ?? $m !! GStreamer::Message.new($m) )
      !!
      GstMessage;
  }

  method new_mouse_over (GstObject() $src, Int() $active, :$raw = False)
    is also<new-mouse-over>
  {
    my gboolean $a = $active.so.Int;
    my $m = gst_navigation_message_new_mouse_over($src, $a);

    $m ??
      ( $raw ?? $m !! GStreamer::Message.new($m) )
      !!
      GstMessage;
  }

  method get_type (GstMessage() $m) is also<get-type> {
    GstNavigationMessageTypeEnum( gst_navigation_message_get_type($m) );
  }

  proto method parse_angles_changed (|)
      is also<parse-angles-changed>
  { * }

  multi method parse_angles_changed (GstMessage() $message) {
    my $rv = samewith($message, $, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method parse_angles_changed (
    GstMessage() $message,
    $cur_angle is rw,
    $n_angles  is rw,
    :$all = False
  ) {
    my guint ($ca, $na) = 0 xx 2;

    my $rv = gst_navigation_message_parse_angles_changed($message, $ca, $na);
    ($cur_angle, $n_angles) = ($ca, $na);
    $all.not ?? $rv !! ($rv, $cur_angle, $n_angles);
  }

  proto method parse_event (|)
      is also<parse-event>
  { * }

  multi method parse_event (GstMessage() $message) {
    my $rv = samewith($message, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method parse_event (
    GstMessage() $message,
    $event is rw,
    :$all = False,
    :$raw = False
  ) {
    my $e = CArray[Pointer[GstEvent]].new;
    $e[0] = Pointer[GstEvent];

    my $rv = gst_navigation_message_parse_event($message, $e);
    $event = ppr($e);
    $event = GStreamer::Event.new($event) if $event && $raw.not;
    $all.not ?? $rv !! ($rv, $event)
  }

  proto method parse_mouse_over (|)
      is also<parse-mouse-over>
  { * }

  multi method parse_mouse_over (GstMessage() $message) {
    my $rv = samewith($message, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method parse_mouse_over (
    GstMessage() $message,
    $active is rw,
    :$all = False
  ) {
    my gboolean $a = 0;

    my $rv = gst_navigation_message_parse_mouse_over($message, $a);
    $active = $a;
    $all.not ?? $rv !! ($rv, $active);
  }
}

class GStreamer::Video::Navigation::Query {
  also does GLib::Roles::StaticClass;

  method new_angles (:$raw = False) is also<new-angles> {
    my $q = gst_navigation_query_new_angles();

    $q ??
      ( $raw ?? $q !! GStreamer::Query.new($q) )
      !!
      GstQuery;
  }

  method new_commands (:$raw = False) is also<new-commands> {
    my $q = gst_navigation_query_new_commands();

    $q ??
      ( $raw ?? $q !! GStreamer::Query.new($q) )
      !!
      GstQuery;
  }

  method get_type (GstQuery() $q) is also<get-type> {
    GstNavigationQueryTypeEnum( gst_navigation_query_get_type($q) );
  }

  proto method parse_angles (|)
      is also<parse-angles>
  { * }

  multi method parse_angles (GstQuery() $query) {
    my $rv = samewith($query, $, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method parse_angles (
    GstQuery() $query,
    $cur_angle is rw,
    $n_angles  is rw,
    :$all = False
  ) {
    my guint ($ca, $na) = 0 xx 2;

    my $rv = gst_navigation_query_parse_angles($query, $ca, $na);
    ($cur_angle, $n_angles) = ($ca, $na);
    $all.not ?? $rv !! ($rv, $cur_angle, $n_angles);
  }

  proto method parse_commands_length (|)
      is also<parse-commands-length>
  { * }

  multi method parse_commands_length (GstQuery() $query) {
    my $rv = samewith($query, $, :all);
  }
  multi method parse_commands_length (
    GstQuery() $query,
    $n_cmds is rw,
    :$all = False
  ) {
    my guint $n = $n_cmds = 0;

    my $rv = gst_navigation_query_parse_commands_length($query, $n);
    $n_cmds = $n;
    $all.not ?? $rv !! ($rv, $n_cmds);
  }

  proto method parse_commands_nth (|)
    is also<parse-commands-nth> { * }

  multi method parse_commands_nth (GstQuery() $query) {
    my $rv = samewith($query, $, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method parse_commands_nth (
    GstQuery() $query,
    $nth is rw,
    $cmd is rw,
    :$all = False
  ) {
    my guint $n = 0;
    my GstNavigationCommand $c = 0;

    my $rv = gst_navigation_query_parse_commands_nth($query, $n, $c);
    ($nth, $cmd) = ($n, $c);
    $all.not ?? $rv !! ($rv, $nth, $cmd);
  }

  method set_angles (GstQuery() $query, Int() $cur_angle, Int() $n_angles)
    is also<set-angles>
  {
    my guint ($ca, $na) = ($cur_angle, $n_angles);

    gst_navigation_query_set_angles($query, $ca, $na);
  }

  method set_commands (GstQuery() $query, @cmds) is also<set-commands> {
    self.set_commandsv($query, @cmds);
  }

  proto method set_commandsv (|)
      is also<set-commandsv>
  { * }

  multi method set_commandsv (GstQuery() $query, @cmds) {
    samewith(
      $query,
      @cmds.elems,
      ArrayToCArray(GstNavigationCommand, @cmds)
    );
  }
  multi method set_commandsv (
    GstQuery() $query,
    Int() $n_cmds,
    CArray[GstNavigationCommand] $cmds
  ) {
    my gint $n = $n_cmds;

    gst_navigation_query_set_commandsv($query, $n, $cmds);
  }
}
