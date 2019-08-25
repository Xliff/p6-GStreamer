use v6.c;

use GTK::Compat::Types;
use GStreamer::Raw::Types;

unit package GStreamer::Raw::ElementFactory;

sub gst_element_factory_create (GstElementFactory $factory, Str $name)
  returns GstElement
  is native(gstreamer)
  is export
{ * }

sub gst_element_factory_find (Str $name)
  returns GstElementFactory
  is native(gstreamer)
  is export
{ * }

sub gst_element_factory_get_element_type (GstElementFactory $factory)
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_element_factory_get_metadata (GstElementFactory $factory, Str $key)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_element_factory_get_metadata_keys (GstElementFactory $factory)
  returns CArray[Str]
  is native(gstreamer)
  is export
{ * }

sub gst_element_factory_get_num_pad_templates (GstElementFactory $factory)
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_element_factory_get_static_pad_templates (GstElementFactory $factory)
  returns GList
  is native(gstreamer)
  is export
{ * }

sub gst_element_factory_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_element_factory_get_uri_type (GstElementFactory $factory)
  returns GstURIType
  is native(gstreamer)
  is export
{ * }

sub gst_element_factory_has_interface (
  GstElementFactory $factory,
  Str $interfacename
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_factory_list_filter (
  GList $list,
  GstCaps $caps,
  GstPadDirection $direction,
  gboolean $subsetonly
)
  returns GList
  is native(gstreamer)
  is export
{ * }

sub gst_element_factory_list_get_elements (
  uint64 $type,    # GstElementFactoryListType $type
  GstRank $minrank
)
  returns GList
  is native(gstreamer)
  is export
{ * }

sub gst_element_factory_list_is_type (
  GstElementFactory $factory,
  uint64 $type     # GstElementFactoryListType $type
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_factory_make (Str $factoryname, Str $name)
  returns GstElement
  is native(gstreamer)
  is export
{ * }

sub gst_element_register (
  GstPlugin $plugin,
  Str $name,
  guint $rank,
  GType $type
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_factory_get_uri_protocols (GstElementFactory $factory)
  returns CArray[Str]
  is native(gstreamer)
  is export
{ * }

sub gst_element_factory_can_sink_all_caps (
  GstElementFactory $factory,
  GstCaps $caps
)
  return gboolean
  is native(gstreamer)
  is export
{ * }

sub gst_element_factory_can_src_all_caps (
  GstElementFactory $factory,
  GstCaps $caps
)
  return gboolean
  is native(gstreamer)
  is export
{ * }

sub gst_element_factory_can_sink_any_caps (
  GstElementFactory $factory,
  GstCaps $caps
)
  return gboolean
  is native(gstreamer)
  is export
{ * }
