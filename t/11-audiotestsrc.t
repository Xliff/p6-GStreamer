use v6.c;

use GStreamer::Raw::Types;

use GLib::IOChannel;
use GLib::MainLoop;

use GStreamer::Element;
use GStreamer::ElementFactory;
use GStreamer::Main;
use GStreamer::Pipeline;

use GStreamer::Plugins::AudioTestSrc;

sub MAIN (
  :$freq!,          #= Frequency of the tone, in Hz
  :$volume = 0.5,   #= Volume: 0..1 (floating point)
  :$wave = 0        #= Wave pattern number
) {
  my %data;

  GStreamer::Main.init;

  my $pipeline     = GStreamer::Pipeline.new('test-pipeline');

  my @elements = (
    (  my $source       = GStreamer::ElementFactory.make('audiotestsrc', 'source') ),
    (  my $tee          = GStreamer::ElementFactory.make('tee') ),
    |( my ($q1, $q2)    = GStreamer::ElementFactory.make('queue') xx 2 ),
    |( my ($ac1, $ac2)  = GStreamer::ElementFactory.make('audioconvert') xx 2 ),
    (  my $libv-lv      = GStreamer::ElementFactory.make('libvisual_lv_scope') ),
    (  my $vc           = GStreamer::ElementFactory.make('videoconvert') ),
    (  my $asink        = GStreamer::ElementFactory.make('autoaudiosink', 'asink') ),
    (  my $vsink        = GStreamer::ElementFactory.make('autovideosink', 'vsink') )
  );

  if @elements.grep( *.defined.not ) {
    say 'All required elements could not be created';
    $pipeline.unref;
    exit 1;
  }
  $pipeline.add-many( |@elements );

  unless $source 🔗 $tee 🔗 $q1 🔗 $ac1 🔗 $asink {
    say 'Required audio elements could not be linked.';
    $pipeline.unref;
    exit 1;
  }

  unless $tee 🔗 $q2 🔗 $ac2 🔗 $libv-lv 🔗 $vc 🔗 $vsink {
    say 'Required video elements could not be linked.';
    $pipeline.unref;
    exit 1;
  }

  my $test-src = GStreamer::Plugins::AudioTestSrc.new( $source.GstElement );
  $test-src.freq   = $freq;
  $test-src.wave   = $wave;
  $test-src.volume = $volume;

  sub set-state ($s) {
    if $pipeline.set-state($s) == GST_STATE_CHANGE_FAILURE {
      say "Unable to set the pipeline to the $s state.";
      $pipeline.unref;
      exit 1;
    }
  }

  sub play  { set-state(GST_STATE_PLAYING) }
  sub pause { set-state(GST_STATE_PAUSED)  }

  play;

  %data<stdin> = GLib::IOChannel.unix_new($*IN.native-descriptor);
  %data<stdin>.add_watch(G_IO_IN, -> *@a --> gboolean {
    CATCH { default { .message.say } }

    my ($rs, $in) = %data<stdin>.read_line;

    return unless $rs == G_IO_STATUS_NORMAL;

    $in .= substr(0, 1);

    if $in.lc eq <f w v q>.any {
      #pause;
      given $in {
        # Attempting to modify test source in this manner will result in a
        # segfault.
        #
        when 'f'        { $test-src.freq -= 100
                            if $test-src.freq     > 100;       }
        when 'F'        { $test-src.freq += 100
                            if $test-src.freq     < 11000;     }
        when 'w'        { $test-src.wave = $test-src.wave.pred
                            if $test-src.wave.Int > 0;         }
        when 'W'        { $test-src.wave = $test-src.wave.succ
                            if $test-src.wave.Int < 12;        }
        when 'v'        { $test-src.volume -= 0.1
                            if   $test-src.volume > 0          }
        when 'V'        { $test-src.volume += 0.1
                            if   $test-src.volume < 1          }

        when 'q'  | 'Q' { %data<loop>.quit }
      }
      #play;
    }
    1
  });

  say q:to/INSTRUCTIONS/;
    USAGE: Choose one of the following options, then press enter:
      'F' Increase frequency by 100 / 'f' Decrease frequency by 100
      'W' Increase wave      by 1   / 'w' Decrease wave      by 1
      'V' Increase volume    by 0.1 / 'v' Decrease volume    by 0.1
      'Q' to quit
    INSTRUCTIONS

  ( %data<loop> = GLib::MainLoop.new ).run;

  LEAVE {
    $pipeline.set-state(GST_STATE_NULL) if $pipeline.defined;
    for <stdin loop> {
      %data{$_}.unref if %data{$_};
    }
  }
}
