use v6.c;

use GStreamer::Raw::Types;

unit package GStreamer::Raw::GhostPad;

### /usr/include/gstreamer-1.0/gst/gstghostpad.h

sub gst_ghost_pad_activate_mode_default (
  GstPad $pad,
  GstObject $parent,
  GstPadMode $mode,
  gboolean $active
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_ghost_pad_construct (GstGhostPad $gpad)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_ghost_pad_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_proxy_pad_chain_default (
  GstPad $pad,
  GstObject $parent,
  GstBuffer $buffer
)
  returns GstFlowReturn
  is native(gstreamer)
  is export
{ * }

sub gst_proxy_pad_chain_list_default (
  GstPad $pad,
  GstObject $parent,
  GstBufferList $list
)
  returns GstFlowReturn
  is native(gstreamer)
  is export
{ * }

sub gst_proxy_pad_get_internal (GstProxyPad $pad)
  returns GstProxyPad
  is native(gstreamer)
  is export
{ * }

sub gst_proxy_pad_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_proxy_pad_getrange_default (
  GstPad $pad,
  GstObject $parent,
  guint64 $offset,
  guint $size,
  GstBuffer $buffer
)
  returns GstFlowReturn
  is native(gstreamer)
  is export
{ * }

sub gst_proxy_pad_iterate_internal_links_default (
  GstPad $pad,
  GstObject $parent
)
  returns GstIterator
  is native(gstreamer)
  is export
{ * }

sub gst_ghost_pad_internal_activate_mode_default (
  GstPad $pad,
  GstObject $parent,
  GstPadMode $mode,
  gboolean $active
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_ghost_pad_new (Str $name, GstPad $target)
  returns GstPad
  is native(gstreamer)
  is export
{ * }

sub gst_ghost_pad_new_from_template (
  Str $name,
  GstPad $target,
  GstPadTemplate $templ
)
  returns GstPad
  is native(gstreamer)
  is export
{ * }

sub gst_ghost_pad_new_no_target (Str $name, GstPadDirection $dir)
  returns GstPad
  is native(gstreamer)
  is export
{ * }

sub gst_ghost_pad_new_no_target_from_template (Str $name, GstPadTemplate $templ)
  returns GstPad
  is native(gstreamer)
  is export
{ * }

sub gst_ghost_pad_get_target (GstGhostPad $gpad)
  returns GstPad
  is native(gstreamer)
  is export
{ * }

sub gst_ghost_pad_set_target (GstGhostPad $gpad, GstPad $newtarget)
  returns uint32
  is native(gstreamer)
  is export
{ * }
