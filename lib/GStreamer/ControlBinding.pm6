use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::ControlBinding;

use GLib::Value;
use GStreamer::Object;

use GLib::Roles::TypedBuffer;

our subset GstControlBindingAncestry is export of Mu
  where GstControlBinding | GstObject;

class GStreamer::ControlBinding is GStreamer::Object {
  has GstControlBinding $!cb;

  submethod BUILD (:$control-binding) {
    self.setGstControlBinding($control-binding) if $control-binding;
  }

  method setGstControlBinding (GstControlBindingAncestry $_) {
    my $to-parent;

    $!cb = do {
      when GstControlBinding {
        $to-parent = cast(GstObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstControlBinding, $_);
      }
    }
    self.setGstObject($to-parent);
  }

  method GStreamer::Raw::Structs::GstControlBinding
    is also<GstControlBinding>
  { $!cb }

  multi method new (GstControlBindingAncestry $control-binding) {
    $control-binding ?? self.bless( :$control-binding ) !! Nil;
  }

  # Type: gchar
  method name is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('name', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv = GLib::Value.new( G_TYPE_STRING );
        $gv.string = $val;
        self.prop_set('name', $gv);
      }
    );
  }

  # Type: GstObject
  method object (:$raw = False) is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('object', $gv)
        );

        my $go = cast(GstObject, $gv.object);
        return Nil unless $go;
        $go = GStreamer::Object.new($go) unless $raw;
        $go;
      },
      STORE => -> $, GstObject() $val is copy {
        $gv = GLib::Value.new( GStreamer::Object.get_type );
        $gv.object = $val;
        self.prop_set('object', $gv);
      }
    );
  }

  proto method get_g_value_array (|)
      is also<get-g-value-array>
  { * }

  multi method get_g_value_array (
    Int() $timestamp,
    Int() $interval,
    @values
  ) {
    @values = @values.map({
      my $v = $_;
      die '@values must only contain GValue-compatible entries!'
        unless $v ~~ (GLib::Value, GValue).any;
      $v .= GValue if $v ~~ GLib::Value;
      $v
    });

    my $v = GLib::Roles::TypedBuffer[GValue].new(@values);
    samewith($timestamp, $interval, @values.elems, $v.p)
  }
  multi method get_g_value_array (
    Int() $timestamp,
    Int() $interval,
    Int() $n_values,
    Buf() $values
  ) {
    samewith( $timestamp, $interval, $n_values, cast(gpointer, $values) )
  }
  multi method get_g_value_array (
    Int() $timestamp,
    Int() $interval,
    Int() $n_values,
    gpointer $values
  ) {
    my GstClockTime ($t, $i) = ($timestamp, $interval);
    my guint $n = $n_values;

    so gst_control_binding_get_g_value_array($!cb, $t, $i, $n, $values);
  }

  method get_value (Int() $timestamp, :$raw = False) is also<get-value> {
    my GstClockTime $t = $timestamp;
    my $v = gst_control_binding_get_value($!cb, $timestamp);

    $v ??
      ( $raw ?? $v !! GLib::Value.new($v) )
      !!
      Nil;
  }

  proto method get_value_array (|)
    is also<get-value-array>
  { * }

  multi method get_value_array (
    Int() $timestamp,
    Int() $interval,
    Int() $n_values,
    Buf() $values
  ) {
    samewith( $timestamp, $interval, $n_values, cast(gpointer, $values) )
  }
  multi method get_value_array (
    Int() $timestamp,
    Int() $interval,
    Int() $n_values,
    gpointer $values
  ) {
    my GstClockTime ($t, $i) = ($timestamp, $interval);
    my guint $n = $n_values;

    so gst_control_binding_get_value_array(
      $!cb,
      $timestamp,
      $interval,
      $n,
      $values
    );
  }

  method is_disabled is also<is-disabled> {
    so gst_control_binding_is_disabled($!cb);
  }

  method set_disabled (Int() $disabled) is also<set-disabled> {
    my gboolean $d = $disabled.so.Int;

    gst_control_binding_set_disabled($!cb, $disabled);
  }

  method sync_values (
    GstObject() $object,
    GstClockTime $timestamp,
    GstClockTime $last_sync
  )
    is also<sync-values>
  {
    my GstClockTime ($t, $l) = ($timestamp, $last_sync);

    so gst_control_binding_sync_values($!cb, $object, $t, $l);
  }

}
