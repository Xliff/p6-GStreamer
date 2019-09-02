use v6.c;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::Allocator;

use GStreamer::Object;

our subset AllocatorAncestry is export of Mu
  where GstAllocator | GstObject;

class GStreamer::Allocator is GStreamer::Object {
  has GstAllocator $!a;

  submethod BUILD (:$allocator) {
    self.setAllocator($allocator);
  }

  method setAllocator (AllocatorAncestry $_) {
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

  method new (GstAllocator $allocator) {
    self.bless( :$allocator );
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

  method get_type {
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

  # Move this to GStreamer::Memory
  # method gst_memory_new_wrapped (gpointer $data, gsize $maxsize, gsize $offset, gsize $size, gpointer $user_data, GDestroyNotify $notify) {
  #   gst_memory_new_wrapped($!a, $data, $maxsize, $offset, $size, $user_data, $notify);
  # }

  method register (
    GStreamer::Allocator:U:
    Str() $name,
    GstAllocator() $allocator
  ) {
    gst_allocator_register($name, $allocator);
  }

  method set_default {
    gst_allocator_set_default($!a);
  }

}
