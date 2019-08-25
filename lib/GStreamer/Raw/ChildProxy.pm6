use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GStreamer::Raw::Types;

unit package GStreamer::Raw::ChildProxy;

sub gst_child_proxy_child_added (
  GstChildProxy $parent,
  GObject $child,
  Str $name
)
  is native(gstreamer)
  is export
{ * }

sub gst_child_proxy_child_removed (
  GstChildProxy $parent,
  GObject $child,
  Str $name
)
  is native(gstreamer)
  is export
{ * }

sub gst_child_proxy_get_child_by_index (GstChildProxy $parent, guint $index)
  returns GObject
  is native(gstreamer)
  is export
{ * }

sub gst_child_proxy_get_child_by_name (GstChildProxy $parent, Str $name)
  returns GObject
  is native(gstreamer)
  is export
{ * }

sub gst_child_proxy_get_children_count (GstChildProxy $parent)
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_child_proxy_get_property (
  GstChildProxy $object,
  Str $name,
  GValue $value
)
  is native(gstreamer)
  is export
{ * }

sub gst_child_proxy_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

# sub gst_child_proxy_get_valist (
#   GstChildProxy $object,
#   Str $first_property_name,
#   va_list $var_args
# )
#   is native(gstreamer)
#   is export
# { * }

sub gst_child_proxy_lookup (
  GstChildProxy $object,
  Str $name,
  GObject $target,
  CArray[Pointer[GParamSpec]] $pspec
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_child_proxy_set_property (
  GstChildProxy $object,
  Str $name,
  GValue $value
)
  is native(gstreamer)
  is export
{ * }

# sub gst_child_proxy_set_valist (
#   GstChildProxy $object,
#   Str $first_property_name,
#   va_list $var_args
# )
#   is native(gstreamer)
#   is export
# { * }
