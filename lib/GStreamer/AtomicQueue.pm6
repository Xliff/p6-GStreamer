use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::AtomicQueue;

# BOXED

class GStreamer::AtomicQueue {
  has GstAtomicQueue $!aq;

  submethod BUILD (:$queue) {
    $!aq = $queue;
  }

  method GStreamer::Raw::Definitions::GstAtomicQueue
    is also<GstAtomicQueue>
  { $!aq }

  method new (Int() $size) {
    my guint $s = $size;
    my $queue = gst_atomic_queue_new($s);

    $queue ?? self.bless( :$queue ) !! Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_atomic_queue_get_type, $n, $t );
  }

  method length {
    gst_atomic_queue_length($!aq);
  }

  method peek {
    gst_atomic_queue_peek($!aq);
  }

  method pop {
    gst_atomic_queue_pop($!aq);
  }

  method push (gpointer $data) {
    gst_atomic_queue_push($!aq, $data);
  }

  method ref is also<upref> {
    gst_atomic_queue_ref($!aq);
    self;
  }

  method unref is also<downref> {
    gst_atomic_queue_unref($!aq);
  }

}
