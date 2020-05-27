use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::TypeFindFactory;

### /usr/include/gstreamer-1.0/gst/gsttypefindfactory.h

sub gst_type_find_factory_call_function (
  GstTypeFindFactory $factory,
  GstTypeFind $find
)
  is native(gstreamer)
  is export
{ * }

sub gst_type_find_factory_get_caps (GstTypeFindFactory $factory)
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

sub gst_type_find_factory_get_extensions (GstTypeFindFactory $factory)
  returns CArray[Str]
  is native(gstreamer)
  is export
{ * }

sub gst_type_find_factory_get_list ()
  returns GList
  is native(gstreamer)
  is export
{ * }

sub gst_type_find_factory_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_type_find_factory_has_function (GstTypeFindFactory $factory)
  returns uint32
  is native(gstreamer)
  is export
{ * }
