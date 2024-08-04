use v6.c;

use GStreamer::Raw::Types;

use GLib::MainLoop;
use GStreamer::Main;
use GStreamer::Message;
use GStreamer::ElementFactory;
use GStreamer::Pipeline;

use GStreamer::Plugins::Audio::TestSrc;
use GStreamer::Plugins::Spectrum;
use GStreamer::Plugins::FakeSink;

constant BANDS     = 20;
constant AUDIOFREQ = 32000;

sub message-handler ($b, $m) {
  CATCH { default { .message.say; .backtrace.concise.say } }

  return True unless $m.type == GST_MESSAGE_ELEMENT;

  my $s = $m.structure;
  my $n = $s.name;

  return True unless $n eq 'spectrum';

  my $et = $s.clock-time('endtime');
  $et = GST_CLOCK_TIME_NONE unless $et.defined;

  say "New spectrum message at { $et }";

  my ($mag, $p)   = (
    .get-list('magnitude').Array.map( *.value ),
    .get-list('phase').Array.map( *.value )
  ) given $s;
  my ($haf, $qaf) = AUDIOFREQ «/« (2, 4);
  for ($mag[] Z $p[]).kv.rotor(2) {
    my $f = ($haf * .head + $qaf) / BANDS;

    next unless [&&]( |.tail );

    sprintf( qq:to/MESSAGE/ ).say;
      band { .head } (freq { $f }):
        magnitude { .tail.head.Array.gist } dB
        phase     { .tail.tail.Array.gist }
      MESSAGE

  }
  True;
}

sub MAIN {
  GStreamer::Main.init;

  my $bin  = GStreamer::Pipeline.new('bin');
  my $src  = GStreamer::Plugins::Audio::TestSrc.new;
  my $ac   = GStreamer::ElementFactory.make('audioconvert');
  my $s    = GStreamer::Plugins::Spectrum.new;
  my $sink = GStreamer::Plugins::FakeSink.new;

  $bin.add-many($src, $ac, $s, $sink);

  {
    my $caps = GStreamer::Caps.new-simple(
     'audio/x-raw',
     'rate',
      G_TYPE_INT,
      AUDIOFREQ
    );

    unless [&&](
      $src.link($ac),
      $ac.link-filtered($s, $caps),
      $s.link($sink)
    ) {
      $*ERR.say: "Can't link elements'";
      exit(1);
    }
  }

  $src.setAttributes(
    wave => 0,
    freq => 4000
  );
  $s.setAttributes(
    bands         => BANDS,
    threshold     => -80,
    post-messages => True,
    message-phase => True
  );
  $sink.setAttributes( sync => True );

  $bin.bus.add-watch: sub (*@a) { message-handler( |@a[^2] ) }

  $bin.play;
  ( my $l = GLib::MainLoop.new ).run;
  $bin.stop;
}
