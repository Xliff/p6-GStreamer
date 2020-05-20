use v6.c;

use GStreamer::Raw::Types;

use GStreamer::Element;
use GStreamer::ElementFactory;
use GStreamer::Main;
use GStreamer::Pipeline;

use GStreamer::Controller::InterpolationControlSource;
use GStreamer::Controller::DirectControlBinding;

constant ICS = GStreamer::Controller::InterpolationControlSource;
constant DCB = GStreamer::Controller::DirectControlBinding;

sub MAIN {
  GStreamer::Main.init;

  my $pipeline = GStreamer::Pipeline.new('pipeline');

  my $clock    = $pipeline.clock;
  my $src      = GStreamer::ElementFactory.make('audiotestsrc');
  my $sink     = GStreamer::ElementFactory.make('autoaudiosink');

  if ($src, $sink).grep( *.defined.not ) {
    say 'Required elements could not be created!';
    exit 1;
  }
  $pipeline.add-many($src, $sink);

  unless $src [+] $sink {
    say 'Required elements could not be linked!';
    exit 1;
  }

  my @cs = ICS.new xx 2;
  $src.add_control_binding( DCB.new( $src, 'volume', @cs[0] ) );
  $src.add_control_binding( DCB.new( $src,   'freq', @cs[1] ) );

  .mode = GST_INTERPOLATION_MODE_LINEAR for @cs;

  @cs[0].set(0sec, 0);
  @cs[0].set(5sec, 1);

  @cs[1].set(0sec,  220 / 20000);
  @cs[1].set(3sec, 3520 / 20000);
  @cs[1].set(6sec,  440 / 20000);

  my $cid = $clock.create-single-shot-id( 7sec, :relative );
  if $pipeline.set-state(GST_STATE_PLAYING) {
    my @w = $cid.wait;
    say "Clock::id_wait returned: { @w[0] }" if @w[0] != GST_CLOCK_OK;
    $pipeline.set-state(GST_STATE_NULL);
  }

  LEAVE {
    $pipeline.unref if $pipeline;
  }
}
