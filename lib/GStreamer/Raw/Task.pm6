use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Enums;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::Task;

### /usr/include/gstreamer-1.0/gst/gsttask.h

sub gst_task_cleanup_all ()
  is native(gstreamer-video)
  is export
{ * }

sub gst_task_get_pool (GstTask $task)
  returns GstTaskPool
  is native(gstreamer-video)
  is export
{ * }

sub gst_task_get_state (GstTask $task)
  returns GstTaskState
  is native(gstreamer-video)
  is export
{ * }

sub gst_task_get_type ()
  returns GType
  is native(gstreamer-video)
  is export
{ * }

sub gst_task_join (GstTask $task)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_task_new (
  GstTaskFunction $func,
  gpointer $user_data,
  GDestroyNotify $notify
)
  returns GstTask
  is native(gstreamer-video)
  is export
{ * }

sub gst_task_pause (GstTask $task)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_task_set_enter_callback (
  GstTask $task,
  &enter_func (GstTask, GThread, gpointer),
  gpointer $user_data,
  GDestroyNotify $notify
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_task_set_leave_callback (
  GstTask $task,
  &enter_func (GstTask, GThread, gpointer),
  gpointer $user_data,
  GDestroyNotify $notify
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_task_set_lock (GstTask $task, GRecMutex $mutex)
  is native(gstreamer-video)
  is export
{ * }

sub gst_task_set_pool (GstTask $task, GstTaskPool $pool)
  is native(gstreamer-video)
  is export
{ * }

sub gst_task_set_state (GstTask $task, GstTaskState $state)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_task_start (GstTask $task)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_task_stop (GstTask $task)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }
