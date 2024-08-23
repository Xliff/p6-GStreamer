use v6.c;

use Method::Also;

use GStreamer::Raw::Types;

use GLib::Object::ParamSpec;


# cw: Due to be removed prior to 1.0 release. Still used in the Raku version of
#     gst-inspect, I believe.
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

class GStreamer::ParamSpec::Array is also GLib::Object::ParamSpec {
  has GstParamSpecArray $!gpsst is implementor;

  submethod BUILD ( :$sub-spec ) {
    self.setGParamSpec( cast(GParamSpec, $!gpsst = $sub-spec) ) if $sub-spec
  }

  method GStreamer::Raw::Structs::GstParamSpecArray
    is also<GstParamSpecArray>
  { $!gpsst }

  multi method new (GstParamSpecArray $sub-spec, :$ref = True) {
    return Nil unless $sub-spec;

    my $o = self.bless( :$sub-spec );
    $o.ref if $ref;
    $o;
  }
  multi method new (
    Str()         $nick,
    Str()         $blurb,
    GParamSpec()  $element_spec,
    Int()         $flags,
                 :$raw           = False
  )
    is also<create>
  {
    my GParamFlags $f = $flags;

    my $sub-spec = gst_param_spec_array($nick, $blurb, $element_spec, $f);

    $sub-spec ?? self.bless( :$sub-spec ) !! Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_param_spec_array_get_type, $n, $t );
  }

}

class GStreamer::ParamSpec::Fraction is GLib::Object::ParamSpec {
  has GstParamSpecFraction $!gpsst is implementor;

  method min_num is g-pseudo-property is also<min-num> { $!gpsst.min_num }
  method min_den is g-pseudo-property is also<min-den> { $!gpsst.min_den }
  method max_num is g-pseudo-property is also<max-num> { $!gpsst.max_num }
  method max_den is g-pseudo-property is also<max-den> { $!gpsst.max_den }
  method def_num is g-pseudo-property is also<def-num> { $!gpsst.def_num }
  method def_den is g-pseudo-property is also<def-den> { $!gpsst.def_den }

  submethod BUILD ( :$sub-spec ) {
    self.setGParamSpec( cast(GParamSpec, $!gpsst = $sub-spec) ) if $sub-spec
  }

  method GStreamer::Raw::Structs::GstParamSpecFraction
    is also<GstParamSpecFraction>
  { $!gpsst }

  multi method new (GstParamSpecFraction $sub-spec, :$ref = True) {
    return Nil unless $sub-spec;

    my $o = self.bless( :$sub-spec );
    $o.ref if $ref;
    $o;
  }
  multi method new (
    Str()  $nick,
    Str()  $blurb,
    Int()  $min_num,
    Int()  $min_denom,
    Int()  $max_num,
    Int()  $max_denom,
    Int()  $default_num,
    Int()  $default_denom,
    Int()  $flags,
          :$raw            = False
  )
    is also<create>
  {
    my GParamFlags $f = $flags;

    my gint ($mn, $md, $mxn, $mxd, $dn, $dd) = (
      $min_num,
      $min_denom,
      $max_num,
      $max_denom,
      $default_num,
      $default_denom
    );

    my $sub-spec = gst_param_spec_fraction(
      $nick,
      $blurb,
      $mn,
      $md,
      $mxn,
      $mxd,
      $dn,
      $dd
    );

    $sub-spec ?? self.bless( :$sub-spec ) !! $sub-spec
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_param_spec_fraction_get_type, $n, $t)
  }
}

INIT {
  GLib::Object::ParamSpec.registerParamSpec(
    GstParamFraction => sub ($o) {
      GStreamer::ParamSpec::Fraction.new(
        cast(GstParamFraction, $o.GParamSpec
      );
    }
  )
}

### /usr/include/gstreamer-1.0/gst/gstparamspecs.h

sub gst_param_spec_array (
  Str         $name,
  Str         $nick,
  Str         $blurb,
  GParamSpec  $element_spec,
  GParamFlags $flags
)
  returns GstParamSpecArray
  is      native(gstreamer)
  is      export
{ * }

sub gst_param_spec_array_get_type ()
  returns GType
  is      native(gstreamer)
  is      export
{ * }

sub gst_param_spec_fraction (
  Str         $name,
  Str         $nick,
  Str         $blurb,
  gint        $min_num,
  gint        $min_denom,
  gint        $max_num,
  gint        $max_denom,
  gint        $default_num,
  gint        $default_denom,
  GParamFlags $flags
)
  returns GstParamSpecFraction
  is      native(gstreamer)
  is      export
{ * }

sub gst_param_spec_fraction_get_type ()
  returns GType
  is      native(gstreamer)
  is      export
{ * }
