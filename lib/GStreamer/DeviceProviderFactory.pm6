use v6.c;

use NativeCall;
use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::DeviceProviderFactory;

use GStreamer::PluginFeature;

our subset GstDeviceProviderFactoryAncestry is export of Mu
  where GstDeviceProviderFactory | GstPluginFeatureAncestry;

class GStreamer::DeviceProviderFactory is GStreamer::PluginFeature {
  has GstDeviceProviderFactory $!dpf;

  submethod BUILD (:$factory) {
    self.setDeviceProviderFactory($factory);
  }

  method setDeviceProviderFactory (GstDeviceProviderFactoryAncestry $factory) {
    my $to-parent;

    $!dpf = do {
      when GstDeviceProviderFactory {
        $to-parent = cast(GstPluginFeature, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstDeviceProviderFactory, $_);
      }
    }
    self.setGstPluginFeature($to-parent);
  }

  method new (GstDeviceProviderFactoryAncestry $factory) {
    $factory ?? self.bless( :$factory ) !! Nil;
  }

  method find (GStreamer::DeviceProviderFactory:U: Str() $name) {
    my $factory = gst_device_provider_factory_find($name);

    $factory ?? self.bless( :$factory ) !! Nil;
  }

  method get (:$raw = False) {
    my $dp = gst_device_provider_factory_get($!dpf);

    $dp ??
      ( $raw ?? $dp !! GStreamer::DeviceProvider.new($dp) )
      !!
      Nil;
  }

  method get_by_name (
    GStreamer::DeviceProviderFactory:U:
    Str() $name,
    :$raw = False
  )
    is also<get-by-name>
  {
    my $dp = gst_device_provider_factory_get_by_name($name);

    $dp ??
      ( $raw ?? $dp !! GStreamer::DeviceProvider.new($dp) )
      !!
      Nil;
  }

  method get_device_provider_type is also<get-device-provider-type> {
    GTypeEnum( gst_device_provider_factory_get_device_provider_type($!dpf) );
  }

  method get_metadata (Str() $key) is also<get-metadata> {
    gst_device_provider_factory_get_metadata($!dpf, $key);
  }

  method get_metadata_keys is also<get-metadata-keys> {
    CStringArrayToArray( gst_device_provider_factory_get_metadata_keys($!dpf) );
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &gst_device_provider_factory_get_type,
      $n,
      $t
    );
  }

  proto method has_classes (|)
    is also<has-classes>
  { * }

  proto method has_classesv (|)
    is also<has-classesv>
  { * }

  multi method has_classes (Str() $classes)  {
    so gst_device_provider_factory_has_classes($!dpf, $classes);
  }
  multi method has_classes (@classes) {
    self.has_classesv(@classes);
  }
  multi method has_classes (CArray[Str] $classes) {
    self.has_classesv($classes);
  }

  multi method has_classesv (@classes) {
    # YYY - Move this check to ArrayToCArray using T.^name!
    @classes = @classes.map({
      die '@classes must only contain Str-compatible values!'
        unless .^lookup('Str');
      .Str;
    });
    samewith( ArrayToCArray(Str, @classes) );
  }
  multi method has_classesv (CArray[Str] $classes) {
    so gst_device_provider_factory_has_classesv($!dpf, $classes);
  }

  method list_get_device_providers (
    GStreamer::DeviceProviderFactory:U:
    :$glist = False,
    :$raw = False
  )
    is also<list-get-device-providers>
  {
    my $fl = gst_device_provider_factory_list_get_device_providers($!dpf);

    return Nil unless $fl;
    return $fl if $glist;

    $fl = GLib::GList.new($fl)
      but GLib::Roles::ListData[GstDeviceProviderFactory];

    $raw ?? $fl.Array
         !! $fl.Array.map({ GStreamer::DeviceProviderFactory.new($_) });
  }

}
