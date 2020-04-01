use v6.c;

use NativeCall;

use GStreamer::Raw::Types;
use GStreamer::Raw::Format;

use GStreamer::Iterator;

use GLib::Roles::StaticClass;

class GStreamer::Format {
  also does GLib::Roles::StaticClass;

  method get_by_nick (Str() $nick) {
    gst_format_get_by_nick($nick);
  }

  method get_details (GstFormat $format) {
    gst_format_get_details($format);
  }

  method get_name (GstFormat $format) {
    gst_format_get_name($format);
  }

  proto method gst_formats_contains (|)
  { * }

  multi method gst_formats_contains (@formats, GstFormat $format) {
    die '@formats must only contain GstFormat data!'
      unless @formats.all ~~ GstFormat;

    my $f = CArray[uint32].new; # CArray[uint32].new

    my $ne = @formats.elems;
    $f[$_] = @formats[$_] for ^$ne;
    $f[$ne] = 0;
    samewith($f, $format);
  }
  multi method gst_formats_contains (
    CArray[uint32] $formats,   # Zero Terminated
    Int() $format
  ) {
    my GstFormat $f = $format;

    die '$formats input must be zero-terminated!' if $formats[* - 1];

    gst_formats_contains($formats, $f);
  }

  method iterate_definitions (:$raw = False) {
    my $i = gst_format_iterate_definitions();

    $i ??
      ( $raw ?? $i !! GStreamer::Iterator.new($i) )
      !!
      GstIterator;
  }

  method register (Str() $nick, Str() $description) {
    gst_format_register($nick, $description);
  }

  method to_quark (
    Int() $format # GstFormat $format
  ) {
    my GstFormat $f = $format;

    gst_format_to_quark($f);
  }

}
