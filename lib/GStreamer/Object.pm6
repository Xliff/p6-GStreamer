use v6.c;

use Method::Also;
use NativeCall;

use GStreamer::Raw::Types;
use GStreamer::Raw::Object;

use GLib::Value;

use GLib::Roles::Object;

class GStreamer::Object {
  also does GLib::Roles::Object;

  has GstObject $!gst-o handles <flags>;

  submethod BUILD (:$object) {
    self.setGstObject($object) if $object;
  }

  multi method Numeric { $!gst-o.p }

  method setGstObject(GstObject $object) {
    self!setObject( cast(GObject, $!gst-o = $object) )
  }

  method GStreamer::Raw::Structs::GstObject
    is also<GstObject>
  { $!gst-o }

  multi method new (GstObject $object) {
    $object ?? self.bless( :$object ) !! Nil;
  }
  multi method new (|c) {
    my $dieMsg = qq:to/DIE/.chomp;
      GStreamer::Object.new will not take a signature of:
        { c.list.map( *.^name ).join(', ') }
      DIE

    die $dieMsg;
  }

  # Is originally:
  # GstObject, GstObject, GParamSpec, gpointer
  method deep-notify {
    self.connect-deep-notify($!gst-o);
  }

  method flag_set($f) { (self.flags +& $f).so }
  method flag-set($f) {  self.flag_set($f)    }

  method control_rate is rw is also<control-rate> {
    Proxy.new(
      FETCH => sub ($) {
        gst_object_get_control_rate($!gst-o);
      },
      STORE => sub ($, Int() $control_rate is copy) {
        my GstClockTime $c = $control_rate;

        gst_object_set_control_rate($!gst-o, $c);
      }
    );
  }

  method name is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_object_get_name($!gst-o);
      },
      STORE => sub ($, Str() $name is copy) {
        gst_object_set_name($!gst-o, $name);
      }
    );
  }

  method parent (:$raw = False) is rw {
    Proxy.new(
      FETCH => sub ($) {
        my $o = gst_object_get_parent($!gst-o);

        $o ??
          ( $raw ?? $o !! GStreamer::Object.new($o) )
          !!
          Nil;
      },
      STORE => sub ($, GstObject() $parent is copy) {
        gst_object_set_parent($!gst-o, $parent);
      }
    );
  }

  method add_control_binding (GstControlBinding() $binding)
    is also<add-control-binding>
  {
    gst_object_add_control_binding($!gst-o, $binding);
  }

  method check_uniqueness (GStreamer::Object:U:
    GList() $list,
    Str() $name
  )
    is also<check-uniqueness>
  {
    so gst_object_check_uniqueness($list, $name);
  }

  proto method default_deep_notify (|)
    is also<default-deep-notify>
  { * }

  multi method default_deep_notify (
    GStreamer::Object:U:

    GObject()   $obj,
    GstObject() $orig,
    GParamSpec  $pspec,
                @excluded_props
  ) {
    my $ep = CArray[Str].new;

    my $ne = @excluded_props.elems;

    $ep[$_]  = @excluded_props[$_] for ^$ne;
    $ep[$ne] = Str;
    samewith($obj, $orig, $pspec, $ep);
  }
  multi method default_deep_notify (
    GStreamer::Object:U:

    GObject()   $obj,
    GstObject() $orig,
    GParamSpec  $pspec,
    CArray[Str] $excluded_props
  ) {
    gst_object_default_deep_notify($obj, $orig, $pspec, $excluded_props);
  }

  method get_control_binding (Str() $property_name)
    is also<get-control-binding>
  {
    gst_object_get_control_binding($!gst-o, $property_name);
  }

  proto method get_g_value_array (|)
    is also<get-g-value-array>
  { * }

  multi method get_g_value_array (
    Str()  $property_name,
    Int()  $timestamp,
    Int()  $interval,
    Int()  $n_values,
          :$raw              = False
  ) {
    my $rv = callwith(
      $property_name,
      $timestamp,
      $interval,
      $n_values,
      @,
      :all,
      :$raw
    );

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_g_value_array (
    Str()  $property_name,
    Int()  $timestamp,
    Int()  $interval,
    Int()  $n_values,
           @values,
          :$all             = False,
          :$raw             = False
  ) {
    my GstClockTime ($ts, $in) = ($timestamp, $interval);
    my guint $n = $n_values;

    # CALLER ALLOCATES!
    my $v = GLib::Roles::TypedBuffer[GValue].new(size => $n);

    my $rv = so gst_object_get_g_value_array(
      $!gst-o,
      $property_name,
      $ts,
      $in,
      $n,
      $v
    );

    my @array = $v ??
      ( $raw ?? $v.Array !! $v.Array.map({ GLib::Value.new($_) }) )
      !!
      Nil;

    $all.not ?? $rv !! ($rv, @array)
  }

  method get_path_string is also<get-path-string> {
    gst_object_get_path_string($!gst-o);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_object_get_type, $n, $t );
  }

  proto method get_value (|)
    is also<get-value>
  { * }

  multi method get_value (Str() $property_name, Int() $timestamp) {
    my GstClockTime $t = $timestamp;

    gst_object_get_value($!gst-o, $property_name, $t);
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
  #     $!gst-o,
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
    so gst_object_has_active_control_bindings($!gst-o);
  }

  method has_as_ancestor (GstObject() $ancestor) is also<has-as-ancestor> {
    so gst_object_has_as_ancestor($!gst-o, $ancestor);
  }

  method has_as_parent (GstObject() $parent) is also<has-as-parent> {
    so gst_object_has_as_parent($!gst-o, $parent);
  }

  method ref is also<upref> {
    gst_object_ref($!gst-o);
    self;
  }

  method ref_sink is also<ref-sink> {
    gst_object_ref_sink($!gst-o);
    self;
  }

  method remove_control_binding (GstControlBinding() $binding)
    is also<remove-control-binding>
  {
    gst_object_remove_control_binding($!gst-o, $binding);
  }

  method replace (GstObject() $newobj) {
    gst_object_replace($!gst-o, $newobj);
  }

  method set_control_binding_disabled (
    Str() $property_name,
    Int() $disabled
  )
    is also<set-control-binding-disabled>
  {
    gst_object_set_control_binding_disabled($!gst-o, $property_name, $disabled);
  }

  method set_control_bindings_disabled (Int() $disabled)
    is also<set-control-bindings-disabled>
  {
    gst_object_set_control_bindings_disabled($!gst-o, $disabled);
  }

  method suggest_next_sync is also<suggest-next-sync> {
    gst_object_suggest_next_sync($!gst-o);
  }

  method sync_values (GstClockTime $timestamp) is also<sync-values> {
    gst_object_sync_values($!gst-o, $timestamp);
  }

  method unparent {
    gst_object_unparent($!gst-o);
  }

  method unref is also<downref> {
    gst_object_unref($!gst-o);
  }

}
