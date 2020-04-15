use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::PluginFeature;
use GStreamer::Raw::Registry;

use GLib::GList;
use GStreamer::Object;
use GStreamer::Plugin;
use GStreamer::PluginFeature;

use GLib::Roles::ListData;

our subset GstRegistryAncestry is export of Mu
  where GstRegistry | GstObject;

class GStreamer::Registry is GStreamer::Object {
  has GstRegistry $!r;

  submethod BUILD (:$registry) {
    self.setRegistry($registry);
  }

  method setRegistry(GstRegistryAncestry $_) {
    my $to-parent;

    $!r = do {
      when GstRegistry {
        $to-parent = cast(GstObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstRegistry, $_);
      }
    }
    self.setGstObject($to-parent);
  }

  method GStreamer::Raw::Definitions::GstRegistry
    is also<GstRegistry>
  { $!r }

  multi method new (GstRegistryAncestry $registry) {
    $registry ?? self.bless( :$registry ) !! Nil;
  }
  multi method new {
    self.get;
  }

  method get {
    my $registry = gst_registry_get();

    $registry ?? self.bless( :$registry ) !! Nil;
  }

  method add_feature (GstPluginFeature() $feature) is also<add-feature> {
    so gst_registry_add_feature($!r, $feature);
  }

  method add_plugin (GstPlugin() $plugin) is also<add-plugin> {
    so gst_registry_add_plugin($!r, $plugin);
  }

  method check_feature_version (
    Str() $feature_name,
    Int() $min_major,
    Int() $min_minor,
    Int() $min_micro
  ) is also<check-feature-version> {
    my ($mj, $mn, $mc) = ($min_major, $min_minor, $min_micro);

    so gst_registry_check_feature_version($!r, $feature_name, $mj, $mn, $mc);
  }

  method feature_filter (
    &filter,
    Int() $first = False,
    gpointer $user_data = gpointer,
    :$glist = False,
    :$raw = False
  )
    is also<feature-filter>
  {
    my gboolean $f = $first.so.Int;
    my $fl = gst_registry_feature_filter($!r, &filter, $f, $user_data);

    return Nil unless $fl;
    return $fl if $glist;

    my $fll = GLib::GList.new($fl) but GLib::Roles::ListData[GstPluginFeature];
    my @r = $raw ?? $fll.Array
                 !! $fll.Array.map({ GStreamer::PluginFeature.new($_) });

    # Free list AFTER return array is created.
    gst_plugin_feature_list_free($fl);
    
    @r
  }

  method find_feature (Str() $name, Int() $type, :$raw = False) is also<find-feature> {
    my GType $t = $type;
    my $f = gst_registry_find_feature($!r, $name, $t);

    $f ??
      ( $raw ?? $f !! GStreamer::PluginFeature.new($f) )
      !!
      Nil;
  }

  method find_plugin (Str() $name, :$raw = False) is also<find-plugin> {
    my $p = gst_registry_find_plugin($!r, $name);

    $p ??
      ( $raw ?? $p !! GStreamer::Plugin.new($p) )
      !!
      Nil;
  }

  method get_feature_list (Int() $type, :$glist = False, :$raw = False) is also<get-feature-list> {
    my GType $t = $type;
    my $fl = gst_registry_get_feature_list($!r, $t);

    return Nil unless $fl;
    return $fl if $glist;

    $fl = GLib::GList.new($fl) but GLib::Roles::ListData[GstPluginFeature];
    $raw ?? $fl.Array !! $fl.Array.map({ GStreamer::PluginFeature.new($_) });
  }

  method get_feature_list_by_plugin (
    Str() $name,
    :$glist = False,
    :$raw = False
  ) is also<get-feature-list-by-plugin> {
    my $fl = gst_registry_get_feature_list_by_plugin($!r, $name);

    return Nil unless $fl;
    return $fl if $glist;

    $fl = GLib::GList.new($fl) but GLib::Roles::ListData[GstPluginFeature];
    $raw ?? $fl.Array !! $fl.Array.map({ GStreamer::PluginFeature.new($_) });
  }

  method get_feature_list_cookie is also<get-feature-list-cookie> {
    gst_registry_get_feature_list_cookie($!r);
  }

  method get_plugin_list (:$glist = False, :$raw = False)
    is also<get-plugin-list>
  {
    my $pl = gst_registry_get_plugin_list($!r);

    return Nil unless $pl;
    return $pl if $glist;

    $pl = GLib::GList.new($pl) but GLib::Roles::ListData[GstPlugin];
    $raw ?? $pl.Array !! $pl.Array.map({ GStreamer::Plugin.new($_) });
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_registry_get_type, $n, $t );
  }

  method lookup (Str() $filename, :$raw = False) {
    my $p = gst_registry_lookup($!r, $filename);

    $p ??
      ( $raw ?? $p !! GStreamer::Plugin.new($p) )
      !!
      GstPlugin
  }

  method lookup_feature (Str() $name, :$raw = False) is also<lookup-feature> {
    my $pf = gst_registry_lookup_feature($!r, $name);

    $pf ??
      ( $raw ?? $pf !! GStreamer::PluginFeature.new($pf) )
      !!
      GstPluginFeature
  }

  method plugin_filter (
    &filter,
    Int() $first,
    gpointer $user_data = gpointer
  ) is also<plugin-filter> {
    my gboolean $f = $first.so.Int;

    gst_registry_plugin_filter($!r, &filter, $f, $user_data);
  }

  method remove_feature (GstPluginFeature() $feature) is also<remove-feature> {
    gst_registry_remove_feature($!r, $feature);
  }

  method remove_plugin (GstPlugin() $plugin) is also<remove-plugin> {
    gst_registry_remove_plugin($!r, $plugin);
  }

  method scan_path (Str() $path) is also<scan-path> {
    so gst_registry_scan_path($!r, $path);
  }

}
