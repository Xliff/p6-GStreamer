use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;

use GStreamer::Base::Src;

use GLib::Roles::Object;

unit package GStreamer::Plugins::AudioTestSrc;

constant GstAudioTestSrcWave is export := guint32;
our enum GstAudioTestSrcWaveEnum is export <
  GST_AUDIO_TEST_SRC_WAVE_SINE
  GST_AUDIO_TEST_SRC_WAVE_SQUARE
  GST_AUDIO_TEST_SRC_WAVE_SAW
  GST_AUDIO_TEST_SRC_WAVE_TRIANGLE
  GST_AUDIO_TEST_SRC_WAVE_SILENCE
  GST_AUDIO_TEST_SRC_WAVE_WHITE_NOISE
  GST_AUDIO_TEST_SRC_WAVE_PINK_NOISE
  GST_AUDIO_TEST_SRC_WAVE_SINE_TAB
  GST_AUDIO_TEST_SRC_WAVE_TICKS
  GST_AUDIO_TEST_SRC_WAVE_GAUSSIAN_WHITE_NOISE
  GST_AUDIO_TEST_SRC_WAVE_RED_NOISE
  GST_AUDIO_TEST_SRC_WAVE_BLUE_NOISE
  GST_AUDIO_TEST_SRC_WAVE_VIOLET_NOISE
>;

constant PINK_MAX_RANDOM_ROWS  = 30;
constant PINK_RANDOM_BITS      = 16;
constant PINK_RANDOM_SHIFT     = 64 - PINK_RANDOM_BITS;  #= (sizeof(long)*8)-PINK_RANDOM_BITS;

class GstPinkNoise               is repr<CStruct>     does GLib::Roles::Pointers is export {
  HAS glong      @.rows[PINK_MAX_RANDOM_ROWS] is CArray;

  has glong      $.running_sum is rw; #= Used to optimize summing of generators.
  has gint       $.index       is rw; #= Incremented each sample.
  has gint       $.index_mask  is rw; #= Index wrapped by ANDing with this mask.
  has gdouble    $.scalar      is rw; #= Used to scale within range of -1.0 to +1.0
}

class GstRedNoise                is repr<CStruct>     does GLib::Roles::Pointers is export {
  has gdouble    $.state       is rw; #= noise state
}

class GstAudioTestSrc            is repr<CStruct>     does GLib::Roles::Pointers is export {
  HAS GstBaseSrc          $.parent;

  has Pointer             $!process                       ; #= ProcessFunc
  has Pointer             $!pack_func                     ; #= GstAudioFormatPack
  has gint                $.pack_size             is rw   ;
  has gpointer            $.tmp                   is rw   ;
  has gsize               $.tmpsize               is rw   ;

  # Parameters
  has GstAudioTestSrcWave $.wave                  is rw   ;
  has gdouble             $.volume                is rw   ;
  has gdouble             $.freq                  is rw   ;

  # Audio parameters
  has GstAudioInfo        $!info                          ;
  has gint                $.samples_per_buffer    is rw   ;

  # Private
  has gboolean            $!tags_pushed                   ;   #= send tags just once ?
  has GstClockTimeDiff    $!timestamp_offset              ;   #= base offset
  has GstClockTime        $!next_time                     ;   #= next timestamp
  has gint64              $!next_sample                   ;   #= next sample to send
  has gint64              $!next_byte                     ;   #= next byte to send
  has gint64              $!sample_stop                   ;
  has gboolean            $!check_seek_stop               ;
  has gboolean            $!eos_reached                   ;
  has gint                $!generate_samples_per_buffer   ;   #= used to generate a partial buffer
  has gboolean            $!can_activate_pull             ;
  has gboolean            $!reverse                       ;   #= play backwards

  # waveform specific context data
  has GRand               $!gen                            ;  #= random number generator
  has gdouble             $!accumulator                    ;  #= phase angle
  has GstPinkNoise        $!pink                           ;
  has GstRedNoise         $!red                            ;
  HAS gdouble             @!wave_table[1024]      is CArray;
  has guint               $!sine_periods_per_tick          ;
  has guint64             $!tick_interval                  ;
  has guint               $!marker_tick_period             ;
  has gdouble             $!marker_tick_volume             ;
  has gboolean            $!apply_tick_ramp                ;
  has guint               $!samples_between_ticks          ;
  has guint               $!tick_counter                   ;

  method process is rw {
    Proxy.new:
      FETCH => -> $                { $!process },
      STORE => -> $, $, \func {
        $!process := set_func_pointer( &(func), &sprintf-ProcessFunc);
      };
  }

  method pack_func is rw is also<pack-func> {
    Proxy.new:
      FETCH => -> $                { $!pack_func },
      STORE => -> $, \func {
        $!pack_func := set_func_pointer( &(func), &sprintf-GstAudioFormatPack );
      };
  }

  method info is rw {
    Proxy.new:
      FETCH => -> $                    { self.^attributes[9].get_value(self)    },
      STORE => -> $, GstAudioInfo() \a { self.^attributes[9].set_value(self, a) };
  }

  sub sprintf-ProcessFunc (
    Blob,
    Str,
    & (GstAudioTestSrc, CArray[guint8]),
    gpointer
  )
    returns int64
    is export
    is native
    is symbol('sprintf')
  { * }

}

our subset GstAudioTestSrcAncestry is export of Mu
  where GstAudioTestSrc | GstBaseSrcAncestry;

class GStreamer::Plugins::AudioTestSrc is GStreamer::Base::Src {
  has GstAudioTestSrc $!ats;

  submethod BUILD (:$audio-test-src) {
    self.setAudioTestSrc($audio-test-src);
  }

  method setAudioTestSrc (GstAudioTestSrcAncestry $_) {
    my $to-parent;

    $!ats = do {
      when GstAudioTestSrc {
        $to-parent = cast(GstBaseSrc, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstAudioTestSrc, $_);
      }
    }
    self.setGstBaseSrc($to-parent);
  }

  method GStreamer::Plugins::Base::GST::AudioTestSrc::GstAudioTestSrc
    is also<GstAudioTestSrc>
  { $!ats }

  method new (GstAudioTestSrcAncestry $audio-test-src) {
    $audio-test-src ?? self.bless( :$audio-test-src ) !! Nil;
  }

  # Type: gboolean
  method apply-tick-ramp is rw  is also<apply_tick_ramp> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('apply-tick-ramp', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_BOOLEAN );
        $gv.boolean = $val;
        self.prop_set('apply-tick-ramp', $gv);
      }
    );
  }

  # Type: guint
  method blocksize is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('blocksize', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT );
        $gv.uint = $val;
        self.prop_set('blocksize', $gv);
      }
    );
  }

  # Type: gboolean
  method can-activate-pull is rw  is also<can_activate_pull> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('can-activate-pull', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_BOOLEAN );
        $gv.boolean = $val;
        self.prop_set('can-activate-pull', $gv);
      }
    );
  }

  # Type: gboolean
  method can-activate-push is rw  is also<can_activate_push> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('can-activate-push', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_BOOLEAN );
        $gv.boolean = $val;
        self.prop_set('can-activate-push', $gv);
      }
    );
  }

  # Type: gboolean
  method do-timestamp is rw  is also<do_timestamp> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('do-timestamp', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_BOOLEAN );
        $gv.boolean = $val;
        self.prop_set('do-timestamp', $gv);
      }
    );
  }

  # Type: gdouble
  method freq is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('freq', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv = GLib::Value.new( G_TYPE_DOUBLE );
        $gv.double = $val;
        self.prop_set('freq', $gv);
      }
    );
  }

  # Type: gboolean
  method is-live is rw  is also<is_live> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('is-live', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_BOOLEAN );
        $gv.boolean = $val;
        self.prop_set('is-live', $gv);
      }
    );
  }

  # Type: guint
  method marker-tick-period is rw  is also<marker_tick_period> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('marker-tick-period', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT );
        $gv.uint = $val;
        self.prop_set('marker-tick-period', $gv);
      }
    );
  }

  # Type: gdouble
  method marker-tick-volume is rw  is also<marker_tick_volume> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('marker-tick-volume', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv = GLib::Value.new( G_TYPE_DOUBLE );
        $gv.double = $val;
        self.prop_set('marker-tick-volume', $gv);
      }
    );
  }

  # Type: Str (gchararray)
  method name is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('name', $gv)
        );
        $gv.string
      },
      STORE => -> $, Str() $val is copy {
        $gv = GLib::Value.new( G_TYPE_STRING );
        $gv.string = $val;
        self.prop_set('name', $gv);
      }
    );
  }

  # Type: gint
  method num-buffers is rw  is also<num_buffers> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('num-buffers', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_INT );
        $gv.int = $val;
        self.prop_set('num-buffers', $gv);
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
        return $o  if     $raw;

        GLib::Roles::Object.new-object-obj($o);
      },
      STORE => -> $, GObject() $val is copy {
        $gv = GLib::Value.new( G_TYPE_OBJECT );
        $gv.object = $val;
        self.prop_set('parent', $gv);
      }
    );
  }

  # Type: gint
  method samplesperbuffer is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('samplesperbuffer', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_INT );
        $gv.int = $val;
        self.prop_set('samplesperbuffer', $gv);
      }
    );
  }

  # Type: guint
  method sine-periods-per-tick is rw  is also<sine_periods_per_tick> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('sine-periods-per-tick', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT );
        $gv.uint = $val;
        self.prop_set('sine-periods-per-tick', $gv);
      }
    );
  }

  # Type: guint64
  method tick-interval is rw  is also<tick_interval> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('tick-interval', $gv)
        );
        $gv.uint64;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT64 );
        $gv.uint64 = $val;
        self.prop_set('tick-interval', $gv);
      }
    );
  }

  # Type: gint64
  method timestamp-offset is rw  is also<timestamp_offset> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('timestamp-offset', $gv)
        );
        $gv.int64;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_INT64 );
        $gv.int64 = $val;
        self.prop_set('timestamp-offset', $gv);
      }
    );
  }

  # Type: gboolean
  method typefind is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('typefind', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_BOOLEAN );
        $gv.boolean = $val;
        self.prop_set('typefind', $gv);
      }
    );
  }

  # Type: gdouble
  method volume is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('volume', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv = GLib::Value.new( G_TYPE_DOUBLE );
        $gv.double = $val;
        self.prop_set('volume', $gv);
      }
    );
  }

  # Type: Audio-test-src-wave
  method wave is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('wave', $gv)
        );
        GstAudioTestSrcWaveEnum( $gv.enum )
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT );
        $gv.uint = $val;
        self.prop_set('wave', $gv);
      }
    );
  }

}
