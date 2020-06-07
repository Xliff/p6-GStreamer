use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Plugins::GstISOMP4::Raw;

use GStreamer::Element;

use GStreamer::Roles::Preset;

our subset GstGppMux3Ancestry is export of Mu
  where GstQTMux | GstElementAncestry;

class GStreamer::Plugins::Gppmux3 is GStreamer::Element {
  #also does GStreamer::Roles::TagSetter;
  #also does GStreamer::Roles::TagXMPWriter;
  also does GStreamer::Roles::Preset;

  # Closest struct def in plugin!
  has GstQTMux $!qtmux3;

  submethod BUILD (:$mux3) {
    self.setGstMux3($mux3) if $mux3;
  }

  method setGstMux3(GstGppMux3Ancestry $_) {
    my $to-parent;

    $!qtmux3 = do  {
      when GstQTMux {
        $to-parent = cast(GstElement, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstQTMux, $_);
      }
    }
    self.setGstElement($to-parent);
  }

  method GStreamer::Raw::Structs::GstQTMux
    is also<GstQTMux>
  { $!qtmux3 }

  method new (GstGppMux3Ancestry $mux3) {
    $mux3 ?? self.bless( :$mux3 ) !! Nil;
  }

  # Type: GstQTMuxDtsMethods
  # Marked as DEPRECATED in gst-inspect!
  # No enum found!
  #
  # From gst-inspect:
  # Enum "GstQTMuxDtsMethods" Default: 1, "reorder"
  # (0): dd               - delta/duration
  # (1): reorder          - reorder
  # (2): asc              - ascending
  method dts-method is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('dts-method', $gv)
        );
        $gv.uint
      },
      STORE => -> $, Int() $val is copy {
        warn 'dts-method is a construct-only attribute'
      }
    );
  }

  # Type: gboolean
  method faststart is rw  {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('faststart', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('faststart', $gv);
      }
    );
  }

  # Type: gchararray
  method faststart-file is rw  {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('faststart-file', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'faststart-file is a construct-only attribute'
      }
    );
  }

  # Not in gst-inspect
  #
  # Type: gboolean
  # method force-chunks is rw  {
  #   my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
  #   Proxy.new(
  #     FETCH => sub ($) {
  #       $gv = GLib::Value.new(
  #         self.prop_get('force-chunks', $gv)
  #       );
  #       $gv.boolean;
  #     },
  #     STORE => -> $, Int() $val is copy {
  #       $gv.boolean = $val;
  #       self.prop_set('force-chunks', $gv);
  #     }
  #   );
  # }

  # Not in gst-inspect!
  #
  # Type: gboolean
  # method force-create-timecode-trak is rw  {
  #   my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
  #   Proxy.new(
  #     FETCH => sub ($) {
  #       $gv = GLib::Value.new(
  #         self.prop_get('force-create-timecode-trak', $gv)
  #       );
  #       $gv.boolean;
  #     },
  #     STORE => -> $, Int() $val is copy {
  #       warn 'force-create-timecode-trak is a construct-only attribute'
  #     }
  #   );
  # }

  # Type: guint
  method fragment-duration is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('fragment-duration', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        warn 'fragment-duration is a construct-only attribute'
      }
    );
  }

  # Type: guint64
  method interleave-bytes is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT64 );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('interleave-bytes', $gv)
        );
        $gv.uint64;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint64 = $val;
        self.prop_set('interleave-bytes', $gv);
      }
    );
  }

  # Type: guint64
  method interleave-time is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT64 );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('interleave-time', $gv)
        );
        $gv.uint64;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint64 = $val;
        self.prop_set('interleave-time', $gv);
      }
    );
  }

  # Not in gst-inspect!
  #
  # Type: guint64
  # method latency is rw  {
  #   my $gv = GLib::Value.new( G_TYPE_UINT64 );
  #   Proxy.new(
  #     FETCH => sub ($) {
  #       $gv = GLib::Value.new(
  #         self.prop_get('latency', $gv)
  #       );
  #       $gv.uint64;
  #     },
  #     STORE => -> $, Int() $val is copy {
  #       $gv.uint64 = $val;
  #       self.prop_set('latency', $gv);
  #     }
  #   );
  # }

  # Type: guint64
  method max-raw-audio-drift is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT64 );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('max-raw-audio-drift', $gv)
        );
        $gv.uint64;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint64 = $val;
        self.prop_set('max-raw-audio-drift', $gv);
      }
    );
  }

  # Type: guint64
  method min-upstream-latency is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT64 );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('min-upstream-latency', $gv)
        );
        $gv.uint64;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint64 = $val;
        self.prop_set('min-upstream-latency', $gv);
      }
    );
  }

  # Type: gchararray
  method moov-recovery-file is rw  {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('moov-recovery-file', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'moov-recovery-file is a construct-only attribute'
      }
    );
  }

  # Type: guint
  method movie-timescale is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('movie-timescale', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        warn 'movie-timescale is a construct-only attribute'
      }
    );
  }

  # Present in gst-inspect, but not on GStreamer docs page!
  # Currently r/o
  method parent (:$raw = False) is rw  {
    my $gv = GLib::Value.new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('presentation-time', $gv)
        );

        return Nil unless

        my $o = cast(GstObject, $gv.object);
        return $o if $raw;

        return GStreamer::Object.new($o)
      },
      STORE => -> $, GstObject() $val is copy {
        warn 'parent is a construct-only attribute'
      }
    );
  }

  # Type: gboolean
  method presentation-time is rw  {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('presentation-time', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        warn 'presentation-time is a construct-only attribute'
      }
    );
  }

  # Type: guint
  method reserved-bytes-per-sec is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('reserved-bytes-per-sec', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        warn 'reserved-bytes-per-sec is a construct-only attribute'
      }
    );
  }

  # Type: guint64
  method reserved-duration-remaining is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT64 );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('reserved-duration-remaining', $gv)
        );
        $gv.uint64;
      },
      STORE => -> $, Int() $val is copy {
        warn 'reserved-duration-remaining does not allow writing'
      }
    );
  }

  # Type: guint64
  method reserved-max-duration is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT64 );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('reserved-max-duration', $gv)
        );
        $gv.uint64;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint64 = $val;
        self.prop_set('reserved-max-duration', $gv);
      }
    );
  }

  # Type: guint64
  method reserved-moov-update-period is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT64 );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('reserved-moov-update-period', $gv)
        );
        $gv.uint64;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint64 = $val;
        self.prop_set('reserved-moov-update-period', $gv);
      }
    );
  }

  # Type: gboolean
  method reserved-prefill is rw  {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('reserved-prefill', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        warn 'reserved-prefill is a construct-only attribute'
      }
    );
  }

  # Type: guint64
  method start-gap-threshold is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT64 );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('start-gap-threshold', $gv)
        );
        $gv.uint64;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint64 = $val;
        self.prop_set('start-gap-threshold', $gv);
      }
    );
  }

  # Not in gst-inspect
  #
  # Type: guint64
  # method start-time is rw  {
  #   my $gv = GLib::Value.new( G_TYPE_UINT64 );
  #   Proxy.new(
  #     FETCH => sub ($) {
  #       $gv = GLib::Value.new(
  #         self.prop_get('start-time', $gv)
  #       );
  #       $gv.uint64;
  #     },
  #     STORE => -> $, Int() $val is copy {
  #       $gv.uint64 = $val;
  #       self.prop_set('start-time', $gv);
  #     }
  #   );
  # }

  # Not in gst-inspect!
  #
  # Type: GstAggregatorStartTimeSelection
  # method start-time-selection is rw  {
  #   my $gv = GLib::Value.new( -type- );
  #   Proxy.new(
  #     FETCH => sub ($) {
  #       $gv = GLib::Value.new(
  #         self.prop_get('start-time-selection', $gv)
  #       );
  #       #$gv.TYPE
  #     },
  #     STORE => -> $,  $val is copy {
  #       #$gv.TYPE = $val;
  #       self.prop_set('start-time-selection', $gv);
  #     }
  #   );
  # }

  # Type: gboolean
  method streamable is rw  {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('streamable', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        warn 'streamable is a construct-only attribute'
      }
    );
  }

  # Type: guint
  method trak-timescale is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('trak-timescale', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        warn 'trak-timescale is a construct-only attribute'
      }
    );
  }

}
