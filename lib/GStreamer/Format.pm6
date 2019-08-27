use v6.c;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::Format;

use GStreamer::Iterator;

class GStreamer::Format {

  method new(|) {
    warn 'GStreamer::Format is a static class and does not need instantiation.'
      if $DEBUG;

    GStreamer::Format;
  }

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

    my $f = CArray[GstFormat].new; # CArray[uint32].new

    $f[$_] = @formats[$_] for ^@formats.elems;
    samewith($f, $format);
  }
  multi method gst_formats_contains (
    CArray[GstFormat] $formats,   # Zero Terminated
    GstFormat $format
  ) {
    gst_formats_contains($formats, $format);
  }

  method iterate_definitions (:$raw = False) {
    my $i = gst_format_iterate_definitions();

    $i ??
      ( $raw ?? $i !! GStreamer::Iterator.new($i) )
      !!
      Nil;
  }

  method register (Str() $nick, Str() $description) {
    gst_format_register($nick, $description);
  }

  method to_quark (GstFormat $format) {
    gst_format_to_quark($format);
  }
