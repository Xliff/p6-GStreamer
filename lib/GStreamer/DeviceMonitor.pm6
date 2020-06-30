use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::DeviceMonitor;

use GStreamer::Object;

use GLib::GList;

use GStreamer::Bus;
use GStreamer::Device;

use GLib::Roles::Signals::Generic;

our subset GstDeviceMonitorAncestry is export of Mu
  where GstDeviceMonitor | GstObject;

class GStreamer::DeviceMonitor is GStreamer::Object {
  also does GLib::Roles::Signals::Generic;

  has GstDeviceMonitor $!dm;

  submethod BUILD (:$monitor) {
    self.setDeviceMonitor($monitor);
  }

  method setDeviceMonitor (GstDeviceMonitorAncestry $_) {
    my $to-parent;

    $!dm = do {
      when GstDeviceMonitor {
        $to-parent = cast(GstObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstDeviceMonitor, $_);
      }
    }

    self.setGstObject($to-parent);
  }

  multi method new (GstDeviceMonitorAncestry $monitor) {
    $monitor ?? self.bless( :$monitor ) !! Nil;
  }
  multi method new {
    my $monitor = gst_device_monitor_new();

    $monitor ?? self.bless( :$monitor ) !! Nil;
  }

  # Is originally:
  # GstDeviceProvider, gchar, gpointer
  method provider-hidden {
    self.connect-string($!dm, 'provider-hidden');
  }

  # Is originally:
  # GstDeviceProvider, gchar, gpointer
  method provider-unhidden {
    self.connect-provider-unhidden($!dm, 'provider-unhidden');
  }

  method show_all_devices is rw
    is also<
      show-all-devices
      show_all
      show-all
    >
  {
    Proxy.new(
      FETCH => sub ($) {
        so gst_device_monitor_get_show_all_devices($!dm);
      },
      STORE => sub ($, Int() $show_all is copy) {
        my gboolean $sa = $show_all.so.Int;

        gst_device_monitor_set_show_all_devices($!dm, $sa);
      }
    );
  }

  method add_filter (Str() $classes, GstCaps() $caps) is also<add-filter> {
    gst_device_monitor_add_filter($!dm, $classes, $caps);
  }

  method get_bus (:$raw = False)
    is also<
      get-bus
      bus
    >
  {
    my $b = gst_device_monitor_get_bus($!dm);

    $b ??
      ( $raw ?? $b !! GStreamer::Bus.new($b) )
      !!
      Nil;
  }

  method get_devices (:$glist = False, :$raw = False)
    is also<
      get-devices
      devices
    >
  {
    my $dl = gst_device_monitor_get_devices($!dm);

    return Nil unless $dl;
    return $dl if $glist;

    $dl = GLib::GList.new($dl) but GLib::Roles::ListData[GstDevice];
    $raw ?? $dl.Array !! $dl.Array.map({ GStreamer::Device.new($_) });
  }

  method get_providers
    is also<
      get-providers
      providers
    >
  {
    CStringArrayToArray( gst_device_monitor_get_providers($!dm) );
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_device_monitor_get_type, $n, $t );
  }

  method remove_filter (Int() $filter_id) is also<remove-filter> {
    my guint $f = $filter_id;

    so gst_device_monitor_remove_filter($!dm, $f);
  }

  method start {
    so gst_device_monitor_start($!dm);
  }

  method stop {
    so gst_device_monitor_stop($!dm);
  }

}
