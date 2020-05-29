use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Value;

use GLib::Value;
use GStreamer::Caps;
use GStreamer::CapsFeatures;
use GStreamer::Structure;

class GStreamer::Value is GLib::Value {

  method bitmask is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_value_get_bitmask( self.gvalue );
      },
      STORE => sub ($, Int() $bitmask is copy) {
        my uint64 $b = $bitmask;

        gst_value_set_bitmask(self.gvalue, $b);
      }
    );
  }

  method caps (:$raw = False) is rw {
    Proxy.new(
      FETCH => sub ($) {
        my $c = gst_value_get_caps( self.gvalue );

        $c ??
          ( $raw ?? $c !! GStreamer::Caps.new($c) )
          !!
          Nil;
      },
      STORE => sub ($, GstCaps() $caps is copy) {
        gst_value_set_caps(self.gvalue, $caps);
      }
    );
  }

  method caps_features (:$raw = False) is rw is also<caps-features> {
    Proxy.new(
      FETCH => sub ($) {
        my $cf = gst_value_get_caps_features( self.gvalue );

        $cf ??
          ( $raw ?? $cf !! GStreamer::CapsFeatures.new($cf) )
          !!
          Nil;
      },
      STORE => sub ($, GstCapsFeatures() $features is copy) {
        gst_value_set_caps_features(self.gvalue, $features);
      }
    );
  }

  method structure (:$raw = False) is rw {
    Proxy.new(
      FETCH => sub ($) {
        my $s = gst_value_get_structure( self.gvalue );

        $s ??
          ( $raw ?? $s !! GStreamer::Structure.new($s) )
          !!
          Nil;
      },
      STORE => sub ($, GstStructure() $structure is copy) {
        gst_value_set_structure(self.gvalue, $structure);
      }
    );
  }

  method can_compare (GValue() $value2) is also<can-compare> {
    so gst_value_can_compare(self.gvalue, $value2);
  }

  method can_intersect (GValue() $value2) is also<can-intersect> {
    so gst_value_can_intersect(self.gvalue, $value2);
  }

  method can_subtract (GValue() $subtrahend) is also<can-subtract> {
    so gst_value_can_subtract(self.gvalue, $subtrahend);
  }

  method can_union (GValue() $value2) is also<can-union> {
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

  method fraction_multiply (GValue() $factor1, GValue() $factor2)
    is also<fraction-multiply>
  {
    so gst_value_fraction_multiply(self.gvalue, $factor1, $factor2);
  }

  method fraction_subtract (GValue() $minuend, GValue() $subtrahend)
    is also<fraction-subtract>
  {
    so gst_value_fraction_subtract(self.gvalue, $minuend, $subtrahend);
  }

  method get_double_range_max is also<get-double-range-max> {
    gst_value_get_double_range_max(self.gvalue);
  }

  method get_double_range_min is also<get-double-range-min> {
    gst_value_get_double_range_min(self.gvalue);
  }

  method get_flagset_flags is also<get-flagset-flags> {
    gst_value_get_flagset_flags(self.gvalue);
  }

  method get_flagset_mask is also<get-flagset-mask> {
    gst_value_get_flagset_mask(self.gvalue);
  }

  method get_fraction_denominator is also<get-fraction-denominator> {
    gst_value_get_fraction_denominator(self.gvalue);
  }

  method get_fraction_numerator is also<get-fraction-numerator> {
    gst_value_get_fraction_numerator(self.gvalue);
  }

  method get_fraction_range_max (:$raw = False)
    is also<get-fraction-range-max>
  {
    my $v = gst_value_get_fraction_range_max(self.gvalue);

    $v ??
      ( $raw ?? $v !! GStreamer::Value.new($v) )
      !!
      Nil;
  }

  method get_fraction_range_min (:$raw = False)
    is also<get-fraction-range-min>
  {
    my $v = gst_value_get_fraction_range_min(self.gvalue);

    $v ??
      ( $raw ?? $v !! GStreamer::Value.new($v) )
      !!
      Nil;
  }

  method get_int64_range_max is also<get-int64-range-max> {
    gst_value_get_int64_range_max(self.gvalue);
  }

  method get_int64_range_min is also<get-int64-range-min> {
    gst_value_get_int64_range_min(self.gvalue);
  }

  method get_int64_range_step is also<get-int64-range-step> {
    gst_value_get_int64_range_step(self.gvalue);
  }

  method get_int_range_max is also<get-int-range-max> {
    gst_value_get_int_range_max(self.gvalue);
  }

  method get_int_range_min is also<get-int-range-min> {
    gst_value_get_int_range_min(self.gvalue);
  }

  method get_int_range_step is also<get-int-range-step> {
    gst_value_get_int_range_step(self.gvalue);
  }

  method bitmask_get_type (GStreamer::Value:U:) is also<bitmask-get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name ~ '-Bitmask',
      &gst_bitmask_get_type,
      $n,
      $t
    );
  }

  method double_range_get_type is also<double-range-get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name ~ '-DoubleRange',
      &gst_double_range_get_type,
      $n,
      $t
    );
  }

  method flagset_get_type is also<flagset-get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name ~ '-Flagset',
      &gst_flagset_get_type,
      $n,
      $t
    );
  }

  method flagset_register is also<flagset-register> {
    gst_flagset_register(self.gvalue);
  }

  method fraction_get_type is also<fraction-get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name ~ '-Fraction',
      &gst_fraction_get_type,
      $n,
      $t
    );
  }

  method fraction_range_get_type is also<fraction-range-get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name ~ '-FractionRange',
      &gst_fraction_range_get_type,
      $n,
      $t
    );
  }

  method g_thread_get_type is also<g-thread-get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name ~ '-GThread',
      &gst_g_thread_get_type,
      $n,
      $t
    );
  }

  method int64_range_get_type is also<int64-range-get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name ~ '-Int64Range',
      &gst_int64_range_get_type,
      $n,
      $t
    );
  }

  method int_range_get_type is also<int-range-get-type> {
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
  )
    is also<init-and-copy>
  {
    gst_value_init_and_copy($dest, $src);
  }

  method intersect (GValue() $value1, GValue $value2) {
    so gst_value_intersect(self.gvalue, $value1, $value2);
  }

  method is_fixed is also<is-fixed> {
    so gst_value_is_fixed(self.gvalue);
  }

  method is_subset (GValue() $value2) is also<is-subset> {
    so gst_value_is_subset(self.gvalue, $value2);
  }

  # method register (GValueTable $table) {
  #   gst_value_register($table);
  # }

  method serialize {
    gst_value_serialize(self.gvalue);
  }

  method set_double_range (Num() $start, Num() $end)
    is also<set-double-range>
  {
    my gdouble ($s, $e) = ($start, $end);

    gst_value_set_double_range(self.gvalue, $s, $e);
  }

  method set_flagset (Int() $flags, Int() $mask) is also<set-flagset> {
    my guint ($f, $m) = ($flags, $mask);

    gst_value_set_flagset(self.gvalue, $f, $m);
  }

  method set_fraction (Int() $numerator, Int() $denominator)
    is also<set-fraction>
  {
    my gint ($n, $d) = ($numerator, $denominator);

    gst_value_set_fraction(self.gvalue, $n, $d);
  }

  method set_fraction_range (GValue() $start, GValue() $end)
    is also<set-fraction-range>
  {
    gst_value_set_fraction_range(self.gvalue, $start, $end);
  }

  method set_fraction_range_full (
    Int() $numerator_start,
    Int() $denominator_start,
    Int() $numerator_end,
    Int() $denominator_end
  )
    is also<set-fraction-range-full>
  {
    my gint ($ns, $ds, $ne, $de) = (
      $numerator_start,
      $denominator_start,
      $numerator_end,
      $denominator_end
    );

    gst_value_set_fraction_range_full(self.gvalue, $ns, $ds, $ne, $de);
  }

  method set_int64_range (Int() $start, Int() $end) is also<set-int64-range> {
    my gint64 ($s, $e) = ($start, $end);

    gst_value_set_int64_range(self.gvalue, $start, $end);
  }

  method set_int64_range_step (Int() $start, Int() $end, Int() $step)
    is also<set-int64-range-step>
  {
    my gint64 ($st, $e, $sp) = ($start, $end,  $step);

    gst_value_set_int64_range_step(self.gvalue, $start, $end, $step);
  }

  method set_int_range (Int() $start, Int() $end) is also<set-int-range> {
    my gint ($s, $e) = ($start, $end);

    gst_value_set_int_range(self.gvalue, $s, $e);
  }

  method set_int_range_step (Int() $start, Int() $end, Int() $step)
    is also<set-int-range-step>
  {
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

class GStreamer::Value::Array is GStreamer::Value {

  method append_and_take_value (GValue() $append_value)
    is also<append-and-take-value>
  {
    gst_value_array_append_and_take_value(self.gvalue, $append_value);
  }

  method append_value (GValue() $append_value) is also<append-value> {
    gst_value_array_append_value(self.gvalue, $append_value);
  }

  method get_size is also<get-size> {
    gst_value_array_get_size(self.gvalue);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &gst_value_array_get_type,
      $n,
      $t
    );
  }

  method get_value (Int() $index) is also<get-value> {
    my guint $i = $index;

    gst_value_array_get_value(self.gvalue, $i);
  }

  method prepend_value (GValue() $prepend_value) is also<prepend-value> {
    gst_value_array_prepend_value(self.gvalue, $prepend_value);
  }

}

class GStreamer::Value::List is GStreamer::Value {

  method append_and_take_value (GValue() $append_value)
    is also<append-and-take-value>
  {
    gst_value_list_append_and_take_value(self.gvalue, $append_value);
  }

  method append_value (GValue() $append_value) is also<append-value> {
    gst_value_list_append_value(self.gvalue, $append_value);
  }

  method concat (GValue() $value1, GValue() $value2) {
    gst_value_list_concat(self.gvalue, $value1, $value2);
  }

  method get_size is also<get-size> {
    gst_value_list_get_size(self.gvalue);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &gst_value_list_get_type,
      $n,
      $t
    );
  }

  method get_value (Int() $index) is also<get-value> {
    my guint $i = $index;

    gst_value_list_get_value(self.gvalue, $i);
  }

  method merge (GValue() $value1, GValue() $value2) {
    gst_value_list_merge(self.gvalue, $value1, $value2);
  }

  method prepend_value (GValue() $prepend_value) is also<prepend-value> {
    gst_value_list_prepend_value(self.gvalue, $prepend_value);
  }

}
