use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

use GStreamer::Bus;
use GStreamer::SystemClock;

our subset GstNetClientClockAncestry is export of Mu
  where GstNetClientClock | GstSystemClockAncestry;

class GStreamer::Net::ClientClock is GStreamer::SystemClock {
  has GstNetClientClock $!nc;

  submethod BUILD (:$net-clock) {
    self.setGstNetClientClock($net-clock) if $net-clock;
  }

  method setGstNetClientClock (GstNetClientClockAncestry $_) {
    my $to-parent;

    $!nc = do {
      when GstNetClientClock {
        $to-parent = cast(GstSystemClock, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstNetClientClock, $_);
      }
    }
    self.setGstSystemClock($to-parent);
  }


  multi method new (GstNetClientClock $net-clock) {
    $net-clock ?? self.bless( :$net-clock ) !! Nil;
  }
  multi method new (
    Str() $name,
    Str() $remote_address,
    Int() $remote_port,
    Int() $base_time
  ) {
    my gint $r = $remote_port;
    my GstClockTime $b = $base_time;
    my $net-clock = gst_net_client_clock_new($name, $remote_address, $r, $b);

    $net-clock ?? self.bless( :$net-clock ) !! Nil;
  }

  # Type: gchar
  method address is rw  {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('address', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('address', $gv);
      }
    );
  }

  # Type: guint64
  method base-time is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT64 );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('base-time', $gv)
        );
        $gv.uint64;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint64 = $val;
        self.prop_set('base-time', $gv);
      }
    );
  }

  # Type: GstBus
  method bus (:$raw = False) is rw  {
    my $gv = GLib::Value.new( GStreamer::Bus.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('bus', $gv)
        );

        my $o = $gv.object;
        return Nil unless $o;

        $o = cast(GstBus, $o);
        return $o if $raw;

        GStreamer::Bus.new($o);
      },
      STORE => -> $, GstBus() $val is copy {
        $gv.object = $val;
        self.prop_set('bus', $gv);
      }
    );
  }

  # Type: GstClock
  method internal-clock (:$raw = False) is rw  {
    my $gv = GLib::Value.new( GStreamer::Clock.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('internal-clock', $gv)
        );

        my $o = $gv.object;
        return Nil unless $o;

        $o = cast(GstClock, $o);
        return $o if $raw;

        GStreamer::Clock.new($o);
      },
      STORE => -> $,  $val is copy {
        warn 'internal-clock does not allow writing'
      }
    );
  }

  # Type: guint64
  method minimum-update-interval is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT64 );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('minimum-update-interval', $gv)
        );
        $gv.uint64;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint64 = $val;
        self.prop_set('minimum-update-interval', $gv);
      }
    );
  }

  # Type: gint
  method port is rw  {
    my $gv = GLib::Value.new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('port', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('port', $gv);
      }
    );
  }

  # Type: gint
  method qos-dscp is rw  {
    my $gv = GLib::Value.new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('qos-dscp', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('qos-dscp', $gv);
      }
    );
  }

  # Type: guint64
  method round-trip-limit is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT64 );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('round-trip-limit', $gv)
        );
        $gv.uint64;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint64 = $val;
        self.prop_set('round-trip-limit', $gv);
      }
    );
  }

}


class GStreamer::Net::NTPClock is GStreamer::Net::ClientClock {

  method new (Str() $name, Str() $remote_address, Int() $remote_port, Int() $base_time) {
    my gint $r = $remote_port;
    my GstClockTime $b = $base_time;
    my $net-clock = gst_ntp_clock_new($name, $remote_address, $r, $b);

    $net-clock ?? self.bless( :$net-clock ) !! Nil;
  }

}


### /usr/include/gstreamer-1.0/gst/net/gstnetclientclock.h

sub gst_net_client_clock_new (
  Str $name,
  Str $remote_address,
  gint $remote_port,
  GstClockTime $base_time
)
  returns GstNetClientClock
  is native(gstreamer-net)
  is export
{ * }

sub gst_ntp_clock_new (
  Str $name,
  Str $remote_address,
  gint $remote_port,
  GstClockTime $base_time
)
  returns GstNetClientClock
  is native(gstreamer-net)
  is export
{ * }
