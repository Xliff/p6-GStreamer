use v6.c;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::Context;

use GStreamer::MiniObject;

use GStreamer::Structure;

class GStreamer::Context is GStreamer::MiniObject {
  has GstContext $!c;

  submethod BUILD (:$context) {
    self.setMiniObject( cast(GstMiniObject, $!c = $context) );
  }

  method GStreamer::Raw::Types::GstContext
  { $!c }

  method new (Str() $type, Int() $persistent) {
    my gboolean $p = $persistent;
    self.bless( context => gst_context_new($type, $p) );
  }

  # method copy {
  #   self.bless( query => GStreamer::MiniObject.copy($!c.GstMiniObject) );
  # }

  method get_context_type {
    GstContextEnum( gst_context_get_context_type($!c) );
  }

  method get_structure (:$raw = False) {
    my $s = gst_context_get_structure($!c);

    $raw ?? $s !! GStreamer::Structure.new($s);
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_context_get_type, $n, $t )
  }

  method has_context_type (Str() $context_type) {
    so gst_context_has_context_type($!c, $context_type);
  }

  method is_persistent {
    so gst_context_is_persistent($!c);
  }

  method writable_structure (:$raw = False) {
    my $e = gst_context_writable_structure($!c);

    $raw ?? $s !! GStreamer::Structure.new($e);
  }

}