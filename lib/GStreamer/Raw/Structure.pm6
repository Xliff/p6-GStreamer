use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GStreamer::Raw::Types;

unit package GStreamer::Raw::Structure;

sub gst_structure_can_intersect (GstStructure $struct1, GstStructure $struct2)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_structure_copy (GstStructure $structure)
  returns GstStructure
  is native(gstreamer)
  is export
{ * }

sub gst_structure_filter_and_map_in_place (
  GstStructure $structure,
  GstStructureFilterMapFunc $func,
  gpointer $user_data
)
  is native(gstreamer)
  is export
{ * }

sub gst_structure_fixate (GstStructure $structure)
  is native(gstreamer)
  is export
{ * }

sub gst_structure_fixate_field (GstStructure $structure, Str $field_name)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_structure_fixate_field_boolean (
  GstStructure $structure, Str
  $field_name,
  gboolean $target
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_structure_fixate_field_nearest_double (
  GstStructure $structure,
  Str $field_name,
  gdouble $target
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_structure_fixate_field_nearest_fraction (
  GstStructure $structure,
  Str $field_name,
  gint $target_numerator,
  gint $target_denominator
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_structure_fixate_field_nearest_int (
  GstStructure $structure,
  Str $field_name,
  gint $target
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_structure_fixate_field_string (
  GstStructure $structure,
  Str $field_name,
  Str $target
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_structure_foreach (
  GstStructure $structure,
  &func (GQuark, GValue, Pointer --> gboolean),
  gpointer $user_data
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_structure_free (GstStructure $structure)
  is native(gstreamer)
  is export
{ * }

sub gst_structure_from_string (Str $string, CArray[Str] $end)
  returns GstStructure
  is native(gstreamer)
  is export
{ * }

sub gst_structure_get_array (
  GstStructure $structure,
  Str $fieldname,
  CArray[Pointer[GValueArray]] $array
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_structure_get_boolean (
  GstStructure $structure,
  Str $fieldname,
  gboolean $value is rw
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_structure_get_clock_time (
  GstStructure $structure,
  Str $fieldname,
  GstClockTime $value is rw
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_structure_get_date (
  GstStructure $structure,
  Str $fieldname,
  CArray[Pointer[GDate]] $value
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_structure_get_date_time (
  GstStructure $structure,
  Str $fieldname,
  CArray[GstDateTime] $value
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_structure_get_double (
  GstStructure $structure,
  Str $fieldname,
  gdouble $value is rw
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_structure_get_enum (
  GstStructure $structure,
  Str $fieldname,
  GType $enumtype,
  gint $value is rw
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_structure_get_field_type (GstStructure $structure, Str $fieldname)
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_structure_get_flagset (
  GstStructure $structure,
  Str $fieldname,
  guint $value_flags is rw,
  guint $value_mask  is rw
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_structure_get_fraction (
  GstStructure $structure,
  Str $fieldname,
  gint $value_numerator   is rw,
  gint $value_denominator is rw
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_structure_get_int (
  GstStructure $structure,
  Str $fieldname,
  gint $value is rw
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_structure_get_int64 (
  GstStructure $structure,
  Str $fieldname,
  gint64 $value is rw
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_structure_get_list (
  GstStructure $structure,
  Str $fieldname,
  CArray[Pointer[GValueArray]] $array
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_structure_get_name_id (GstStructure $structure)
  returns GQuark
  is native(gstreamer)
  is export
{ * }

sub gst_structure_get_string (GstStructure $structure, Str $fieldname)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_structure_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_structure_get_uint (
  GstStructure $structure,
  Str $fieldname,
  guint $value is rw
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_structure_get_uint64 (
  GstStructure $structure,
  Str $fieldname,
  guint64 $value is rw
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

# sub gst_structure_get_valist (
#   GstStructure $structure,
#   Str $first_fieldname,
#   va_list $args
# )
#   returns uint32
#   is native(gstreamer)
#   is export
# { * }

sub gst_structure_get_value (GstStructure $structure, Str $fieldname)
  returns GValue
  is native(gstreamer)
  is export
{ * }

sub gst_clear_structure (GstStructure $structure_ptr)
  is native(gstreamer)
  is export
{ * }

sub gst_structure_has_field (GstStructure $structure, Str $fieldname)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_structure_has_field_typed (
  GstStructure $structure,
  Str $fieldname,
  GType $type
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_structure_has_name (GstStructure $structure, Str $name)
  returns uint32
  is native(gstreamer)
  is export
{ * }

# sub gst_structure_id_get_valist (
#   GstStructure $structure,
#   GQuark $first_field_id,
#   va_list $args
# )
#   returns uint32
#   is native(gstreamer)
#   is export
# { * }

sub gst_structure_id_get_value (GstStructure $structure, GQuark $field)
  returns GValue
  is native(gstreamer)
  is export
{ * }

sub gst_structure_id_has_field (GstStructure $structure, GQuark $field)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_structure_id_has_field_typed (
  GstStructure $structure,
  GQuark $field,
  GType $type
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

# sub gst_structure_id_set_valist (
#   GstStructure $structure,
#   GQuark $fieldname,
#   va_list $varargs
# )
#   is native(gstreamer)
#   is export
# { * }

sub gst_structure_id_set_value (
  GstStructure $structure,
  GQuark $field,
  GValue $value
)
  is native(gstreamer)
  is export
{ * }

sub gst_structure_id_take_value (
  GstStructure $structure,
  GQuark $field,
  GValue $value
)
  is native(gstreamer)
  is export
{ * }

sub gst_structure_intersect (GstStructure $struct1, GstStructure $struct2)
  returns GstStructure
  is native(gstreamer)
  is export
{ * }

sub gst_structure_is_equal (GstStructure $structure1, GstStructure $structure2)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_structure_is_subset (GstStructure $subset, GstStructure $superset)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_structure_map_in_place (
  GstStructure $structure,
  GstStructureMapFunc $func,
  gpointer $user_data
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_structure_n_fields (GstStructure $structure)
  returns gint
  is native(gstreamer)
  is export
{ * }

sub gst_structure_new_empty (Str $name)
  returns GstStructure
  is native(gstreamer)
  is export
{ * }

sub gst_structure_new_from_string (Str $string)
  returns GstStructure
  is native(gstreamer)
  is export
{ * }

sub gst_structure_new_id_empty (GQuark $quark)
  returns GstStructure
  is native(gstreamer)
  is export
{ * }

# sub gst_structure_new_valist (Str $name, Str $firstfield, va_list $varargs)
#   returns GstStructure
#   is native(gstreamer)
#   is export
# { * }

sub gst_structure_nth_field_name (GstStructure $structure, guint $index)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_structure_remove_all_fields (GstStructure $structure)
  is native(gstreamer)
  is export
{ * }

sub gst_structure_remove_field (GstStructure $structure, Str $fieldname)
  is native(gstreamer)
  is export
{ * }

# sub gst_structure_remove_fields_valist (
#   GstStructure $structure,
#   Str $fieldname,
#   va_list $varargs
# )
#   is native(gstreamer)
#   is export
# { * }

sub gst_structure_set_array (
  GstStructure $structure,
  Str $fieldname,
  GValueArray $array
)
  is native(gstreamer)
  is export
{ * }

sub gst_structure_set_list (
  GstStructure $structure,
  Str $fieldname,
  GValueArray $array
)
  is native(gstreamer)
  is export
{ * }

sub gst_structure_set_parent_refcount (GstStructure $structure, gint $refcount)
  returns uint32
  is native(gstreamer)
  is export
{ * }

# sub gst_structure_set_valist (
#   GstStructure $structure,
#   Str $fieldname,
#   va_list $varargs
# )
#   is native(gstreamer)
#   is export
# { * }

sub gst_structure_set_value (
  GstStructure $structure,
  Str $fieldname,
  GValue $value
)
  is native(gstreamer)
  is export
{ * }

sub gst_structure_take_value (
  GstStructure $structure,
  Str $fieldname, GValue $value
)
  is native(gstreamer)
  is export
{ * }

sub gst_structure_to_string (GstStructure $structure)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_structure_get_name (GstStructure $structure)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_structure_set_name (GstStructure $structure, Str $name)
  is native(gstreamer)
  is export
{ * }
