use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::Meta;

### /usr/include/gstreamer-1.0/gst/gstmeta.h

sub gst_meta_api_type_get_tags (GType $api)
  returns CArray[CArray[Str]]
  is native(gstreamer-video)
  is export
{ * }

sub gst_meta_api_type_has_tag (GType $api, GQuark $tag)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_meta_api_type_register (Str $api, Str $tags)
  returns GType
  is native(gstreamer-video)
  is export
{ * }

sub gst_meta_compare_seqnum (GstMeta $meta1, GstMeta $meta2)
  returns gint
  is native(gstreamer-video)
  is export
{ * }

sub gst_meta_get_info (Str $impl)
  returns GstMetaInfo
  is native(gstreamer-video)
  is export
{ * }

sub gst_meta_get_seqnum (GstMeta $meta)
  returns guint64
  is native(gstreamer-video)
  is export
{ * }

sub gst_meta_register (
  GType $api,
  Str $impl,
  gsize $size,
  &init_func  (GstMeta, gpointer, GstBuffer --> gboolean),
  &free_func  (GstMeta, GstBuffer),
  &trans_func (GstMeta, GstMeta, GstBuffer, GQuark, gpointer --> gboolean)
)
  returns GstMetaInfo
  is native(gstreamer-video)
  is export
{ * }
