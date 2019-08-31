use v6.c;

use Method::Also;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::Pipeline;

use GStreamer::Bin;
use GStreamer::Bus;

our subset PipelineAncestry is export of Mu
  where GstPipeline | BinAncestry;

class GStreamer::Pipeline is GStreamer::Bin {
  has GstPipeline $!p;

  submethod BUILD (:$pipeline) {
    self.setPipeline($pipeline);
  }

  method setPipeline (PipelineAncestry $_) {
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

  method GStreamer::Raw::Types::GstPipeline
    is also<GstPipeline>
  { $!p }

  multi method new (GstPipeline $pipeline) {
    self.bless( :$pipeline );
  }
  multi method new (Str() $name) {
    my $pipeline = gst_pipeline_new($name);
    self.bless( :$pipeline );
  }

  method auto_flush_bus is rw is also<auto-flush-bus> {
    Proxy.new(
      FETCH => sub ($) {
        so gst_pipeline_get_auto_flush_bus($!p);
      },
      STORE => sub ($, $auto_flush is copy) {
        gst_pipeline_set_auto_flush_bus($!p, $auto_flush);
      }
    );
  }

  method clock (:$raw = False) is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_pipeline_get_clock($!p);
        # OBJECT CREATION HERE
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
      STORE => sub ($, $delay is copy) {
        gst_pipeline_set_delay($!p, $delay);
      }
    );
  }

  method latency is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_pipeline_get_latency($!p);
      },
      STORE => sub ($, $latency is copy) {
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
    # OBJECT CREATION HERE
    gst_pipeline_get_pipeline_clock($!p);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_pipeline_get_type, $n, $t );
  }

  method use_clock (GstClock() $clock) is also<use-clock> {
    gst_pipeline_use_clock($!p, $clock);
  }

}
