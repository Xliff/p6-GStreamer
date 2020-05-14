use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;
use GStreamer::Raw::Audio::Converter;

class GStreamer::Audio::Converter {
  has GstAudioConverter $!ac;

  submethod BUILD (:$converter) {
    $!ac = $converter;
  }

  method GStreamer::Raw::Definitions::GstAudioConverter
    is also<GstAudioConverter>
  { $!ac }

  multi method new (GstAudioConverter $converter) {
    $converter ?? self.bless( :$converter ) !! Nil;
  }
  multi method new (
    Int() $flags,
    GstAudioInfo() $in_info,
    GstAudioInfo() $out_info,
    GstStructure() $config
  ) {
    my GstAudioConverterFlags $f = $flags;
    my $converter = gst_audio_converter_new($f, $in_info, $out_info, $config);

    $converter ?? self.bless( :$converter ) !! Nil;
  }

  multi method convert (
    Int() $flags,
    Buf() $in
  ) {
    samewith($flags, cast(Pointer, $in), $in.bytes);
  }
  multi method convert (
    Int() $flags,
    CArray[guint8] $in,
    Int() $in_size
  ) {
    samewith($flags, $in, $in_size);
  }
  multi method convert (
    Int() $flags,
    gpointer $in,
    Int() $in_size,
  ) {
    my $rv = samewith($flags, $in, $in_size, $, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method convert (
    Int() $flags,
    gpointer $in,
    Int() $in_size,
    $out is rw,
    $out_size is rw,
    :$all = False
  ) {
    my GstAudioConverterFlags $f = $flags;
    my gsize ($is, $os) = ($in_size, 0);
    my gpointer $o = Pointer.new;

    my $rv = gst_audio_converter_convert($!ac, $flags, $in, $in_size, $o, $os);
    ($out, $out_size) = ($o, $os);
    $all.not ?? $rv !! ($rv, $out, $os);
  }

  method free {
    gst_audio_converter_free($!ac);
  }

  proto method get_config (|)
      is also<get-config>
  { * }

  multi method get_config (:$all = False, :$raw = False) {
    samewith($, $, :$all, :$raw);
  }
  multi method get_config (
    $in_rate is rw,
    $out_rate is rw,
    :$all = False,
    :$raw = False
  ) {
    my ($i, $o) = 0 xx 2;
    my $s = gst_audio_converter_get_config($!ac, $i, $o);

    ($in_rate, $out_rate) = ($i, $o);
    $s = $s ??
      ( $raw ?? $s !! GStreamer::Sturcture.new($s) )
      !!
      Nil;
    $all.not ?? $s !! ($s, $in_rate, $out_rate);
  }

  method get_in_frames (Int() $out_frames) is also<get-in-frames> {
    my gsize $o = $out_frames;

    gst_audio_converter_get_in_frames($!ac, $o);
  }

  method get_max_latency is also<get-max-latency> {
    gst_audio_converter_get_max_latency($!ac);
  }

  method get_out_frames (Int() $in_frames) is also<get-out-frames> {
    my gsize $i = $in_frames;

    gst_audio_converter_get_out_frames($!ac, $i);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_audio_converter_get_type, $n, $t );
  }

  method is_passthrough is also<is-passthrough> {
    so gst_audio_converter_is_passthrough($!ac);
  }

  method reset {
    gst_audio_converter_reset($!ac);
  }

  multi method samples (
    Int() $flags,
    gpointer $out,
    Int() $out_frames
  ) {
    samewith($flags, gpointer, $out_frames, $out, $out_frames);
  }
  multi method samples (
    Int() $flags,
    gpointer $in,
    Int() $in_frames,
    gpointer $out,
    Int() $out_frames
  ) {
    my GstAudioConverterFlags $f = $flags;
    my gsize ($if, $of) = ($in_frames, $out_frames);

    so gst_audio_converter_samples($!ac, $flags, $in, $if, $out, $of);
  }

  method supports_inplace is also<supports-inplace> {
    so gst_audio_converter_supports_inplace($!ac);
  }

  method update_config (
    Int() $in_rate,
    Int() $out_rate,
    GstStructure() $config
  )
    is also<update-config>
  {
    my gsize ($i, $o) = ($in_rate, $out_rate);

    gst_audio_converter_update_config($!ac, $i, $o, $config);
  }

}
