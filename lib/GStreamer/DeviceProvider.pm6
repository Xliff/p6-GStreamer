use v6.c;

use Method::Also;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::DeviceProvider;

use GStreamer::Object;
use GStreamer::Bus;

our subset DeviceProviderAncestry is export of Mu
  where GstDeviceProvider | GstObject;

class GStreamer::DeviceProvider is GStreamer::Object {
  has GstDeviceProvider $!dp ;

  submethod BUILD (:$provider) {
    self.setDeviceProvider($provider);
  }

  method setDeviceProvider (DeviceProviderAncestry $_) {
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

  # SIGNALS - NYI

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
      Nil;
  }

  method get_devices (
    :raw_list(:$raw-list) = False,
    :$raw = False
  )
    is also<get-devices>
  {
    my $d = gst_device_provider_get_devices($!dp);
    return $d if $raw-list;

    $d = GTK::Compat::GList.new($d)
      but GTK::Compat::Roles::ListData[GstDevice];

    $d ??
      ( $raw ?? $d.Array !! $d.Array.map({ GStreamer::Device.new($_) }) )
      !!
      Nil;
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
