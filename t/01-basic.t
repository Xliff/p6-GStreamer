use v6.c;

use GStreamer::Raw::Types;

use GStreamer::Bus;
use GStreamer::Element;
use GStreamer::Main;
use GStreamer::Parse;

sub MAIN {
  GStreamer::Main.init;

  my $pipeline = GStreamer::Parse.launch(
    "playbin uri=https://www.freedesktop.org/software/gstreamer-sdk/data/media/sintel_trailer-480p.webm",
  );

  $pipeline.set_state(GST_STATE_PLAYING);

  my $bus = $pipeline.bus;
  my $msg = $bus.timed-pop-filtered(
    GST_CLOCK_TIME_NONE,
    GST_MESSAGE_ERROR +| GST_MESSAGE_EOS
  );

  $pipeline.set_state(GST_STATE_NULL);
  $msg.unref if $msg.defined;
  .unref for $bus, $pipeline;
}
