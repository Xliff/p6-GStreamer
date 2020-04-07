use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;

use GLib::Raw::ReturnedValue;
use GStreamer::Raw::Subs;
use GStreamer::Roles::Plugins::Raw::Playbin;

#use GStreamer::Plugins::Gst::Playback;

use GLib::Value;
use GStreamer::Buffer;
use GStreamer::Element;
use GStreamer::Sample;
use GStreamer::TagList;

use GLib::Roles::Object;
use GLib::Roles::Signals::Generic;
use GStreamer::Roles::Video::ColorBalance;

role GStreamer::Roles::Plugins::Playbin {
  also does GLib::Roles::Signals::Generic;
  also does GStreamer::Roles::Video::ColorBalance;

  has $!pb;
  has %!signals-pb;

  submethod TWEAK {
    self!setObject( $!pb = cast(GObject, self.GstObject) );
  }

  # Check to insure all methods are provided!

  # DESTROY for signals!

  method !flags-get-type {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_play_flags_get_type, $n, $t );
  }

  # Type: GstElement
  method audio-sink (:$raw = False) is rw  is also<audio_sink> {
    my GLib::Value $gv .= new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('audio-sink', $gv)
        );
        my $e = cast(GstElement, $gv.object);

        $e ??
          ( $raw ?? $e !! GStreamer::Element.new($e) )
          !!
          GstElement
      },
      STORE => -> $, GObject() $val is copy {
        $gv.object = $val;
        self.prop_set('audio-sink', $gv);
      }
    );
  }

  # Type: GstBuffer
  method frame (:$raw = False) is rw  {
    my GLib::Value $gv .= new( GStreamer::Buffer.get_type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('frame', $gv)
        );
        my $b = cast(GstBuffer, $gv.boxed);

        $b ??
          ( $raw ?? $b !! GStreamer::Buffer.new($b) )
          !!
          GstBuffer;
      },
      STORE => -> $,  $val is copy {
        warn 'frame does not allow writing'
      }
    );
  }

  # Type: gchar
  method subtitle-font-desc is rw  is also<subtitle_font_desc> {
    my GLib::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
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
  method video-sink (:$raw = False) is rw  is also<video_sink> {
    my GLib::Value $gv .= new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('video-sink', $gv)
        );
        my $v = cast(GstElement, $gv.object);

        $v ??
          ( $raw ?? $v !! GStreamer::Element.new($v) )
          !!
          GstElement;
      },
      STORE => -> $, GstElement() $val is copy {
        $gv.object = $val;
        self.prop_set('video-sink', $gv);
      }
    );
  }

  # Type: GstElement
  method vis-plugin (:$raw = False) is rw  is also<vis_plugin> {
    my subset GstElementOrObject of Mu where GStreamer::Element | GstElement;
    my GLib::Value $gv .= new( GStreamer::Element.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('vis-plugin', $gv)
        );
        my $v = cast(GstElement, $gv.object);

        $v ??
          ( $raw ?? $v !! GStreamer::Element.new($v) )
          !!
          GstElement;
      },
      STORE => -> $, GstElementOrObject $val is copy {
        $val .= GObject if $val ~~ GStreamer::Element;
        $gv.object = $val;
        self.prop_set('vis-plugin', $gv);
      }
    );
  }

  # Type: gdouble
  method volume is rw  {
    my GLib::Value $gv .= new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
  method connection-speed is rw  is also<connection_speed> {
    my GLib::Value $gv .= new( G_TYPE_UINT64 );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
  method av-offset is rw  is also<av_offset> {
    my GLib::Value $gv .= new( G_TYPE_INT64 );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
  method buffer-duration is rw  is also<buffer_duration> {
    my GLib::Value $gv .= new( G_TYPE_INT64 );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
  method buffer-size is rw  is also<buffer_size> {
    my GLib::Value $gv .= new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
  method current-audio is rw  is also<current_audio> {
    my GLib::Value $gv .= new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
  method current-text is rw  is also<current_text> {
    my GLib::Value $gv .= new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
  method current-video is rw  is also<current_video> {
    my GLib::Value $gv .= new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
    # say 'flags';
    # my GLib::Value $gv .= new(
    #   do {
    #     state ($n, $t);
    #
    #     unstable_get_type( self.^name, &global_gst_play_flags_get_type, $n, $t )
    #   }
    #   G_TYPE_UINT64
    # );
    #my GLib::Value $gv .= new( G_TYPE_INT );
    my $la = CArray[guint].new;
    Proxy.new(
      FETCH => -> $ {
        # $gv = GLib::Value.new(
        #   self.prop_get('flags', $gv)
        # );
        $la[0] = 0;
        gst_object_get_uint($!pb.p, 'flags', $la, Str);
        $la[0];
      },
      STORE => -> $, Int() $val is copy {
        # $gv.uint = $val;
        # self.prop_set('flags', $gv);
        my guint $v = $val;
        gst_object_set_uint($!pb.p, 'flags', $v, Str);
      }
    );
  }

  # Type: gboolean
  method mute is rw  {
    my GLib::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
  method n-audio is rw  is also<n_audio> {
    my GLib::Value $gv .= new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
  method n-text is rw  is also<n_text> {
    my GLib::Value $gv .= new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
  method n-video is rw  is also<n_video> {
    my GLib::Value $gv .= new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
  method ring-buffer-max-size is rw  is also<ring_buffer_max_size> {
    my GLib::Value $gv .= new( G_TYPE_UINT64 );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
    my GLib::Value $gv .= new( G_TYPE_BOXED );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('sample', $gv)
        );
        my $s = cast(GstSample, $gv.boxed);

        $s ??
          ( $raw ?? $s !! GStreamer::Sample.new($s) )
          !!
          GstSample;
      },
      STORE => -> $,  $val is copy {
        warn 'sample does not allow writing'
      }
    );
  }

  # Type: GstElement
  method source (:$raw = False) is rw  {
    my GLib::Value $gv .= new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('source', $gv)
        );
        my $e = cast(GstElement, $gv.object);

        $e ??
          ( $raw ?? $e !! GStreamer::Element.new($e) )
          !!
          GstElement;
      },
      STORE => -> $, $val is copy {
        warn 'source does not allow writing'
      }
    );
  }

  # Type: gchar
  method subtitle-encoding is rw  is also<subtitle_encoding> {
    my GLib::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
    my GLib::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
  method text-sink (:$raw = False) is rw  is also<text_sink> {
    my GLib::Value $gv .= new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('text-sink', $gv)
        );
        my $s = cast(GstElement, $gv.object);

        $s ??
          ( $raw ?? $s !! GStreamer::Element.new($s) )
          !!
          GstElement;
      },
      STORE => -> $, GstElement() $val is copy {
        $gv.object = $val;
        self.prop_set('text-sink', $gv);
      }
    );
  }

  # Type: gchar
  method uri is rw  {
    my GLib::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
  method current-suburi is rw  is also<current_suburi> {
    my GLib::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
  method current-uri is rw  is also<current_uri> {
    my GLib::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
  method force-aspect-ratio is rw  is also<force_aspect_ratio> {
    my GLib::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
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
  method audio-stream-combiner (:$raw = False) is rw
    is also<audio_stream_combiner>
  {
    my GLib::Value $gv .= new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('audio-stream-combiner', $gv)
        );
        my $e = cast(GstElement, $gv.object);

        $e ??
          ( $raw ?? $e !! GStreamer::Element.new($e) )
          !!
          GstElement;
      },
      STORE => -> $, GstElement() $val is copy {
        $gv.object = $val;
        self.prop_set('audio-stream-combiner', $gv);
      }
    );
  }

  # Type: GstElement
  method text-stream-combiner (:$raw = False) is rw
    is also<text_stream_combiner>
  {
    my GLib::Value $gv .= new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('text-stream-combiner', $gv)
        );
        my $e = cast(GstElement, $gv.object);

        $e ??
          ( $raw ?? $e !! GStreamer::Element.new($e) )
          !!
          GstElement;
      },
      STORE => -> $, GstElement() $val is copy {
        $gv.object = $val;
        self.prop_set('text-stream-combiner', $gv);
      }
    );
  }

  # Type: GstElement
  method video-stream-combiner (:$raw = False) is rw
    is also<video_stream_combiner>
  {
    my GLib::Value $gv .= new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('video-stream-combiner', $gv)
        );
        my $e = cast(GstElement, $gv.object);

        $e ??
          ( $raw ?? $e !! GStreamer::Element.new($e) )
          !!
          GstElement;
      },
      STORE => -> $, GstElement() $val is copy {
        $gv.object = $val;
        self.prop_set('video-stream-combiner', $gv);
      }
    );
  }

  # Is originally:
  # GstPlayBin, gpointer --> void
  method about-to-finish is also<about_to_finish> {
    self.connect($!pb, 'about-to-finish');
  }

  # Is originally:
  # GstPlayBin, gpointer --> void
  method audio-changed is also<audio_changed> {
    self.connect($!pb, 'audio-changed');
  }

  # Is originally:
  # GstPlayBin, gint, gpointer --> void
  method audio-tags-changed is also<audio_tags_changed> {
    self.connect-tags-changed($!pb, 'audio-tags-changed');
  }

  # Is originally:
  # GstPlayBin, GstCaps, gpointer --> GstSample
  method convert-sample is also<convert_sample> {
    self.connect-convert-sample($!pb);
  }

  # Is originally:
  # GstPlayBin, gint, gpointer --> GstPad
  method get-audio-pad is also<get_audio_pad> {
    self.connect-get-pad($!pb, 'get-audio-pad');
  }

  # Is originally:
  # GstPlayBin, gint, gpointer --> GstTagList
  method get-audio-tags is also<get_audio_tags> {
    self.connect-get-tags($!pb, 'get-audio-tags');
  }

  # Is originally:
  # GstPlayBin, gint, gpointer --> GstPad
  method get-text-pad is also<get_text_pad> {
    self.connect-get-pad($!pb, 'get-text-pad');
  }

  # Is originally:
  # GstPlayBin, gint, gpointer --> GstTagList
  method get-text-tags is also<get_text_tags> {
    self.connect-get-tags($!pb, 'get-text-tags');
  }

  # Is originally:
  # GstPlayBin, gint, gpointer --> GstPad
  method get-video-pad is also<get_video_pad> {
    self.connect-get-pad($!pb, 'get-video-pad');
  }

  # Is originally:
  # GstPlayBin, gint, gpointer --> GstTagList
  method get-video-tags is also<get_video_tags> {
    self.connect-get-tags($!pb, 'get-video-tags');
  }

  # Is originally:
  # GstPlayBin, GstElement, gpointer --> void
  method source-setup is also<source_setup> {
    self.connect-source-setup($!pb);
  }

  # Is originally:
  # GstPlayBin, gpointer --> void
  method text-changed is also<text_changed> {
    self.connect($!pb, 'text-changed');
  }

  # Is originally:
  # GstPlayBin, gint, gpointer --> void
  method text-tags-changed is also<text_tags_changed> {
    self.connect-tags-changed($!pb, 'text-tags-changed');
  }

  # Is originally:
  # GstPlayBin, gpointer --> void
  method video-changed is also<video_changed> {
    self.connect($!pb, 'video-changed');
  }

  # Is originally:
  # GstPlayBin, gint, gpointer --> void
  method video-tags-changed is also<video_tags_changed> {
    self.connect-tags-changed($!pb, 'video-tags-changed');
  }

  proto method emit-get-tags (|)
      is also<emit_get_tags>
  { * }

  multi method emit-get-tags (
    Str() $name,
    Int() $i,
    :$raw = False
  ) {
    samewith($name, $i, $, :$raw);
  }
  multi method emit-get-tags (
    Str() $name,
    Int() $i,
    $taglist is rw,
    :$raw = False
  ) {
    my gint $ii = $i;
    my $tl = CArray[Pointer[GstTagList]].new;
    $tl[0] = Pointer[GstTagList];

    g-signal-emit-get-tags($!pb, $name, $ii, $tl);

    $taglist = ppr($tl);

    $taglist ??
      ( $raw ?? $taglist !! GStreamer::TagList.new($taglist) )
      !!
      GstTagList;
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

sub gst_object_set_uint (
  Pointer $element,
  Str $name,
  guint $value,
  Str
)
  is native(gobject)
  is symbol('g_object_set')
{ * }

sub gst_object_get_uint (
  Pointer $element,
  Str $name,
  CArray[guint] $value,
  Str
)
  is native(gobject)
  is symbol('g_object_get')
{ * }

constant GstAutoplugSelectResult is export := guint32;
our enum GstAutoplugSelectResultEnum is export <
    GST_AUTOPLUG_SELECT_TRY
    GST_AUTOPLUG_SELECT_EXPOSE
    GST_AUTOPLUG_SELECT_SKIP
>;

constant GstPlayFlags is export := guint32;
our enum GstPlayFlagsEnum is export (
  GST_PLAY_FLAG_VIDEO             => 1,
  GST_PLAY_FLAG_AUDIO             => (1 +< 1),
  GST_PLAY_FLAG_TEXT              => (1 +< 2),
  GST_PLAY_FLAG_VIS               => (1 +< 3),
  GST_PLAY_FLAG_SOFT_VOLUME       => (1 +< 4),
  GST_PLAY_FLAG_NATIVE_AUDIO      => (1 +< 5),
  GST_PLAY_FLAG_NATIVE_VIDEO      => (1 +< 6),
  GST_PLAY_FLAG_DOWNLOAD          => (1 +< 7),
  GST_PLAY_FLAG_BUFFERING         => (1 +< 8),
  GST_PLAY_FLAG_DEINTERLACE       => (1 +< 9),
  GST_PLAY_FLAG_SOFT_COLORBALANCE => (1 +< 10),
  GST_PLAY_FLAG_FORCE_FILTERS     => (1 +< 11),
);

constant GstPlaySinkType is export := guint32;
our enum GstPlaySinkTypeEnum is export (
    GST_PLAY_SINK_TYPE_AUDIO     =>  0,
    GST_PLAY_SINK_TYPE_AUDIO_RAW =>  1,
    GST_PLAY_SINK_TYPE_VIDEO     =>  2,
    GST_PLAY_SINK_TYPE_VIDEO_RAW =>  3,
    GST_PLAY_SINK_TYPE_TEXT      =>  4,
    GST_PLAY_SINK_TYPE_LAST      =>  5,
    GST_PLAY_SINK_TYPE_FLUSHING  =>  6,
);
