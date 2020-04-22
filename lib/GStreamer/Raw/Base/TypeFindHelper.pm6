use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Structs;
use GStreamer::Raw::Enums;

unit package GStreamer::Raw::Base::TypeFindHelper;

### /usr/include/gstreamer-1.0/gst/base/gsttypefindhelper.h

sub gst_type_find_helper (GstPad $src, guint64 $size)
  returns GstCaps
  is native(gstreamer-base)
  is export
{ * }

sub gst_type_find_helper_for_buffer (
  GstObject $obj,
  GstBuffer $buf,
  GstTypeFindProbability $prob
)
  returns GstCaps
  is native(gstreamer-base)
  is export
{ * }

sub gst_type_find_helper_for_buffer_with_extension (
  GstObject $obj,
  GstBuffer $buf,
  Str $extension,
  GstTypeFindProbability $prob
)
  returns GstCaps
  is native(gstreamer-base)
  is export
{ * }

multi sub gst_type_find_helper_for_data (
  GstObject $obj,
  Pointer $data,
  gsize $size,
  GstTypeFindProbability $prob
)
  returns CArray[GstCaps]
  is native(gstreamer-base)
  is export
{ * }
multi sub gst_type_find_helper_for_data (
  GstObject $obj,
  CArray[guint8] $data,
  gsize $size,
  GstTypeFindProbability $prob
)
  returns CArray[GstCaps]
  is native(gstreamer-base)
  is export
{ * }

# cw: Using this as a multi should have worked!
sub gst_type_find_helper_for_data_with_extension (
  GstObject $obj,
  Pointer $data,
  gsize $size,
  Str $extension,
  GstTypeFindProbability $prob
)
  returns GstCaps
  is native(gstreamer-base)
  is export
{ * }
# multi sub gst_type_find_helper_for_data_with_extension (
#   GstObject $obj,
#   CArray[guint8] $data,
#   gsize $size,
#   Str $extension,
#   GstTypeFindProbability $prob
# )
#   returns GstCaps
#   is native(gstreamer-base)
#   is export
# { * }

sub gst_type_find_helper_for_extension (GstObject $obj, Str $extension)
  returns CArray[GstCaps]
  is native(gstreamer-base)
  is export
{ * }

sub gst_type_find_helper_get_range (
  GstObject $obj,
  GstObject $parent,
  &func (
    GstObject,
    GstObject,
    guint64,
    guint,
    CArray[Pointer[GstBuffer]]
    --> GstFlowReturn
  ),
  guint64 $size,
  Str $extension,
  GstTypeFindProbability $prob
)
  returns GstCaps
  is native(gstreamer-base)
  is export
{ * }

sub gst_type_find_helper_get_range_full (
  GstObject $obj,
  GstObject $parent,
  &func (
    GstObject,
    GstObject,
    guint64,
    guint,
    CArray[Pointer[GstBuffer]]
    --> GstFlowReturn
  ),
  guint64 $size,
  Str $extension,
  GstCaps $caps,
  GstTypeFindProbability $prob
)
  returns GstFlowReturn
  is native(gstreamer-base)
  is export
{ * }
