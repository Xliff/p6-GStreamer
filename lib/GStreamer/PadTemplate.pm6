use v6.c;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::PadTemplate;

use GStreamer::Caps;
use GStreamer::Object;

our subset PadTemplateAncestry is export of Mu
  where GstPadTemplate | GstObject;

class GStreamer::PadTemplate is GStreamer::Object {
  has GstPadTemplate $!pt;

  submethod BUILD (:$template) {
    self.setPadTemplate($template);
  }

  method setPadTemplate (PadTemplateAncestry $_) {
    my $to-parent;

    $!pt = do {
      when GstPadTemplate {
        $to-parent = cast(GstObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstPadTemplate, $_);
      }
    }
    self.setGstObject($to-parent);
  }

  method GStreamer::Raw::Types::GstPadTemplate
  { $!pt }

  multi method new (GstPadTemplate $template) {
    self.bless( :$template );
  }
  multi method new (
    Str() $name,
    Int() $direction,
    Int() $presence,
    GstCaps() $caps
  ) {
    my GstPadDirection $d = $direction;
    my GstPadPresence $p = $presence;

    self.bless(
      template => gst_pad_template_new($name, $d, $p, $caps)
    );
  }

  method new_from_static_pad_template_with_gtype (
    GstStaticPadTemplate() $pad_template,
    Int() $pad_type
  ) {
    my GType $pt = $pad_type;

    self.bless(
      template => gst_pad_template_new_from_static_pad_template_with_gtype(
        $pad_template,
        $pt
      )
    );
  }

  method new_with_gtype (
    Str() $name,
    Int() $direction,
    Int() $presence,
    GstCaps() $caps,
    Int() $pad_type
  ) {
    my GstPadDirection $d = $direction;
    my GstPadPresence $p = $presence;
    my GType $pt = $pad_type;

    self.bless(
      template => gst_pad_template_new_with_gtype($name, $d, $p, $caps, $pt);
    );
  }

  method get_caps (:$raw = False) {
    my $c = gst_pad_template_get_caps($!pt);

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_pad_template_get_type, $n, $t );
  }

  method emit_pad_created (GstPad() $pad) {
    gst_pad_template_pad_created($!pt, $pad);
  }

}

class GStreamer::StaticPadTemplate {
  has GstStaticPadTemplate $!spt;

  submethod BUILD (:$static-template) {
    $!spt = $static-template;
  }

  method new (GstStaticPadTemplate $static-template) {
    self.bless( :$static-template );
  }

  method get (:$raw = False) {
    my $pt = gst_static_pad_template_get($!spt);

    $pt ??
      ( $raw ?? $pt !! GStreamer::PadTemplate.new($pt) )
      !!
      Nil;
  }

  method get_caps (:$raw = False) {
    my $c = gst_static_pad_template_get_caps($!spt);

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_static_pad_template_get_type, $n, $t );
  }

}
