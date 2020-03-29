use v6.c;

use NativeCall;


use GStreamer::Raw::Types;

unit package GStreamer::Raw::PadTemplate;

sub gst_pad_template_get_caps (GstPadTemplate $templ)
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

sub gst_pad_template_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_static_pad_template_get (GstStaticPadTemplate $pad_template)
  returns GstPadTemplate
  is native(gstreamer)
  is export
{ * }

sub gst_static_pad_template_get_caps (GstStaticPadTemplate $templ)
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

sub gst_static_pad_template_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_pad_template_new (
  Str $name_template,
  GstPadDirection $direction,
  GstPadPresence $presence,
  GstCaps $caps
)
  returns GstPadTemplate
  is native(gstreamer)
  is export
{ * }

sub gst_pad_template_new_from_static_pad_template_with_gtype (
  GstStaticPadTemplate $pad_template,
  GType $pad_type
)
  returns GstPadTemplate
  is native(gstreamer)
  is export
{ * }

sub gst_pad_template_new_with_gtype (
  Str $name_template,
  GstPadDirection $direction,
  GstPadPresence $presence,
  GstCaps $caps,
  GType $pad_type
)
  returns GstPadTemplate
  is native(gstreamer)
  is export
{ * }

sub gst_pad_template_pad_created (GstPadTemplate $templ, GstPad $pad)
  is native(gstreamer)
  is export
{ * }
