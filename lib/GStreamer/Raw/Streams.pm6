use v6.c;

use GTK::Compat::Types;
use GStreamer::Raw::Types;

unit package GStreamer::Raw::Stream;

sub gst_stream_get_stream_id (GstStream $stream)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_stream_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_stream_new (
  Str $stream_id,
  GstCaps $caps,
  GstStreamType $type,
  GstStreamFlags $flags
)
  returns GstStream
  is native(gstreamer)
  is export
{ * }

sub gst_stream_type_get_name (GstStreamType $stype)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_stream_get_caps (GstStream $stream)
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

sub gst_stream_get_stream_flags (GstStream $stream)
  returns GstStreamFlags
  is native(gstreamer)
  is export
{ * }

sub gst_stream_get_stream_type (GstStream $stream)
  returns GstStreamType
  is native(gstreamer)
  is export
{ * }

sub gst_stream_get_tags (GstStream $stream)
  returns GstTagList
  is native(gstreamer)
  is export
{ * }

sub gst_stream_set_caps (GstStream $stream, GstCaps $caps)
  is native(gstreamer)
  is export
{ * }

sub gst_stream_set_stream_flags (GstStream $stream, GstStreamFlags $flags)
  is native(gstreamer)
  is export
{ * }

sub gst_stream_set_stream_type (GstStream $stream, GstStreamType $stream_type)
  is native(gstreamer)
  is export
{ * }

sub gst_stream_set_tags (GstStream $stream, GstTagList $tags)
  is native(gstreamer)
  is export
{ * }
