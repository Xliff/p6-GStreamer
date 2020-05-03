use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Allocator;

use GStreamer::Object;

our subset GstAllocatorAncestry is export of Mu
  where GstAllocator | GstObject;

class GStreamer::Allocator is GStreamer::Object {
  has GstAllocator $!a;

  submethod BUILD (:$allocator) {
    self.setAllocator($allocator);
  }

  method setAllocator (GstAllocatorAncestry $_) {
    my $to-parent;

    $!a = do {
      when GstAllocator {
        $to-parent = cast(GstObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstAllocator, $_);
      }
    };
    self.setGstObject($to-parent);
  }

  method GStreamer::Raw::Structs::GstAllocator
    is also<GstAllocator>
  { $!a }

  method new (GstAllocatorAncestry $allocator) {
    $allocator ?? self.bless( :$allocator ) !! Nil;
  }

  method alloc (Int() $size, gpointer $params, :$raw = False) {
    my gsize $s = $size;
    my $m = gst_allocator_alloc($!a, $s, $params);

    $m ??
      ( $raw ?? $m !! GStreamer::Memory.new($m) )
      !!
      Nil;
  }

  method find (GStreamer::Allocator:U: Str() $name, :$raw = False) {
    my $a = gst_allocator_find($name);

    $a ??
      ( $raw ?? $a !! GStreamer::Allocator.new($a) )
      !!
      Nil;
  }

  method free (GstMemory() $memory) {
    gst_allocator_free($!a, $memory);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_allocator_get_type, $n, $t );
  }

  # Move this to GStreamer::AllocationParams
  # method gst_allocation_params_copy () {
  #   gst_allocation_params_copy($!a);
  # }
  #
  # method gst_allocation_params_free () {
  #   gst_allocation_params_free($!a);
  # }
  #
  # method gst_allocation_params_get_type () {
  #   gst_allocation_params_get_type();
  # }
  #
  # method gst_allocation_params_init () {
  #   gst_allocation_params_init($!a);
  # }

  method register (
    GStreamer::Allocator:U:
    Str() $name,
    GstAllocator() $allocator
  ) {
    gst_allocator_register($name, $allocator);
  }

  method set_default is also<set-default> {
    gst_allocator_set_default($!a);
  }

}
