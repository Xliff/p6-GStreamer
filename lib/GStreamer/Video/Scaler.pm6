use v6.c;

use Method::Also;
use NativeCall;

use GStreamer::Raw::Types;
use GStreamer::Raw::Video::Scaler;

class GStreamer::Video::Scaler {
  has GstVideoScaler $!vs;

  submethod BUILD (:$scaler) {
    $!vs = $scaler;
  }

  multi method new (GstVideoScaler $scaler) {
    $scaler ?? self.bless( :$scaler ) !! Nil;
  }
  multi method new (
    Int() $method,
    Int() $flags,
    Int() $n_taps,
    Int() $in_size,
    Int() $out_size,
    GstStructure() $options
  ) {
    my GstVideoResamplerMethod $m = $method;
    my GstVideoScalerFlags $f = $flags;
    my guint ($n, $i, $o) = ($n_taps, $in_size, $out_size);
    my $scaler = gst_video_scaler_new($m, $f, $n, $i, $o, $options);

    $scaler ?? self.bless( :$scaler ) !! Nil;
  }

  method GStreamer::Raw::Definitions::GstVideoScaler
    is also<GstVideoScaler>
  { $!vs }

  proto method scale_2d (|)
    is also<scale-2d>
  { * }

  multi method scale_2d (
    GstVideoScaler() $vscale,
    Int() $format,
    Buf() $src,
    Int() $src_stride,
    Buf() $dest,
    Int() $dest_stride,
    Int() $x,
    Int() $y,
    Int() $width,
    Int() $height
  ) {
    samewith(
      $vscale,
      $format,
      cast(gpointer, $src),
      $src_stride,
      cast(gpointer, $dest),
      $dest_stride,
      $x,
      $y,
      $width,
      $height
    );
  }
  multi method scale_2d (
    GstVideoScaler() $vscale,
    Int() $format,
    gpointer $src,
    Int() $src_stride,
    gpointer $dest,
    Int() $dest_stride,
    Int() $x,
    Int() $y,
    Int() $width,
    Int() $height
  ) {
    my GstVideoFormat $f = $format;
    my gint ($ss, $ds) = ($src_stride, $dest_stride);
    my guint ($xx, $yy, $ww, $hh) = ($x, $y, $width, $height);

    gst_video_scaler_2d(
      $!vs,
      $vscale,
      $f,
      $src,
      $ss,
      $dest,
      $ds,
      $xx,
      $yy,
      $ww,
      $hh
    );
  }

  method combine_packed_YUV (
    GstVideoScaler() $uv_scale,
    Int() $in_format,
    Int() $out_format
  )
    is also<
      combine-packed-YUV
      combine_packed_yuv
      combine-packed-yuv
    >
  {
    my GstVideoFormat ($i, $o) = ($in_format, $out_format);

    gst_video_scaler_combine_packed_YUV($!vs, $uv_scale, $i, $o);
  }

  method free {
    gst_video_scaler_free($!vs);
  }

  proto method get_coeff (|)
      is also<get-coeff>
  { * }

  multi method get_coeff (Int() $out_offset, :$raw = False) {
    samewith($out_offset, $, $, :all, :$raw);
  }
  multi method get_coeff (
    Int() $out_offset,
    $in_offset is rw,
    $n_taps    is rw,
    :$all = False,
    :$raw = False
  ) {
    my guint ($o, $i, $n) = ($out_offset, 0, 0);
    my $ca = gst_video_scaler_get_coeff($!vs, $o, $i, $n);

    $ca = CArrayToArray(gdouble, $ca) unless $raw;
    ($in_offset, $n_taps) = ($i, $n);
    $all.not ?? $ca !! ($ca, $in_offset, $n_taps);
  }

  method get_max_taps is also<get-max-taps> {
    gst_video_scaler_get_max_taps($!vs);
  }

  # $src is left as pointer until the horizontal and vertical methods are
  # better understood. PRs would be VERY welcome!
  multi method horizontal (
    Int() $format,
    gpointer $src,
    CArray[guint8] $dest,
    Int() $dest_offset,
    Int() $width
  ) {
    samewith($format, $src, cast(gpointer, $dest), $dest_offset, $width);
  }
  multi method horizontal (
    Int() $format,
    gpointer $src,
    gpointer $dest,
    Int() $dest_offset,
    Int() $width
  ) {
    my GstVideoFormat $f = $format;
    my guint ($d, $w);

    gst_video_scaler_horizontal($!vs, $format, $src, $dest, $d, $w);
  }

  method vertical (
    Int() $format,
    CArray[gpointer] $src_lines,
    CArray[guint8] $dest,
    Int() $dest_offset,
    Int() $width
  ) {
    my GstVideoFormat $f = $format;
    my guint ($d, $w);

    gst_video_scaler_vertical(
      $!vs,
      $f,
      $src_lines,
      cast(gpointer, $dest),
      $d,
      $w
    );
  }

}
