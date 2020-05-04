use MONKEY-TYPING;

use GStreamer::Raw::Types;
use GStreamer::Raw::Video::Meta;

use GStreamer::Buffer;

use GLib::Roles::StaticClass;

augment class GStreamer::Buffer {

  proto method add_video_gl_texture_upload_meta (|)
  { * }

  multi method add_video_multi_texture_upload_meta (
    GstVideoGLTextureOrientation $texture_orientation,
    guint $n_textures,
    GstVideoGLTextureType $texture_type,
    GstVideoGLTextureUpload $upload,
    gpointer $user_data = gpointer
  ) {
    samewith(
      $texture_orientation,
      $n_textures,
      $texture_type,
      $upload,
      $user_data,
      Callable,
      Callable
    );
  }
  multi method add_video_gl_texture_upload_meta (
    Int() $texture_orientation,
    Int() $n_textures,
    Int() $texture_type,
    Int() $upload,
    gpointer $user_data,
    &user_data_copy,
    &user_data_free
  ) {
    my GstVideoGLTextureOrientation $o = $texture_orientation;
    my GstVideoGLTextureType $t = $texture_type;
    my GstVideoGLTextureUpload $u = $upload;
    my guint $n = $n_textures;

    gst_buffer_add_video_gl_texture_upload_meta(
      $!b,
      $o,
      $n,
      $t,
      $u,
      $user_data,
      &user_data_copy,
      &user_data_free
    );
  }

  method add_video_meta (
    Int() $flags,
    Int() $format,
    Int() $width,
    Int() $height
  ) {
    my GstVideoFrameFlags $fl = $flags;
    my GstVideoFormat $f = $format;
    my guint ($w, $h) = ($width, $height);

    gst_buffer_add_video_meta($!b, $fl, $f, $w, $h);
  }

  method add_video_meta_full (
    Int() $flags,
    Int() $format,
    Int() $width,
    Int() $height,
    Int() $n_planes,
    Int() $offset,
    Int() $stride
  ) {
    my GstVideoFrameFlags $fl = $flags;
    my GstVideoFormat $f = $format;
    my guint ($w, $h, $n) = ($width, $height, $n_planes);
    my gsize $o = $offset;
    my gint $s = $stride;

    gst_buffer_add_video_meta_full($!b, $fl, $f, $w, $h, $n, $o, $s);
  }

  method add_video_region_of_interest_meta (
    Str() $roi_type,
    Int() $x,
    Int() $y,
    Int() $w,
    Int() $h
  ) {
    my guint ($xx, $yy, $ww, $hh) = ($x, $y, $w, $h);

    gst_buffer_add_video_region_of_interest_meta(
      $!b,
      $roi_type,
      $xx,
      $yy,
      $ww,
      $hh
    );
  }

  method add_video_region_of_interest_meta_id (
    GQuark $roi_type,
    Int() $x,
    Int() $y,
    Int() $w,
    Int() $h
  ) {
    my guint ($xx, $yy, $ww, $hh) = ($x, $y, $w, $h);

    gst_buffer_add_video_region_of_interest_meta_id(
      $!b,
      $roi_type,
      $xx,
      $yy,
      $ww,
      $hh
    );
  }

  method get_video_meta (:$raw = False) {
    gst_buffer_get_video_meta($!b);
  }

  method get_video_meta_id (Int() $id) {
    my gint $i = $id;

    gst_buffer_get_video_meta_id($!b, $i);
  }

}
