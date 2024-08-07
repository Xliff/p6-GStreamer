use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;
use GStreamer::Raw::ChildProxy;

use GStreamer::Roles::Signals::ChildProxy;

role GStreamer::Roles::ChildProxy {
  also does GStreamer::Roles::Signals::ChildProxy;

  has GstChildProxy $!cp;

  method roleInit-ChildProxy {
    return if $!cp;

    my \i = findProperImplementor(self.^attributes);

    $!cp  = cast( GstChildProxy, i.get_value(self) );
  }

  method GStreamer::Raw::Definitions::GstChildProxy
    is also<GstChildProxy>
  { $!cp }

  # Is originally:
  # GstChildProxy, GObject, gchar, gpointer
  method child-added {
    self.connect-child-added($!cp, 'child-added');
  }

  # Is originally:
  # GstChildProxy, GObject, gchar, gpointer
  method child-removed {
    self.connect-child-removed($!cp, 'child-child-removed');
  }

  method emit_child_added (GObject() $child, Str() $name)
    is also<emit-child-added>
  {
    gst_child_proxy_child_added($!cp, $child, $name);
  }

  method emit_child_removed (GObject() $child, Str() $name)
    is also<emit-child-removed>
  {
    gst_child_proxy_child_removed($!cp, $child, $name);
  }

  method get_child_by_index (Int() $index) is also<get-child-by-index>
  {
    gst_child_proxy_get_child_by_index($!cp, $index);
  }

  method get_child_by_name (Str() $name) is also<get-child-by-name>
  {
    gst_child_proxy_get_child_by_name($!cp, $name);
  }

  method get_children_count
    is also<
      get-children-count
      children_count
      children-count
      elems
    >
  {
    gst_child_proxy_get_children_count($!cp);
  }

  method get_property (Str() $name, GValue() $value) is also<get-property> {
    gst_child_proxy_get_property($!cp, $name, $value);
  }

  method child_proxy_get_type(GStreamer::Roles::ChildProxy:U:)
    is also<child-proxy-get-type>
  {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_child_proxy_get_type, $n, $t );
  }

  method lookup (
    Str()                       $name,
    GObject()                   $target,
    CArray[Pointer[GParamSpec]] $pspec
  ) {
    gst_child_proxy_lookup($!cp, $name, $target, $pspec);
  }

  method set_property (Str() $name, GValue() $value) is also<set-property> {
    gst_child_proxy_set_property($!cp, $name, $value);
  }

}
