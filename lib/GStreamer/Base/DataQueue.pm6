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
      default              { Cast(GstDataQueue, $_) }
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

    do gst_data_queue_drop_head($!bt, $t);
  }

  method flush {
    gst_data_queue_flush($!bt);
  }

  method get_level (GstDataQueueSize $level) is also<get-level> {
    gst_data_queue_get_level($!bt, $level);
  }

  method is_empty is also<is-empty> {
    so gst_data_queue_is_empty($!bt);
  }

  method is_full is also<is-full> {
    so gst_data_queue_is_full($!bt);
  }

  method limits_changed is also<limits-changed> {
    gst_data_queue_limits_changed($!bt);
  }

  method peek (GstDataQueueItem $item) {
    so gst_data_queue_peek($!bt, $item);
  }

  method pop (GstDataQueueItem $item) {
    so gst_data_queue_pop($!bt, $item);
  }

  method push (GstDataQueueItem $item) {
    so gst_data_queue_push($!bt, $item);
  }

  method push_force (GstDataQueueItem $item) is also<push-force> {
    so gst_data_queue_push_force($!bt, $item);
  }

  method set_flushing (Int() $flushing) is also<set-flushing> {
    my gboolean $f = $flushing.so.Int;

    gst_data_queue_set_flushing($!bt, $f);
  }

}
