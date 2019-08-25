use v6.c;

use GTK::Compat::Types;
use GStreamer::Raw::Types;

unit package GStreamer::Raw::Bus;

sub gst_bus_add_signal_watch (GstBus $bus)
  is native(gstreamer)
  is export
{ * }

sub gst_bus_add_signal_watch_full (GstBus $bus, gint $priority)
  is native(gstreamer)
  is export
{ * }

sub gst_bus_add_watch (
  GstBus $bus,
  &func (GstBus, GstMesage, gpointer --> gboolean),
  gpointer $user_data
)
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_bus_add_watch_full (
  GstBus $bus,
  gint $priority,
  &func (GstBus, GstMesage, gpointer --> gboolean),
  gpointer $user_data,
  GDestroyNotify $notify
)
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_bus_async_signal_func (
  GstBus $bus,
  GstMessage $message,
  gpointer $data
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_bus_create_watch (GstBus $bus)
  returns GSource
  is native(gstreamer)
  is export
{ * }

sub gst_bus_disable_sync_message_emission (GstBus $bus)
  is native(gstreamer)
  is export
{ * }

sub gst_bus_enable_sync_message_emission (GstBus $bus)
  is native(gstreamer)
  is export
{ * }

sub gst_bus_get_pollfd (GstBus $bus, GPollFD $fd)
  is native(gstreamer)
  is export
{ * }

sub gst_bus_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_bus_have_pending (GstBus $bus)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_bus_new ()
  returns GstBus
  is native(gstreamer)
  is export
{ * }

sub gst_bus_peek (GstBus $bus)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_bus_poll (GstBus $bus, GstMessageType $events, GstClockTime $timeout)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_bus_pop (GstBus $bus)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_bus_pop_filtered (
  GstBus $bus,
  GstMessageType $types
)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_bus_post (GstBus $bus, GstMessage $message)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_bus_remove_signal_watch (GstBus $bus)
  is native(gstreamer)
  is export
{ * }

sub gst_bus_remove_watch (GstBus $bus)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_bus_set_flushing (GstBus $bus, gboolean $flushing)
  is native(gstreamer)
  is export
{ * }

sub gst_bus_set_sync_handler (
  GstBus $bus,
  &func (GstBus, GstMessage, gpointer --> guint),
  gpointer $user_data,
  GDestroyNotify $notify
)
  is native(gstreamer)
  is export
{ * }

sub gst_bus_sync_signal_handler (
  GstBus $bus,
  GstMessage $message,
  gpointer $data
)
  returns GstBusSyncReply
  is native(gstreamer)
  is export
{ * }

sub gst_bus_timed_pop (GstBus $bus, GstClockTime $timeout)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_bus_timed_pop_filtered (
  GstBus $bus,
  GstClockTime $timeout,
  GstMessageType $types
)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }
