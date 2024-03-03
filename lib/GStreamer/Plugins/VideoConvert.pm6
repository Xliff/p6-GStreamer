use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;

use GStreamer::Video::Filter;

use GLib::Roles::Pointers;

class GstVideoConvert            is repr<CStruct>     does GLib::Roles::Pointers is export {
  HAS GstVideoFilter           $.element;

  has GstVideoConverter        $!convert;
  has GstVideoDitherMethod     $.dither              is rw;
  has guint                    $.dither_quantization is rw;
  has GstVideoResamplerMethod  $.chroma_resampler    is rw;
  has GstVideoAlphaMode        $.alpha_mode          is rw;
  has GstVideoChromaMode       $.chroma_mode         is rw;
  has GstVideoMatrixMode       $.matrix_mode         is rw;
  has GstVideoGammaMode        $.gamma_mode          is rw;
  has GstVideoPrimariesMode    $.primaries_mode      is rw;
  has gdouble                  $.alpha_value         is rw;
  has gint                     $.n_threads           is rw;
}

our subset GstVideoConvertAncestry is export of Mu
  where GstVideoConvert | GstVideoFilterAncestry;

class GStreamer::Plugins::VideoConvert is GStreamer::Video::Filter {
  has GstVideoConvert $!vf;

  submethod BUILD (:$video-convert) {
    self.setGstVideoConvert($video-convert) if $video-convert;
  }

  method setGstVideoConvert (GstVideoConvertAncestry $_) {
    my $to-parent;

    $!vf = do {
      when GstVideoConvert {
        $to-parent = cast(GstVideoFilter, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstVideoConvert, $_);
      }
    }
    self.setGstVideoFilter($to-parent);
  }

  method GStreamer::Raw::Structs::GstVideoConvert
    is also<GstVideoConvert>
  { $!vf }

  method new (GstVideoConvertAncestry $video-convert) {
    $video-convert ?? self.bless( :$video-convert ) !! Nil;
  }

  # Type: Video-alpha-mode
  method alpha-mode is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('alpha-mode', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT );
        $gv.uint = $val;
        self.prop_set('alpha-mode', $gv);
      }
    );
  }

  # Type: gdouble
  method alpha-value is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('alpha-value', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv = GLib::Value.new( G_TYPE_DOUBLE );
        $gv.double = $val;
        self.prop_set('alpha-value', $gv);
      }
    );
  }

  # Type: Video-chroma-mode
  method chroma-mode is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('chroma-mode', $gv)
        );
        $gv.uint
      },
      STORE => -> $,  $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT );
        $gv.uint = $val;
        self.prop_set('chroma-mode', $gv);
      }
    );
  }

  # Type: Video-resampler-method
  method chroma-resampler is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('chroma-resampler', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT );
        $gv.uint = $val;
        self.prop_set('chroma-resampler', $gv);
      }
    );
  }

  # Type: Video-dither-method
  method dither is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('dither', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int()  $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT );
        $gv.uint = $val;
        self.prop_set('dither', $gv);
      }
    );
  }

  # Type: guint
  method dither-quantization is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('dither-quantization', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT );
        $gv.uint = $val;
        self.prop_set('dither-quantization', $gv);
      }
    );
  }

  # Type: Video-gamma-mode
  method gamma-mode is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('gamma-mode', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT );
        $gv.uint = $val;
        self.prop_set('gamma-mode', $gv);
      }
    );
  }

  # Type: Video-matrix-mode
  method matrix-mode is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('matrix-mode', $gv)
        );
        $gv.uint
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT );
        $gv.uint = $val;
        self.prop_set('matrix-mode', $gv);
      }
    );
  }

  # Type: guint
  method n-threads is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('n-threads', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT );
        $gv.uint = $val;
        self.prop_set('n-threads', $gv);
      }
    );
  }

  # Type: gchararray
  method name is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('name', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv = GLib::Value.new( G_TYPE_STRING );
        $gv.string = $val;
        self.prop_set('name', $gv);
      }
    );
  }

  # Type: GstObject
  method parent is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('parent', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT );
        $gv.uint = $val;
        self.prop_set('parent', $gv);
      }
    );
  }

  # Type: Video-primaries-mode
  method primaries-mode is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('primaries-mode', $gv)
        );
        $gv.uint
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT );
        $gv.uint = $val;
        self.prop_set('primaries-mode', $gv);
      }
    );
  }

  # Type: gboolean
  method qos is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('qos', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_BOOLEAN );
        $gv.boolean = $val;
        self.prop_set('qos', $gv);
      }
    );
  }

}
