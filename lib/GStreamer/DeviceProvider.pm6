use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::DeviceProvider;

use GStreamer::Object;
use GStreamer::Bus;

our subset GstDeviceProviderAncestry is export of Mu
  where GstDeviceProvider | GstObject;

class GStreamer::DeviceProvider is GStreamer::Object {
  has GstDeviceProvider $!dp ;

  submethod BUILD (:$provider) {
    self.setDeviceProvider($provider);
  }

  method setDeviceProvider (GstDeviceProviderAncestry $_) {
    my $to-parent;

    $!dp = do {
      when GstDeviceProvider {
        $to-parent = cast(GstObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstDeviceProvider, $_);
      }
    };
    self.setGstObject($to-parent);
  }

  method GStreamer::Raw::Types::GstDeviceProvider
    is also<GstDeviceProvider>
  { $!dp }

  method new (GstDeviceProviderAncestry $provider) {
    $provider ?? self.bless( :$provider ) !! Nil;
  }

  # SIGNALS
  method provider-hidden {
    self.connect-string('provider-hidden');
  }

  method provider-unhidden {
    self.connect-string('provider-unhidden');
  }

  method can_monitor is also<can-monitor> {
    so gst_device_provider_can_monitor($!dp);
  }

  method device_add (GstDevice() $device) is also<device-add> {
    gst_device_provider_device_add($!dp, $device);
  }

  method device_changed (GstDevice() $device, GstDevice() $changed_device)
    is also<device-changed>
  {
    gst_device_provider_device_changed($!dp, $device, $changed_device);
  }

  method device_remove (GstDevice() $device) is also<device-remove> {
    gst_device_provider_device_remove($!dp, $device);
  }

  method get_bus (:$raw = False) is also<get-bus> {
    my $b = gst_device_provider_get_bus($!dp);

    $b ??
      ( $raw ?? $b !! GStreamer::Bus.new($b) )
      !!
      GstBus;
  }

  method get_devices (
    :$glist = False,
    :$raw = False
  )
    is also<get-devices>
  {
    my $d = gst_device_provider_get_devices($!dp);

    return Nil unless $d;
    return $d if $glist;

    $d = GLib::GList.new($d) but GLib::Roles::ListData[GstDevice];

    $raw ?? $d.Array !! $d.Array.map({ GStreamer::Device.new($_) });
  }

  # Object is NYI
  method get_factory (:$raw = False) is also<get-factory> {
    my $f = gst_device_provider_get_factory($!dp);
  }

  method get_hidden_providers is also<get-hidden-providers> {
    my $hp = gst_device_provider_get_hidden_providers($!dp);

    my ($idx, @rv) = (0);
    repeat {
      @rv.push($hp[$idx] );
    } while $hp[++$idx].defined;
    @rv;
  }

  method get_metadata (Str() $key) is also<get-metadata> {
    gst_device_provider_get_metadata($!dp, $key);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_device_provider_get_type, $n, $t );
  }

  method hide_provider (Str() $name) is also<hide-provider> {
    gst_device_provider_hide_provider($!dp, $name);
  }

  multi method register (
    Str() $name,
    Int() $rank,
    Int() $type
  ) {
    samewith(GstPlugin, $name, $rank, $type);
  }
  multi method register (
    GStreamer::DeviceProvider:U:
    GstPlugin() $plugin,
    Str() $name,
    Int() $rank,
    Int() $type
  ) {
    my guint $r = $rank;
    my GType $t = $type;

    so gst_device_provider_register($plugin, $name, $r, $t);
  }

  method start {
    so gst_device_provider_start($!dp);
  }

  method stop {
    gst_device_provider_stop($!dp);
  }

  method unhide_provider (Str() $name) is also<unhide-provider> {
    gst_device_provider_unhide_provider($!dp, $name);
  }

}
