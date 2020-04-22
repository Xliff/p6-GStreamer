use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Base::QueueArray;

class GStreamer::Base::QueueArray {
  has GstQueueArray $!qa;

  submethod BUILD (:$queue-array) {
    $!qa = $queue-array;
  }

  method GStreamer::Raw::Definitions::GstQueueArray
  { $!qa }

  multi method new (Int() $initial_size) {
    my guint $i = $initial_size;
    my $queue-array = gst_queue_array_new($i);

    $queue-array ?? self.bless( :$queue-array ) !! Nil;
  }

  multi method new (
    Int() $struct_size,
    Int() $initial_size,
    :$struct is required
  ) {
    samewith($struct_size, $initial_size);
  }
  multi method new_for_struct (
    Int() $struct_size,
    Int() $initial_size
  )
    is also<new-for-struct>
  {
    my gsize $s = $struct_size;
    my guint $i = $initial_size;
    my $queue-array = gst_queue_array_new_for_struct($s, $i);

    $queue-array ?? self.bless( :$queue-array ) !! Nil;
  }

  method clear {
    gst_queue_array_clear($!qa);
  }

  method drop_element (Int() $idx) is also<drop-element> {
    my guint $i = $idx;

    gst_queue_array_drop_element($!qa, $i);
  }

  method drop_struct (Int() $idx, gpointer $p_struct) is also<drop-struct> {
    my guint $i = $idx;

    so gst_queue_array_drop_struct($!qa, $i, $p_struct);
  }

  multi method find (gpointer $data) {
    samewith(Callable, $data);
  }
  multi method find (&func, gpointer $data) {
    gst_queue_array_find($!qa, &func, $data);
  }

  method free {
    gst_queue_array_free($!qa);
  }

  method get_length
    is also<
      length
      elems
    >
  is also<get-length> {
    gst_queue_array_get_length($!qa);
  }

  method is_empty is also<is-empty> {
    so gst_queue_array_is_empty($!qa);
  }

  method peek_head is also<peek-head> {
    gst_queue_array_peek_head($!qa);
  }

  method peek_head_struct is also<peek-head-struct> {
    gst_queue_array_peek_head_struct($!qa);
  }

  method peek_nth (Int() $idx) is also<peek-nth> {
    my guint $i = $idx;

    gst_queue_array_peek_nth($!qa, $i);
  }

  method peek_nth_struct (Int() $idx) is also<peek-nth-struct> {
    my guint $i = $idx;

    gst_queue_array_peek_nth_struct($!qa, $idx);
  }

  method peek_tail is also<peek-tail> {
    gst_queue_array_peek_tail($!qa);
  }

  method peek_tail_struct is also<peek-tail-struct> {
    gst_queue_array_peek_tail_struct($!qa);
  }

  method pop_head is also<pop-head> {
    gst_queue_array_pop_head($!qa);
  }

  method pop_head_struct is also<pop-head-struct> {
    gst_queue_array_pop_head_struct($!qa);
  }

  method pop_tail is also<pop-tail> {
    gst_queue_array_pop_tail($!qa);
  }

  method pop_tail_struct is also<pop-tail-struct> {
    gst_queue_array_pop_tail_struct($!qa);
  }

  method push_tail (gpointer $data) is also<push-tail> {
    gst_queue_array_push_tail($!qa, $data);
  }

  method push_tail_struct (gpointer $p_struct) is also<push-tail-struct> {
    gst_queue_array_push_tail_struct($!qa, $p_struct);
  }

  method set_clear_func (GDestroyNotify $clear_func = gpointer)
    is also<set-clear-func>
  {
    gst_queue_array_set_clear_func($!qa, $clear_func);
  }

}
