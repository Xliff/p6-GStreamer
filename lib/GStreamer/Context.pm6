use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Context;

use GStreamer::MiniObject;

use GStreamer::Structure;

class GStreamer::Context is GStreamer::MiniObject {
  has GstContext $!c;

  submethod BUILD (:$context) {
    self.setMiniObject( cast(GstMiniObject, $!c = $context) );
  }

  method GStreamer::Raw::Definitions::GstContext
    is also<GstContext>
  { $!c }

  multi method new (GstContext $context) {
    $context ?? self.bless( :$context ) !! Nil;
  }
  multi method new (Str() $type, Int() $persistent) {
    my gboolean $p = $persistent;
    my $context = gst_context_new($type, $p);

    $context ?? self.bless( :$context ) !! Nil;
  }

  # method copy {
  #   self.bless( query => GStreamer::MiniObject.copy($!c.GstMiniObject) );
  # }

  method get_context_type is also<get-context-type> {
    gst_context_get_context_type($!c);
  }

  method get_structure (:$raw = False) is also<get-structure> {
    my $s = gst_context_get_structure($!c);

    $s ??
      ( $raw ?? $s !! GStreamer::Structure.new($s) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_context_get_type, $n, $t )
  }

  method has_context_type (Str() $context_type) is also<has-context-type> {
    so gst_context_has_context_type($!c, $context_type);
  }

  method is_persistent is also<is-persistent> {
    so gst_context_is_persistent($!c);
  }

  method writable_structure (:$raw = False) is also<writable-structure> {
    my $e = gst_context_writable_structure($!c);

    $e ??
      ( $raw ?? $e !! GStreamer::Structure.new($e) )
      !!
      Nil;
  }

}
