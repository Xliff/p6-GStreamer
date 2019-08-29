use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::Structure;

use GStreamer::Raw::Subs;

use GTK::Compat::Value;

class GStreamer::Structure {
  has GstStructure $!s handles <type>;

  submethod BUILD (:$structure) {
    $!s = $structure;
  }

  method GStreamer::Raw::Types::GstStructure
  { $!s }

  method new (GstStructure $structure) {
    self.bless( :$structure );
  }

  method new_empty (Str() $name) {
    self.bless( structure => gst_structure_new_empty($name) );
  }

  method new_from_string (Str() $desc) {
    self.bless( structure => gst_structure_new_from_string($desc) );
  }

  proto method from_string (|)
  { * }

  multi method from_string (Str() $desc) {
    my $es = CArray[Str].new;

    $es[0] = Str;
    samewith($desc, $es);
  }
  multi method from_string (Str() $desc, CArray[Str] $end) {
    self.bless( structure => gst_structure_from_string($desc, $end) );
  }

  method new_id_empty (Int() $quark) {
    my GQuark $q = $quark;

    gst_structure_new_id_empty($q);
  }

  method name is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_structure_get_name($!s);
      },
      STORE => sub ($, $name is copy) {
        gst_structure_set_name($!s, $name);
      }
    );
  }

  proto method can_intersect (|)
  { * }

  multi method can_intersect (GstStructure() $struct2) {
    GStreamer::Structure.can_intersect($!s, $struct2);
  }
  multi method can_intersect (
    GStreamer::Structure:U:
    GstStructure $s1, GstStructure $s2
  ) {
    so gst_structure_can_intersect($s1, $s2);
  }

  method copy (:$raw = False) {
    my $s = gst_structure_copy($!s);

    $s ??
      ( $raw ?? $s !! GStreamer::Structure.new($s) )
      !!
      Nil;
  }

  multi method clear {
    GStreamer::Structure.clear($!s);
  }
  multi method clear (
    GStreamer::Structure:U:
    GstStructure $s
  ) {
    gst_clear_structure($s);
  }

  method filter_and_map_in_place (
    GstStructureFilterMapFunc $func,
    gpointer $user_data = gpointer
  ) {
    gst_structure_filter_and_map_in_place($!s, $func, $user_data);
  }

  method fixate {
    gst_structure_fixate($!s);
  }

  method fixate_field (Str() $field_name) {
    gst_structure_fixate_field($!s, $field_name);
  }

  method fixate_field_boolean (Str() $field_name, Int() $target) {
    my gboolean $t = $target;

    gst_structure_fixate_field_boolean($!s, $field_name, $t);
  }

  method fixate_field_nearest_double (Str() $field_name, Num() $target) {
    my gdouble $t = $target;

    gst_structure_fixate_field_nearest_double($!s, $field_name, $target);
  }

  method fixate_field_nearest_fraction (
    Str() $field_name,
    Int() $target_numerator,
    Int() $target_denominator
  ) {
    my gint ($tn, $td) = ($target_numerator, $target_denominator);

    gst_structure_fixate_field_nearest_fraction($!s, $field_name, $tn, $td);
  }

  method fixate_field_nearest_int (Str() $field_name, Int() $target) {
    my gint $t = $target;

    gst_structure_fixate_field_nearest_int($!s, $field_name, $t);
  }

  method fixate_field_string (Str() $field_name, Str() $target) {
    gst_structure_fixate_field_string($!s, $field_name, $target);
  }

  method foreach (
    GstStructureForeachFunc $func,
    gpointer $user_data = gpointer
  ) {
    gst_structure_foreach($!s, $func, $user_data);
  }

  multi method free {
    GStreamer::Structure.free($!s);
  }
  multi method free (
    GStreamer::Structure:U:
    GstStructure $s
  ) {
    gst_structure_free($s);
  }

  method get_array (Str() $fieldname, $array is rw) {
    my $aa = CArray[Pointer[GValueArray]].new;

    $aa[0] = Pointer[GValueArray].new;
    gst_structure_get_array($!s, $fieldname, $array);
    ($array) = ppr($aa);
  }

  method get_boolean (Str() $fieldname, $value is rw) {
    my gboolean $v = 0;

    gst_structure_get_boolean($!s, $fieldname, $value);
    $value = $v;
  }

  method get_clock_time (Str() $fieldname, $value is rw) {
    my GstClockTime $v = 0;

    gst_structure_get_clock_time($!s, $fieldname, $v);
    $value = $v;
  }

  method get_date (Str() $fieldname, $value is rw) {
    my $v = CArray[Pointer[GDate]].new;

    $v[0] = Pointer[GDate].new;
    gst_structure_get_date($!s, $fieldname, $v);
    ($value) = ppr($v);
  }

  method get_date_time (Str() $fieldname, $value is rw) {
    my $v = CArray[GstDateTime];

    $v[0] = GstDateTime;
    gst_structure_get_date_time($!s, $fieldname, $v);
    ($value) = ppr($v);
  }

  method get_double (Str() $fieldname, $value is rw) {
    my gdouble $v = 0e0;

    gst_structure_get_double($!s, $fieldname, $v);
    $value = $v;
  }

  method get_enum (Str() $fieldname, Int() $enumtype, $value is rw) {
    my gint $v = 0;
    my GType $et = $enumtype;

    gst_structure_get_enum($!s, $fieldname, $et, $v);
  }

  method get_field_type (Str() $fieldname) {
    GTypeEnum( gst_structure_get_field_type($!s, $fieldname) );
  }

  method get_flagset (
    Str() $fieldname,
    $value_flags is rw,
    $value_mask is rw
  ) {
    my guint ($vf, $vm) = 0 xx 2;

    gst_structure_get_flagset($!s, $fieldname, $vf, $vm);
    ($value_flags, $value_mask) = ($vf, $vm);
  }

  method get_fraction (
    Str() $fieldname,
    $value_numerator is rw,
    $value_denominator is rw
  ) {
    my gint ($vn, $vd) = 0 xx 2;

    gst_structure_get_fraction($!s, $fieldname, $vn, $vd);
    ($value_numerator, $value_denominator) = ($vn, $vd);
  }

  method get_int (Str() $fieldname, $value is rw) {
    my gint $v = 0;

    gst_structure_get_int($!s, $fieldname, $value);
    $value = $v;
  }

  method get_int64 (Str() $fieldname, $value is rw) {
    my gint64 $v = 0;

    gst_structure_get_int64($!s, $fieldname, $v);
    $value = $v;
  }

  method get_list (Str() $fieldname, $array is rw) {
    my $a = CArray[Pointer[GValueArray]];

    $a[0] = Pointer[GValueArray].new;
    gst_structure_get_list($!s, $fieldname, $array);
    ($array) = ppr($a);
  }

  method get_name_id {
    gst_structure_get_name_id($!s);
  }

  method get_string (Str() $fieldname) {
    gst_structure_get_string($!s, $fieldname);
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_structure_get_type, $n, $t );
  }

  method get_uint (Str() $fieldname, $value is rw) {
    my guint $v = 0;

    gst_structure_get_uint($!s, $fieldname, $v);
    $value = $v;
  }

  method get_uint64 (Str() $fieldname, $value is rw) {
    my guint64 $v = 0;

    gst_structure_get_uint64($!s, $fieldname, $value);
    $value = $v;
  }

  # method get_valist (Str $first_fieldname, va_list $args) {
  #   gst_structure_get_valist($!s, $first_fieldname, $args);
  # }

  method get_value (Str() $fieldname, :$raw = False) {
    my $v = gst_structure_get_value($!s, $fieldname);

    $v ??
      ( $raw ?? $v !! GTK::Compat::Value.new($v) )
      !!
      Nil;
  }

  method has_field (Str() $fieldname) {
    gst_structure_has_field($!s, $fieldname);
  }

  method has_field_typed (Str() $fieldname, Int() $type) {
    my GType $t = $type;

    so gst_structure_has_field_typed($!s, $fieldname, $t);
  }

  method has_name (Str() $name) {
    so gst_structure_has_name($!s, $name);
  }

  # method id_get_valist (GQuark $first_field_id, va_list $args) {
  #   gst_structure_id_get_valist($!s, $first_field_id, $args);
  # }

  method id_get_value (Int() $field, :$raw = False) {
    my GQuark $f = $field;
    my $v = gst_structure_id_get_value($!s, $f);

    $v ??
      ( $raw ?? $v !! GTK::Compat::Value.new($v) )
      !!
      Nil;
  }

  method id_has_field (Int() $field) {
    my GQuark $f = $field;

    so gst_structure_id_has_field($!s, $f);
  }

  method id_has_field_typed (Int() $field, Int() $type) {
    my GQuark $f = $field;
    my GType $t = $type;

    so gst_structure_id_has_field_typed($!s, $f, $t);
  }

  # method id_set_valist (GQuark $fieldname, va_list $varargs) {
  #   gst_structure_id_set_valist($!s, $fieldname, $varargs);
  # }

  method id_set_value (Int() $field, GValue() $value) {
    my GQuark $f = $field;

    gst_structure_id_set_value($!s, $field, $value);
  }

  method id_take_value (Int() $field, GValue() $value) {
    my GQuark $f = $field;

    gst_structure_id_take_value($!s, $field, $value);
  }

  multi method intersect (GstStructure() $struct2) {
    GStreamer::Structure.intersect($!s, $struct2);
  }
  multi method intersect (
    GStreamer::Structure:U:
    GstStructure $s1, GstStructure $s2
  ) {
    so gst_structure_intersect($s1, $s2);
  }

  proto method is_equal (|)
  { * }

  multi method is_equal (
    GStreamer::Structure:U:
    GstStructure $s1, GstStructure $s2
  ) {
    GStreamer::Structure.is_equal($!s, $s2);
  }
  multi method is_equal (
    GStreamer::Structure:U:
    GstStructure $s1, GstStructure $s2
  ) {
    gst_structure_is_equal($s1, $s2);
  }

  proto method is_subset (|)
  { * }

  multi method is_subset (GstStructure() $superset) {
    GStreamer::Structure.is_subset($!s, $superset);
  }
  multi method is_subset (
    GStreamer::Structure:U:
    GstStructure $s1, GstStructure $s2
  ) {
    so gst_structure_is_subset($s1, $s2);
  }

  method map_in_place (
    GstStructureMapFunc $func,
    gpointer $user_data = gpointer
  ) {
    gst_structure_map_in_place($!s, $func, $user_data);
  }

  method n_fields {
    gst_structure_n_fields($!s);
  }

  # method new_valist (Str $firstfield, va_list $varargs) {
  #   gst_structure_new_valist($!s, $firstfield, $varargs);
  # }

  method nth_field_name (Int() $index) {
    my guint $i = $index;

    gst_structure_nth_field_name($!s, $i);
  }

  method remove_all_fields {
    gst_structure_remove_all_fields($!s);
  }

  method remove_field (Str() $fieldname) {
    gst_structure_remove_field($!s, $fieldname);
  }

  # method remove_fields_valist (Str() $fieldname, va_list $varargs) {
  #   gst_structure_remove_fields_valist($!s, $fieldname, $varargs);
  # }

  method set_array (Str() $fieldname, GValueArray() $array) {
    gst_structure_set_array($!s, $fieldname, $array);
  }

  method set_list (Str() $fieldname, GValueArray() $array) {
    gst_structure_set_list($!s, $fieldname, $array);
  }

  method set_parent_refcount (Int() $refcount) {
    my gint $rc = $refcount;

    gst_structure_set_parent_refcount($!s, $rc);
  }

  # method set_valist (Str() $fieldname, va_list $varargs) {
  #   gst_structure_set_valist($!s, $fieldname, $varargs);
  # }

  method set_value (Str() $fieldname, GValue() $value) {
    gst_structure_set_value($!s, $fieldname, $value);
  }

  method take_value (Str() $fieldname, GValue() $value) {
    gst_structure_take_value($!s, $fieldname, $value);
  }

  method to_string {
    gst_structure_to_string($!s);
  }

}
