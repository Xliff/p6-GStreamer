use v6.c;

use GStreamer::Raw::Types;
use GTK::Raw::Types;

use GStreamer::Controller::DirectBinding;
use GStreamer::Main;
use GStreamer::Message;
use GStreamer::ElementFactory;
use GStreamer::Pipeline;
use GStreamer::Controller::DirectBinding;
use GStreamer::Controller::LFO;

use GStreamer::Plugins::Auto::Audio::Sink;
use GStreamer::Plugins::Audio::TestSrc;
use GStreamer::Plugins::FileSrc;
use GStreamer::Plugins::Mpeg::AudioParse;
use GStreamer::Plugins::Mpeg123::AudioDec;
use GStreamer::Plugins::Spectrum;
use GStreamer::Plugins::FakeSink;

use Color;
use GLib::Timeout;
use GDK::RGBA;
use GTK::Application;
use GTK::DrawingArea;

constant BANDS      = 50;
constant AUDIOFREQ  = 32000;
constant W          = 700;
constant H          = 350;
constant MAXMEASURE = 70;

my (@bands, @size);

my $bs     = 360 / BANDS;
my @colors = (0..360).rotor($bs);
my $csp    = (^$bs).roll;
@colors .= map({ .gist.say; Color.new( hsv => [ .[$csp], 50, 50 ] ) });

sub message-handler ($b, $m) {
  CATCH { default { .message.say; .backtrace.concise.say } }

  return True unless $m.type == GST_MESSAGE_ELEMENT;

  my $s = $m.structure;
  my $n = $s.name;

  return True unless $n eq 'spectrum';

  @bands = $s.get-list('magnitude').Array.map( *.value );
  my $max = @bands.hyper.map( *.abs.Int ).max / MAXMEASURE;

  True;
}

my %app-opts;

sub drawBand ($b, $v, $w, $h) {
  my ($hs, $vs) = ($w, $h) »/« (W, H);
  my ($x,   $y) = (35 * $b * $hs + 5, $v.Int.abs * 5 * $vs);
  my  $color    = @colors[$b];

  given $*cr {
    my $bh = $y - $h * $vs;

    .rgba( |$color.lighten(14).rgbad );
    .rectangle($x * $hs, $y * $vs, 25 * $hs, (H - $y) * $vs);
    .stroke( :preserve );
    .rgba( |$color.rgbad );
    .fill;
  }
}

sub draw ($, $cr, $, $r) {
  my $*cr     = $cr;
  my ($w, $h) = %app-opts<width height>;

  given $*cr {
    .line_width = 4;
    .operator = OPERATOR_SOURCE;
    .rgba(0, 0, 0, 1);
    .paint;
  }

  drawBand( |$_, $w, $h ) for @bands.kv.rotor(2);
  $r.r = 1;
}

sub MAIN ( $filename ) {
  unless $filename.IO.r {
    $*ERR.say: "Could not load file '{ $filename }'";
    exit(1);
  }

  GStreamer::Main.init;

  my $bin = GStreamer::Pipeline.new('bin');

  %app-opts = (
    title => 'org.genex.gstreamer.spectrum-analyzer',
    width => 700,
    height=> 350
  );

  my $a = GTK::Application.new( |%app-opts );

  $a.activate.tap: SUB {
    my $src  = GStreamer::Plugins::FileSrc.new;
    my $ap   = GStreamer::Plugins::Mpeg::AudioParse.new;
    my $ad   = GStreamer::Plugins::Mpeg123::AudioDec.new;
    my $ac   = GStreamer::ElementFactory.make('audioconvert');
    my $s    = GStreamer::Plugins::Spectrum.new;
    my $sink = GStreamer::Plugins::Auto::Audio::Sink.new;
    $bin.add-many($src, $ap, $ad, $ac, $s, $sink);

    {
      my $caps = GStreamer::Caps.new-simple(
       'audio/x-raw',
       'rate',
        G_TYPE_INT,
        AUDIOFREQ
      );

      unless [&&](
        $src.link($ap),
        $ap.link($ad),
        $ad.link($ac),
        $ac.link-filtered($s, $caps),
        $s.link($sink)
      ) {
        $*ERR.say: "Can't link elements'";
        exit(1);
      }
    }

    $src.setAttributes( location => $filename );
    $s.setAttributes(
      bands         => BANDS,
      threshold     => -80,
      post-messages => True,
      message-phase => True
    );

    $bin.bus.add-watch: sub (*@a) { message-handler( |@a[^2] ) }

    my $da = GTK::DrawingArea.new;
    $da.draw.tap: sub (*@a) { draw( | @a ) }
    $a.window.add: $da;
    $a.window.show-all;
    $da.invalidate;

    $bin.play;

    GLib::Timeout.add(50, SUB { $da.invalidate; G_SOURCE_CONTINUE });
  }

  $a.run;
  $bin.stop;
}
