use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;

use GLib::Value;
use GStreamer::Element;
use GStreamer::Object;
use GStreamer::Audio::Converter;

use GLib::Roles::Pointers;

unit package GStreamer::Plugins::AudioConvert;

class GstAudioConvert            is repr<CStruct>     does GLib::Roles::Pointers is export {
  HAS GstBaseTransform           $.element;
  # Properties
  has GstAudioDitherMethod       $.dither              is rw; #= Enum
  has GstAudioNoiseShapingMethod $.ns                  is rw; #= Enum
  HAS GValue                     $.mix_matrix;
  has gboolean                   $.mix_matrix_was_set  is rw;
  HAS GstAudioInfo               $.in_info;
  HAS GstAudioInfo               $.out_info;
  has GstAudioConverter          $!convert;

  method convert (:$raw = False) is rw {
    Proxy.new(
      FETCH => -> $ {
        my $c = self.^attributes[* - 1].get_value(self);

        $c ?? ( $raw ?? $c !! GStreamer::Audio::Converter.new($c) )
           !! Nil
      },
      STORE => -> $, GstAudioConverter() \a {
        self.^attributes[* - 1].set_value(self, a)
      }
    );
  }
}

our subset GstAudioConvertAncestry is export of Mu
  where GstAudioConvert | GstElementAncestry;

class GStreamer::Plugins::AudioConvert is GStreamer::Element {
  has GstAudioConvert $!ac;

  submethod BUILD (:$audio-convert) {
    self.setAudioConvert($audio-convert);
  }

  method setAudioConvert (GstAudioConvertAncestry $_) {
    my $to-parent;

    $!ac = do {
      when GstAudioConvert {
        $to-parent = cast(GstElement, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstAudioConvert, $_);
      }
    }
    self.setGstElement($to-parent);
  }

  method GStreamer::Plugins::Base::GST::AudioConvert::GstAudioConvert
    is also<GstAudioConvert>
  { $!ac }

  method new (GstAudioConvertAncestry $audio-convert) {
    $audio-convert ?? self.bless( :$audio-convert ) !! Nil;
  }

  # Type: Audio-dither-method
  method dithering is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('dithering', $gv)
        );
        GstAudioDitherMethodEnum( $gv.enum )
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new(
          GLib::Value.typeFromEnum(GstAudioDitherMethod)
        );
        $gv.valueFromEnum(GstAudioDitherMethod) = $val;
        self.prop_set('dithering', $gv);
      }
    );
  }

  # Type: GValue (GstValueArray)
  method mix-matrix (:$raw = False) is rw  is also<mix_matrix> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('mix-matrix', $gv)
        );

        $raw ?? $gv.GValue
             !! GStreamer::Value::Array.new( $gv.gvalue )
      },
      # Can still be mixed up with your average GValue, so better identification
      # and error handling may be needed.
      STORE => -> $, GValue() $val is copy {
        self.prop_set('mix-matrix', $val);
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
        $gv.Str;
      },
      STORE => -> $, Str() $val is copy {
        $gv = GLib::Value.new( G_TYPE_STRING );
        $gv.Str = $val;
        self.prop_set('name', $gv);
      }
    );
  }

  # Type: Audio-noise-shaping-method
  method noise-shaping is rw  is also<noise_shaping> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('noise-shaping', $gv)
        );
        GstAudioNoiseShapingMethodEnum( $gv.enum );
      },
      STORE => -> $,  $val is copy {
        $gv = GLib::Value.new(
          GLib::Value.typeFromEnum(GstAudioNoiseShapingMethod)
        );
        $gv.valueFromEnum(GstAudioNoiseShapingMethod) = $val;
        self.prop_set('noise-shaping', $gv);
      }
    );
  }

  # Type: GstObject
  method parent (:$raw = False) is rw  {
    my $gv;
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
        $gv = GLib::Value.new( GStreamer::Object.get_type );
        $gv.object = $val;
        self.prop_set('parent', $gv);
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
