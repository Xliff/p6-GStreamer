use v6.c;

use GStreamer::Raw::Types;

use GStreamer::Element;
use GStreamer::ElementFactory;
use GStreamer::Main;
use GStreamer::Pipeline;
use GStreamer::Controller::DirectControlBinding;
use GStreamer::Controller::ARGBControlBinding;
use GStreamer::Controller::LFOControlSource;
use GStreamer::Plugins::VideoTestSrc;
use GStreamer::Plugins::Pango::TextOverlay;

constant DCB  = GStreamer::Controller::DirectControlBinding;
constant ARGB = GStreamer::Controller::ARGBControlBinding;

sub MAIN (
  :$pattern = 3,                  #= Background video pattern
  :$message = 'GStreamer rocks!'  #= Text message to display
) {
  GStreamer::Main.init;

  my $bin   = GStreamer::Pipeline.new('pipeline');
  my $clock = $bin.clock;
  unless (my $src   = GStreamer::ElementFactory.make('videotestsrc') ) {
    say 'Need videotestsrc from gst-plugins-base';
    exit 1;
  }
  unless (my $text  = GStreamer::ElementFactory.make('textoverlay')  ) {
    say 'Need textoverlay from gst-plugins-base';
    exit 1;
  }
  unless (my $sink  = GStreamer::ElementFactory.make('xvimagesink')  ) {
    say 'Need ximagesink from gst-plugins-base';
    exit 1;
  }

  $src  = GStreamer::Plugins::VideoTestSrc.new($src.GstElement);
  $text = GStreamer::Plugins::Pango::TextOverlay.new($text.GstElement);

  $src.pattern = $pattern;
  (.text, .font-desc, .halignment, .valignment) =
    ($message, 'Sans 30', 4, 3) given $text;

  $bin.add-many($src, $text, $sink);
  unless $src.link-many($text, $sink) {
    say "Can't link elements!";
    exit 1;
  }

  given GStreamer::Controller::LFOControlSource.new {
    (.frequency, .amplitude, .offset) = (0.11, 0.2, 0.5);
    $text.add-control-binding( DCB.new($text, 'xpos', $_) );
    .unref;
  }

  given GStreamer::Controller::LFOControlSource.new {
    (.frequency, .amplitude, .offset) = (0.04, 0.4, 0.5);
    $text.add-control-binding( DCB.new($text, 'xpos', $_) );
    .unref;
  }

  (.frequency, .amplitude, .offset) = (0.19, 0.5, 0.5)
    given (my $cs-r = GStreamer::Controller::LFOControlSource.new);
  (.frequency, .amplitude, .offset) = (0.27, 0.5, 0.5)
    given (my $cs-g = GStreamer::Controller::LFOControlSource.new);
  (.frequency, .amplitude, .offset) = (0.13, 0.5, 0.5)
    given (my $cs-b = GStreamer::Controller::LFOControlSource.new);
  $text.add-control-binding( ARGB.new($text, 'color', $cs-r, $cs-g, $cs-b) );
  .unref for $cs-r, $cs-g, $cs-b;

  my $cid = $clock.create-single-shot-id(30sec, :relative);
  if $bin.play {
    my @w = $cid.wait;
    say "Clock::id_wait returned: { @w[0] }" if @w[0] != GST_CLOCK_OK;
    $bin.stop;
  }

  LEAVE {
    .unref if $_ for $cid, $clock, $bin;
  }
}
