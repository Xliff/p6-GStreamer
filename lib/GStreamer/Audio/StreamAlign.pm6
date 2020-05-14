use v6.c;

use GStreamer::Raw::Types;
use GStreamer::Raw::Audio::StreamAlign;

class GStreamer::Audio::StreamAlign {
  has GstAudioStreamAlign $!asa;

  submethod BUILD (:$align) {
    $!asa = $align;
  }

  method GStreamer::Raw::Definitions::GstAudioStreamAlign
  { $!asa }

  multi method new (GstAudioStreamAlign $align) {
    $align ?? self.bless( :$align ) !! Nil;
  }
  multi method new (Int() $alignment_threshold, Int() $discont_wait) {
    my GstClockTime ($a, $d) = ($alignment_threshold, $discont_wait);

    gst_audio_stream_align_new($!asa, $a, $d);
  }

  method copy(:$raw = False) {
    my $copy = gst_audio_stream_align_copy($!asa);

    $copy ??
      ( $raw ?? $copy !! GStreamer::Audio::StreamAlign.new($copy) )
      !!
      Nil;
  }

  method free {
    gst_audio_stream_align_free($!asa);
  }

  method get_alignment_threshold {
    gst_audio_stream_align_get_alignment_threshold($!asa);
  }

  method get_discont_wait {
    gst_audio_stream_align_get_discont_wait($!asa);
  }

  method get_rate {
    gst_audio_stream_align_get_rate($!asa);
  }

  method get_samples_since_discont {
    gst_audio_stream_align_get_samples_since_discont($!asa);
  }

  method get_timestamp_at_discont {
    gst_audio_stream_align_get_timestamp_at_discont($!asa);
  }

  method get_type {
    gst_audio_stream_align_get_type();
  }

  method mark_discont {
    gst_audio_stream_align_mark_discont($!asa);
  }

  multi method process (
    Int() $discont,
    Int() $timestamp,
    Int() $n_samples
  ) {
    my $rv = samewith($discont, $timestamp, $n_samples, $, $, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method process (
    Int() $discont,
    Int() $timestamp,
    Int() $n_samples,
    $out_timestamp is rw,
    $out_duration is rw,
    $out_sample_position is rw,
    :$all = False
  ) {
    my gboolean $d = $discont.so.Int;
    my GstClockTime ($t, $ot, $od) = ($timestamp, 0, 0);
    my guint $n = $n_samples;
    my guint64 $osp = 0;

    my $rv = gst_audio_stream_align_process($!asa, $d, $t, $n, $ot, $od, $osp);
    ($out_timestamp, $out_duration, $out_sample_position) = ($ot, $od, $osp);
    $all.not ?? $rv
             !! ($rv, $out_timestamp, $out_duration, $out_sample_position);
  }

  method set_alignment_threshold (Int() $alignment_threshold) {
    my GstClockTime $a = $alignment_threshold;

    gst_audio_stream_align_set_alignment_threshold($!asa, $a);
  }

  method set_discont_wait (Int() $discont_wait) {
    my GstClockTime $d = $discont_wait;

    gst_audio_stream_align_set_discont_wait($!asa, $d);
  }

  method set_rate (Int() $rate) {
    my gint $r = $rate;

    gst_audio_stream_align_set_rate($!asa, $r);
  }

}
