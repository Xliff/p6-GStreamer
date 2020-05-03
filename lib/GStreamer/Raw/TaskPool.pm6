use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::TaskPool;

### /usr/include/gstreamer-1.0/gst/gsttaskpool.h

sub gst_task_pool_cleanup (GstTaskPool $pool)
  is native(gstreamer-video)
  is export
{ * }

sub gst_task_pool_get_type ()
  returns GType
  is native(gstreamer-video)
  is export
{ * }

sub gst_task_pool_join (GstTaskPool $pool, gpointer $id)
  is native(gstreamer-video)
  is export
{ * }

sub gst_task_pool_new ()
  returns GstTaskPool
  is native(gstreamer-video)
  is export
{ * }

sub gst_task_pool_prepare (
  GstTaskPool $pool,
  CArray[Pointer[GError]] $error
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_task_pool_push (
  GstTaskPool $pool,
  &func (gpointer),
  gpointer $user_data,
  CArray[Pointer[GError]] $error
)
  returns Pointer
  is native(gstreamer-video)
  is export
{ * }
