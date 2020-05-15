use v6.c;

use NativeCall;
use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Clock;

use GStreamer::Clock;

class GStreamer::SystemClock is GStreamer::Clock {

  submethod BUILD (:$sclock) {
    self.setSystemClock($sclock);
  }

  method setSystemClock ($sclock) {
    self.setClock($sclock);
  }

  method new (GstClockAncestry $sclock) {
    $sclock ?? self.bless(:$sclock) !! Nil;
  }

  # Type: GstClockType
  method clock-type is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('clock-type', $gv)
        );
        GstClockTypeEnum( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT );
        $gv.uint = $val;
        self.prop_set('clock-type', $gv);
      }
    );
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_system_clock_get_type, $n, $t);
  }

  method obtain (:$raw = False) {
    my $sc = gst_system_clock_obtain();

    $sc ??
      ( $raw ?? $sc !! GStreamer::SystemClock.new($sc) )
      !!
      Nil;
  }

  method set_default (GstClock() $nc) {
    gst_system_clock_set_default($nc);
  }

}

### /usr/include/gstreamer-1.0/gst/gstsystemclock.h

sub gst_system_clock_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_system_clock_obtain ()
  returns GstClock
  is native(gstreamer)
  is export
{ * }

sub gst_system_clock_set_default (GstClock $new_clock)
  is native(gstreamer)
  is export
{ * }
