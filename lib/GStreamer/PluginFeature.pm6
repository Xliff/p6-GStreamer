use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::PluginFeature;

use GLib::GList;

use GStreamer::Object;
#use GStreamer::Plugin;

our subset PluginFeatureAncestry is export of Mu
  where GstPluginFeature | GstObject;

class GStreamer::PluginFeature is GStreamer::Object {
  has GstPluginFeature $!pf;

  submethod BUILD (:$plugin-feature) {
    self.setPluginFeature($plugin-feature) if $plugin-feature;
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
    $plugin-feature ?? self.bless( :$plugin-feature ) !! Nil;
  }

  method load {
    my $plugin-feature = gst_plugin_feature_load($!pf);
    
    $plugin-feature ?? self.bless( :$plugin-feature ) !! Nil;
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
      GstPlugin;
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

  method list_copy (
    GStreamer::PluginFeature:U:
    GList() $list,
    :$raw = False
  )
    is also<
      list-copy
      copy
    >
  {
    my $l = gst_plugin_feature_list_copy($list);

    $l ??
      ( $raw ?? $l !! GLib::GList.new($list) )
      !!
      GList;
  }

  method list_debug (
    GStreamer::PluginFeature:U:
    GList() $list
  )
    is also<
      list-debug
      debug
    >
  {
    gst_plugin_feature_list_debug($list);
  }

  multi method list_free (
    GStreamer::PluginFeature:U:
    GList() $list
  ) {
    gst_plugin_feature_list_free($list);
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
