use v6.c;

use GTK::Compat::Types;
use GStreamer::Raw::Types;

unit package GStreamer::Raw::StreamCollection;

sub gst_stream_collection_add_stream (
  GstStreamCollection $collection,
  GstStream $stream
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_stream_collection_get_size (GstStreamCollection $collection)
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_stream_collection_get_stream (
  GstStreamCollection $collection,
  guint $index
)
  returns GstStream
  is native(gstreamer)
  is export
{ * }

sub gst_stream_collection_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_stream_collection_get_upstream_id (GstStreamCollection $collection)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_stream_collection_new (Str $upstream_id)
  returns GstStreamCollection
  is native(gstreamer)
  is export
{ * }
