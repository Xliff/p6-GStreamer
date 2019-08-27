use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GStreamer::Raw::Types;

unit package GStreamer::Raw::Iterator;

sub gst_iterator_copy (GstIterator $it)
  returns GstIterator
  is native(gstreamer)
  is export
{ * }

sub gst_iterator_filter (
  GstIterator $it,
  GCompareFunc $func,
  GValue $user_data
)
  returns GstIterator
  is native(gstreamer)
  is export
{ * }

sub gst_iterator_find_custom (
  GstIterator $it,
  GCompareFunc $func,
  GValue $elem,
  gpointer $user_data
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_iterator_fold (
  GstIterator $it,
  GstIteratorFoldFunction $func,
  GValue $ret,
  gpointer $user_data
)
  returns guint # GstIteratorResult
  is native(gstreamer)
  is export
{ * }

sub gst_iterator_foreach (
  GstIterator $it,
  GstIteratorForeachFunction $func,
  gpointer $user_data
)
  returns guint # GstIteratorResult
  is native(gstreamer)
  is export
{ * }

sub gst_iterator_free (GstIterator $it)
  is native(gstreamer)
  is export
{ * }

sub gst_iterator_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_iterator_new (
  guint $size,
  GType $type,
  GMutex $lock,
  guint32 $master_cookie,
  GstIteratorCopyFunction $copy,
  GstIteratorNextFunction $next,
  GstIteratorItemFunction $item,
  GstIteratorResyncFunction $resync,
  GstIteratorFreeFunction $free
)
  returns GstIterator
  is native(gstreamer)
  is export
{ * }

sub gst_iterator_new_list (
  GType $type,
  GMutex $lock,
  guint32 $master_cookie,
  GList $list,
  GObject $owner,
  GstIteratorItemFunction $item
)
  returns GstIterator
  is native(gstreamer)
  is export
{ * }

sub gst_iterator_new_single (GType $type, GValue $object)
  returns GstIterator
  is native(gstreamer)
  is export
{ * }

sub gst_iterator_next (GstIterator $it, GValue $elem)
  returns guint # GstIteratorResult
  is native(gstreamer)
  is export
{ * }

sub gst_iterator_push (GstIterator $it, GstIterator $other)
  is native(gstreamer)
  is export
{ * }

sub gst_iterator_resync (GstIterator $it)
  is native(gstreamer)
  is export
{ * }
