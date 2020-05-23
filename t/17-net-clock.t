use v6.c;

use GStreamer::Raw::Types;

use GLib::MainLoop;
use GStreamer::Bus;
use GStreamer::Main;
use GStreamer::Message;
use GStreamer::Net::Clock;
use GStreamer::SystemClock;

sub handle-bus-message($b, $m, $c) {
  CATCH { default { .message.say } }

  die 'Received undefined message!' unless $m;
  # $m is a GstMessage, so object must be created!
  my $msg = GStreamer::Message.new($m);

  if $msg.type == GST_MESSAGE_ELEMENT {
    my $s = $msg.structure;
    return unless $s;

    say ~$s;
  }
  1;
}

multi sub MAIN ('client', $host, $port) {
  GStreamer::Main.init;

  unless ( my $c = GStreamer::Net::ClientClock.new($host, $port) ) {
    say 'Failed to create network clock client!';
    return 1;
  }

  my $bus = GStreamer::Bus.new;
  $bus.add-watch(-> *@a --> gboolean { handle-bus-message($bus, @a[1], $c) });
  $c.bus = $bus;

  (my $loop = GLib::MainLoop.new).run;
  .unref for $loop, $c;
}

multi sub MAIN ('server', Int $port) {
  GStreamer::Main.init;

  my $c  = GStreamer::SystemClock.obtain;
  my $nc = GStreamer::Net::TimeProvider.new($c, $port);

  say "Published network clock on port { $nc.port }";

  (my $loop = GLib::MainLoop.new).run;
  $loop.unref;
}
