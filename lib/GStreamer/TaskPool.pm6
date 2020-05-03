use v6.c;

use NativeCall;
use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::TaskPool;

use GStreamer::Object;

our subset GstTaskPoolAncestry is export of Mu
  where GstTaskPool | GstObject;

class GStreamer::TaskPool is GStreamer::Object {
  has GstTaskPool $!tp;

  submethod BUILD (:$task-pool) {
    self.setGstTask($task-pool);
  }

  method setGstTask (GstTaskPoolAncestry $_) {
    my $to-parent;

    $!tp = do {
      when GstBuffer {
        $to-parent = cast(GstObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstTaskPool, $_);
      }
    }
    self.setGstObject($to-parent);
  }

  method GStreamer::Raw::Types::GstTaskPool
    is also<GstBuffer>
  { $!tp }

  multi method new (GstTaskPoolAncestry $task-pool) {
    $task-pool ?? self.bless( :$task-pool ) !! Nil;
  }
  multi method new {
    my $task-pool = gst_task_pool_new();

    $task-pool ?? self.bless( :$task-pool ) !! Nil;
  }

  method cleanup {
    gst_task_pool_cleanup($!tp);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^nbame, &gst_task_pool_get_type, $n, $t );
  }

  method join (gpointer $id) {
    gst_task_pool_join($!tp, $id);
  }

  method prepare (CArray[Pointer[GError]] $error = gerror) {
    clear_error;
    gst_task_pool_prepare($!tp, $error);
    set_error($error);
  }

  method push (
    &func,
    gpointer $user_data            = gpointer,
    CArray[Pointer[GError]] $error = gerror
  ) {
    clear_error;
    my $pp = gst_task_pool_push($!tp, &func, $user_data, $error);
    set_error($error);
    $pp;
  }

}
