use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Enums;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::Base::CollectPads;

### /usr/include/gstreamer-1.0/gst/base/gstcollectpads.h

sub gst_collect_pads_add_pad (
  GstCollectPads $pads,
  GstPad $pad,
  guint $size,
  Pointer $destroy_notify, # GstCollectDataDestroyNotify
  gboolean $lock
)
  returns GstCollectData
  is native(gstreamer-base)
  is export
{ * }

sub gst_collect_pads_available (GstCollectPads $pads)
  returns guint
  is native(gstreamer-base)
  is export
{ * }

sub gst_collect_pads_clip_running_time (
  GstCollectPads $pads,
  GstCollectData $cdata,
  GstBuffer $buf,
  CArray[Pointer[GstBuffer]] $outbuf,
  gpointer $user_data
)
  returns GstFlowReturn
  is native(gstreamer-base)
  is export
{ * }

sub gst_collect_pads_event_default (
  GstCollectPads $pads,
  GstCollectData $data,
  GstEvent $event,
  gboolean $discard
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_collect_pads_flush (
  GstCollectPads $pads,
  GstCollectData $data,
  guint $size
)
  returns guint
  is native(gstreamer-base)
  is export
{ * }

sub gst_collect_pads_get_type ()
  returns GType
  is native(gstreamer-base)
  is export
{ * }

sub gst_collect_pads_new ()
  returns GstCollectPads
  is native(gstreamer-base)
  is export
{ * }

sub gst_collect_pads_peek (GstCollectPads $pads, GstCollectData $data)
  returns GstBuffer
  is native(gstreamer-base)
  is export
{ * }

sub gst_collect_pads_pop (GstCollectPads $pads, GstCollectData $data)
  returns GstBuffer
  is native(gstreamer-base)
  is export
{ * }

sub gst_collect_pads_query_default (
  GstCollectPads $pads,
  GstCollectData $data,
  GstQuery $query,
  gboolean $discard
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_collect_pads_read_buffer (
  GstCollectPads $pads,
  GstCollectData $data,
  guint $size
)
  returns GstBuffer
  is native(gstreamer-base)
  is export
{ * }

sub gst_collect_pads_remove_pad (GstCollectPads $pads, GstPad $pad)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_collect_pads_set_buffer_function (
  GstCollectPads $pads,
  &func (GstCollectPads, GstCollectData, GstBuffer, gpointer --> GstFlowReturn),
  gpointer $user_data
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_collect_pads_set_clip_function (
  GstCollectPads $pads,
  &clipfunc (
    GstCollectPads,
    GstCollectData,
    GstBuffer,
    CArray[Pointer[GstBuffer]],
    gpointer
    --> GstFlowReturn
  ),
  gpointer $user_data
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_collect_pads_set_compare_function (
  GstCollectPads $pads,
  &func (
    GstCollectPads,
    GstCollectData,
    GstClockTime,
    GstCollectData,
    GstClockTime,
    gpointer
    --> gint
  ),
  gpointer $user_data
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_collect_pads_set_event_function (
  GstCollectPads $pads,
  &func (GstCollectPads, GstCollectData, GstEvent, gpointer --> gboolean),
  gpointer $user_data
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_collect_pads_set_flush_function (
  GstCollectPads $pads,
  &func (GstCollectPads, gpointer),
  gpointer $user_data
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_collect_pads_set_flushing (GstCollectPads $pads, gboolean $flushing)
  is native(gstreamer-base)
  is export
{ * }

sub gst_collect_pads_set_function (
  GstCollectPads $pads,
  &func (GstCollectPads, gpointer --> GstFlowReturn),
  gpointer $user_data
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_collect_pads_set_query_function (
  GstCollectPads $pads,
  &func (GstCollectPads, GstCollectData, GstQuery, gpointer --> gboolean),
  gpointer $user_data
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_collect_pads_set_waiting (
  GstCollectPads $pads,
  GstCollectData $data,
  gboolean $waiting
)
  is native(gstreamer-base)
  is export
{ * }

sub gst_collect_pads_src_event_default (
  GstCollectPads $pads,
  GstPad $pad,
  GstEvent $event
)
  returns uint32
  is native(gstreamer-base)
  is export
{ * }

sub gst_collect_pads_start (GstCollectPads $pads)
  is native(gstreamer-base)
  is export
{ * }

sub gst_collect_pads_stop (GstCollectPads $pads)
  is native(gstreamer-base)
  is export
{ * }

sub gst_collect_pads_take_buffer (
  GstCollectPads $pads,
  GstCollectData $data,
  guint $size
)
  returns GstBuffer
  is native(gstreamer-base)
  is export
{ * }
