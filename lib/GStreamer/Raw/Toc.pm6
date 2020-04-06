use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

unit package GStreamer::Raw::Toc;

sub gst_toc_append_entry (GstToc $toc, GstTocEntry $entry)
  is native(gstreamer)
  is export
{ * }

sub gst_toc_dump (GstToc $toc)
  is native(gstreamer)
  is export
{ * }

sub gst_toc_entry_append_sub_entry (GstTocEntry $entry, GstTocEntry $subentry)
  is native(gstreamer)
  is export
{ * }

sub gst_toc_entry_get_entry_type (GstTocEntry $entry)
  returns GstTocEntryType
  is native(gstreamer)
  is export
{ * }

sub gst_toc_entry_get_loop (
  GstTocEntry $entry,
  GstTocLoopType $loop_type,
  gint $repeat_count
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_toc_entry_get_parent (GstTocEntry $entry)
  returns GstTocEntry
  is native(gstreamer)
  is export
{ * }

sub gst_toc_entry_get_start_stop_times (
  GstTocEntry $entry,
  gint64 $start,
  gint64 $stop
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_toc_entry_get_sub_entries (GstTocEntry $entry)
  returns GList
  is native(gstreamer)
  is export
{ * }

sub gst_toc_entry_get_tags (GstTocEntry $entry)
  returns GstTagList
  is native(gstreamer)
  is export
{ * }

sub gst_toc_entry_get_toc (GstTocEntry $entry)
  returns GstToc
  is native(gstreamer)
  is export
{ * }

sub gst_toc_entry_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_toc_entry_get_uid (GstTocEntry $entry)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_toc_entry_is_alternative (GstTocEntry $entry)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_toc_entry_is_sequence (GstTocEntry $entry)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_toc_entry_merge_tags (
  GstTocEntry $entry,
  GstTagList $tags,
  GstTagMergeMode $mode
)
  is native(gstreamer)
  is export
{ * }

sub gst_toc_entry_new (GstTocEntryType $type, Str $uid)
  returns GstTocEntry
  is native(gstreamer)
  is export
{ * }

sub gst_toc_entry_set_loop (
  GstTocEntry $entry,
  GstTocLoopType $loop_type,
  gint $repeat_count
)
  is native(gstreamer)
  is export
{ * }

sub gst_toc_entry_set_start_stop_times (
  GstTocEntry $entry,
  gint64 $start,
  gint64 $stop
)
  is native(gstreamer)
  is export
{ * }

sub gst_toc_entry_set_tags (GstTocEntry $entry, GstTagList $tags)
  is native(gstreamer)
  is export
{ * }

sub gst_toc_entry_type_get_nick (GstTocEntryType $type)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_toc_find_entry (GstToc $toc, Str $uid)
  returns GstTocEntry
  is native(gstreamer)
  is export
{ * }

sub gst_toc_get_entries (GstToc $toc)
  returns GList
  is native(gstreamer)
  is export
{ * }

sub gst_toc_get_scope (GstToc $toc)
  returns GstTocScope
  is native(gstreamer)
  is export
{ * }

sub gst_toc_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_toc_merge_tags (GstToc $toc, GstTagList $tags, GstTagMergeMode $mode)
  is native(gstreamer)
  is export
{ * }

sub gst_toc_new (GstTocScope $scope)
  returns GstToc
  is native(gstreamer)
  is export
{ * }

sub gst_toc_get_tags (GstToc $toc)
  returns GstTagList
  is native(gstreamer)
  is export
{ * }

sub gst_toc_set_tags (GstToc $toc, GstTagList $tags)
  is native(gstreamer)
  is export
{ * }
