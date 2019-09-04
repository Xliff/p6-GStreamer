use v6.c;

use Method::Also;

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

  multi method new (GstStructure $structure) {
    self.bless( :$structure );
  }

  multi method new(
    $name is copy,
    *%pairs where *.keys.all ne <
      empty
      from_string from-string
      id_empty    id-$empty
    >.any
  ) {
    die '<name> parameter must be Str-compatible!'
      unless $name.^can('Str').elems;
    $name .= Str unless $name ~~ Str;

    # Callier is responsible for assigning proper values.
    die 'The values in %pairs must only contain GValue-compatible elements!'
      unless %pairs.values.all ~~ (GTK::Compat::Value, GValues).any;

    my $o = ::?CLASS.new_empty($name);
    $o.set_value(.key, .value) for %pairs.pairs;
    $o;
  }

  multi method new (Str() $name, :$empty is required, *%pairs) {
    die qq:to/DIE/ if %pairs;
      Hash key "empty" is reserved! Please do { ''
      } NOT use them in your key-value specifications!
      If you must use these key names, you can add them later using the { ''
      } appropriate set function.
      DIE

    ::?CLASS.new_empty($name);
  }
  method new_empty (Str() $name) is also<new-empty> {
    self.bless( structure => gst_structure_new_empty($name) );
  }

  multi method new (
    Str() $desc,
    :from-string(:$from_string) is required,
    *%pairs
  ) {
    die qq:to/DIE/ if %pairs;
      Hash keys "from-string" and "from_string" are reserved! Please do { ''
      } NOT use them in your key-value specifications!
      If you must use these key names, you can add them later using the { ''
      } appropriate set function.
      DIE

    ::?CLASS.new_from_string($desc);
  }
  method new_from_string (Str() $desc) is also<new-from-string> {
    self.bless( structure => gst_structure_new_from_string($desc) );
  }

  multi method new (Int() $quark, :id-empty($id_empty) is required) {
    ::?CLASS.new_id_empty($quark);
  }
  method new_id_empty (Int() $quark) is also<new-id-empty> {
    my GQuark $q = $quark;

    self.bless( structure => gst_structure_new_id_empty($q) );
  }

  proto method from_string (|)
      is also<from-string>
  { * }

  multi method from_string (Str() $desc) {
    my $es = CArray[Str].new;

    $es[0] = Str;
    samewith($desc, $es);
  }
  multi method from_string (Str() $desc, CArray[Str] $end) {
    self.bless( structure => gst_structure_from_string($desc, $end) );
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
      is also<can-intersect>
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
  )
    is also<filter-and-map-in-place>
  {
    gst_structure_filter_and_map_in_place($!s, $func, $user_data);
  }

  method fixate {
    gst_structure_fixate($!s);
  }

  method fixate_field (Str() $field_name) is also<fixate-field> {
    gst_structure_fixate_field($!s, $field_name);
  }

  method fixate_field_boolean (Str() $field_name, Int() $target)
    is also<fixate-field-boolean>
  {
    my gboolean $t = $target;

    gst_structure_fixate_field_boolean($!s, $field_name, $t);
  }

  method fixate_field_nearest_double (Str() $field_name, Num() $target)
    is also<fixate-field-nearest-double>
  {
    my gdouble $t = $target;

    gst_structure_fixate_field_nearest_double($!s, $field_name, $target);
  }

  method fixate_field_nearest_fraction (
    Str() $field_name,
    Int() $target_numerator,
    Int() $target_denominator
  )
    is also<fixate-field-nearest-fraction>
  {
    my gint ($tn, $td) = ($target_numerator, $target_denominator);

    gst_structure_fixate_field_nearest_fraction($!s, $field_name, $tn, $td);
  }

  method fixate_field_nearest_int (Str() $field_name, Int() $target)
    is also<fixate-field-nearest-int>
  {
    my gint $t = $target;

    gst_structure_fixate_field_nearest_int($!s, $field_name, $t);
  }

  method fixate_field_string (Str() $field_name, Str() $target)
    is also<fixate-field-string>
  {
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

  method get_array (Str() $fieldname, $array is rw) is also<get-array> {
    my $aa = CArray[Pointer[GValueArray]].new;

    $aa[0] = Pointer[GValueArray].new;
    gst_structure_get_array($!s, $fieldname, $array);
    ($array) = ppr($aa);
  }

  method get_boolean (Str() $fieldname, $value is rw) is also<get-boolean> {
    my gboolean $v = 0;

    gst_structure_get_boolean($!s, $fieldname, $value);
    $value = $v;
  }

  method get_clock_time (Str() $fieldname, $value is rw)
    is also<get-clock-time>
  {
    my GstClockTime $v = 0;

    gst_structure_get_clock_time($!s, $fieldname, $v);
    $value = $v;
  }

  method get_date (Str() $fieldname, $value is rw) is also<get-date> {
    my $v = CArray[Pointer[GDate]].new;

    $v[0] = Pointer[GDate].new;
    gst_structure_get_date($!s, $fieldname, $v);
    ($value) = ppr($v);
  }

  method get_date_time (Str() $fieldname, $value is rw)
    is also<get-date-time>
  {
    my $v = CArray[GstDateTime];

    $v[0] = GstDateTime;
    gst_structure_get_date_time($!s, $fieldname, $v);
    ($value) = ppr($v);
  }

  method get_double (Str() $fieldname, $value is rw) is also<get-double> {
    my gdouble $v = 0e0;

    gst_structure_get_double($!s, $fieldname, $v);
    $value = $v;
  }

  method get_enum (Str() $fieldname, Int() $enumtype, $value is rw)
    is also<get-enum>
  {
    my gint $v = 0;
    my GType $et = $enumtype;

    gst_structure_get_enum($!s, $fieldname, $et, $v);
  }

  method get_field_type (Str() $fieldname) is also<get-field-type> {
    GTypeEnum( gst_structure_get_field_type($!s, $fieldname) );
  }

  method get_flagset (
    Str() $fieldname,
    $value_flags is rw,
    $value_mask is rw
  )
    is also<get-flagset>
  {
    my guint ($vf, $vm) = 0 xx 2;

    gst_structure_get_flagset($!s, $fieldname, $vf, $vm);
    ($value_flags, $value_mask) = ($vf, $vm);
  }

  method get_fraction (
    Str() $fieldname,
    $value_numerator is rw,
    $value_denominator is rw
  )
    is also<get-fraction>
  {
    my gint ($vn, $vd) = 0 xx 2;

    gst_structure_get_fraction($!s, $fieldname, $vn, $vd);
    ($value_numerator, $value_denominator) = ($vn, $vd);
  }

  method get_int (Str() $fieldname, $value is rw) is also<get-int> {
    my gint $v = 0;

    gst_structure_get_int($!s, $fieldname, $value);
    $value = $v;
  }

  method get_int64 (Str() $fieldname, $value is rw) is also<get-int64> {
    my gint64 $v = 0;

    gst_structure_get_int64($!s, $fieldname, $v);
    $value = $v;
  }

  method get_list (Str() $fieldname, $array is rw) is also<get-list> {
    my $a = CArray[Pointer[GValueArray]];

    $a[0] = Pointer[GValueArray].new;
    gst_structure_get_list($!s, $fieldname, $array);
    ($array) = ppr($a);
  }

  method get_name_id is also<get-name-id> {
    gst_structure_get_name_id($!s);
  }

  method get_string (Str() $fieldname) is also<get-string> {
    gst_structure_get_string($!s, $fieldname);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_structure_get_type, $n, $t );
  }

  method get_uint (Str() $fieldname, $value is rw) is also<get-uint> {
    my guint $v = 0;

    gst_structure_get_uint($!s, $fieldname, $v);
    $value = $v;
  }

  method get_uint64 (Str() $fieldname, $value is rw) is also<get-uint64> {
    my guint64 $v = 0;

    gst_structure_get_uint64($!s, $fieldname, $value);
    $value = $v;
  }

  # method get_valist (Str $first_fieldname, va_list $args) {
  #   gst_structure_get_valist($!s, $first_fieldname, $args);
  # }

  method get_value (Str() $fieldname, :$raw = False) is also<get-value> {
    my $v = gst_structure_get_value($!s, $fieldname);

    $v ??
      ( $raw ?? $v !! GTK::Compat::Value.new($v) )
      !!
      Nil;
  }

  method has_field (Str() $fieldname) is also<has-field> {
    gst_structure_has_field($!s, $fieldname);
  }

  method has_field_typed (Str() $fieldname, Int() $type)
    is also<has-field-typed>
  {
    my GType $t = $type;

    so gst_structure_has_field_typed($!s, $fieldname, $t);
  }

  method has_name (Str() $name) is also<has-name> {
    so gst_structure_has_name($!s, $name);
  }

  # method id_get_valist (GQuark $first_field_id, va_list $args) {
  #   gst_structure_id_get_valist($!s, $first_field_id, $args);
  # }

  method id_get_value (Int() $field, :$raw = False) is also<id-get-value> {
    my GQuark $f = $field;
    my $v = gst_structure_id_get_value($!s, $f);

    $v ??
      ( $raw ?? $v !! GTK::Compat::Value.new($v) )
      !!
      Nil;
  }

  method id_has_field (Int() $field) is also<id-has-field> {
    my GQuark $f = $field;

    so gst_structure_id_has_field($!s, $f);
  }

  method id_has_field_typed (Int() $field, Int() $type)
    is also<id-has-field-typed>
  {
    my GQuark $f = $field;
    my GType $t = $type;

    so gst_structure_id_has_field_typed($!s, $f, $t);
  }

  # method id_set_valist (GQuark $fieldname, va_list $varargs) {
  #   gst_structure_id_set_valist($!s, $fieldname, $varargs);
  # }

  method id_set_value (Int() $field, GValue() $value) is also<id-set-value> {
    my GQuark $f = $field;

    gst_structure_id_set_value($!s, $field, $value);
  }

  method id_take_value (Int() $field, GValue() $value) is also<id-take-value> {
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
      is also<is-equal>
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
      is also<is-subset>
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
  )
    is also<map-in-place>
  {
    gst_structure_map_in_place($!s, $func, $user_data);
  }

  method n_fields
    is also<
      n-fields
      elems
    >
  {
    gst_structure_n_fields($!s);
  }

  # method new_valist (Str $firstfield, va_list $varargs) {
  #   gst_structure_new_valist($!s, $firstfield, $varargs);
  # }

  method nth_field_name (Int() $index) is also<nth-field-name> {
    my guint $i = $index;

    gst_structure_nth_field_name($!s, $i);
  }

  method remove_all_fields is also<remove-all-fields> {
    gst_structure_remove_all_fields($!s);
  }

  method remove_field (Str() $fieldname) is also<remove-field> {
    gst_structure_remove_field($!s, $fieldname);
  }

  # method remove_fields_valist (Str() $fieldname, va_list $varargs) {
  #   gst_structure_remove_fields_valist($!s, $fieldname, $varargs);
  # }

  method set_array (Str() $fieldname, GValueArray() $array)
    is also<set-array>
  {
    gst_structure_set_array($!s, $fieldname, $array);
  }

  method set_list (Str() $fieldname, GValueArray() $array) is also<set-list> {
    gst_structure_set_list($!s, $fieldname, $array);
  }

  method set_parent_refcount (Int() $refcount) is also<set-parent-refcount> {
    my gint $rc = $refcount;

    gst_structure_set_parent_refcount($!s, $rc);
  }

  # method set_valist (Str() $fieldname, va_list $varargs) {
  #   gst_structure_set_valist($!s, $fieldname, $varargs);
  # }

  method set_value (Str() $fieldname, GValue() $value) is also<set-value> {
    gst_structure_set_value($!s, $fieldname, $value);
  }

  method take_value (Str() $fieldname, GValue() $value) is also<take-value> {
    gst_structure_take_value($!s, $fieldname, $value);
  }

  method to_string
    is also<
      to-string
      Str
    >
  {
    gst_structure_to_string($!s);
  }

}
