use v6.c;

use Method::Also;


use GStreamer::Raw::Types;
use GStreamer::Raw::CapsFeatures;

class GStreamer::CapsFeatures {
  has GstCapsFeatures $!cf;

  submethod BUILD (:$features) {
    $!cf = $features;
  }

  method GStreamer::Raw::Types::GstCapsFeatures
  { $!cf }

  multi method new (GstCapsFeatures $features) {
    self.bless( :$features);
  }

  multi method new (*@args) {
    my $o = ::?CLASS.new_empty;

    for @args {
      when GQuark { $o.add_id($_) }
      when Str    { $o.add($_)    }
    }
    $o;
  }

  #GST_API GstCapsFeatures * gst_caps_features_new (const gchar *feature1, ...);'
  #GST_API GstCapsFeatures * gst_caps_features_new_id (GQuark feature1, ...);'

  multi method new (:$any is required) {
    ::?CLASS.new_any;
  }
  method new_any is also<new-any> {
    self.bless( features => gst_caps_features_new_any() );
  }

  multi method new (:$empty is required) {
    ::?CLASS.new_empty;
  }
  method new_empty is also<new-empty> {
    self.bless( features => gst_caps_features_new_empty() );
  }

  multi method new (Str() $desc, :from-string(:$from_string) is required) {
    ::?CLASS.new_from_string($desc);
  }
  method new_from_string (Str() $desc) is also<new-from-string> {
    self.bless( features => gst_caps_features_from_string($desc) );
  }

  method add (Str() $feature) {
    gst_caps_features_add($!cf, $feature);
  }

  method add_id (GQuark $feature) is also<add-id> {
    gst_caps_features_add_id($!cf, $feature);
  }

  method contains (Str() $feature) {
    so gst_caps_features_contains($!cf, $feature);
  }

  method contains_id (GQuark $feature) is also<contains-id> {
    so gst_caps_features_contains_id($!cf, $feature);
  }

  method copy {
    ::?CLASS.new( gst_caps_features_copy($!cf) );
  }

  method free {
    gst_caps_features_free($!cf);
  }

  method get_nth (Int() $i) is also<get-nth> {
    my guint $ii = $i;

    gst_caps_features_get_nth($!cf, $i);
  }

  method get_nth_id (Int() $i) is also<get-nth-id> {
    my guint $ii = $i;

    gst_caps_features_get_nth_id($!cf, $i);
  }

  method get_size is also<get-size> {
    gst_caps_features_get_size($!cf);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_caps_features_get_type, $n, $t );
  }

  method is_caps_features (
    GStreamer::CapsFeatures:U:
    gpointer $candidate
  )
    is also<is-caps-features>
  {
    so gst_is_caps_features($candidate);
  }

  method is_any is also<is-any> {
    so gst_caps_features_is_any($!cf);
  }

  method is_equal (GstCapsFeatures() $features2) is also<is-equal> {
    so gst_caps_features_is_equal($!cf, $features2);
  }

  method remove (Str() $feature) {
    gst_caps_features_remove($!cf, $feature);
  }

  method remove_id (GQuark $feature) is also<remove-id> {
    gst_caps_features_remove_id($!cf, $feature);
  }

  method set_parent_refcount (Int() $refcount) is also<set-parent-refcount> {
    my gint $refc = $refcount;

    warn 'set_parent_refcount has been called -- USE AT YOUR OWN RISK!'
      if $DEBUG;

    gst_caps_features_set_parent_refcount($!cf, $refc);
  }

  method to_string
    is also<
      to-string
      Str
    >
  {
    gst_caps_features_to_string($!cf);
  }

}
