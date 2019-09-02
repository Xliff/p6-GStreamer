use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GTK::Raw::ReturnedValue;
use GStreamer::Raw::Types;
use GStreamer::Roles::Plugins::Raw::Playbin;

use GTK::Roles::Properties;

use GStreamer::Buffer;
use GStreamer::Element;
use GStreamer::Sample;

use GTK::Roles::Signals::Generic;

role GStreamer::Roles::Plugins::Playbin {
  also does GTK::Roles::Properties;
  also does GTK::Roles::Signals::Generic;

  has $!pb;
  has %!signals-pb;

  submethod TWEAK {
    $!pb = cast(GObject, self.GstObject);
  }

  # DESTROY for signals!

  # Type: GstElement
  method audio-sink (:$raw = False) is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('audio-sink', $gv)
        );
        my $e = cast(GstElement, $gv.object);

        $e ??
          ( $raw ?? $e !! GStreamer::Element.new($e) )
          !!
          Nil
      },
      STORE => -> $, GObject() $val is copy {
        $gv.object = $val;
        self.prop_set('audio-sink', $gv);
      }
    );
  }

  # Type: GstBuffer
  method frame (:$raw = False) is rw  {
    my GTK::Compat::Value $gv .= new( GStreamer::Buffer.get_type );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('frame', $gv)
        );
        my $b = cast(GstBuffer, $gv.boxed);

        $b ??
          ( $raw ?? $b !! GStreamer::Buffer.new($b) )
          !!
          Nil;
      },
      STORE => -> $,  $val is copy {
        warn 'frame does not allow writing'
      }
    );
  }

  # Type: gchar
  method subtitle-font-desc is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => -> $ {
        warn 'subtitle-font-desc does not allow reading' if $DEBUG;
        '';

      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('subtitle-font-desc', $gv);
      }
    );
  }

  # Type: GstElement
  method video-sink (:$raw = False) is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('video-sink', $gv)
        );
        my $v = cast(GstElement, $gv.object);

        $v ??
          ( $raw ?? $v !! GStreamer::Element.new($v) )
          !!
          Nil;
      },
      STORE => -> $, GstElement() $val is copy {
        $gv.object = $val;
        self.prop_set('video-sink', $gv);
      }
    );
  }

  # Type: GstElement
  method vis-plugin (:$raw = False) is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('vis-plugin', $gv)
        );
        my $v = cast(GstElement, $gv.object);

        $v ??
          ( $raw ?? $v !! GStreamer::Element.new($v) )
          !!
          Nil;
      },
      STORE => -> $, GstElement() $val is copy {
        $gv.object = $val;
        self.prop_set('vis-plugin', $gv);
      }
    );
  }

  # Type: gdouble
  method volume is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('volume', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('volume', $gv);
      }
    );
  }

  # Type: guint64
  method connection-speed is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_UINT64 );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('connection-speed', $gv)
        );
        $gv.uint64;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint64 = $val;
        self.prop_set('connection-speed', $gv);
      }
    );
  }

  # Type: gint64
  method av-offset is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_INT64 );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('av-offset', $gv)
        );
        $gv.int64;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int64 = $val;
        self.prop_set('av-offset', $gv);
      }
    );
  }

  # Type: gint64
  method buffer-duration is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_INT64 );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('buffer-duration', $gv)
        );
        $gv.int64;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int64 = $val;
        self.prop_set('buffer-duration', $gv);
      }
    );
  }

  # Type: gint
  method buffer-size is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_INT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('buffer-size', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('buffer-size', $gv);
      }
    );
  }

  # Type: gint
  method current-audio is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_INT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('current-audio', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('current-audio', $gv);
      }
    );
  }

  # Type: gint
  method current-text is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_INT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('current-text', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('current-text', $gv);
      }
    );
  }

  # Type: gint
  method current-video is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_INT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('current-video', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('current-video', $gv);
      }
    );
  }

  # Type: GstPlayFlags
  method flags is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('flags', $gv)
        );
        GstPlayFlagsEnum( $gv.boxed );
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;

        self.prop_set('flags', $gv);
      }
    );
  }

  # Type: gboolean
  method mute is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('mute', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('mute', $gv);
      }
    );
  }

  # Type: gint
  method n-audio is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_INT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('n-audio', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        warn 'n-audio does not allow writing'
      }
    );
  }

  # Type: gint
  method n-text is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_INT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('n-text', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        warn 'n-text does not allow writing'
      }
    );
  }

  # Type: gint
  method n-video is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_INT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('n-video', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        warn 'n-video does not allow writing'
      }
    );
  }

  # Type: guint64
  method ring-buffer-max-size is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_UINT64 );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('ring-buffer-max-size', $gv)
        );
        $gv.uint64;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint64 = $val;
        self.prop_set('ring-buffer-max-size', $gv);
      }
    );
  }

  # Type: GstSample
  method sample (:$raw = False) is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_BOXED );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('sample', $gv)
        );
        my $s = cast(GstSample, $gv.boxed);

        $s ??
          ( $raw ?? $s !! GStreamer::Sample.new($s) )
          !!
          Nil;
      },
      STORE => -> $,  $val is copy {
        warn 'sample does not allow writing'
      }
    );
  }

  # Type: GstElement
  method source (:$raw = False) is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('source', $gv)
        );
        my $e = cast(GstElement, $gv.object);

        $e ??
          ( $raw ?? $e !! GStreamer::Element.new($e) )
          !!
          Nil;
      },
      STORE => -> $, $val is copy {
        warn 'source does not allow writing'
      }
    );
  }

  # Type: gchar
  method subtitle-encoding is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('subtitle-encoding', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('subtitle-encoding', $gv);
      }
    );
  }

  # Type: gchar
  method suburi is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('suburi', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('suburi', $gv);
      }
    );
  }

  # Type: GstElement
  method text-sink (:$raw = False) is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('text-sink', $gv)
        );
        my $s = cast(GstElement, $gv.object);

        $s ??
          ( $raw ?? $s !! GStreamer::Element.new($s) )
          !!
          Nil;
      },
      STORE => -> $, GstElement() $val is copy {
        $gv.object = $val;
        self.prop_set('text-sink', $gv);
      }
    );
  }

  # Type: gchar
  method uri is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('uri', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('uri', $gv);
      }
    );
  }

  # Type: gchar
  method current-suburi is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('current-suburi', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'current-suburi does not allow writing'
      }
    );
  }

  # Type: gchar
  method current-uri is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('current-uri', $gv)
          );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'current-uri does not allow writing'
      }
    );
  }

  # Type: gboolean
  method force-aspect-ratio is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('force-aspect-ratio', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('force-aspect-ratio', $gv);
      }
    );
  }

  # Type: GstElement
  method audio-stream-combiner (:$raw = False) is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('audio-stream-combiner', $gv)
        );
        my $e = cast(GstElement, $gv.object);

        $e ??
          ( $raw ?? $e !! GStreamer::Element.new($e) )
          !!
          Nil;
      },
      STORE => -> $, GstElement() $val is copy {
        $gv.object = $val;
        self.prop_set('audio-stream-combiner', $gv);
      }
    );
  }

  # Type: GstElement
  method text-stream-combiner (:$raw = False) is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('text-stream-combiner', $gv)
        );
        my $e = cast(GstElement, $gv.object);

        $e ??
          ( $raw ?? $e !! GStreamer::Element.new($e) )
          !!
          Nil;
      },
      STORE => -> $, GstElement() $val is copy {
        $gv.object = $val;
        self.prop_set('text-stream-combiner', $gv);
      }
    );
  }

  # Type: GstElement
  method video-stream-combiner (:$raw = False) is rw  {
    my GTK::Compat::Value $gv .= new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => -> $ {
        $gv = GTK::Compat::Value.new(
          self.prop_get('video-stream-combiner', $gv)
        );
        my $e = cast(GstElement, $gv.object);

        $e ??
          ( $raw ?? $e !! GStreamer::Element.new($e) )
          !!
          Nil;
      },
      STORE => -> $, GstElement() $val is copy {
        $gv.object = $val;
        self.prop_set('video-stream-combiner', $gv);
      }
    );
  }

  # Is originally:
  # GstPlayBin, gpointer --> void
  method about-to-finish {
    self.connect($!pb, 'about-to-finish');
  }

  # Is originally:
  # GstPlayBin, gpointer --> void
  method audio-changed {
    self.connect($!pb, 'audio-changed');
  }

  # Is originally:
  # GstPlayBin, gint, gpointer --> void
  method audio-tags-changed {
    self.connect-tags-changed($!pb, 'audio-tags-changed');
  }

  # Is originally:
  # GstPlayBin, GstCaps, gpointer --> GstSample
  method convert-sample {
    self.connect-convert-sample($!pb);
  }

  # Is originally:
  # GstPlayBin, gint, gpointer --> GstPad
  method get-audio-pad {
    self.connect-get-pad($!pb, 'get-audio-pad');
  }

  # Is originally:
  # GstPlayBin, gint, gpointer --> GstTagList
  method get-audio-tags {
    self.connect-get-tags($!pb, 'get-audio-tags');
  }

  # Is originally:
  # GstPlayBin, gint, gpointer --> GstPad
  method get-text-pad {
    self.connect-get-pad($!pb, 'get-text-pad');
  }

  # Is originally:
  # GstPlayBin, gint, gpointer --> GstTagList
  method get-text-tags {
    self.connect-get-tags($!pb, 'get-text-tags');
  }

  # Is originally:
  # GstPlayBin, gint, gpointer --> GstPad
  method get-video-pad {
    self.connect-get-pad($!pb, 'get-video-pad');
  }

  # Is originally:
  # GstPlayBin, gint, gpointer --> GstTagList
  method get-video-tags {
    self.connect-get-tags($!pb, 'get-video-tags');
  }

  # Is originally:
  # GstPlayBin, GstElement, gpointer --> void
  method source-setup {
    self.connect-source-setup($!pb);
  }

  # Is originally:
  # GstPlayBin, gpointer --> void
  method text-changed {
    self.connect($!pb, 'text-changed');
  }

  # Is originally:
  # GstPlayBin, gint, gpointer --> void
  method text-tags-changed {
    self.connect-tags-changed($!pb, 'text-tags-changed');
  }

  # Is originally:
  # GstPlayBin, gpointer --> void
  method video-changed {
    self.connect($!pb, 'video-changed');
  }

  # Is originally:
  # GstPlayBin, gint, gpointer --> void
  method video-tags-changed {
    self.connect-tags-changed($!pb, 'video-tags-changed');
  }

  # GstPlayBin, gint, gpointer
  method connect-tags-changed (
    $obj,
    $signal,
    &handler?
  ) {
    my $hid;
    %!signals-pb{$signal} //= do {
      my $s = Supplier.new;
      $hid = g-connect-tags-changed($obj, $signal,
        -> $, $g, $ud {
          CATCH {
            default { $s.note($_) }
          }

          $s.emit( [self, $g, $ud ] );
        },
        Pointer, 0
      );
      [ $s.Supply, $obj, $hid ];
    };
    %!signals-pb{$signal}[0].tap(&handler) with &handler;
    %!signals-pb{$signal}[0];
  }

  # GstPlayBin, GstCaps, gpointer --> GstSample
  method connect-convert-sample (
    $obj,
    $signal = 'convert-sample',
    &handler?
  ) {
    my $hid;
    %!signals-pb{$signal} //= do {
      my $s = Supplier.new;
      $hid = g-connect-convert-sample($obj, $signal,
        -> $, $gc, $ud --> GstSample {
          CATCH {
            default { $s.note($_) }
          }

          my $r = ReturnedValue.new;
          $s.emit( [self, $gc, $ud, $r] );
          $r.r;
        },
        Pointer, 0
      );
      [ $s.Supply, $obj, $hid ];
    };
    %!signals-pb{$signal}[0].tap(&handler) with &handler;
    %!signals-pb{$signal}[0];
  }

  # GstPlayBin, gint, gpointer --> GstPad
  method connect-get-pad (
    $obj,
    $signal,
    &handler?
  ) {
    my $hid;
    %!signals-pb{$signal} //= do {
      my $s = Supplier.new;
      $hid = g-connect-get-pad($obj, $signal,
        -> $, $g, $ud --> GstPad {
          CATCH {
            default { $s.note($_) }
          }

          my $r = ReturnedValue.new;
          $s.emit( [self, $g, $ud, $r] );
          $r.r;
        },
        Pointer, 0
      );
      [ $s.Supply, $obj, $hid ];
    };
    %!signals-pb{$signal}[0].tap(&handler) with &handler;
    %!signals-pb{$signal}[0];
  }


  # GstPlayBin, gint, gpointer --> GstTagList
  method connect-get-tags (
    $obj,
    $signal,
    &handler?
  ) {
    my $hid;
    %!signals-pb{$signal} //= do {
      my $s = Supplier.new;
      $hid = g-connect-get-tags($obj, $signal,
        -> $, $g, $ud --> GstTagList {
          CATCH {
            default { $s.note($_) }
          }

          my $r = ReturnedValue.new;
          $s.emit( [self, $g, $ud, $r] );
          $r.r;
        },
        Pointer, 0
      );
      [ $s.Supply, $obj, $hid ];
    };
    %!signals-pb{$signal}[0].tap(&handler) with &handler;
    %!signals-pb{$signal}[0];
  }

  # GstPlayBin, GstElement, gpointer
  method connect-source-setup (
    $obj,
    $signal = 'source-setup',
    &handler?
  ) {
    my $hid;
    %!signals-pb{$signal} //= do {
      my $s = Supplier.new;
      $hid = g-connect-source-setup($obj, $signal,
        -> $, $ge, $ud {
          CATCH {
            default { $s.note($_) }
          }

          $s.emit( [self, $ge, $ud ] );
        },
        Pointer, 0
      );
      [ $s.Supply, $obj, $hid ];
    };
    %!signals-pb{$signal}[0].tap(&handler) with &handler;
    %!signals-pb{$signal}[0];
  }

}
