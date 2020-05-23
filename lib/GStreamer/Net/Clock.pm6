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
    Str() $remote_address,
    Int() $remote_port,
    Int() $base_time = 0
  ) {
    samewith(Str, $remote_address, $remote_port, $base_time);
  }
  multi method new (
    Str() $name,
    Str() $remote_address,
    Int() $remote_port,
    Int() $base_time = 0
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

  multi method new (
    Str() $remote_address,
    Int() $remote_port,
    Int() $base_time = 0
  ) {
    samewith(Str, $remote_address, $remote_port, 0);
  }
  multi method new (
    Str() $name,
    Str() $remote_address,
    Int() $remote_port,
    Int() $base_time = 0
  ) {
    my gint $r = $remote_port;
    my GstClockTime $b = $base_time;
    my $net-clock = gst_ntp_clock_new($name, $remote_address, $r, $b);

    $net-clock ?? self.bless( :$net-clock ) !! Nil;
  }

}

our subset GstNetTimeProviderAncestry is export of Mu
  where GstNetTimeProvider | GstObject;

class GStreamer::Net::Provider is GStreamer::Object {
  has GstNetTimeProvider $!ntp;

  submethod BUILD (:$time-provider) {
    self.setGstNetTimeProvider($time-provider);
  }

  method setGstNetTimeProvider (GstNetTimeProviderAncestry $_) {
    my $to-parent;

    $!ntp = do {
      when GstNetTimeProvider {
        $to-parent = cast(GstObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstNetTimeProvider, $_);
      }
    }
    self.setGstObject($to-parent);
  }

  multi method new (GstNetTimeProviderAncestry $time-provider) {
    $time-provider ?? self.bless( :$time-provider ) !! Nil;
  }
  multi method new (GstClock() $clock, Int() $port) {
    samewith($clock, Str, $port);
  }
  multi method new (GstClock() $clock, Str() $address, Int() $port) {
    my gint $p = $port;

    gst_net_time_provider_new($clock, $address, $p);
  }

  # Type: gboolean
  method active is rw  {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('active', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('active', $gv);
      }
    );
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

  # Type: GstClock
  method clock (:$raw = False) is rw  {
    my $gv = GLib::Value.new( GStreamer::Clock.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('clock', $gv)
        );

        my $o = $gv.object;
        return Nil unless $o;

        $o = cast(GstClock, $o);
        return $o if $raw;

        GStreamer::Clock.new($o);
      },
      STORE => -> $, GstClock() $val is copy {
        $gv.object = $val;
        self.prop_set('clock', $gv);
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

### /usr/include/gstreamer-1.0/gst/net/gstnettimeprovider.h

sub gst_net_time_provider_get_type ()
  returns GType
  is native(gstreamer-net)
  is export
{ * }

sub gst_net_time_provider_new (
  GstClock $clock,
  Str $address,
  gint $port
)
  returns GstNetTimeProvider
  is native(gstreamer-net)
  is export
{ * }
