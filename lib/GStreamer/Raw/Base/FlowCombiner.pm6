use v6.c;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Enums;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::Base::FlowCombiner;

### /usr/include/gstreamer-1.0/gst/base/gstflowcombiner.h

sub gst_flow_combiner_add_pad (GstFlowCombiner $combiner, GstPad $pad)
  is native(gstreamer-base)
  is export
{ * }

sub gst_flow_combiner_clear (GstFlowCombiner $combiner)
  is native(gstreamer-base)
  is export
{ * }

sub gst_flow_combiner_free (GstFlowCombiner $combiner)
  is native(gstreamer-base)
  is export
{ * }

sub gst_flow_combiner_get_type ()
  returns GType
  is native(gstreamer-base)
  is export
{ * }

sub gst_flow_combiner_new ()
  returns GstFlowCombiner
  is native(gstreamer-base)
  is export
{ * }

sub gst_flow_combiner_ref (GstFlowCombiner $combiner)
  returns GstFlowCombiner
  is native(gstreamer-base)
  is export
{ * }

sub gst_flow_combiner_remove_pad (GstFlowCombiner $combiner, GstPad $pad)
  is native(gstreamer-base)
  is export
{ * }

sub gst_flow_combiner_reset (GstFlowCombiner $combiner)
  is native(gstreamer-base)
  is export
{ * }

sub gst_flow_combiner_unref (GstFlowCombiner $combiner)
  is native(gstreamer-base)
  is export
{ * }

sub gst_flow_combiner_update_flow (
  GstFlowCombiner $combiner,
  GstFlowReturn $fret
)
  returns GstFlowReturn
  is native(gstreamer-base)
  is export
{ * }

sub gst_flow_combiner_update_pad_flow (
  GstFlowCombiner $combiner,
  GstPad $pad,
  GstFlowReturn $fret
)
  returns GstFlowReturn
  is native(gstreamer-base)
  is export
{ * }
