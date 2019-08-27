use v6.c;

use Method::Also;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::Object;

use GTK::Raw::Utils;

use GTK::Roles::Properties;

class GStreamer::Object {
  also does GTK::Roles::Properties;

  has GstObject $!o;

  submethod BUILD (:$object) {
    self.setGstObject($object) if $object;
  }

  method setGstObject(GstObject $object) {
    $!prop = cast(GObject, $!o = $object);    # GTK::Roles::Properties
  }

  method GStreamer::Raw::Types::GstObject
    is also<GstObject>
  { $!o }

  multi method new (GstObject $object) {
    self.bless( :$object );
  }
  multi method new (|c) {
    my $dieMsg = qq:to/DIE/.chomp;
      GStreamer::Object.new will not take a signature of:
        { c.list.map( *.^name ).join(', ') }
      DIE

    die $dieMsg;
  }

  method control_rate is rw is also<control-rate> {
    Proxy.new(
      FETCH => sub ($) {
        gst_object_get_control_rate($!o);
      },
      STORE => sub ($, $control_rate is copy) {
        gst_object_set_control_rate($!o, $control_rate);
      }
    );
  }

  method name is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_object_get_name($!o);
      },
      STORE => sub ($, Str() $name is copy) {
        gst_object_set_name($!o, $name);
      }
    );
  }

  method parent (:$raw = False) is rw {
    Proxy.new(
      FETCH => sub ($) {
        my $o = gst_object_get_parent($!o);

        $o ??
          ( $raw ?? $o !! GStreamer::Object.new($o) )
          !!
          Nil;
      },
      STORE => sub ($, GstObject() $parent is copy) {
        gst_object_set_parent($!o, $parent);
      }
    );
  }

  method add_control_binding (GstControlBinding() $binding)
    is also<add-control-binding>
  {
    gst_object_add_control_binding($!o, $binding);
  }

  method check_uniqueness (Str() $name) is also<check-uniqueness> {
    gst_object_check_uniqueness($!o, $name);
  }

  method default_deep_notify (
    GstObject() $orig,
    GParamSpec $pspec,
    Str() $excluded_props
  )
    is also<default-deep-notify>
  {
    gst_object_default_deep_notify($!o, $orig, $pspec, $excluded_props);
  }

  method get_control_binding (Str() $property_name)
    is also<get-control-binding>
  {
    gst_object_get_control_binding($!o, $property_name);
  }

  method get_g_value_array (
    Str() $property_name,
    GstClockTime $timestamp,
    GstClockTime $interval,
    guint $n_values,
    gpointer $values,
    :$raw = False
  )
    is also<get-g-value-array>
  {
    gst_object_get_g_value_array(
      $!o,
      $property_name,
      $timestamp,
      $interval,
      $n_values,
      $values
    );
    my $v = $values but GTK::Compat::Roles::TypedBuffer[GValue].new(
      size => $n_values
    );

    $v ??
      ( $raw ?? $v.Array !! $v.Array.map({ GTK::Compat::Value.new($_) }) )
      !!
      Nil;
  }

  method get_path_string is also<get-path-string> {
    gst_object_get_path_string($!o);
  }

  method get_type is also<get-type> {
    state ($n, $t);
    unstable_get_type( self.^name, &gst_object_get_type, $n, $t );
  }

  method get_value (Str() $property_name, GstClockTime $timestamp)
    is also<get-value>
  {
    gst_object_get_value($!o, $property_name, $timestamp);
  }

  # This method is probably better left to C!
  # method get_value_array (
  #   Str() $property_name,
  #   GstClockTime $timestamp,
  #   GstClockTime $interval,
  #   guint $n_values,
  #   gpointer $values
  # )
  #   is also<get-value-array>
  # {
  #   gst_object_get_value_array(
  #     $!o,
  #     $property_name,
  #     $timestamp,
  #     $interval,
  #     $n_values,
  #     $values
  #   );
  # }

  method clear_object (
    GStreamer::Object:U:
    GstObject $obj
  )
    is also<clear-object>
  {
    gst_clear_object($obj);
  }

  method has_active_control_bindings is also<has-active-control-bindings> {
    so gst_object_has_active_control_bindings($!o);
  }

  method has_as_ancestor (GstObject() $ancestor) is also<has-as-ancestor> {
    so gst_object_has_as_ancestor($!o, $ancestor);
  }

  method has_as_parent (GstObject() $parent) is also<has-as-parent> {
    so gst_object_has_as_parent($!o, $parent);
  }

  method ref {
    gst_object_ref($!o);
    self;
  }

  method ref_sink is also<ref-sink> {
    gst_object_ref_sink($!o);
    self;
  }

  method remove_control_binding (GstControlBinding() $binding)
    is also<remove-control-binding>
  {
    gst_object_remove_control_binding($!o, $binding);
  }

  method replace (GstObject() $newobj) {
    gst_object_replace($!o, $newobj);
  }

  method set_control_binding_disabled (
    Str() $property_name,
    Int() $disabled
  )
    is also<set-control-binding-disabled>
  {
    gst_object_set_control_binding_disabled($!o, $property_name, $disabled);
  }

  method set_control_bindings_disabled (Int() $disabled)
    is also<set-control-bindings-disabled>
  {
    gst_object_set_control_bindings_disabled($!o, $disabled);
  }

  method suggest_next_sync is also<suggest-next-sync> {
    gst_object_suggest_next_sync($!o);
  }

  method sync_values (GstClockTime $timestamp) is also<sync-values> {
    gst_object_sync_values($!o, $timestamp);
  }

  method unparent {
    gst_object_unparent($!o);
  }

  method unref {
    gst_object_unref($!o);
  }

}
