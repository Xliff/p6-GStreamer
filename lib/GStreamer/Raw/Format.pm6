use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GStreamer::Raw::Types;

unit package GStreamer::Format;

sub gst_format_get_by_nick (Str $nick)
  returns guint  # GstFormat
  is native(gstreamer)
  is export
{ * }

sub gst_format_get_details (
  guint $format  # GstFormat $format
)
  returns GstFormatDefinition
  is native(gstreamer)
  is export
{ * }

sub gst_format_get_name (
  guint $format  # GstFormat $format
)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_formats_contains (
  CArray[guint] $formats,
  guint $format  # GstFormat $format
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_format_iterate_definitions ()
  returns GstIterator
  is native(gstreamer)
  is export
{ * }

sub gst_format_register (Str $nick, Str $description)
  returns guint  # GstFormat
  is native(gstreamer)
  is export
{ * }

sub gst_format_to_quark (
  guint $format  # GstFormat $format
)
  returns GQuark
  is native(gstreamer)
  is export
{ * }
