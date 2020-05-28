use v6.c;

use NativeCall;

use GLib::Object::Class::Object;
use GStreamer::Raw::Types;

use GLib::Roles::Pointers;

class GstObjectClass is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS GObjectClass  $.parent_class;             #= GInitiallyUnowned
  has Str           $.path_string_separator;
  has Pointer       $.deep_notify;              #= void          (*deep_notify)      (GstObject * object, GstObject * orig, GParamSpec * pspec);
  HAS GstPadding    $!padding;
}
