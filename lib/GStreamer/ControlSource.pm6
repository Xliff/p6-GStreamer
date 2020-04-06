use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;

use GStreamer::Object;

our subset GstControlSourceAncestry is export of Mu
  where GstControlSource | GstObject;

class GStreamer::ControlSource is GStreamer::Object {
  has GstControlSource $!cs;

  submethod BUILD (:$control) {
    self.setControlSource($control);
  }

  method setControlSource(GstControlSourceAncestry $_) {
    my $to-parent;

    $!cs = do {
      when GstControlSource {
        $to-parent = cast(GstObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstControlSource, $_);
      }
    }
    self.setGstObject($to-parent);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_control_source_get_type, $n, $t );
  }

  proto method get_value (|)
      is also<get-value>
  { * }

  multi method get_value (Int() $timestamp) {
    my $rv = samewith($timestamp, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_value (Int() $timestamp, $value is rw, :$all = False) {
    my GstClockTime $t = $timestamp;
    my gdouble $v = 0e0;
    my $rv = so gst_control_source_get_value($!cs, $timestamp, $v);

    $value = $v;
    $all.not ?? $rv !! ($rv, $value);
  }

  proto method get_value_array (|)
      is also<get-value-array>
  { * }

  multi method get_value_array (
    Int() $timestamp,
    Int() $interval,
    Int() $n_values
  ) {
    my $rv = samewith($timestamp, $interval, $n_values, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_value_array (
    Int() $timestamp,
    Int() $interval,
    Int() $n_values,
    $values is rw,
    :$all = False
  ) {
    my GstClockTime ($t, $i) = ($timestamp, $interval);
    my guint $n = $n_values;

    my $v = CArray[gdouble].new;
    $v[0] = 0e0;

    my $rv = so gst_control_source_get_value_array($!cs, $t, $i, $n, $v);
    $values = $v;
    $all.not ?? $rv.so !! ($rv, $values);
  }

}

### /usr/include/gstreamer-1.0/gst/gstcontrolsource.h

sub gst_control_source_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_control_source_get_value (
  GstControlSource $self,
  GstClockTime $timestamp,
  gdouble $value
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_control_source_get_value_array (
  GstControlSource $self,
  GstClockTime $timestamp,
  GstClockTime $interval,
  guint $n_values,
  gdouble $values
)
  returns uint32
  is native(gstreamer)
  is export
{ * }
