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
use GStreamer::Plugins::Spectrum;
use GStreamer::Plugins::FakeSink;

use Color;
use GLib::Timeout;
use GDK::RGBA;
use GTK::Application;
use GTK::DrawingArea;

constant BANDS     = 20;
constant AUDIOFREQ = 32000;
constant W         = 700;
constant H         = 350;

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
  my $max = @bands.hyper.map( *.abs.Int ).max;

  True;
}

my %app-opts;

sub drawBand ($b, $v, $w, $h) {
  my ($hs, $vs) = ($w, $h) »/« (W, H);
  my ($x,   $y) = (35 * $b * $hs + 5, $v.Int.abs * 10 * $vs);

#  say "Drawing #{ $b }: ({ $x }, { $y }) s ({ $hs }, { $vs })";

  my $color = @colors[$b];

  given $*cr {
    my $bh = $y - $h * $vs;

    .rgba( |$color.lighten(14).rgbad );
    .rectangle($x * $hs, $y * $vs, 25 * $hs, (700 - $y) * $vs);

    # .move_to($x, $y);
    # .line_to(           25 * $hs,     0, :rel );
    # .line_to(                  0,   $bh, :rel );
    # .line_to(          -25 * $hs,     0, :rel );
    # .close_path;
    # cw: COLORING!

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

sub MAIN {
  GStreamer::Main.init;

  my $bin = GStreamer::Pipeline.new('bin');

  %app-opts = (
    title => 'org.genex.gstreamer.spectrum-analyzer',
    width => 700,
    height=> 350
  );

  my $a = GTK::Application.new( |%app-opts );

  $a.activate.tap: SUB {
    my $src  = GStreamer::Plugins::Audio::TestSrc.new;
    my $ac   = GStreamer::ElementFactory.make('audioconvert');
    my $s    = GStreamer::Plugins::Spectrum.new;
    my $sink = GStreamer::Plugins::Auto::Audio::Sink.new;
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
      freq => 2000
    );
    $s.setAttributes(
      bands         => BANDS,
      threshold     => -80,
      post-messages => True,
      message-phase => True
    );
    #$sink.setAttributes( sync => True );

    $bin.bus.add-watch: sub (*@a) { message-handler( |@a[^2] ) }

    my $da = GTK::DrawingArea.new;
    $da.draw.tap: sub (*@a) { draw( | @a ) }
    $a.window.add: $da;
    $a.window.show-all;
    $da.invalidate;

    $bin.play;

    GLib::Timeout.add(100, SUB { $da.invalidate; G_SOURCE_CONTINUE });

    $*SCHEDULER.cue( in => 5, sub {
      $bin.stop;
      $src.freq = 3000;
      $bin.start;
      $*SCHEDULER.cue( in => 5, sub {
        $bin.stop;
        $src.freq = 4000;
        $bin.play;
        $*SCHEDULER.cue( in => 5, sub {
          $bin.stop;
          $src.freq = 5000;
          $bin.start;
        });
      });
    });
  }

  $a.run;
  $bin.stop;
}
