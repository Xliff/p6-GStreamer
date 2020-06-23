use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::PadTemplate;

use GStreamer::Caps;
use GStreamer::Object;

use GStreamer::Roles::Signals::Generic;

our subset PadTemplateAncestry is export of Mu
  where GstPadTemplate | GstObject;

class GStreamer::PadTemplate is GStreamer::Object {
  also does GStreamer::Roles::Signals::Generic;

  has GstPadTemplate $!pt handles <
    name_template name-template
    abi_type      abi-type
    direction
    presence
  >;

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

  method GStreamer::Raw::Structs::GstPadTemplate
    is also<GstPadTemplate>
  { $!pt }

  multi method new (GstPadTemplate $template) {
    $template ?? self.bless( :$template ) !! Nil;
  }
  multi method new (
    Str() $name,
    Int() $direction,
    Int() $presence,
    GstCaps() $caps
  ) {
    my GstPadDirection $d = $direction;
    my GstPadPresence $p = $presence;
    my $template = gst_pad_template_new($name, $d, $p, $caps);

    $template ?? self.bless( :$template ) !! Nil;
  }

  method new_from_static_pad_template_with_gtype (
    GstStaticPadTemplate() $pad_template,
    Int() $pad_type
  )
    is also<new-from-static-pad-template-with-gtype>
  {
    my GType $pt = $pad_type;
    my $template = gst_pad_template_new_from_static_pad_template_with_gtype(
      $pad_template,
      $pt
    );

    $template ?? self.bless( :$template ) !! Nil;
  }

  method new_with_gtype (
    Str() $name,
    Int() $direction,
    Int() $presence,
    GstCaps() $caps,
    Int() $pad_type
  )
    is also<new-with-gtype>
  {
    my GstPadDirection $d = $direction;
    my GstPadPresence $p = $presence;
    my GType $pt = $pad_type;
    my $template = gst_pad_template_new_with_gtype($name, $d, $p, $caps, $pt);

    $template ?? self.bless( :$template ) !! Nil;
  }

  # Is originally:
  # GstPadTemplate, GstPad, gpointer
  method pad-created {
    self.connect-pad($!pt, 'pad-created');
  }

  method get_caps (:$raw = False)
    is also<
      get-caps
      caps
    >
  {
    my $c = gst_pad_template_get_caps($!pt);

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_pad_template_get_type, $n, $t );
  }

  method emit_pad_created (GstPad() $pad) is also<emit-pad-created> {
    gst_pad_template_pad_created($!pt, $pad);
  }

}

class GStreamer::StaticPadTemplate {
  has GstStaticPadTemplate $!spt handles <
    name_template  name-template
  >;

  submethod BUILD (:$static-template) {
    $!spt = $static-template;
  }

  method new (GstStaticPadTemplate $static-template) {
    $static-template ?? self.bless( :$static-template ) !! Nil;
  }

  method GStreamer::Raw::Structs::GstStaticPadTemplate
    is also<GstStaticPadTemplate>
  { $!spt }

  method direction {
    GstPadDirectionEnum( $!spt.direction );
  }

  method get (:$raw = False) {
    my $pt = gst_static_pad_template_get($!spt);

    $pt ??
      ( $raw ?? $pt !! GStreamer::PadTemplate.new($pt) )
      !!
      Nil;
  }

  method get_caps (:$raw = False) is also<get-caps> {
    my $c = gst_static_pad_template_get_caps($!spt);

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_static_pad_template_get_type, $n, $t );
  }

  method presence {
    GstPadPresenceEnum( $!spt.presence );
  }

  method static_caps (:$raw = False) is also<static-caps> {
    $raw ?? $!spt.static_caps
         !! GStreamer::StaticCaps.new($!spt.static_caps);
  }

}
