use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Bus;

use GLib::Source;
use GStreamer::Object;

use GStreamer::Roles::Signals::Bus;

our subset BusAncestry is export of Mu
  where GstBus | GstObject;

class GStreamer::Bus is GStreamer::Object {
  also does GStreamer::Roles::Signals::Bus;

  has GstBus $!b;

  submethod BUILD (:$bus) {
    self.setBus($bus);
  }

  method setBus(BusAncestry $_) {
    my $to-parent;

    $!b = do {
      when GstBus {
        $to-parent = cast(GstObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstBus, $_);
      }
    }
    self.setGstObject($to-parent);
  }

  method GStreamer::Raw::Types::GstBus
    is also<GstBus>
  { $!b }

  multi method new (GstBus $bus) {
    $bus ?? self.bless( :$bus ) !! Nil;
  }
  multi method new {
    my $bus = gst_bus_new();

    $bus ?? self.bless( :$bus ) !! Nil;
  }

  # Type: gboolean
  method enable-async is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('enable-async', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_BOOLEAN );
        $gv.boolean = $val;
        self.prop_set('enable-async', $gv);
      }
    );
  }

  # Is originally:
  # GstBus, GstMessage, gpointer
  method message {
    self.connect-message($!b);
  }

  # Is originally:
  # GstBus, GstMessage, gpointer
  method sync-message {
    self.connect-message($!b, 'sync-message');
  }

  method add_signal_watch is also<add-signal-watch> {
    gst_bus_add_signal_watch($!b);
  }

  method add_signal_watch_full (Int() $priority)
    is also<add-signal-watch-full>
  {
    gst_bus_add_signal_watch_full($!b, $priority);
  }

  method add_watch (
    &func,
    gpointer $user_data = gpointer
  )
    is also<add-watch>
  {
    gst_bus_add_watch($!b, &func, $user_data);
  }

  method add_watch_full (
    Int() $priority,
    &func,
    gpointer $user_data    = gpointer,
    GDestroyNotify $notify = gpointer
  )
    is also<add-watch-full>
  {
    gst_bus_add_watch_full($!b, $priority, &func, $user_data, $notify);
  }

  method async_signal_func (
    GstMessage() $message,
    gpointer $data
  )
    is also<async-signal-func>
  {
    so gst_bus_async_signal_func($!b, $message, $data);
  }

  method create_watch (:$raw = False) is also<create-watch> {
    my $s = gst_bus_create_watch($!b);

    $s ??
      ( $raw ?? $s !! GLib::Source.new($s) )
      !!
      Nil;
  }

  method disable_sync_message_emission is also<disable-sync-message-emission> {
    gst_bus_disable_sync_message_emission($!b);
  }

  method enable_sync_message_emission is also<enable-sync-message-emission> {
    gst_bus_enable_sync_message_emission($!b);
  }

  proto method get_pollfd (|)
    is also<get-pollfd>
  { * }

  multi method get_pollfd {
    samewith(GPollFD.new);
  }
  multi method get_pollfd (GPollFD() $fd) {
    gst_bus_get_pollfd($!b, $fd);
    $fd;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_bus_get_type, $n, $t );
  }

  method have_pending is also<have-pending> {
    so gst_bus_have_pending($!b);
  }

  method peek (:$raw = False) {
    my $m = gst_bus_peek($!b);
    my $lb = 'GStreamer::Message';

    (my $msg-late-bound = ::("$lb")).so;
    if $msg-late-bound ~~ Failure {
      require ::($ = $lb);
      $msg-late-bound = ::($ = $lb);
    }

    die 'GStreamer::Message was not found! Please add its use statement in the calling script!'
      if $msg-late-bound ~~ Failure;

    $m ??
      ( $raw ?? $m !! $msg-late-bound.new($m) )
      !!
      Nil;
  }

  method poll (
    Int() $events,   # GstMessageType $events,
    Int() $timeout,
    :$raw = False
  ) {
    my $m = gst_bus_poll($!b, $events, $timeout);
    my $lb = 'GStreamer::Message';

    (my $msg-late-bound = ::("$lb")).so;
    if $msg-late-bound ~~ Failure {
      require ::($ = $lb);
      $msg-late-bound = ::($ = $lb);
    }
    die 'GStreamer::Message was not found! Please add its use statement in the calling script!'
      if $msg-late-bound ~~ Failure;

    $m ??
      ( $raw ?? $m !! $msg-late-bound.new($m) )
      !!
      Nil;
  }

  method pop (:$raw = False) {
    my $m = gst_bus_pop($!b);
    my $lb = 'GStreamer::Message';

    (my $msg-late-bound = ::("$lb")).so;
    if $msg-late-bound ~~ Failure {
      require ::($ = $lb);
      $msg-late-bound = ::($ = $lb);
    }
    die 'GStreamer::Message was not found! Please add its use statement in the calling script!'
      if $msg-late-bound ~~ Failure;

    $m ??
      ( $raw ?? $m !! $msg-late-bound.new($m) )
      !!
      Nil;
  }

  method pop_filtered (
    Int() $types,    # GstMessageType $types,
    :$raw = False
  )
    is also<pop-filtered>
  {
    my guint $t = $types;
    my $m = gst_bus_pop_filtered($!b, $t);
    my $lb = 'GStreamer::Message';

    (my $msg-late-bound = ::("$lb")).so;
    if $msg-late-bound ~~ Failure {
      require ::($ = $lb);
      $msg-late-bound = ::($ = $lb);
    }
    die 'GStreamer::Message was not found! Please add its use statement in the calling script!'
      if $msg-late-bound ~~ Failure;

    $m ??
      ( $raw ?? $m !! $msg-late-bound.new($m) )
      !!
      Nil;
  }

  method post (GstMessage() $message) {
    so gst_bus_post($!b, $message);
  }

  method remove_signal_watch is also<remove-signal-watch> {
    gst_bus_remove_signal_watch($!b);
  }

  method remove_watch is also<remove-watch> {
    gst_bus_remove_watch($!b);
  }

  method set_flushing (gboolean $flushing) is also<set-flushing> {
    gst_bus_set_flushing($!b, $flushing);
  }

  method set_sync_handler (
    GstBusSyncHandler $func,
    gpointer $user_data    = gpointer,
    GDestroyNotify $notify = gpointer
  )
    is also<set-sync-handler>
  {
    gst_bus_set_sync_handler($!b, $func, $user_data, $notify);
  }

  method sync_signal_handler (
    GstMessage() $message,
    gpointer $data = gpointer
  )
    is also<sync-signal-handler>
  {
    gst_bus_sync_signal_handler($!b, $message, $data);
  }

  method timed_pop (
    Int() $timeout, # GstClockTime $timeout,
    :$raw = False
  )
    is also<timed-pop>
  {
    my uint64 $to = $timeout;
    my $m = gst_bus_timed_pop($!b, $timeout);
    my $lb = 'GStreamer::Message';

    (my $msg-late-bound = ::("$lb")).so;
    if $msg-late-bound ~~ Failure {
      require ::($ = $lb);
      $msg-late-bound = ::($ = $lb);
    }
    die 'GStreamer::Message was not found! Please add its use statement in the calling script!'
      if $msg-late-bound ~~ Failure;

    $m ??
      ( $raw ?? $m !! $msg-late-bound.new($m) )
      !!
      Nil;
  }

  method timed_pop_filtered (
    Int() $timeout,  # GstClockTime $timeout,
    Int() $types,    # GstMessageType $types,
    :$raw = False
  )
    is also<timed-pop-filtered>
  {
    my uint64 $to = $timeout;
    my guint $t = $types;
    my $m = gst_bus_timed_pop_filtered($!b, $to, $t);
    my $lb = 'GStreamer::Message';

    (my $msg-late-bound = ::("$lb")).so;
    if $msg-late-bound ~~ Failure {
      require ::($ = $lb);
      $msg-late-bound = ::($ = $lb);
    }
    die 'GStreamer::Message was not found! Please add its use statement in the calling script!'
      if $msg-late-bound ~~ Failure;

    $m ??
      ( $raw ?? $m !! $msg-late-bound.new($m) )
      !!
      Nil;
  }

}
