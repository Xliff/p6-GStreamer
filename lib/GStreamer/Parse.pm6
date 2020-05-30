use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;
use GStreamer::Raw::Parse;

use GStreamer::Element;

use GLib::Roles::StaticClass;

class GStreamer::Parse {
  also does GLib::Roles::StaticClass;

  method error_quark is also<error-quark> {
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
  )
    is also<launch-full>
  {
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
    my $v = resolve-gstrv(@v);

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

  proto method launchv_full (|)
    is also<launchv-full>
  { * }

  multi method launchv_full (
    @v,
    GstParseContext() $context,
    Int() $flags, # GstParseFlags $flags,
    CArray[Pointer[GError]] $error = gerror,
    :$raw = False
  ) {
    my $v = resolve-gstrv(@v);

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

  method GStreamer::Raw::Definitions::GstParseContext
    is also<GstParseContext>
  { $!pc }

  method new {
    my $parsecontext = gst_parse_context_new();

    $parsecontext ?? self.bless( :$parsecontext ) !! Nil;
  }

  method copy {
    my $parsecontext = gst_parse_context_copy($!pc);

    $parsecontext ?? self.bless( :$parsecontext ) !! Nil;
  }

  method free {
    gst_parse_context_free($!pc);
  }

  method get_missing_elements is also<get-missing-elements> {
    gst_parse_context_get_missing_elements($!pc);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_parse_context_get_type, $n, $t );
  }

}
