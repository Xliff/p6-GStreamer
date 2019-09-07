use v6.c;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::Value;

use GTK::Compat::Value;

class GStreamer::Value is GTK::Compat::Value {

  method bitmask is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_value_get_bitmask( GStreamer::Value.bitmask_get_type );
      },
      STORE => sub ($, Int() $bitmask is copy) {
        my uint64 $b = $bitmask;

        gst_value_set_bitmask(self.gvalue, $b);
      }
    );
  }

  method caps is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_value_get_caps( GStreamer::Caps.get_type );
      },
      STORE => sub ($, GstCaps() $caps is copy) {
        gst_value_set_caps(self.gvalue, $caps);
      }
    );
  }

  method caps_features is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_value_get_caps_features( GStreamer::CapsFeatures.get_type );
      },
      STORE => sub ($, GstCapsFeatures() $features is copy) {
        gst_value_set_caps_features(self.gvalue, $features);
      }
    );
  }

  method structure is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_value_get_structure( GStreamer::Structure.get_type );
      },
      STORE => sub ($, GstStructure() $structure is copy) {
        gst_value_set_structure(self.gvalue, $structure);
      }
    );
  }

  method array_append_and_take_value (GValue() $append_value) {
    gst_value_array_append_and_take_value(self.gvalue, $append_value);
  }

  method array_append_value (GValue() $append_value) {
    gst_value_array_append_value(self.gvalue, $append_value);
  }

  method array_get_size {
    gst_value_array_get_size(self.gvalue);
  }

  method array_get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name ~ '-Array',
      &gst_value_array_get_type,
      $n,
      $t
    );
  }

  method array_get_value (Int() $index) {
    my guint $i = $index;

    gst_value_array_get_value(self.gvalue, $i);
  }

  method array_prepend_value (GValue() $prepend_value) {
    gst_value_array_prepend_value(self.gvalue, $prepend_value);
  }

  method can_compare (GValue() $value2) {
    so gst_value_can_compare(self.gvalue, $value2);
  }

  method can_intersect (GValue() $value2) {
    so gst_value_can_intersect(self.gvalue, $value2);
  }

  method can_subtract (GValue() $subtrahend) {
    so gst_value_can_subtract(self.gvalue, $subtrahend);
  }

  method can_union (GValue() $value2) {
    so gst_value_can_union(self.gvalue, $value2);
  }

  method compare (GValue() $value2) {
    gst_value_compare(self.gvalue, $value2);
  }

  method deserialize (Str() $src) {
    so gst_value_deserialize(self.gvalue, $src);
  }

  method fixate (GValue() $src) {
    so gst_value_fixate(self.gvalue, $src);
  }

  method fraction_multiply (GValue() $factor1, GValue() $factor2) {
    so gst_value_fraction_multiply(self.gvalue, $factor1, $factor2);
  }

  method fraction_subtract (GValue() $minuend, GValue() $subtrahend) {
    so gst_value_fraction_subtract(self.gvalue, $minuend, $subtrahend);
  }

  method get_double_range_max {
    gst_value_get_double_range_max(self.gvalue);
  }

  method get_double_range_min {
    gst_value_get_double_range_min(self.gvalue);
  }

  method get_flagset_flags {
    gst_value_get_flagset_flags(self.gvalue);
  }

  method get_flagset_mask {
    gst_value_get_flagset_mask(self.gvalue);
  }

  method get_fraction_denominator {
    gst_value_get_fraction_denominator(self.gvalue);
  }

  method get_fraction_numerator {
    gst_value_get_fraction_numerator(self.gvalue);
  }

  method get_fraction_range_max (:$raw = False) {
    my $v = gst_value_get_fraction_range_max(self.gvalue);

    $v ??
      ( $raw ?? $v !! GStreamer::Value.new($v) )
      !!
      Nil;
  }

  method get_fraction_range_min (:$raw = False) {
    my $v = gst_value_get_fraction_range_min(self.gvalue);

    $v ??
      ( $raw ?? $v !! GStreamer::Value.new($v) )
      !!
      Nil;
  }

  method get_int64_range_max {
    gst_value_get_int64_range_max(self.gvalue);
  }

  method get_int64_range_min {
    gst_value_get_int64_range_min(self.gvalue);
  }

  method get_int64_range_step {
    gst_value_get_int64_range_step(self.gvalue);
  }

  method get_int_range_max {
    gst_value_get_int_range_max(self.gvalue);
  }

  method get_int_range_min {
    gst_value_get_int_range_min(self.gvalue);
  }

  method get_int_range_step {
    gst_value_get_int_range_step(self.gvalue);
  }

  method bitmask_get_type (GStreamer::Value:U:) {
    state ($n, $t);

    unstable_get_type(
      self.^name ~ '-Bitmask',
      &gst_bitmask_get_type,
      $n,
      $t
    );
  }

  method double_range_get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name ~ '-DoubleRange',
      &gst_double_range_get_type,
      $n,
      $t
    );
  }

  method flagset_get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name ~ '-Flagset',
      &gst_flagset_get_type,
      $n,
      $t
    );
  }

  method flagset_register {
    gst_flagset_register(self.gvalue);
  }

  method fraction_get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name ~ '-Fraction',
      &gst_fraction_get_type,
      $n,
      $t
    );
  }

  method fraction_range_get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name ~ '-FractionRange',
      &gst_fraction_range_get_type,
      $n,
      $t
    );
  }

  method g_thread_get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name ~ '-GThread',
      &gst_g_thread_get_type,
      $n,
      $t
    );
  }

  method int64_range_get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name ~ '-Int64Range',
      &gst_int64_range_get_type,
      $n,
      $t
    );
  }

  method int_range_get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name ~ '-IntRange',
      &gst_int_range_get_type,
      $n,
      $t
    );
  }

  method init_and_copy (
    GStreamer::Value:U:
    GValue() $dest,
    GValue() $src
  ) {
    gst_value_init_and_copy($dest, $src);
  }

  method intersect (GValue() $value1, GValue $value2) {
    so gst_value_intersect(self.gvalue, $value1, $value2);
  }

  method is_fixed {
    so gst_value_is_fixed(self.gvalue);
  }

  method is_subset (GValue() $value2) {
    so gst_value_is_subset(self.gvalue, $value2);
  }

  method list_append_and_take_value (GValue() $append_value) {
    gst_value_list_append_and_take_value(self.gvalue, $append_value);
  }

  method list_append_value (GValue() $append_value) {
    gst_value_list_append_value(self.gvalue, $append_value);
  }

  method list_concat (GValue() $value1, GValue() $value2) {
    gst_value_list_concat(self.gvalue, $value1, $value2);
  }

  method list_get_size {
    gst_value_list_get_size(self.gvalue);
  }

  method list_get_type {
    state ($n, $t);

    unstable_get_type(
      self.^name ~ '-List',
      &gst_value_list_get_type,
      $n,
      $t
    );
  }

  method list_get_value (Int() $index) {
    my guint $i = $index;

    gst_value_list_get_value(self.gvalue, $i);
  }

  method list_merge (GValue() $value1, GValue() $value2) {
    gst_value_list_merge(self.gvalue, $value1, $value2);
  }

  method list_prepend_value (GValue() $prepend_value) {
    gst_value_list_prepend_value(self.gvalue, $prepend_value);
  }

  # method register (GValueTable $table) {
  #   gst_value_register($table);
  # }

  method serialize {
    gst_value_serialize(self.gvalue);
  }

  method set_double_range (Num() $start, Num() $end) {
    my gdouble ($s, $e) = ($start, $end);

    gst_value_set_double_range(self.gvalue, $s, $e);
  }

  method set_flagset (Int() $flags, Int() $mask) {
    my guint ($f, $m) = ($flags, $mask);

    gst_value_set_flagset(self.gvalue, $f, $m);
  }

  method set_fraction (gint $numerator, gint $denominator) {
    my gint ($n, $d) = ($numerator, $denominator);

    gst_value_set_fraction(self.gvalue, $n, $d);
  }

  method set_fraction_range (GValue() $start, GValue() $end) {
    gst_value_set_fraction_range(self.gvalue, $start, $end);
  }

  method set_fraction_range_full (
    Int() $numerator_start,
    Int() $denominator_start,
    Int() $numerator_end,
    Int() $denominator_end
  ) {
    my gint ($ns, $ds, $ne, $de) = (
      $numerator_start,
      $denominator_start,
      $numerator_end,
      $denominator_end
    );

    gst_value_set_fraction_range_full(self.gvalue, $ns, $ds, $ne, $de);
  }

  method set_int64_range (Int() $start, Int() $end) {
    my gint64 ($s, $e) = ($start, $end);

    gst_value_set_int64_range(self.gvalue, $start, $end);
  }

  method set_int64_range_step (Int() $start, Int() $end, Int() $step) {
    my gint64 ($st, $e, $sp) = ($start, $end,  $step);

    gst_value_set_int64_range_step(self.gvalue, $start, $end, $step);
  }

  method set_int_range (Int() $start, Int() $end) {
    my gint ($s, $e) = ($start, $end);

    gst_value_set_int_range(self.gvalue, $s, $e);
  }

  method set_int_range_step (Int() $start, Int() $end, Int() $step) {
    my gint ($st, $e, $sp) = ($start, $end,  $step);

    gst_value_set_int_range_step(self.gvalue, $st, $e, $sp);
  }

  method subtract (GValue() $minuend, GValue() $subtrahend) {
    so gst_value_subtract(self.gvalue, $minuend, $subtrahend);
  }

  method union (GValue() $value1, GValue() $value2) {
    so gst_value_union(self.gvalue, $value1, $value2);
  }

}
