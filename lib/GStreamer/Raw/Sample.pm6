use v6.c;

use NativeCall;


use GStreamer::Raw::Types;

unit package GStreamer::Raw::Sample;

sub gst_sample_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_sample_new (
  GstBuffer $buffer,
  GstCaps $caps,
  GstSegment $segment,
  GstStructure $info
)
  returns GstSample
  is native(gstreamer)
  is export
{ * }

sub gst_sample_get_buffer (GstSample $sample)
  returns GstBuffer
  is native(gstreamer)
  is export
{ * }

sub gst_sample_get_buffer_list (GstSample $sample)
  returns GstBufferList
  is native(gstreamer)
  is export
{ * }

sub gst_sample_get_caps (GstSample $sample)
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

sub gst_sample_get_info (GstSample $sample)
  returns GstStructure
  is native(gstreamer)
  is export
{ * }

sub gst_sample_get_segment (GstSample $sample)
  returns GstSegment
  is native(gstreamer)
  is export
{ * }

sub gst_sample_set_buffer (GstSample $sample, GstBuffer $buffer)
  is native(gstreamer)
  is export
{ * }

sub gst_sample_set_buffer_list (GstSample $sample, GstBufferList $buffer_list)
  is native(gstreamer)
  is export
{ * }

sub gst_sample_set_caps (GstSample $sample, GstCaps $caps)
  is native(gstreamer)
  is export
{ * }

sub gst_sample_set_info (GstSample $sample, GstStructure $info)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_sample_set_segment (GstSample $sample, GstSegment $segment)
  is native(gstreamer)
  is export
{ * }
