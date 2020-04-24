use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Base::FlowCombiner;

class GStreamer::Base::FlowCombiner {
  has GstFlowCombiner $!fc;

  submethod BUILD (:$flow-combiner) {
    $!fc = $flow-combiner;
  }

  method GStreamer::Raw::Definitions::GstFlowCombiner
    is also<GstFlowCombiner>
  { * }

  multi method new (GstFlowCombiner $flow-combiner) {
    $flow-combiner ?? self.bless( :$flow-combiner ) !! Nil;
  }
  multi method new {
    gst_flow_combiner_new();
  }

  method add_pad (GstPad() $pad) is also<add-pad> {
    gst_flow_combiner_add_pad($!fc, $pad);
  }

  method clear {
    gst_flow_combiner_clear($!fc);
  }

  method free {
    gst_flow_combiner_free($!fc);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_flow_combiner_get_type, $n, $t );
  }

  method ref {
    gst_flow_combiner_ref($!fc);
  }

  method remove_pad (GstPad() $pad) is also<remove-pad> {
    gst_flow_combiner_remove_pad($!fc, $pad);
  }

  method reset {
    gst_flow_combiner_reset($!fc);
  }

  method unref {
    gst_flow_combiner_unref($!fc);
  }

  method update_flow (Int() $fret) is also<update-flow> {
    my GstFlowReturn $f = $fret;

    GstFlowReturnEnum( gst_flow_combiner_update_flow($!fc, $fret) );
  }

  method update_pad_flow (GstPad() $pad, GstFlowReturn $fret)
    is also<update-pad-flow>
  {
    my GstFlowReturn $f = $fret;

    GstFlowReturnEnum( gst_flow_combiner_update_pad_flow($!fc, $pad, $fret) );
  }

}
