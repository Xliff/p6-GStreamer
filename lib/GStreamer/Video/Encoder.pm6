use v6.c;

use NativeCall;
use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Video::Encoder;

use GStreamer::Buffer;
use GStreamer::Caps;
use GStreamer::Element;

our subset GstVideoEncoderAncestry is export of Mu
  where GstVideoEncoder | GstElementAncestry;

class GStreamer::Video::Encoder is GStreamer::Element {
  has GstVideoEncoder $!ve;

  submethod BUILD (:$encoder) {
    self.setVideoEncoder($encoder);
  }

  method setVideoEncoder(GstVideoEncoderAncestry $_) {
    my $to-parent;

    $!ve = do {
      when GstVideoEncoder {
        $to-parent = cast(GstElement, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstVideoEncoder, $_);
      }
    }
    self.setElement($to-parent);
  }

  method GStreamer::Raw::Definitions::GstVideoEncoder
    is also<GstVideoEncoder>
  { $!ve }

  method new (GstVideoEncoderAncestry $encoder) {
    $encoder ?? self.bless( :$encoder ) !! Nil;
  }

  method allocate_output_buffer (Int() $size, :$raw = False)
    is also<allocate-output-buffer>
  {
    my gsize $s = $size;
    my $b = gst_video_encoder_allocate_output_buffer($!ve, $s);

    $b ??
      ($raw ?? $b !! GStreamer::Buffer.new($b) )
      !!
      Nil;
  }

  method allocate_output_frame (GstVideoCodecFrame $frame, Int() $size)
    is also<allocate-output-frame>
  {
    my gsize $s = $size;

    GstFlowReturnEnum(
      gst_video_encoder_allocate_output_frame($!ve, $frame, $s)
    );
  }

  method finish_frame (GstVideoCodecFrame $frame) is also<finish-frame> {
    GstFlowReturnEnum(
      gst_video_encoder_finish_frame($!ve, $frame)
    );
  }

  proto method get_allocator (|)
      is also<get-allocator>
  { * }

  multi method get_allocator (GstAllocationParams() $params) {
    samewith($, $params);
  }
  multi method get_allocator (
    $allocator is rw,
    GstAllocationParams() $params
  ) {
    my $aa = CArray[Pointer[GstAllocator]].new;
    $aa = Pointer[GstAllocator];

    gst_video_encoder_get_allocator($!ve, $aa, $params);
    $allocator = ppr($aa);
  }

  method get_frame (gint $frame_number) is also<get-frame> {
    my gint $f = $frame_number;

    gst_video_encoder_get_frame($!ve, $f);
  }

  method get_frames (:$glist = False) is also<get-frames> {
    my $fl = gst_video_encoder_get_frames($!ve);

    return Nil unless $fl;
    return $fl if     $glist;

    $fl = $fl but GLib::Roles::ListData[GstVideoCodecFrame];
    $fl.Array
  }

  proto method get_latency (|)
      is also<get-latency>
  { * }

  multi method get_latency {
    samewith($, $);
  }
  multi method get_latency ($min_latency is rw, $max_latency is rw) {
    my GstClockTime ($mnl, $mxl) = 0 xx 2;

    gst_video_encoder_get_latency($!ve, $mnl, $mxl);
    ($min_latency, $max_latency) = ($mnl, $mxl);
  }

  method get_max_encode_time (GstVideoCodecFrame $frame)
    is also<get-max-encode-time>
  {
    gst_video_encoder_get_max_encode_time($!ve, $frame);
  }

  method get_oldest_frame is also<get-oldest-frame> {
    gst_video_encoder_get_oldest_frame($!ve);
  }

  method get_output_state is also<get-output-state> {
    gst_video_encoder_get_output_state($!ve);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_video_encoder_get_type, $n, $t );
  }

  method is_qos_enabled is also<is-qos-enabled> {
    so gst_video_encoder_is_qos_enabled($!ve);
  }

  method merge_tags (GstTagList() $tags, Int() $mode) is also<merge-tags> {
    my GstTagMergeMode $m = $mode;

    gst_video_encoder_merge_tags($!ve, $tags, $m);
  }

  method negotiate {
    so gst_video_encoder_negotiate($!ve);
  }

  method proxy_getcaps (GstCaps() $caps, GstCaps() $filter, :$raw = False)
    is also<proxy-getcaps>
  {
    my $c = gst_video_encoder_proxy_getcaps($!ve, $caps, $filter);

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

  method set_headers (GList() $headers) is also<set-headers> {
    gst_video_encoder_set_headers($!ve, $headers);
  }

  method set_latency (Int() $min_latency, Int() $max_latency)
    is also<set-latency>
  {
    my GstClockTime ($mnl, $mxl) = ($min_latency, $max_latency);

    gst_video_encoder_set_latency($!ve, $mnl, $mxl);
  }

  method set_min_pts (Int() $min_pts) is also<set-min-pts> {
    my GstClockTime $m = $min_pts;

    gst_video_encoder_set_min_pts($!ve, $m);
  }

  method set_output_state (GstCaps() $caps, GstVideoCodecState $reference)
    is also<set-output-state>
  {
    gst_video_encoder_set_output_state($!ve, $caps, $reference);
  }

  method set_qos_enabled (Int() $enabled) is also<set-qos-enabled> {
    my gboolean $e = $enabled.so.Int;

    gst_video_encoder_set_qos_enabled($!ve, $enabled);
  }

}
