use v6.c;

use NativeCall;


use GStreamer::Raw::Types;

unit package GStreamer::Raw::Context;

sub gst_context_get_context_type (GstContext $context)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_context_get_structure (GstContext $context)
  returns GstStructure
  is native(gstreamer)
  is export
{ * }

sub gst_context_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_context_has_context_type (GstContext $context, Str $context_type)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_context_is_persistent (GstContext $context)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_context_new (Str $context_type, gboolean $persistent)
  returns GstContext
  is native(gstreamer)
  is export
{ * }

sub gst_context_writable_structure (GstContext $context)
  returns GstStructure
  is native(gstreamer)
  is export
{ * }
