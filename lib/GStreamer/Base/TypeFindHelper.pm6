use v6.c;

use NativeCall;

use GStreamer::Raw::Types;
use GStreamer::Raw::Base::TypeFindHelper;

use GLib::Roles::StaticClass;

class GStreamer::Base::TypeFindHelper {
  also does GLib::Roles::StaticClass;

  method gst_type_find_helper (GstPad() $src, Int() $size, :$raw = False) {
    my guint64 $s = $size;
    my $c = gst_type_find_helper($src, $s);

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

  proto method for_buffer (|)
  { * }

  multi method for_buffer (GstBuffer() $buf, :$raw = False) {
    samewith(GstObject, $buf, :$raw);
  }
  multi method for_buffer (
    GstObject() $obj,
    GstBuffer() $buf,
    $prob is rw,
    :$raw = False
  ) {
    my GstTypeFindProbability $p = 0;

    my $c = gst_type_find_helper_for_buffer($obj, $buf, $p);
    $prob = $p;

    $c = Nil unless $c;
    $c = GStreamer::Caps.new($c) unless $c.not || $raw;

    ($c, $prob);
  }

  proto method for_buffer_with_extension (|)
  { * }

  multi method for_buffer_with_extension (
    GstBuffer() $buf,
    Str() $extension,
    Int() $prob,
    :$raw = False
  ) {
    samewith(GstObject, $extension, $prob, :$raw);
  }
  multi method for_buffer_with_extension (
    GstObject() $obj,
    GstBuffer() $buf,
    Str() $extension,
    Int() $prob,
    :$raw = False
  ) {
    my GstTypeFindProbability $p = $prob;
    my $c = gst_type_find_helper_for_buffer_with_extension(
      $obj,
      $buf,
      $extension,
      $p
    );

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

  proto method for_data (|)
  { * }

  multi method for_data (
    Buf() $data,
    Int() $prob,
    :$raw = False
  ) {
    samewith(
      GstObject,
      cast(Pointer, $data),
      $data.bytes,
      $prob,
      :$raw
    );
  }
  multi method for_data (
    CArray[guint8] $data,
    Int() $size,
    Int() $prob,
    :$raw = False
  ) {
    samewith(
      GstObject,
      $data,
      $size,
      $prob,
      :$raw
    );
  }
  multi method for_data (
    GstObject() $obj,
    $data,
    Int() $size,
    Int() $prob,
    :$raw = False
  ) {
    my guint64 $s = $size;
    my GstTypeFindProbability $p = $prob;

    die '$data is an invalid tape. Can only be Buf or CArray[uint8]!'
      unless $data ~~ (Buf, CArray[uint8]).any;

    my $c = gst_type_find_helper_for_data($obj, $data, $size, $prob);

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

  proto method for_data_with_extension (|)
  { * }

  multi method for_data_with_extension (
    Buf() $data,
    Str() $extension,
    Int() $prob,
    :$raw = False
  ) {
    my GstTypeFindProbability $p = $prob;
    my $c = gst_type_find_helper_for_data_with_extension(
      GstObject,
      cast(Pointer, $data),
      $data.bytes,
      $extension,
      $prob
    );

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }
  multi method for_data_with_extension (
    CArray[guint8] $data,
    Int() $size,
    Str() $extension,
    Int() $prob,
    :$raw = False
  ) {
    samewith(GstObject, $data, $size, $extension, $prob, :$raw);
  }
  multi method for_data_with_extension (
    GstObject() $obj,
    CArray[guint8] $data,
    Int() $size,
    Str() $extension,
    Int() $prob,
    :$raw = False
  ) {
    my guint64 $s = $size;
    my GstTypeFindProbability $p = $prob;

    my $c = gst_type_find_helper_for_data_with_extension(
      $obj,
      cast(Pointer, $data),
      $size,
      $extension,
      $prob
    );

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

  proto method for_extension (|)
  { * }

  multi method for_extension (Str() $extension, :$raw = False) {
    samewith(GstObject, $extension, :$raw);
  }
  multi method for_extension (GstObject $obj, Str $extension, :$raw = False) {
    gst_type_find_helper_for_extension($obj, $extension);
  }

  proto method get_range (|)
  { * }

  multi method get_range (
    GstObject() $obj,
    &func,
    Int() $size,
    Str() $extension,
    Int() $prob,
    :$raw = False
  ) {
    samewith($obj, GstObject, &func, $size, $extension, $prob, :$raw);
  }
  multi method get_range (
    GstObject() $obj,
    GstObject() $parent,
    &func,
    Int() $size,
    Str() $extension,
    Int() $prob,
    :$raw = False
  ) {
    my guint64 $s = $size;
    my GstTypeFindProbability $p = $prob;

    my $c = gst_type_find_helper_get_range(
      $obj,
      $parent,
      &func,
      $s,
      $extension,
      $p
    );

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

  proto method get_range_full (|)
  { * }

  multi method get_range_full (
    GstObject() $obj,
    &func,
    Int() $size,
    Str() $extension,
    GstCaps() $caps,
    Int() $prob
  ) {
    samewith($obj, GstObject, $size, $extension, $caps, $prob);
  }
  multi method get_range_full (
    GstObject() $obj,
    GstObject() $parent,
    &func,
    Int() $size,
    Str() $extension,
    GstCaps() $caps,
    Int() $prob
  ) {
    my guint64 $s = $size;
    my GstTypeFindProbability $p = $prob;

    GstFlowReturnEnum(
      gst_type_find_helper_get_range_full(
        $obj,
        $parent,
        &func,
        $s,
        $extension,
        $caps,
        $p
      )
    );
  }

}
