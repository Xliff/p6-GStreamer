use v6.c;

use Method::Also;

use GStreamer::Raw::Types;

use GLib::Object::ParamSpec;

use GLib::Roles::StaticClass;

class GStreamer::ParamSpec is GLib::Object::ParamSpec {

  method value_spec is also<value-spec> {
    my \T := do given self.type {
      when GStreamer::ParamSpec::Array.get-type    { GstParamSpecArray    }
      when GStreamer::ParamSpec::Fraction.get-type { GstParamSpecFraction }
      default                                      { nextsame             }
    }

    cast(T, self.GParamSpec);
  }

}

class GStreamer::ParamSpec::Array {
  also does GLib::Roles::StaticClass;

  method array (
    Str() $nick,
    Str() $blurb,
    GParamSpec() $element_spec,
    GParamFlags $flags,
    :$raw = False
  ) {
    my GParamFlags $f = $flags;
    my $ps = gst_param_spec_array($nick, $blurb, $element_spec, $f);

    $ps ??
      ( $raw ?? $ps !! GLib::Object::ParamSpec.new($ps) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_param_spec_array_get_type, $n, $t );
  }

}

class GStreamer::ParamSpec::Fraction {

  method create (
    Str() $nick,
    Str() $blurb,
    Int() $min_num,
    Int() $min_denom,
    Int() $max_num,
    Int() $max_denom,
    Int() $default_num,
    Int() $default_denom,
    Int() $flags,
    :$raw = False
  ) {
    my GParamFlags $f = $flags;
    my gint ($mn, $md, $mxn, $mxd, $dn, $dd) = (
      $min_num,
      $min_denom,
      $max_num,
      $max_denom,
      $default_num,
      $default_denom
    );
    my $ps =
      gst_param_spec_fraction($nick, $blurb, $mn, $md, $mxn, $mxd, $dn, $dd);

    $ps ??
      ( $raw ?? $ps !! GLib::Object::ParamSpec.new($ps) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_param_spec_fraction_get_type, $n, $t)
  }
}

### /usr/include/gstreamer-1.0/gst/gstparamspecs.h

sub gst_param_spec_array (
  Str $name,
  Str $nick,
  Str $blurb,
  GParamSpec $element_spec,
  GParamFlags $flags
)
  returns GParamSpec
  is native(gstreamer)
  is export
{ * }

sub gst_param_spec_array_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_param_spec_fraction (
  Str $name,
  Str $nick,
  Str $blurb,
  gint $min_num,
  gint $min_denom,
  gint $max_num,
  gint $max_denom,
  gint $default_num,
  gint $default_denom,
  GParamFlags $flags
)
  returns GParamSpec
  is native(gstreamer)
  is export
{ * }

sub gst_param_spec_fraction_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }
