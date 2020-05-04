use v6.c;

use Method::Also;

use MONKEY-TYPING;

use GStreamer::Raw::Types;
use GStreamer::Raw::Video::OverlayComposition;

use GStreamer::Buffer;

# Delayed definition due to use of enum.
constant GST_VIDEO_OVERLAY_COMPOSITION_FORMAT_YUV is export = GST_VIDEO_FORMAT_AYUV;
constant GST_VIDEO_OVERLAY_COMPOSITION_FORMAT_RGB is export =
  $*KERNEL.endian == BigEndian ?? GST_VIDEO_FORMAT_ARGB
                               !! GST_VIDEO_FORMAT_BGRA;

augment class GStreamer::Buffer {

  method add_video_overlay_composition_meta (
    GstVideoOverlayComposition $comp
  ) is also<add-video-overlay-composition-meta> {
    gst_buffer_add_video_overlay_composition_meta($!b, $comp);
  }

}

# GstMiniObject?
class GStreamer::Video::OverlayRectangle {
  has GstVideoOverlayRectangle $!or;

  submethod BUILD (:$overlay-rect) {
    $!or = $overlay-rect;
  }

  method GStreamer::Raw::Definitions::GstVideoOverlayRectangle
    is also<GstVideoOverlayRectangle>
  { $!or }

  multi method new (GstVideoOverlayRectangle $overlay-rect) {
    $overlay-rect ?? self.bless( :$overlay-rect ) !! Nil;
  }
  multi method new (
    GstBuffer() $pixels,
    Int() $render_x,
    Int() $render_y,
    Int() $render_width,
    Int() $render_height,
    Int() $flags
  ) {
    my gint ($rx, $ry) = ($render_x, $render_y);
    my guint ($rw, $rh) = ($render_width, $render_height);
    my GstVideoOverlayFormatFlags $f = $flags;
    my $overlay-rect = gst_video_overlay_rectangle_new_raw(
      $pixels,
      $rx,
      $ry,
      $rw,
      $rh,
      $f
    );

    $overlay-rect ?? self.bless( :$overlay-rect ) !! Nil;
  }

  method copy {
    gst_video_overlay_rectangle_copy($!or);
  }

  method get_flags is also<get-flags> {
    gst_video_overlay_rectangle_get_flags($!or);
  }

  method get_global_alpha is also<get-global-alpha> {
    gst_video_overlay_rectangle_get_global_alpha($!or);
  }

  method get_pixels_argb (Int() $flags, :$raw = False)
    is also<get-pixels-argb>
  {
    my GstVideoOverlayFormatFlags $f = $flags;
    my $b = gst_video_overlay_rectangle_get_pixels_argb($!or, $f);

    $b ??
      ( $raw ?? $b !! GStreamer::Buffer.new($b) )
      !!
      Nil;
  }

  method get_pixels_ayuv (Int() $flags, :$raw = False)
    is also<get-pixels-ayuv>
  {
    my GstVideoOverlayFormatFlags $f = $flags;
    my $b = gst_video_overlay_rectangle_get_pixels_ayuv($!or, $f);

    $b ??
      ( $raw ?? $b !! GStreamer::Buffer.new($b) )
      !!
      Nil;
  }

  method get_pixels_raw (Int() $flags, :$raw = False)
    is also<get-pixels-raw>
  {
    my GstVideoOverlayFormatFlags $f = $flags;
    my $b = gst_video_overlay_rectangle_get_pixels_raw($!or, $f);

    $b ??
      ( $raw ?? $b !! GStreamer::Buffer.new($b) )
      !!
      Nil;
  }

  method get_pixels_unscaled_argb (
    Int() $flags,
    :$raw = False
  )
    is also<get-pixels-unscaled-argb>
  {
    my GstVideoOverlayFormatFlags $f = $flags;
    my $b = gst_video_overlay_rectangle_get_pixels_unscaled_argb($!or, $f);

    $b ??
      ( $raw ?? $b !! GStreamer::Buffer.new($b) )
      !!
      Nil;
  }

  method get_pixels_unscaled_ayuv (
    Int() $flags,
    :$raw = False
  )
    is also<get-pixels-unscaled-ayuv>
  {
    my GstVideoOverlayFormatFlags $f = $flags;
    my $b = gst_video_overlay_rectangle_get_pixels_unscaled_ayuv($!or, $f);

    $b ??
      ( $raw ?? $b !! GStreamer::Buffer.new($b) )
      !!
      Nil;
  }

  method get_pixels_unscaled_raw (
    Int() $flags,
    :$raw = False
  )
    is also<get-pixels-unscaled-raw>
  {
    my GstVideoOverlayFormatFlags $f = $flags;
    my $b = gst_video_overlay_rectangle_get_pixels_unscaled_raw($!or, $f);

    $b ??
      ( $raw ?? $b !! GStreamer::Buffer.new($b) )
      !!
      Nil;
  }

  proto method get_render_rectangle (|)
  { * }

  multi method get_render_rectangle {
    samewith($, $, $, $);
  }
  multi method get_render_rectangle (
    $render_x is rw,
    $render_y is rw,
    $render_width is rw,
    $render_height is rw
  )
    is also<get-render-rectangle>
  {
    my gint ($rx, $ry) = 0 xx 2;
    my guint ($rw, $rh) = 0 xx 2;

    gst_video_overlay_rectangle_get_render_rectangle($!or, $rx, $ry, $rw, $rh);
    ($render_x, $render_y, $render_width, $render_height) =
      ($rx, $ry, $rw, $rh);
  }

  method get_seqnum is also<get-seqnum> {
    gst_video_overlay_rectangle_get_seqnum($!or);
  }

  method set_global_alpha (Num() $global_alpha) is also<set-global-alpha> {
    my gfloat $ga = $global_alpha;

    gst_video_overlay_rectangle_set_global_alpha($!or, $ga);
  }

  method set_render_rectangle (
    Int() $render_x,
    Int() $render_y,
    Int() $render_width,
    Int() $render_height
  )
    is also<set-render-rectangle>
  {
    my gint ($rx, $ry) = ($render_x, $render_y);
    my guint ($rw, $rh) = ($render_width, $render_height);

    gst_video_overlay_rectangle_set_render_rectangle($!or, $rx, $ry, $rw, $rh);
  }

}

# GstMiniObject?
class GStreamer::Video::OverlayComposition {
  has GstVideoOverlayComposition $!oc;

  submethod BUILD (:$overlay-comp) {
    $!oc = $overlay-comp;
  }

  method GStreamer::Raw::Definitions::GstVideoOverlayComposition
    is also<GstVideoOverlayComposition>
  { $!oc }

  multi method new (GstVideoOverlayComposition $overlay-comp) {
    $overlay-comp ?? self.bless( :$overlay-comp ) !! Nil;
  }
  multi method new (GstVideoOverlayRectangle $rectangle) {
    my $overlay-comp = gst_video_overlay_composition_new($rectangle);

    $overlay-comp ?? self.bless( :$overlay-comp ) !! Nil;
  }

  method add_rectangle (GstVideoOverlayRectangle $rectangle)
    is also<add-rectangle>
  {
    gst_video_overlay_composition_add_rectangle($!oc, $rectangle);
  }

  method blend (GstVideoFrame $video_buf) {
    so gst_video_overlay_composition_blend($!oc, $video_buf);
  }

  method copy (:$raw = False) {
    my $c = gst_video_overlay_composition_copy($!oc);

    $c ??
      ( $raw ?? $c !! GStreamer::Video::OverlayComposition.new($c) )
      !!
      Nil
  }

  method get_rectangle (Int() $n) is also<get-rectangle> {
    my guint $nn = $n;

    gst_video_overlay_composition_get_rectangle($!oc, $nn);
  }

  method get_seqnum is also<get-seqnum> {
    gst_video_overlay_composition_get_seqnum($!oc);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &gst_video_overlay_composition_get_type,
      $n,
      $t
    );
  }

  method make_writable (:$raw = False) is also<make-writable> {
    my $wr = gst_video_overlay_composition_make_writable($!oc);

    $wr ??
      ( $raw ?? $wr !! GStreamer::Video::OverlayComposition.new($wr) )
      !!
      Nil;
  }

  method n_rectangles is also<n-rectangles> {
    gst_video_overlay_composition_n_rectangles($!oc);
  }
}
