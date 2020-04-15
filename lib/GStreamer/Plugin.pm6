use v6.c;

use Method::Also;
use NativeCall;

use GStreamer::Raw::Types;
use GStreamer::Raw::Plugin;

use GStreamer::Object;

# cw[1]: Just a thought... maybe this...
# our @plugin-ancestry is export = (GstPlugin, GstObject);
# our subset PluginAncestry is export of Mu where @plugin-ancestry.any;

our subset PluginAncestry is export of Mu
  where GstPlugin | GstObject;

class GStreamer::Plugin is GStreamer::Object {
  has GstPlugin $!p;

  submethod BUILD (:$plugin) {
    self.setPlugin($plugin);
  }

  method setPlugin(PluginAncestry $_) {
    # cw[1]: ...could be used to automate/abstract this?
    my $to-parent;

    $!p = do {
      when GstPlugin {
        $to-parent = cast(GstObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstPlugin, $_);
      }
    }
  }

  method new (GstPlugin $plugin) {
    $plugin ?? self.bless( :$plugin ) !! Nil;
  }

  method GStreamer::Raw::Types::GstPlugin
    is also<GstPlugin>
  { $!p }

  method cache_data is rw is also<cache-data> {
    Proxy.new(
      FETCH => sub ($) {
        gst_plugin_get_cache_data($!p);
      },
      STORE => sub ($, GstStructure() $cache_data is copy) {
        gst_plugin_set_cache_data($!p, $cache_data);
      }
    );
  }

  method add_dependency (
    Str() $env_vars,
    Str() $paths,
    Str() $names,
    Int() $flags      # GstPluginDependencyFlags $flags
  )
    is also<add-dependency>
  {
    gst_plugin_add_dependency($!p, $env_vars, $paths, $names, $flags);
  }

  method add_dependency_simple (
    Str() $env_vars,
    Str() $paths,
    Str() $names,
    Int() $flags      # GstPluginDependencyFlags $flags
  )
    is also<add-dependency-simple>
  {
    gst_plugin_add_dependency_simple($!p, $env_vars, $paths, $names, $flags);
  }

  method error_quark is also<error-quark> {
    gst_plugin_error_quark();
  }

  method get_description is also<get-description> {
    gst_plugin_get_description($!p);
  }

  method get_filename is also<get-filename> {
    gst_plugin_get_filename($!p);
  }

  method get_license is also<get-license> {
    gst_plugin_get_license($!p);
  }

  method get_name is also<get-name> {
    gst_plugin_get_name($!p);
  }

  method get_origin is also<get-origin> {
    gst_plugin_get_origin($!p);
  }

  method get_package is also<get-package> {
    gst_plugin_get_package($!p);
  }

  method get_release_date_string is also<get-release-date-string> {
    gst_plugin_get_release_date_string($!p);
  }

  method get_source is also<get-source> {
    gst_plugin_get_source($!p);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_plugin_get_type, $n, $t );
  }

  method get_version is also<get-version> {
    gst_plugin_get_version($!p);
  }

  method is_loaded is also<is-loaded> {
    so gst_plugin_is_loaded($!p);
  }

  method list_free (
    GStreamer::Plugin:U:
    GList() $list
  )
    is also<list-free>
  {
    gst_plugin_list_free($list);
  }

  multi method load {
    GStreamer::Plugin.load($!p);
  }
  multi method load (GstPlugin $p, :$raw = False) {
    my $pp = gst_plugin_load($p);

    $pp ??
      ( $raw ?? $pp !! GStreamer::Plugin.new($pp) )
      !!
      Nil;
  }

  method load_by_name (Str() $name, :$raw = False) is also<load-by-name> {
    my $p = gst_plugin_load_by_name($name);

    $p ??
      ( $raw ?? $p !! GStreamer::Plugin.new($p) )
      !!
      Nil;
  }

  method load_file (
    Str() $filename,
    CArray[Pointer[GError]] $error = gerror,
    :$raw = False
  )
    is also<load-file>
  {
    clear_error;
    my $rc = gst_plugin_load_file($filename, $error);
    set_error($error);

    $rc ??
      ( $raw ?? $rc !! GStreamer::Plugin.new($rc) )
      !!
      Nil;
  }

  method register_static (
    Int() $major_version,
    Int() $minor_version,
    Str() $name,
    Str() $description,
    GstPluginInitFunc $init_func,
    Str() $version,
    Str() $license,
    Str() $source,
    Str() $package,
    Str() $origin
  )
    is also<register-static>
  {
    gst_plugin_register_static(
      $major_version,
      $minor_version,
      $name,
      $description,
      $init_func,
      $version,
      $license,
      $source,
      $package,
      $origin
    );
  }

  method register_static_full (
    Int() $major_version,
    Int() $minor_version,
    Str() $name,
    Str() $description,
    GstPluginInitFullFunc $init_full_func,
    Str() $version,
    Str() $license,
    Str() $source,
    Str() $package,
    Str() $origin,
    gpointer $user_data = gpointer
  )
    is also<register-static-full>
  {
    gst_plugin_register_static_full(
      $major_version,
      $minor_version,
      $name,
      $description,
      $init_full_func,
      $version,
      $license,
      $source,
      $package,
      $origin,
      $user_data
    );
  }

}
