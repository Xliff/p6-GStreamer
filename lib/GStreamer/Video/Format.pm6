use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Video::Format;

use GLib::Roles::StaticClass;

class GStreamer::Video::Format {
  also does GLib::Roles::StaticClass;

  method from_fourcc (Int() $fourcc) is also<from-fourcc> {
    my guint $f = $fourcc;

    GstVideoFormatEnum( gst_video_format_from_fourcc($f) )
  }

  method from_masks (
    Int() $depth,
    Int() $bpp,
    Int() $endianness,
    Int() $red_mask,
    Int() $green_mask,
    Int() $blue_mask,
    Int() $alpha_mask
  ) is also<from-masks> {
    my gint ($d, $b, $e) = ($depth, $bpp, $endianness);
    my guint ($rm, $gm, $bm, $am) =
      ($red_mask, $green_mask, $blue_mask, $alpha_mask);

    gst_video_format_from_masks($d, $b, $e, $rm, $gm, $bm, $am);
  }

  method from_string (Str() $format) is also<from-string> {
    GstVideoFormatEnum( gst_video_format_from_string($format) );
  }

  method get_info (Int() $format) is also<get-info> {
    my GstVideoFormat $f = $format;

    gst_video_format_get_info($f);
  }

  method get_palette (Int() $format, Int() $size) is also<get-palette> {
    my GstVideoFormat $f = $format;
    my gsize $s = $size;
    my $p = gst_video_format_get_palette($format, $s);

    $p ?? $p !! Nil;
  }

  method to_fourcc (Int() $format) is also<to-fourcc> {
    my GstVideoFormat $f = $format;

    gst_video_format_to_fourcc($f);
  }

  method to_string (Int() $format) is also<to-string> {
    my GstVideoFormat $f = $format;

    gst_video_format_to_string($f);
  }

}
