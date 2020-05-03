use v6.c;

use GStreamer::Raw::Types;
use GStreamer::Raw::Memory;

use GStreamer::MiniObject;

our subset GstMemoryAncestry is export of Mu
  where GstMemory | GstMiniObject;

class GStreamer::Memory is GStreamer::MiniObject {
  has GstMemory $!m;

  submethod BUILD (:$memory) {
    self.setGstMemory($memory);
  }

  method setGstMemory (GstMemoryAncestry $_) {
    my $to-parent;

    $!m = do {
      when GstMemory {
        $to-parent = cast(GstMiniObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstMemory, $_);
      }
    }
    self.setMiniObject($to-parent);
  }

  method GStreamer::Raw::Structs::GstMemory
  { $!m }

  method new (GstMemoryAncestry $memory) {
    $memory ?? self.bless( :$memory ) !! Nil;
  }

  method new_wrapped (
    Int() $flags,
    gpointer $data,
    Int() $maxsize,
    Int() $offset,
    Int() $size,
    gpointer $user_data    = gpointer,
    GDestroyNotify $notify = gpointer
  ) {
    my GstMemoryFlags $fl = $flags;
    my gsize ($m, $o, $s) = ($maxsize, $offset, $size);
    my $memory =
      gst_memory_new_wrapped($fl, $data, $m, $o, $s, $user_data, $notify);

    $memory ?? self.bless( :$memory ) !! Nil;
  }

  method copy (Int() $offset, Int() $size, :$raw = False) {
    my gssize ($o, $s) = ($offset, $size);
    my $m = gst_memory_copy($!m, $o, $s);

    $m ??
      ( $raw ?? $m !! Gstreamer::Memory.new($m) )
      !!
      Nil;
  }

  method get_sizes (Int() $offset, Int() $maxsize) {
    my gsize ($o, $m) = 0 xx 2;
    my $size = gst_memory_get_sizes($!m, $o, $m);

    ($size, $offset = $o, $maxsize = $m);
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_memory_get_type, $n, $t );
  }

  method init (
    Int() $flags,
    GstAllocator() $allocator,
    GstMemory() $parent,
    Int() $maxsize,
    Int() $align,
    Int() $offset,
    Int() $size
  ) {
    my GstMemoryFlags $f = $flags;
    my gsize ($m, $a, $o, $s) = ($maxsize, $align, $offset, $size);

    gst_memory_init($!m, $f, $allocator, $parent, $m, $a, $o, $s);
  }

  method is_span (GstMemory() $mem2, Int() $offset) {
    my gsize $o = $offset;

    so gst_memory_is_span($!m, $mem2, $o);
  }

  method is_type (Str() $mem_type) {
    so gst_memory_is_type($!m, $mem_type);
  }

  method make_mapped (GstMapInfo() $info, Int() $flags, :$raw = False) {
    my GstMemoryFlags $f = $flags;
    my $m = gst_memory_make_mapped($!m, $info, $f);

    $m ??
      ( $raw ?? $m !! GStreamer::Memory.new($m) )
      !!
      Nil;
  }

  method map (GstMapInfo() $info, Int() $flags) {
    my GstMemoryFlags $f = $flags;

    so gst_memory_map($!m, $info, $f);
  }

  method resize (Int() $offset, Int() $size) {
    my gssize $o = $offset;
    my gsize $s = $size;

    gst_memory_resize($!m, $offset, $size);
  }

  method share (Int() $offset, Int() $size, :$raw = False) {
    my gssize $o = $offset;
    my gsize $s = $size;
    my $m = gst_memory_share($!m, $offset, $size);

    $m ??
      ( $raw ?? $m !! GStreamer::Memory.new($m) )
      !!
      Nil;
  }

  method unmap (GstMapInfo() $info) {
    gst_memory_unmap($!m, $info);
  }

}
