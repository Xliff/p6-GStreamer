use v6.c;

use Method::Also;
use NativeCall;

use GStreamer::Raw::Types;
use GStreamer::Raw::Audio::RingBuffer;

use GStreamer::Object;

our subset GstAudioRingBufferAncestry is export of Mu
  where GstAudioRingBuffer | GstObject;

class GStreamer::Audio::RingBuffer is GStreamer::Object {
  has GstAudioRingBuffer $!arb;

  submethod BUILD (:$ring-buffer) {
    self.setGstAudioRingBuffer($ring-buffer);
  }

  method setGstAudioRingBuffer(GstAudioRingBufferAncestry $_) {
    my $to-parent;

    $!arb = do {
      when GstAudioRingBuffer {
        $to-parent = cast(GstObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstAudioRingBuffer, $_);
      }
    }
    self.setGstObject($to-parent);
  }

  method GStreamer::Raw::Structs::GstAudioRingBuffer
    is also<GstAudioRingBuffer>
  { $!arb }

  method new (GstAudioRingBufferAncestry $ring-buffer) {
    $ring-buffer ?? self.bless( :$ring-buffer ) !! Nil;
  }

  method acquire (GstAudioRingBufferSpec $spec) {
    so gst_audio_ring_buffer_acquire($!arb, $spec);
  }

  method activate (Int() $active) {
    my gboolean $a = $active.so.Int;

    so gst_audio_ring_buffer_activate($!arb, $a);
  }

  method advance (Int() $advance) {
    my guint $a = $advance;

    gst_audio_ring_buffer_advance($!arb, $a);
  }

  method clear (Int() $segment) {
    my gint $s = $segment;

    gst_audio_ring_buffer_clear($!arb, $s);
  }

  method clear_all is also<clear-all> {
    gst_audio_ring_buffer_clear_all($!arb);
  }

  method close_device is also<close-device> {
    gst_audio_ring_buffer_close_device($!arb);
  }

  multi method commit (
    $sample,
    Buf() $data,
    Int() $out_samples
  ) {
    samewith($sample, cast(Pointer, $data), $data.bytes, $out_samples, $, :all);
  }
  multi method commit (
    $sample,
    CArray[guint8] $data,
    Int() $in_samples,
    Int() $out_samples
  ) {
    samewith($sample, cast(Pointer, $data), $in_samples, $out_samples, $, :all);
  }
  multi method commit (
    $sample,
    Pointer $data,
    Int() $in_samples,
    Int() $out_samples,
  ) {
    samewith($sample, $data, $in_samples, $out_samples, $, :all);
  }
  multi method commit (
    $sample,
    Buf() $data,
    Int() $out_samples,
    Int() $accum is rw,
    :$all = False
  ) {
    samewith($sample, cast(Pointer, $data), $data.bytes, $out_samples, $accum);
  }
  multi method commit (
    $sample,
    CArray[guint8] $data,
    Int() $in_samples,
    Int() $out_samples,
    Int() $accum is rw,
    :$all = False
  ) {
    samewith($sample, cast(Pointer, $data), $in_samples, $out_samples, $accum);
  }
  multi method commit (
    $sample,
    Pointer $data,
    Int() $in_samples,
    Int() $out_samples,
    Int() $accum is rw,
  ) {
    die "\$sample must be either a guint64-compatible value or a CArray {''
        }containing the same!"
    unless $sample ~~ ( Int, CArray[guint64] ).any ||
           ( my $meth = $sample.^lookup('Int') );

    my gint ($i, $o, $a) = ($in_samples, $out_samples, 0);

    my $s = do if $sample !~~ Int {
      CArray[guint64].new( $meth($sample) );
    } elsif $sample ~~ CArray[guint64] {
      $sample;
    } else {
      CArray[guint64].new($sample);
    }

    my $c = gst_audio_ring_buffer_commit($!arb, $s, $data, $i, $o, $a);
    ($c, $accum = $a);
  }

  multi method convert (
    Int() $src_fmt,
    Int() $src_val,
    Int() $dest_fmt
  ) {
    my $rv = samewith($src_fmt, $src_val, $dest_fmt, $);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method convert (
    Int() $src_fmt,
    Int() $src_val,
    Int() $dest_fmt,
    Int() $dest_val is rw,
    :$all = False
  ) {
    my gint64 ($s, $d) = ($src_val, 0);
    my GstFormat ($sf, $df) = ($src_fmt, $dest_fmt);

    my $rv = gst_audio_ring_buffer_convert($!arb, $sf, $src_val, $sf, $d);
    $dest_val = $d;
    $all.not ?? $rv !! ($rv, $dest_val);
  }

  method delay {
    gst_audio_ring_buffer_delay($!arb);
  }

  method device_is_open is also<device-is-open> {
    so gst_audio_ring_buffer_device_is_open($!arb);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_audio_ring_buffer_get_type, $n, $t );
  }

  method is_acquired is also<is-acquired> {
    so gst_audio_ring_buffer_is_acquired($!arb);
  }

  method is_active is also<is-active> {
    so gst_audio_ring_buffer_is_active($!arb);
  }

  method is_flushing is also<is-flushing> {
    so gst_audio_ring_buffer_is_flushing($!arb);
  }

  method may_start (Int() $allowed) is also<may-start> {
    my gboolean $a = $allowed.so.Int;

    gst_audio_ring_buffer_may_start($!arb, $a);
  }

  method open_device is also<open-device> {
    so gst_audio_ring_buffer_open_device($!arb);
  }

  method pause {
    so gst_audio_ring_buffer_pause($!arb);
  }

  proto method prepare_read (|)
      is also<prepare-read>
  { * }

  multi method prepare_read {
    my $rv = samewith($, $, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method prepare_read (
    $segment is rw,
    $readptr is rw,
    $len     is rw,
    :$all = False
  ) {
    my ($s, $l) = 0;
    my $r = CArray[CArray[guint8]].new;

    $r[0] = CArray[guint8];
    my $rv = gst_audio_ring_buffer_prepare_read($!arb, $s, $r, $l);
    ($segment, $readptr, $len) = ppr($s, $r, $l);
    $all.not ?? $rv !! ($rv, $segment, $readptr, $len);
  }

  multi method read (
    Int() $sample,
    Buf() $data
  ) {
    samewith($sample, cast(Pointer, $data), $data.bytes, $);
  }
  multi method read (
    Int() $sample,
    CArray[guint8] $data,
    Int() $len
  ) {
    samewith($sample, cast(Pointer, $data), $data.bytes, $);
  }
  multi method read (
    Int() $sample,
    Pointer $data,
    Int() $len
  ) {
    samewith($sample, $data, $len, $);
  }
  multi method read (
    Int() $sample,
    Buf() $data,
    $timestamp is rw
  ) {
    samewith($sample, cast(Pointer, $data), $data.bytes, $timestamp);
  }
  multi method read (
    Int() $sample,
    CArray[guint8] $data,
    Int() $len,
    $timestamp is rw
  ) {
    samewith($sample, cast(Pointer, $data), $len, $timestamp);
  }
  multi method read (
    Int() $sample,
    Pointer $data,
    Int() $len,
    $timestamp is rw,
  ) {
    my guint64 $s = $sample;
    my guint $l = $len;
    my GstClockTime $t = 0;

    my $sr = gst_audio_ring_buffer_read($!arb, $s, $data, $l, $t);
    $timestamp = $t;
    ($sr, $timestamp);
  }

  method release {
    so gst_audio_ring_buffer_release($!arb);
  }

  method samples_done is also<samples-done> {
    gst_audio_ring_buffer_samples_done($!arb);
  }

  method set_callback (&cb, gpointer $user_data = gpointer)
    is also<set-callback>
  {
    gst_audio_ring_buffer_set_callback($!arb, &cb, $user_data);
  }

  method set_callback_full (
    &cb,
    gpointer $user_data    = gpointer,
    GDestroyNotify $notify = gpointer
  )
    is also<set-callback-full>
  {
    gst_audio_ring_buffer_set_callback_full($!arb, &cb, $user_data, $notify);
  }

  method set_channel_positions (Int() $position)
    is also<set-channel-positions>
  {
    my GstAudioChannelPosition $p = $position;

    gst_audio_ring_buffer_set_channel_positions($!arb, $p);
  }

  method set_flushing (Int() $flushing) is also<set-flushing> {
    my gboolean $f = $flushing.so.Int;

    gst_audio_ring_buffer_set_flushing($!arb, $f);
  }

  method set_sample (Int() $sample) is also<set-sample> {
    my guint64 $s = $sample;

    gst_audio_ring_buffer_set_sample($!arb, $s);
  }

  method set_timestamp (Int() $readseg, Int() $timestamp)
    is also<set-timestamp>
  {
    my gint $r = $readseg;
    my GstClockTime $t = $timestamp;

    gst_audio_ring_buffer_set_timestamp($!arb, $r, $t);
  }

  method start {
    so gst_audio_ring_buffer_start($!arb);
  }

  method stop {
    so gst_audio_ring_buffer_stop($!arb);
  }

}
