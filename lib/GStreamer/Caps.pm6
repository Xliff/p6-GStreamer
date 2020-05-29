use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Caps;

use GStreamer::MiniObject;
use GStreamer::Structure;

our subset GstCapsAncestry is export of Mu
  where GstCaps | GstMiniObject;

class GStreamer::Caps is GStreamer::MiniObject {
  has GstCaps $!c;

  submethod BUILD (:$caps) {
    self.setCaps($caps);
  }

  method setCaps (GstCapsAncestry $_) {
    my $to-parent;

    $!c = do {
      when GstCaps {
        $to-parent = cast(GstMiniObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstCaps, $_);
      }
    }
    self.setMiniObject($to-parent);
  }

  method GStreamer::Raw::Types::GstCaps
    is also<GstCaps>
  { $!c }

  multi method new (GstCapsAncestry $caps) {
    $caps ?? self.bless( :$caps ) !! Nil;
  }

  multi method new (:$any is required) {
    self.new_any;
  }
  method new_any is also<new-any> {
    my $caps = gst_caps_new_any();

    $caps ?? self.bless( :$caps ) !! Nil;
  }

  multi method new (:$empty is required) {
    self.new_empty;
  }
  method new_empty is also<new-empty> {
    my $caps = gst_caps_new_empty();

    $caps ?? self.bless( :$caps ) !! Nil;
  }

  multi method new (
    $media-type is copy,
    :empty-simple($empty_simple) is required
  ) {
    self.new_empty_simple($media-type);
  }
  method new_empty_simple (Str() $media-type) is also<new-empty-simple> {
    my $caps = gst_caps_new_empty_simple($media-type);

    $caps ?? self.bless( :$caps ) !! Nil;
  }

  multi method new (
    *@structs,
    :$full is required
  ) {
    self.new_full( |@structs );
  }
  method new_full (*@structs) is also<new-full> {
    my $o = self.new_empty;

    die '@structs must only contain GStreamer::Structure-compatible elements.'
      unless @structs.all ~~ (GStreamer::Structure, GstStructure).any;

    $o.append_structure($_) for @structs;
    $o;
  }

  multi method new (
    $media-type,
    :$simple is required,
    *%pairs,
  ) {
    self.new_simple($media-type, |%pairs);
  }
  method new_simple (Str() $media-type, *%pairs) is also<new-simple> {
    my $s = GStreamer::Structure.new( |%pairs );
    my $o = self.new_empty_simple($media-type);

    $o.append_structure($s);
  }

  multi method new ($desc, :from-string($from_string) is required) {
    self.new_from_string($desc);
  }
  method new_from_string (Str() $desc)
    is also<
      new-from-string
      from_string
      from-string
    >
  {
    my $caps = gst_caps_from_string($desc);

    $caps ?? self.bless( :$caps ) !! Nil;
  }

  method append (GstCaps() $caps2) {
    gst_caps_append($!c, $caps2);
  }

  method append_structure (GstStructure() $structure)
    is also<append-structure>
  {
    gst_caps_append_structure($!c, $structure);
  }

  method append_structure_full (
    GstStructure() $structure,
    GstCapsFeatures() $features
  )
    is also<append-structure-full>
  {
    gst_caps_append_structure_full($!c, $structure, $features);
  }

  method can_intersect (GstCaps() $caps2) is also<can-intersect> {
    gst_caps_can_intersect($!c, $caps2);
  }

  multi method copy {
    GStreamer::Caps.copy($!c);
  }
  multi method copy (GStreamer::Caps:U: GstCaps $cpy, :$raw = False) {
    my $c = gst_caps_copy($cpy);

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

  method copy_nth (Int() $nth, :$raw = False) is also<copy-nth> {
    my guint $n = $nth;
    my $caps = gst_caps_copy_nth($!c, $n);

    $caps ??
      ( $raw ?? $caps !! GStreamer::Caps.new($caps) )
      !!
      Nil;
  }

  method filter_and_map_in_place (
    GstCapsFilterMapFunc $func,
    gpointer $user_data = gpointer
  )
    is also<filter-and-map-in-place>
  {
    gst_caps_filter_and_map_in_place($!c, $func, $user_data);
  }

  method fixate (GstCaps() $caps, :$raw = False) {
    my $c = gst_caps_fixate($caps);

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

  method foreach (
    GstCapsForeachFunc $func,
    gpointer $user_data = gpointer
  ) {
    gst_caps_foreach($!c, $func, $user_data);
  }

  method get_features (Int() $index) is also<get-features> {
    my guint $i = $index;

    gst_caps_get_features($!c, $i);
  }

  method get_size is also<get-size> {
    gst_caps_get_size($!c);
  }

  method get_structure (Int() $index, :$raw = False) is also<get-structure> {
    my guint $i = $index;
    my       $s = gst_caps_get_structure($!c, $index);

    $s ??
      ( $raw ?? $s !! GStreamer::Structure.new($s) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_caps_get_type, $n, $t );
  }

  method intersect (GstCaps() $caps2) {
    gst_caps_intersect($!c, $caps2);
  }

  method intersect_full (
    GstCaps() $caps2,
    Int() $mode
  )
    is also<intersect-full>
  {
    my GstCapsIntersectMode $m = $mode;

    gst_caps_intersect_full($!c, $caps2, $m);
  }

  method is_always_compatible (GstCaps() $caps2)
    is also<is-always-compatible>
  {
    so gst_caps_is_always_compatible($!c, $caps2);
  }

  method is_any is also<is-any> {
    so gst_caps_is_any($!c);
  }

  method is_empty is also<is-empty> {
    so gst_caps_is_empty($!c);
  }

  method is_equal (GstCaps() $caps2) is also<is-equal> {
    so gst_caps_is_equal($!c, $caps2);
  }

  method is_equal_fixed (GstCaps() $caps2) is also<is-equal-fixed> {
    so gst_caps_is_equal_fixed($!c, $caps2);
  }

  method is_fixed is also<is-fixed> {
    so gst_caps_is_fixed($!c);
  }

  method is_strictly_equal (GstCaps() $caps2) is also<is-strictly-equal> {
    so gst_caps_is_strictly_equal($!c, $caps2);
  }

  method is_subset (GstCaps() $superset) is also<is-subset> {
    so gst_caps_is_subset($!c, $superset);
  }

  method is_subset_structure (GstStructure() $structure)
    is also<is-subset-structure>
  {
    so gst_caps_is_subset_structure($!c, $structure);
  }

  method is_subset_structure_full (
    GstStructure() $structure,
    GstCapsFeatures() $features
  )
    is also<is-subset-structure-full>
  {
    so gst_caps_is_subset_structure_full($!c, $structure, $features);
  }

  method map_in_place (
    GstCapsMapFunc $func,
    gpointer $user_data = gpointer
  )
    is also<map-in-place>
  {
    gst_caps_map_in_place($!c, $func, $user_data);
  }

  method merge (GstCaps() $caps2) {
    gst_caps_merge($!c, $caps2);
  }

  method merge_structure (GstStructure() $structure) is also<merge-structure> {
    gst_caps_merge_structure($!c, $structure);
  }

  method merge_structure_full (
    GstStructure() $structure,
    GstCapsFeatures() $features;
  )
    is also<merge-structure-full>
  {
    gst_caps_merge_structure_full($!c, $structure, $features);
  }

  method normalize (:$raw = False) {
    my $n = gst_caps_normalize($!c);

    $n ??
      ( $raw ?? $n !! Gstreamer::Caps.new($n) )
      !!
      Nil;
  }

  method remove_structure (Int() $idx) is also<remove-structure> {
    my guint $i = $idx;

    gst_caps_remove_structure($!c, $idx);
  }

  method set_features (
    Int() $index,
    GstCapsFeatures() $features
  )
    is also<set-features>
  {
    my guint $i = $index;

    gst_caps_set_features($!c, $i, $features);
  }

  method set_features_simple (GstCapsFeatures() $features)
    is also<set-features-simple>
  {
    gst_caps_set_features_simple($!c, $features);
  }

  method set_value (Str() $field, GValue() $value) is also<set-value> {
    gst_caps_set_value($!c, $field, $value);
  }

  method simplify (:$raw = False) {
    my $s = gst_caps_simplify($!c);

    $s ??
      ( $raw ?? $s !! GStreamer::Caps.new($s) )
      !!
      Nil;
  }

  method steal_structure (Int() $index) is also<steal-structure> {
    my guint $i = $index;

    gst_caps_steal_structure($!c, $i);
  }

  method subtract (GstCaps() $subtrahend, :$raw = False) {
    my $sl = gst_caps_subtract($!c, $subtrahend);

    $sl ??
      ( $raw ?? $sl !! GStreamer::Caps.new($sl) )
      !!
      Nil;
  }

  method to_string
    is also<
      to-string
      Str
    >
  {
    gst_caps_to_string($!c);
  }

  method truncate (:$raw = False) {
    my $t = gst_caps_truncate($!c);

    $t ??
      ( $raw ?? $t !! GStreamer::Caps.new($t) )
      !!
      Nil;
  }

}

class GStreamer::StaticCaps {
  has GstStaticCaps $!sc handles<string Str>;

  submethod BUILD (:$static-caps) {
    $!sc = $static-caps;
  }

  method GStreamer::Raw::Types::GstStaticCaps
    is also<GstStaticCaps>
  { $!sc }

  method new (GstStaticCaps $static-caps) {
    $static-caps ?? self.bless( :$static-caps ) !! Nil;
  }

  method cleanup {
    gst_static_caps_cleanup($!sc);
  }

  method get (:$raw = False) {
    my $c = gst_static_caps_get($!sc);

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_static_caps_get_type, $n, $t );
  }
}
