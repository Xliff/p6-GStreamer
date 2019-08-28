use v6.c;

use GStreamer::Raw::Types;

use GTK::Compat::Value;

use GStreamer::ElementFactory;
use GStreamer::Main;
use GStreamer::Pipeline;

sub MAIN {
  GStreamer::Main.init;

  my $source   = GStreamer::ElementFactory.make('videotestsrc', 'source');
  my $sink     = GStreamer::ElementFactory.make('autovideosink', 'sink');
  my $pipeline = GStreamer::Pipeline.new('test-pipeline');

  if ($source, $sink, $pipeline).grep( *.defined.not ) {
    say 'Elements could not be linked';
    $pipeline.unref;
    exit 1;
  }

  $pipeline.add-many($source, $sink);
  unless $source.link($sink) {
    say 'Elements could not be linked.';
    $pipeline.unref;
    exit 1;
  }

  $source.prop_set('pattern', gv_int(0));

  if $pipeline.set-state(GST_STATE_PLAYING) == GST_STATE_CHANGE_FAILURE {
    say 'Unable to set the pipeline to the playing state.';
    $pipeline.unref;
    exit 1;
  }

  my $bus = $pipeline.bus;
  my $msg = $bus.timed-pop-filtered(
    GST_CLOCK_TIME_NONE,
    GST_MESSAGE_ERROR +| GST_MESSAGE_EOS
  );

  if $msg {
    given $msg.type {
      when GST_MESSAGE_ERROR {
        my ($error, $debug) = $msg.parse_error;

        say "Error received from element { $msg.src.name }: { $error.message }";
        say "Debugging information: { $debug ?? $debug !! 'none' }";
      }

      when GST_MESSAGE_EOS { say 'End of stream reached' }
      default              { say 'Unexpected message received.' }
    }
    $msg.unref;
  }

  $pipeline.set_state(GST_STATE_NULL);
  $bus.unref;
}
