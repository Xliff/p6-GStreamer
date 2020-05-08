use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Task;

use GStreamer::Object;
use GStreamer::TaskPool;

our subset GstTaskAncestry is export of Mu
  where GstTask | GstObject;

class GStreamer::Task is GStreamer::Object {
  has GstTask $!t;

  submethod BUILD (:$task) {
    self.setGstTask($task);
  }

  method setGstTask (GstTaskAncestry $_) {
    my $to-parent;

    $!t = do {
      when GstBuffer {
        $to-parent = cast(GstObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstTask, $_);
      }
    }
    self.setGstObject($to-parent);
  }

  method GStreamer::Raw::Types::GstTask
    is also<GstBuffer>
  { $!t }

  multi method new (GstTaskAncestry $task) {
    $task ?? self.bless( :$task ) !! Nil;
  }
  multi method new (&func, gpointer $user_data, GDestroyNotify $notify) {
    my $task = gst_task_new(&func, $user_data, $notify);

    $task ?? self.bless( :$task ) !! Nil;
  }

  method cleanup_all (GStreamer::Task:U:)
    is also<cleanup-all>
  {
    gst_task_cleanup_all();
  }

  method get_pool (:$raw = False) is also<get-pool> {
    my $tp = gst_task_get_pool($!t);

    $tp ??
      ( $raw ?? $tp !! GStreamer::TaskPool.new($tp) )
      !!
      Nil;
  }

  method get_state is also<get-state> {
    GstTaskState( gst_task_get_state($!t) );
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_task_get_type, $n, $t );
  }

  method join {
    so gst_task_join($!t);
  }

  method pause {
    so gst_task_pause($!t);
  }

  method set_enter_callback (
    &enter_func,
    gpointer $user_data    = gpointer,
    GDestroyNotify $notify = gpointer
  )
    is also<set-enter-callback>
  {
    gst_task_set_enter_callback($!t, &enter_func, $user_data, $notify);
  }

  method set_leave_callback (
    &leave_func,
    gpointer $user_data,
    GDestroyNotify $notify
  )
    is also<set-leave-callback>
  {
    gst_task_set_leave_callback($!t, &leave_func, $user_data, $notify);
  }

  method set_lock (GRecMutex() $mutex) is also<set-lock> {
    gst_task_set_lock($!t, $mutex);
  }

  method set_pool (GstTaskPool() $pool) is also<set-pool> {
    gst_task_set_pool($!t, $pool);
  }

  method set_state (GstTaskState $state) is also<set-state> {
    my GstTaskState $s = $state;

    warn 'No lock set! Will always return false.' if $DEBUG && $!t.getLock;

    so gst_task_set_state($!t, $state);
  }

  method start {
    so gst_task_start($!t);
  }

  method stop {
    so gst_task_stop($!t);
  }

}
