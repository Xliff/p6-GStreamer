use v6.c;

use NativeCall;
use Method::Also;

use GLib::Class::Object;
use GStreamer::Raw::Types;

use GLib::Roles::Pointers;

class GstObjectClass is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS GObjectClass  $.parent_class;             #= GInitiallyUnowned
  has Str           $.path_string_separator;
  has Pointer       $.deep_notify;              #= void          (*deep_notify)      (GstObject * object, GstObject * orig, GParamSpec * pspec);
  HAS GstPadding    $!padding;
}

our subset GstObjectClassAncestry is export of Mu
  where GstObjectClass | GObjectClass;

class GStreamer::Class::Object is GLib::Class::Object {
  has GstObjectClass $!goc is implementor;

  submethod BUILD (:$gst-object-class) {
    self.setGstObjectClass($gst-object-class) if $gst-object-class
  }

  method GStreamer::Class::Object::GstObjectClass
    is also<GstObjectClass>
  { $!goc }

  method setGstObjectClass (GstObjectClassAncestry $_) {
    my $to-parent;

    $!goc = do {
      when GstObjectClass {
        $to-parent = cast(GObjectClass, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstObjectClass, $_);
      }
    }
    self.setObjectClass($to-parent);
  }

  method new (GstObjectClassAncestry $gst-object-class) {
    $gst-object-class ?? self.bless( :$gst-object-class ) !! Nil;
  }

}
