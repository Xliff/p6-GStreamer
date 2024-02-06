use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Pipeline;

use GStreamer::Bin;
use GStreamer::Bus;
use GStreamer::Clock;

our subset GstPipelineAncestry is export of Mu
  where GstPipeline | GstBinAncestry;

class GStreamer::Pipeline is GStreamer::Bin {
  has GstPipeline $!p;

  submethod BUILD (:$pipeline) {
    self.setPipeline($pipeline) if $pipeline
  }

  method setPipeline (GstPipelineAncestry $_) {
    my $to-parent;

    $!p = do {
      when GstPipeline {
        $to-parent = cast(GstBin, $_);
        $_
      }

      default {
        $to-parent = $_;
        cast(GstPipeline, $_);
      }
    }
    self.setBin($to-parent);
  }

  method GStreamer::Raw::Definitions::GstPipeline
    is also<GstPipeline>
  { $!p }

  multi method new (GstPipeline $pipeline) {
    $pipeline ?? self.bless( :$pipeline ) !! Nil;
  }
  multi method new (Str() $name) {
    my $pipeline = gst_pipeline_new($name);

    $pipeline ?? self.bless( :$pipeline ) !! Nil;
  }

  method auto_flush_bus is rw is also<auto-flush-bus> {
    Proxy.new(
      FETCH => sub ($) {
        so gst_pipeline_get_auto_flush_bus($!p);
      },
      STORE => sub ($, Int() $auto_flush is copy) {
        my gboolean $a = $auto_flush.so.Int;

        gst_pipeline_set_auto_flush_bus($!p, $a);
      }
    );
  }

  method clock (:$raw = False) is rw {
    Proxy.new(
      FETCH => sub ($) {
        my $c = gst_pipeline_get_clock($!p);

        $c ??
          ( $raw ?? $c !! GStreamer::Clock.new($c) )
          !!
          Nil;
      },
      STORE => sub ($, GstClock() $clock is copy) {
        gst_pipeline_set_clock($!p, $clock);
      }
    );
  }

  method delay is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_pipeline_get_delay($!p);
      },
      STORE => sub ($, Int() $delay is copy) {
        my GstClockTime $d = $delay;

        gst_pipeline_set_delay($!p, $d);
      }
    );
  }

  method latency is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_pipeline_get_latency($!p);
      },
      STORE => sub ($, Int() $latency is copy) {
        my GstClockTime $l = $latency;

        gst_pipeline_set_latency($!p, $latency);
      }
    );
  }

  method auto_clock is also<auto-clock> {
    gst_pipeline_auto_clock($!p);
  }

  method get_bus (:$raw = False)
    is also<
      get-bus
      bus
    >
  {
    my $b = gst_pipeline_get_bus($!p);

    $b ??
      ( $raw ?? $b !! GStreamer::Bus.new($b) )
      !!
      Nil;
  }

  method get_pipeline_clock (:$raw = False)
    is also<
      get-pipeline-clock
      pipeline_clock
      pipeline-clock
    >
  {
    my $c = gst_pipeline_get_pipeline_clock($!p);

    $c ??
      ( $raw ?? $c !! GStreamer::Clock.new($c) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_pipeline_get_type, $n, $t );
  }

  method use_clock (GstClock() $clock) is also<use-clock> {
    gst_pipeline_use_clock($!p, $clock);
  }

}
