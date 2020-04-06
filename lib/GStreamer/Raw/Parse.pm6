use v6.c;

use NativeCall;


use GStreamer::Raw::Types;

unit package GStreamer::Raw::Parse;

sub gst_parse_context_copy (GstParseContext $context)
  returns GstParseContext
  is native(gstreamer)
  is export
{ * }

sub gst_parse_context_free (GstParseContext $context)
  is native(gstreamer)
  is export
{ * }

sub gst_parse_context_get_missing_elements (GstParseContext $context)
  returns CArray[Str]
  is native(gstreamer)
  is export
{ * }

sub gst_parse_context_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_parse_context_new ()
  returns GstParseContext
  is native(gstreamer)
  is export
{ * }

sub gst_parse_error_quark ()
  returns GQuark
  is native(gstreamer)
  is export
{ * }

sub gst_parse_launch (
  Str $pipeline_description,
  CArray[Pointer[GError]] $error
)
  returns GstElement
  is native(gstreamer)
  is export
{ * }

sub gst_parse_launch_full (
  Str $pipeline_description,
  GstParseContext $context,
  guint $flags,                   # GstParseFlags $flags,
  CArray[Pointer[GError]] $error
)
  returns GstElement
  is native(gstreamer)
  is export
{ * }

sub gst_parse_launchv (
  CArray[Str] $argv,
  CArray[Pointer[GError]] $error
)
  returns GstElement
  is native(gstreamer)
  is export
{ * }

sub gst_parse_launchv_full (
  CArray[Str] $argv,
  GstParseContext $context,
  guint $flags,                   # GstParseFlags $flags,
  CArray[Pointer[GError]] $error
)
  returns GstElement
  is native(gstreamer)
  is export
{ * }
