use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Structs;
use GStreamer::Raw::Enums;
use GStreamer::Raw::Definitions;

unit package GStreamer::Raw::Base::Aggregator;

### /usr/include/gstreamer-1.0/gst/base/gstaggregator.h

sub gst_aggregator_finish_buffer (GstAggregator $aggregator, GstBuffer $buffer)
  returns GstFlowReturn
  is native(gstreamer-base)
  is export
{ * }

sub gst_aggregator_get_allocator (
  GstAggregator $self,
  GstAllocator $allocator,
  GstAllocationParams $params is rw
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_aggregator_get_buffer_pool (GstAggregator $self)
  returns GstBufferPool
  is native(gstreamer-base)
  is export
{ * }

sub gst_aggregator_get_latency (GstAggregator $self)
  returns GstClockTime
  is native(gstreamer-base)
  is export
{ * }

sub gst_aggregator_get_type ()
  returns GType
  is native(gstreamer-base)
  is export
{ * }

sub gst_aggregator_pad_drop_buffer (GstAggregatorPad $pad)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_aggregator_pad_get_type ()
  returns GType
  is native(gstreamer-base)
  is export
{ * }

sub gst_aggregator_pad_has_buffer (GstAggregatorPad $pad)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_aggregator_pad_is_eos (GstAggregatorPad $pad)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_aggregator_pad_peek_buffer (GstAggregatorPad $pad)
  returns GstBuffer
  is native(gstreamer-base)
  is export
{ * }

sub gst_aggregator_pad_pop_buffer (GstAggregatorPad $pad)
  returns GstBuffer
  is native(gstreamer-base)
  is export
{ * }

sub gst_aggregator_set_latency (
  GstAggregator $self,
  GstClockTime $min_latency,
  GstClockTime $max_latency
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_aggregator_set_src_caps (GstAggregator $self, GstCaps $caps)
  is native(gstreamer-base)
  is export
{ * }

sub gst_aggregator_simple_get_next_time (GstAggregator $self)
  returns GstClockTime
  is native(gstreamer-base)
  is export
{ * }
