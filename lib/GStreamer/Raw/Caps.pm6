use v6.c;

use NativeCall;


use GStreamer::Raw::Types;

unit package GStreamer::Raw::Caps;

sub gst_caps_append (GstCaps $caps1, GstCaps $caps2)
  is native(gstreamer)
  is export
{ * }

sub gst_caps_append_structure (GstCaps $caps, GstStructure $structure)
  is native(gstreamer)
  is export
{ * }

sub gst_caps_append_structure_full (
  GstCaps $caps,
  GstStructure $structure,
  GstCapsFeatures $features
)
  is native(gstreamer)
  is export
{ * }

sub gst_caps_can_intersect (GstCaps $caps1, GstCaps $caps2)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_caps_copy (GstCaps $caps)
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

sub gst_caps_copy_nth (GstCaps $caps, guint $nth)
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

sub gst_caps_filter_and_map_in_place (
  GstCaps $caps,
  GstCapsFilterMapFunc $func,
  gpointer $user_data
)
  is native(gstreamer)
  is export
{ * }

sub gst_caps_fixate (GstCaps $caps)
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

sub gst_caps_foreach (
  GstCaps $caps,
  GstCapsForeachFunc $func,
  gpointer $user_data
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_caps_from_string (Str $string)
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

sub gst_caps_get_features (GstCaps $caps, guint $index)
  returns GstCapsFeatures
  is native(gstreamer)
  is export
{ * }

sub gst_caps_get_size (GstCaps $caps)
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_caps_get_structure (GstCaps $caps, guint $index)
  returns GstStructure
  is native(gstreamer)
  is export
{ * }

sub gst_caps_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_static_caps_cleanup (GstStaticCaps $static_caps)
  is native(gstreamer)
  is export
{ * }

sub gst_static_caps_get (GstStaticCaps $static_caps)
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

sub gst_static_caps_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_caps_intersect (GstCaps $caps1, GstCaps $caps2)
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

sub gst_caps_intersect_full (
  GstCaps $caps1,
  GstCaps $caps2,
  GstCapsIntersectMode $mode
)
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

sub gst_caps_is_always_compatible (GstCaps $caps1, GstCaps $caps2)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_caps_is_any (GstCaps $caps)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_caps_is_empty (GstCaps $caps)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_caps_is_equal (GstCaps $caps1, GstCaps $caps2)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_caps_is_equal_fixed (GstCaps $caps1, GstCaps $caps2)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_caps_is_fixed (GstCaps $caps)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_caps_is_strictly_equal (GstCaps $caps1, GstCaps $caps2)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_caps_is_subset (GstCaps $subset, GstCaps $superset)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_caps_is_subset_structure (GstCaps $caps, GstStructure $structure)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_caps_is_subset_structure_full (
  GstCaps $caps,
  GstStructure $structure,
  GstCapsFeatures $features
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_caps_map_in_place (
  GstCaps $caps,
  GstCapsMapFunc $func,
  gpointer $user_data
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_caps_merge (GstCaps $caps1, GstCaps $caps2)
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

sub gst_caps_merge_structure (GstCaps $caps, GstStructure $structure)
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

sub gst_caps_merge_structure_full (
  GstCaps $caps,
  GstStructure $structure,
  GstCapsFeatures $features
)
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

sub gst_caps_new_any ()
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

sub gst_caps_new_empty ()
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

sub gst_caps_new_empty_simple (Str $media_type)
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

# sub gst_caps_new_full_valist (GstStructure $structure, va_list $var_args)
#   returns GstCaps
#   is native(gstreamer)
#   is export
# { * }

sub gst_caps_normalize (GstCaps $caps)
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

sub gst_caps_remove_structure (GstCaps $caps, guint $idx)
  is native(gstreamer)
  is export
{ * }

sub gst_caps_set_features (
  GstCaps $caps,
  guint $index,
  GstCapsFeatures $features
)
  is native(gstreamer)
  is export
{ * }

sub gst_caps_set_features_simple (GstCaps $caps, GstCapsFeatures $features)
  is native(gstreamer)
  is export
{ * }

# sub gst_caps_set_simple_valist (GstCaps $caps, Str $field, va_list $varargs)
#   is native(gstreamer)
#   is export
# { * }

sub gst_caps_set_value (GstCaps $caps, Str $field, GValue $value)
  is native(gstreamer)
  is export
{ * }

sub gst_caps_simplify (GstCaps $caps)
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

sub gst_caps_steal_structure (GstCaps $caps, guint $index)
  returns GstStructure
  is native(gstreamer)
  is export
{ * }

sub gst_caps_subtract (GstCaps $minuend, GstCaps $subtrahend)
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

sub gst_caps_to_string (GstCaps $caps)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_caps_truncate (GstCaps $caps)
  returns GstCaps
  is native(gstreamer)
  is export
{ * }
