use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Base::DataQueue;

use GLib::Roles::Object;

our subset GstDataQueueAncestry is export of Mu
  where GstDataQueue | GObject;

class GStreamer::Base::DataQueue {
  also does GLib::Roles::Object;

  has GstDataQueue $!dq is implementor;

  submethod BUILD (:$queue) {
    self.setGstDataQueue($queue);
  }

  method setGstDataQueue (GstDataQueueAncestry $_) {
    my $to-parent;

    $!dq = do {
      when    GstDataQueue { $_ }
      default              { cast(GstDataQueue, $_) }
    }

    self.roleInit-Object;
  }

  method GStreamer::Raw::Definitions::GstDataQueue
    is also<GstDataQueue>
  { * }

  method new (
    &checkfull,
    &fullcallback,
    &emptycallback,
    gpointer $checkdata = gpointer
  ) {
    my $queue = gst_data_queue_new(
      &checkfull,
      &fullcallback,
      &emptycallback,
      $checkdata
    );

    $queue ?? self.bless( :$queue ) !! Nil;
  }

  method drop_head (Int() $type) is also<drop-head> {
    my GType $t = $type;

    do gst_data_queue_drop_head($!dq, $t);
  }

  method flush {
    gst_data_queue_flush($!dq);
  }

  method get_level (GstDataQueueSize $level) is also<get-level> {
    gst_data_queue_get_level($!dq, $level);
  }

  method is_empty is also<is-empty> {
    so gst_data_queue_is_empty($!dq);
  }

  method is_full is also<is-full> {
    so gst_data_queue_is_full($!dq);
  }

  method limits_changed is also<limits-changed> {
    gst_data_queue_limits_changed($!dq);
  }

  method peek (GstDataQueueItem $item) {
    so gst_data_queue_peek($!dq, $item);
  }

  method pop (GstDataQueueItem $item) {
    so gst_data_queue_pop($!dq, $item);
  }

  method push (GstDataQueueItem $item) {
    so gst_data_queue_push($!dq, $item);
  }

  method push_force (GstDataQueueItem $item) is also<push-force> {
    so gst_data_queue_push_force($!dq, $item);
  }

  method set_flushing (Int() $flushing) is also<set-flushing> {
    my gboolean $f = $flushing.so.Int;

    gst_data_queue_set_flushing($!dq, $f);
  }

}
