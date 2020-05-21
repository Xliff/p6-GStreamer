use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;

use GLib::Value;
use GStreamer::Base::PushSrc;

use GLib::Roles::Pointers;

package GStreamer::Plugins::VideoTestSrc::Package {

  constant GstVideoTestSrcAnimationMode is export := guint32;
  our enum GstVideoTestSrcAnimationModeEnum is export <
    GST_VIDEO_TEST_SRC_FRAMES
    GST_VIDEO_TEST_SRC_WALL_TIME
    GST_VIDEO_TEST_SRC_RUNNING_TIME
  >;

  constant GstVideoTestSrcMotionType is export := guint32;
  our enum GstVideoTestSrcMotionTypeEnum is export <
    GST_VIDEO_TEST_SRC_WAVY
    GST_VIDEO_TEST_SRC_SWEEP
    GST_VIDEO_TEST_SRC_HSWEEP
  >;

  constant GstVideoTestSrcPattern is export := guint32;
  our enum GstVideoTestSrcPatternEnum is export <
    GST_VIDEO_TEST_SRC_SMPTE
    GST_VIDEO_TEST_SRC_SNOW
    GST_VIDEO_TEST_SRC_BLACK
    GST_VIDEO_TEST_SRC_WHITE
    GST_VIDEO_TEST_SRC_RED
    GST_VIDEO_TEST_SRC_GREEN
    GST_VIDEO_TEST_SRC_BLUE
    GST_VIDEO_TEST_SRC_CHECKERS1
    GST_VIDEO_TEST_SRC_CHECKERS2
    GST_VIDEO_TEST_SRC_CHECKERS4
    GST_VIDEO_TEST_SRC_CHECKERS8
    GST_VIDEO_TEST_SRC_CIRCULAR
    GST_VIDEO_TEST_SRC_BLINK
    GST_VIDEO_TEST_SRC_SMPTE75
    GST_VIDEO_TEST_SRC_ZONE_PLATE
    GST_VIDEO_TEST_SRC_GAMUT
    GST_VIDEO_TEST_SRC_CHROMA_ZONE_PLATE
    GST_VIDEO_TEST_SRC_SOLID
    GST_VIDEO_TEST_SRC_BALL
    GST_VIDEO_TEST_SRC_SMPTE100
    GST_VIDEO_TEST_SRC_BAR
    GST_VIDEO_TEST_SRC_PINWHEEL
    GST_VIDEO_TEST_SRC_SPOKES
    GST_VIDEO_TEST_SRC_GRADIENT
    GST_VIDEO_TEST_SRC_COLORS
  >;

  class GstVideoTestSrc is repr<CStruct>     does GLib::Roles::Pointers is export {
    HAS GstPushSrc                   $.element;
    # Private
    # type of output
    has GstVideoTestSrcPattern       $!pattern_type;
    # video state
    HAS GstVideoInfo                 $!info;                    #= protected by the object or stream lock
    has GstVideoChromaResample       $!subsample;
    has gboolean                     $!bayer;
    has gint                         $!x_invert;
    has gint                         $!y_invert;
    # private */
    has gint64                       $!timestamp_offset;        #= base offset
    # running time and frames for current caps
    has GstClockTime                 $!running_time;            #= total running time
    has gint64                       $!n_frames;                #= total frames sent
    has gboolean                     $!reverse;
    # previous caps running time and frames
    has GstClockTime                 $!accum_rtime;             #= accumulated running_time
    has gint64                       $!accum_frames;            #= accumulated frames
    # zoneplate
    has gint                         $!k0;
    has gint                         $!kx;
    has gint                         $!ky;
    has gint                         $!kt;
    has gint                         $!kxt;
    has gint                         $!kyt;
    has gint                         $!kxy;
    has gint                         $!kx2;
    has gint                         $!ky2;
    has gint                         $!kt2;
    has gint                         $!xoffset;
    has gint                         $!yoffset;
    # solid color
    has guint                        $!foreground_color;
    has guint                        $!background_color;
    # moving color bars
    has gint                         $!horizontal_offset;
    has gint                         $!horizontal_speed;
    # smpte & snow
    has guint                        $!random_state;
    # Ball motion
    has GstVideoTestSrcAnimationMode $!animation_mode;
    has GstVideoTestSrcMotionType    $!motion_type;
    has gboolean                     $!flip;
    has Pointer                      $!make_image;              #= void (*make_image) (GstVideoTestSrc *v, GstClockTime pts, GstVideoFrame *frame);
    # temporary AYUV/ARGB scanline
    has CArray[guint8]               $!tmpline_u8;
    has CArray[guint8]               $!tmpline;
    has CArray[guint8]               $!tmpline2;
    has CArray[guint16]              $!tmpline_u16;
    has guint                        $!n_lines;
    has gint                         $!offset;
    has CArray[gpointer]             $!lines;
  }

}

import GStreamer::Plugins::VideoTestSrc::Package;

our subset GstVideoTestSrcAncestry is export of Mu
  where GstVideoTestSrc | GstPushSrcAncestry;

class GStreamer::Plugins::VideoTestSrc is GStreamer::Base::PushSrc {
  has GstVideoTestSrc $!vts;

  submethod BUILD (:$video-test-src) {
    self.setGstVideoTestSrc($video-test-src);
  }

  method setGstVideoTestSrc (GstVideoTestSrcAncestry $_) {
    my $to-parent;

    $!vts = do {
      when GstVideoTestSrc {
        $to-parent = cast(GstPushSrc, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstVideoTestSrc, $_);
      }
    }
    self.setGstPushSrc($to-parent);
  }

  method GStreamer::Raw::Structs::GstVideoTestSrc
    is also<GstVideoTestSrc>
  { $!vts }

  method new (GstVideoTestSrcAncestry $video-test-src) {
    $video-test-src ?? self.bless( :$video-test-src ) !! Nil;
  }

  # Type: Video-test-src-animation-mode
  method animation-mode is rw  is also<animation_mode> {
    my $gv = GLib::Value.new(
      GLib::Value.typeFromEnum(GstVideoTestSrcAnimationMode)
    );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('animation-mode', $gv)
        );
        GstVideoTestSrcAnimationModeEnum( $gv.enum )
      },
      STORE => -> $, Int() $val is copy {
        $gv.typeFromEnum(GstVideoTestSrcAnimationMode) = $val;
        self.prop_set('animation-mode', $gv);
      }
    );
  }

  # Type: guint
  method background-color is rw  is also<background_color> {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('background-color', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('background-color', $gv);
      }
    );
  }

  # Type: guint
  method blocksize is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('blocksize', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('blocksize', $gv);
      }
    );
  }

  # Type: gboolean
  method do-timestamp is rw  is also<do_timestamp> {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('do-timestamp', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('do-timestamp', $gv);
      }
    );
  }

  # Type: gboolean
  method flip is rw  {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('flip', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('flip', $gv);
      }
    );
  }

  # Type: guint
  method foreground-color is rw  is also<foreground_color> {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('foreground-color', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('foreground-color', $gv);
      }
    );
  }

  # Type: gint
  method horizontal-speed is rw  is also<horizontal_speed> {
    my $gv = GLib::Value.new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('horizontal-speed', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('horizontal-speed', $gv);
      }
    );
  }

  # Type: gboolean
  method is-live is rw  is also<is_live> {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('is-live', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('is-live', $gv);
      }
    );
  }

  # Type: gint
  method k0 is rw  {
    my $gv = GLib::Value.new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('k0', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('k0', $gv);
      }
    );
  }

  # Type: gint
  method kt is rw  {
    my $gv = GLib::Value.new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('kt', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('kt', $gv);
      }
    );
  }

  # Type: gint
  method kt2 is rw  {
    my $gv = GLib::Value.new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('kt2', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('kt2', $gv);
      }
    );
  }

  # Type: gint
  method kx is rw  {
    my $gv = GLib::Value.new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('kx', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('kx', $gv);
      }
    );
  }

  # Type: gint
  method kx2 is rw  {
    my $gv = GLib::Value.new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('kx2', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('kx2', $gv);
      }
    );
  }

  # Type: gint
  method kxt is rw  {
    my $gv = GLib::Value.new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('kxt', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('kxt', $gv);
      }
    );
  }

  # Type: gint
  method kxy is rw  {
    my $gv = GLib::Value.new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('kxy', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('kxy', $gv);
      }
    );
  }

  # Type: gint
  method ky is rw  {
    my $gv = GLib::Value.new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('ky', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('ky', $gv);
      }
    );
  }

  # Type: gint
  method ky2 is rw  {
    my $gv = GLib::Value.new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('ky2', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('ky2', $gv);
      }
    );
  }

  # Type: gint
  method kyt is rw  {
    my $gv = GLib::Value.new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('kyt', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('kyt', $gv);
      }
    );
  }

  # Type: Video-test-src-motion-type
  method motion is rw  {
    my $gv = GLib::Value.new(
      GLib::Value.typeFromEnum(GstVideoTestSrcMotionType)
    );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('motion', $gv)
        );
        GstVideoTestSrcMotionTypeEnum( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv.typeFromEnum(GstVideoTestSrcMotionType) = $val;
        self.prop_set('motion', $gv);
      }
    );
  }

  # Type: gchararray
  method name is rw  {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('name', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('name', $gv);
      }
    );
  }

  # Type: gint
  method num-buffers is rw  is also<num_buffers> {
    my $gv = GLib::Value.new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('num-buffers', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('num-buffers', $gv);
      }
    );
  }

  # Type: GstObject
  method parent (:$raw = False) is rw  {
    my $gv = GLib::Value.new( GStreamer::Object.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('parent', $gv)
        );

        my $o = $gv.object;
        return Nil unless $o;

        $o = cast(GstObject, $o);
        return $o if $raw;

        GStreamer::Object.new($o);
      },
      STORE => -> $, GstObject() $val is copy {
        $gv.object = $val;
        self.prop_set('parent', $gv);
      }
    );
  }

  # Type: Video-test-src-pattern
  method pattern is rw  {
    my $gv = GLib::Value.new(
      GLib::Value.typeFromEnum(GstVideoTestSrcPattern)
    );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('pattern', $gv)
        );
        GstVideoTestSrcPatternEnum( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv.valueFromEnum(GstVideoTestSrcPattern) = $val;
        self.prop_set('pattern', $gv);
      }
    );
  }

  # Type: gint64
  method timestamp-offset is rw  is also<timestamp_offset> {
    my $gv = GLib::Value.new( G_TYPE_INT64 );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('timestamp-offset', $gv)
        );
        $gv.int64;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int64 = $val;
        self.prop_set('timestamp-offset', $gv);
      }
    );
  }

  # Type: gboolean
  method typefind is rw  {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('typefind', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('typefind', $gv);
      }
    );
  }

  # Type: gint
  method xoffset is rw  {
    my $gv = GLib::Value.new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('xoffset', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('xoffset', $gv);
      }
    );
  }

  # Type: gint
  method yoffset is rw  {
    my $gv = GLib::Value.new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('yoffset', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('yoffset', $gv);
      }
    );
  }

  # sub gst_video_test_src_get_type ()
  #   returns GType
  #   is native(gstreamer-videotestsrc)
  # { * }
}
