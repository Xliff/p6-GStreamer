use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;
use GStreamer::Raw::Video::Decoder;

use GStreamer::Buffer;
use GStreamer::BufferPool;
use GStreamer::Caps;
use GStreamer::Element;

use GLib::Roles::ListData;

our subset GstVideoDecoderAncestry is export of Mu
  where GstVideoDecoder | GstElementAncestry;

class GStreamer::Video::Decoder is GStreamer::Element {
  has GstVideoDecoder $!vd;

  submethod BUILD (:$decoder) {
    self.setVideoDecoder($decoder);
  }

  method setVideoDecoder(GstVideoDecoderAncestry $_) {
    my $to-parent;

    $!vd = do {
      when GstVideoDecoder {
        $to-parent = cast(GstElement, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstVideoDecoder, $_);
      }
    }
    self.setElement($to-parent);
  }

  method GStreamer::Raw::Definitions::GstVideoDecoder
    is also<GstVideoDecoder>
  { $!vd }

  method new (GstVideoDecoderAncestry $decoder) {
    $decoder ?? self.bless( :$decoder ) !! Nil;
  }

  method add_to_frame (Int() $n_bytes) is also<add-to-frame> {
    my gint $n = $n_bytes;

    gst_video_decoder_add_to_frame($!vd, $n);
  }

  method allocate_output_buffer (:$raw = False)
    is also<allocate-output-buffer>
  {
    my $b = gst_video_decoder_allocate_output_buffer($!vd);

    $b ??
      ( $raw ?? $b !! GStreamer::Buffer.new($b) )
      !!
      Nil;
  }

  method allocate_output_frame (GstVideoCodecFrame $frame)
    is also<allocate-output-frame>
  {
    GstFlowReturnEnum(
      gst_video_decoder_allocate_output_frame($!vd, $frame)
    )
  }

  method allocate_output_frame_with_params (
    GstVideoCodecFrame $frame,
    GstBufferPoolAcquireParams $params
  )
    is also<allocate-output-frame-with-params>
  {
    GstFlowReturnEnum(
      gst_video_decoder_allocate_output_frame_with_params(
        $!vd,
        $frame,
        $params
      )
    );
  }

  method drop_frame (GstVideoCodecFrame $frame) is also<drop-frame> {
    GstFlowReturnEnum( gst_video_decoder_drop_frame($!vd, $frame) );
  }

  method finish_frame (GstVideoCodecFrame $frame) is also<finish-frame> {
    GstFlowReturnEnum( gst_video_decoder_finish_frame($!vd, $frame) );
  }

  proto method get_allocator (|)
      is also<get-allocator>
  { * }

  multi method get_allocator (GstAllocationParams $params) {
    samewith($, $params);
  }
  multi method get_allocator (
    $allocator is rw,
    $params is rw;
  ) {
    my $aa = CArray[Pointer[GstAllocator]].new;
    my GstAllocationParams $p = 0;

    $aa[0] = Pointer[GstAllocator];
    gst_video_decoder_get_allocator($!vd, $aa, $p);

    ($allocator, $params) = ppr($aa, $p);
  }

  method get_buffer_pool (:$raw = False) is also<get-buffer-pool> {
    my $bp = gst_video_decoder_get_buffer_pool($!vd);

    $bp ??
      ( $raw ?? $bp !! GStreamer::BufferPool.new($bp) )
      !!
      Nil;
  }

  method get_estimate_rate is also<get-estimate-rate> {
    gst_video_decoder_get_estimate_rate($!vd);
  }

  method get_frame (Int() $frame_number) is also<get-frame> {
    my gint $f = $frame_number;

    gst_video_decoder_get_frame($!vd, $f);
  }

  method get_frames (:$glist = False) is also<get-frames> {
    my $fl = gst_video_decoder_get_frames($!vd);

    return Nil unless $fl;
    return $fl if     $glist;

    $fl = $fl but GLib::Roles::ListData[GstVideoCodecFrame];
    $fl.Array;
  }

  proto method get_latency (|)
      is also<get-latency>
  { * }

  multi method get_latency {
    samewith($, $);
  }
  multi method get_latency ($min_latency is rw, $max_latency is rw) {
    my GstClockTime ($mnl, $mxl) = 0 xx 2;

    gst_video_decoder_get_latency($!vd, $mnl, $mxl);
    ($min_latency, $max_latency) = ($mnl, $mxl);
  }

  method get_max_decode_time (GstVideoCodecFrame $frame)
    is also<get-max-decode-time>
  {
    gst_video_decoder_get_max_decode_time($!vd, $frame);
  }

  method get_max_errors is also<get-max-errors> {
    gst_video_decoder_get_max_errors($!vd);
  }

  method get_needs_format is also<get-needs-format> {
    so gst_video_decoder_get_needs_format($!vd);
  }

  method get_oldest_frame is also<get-oldest-frame> {
    gst_video_decoder_get_oldest_frame($!vd);
  }

  method get_output_state is also<get-output-state> {
    gst_video_decoder_get_output_state($!vd);
  }

  method get_packetized is also<get-packetized> {
    so gst_video_decoder_get_packetized($!vd);
  }

  method get_pending_frame_size is also<get-pending-frame-size> {
    gst_video_decoder_get_pending_frame_size($!vd);
  }

  method get_qos_proportion is also<get-qos-proportion> {
    gst_video_decoder_get_qos_proportion($!vd);
  }

  method have_frame is also<have-frame> {
    GstFlowReturnEnum( gst_video_decoder_have_frame($!vd) );
  }

  method merge_tags (GstTagList() $tags, Int() $mode) is also<merge-tags> {
    my GstTagMergeMode $m = $mode;

    gst_video_decoder_merge_tags($!vd, $tags, $m);
  }

  method negotiate {
    so gst_video_decoder_negotiate($!vd);
  }

  method proxy_getcaps (GstCaps() $caps, GstCaps() $filter, $raw = False)
    is also<proxy-getcaps>
  {
    my $c = gst_video_decoder_proxy_getcaps($!vd, $caps, $filter);

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

  method release_frame (GstVideoCodecFrame $frame) is also<release-frame> {
    gst_video_decoder_release_frame($!vd, $frame);
  }

  method set_estimate_rate (Int() $enabled) is also<set-estimate-rate> {
    my gboolean $e = $enabled.so.Int;

    gst_video_decoder_set_estimate_rate($!vd, $e);
  }

  method set_interlaced_output_state (
    Int() $fmt,
    Int() $mode,
    guint $width,
    guint $height,
    GstVideoCodecState $ref
  )
    is also<set-interlaced-output-state>
  {
    my GstVideoInterlaceMode $m = $mode;
    my guint ($w, $h) = ($width, $height);
    my GstVideoFormat $f = $fmt;

    gst_video_decoder_set_interlaced_output_state($!vd, $f, $m, $w, $h, $ref);
  }

  method set_latency (Int() $min_latency, Int() $max_latency)
    is also<set-latency>
  {
    my GstClockTime ($mnl, $mxl) = ($min_latency, $max_latency);

    gst_video_decoder_set_latency($!vd, $mnl, $mxl);
  }

  method set_max_errors (Int() $num) is also<set-max-errors> {
    my gint $n = $num;

    gst_video_decoder_set_max_errors($!vd, $n);
  }

  method set_needs_format (Int() $enabled) is also<set-needs-format> {
    my gboolean $e = $enabled.so.Int;

    gst_video_decoder_set_needs_format($!vd, $e);
  }

  method set_output_state (
    Int() $fmt,
    Int() $width,
    Int() $height,
    GstVideoCodecState $reference
  )
    is also<set-output-state>
  {
    my GstVideoFormat $f = $fmt;
    my guint ($w, $h) = ($width,  $height);

    gst_video_decoder_set_output_state($!vd, $f, $w, $h, $reference);
  }

  method set_packetized (Int() $packetized) is also<set-packetized> {
    my gboolean $p = $packetized.so.Int;

    gst_video_decoder_set_packetized($!vd, $p);
  }

  method set_use_default_pad_acceptcaps (Int() $use)
    is also<set-use-default-pad-acceptcaps>
  {
    my gboolean $u = $use.so.Int;

    gst_video_decoder_set_use_default_pad_acceptcaps($!vd, $u);
  }

}
