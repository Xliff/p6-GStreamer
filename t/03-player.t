use v6.c;

use GTK::Compat::Types;
use GStreamer::Raw::Types;

use GTK::Compat::MainLoop;
use GTK::Compat::Source;
use GTK::Compat::Value; # for prop_set call.

use GStreamer::ElementFactory;
use GStreamer::Main;
use GStreamer::Message;
use GStreamer::Pipeline;

sub MAIN (
  $filename     #= Name of Ogg/Vorbis file to play
) {
  GStreamer::Main.init;

  my %e;
  my $loop     = GTK::Compat::MainLoop.new;
  my $pipeline = GStreamer::Pipeline.new('audio-player');

  %e{$_[0]} = GStreamer::ElementFactory.make($_[1], $_[2])
    for  <source  filesrc       file-source>,
         <demuxer oggdemux      ogg-demuxer>,
         <decoder vorbisdec     vorbis-decoder>,
         <conv    audioconvert  converter>,
         <sink    autoaudiosink audio-output>;

  die 'One element could not be created. Exiting!'
    if %e.values.grep( *.defined.not );

  # Will need to check this and add it to GStreamer::Object
  %e<source>.prop-set( 'location', gv_str($filename) );

  my $bus = $pipeline.bus;
  my $watch-id = $bus.add-watch(-> *@a --> guint {
    CATCH { default { .message.say } }

    my $m = GStreamer::Message.new( @a[1] );

    say $m.type;
    given $m.type {
      when GST_MESSAGE_EOS   { say 'End of stream'; $loop.quit }

      when GST_MESSAGE_ERROR {
        my ($error, $debug) = $m.parse_error;
        say "Error: { $error.message }";
        $loop.quit;
      }
    }

    1;
  });
  $bus.unref;

  $pipeline.add-many( %e<source demuxer decoder conv sink> );

  %e<source>.link(%e<demuxer>);
  %e<decoder>.link-many(%e<conv>, %e<sink>);

  # note that the demuxer will be linked to the decoder dynamically.
  # The reason is that Ogg may contain various streams (for example
  # audio and video). The source pad(s) will be created at run time,
  # by the demuxer when it detects the amount and nature of streams.
  # Therefore we connect a callback function which will be executed
  # when the "pad-added" is emitted.

  # %e<demuxer>.pad-added.tap(-> *@a {
  #   CATCH { default { .message.say } }
  #
  #   say 'PA';
  #   my $p = GStreamer::Pad.new( @a[1] );
  #   my $sinkpad = %e<decoder>.get-static-pad('sink');
  #
  #   $p.link($sinkpad);
  #   $sinkpad.unref;
  #
  #   say 'Dynamic pad created, linking demuxer/decoder'
  # });

  say "Now playing: { $filename }";
  $pipeline.set_state(GST_STATE_PLAYING);

  say 'Running...';

  $loop.run;

  say 'Returned. Stoping playback...';
  $pipeline.set_state(GST_STATE_NULL);

  say 'Deleting pipeline...';
  $pipeline.unref;
  GTK::Compat::Source.remove($watch-id);
  $loop.unref;
}
