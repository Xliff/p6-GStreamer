use v6.c;

use Method::Also;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::DeviceMonitor;

use GStreamer::Object;

use GLib::GList;

use GStreamer::Bus;
use GStreamer::Device;

our subset DeviceMonitorAncestry is export of Mu
  where GstDeviceMonitor | GstObject;

class GStreamer::DeviceMonitor is GStreamer::Object {
  has GstDeviceMonitor $!dm;

  submethod BUILD (:$monitor) {
    self.setDeviceMonitor($monitor);
  }

  method setDeviceMonitor (DeviceMonitorAncestry $_) {
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
    self.setObject($to-parent);
  }

  multi method new ($monitor) {
    self.bless( :$monitor );
  }
  multi method new {
    self.bless( monitor => gst_device_monitor_new() );
  }

  method show_all_devices is rw is also<show-all-devices> {
    Proxy.new(
      FETCH => sub ($) {
        so gst_device_monitor_get_show_all_devices($!dm);
      },
      STORE => sub ($, Int() $show_all is copy) {
        my gboolean $sa = $show_all;

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

  method get_devices (:$raw = False)
    is also<
      get-devices
      devices
    >
  {
    my $d = GLib::GList.new( gst_device_monitor_get_devices($!dm) )
      but GLib::Roles::ListData[GstDevice];

    $d ??
      ( $raw ?? $d.Array !! $d.Array.map({ GStreamer::Device.new($_) }) )
      !!
      Nil;
  }

  method get_providers
    is also<
      get-providers
      providers
    >
  {
    my @p;
    my $pa = gst_device_monitor_get_providers($!dm);

    if $pa {
      my $pa-idx = 0;
      repeat {
        @p.push( $pa[$pa-idx] );
      } while $pa[$pa-idx++];
    }
    @p;
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
