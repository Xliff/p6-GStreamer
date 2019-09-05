use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GStreamer::Raw::Types;

unit package GStreamer::Raw::CapsFeatures;

sub gst_caps_features_add (GstCapsFeatures $features, Str $feature)
  is native(gstreamer)
  is export
{ * }

sub gst_caps_features_add_id (GstCapsFeatures $features, GQuark $feature)
  is native(gstreamer)
  is export
{ * }

sub gst_caps_features_contains (GstCapsFeatures $features, Str $feature)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_caps_features_contains_id (GstCapsFeatures $features, GQuark $feature)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_caps_features_copy (GstCapsFeatures $features)
  returns GstCapsFeatures
  is native(gstreamer)
  is export
{ * }

sub gst_caps_features_free (GstCapsFeatures $features)
  is native(gstreamer)
  is export
{ * }

sub gst_caps_features_from_string (Str $features)
  returns GstCapsFeatures
  is native(gstreamer)
  is export
{ * }

sub gst_caps_features_get_nth (GstCapsFeatures $features, guint $i)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_caps_features_get_nth_id (GstCapsFeatures $features, guint $i)
  returns GQuark
  is native(gstreamer)
  is export
{ * }

sub gst_caps_features_get_size (GstCapsFeatures $features)
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_caps_features_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_is_caps_features (gconstpointer $obj)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_caps_features_is_any (GstCapsFeatures $features)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_caps_features_is_equal (
  GstCapsFeatures $features1,
  GstCapsFeatures $features2
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_caps_features_new_any ()
  returns GstCapsFeatures
  is native(gstreamer)
  is export
{ * }

sub gst_caps_features_new_empty ()
  returns GstCapsFeatures
  is native(gstreamer)
  is export
{ * }

# sub gst_caps_features_new_id_valist (GQuark $feature1, va_list $varargs)
#   returns GstCapsFeatures
#   is native(gstreamer)
#   is export
# { * }
#
# sub gst_caps_features_new_valist (Str $feature1, va_list $varargs)
#   returns GstCapsFeatures
#   is native(gstreamer)
#   is export
# { * }

sub gst_caps_features_remove (GstCapsFeatures $features, Str $feature)
  is native(gstreamer)
  is export
{ * }

sub gst_caps_features_remove_id (GstCapsFeatures $features, GQuark $feature)
  is native(gstreamer)
  is export
{ * }

sub gst_caps_features_set_parent_refcount (
  GstCapsFeatures $features,
  gint $refcount
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_caps_features_to_string (GstCapsFeatures $features)
  returns Str
  is native(gstreamer)
  is export
{ * }
