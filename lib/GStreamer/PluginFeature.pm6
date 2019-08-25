use v6.c;

use Method::Also;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::PluginFeature;

our subset PluginFeatureAncestry is export of Mu
  where GstPluginFeature | GstObject;

class GStreamer::PluginFeature is GStreamer::Object {
  has GstPluginFeature $!pf;

  submethod BUILD (:$plugin-feature) {
    self.setPluginFeature($plugin-feature);
  }

  method setPluginFeature (PluginFeatureAncestry $_) {
    my $to-parent;

    $!pf = do {
      when GstPluginFeature {
        $to-parent = cast(GstObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstPluginFeature, $_);
      }
    }
    self.setGstObject($to-parent);
  }

  method GStreamer::Raw::Types::GstPluginFeature
    is also<
      GstPluginFeature
      PluginFeature
    >
  { $!pf }

  method new (GstPluginFeature $plugin-feature) {
    self.bless( :$plugin-feature );
  }

  method rank is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_plugin_feature_get_rank($!pf);
      },
      STORE => sub ($, Int() $rank is copy) {
        gst_plugin_feature_set_rank($!pf, $rank);
      }
    );
  }

  method check_version (Int() $min_major, Int() $min_minor, Int() $min_micro)
    is also<check-version>
  {
    so gst_plugin_feature_check_version(
      $!pf,
      $min_major,
      $min_minor,
      $min_micro
    );
  }

  method get_plugin (:$raw = False)
    is also<
      get-plugin
      plugin
    >
  {
    my $p = gst_plugin_feature_get_plugin($!pf);

    $p ??
      ( $raw ?? $p !! GStreamer::Plugin.new($p) )
      !!
      Nil;
  }

  method get_plugin_name
    is also<
      get-plugin-name
      plugin_name
      plugin-name
    >
  {
    gst_plugin_feature_get_plugin_name($!pf);
  }

  method get_type is also<get-type> {
    state ($n, $t);
    unstable_get_type( self.^name, &gst_plugin_feature_get_type, $n, $t );
  }

  method list_copy
    is also<
      list-copy
      copy
    >
  {
    gst_plugin_feature_list_copy($!pf);
  }

  method list_debug
    is also<
      list-debug
      debug
    >
  {
    gst_plugin_feature_list_debug($!pf);
  }

  proto method list_free (|)
    is also<
      list-free
      free
    >
  { * }

  multi method list_free ( GStreamer::PluginFeature:D: )  {
    GStreamer::PluginFeature.list_free($!pf);
  }
  multi method list_free (
    GStreamer::PluginFeature:U:
    GstPluginFeature $feature
  ) {
    gst_plugin_feature_list_free($feature);
  }

  method load {
    self.bless( plugin-feature => gst_plugin_feature_load($!pf) );
  }

  proto method rank_compare_func (|)
    is also<rank-compare-func>
  { * }

  multi method rank_compare_func (GstPluginFeature() $p2) {
    GStreamer::PluginFeature.rank_compare_func($!pf, $p2);
  }
  multi method rank_compare_func (
    GStreamer::PluginFeature:U:
    GstPluginFeature() $a,
    GstPluginFeature() $b
  ) {
    gst_plugin_feature_rank_compare_func($a, $b);
  }

}
