use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

unit package GStreamer::Raw::MiniObject;

sub gst_mini_object_add_parent (GstMiniObject $object, GstMiniObject $parent)
  is native(gstreamer)
  is export
{ * }

sub gst_mini_object_get_qdata (GstMiniObject $object, GQuark $quark)
  returns Pointer
  is native(gstreamer)
  is export
{ * }

sub gst_clear_mini_object (GstMiniObject $object_ptr)
  is native(gstreamer)
  is export
{ * }

sub gst_mini_object_init (
  GstMiniObject $mini_object,
  guint $flags,
  GType $type,
  GstMiniObjectCopyFunction $copy_func,
  GstMiniObjectDisposeFunction $dispose_func,
  GstMiniObjectFreeFunction $free_func
)
  is native(gstreamer)
  is export
{ * }

sub gst_mini_object_is_writable (GstMiniObject $mini_object)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_mini_object_lock (GstMiniObject $object, GstLockFlags $flags)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_mini_object_make_writable (GstMiniObject $mini_object)
  returns GstMiniObject
  is native(gstreamer)
  is export
{ * }

sub gst_mini_object_ref (GstMiniObject $mini_object)
  returns GstMiniObject
  is native(gstreamer)
  is export
{ * }

sub gst_mini_object_remove_parent (
  GstMiniObject $object,
  GstMiniObject $parent
)
  is native(gstreamer)
  is export
{ * }

sub gst_mini_object_replace (GstMiniObject $olddata, GstMiniObject $newdata)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_mini_object_set_qdata (
  GstMiniObject $object,
  GQuark $quark,
  gpointer $data,
  GDestroyNotify $destroy
)
  is native(gstreamer)
  is export
{ * }

sub gst_mini_object_steal (GstMiniObject $olddata)
  returns GstMiniObject
  is native(gstreamer)
  is export
{ * }

sub gst_mini_object_steal_qdata (GstMiniObject $object, GQuark $quark)
  returns Pointer
  is native(gstreamer)
  is export
{ * }

sub gst_mini_object_take (GstMiniObject $olddata, GstMiniObject $newdata)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_mini_object_unlock (GstMiniObject $object, GstLockFlags $flags)
  is native(gstreamer)
  is export
{ * }

sub gst_mini_object_unref (GstMiniObject $mini_object)
  is native(gstreamer)
  is export
{ * }

sub gst_mini_object_weak_ref (
  GstMiniObject $object,
  GstMiniObjectNotify $notify,
  gpointer $data
)
  is native(gstreamer)
  is export
{ * }

sub gst_mini_object_weak_unref (
  GstMiniObject $object,
  GstMiniObjectNotify $notify,
  gpointer $data
)
  is native(gstreamer)
  is export
{ * }

sub gst_mini_object_copy (GstMiniObject $mini-object)
  returns GstMiniObject
  is native(gstreamer)
  is export
{ * }
