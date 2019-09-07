use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GStreamer::Raw::Types;

unit package GStreamer::Raw::Value;

sub gst_value_array_append_and_take_value (GValue $value, GValue $append_value)
  is native(gstreamer)
  is export
{ * }

sub gst_value_array_append_value (GValue $value, GValue $append_value)
  is native(gstreamer)
  is export
{ * }

sub gst_value_array_get_size (GValue $value)
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_value_array_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_value_array_get_value (GValue $value, guint $index)
  returns GValue
  is native(gstreamer)
  is export
{ * }

sub gst_value_array_prepend_value (GValue $value, GValue $prepend_value)
  is native(gstreamer)
  is export
{ * }

sub gst_value_can_compare (GValue $value1, GValue $value2)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_value_can_intersect (GValue $value1, GValue $value2)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_value_can_subtract (GValue $minuend, GValue $subtrahend)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_value_can_union (GValue $value1, GValue $value2)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_value_compare (GValue $value1, GValue $value2)
  returns gint
  is native(gstreamer)
  is export
{ * }

sub gst_value_deserialize (GValue $dest, Str $src)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_value_fixate (GValue $dest, GValue $src)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_value_fraction_multiply (
  GValue $product,
  GValue $factor1,
  GValue $factor2
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_value_fraction_subtract (
  GValue $dest,
  GValue $minuend,
  GValue $subtrahend
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_value_get_double_range_max (GValue $value)
  returns gdouble
  is native(gstreamer)
  is export
{ * }

sub gst_value_get_double_range_min (GValue $value)
  returns gdouble
  is native(gstreamer)
  is export
{ * }

sub gst_value_get_flagset_flags (GValue $value)
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_value_get_flagset_mask (GValue $value)
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_value_get_fraction_denominator (GValue $value)
  returns gint
  is native(gstreamer)
  is export
{ * }

sub gst_value_get_fraction_numerator (GValue $value)
  returns gint
  is native(gstreamer)
  is export
{ * }

sub gst_value_get_fraction_range_max (GValue $value)
  returns GValue
  is native(gstreamer)
  is export
{ * }

sub gst_value_get_fraction_range_min (GValue $value)
  returns GValue
  is native(gstreamer)
  is export
{ * }

sub gst_value_get_int64_range_max (GValue $value)
  returns gint64
  is native(gstreamer)
  is export
{ * }

sub gst_value_get_int64_range_min (GValue $value)
  returns gint64
  is native(gstreamer)
  is export
{ * }

sub gst_value_get_int64_range_step (GValue $value)
  returns gint64
  is native(gstreamer)
  is export
{ * }

sub gst_value_get_int_range_max (GValue $value)
  returns gint
  is native(gstreamer)
  is export
{ * }

sub gst_value_get_int_range_min (GValue $value)
  returns gint
  is native(gstreamer)
  is export
{ * }

sub gst_value_get_int_range_step (GValue $value)
  returns gint
  is native(gstreamer)
  is export
{ * }

sub gst_bitmask_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_double_range_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_flagset_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_flagset_register (GType $flags_type)
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_fraction_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_fraction_range_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_g_thread_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_int64_range_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_int_range_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_value_init_and_copy (GValue $dest, GValue $src)
  is native(gstreamer)
  is export
{ * }

sub gst_value_intersect (GValue $dest, GValue $value1, GValue $value2)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_value_is_fixed (GValue $value)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_value_is_subset (GValue $value1, GValue $value2)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_value_list_append_and_take_value (GValue $value, GValue $append_value)
  is native(gstreamer)
  is export
{ * }

sub gst_value_list_append_value (GValue $value, GValue $append_value)
  is native(gstreamer)
  is export
{ * }

sub gst_value_list_concat (GValue $dest, GValue $value1, GValue $value2)
  is native(gstreamer)
  is export
{ * }

sub gst_value_list_get_size (GValue $value)
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_value_list_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_value_list_get_value (GValue $value, guint $index)
  returns GValue
  is native(gstreamer)
  is export
{ * }

sub gst_value_list_merge (GValue $dest, GValue $value1, GValue $value2)
  is native(gstreamer)
  is export
{ * }

sub gst_value_list_prepend_value (GValue $value, GValue $prepend_value)
  is native(gstreamer)
  is export
{ * }

# sub gst_value_register (GstValueTable $table)
#   is native(gstreamer)
#   is export
# { * }

sub gst_value_serialize (GValue $value)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_value_set_double_range (GValue $value, gdouble $start, gdouble $end)
  is native(gstreamer)
  is export
{ * }

sub gst_value_set_flagset (GValue $value, guint $flags, guint $mask)
  is native(gstreamer)
  is export
{ * }

sub gst_value_set_fraction (GValue $value, gint $numerator, gint $denominator)
  is native(gstreamer)
  is export
{ * }

sub gst_value_set_fraction_range (GValue $value, GValue $start, GValue $end)
  is native(gstreamer)
  is export
{ * }

sub gst_value_set_fraction_range_full (
  GValue $value,
  gint $numerator_start,
  gint $denominator_start,
  gint $numerator_end,
  gint $denominator_end
)
  is native(gstreamer)
  is export
{ * }

sub gst_value_set_int64_range (GValue $value, gint64 $start, gint64 $end)
  is native(gstreamer)
  is export
{ * }

sub gst_value_set_int64_range_step (
  GValue $value,
  gint64 $start,
  gint64 $end,
  gint64 $step
)
  is native(gstreamer)
  is export
{ * }

sub gst_value_set_int_range (GValue $value, gint $start, gint $end)
  is native(gstreamer)
  is export
{ * }

sub gst_value_set_int_range_step (
  GValue $value,
  gint $start,
  gint $end,
  gint $step
)
  is native(gstreamer)
  is export
{ * }

sub gst_value_subtract (GValue $dest, GValue $minuend, GValue $subtrahend)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_value_union (GValue $dest, GValue $value1, GValue $value2)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_value_get_bitmask (GValue $value)
  returns guint64
  is native(gstreamer)
  is export
{ * }

sub gst_value_get_caps (GValue $value)
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

sub gst_value_get_caps_features (GValue $value)
  returns GstCapsFeatures
  is native(gstreamer)
  is export
{ * }

sub gst_value_get_structure (GValue $value)
  returns GstStructure
  is native(gstreamer)
  is export
{ * }

sub gst_value_set_bitmask (GValue $value, guint64 $bitmask)
  is native(gstreamer)
  is export
{ * }

sub gst_value_set_caps (GValue $value, GstCaps $caps)
  is native(gstreamer)
  is export
{ * }

sub gst_value_set_caps_features (GValue $value, GstCapsFeatures $features)
  is native(gstreamer)
  is export
{ * }

sub gst_value_set_structure (GValue $value, GstStructure $structure)
  is native(gstreamer)
  is export
{ * }
