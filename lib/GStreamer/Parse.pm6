use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::Parse;

use GStreamer::Element;

class GStreamer::Parse {

  method new (|) {
    warn 'GStreamer::Parse is a static class and does not need instantiation.'
      unless $DEBUG;

    GStreamer::Parse;
  }

  method error_quark {
    gst_parse_error_quark();
  }

  method launch (
    Str() $pipeline_desc,
    CArray[Pointer[GError]] $error = gerror(),
    :$raw = False
  ) {
    clear_error;
    my $e = gst_parse_launch($pipeline_desc, $error);
    set_error($error);

    $e ??
      ( $raw ?? $e !! GStreamer::Element.new($e) )
      !!
      Nil;
  }

  method launch_full (
    Str() $pipeline_desc,
    GstParseContext() $context,
    Int() $flags, # GstParseFlags $flags,
    CArray[Pointer[GError]] $error = gerror,
    :$raw = False
  ) {
    my guint $f = $flags;
    clear_error;
    my $e = gst_parse_launch_full($pipeline_desc, $context, $f, $error);
    set_error($error);

    $e ??
      ( $raw ?? $e !! GStreamer::Element.new($e) )
      !!
      Nil;
  }

  multi method launchv(
    @v,
    CArray[Pointer[GError]]
    $error = gerror,
    :$raw = False
  ) {
    my $v = CArray[Str].new;
    my $ne = @v.elems;

    $v[$_] = @v[$_] for ^$ne;
    $v[$ne] = Str;
    samewith($v, $error, :$raw);
  }
  multi method launchv (
    CArray[Str] $v,
    CArray[Pointer[GError]] $error = gerror,
    :$raw = False
  ) {
    clear_error;
    my $e = gst_parse_launchv($v, $error);
    set_error($error);

    $e ??
      ( $raw ?? $e !! GStreamer::Element.new($e) )
      !!
      Nil;
  }

  multi method launchv_full (
    @v,
    GstParseContext() $context,
    Int() $flags, # GstParseFlags $flags,
    CArray[Pointer[GError]] $error = gerror,
    :$raw = False
  ) {
    my $v = CArray[Str].new;
    my $ne = @v.elems;

    $v[$_] = @v[$_] for ^$ne;
    $v[$ne] = Str;
    samewith($v, $context, $flags, $error, :$raw);
  }
  multi method launchv_full (
    CArray[Str] $v,
    GstParseContext() $context,
    Int() $flags, # GstParseFlags $flags,
    CArray[Pointer[GError]] $error = gerror,
    :$raw = False
  ) {
    my guint $f = $flags;
    my $e = gst_parse_launchv_full($v, $context, $f, $error);

    $e ??
      ( $raw ?? $e !! GStreamer::Element.new($e) )
      !!
      Nil;
  }

}

class GStreamer::ParseContext {
  has GstParseContext $!pc;

  submethod BUILD (:$parsecontext) {
    $!pc = $parsecontext;
  }

  method GStreamer::Raw::Types::GstParseContext
  { $!pc }

  method new {
    self.bless( parsecontext => gst_parse_context_new() );
  }

  method copy {
    self.bless( parsecontext => gst_parse_context_copy($!pc) );
  }

  method free {
    gst_parse_context_free($!pc);
  }

  method get_missing_elements {
    gst_parse_context_get_missing_elements($!pc);
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_parse_context_get_type, $n, $t );
  }

}
