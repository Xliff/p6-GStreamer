use v6.c;

use Method::Also;
use NativeCall;

use GStreamer::Raw::Types;
use GStreamer::Raw::Audio::Info;

use GStreamer::Caps;

class GStreamer::Audio::Info {
  has GstAudioInfo $!ai;

  submethod BUILD (:$info) {
    $!ai = $info;
  }

  method GStreamer::Raw::Audio::Structs::GstAudioInfo
    is also<GstAudioInfo>
  { $!ai }

  multi method new (GstAudioInfo $info) {
    $info ?? self.bless( :$info ) !! Nil;
  }
  multi method new {
    my $info = gst_audio_info_new();

    $info ?? self.bless( :$info ) !! Nil;
  }

  multi method convert (
    Int() $src_fmt,
    Int() $src_val,
    Int() $dest_fmt
  ) {
    my $rv = samewith($src_fmt, $src_val, $dest_fmt, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method convert (
    Int() $src_fmt,
    Int() $src_val,
    Int() $dest_fmt,
    $dest_val is rw,
    :$all = False,
    :$raw = False
  ) {
    my GstFormat ($sf, $df) = ($src_fmt, $dest_fmt);
    my gint64 $s = $src_val;
    my $d = CArray[guint64].allocate(64);
    my $rv = gst_audio_info_convert($!ai, $sf, $s, $df, $d);

    $dest_val = $d;
    $dest_val = ArrayToCArray($d) unless $raw;
    $all.not ?? $rv !! ($rv, $dest_val);
  }

  method copy (:$raw = False) {
    my $copy = gst_audio_info_copy($!ai);

    $copy ??
      ( $raw ?? $copy !! GStreamer::Audio::Info.new($copy) )
      !!
      Nil;
  }

  method free {
    gst_audio_info_free($!ai);
  }

  method from_caps (GstCaps() $caps) is also<from-caps> {
    gst_audio_info_from_caps($!ai, $caps);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_audio_info_get_type, $n, $t );
  }

  method init {
    gst_audio_info_init($!ai);
  }

  method is_equal (GstAudioInfo() $other) is also<is-equal> {
    so gst_audio_info_is_equal($!ai, $other);
  }

  proto method set_format (|)
      is also<set-format>
  { * }

  multi method set_format (
    Int() $format,
    Int() $rate,
    Int() $channels,
    @position
  ) {
    @position = @position.map({
      die '@position must contain only Num-compatble values!'
        unless $_ ~~ Num || ( my $meth = .^lookup('Num') );
      $_ ~~ Num ?? $_ !! $meth($_);
    });

    samewith( $format, $rate, $channels, ArrayToCArray(guint64, @position) )
  }
  multi method set_format (
    Int() $format,
    Int() $rate,
    Int() $channels,
    CArray[GstAudioChannelPosition] $position
  ) {
    die 'The $position parameter must contain 64 values!'
      unless $position.elems == 64;

    my GstAudioFormat $f = $format;
    my gint ($r, $c) = ($rate, $channels);

    gst_audio_info_set_format($!ai, $f, $r, $c, $position);
  }

  method to_caps (:$raw = False) is also<to-caps> {
    my $c = gst_audio_info_to_caps($!ai);

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

}
