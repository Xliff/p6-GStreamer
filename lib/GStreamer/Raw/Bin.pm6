use v6.c;

use NativeCall;


use GStreamer::Raw::Types;

unit package GStreamer::Raw::Bin;

sub gst_bin_add (GstBin $bin, GstElement $element)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_bin_get_by_interface (GstBin $bin, GType $iface)
  returns GstElement
  is native(gstreamer)
  is export
{ * }

sub gst_bin_get_by_name (GstBin $bin, Str $name)
  returns GstElement
  is native(gstreamer)
  is export
{ * }

sub gst_bin_get_by_name_recurse_up (GstBin $bin, Str $name)
  returns GstElement
  is native(gstreamer)
  is export
{ * }

sub gst_bin_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_bin_iterate_all_by_interface (GstBin $bin, GType $iface)
  returns GstIterator
  is native(gstreamer)
  is export
{ * }

sub gst_bin_iterate_elements (GstBin $bin)
  returns GstIterator
  is native(gstreamer)
  is export
{ * }

sub gst_bin_iterate_recurse (GstBin $bin)
  returns GstIterator
  is native(gstreamer)
  is export
{ * }

sub gst_bin_iterate_sinks (GstBin $bin)
  returns GstIterator
  is native(gstreamer)
  is export
{ * }

sub gst_bin_iterate_sorted (GstBin $bin)
  returns GstIterator
  is native(gstreamer)
  is export
{ * }

sub gst_bin_iterate_sources (GstBin $bin)
  returns GstIterator
  is native(gstreamer)
  is export
{ * }

sub gst_bin_new (Str $name)
  returns GstElement
  is native(gstreamer)
  is export
{ * }

sub gst_bin_recalculate_latency (GstBin $bin)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_bin_remove (GstBin $bin, GstElement $element)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_bin_get_suppressed_flags (GstBin $bin)
  returns guint # GstElementFlags
  is native(gstreamer)
  is export
{ * }

sub gst_bin_set_suppressed_flags (
  GstBin $bin,
  guint $flags # GstElementFlags $flags
)
  is native(gstreamer)
  is export
{ * }
