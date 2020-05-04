use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::Poll;

### /usr/include/gstreamer-1.0/gst/gstpoll.h

sub gst_poll_add_fd (GstPoll $set, GstPollFD $fd)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_poll_fd_can_read (GstPoll $set, GstPollFD $fd)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_poll_fd_can_write (GstPoll $set, GstPollFD $fd)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_poll_fd_ctl_pri (GstPoll $set, GstPollFD $fd, gboolean $active)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_poll_fd_ctl_read (GstPoll $set, GstPollFD $fd, gboolean $active)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_poll_fd_ctl_write (GstPoll $set, GstPollFD $fd, gboolean $active)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_poll_fd_has_closed (GstPoll $set, GstPollFD $fd)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_poll_fd_has_error (GstPoll $set, GstPollFD $fd)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_poll_fd_has_pri (GstPoll $set, GstPollFD $fd)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_poll_fd_ignored (GstPoll $set, GstPollFD $fd)
  is native(gstreamer)
  is export
{ * }

sub gst_poll_fd_init (GstPollFD $fd)
  is native(gstreamer)
  is export
{ * }

sub gst_poll_free (GstPoll $set)
  is native(gstreamer)
  is export
{ * }

sub gst_poll_get_read_gpollfd (GstPoll $set, GPollFD $fd)
  is native(gstreamer)
  is export
{ * }

sub gst_poll_new (gboolean $controllable)
  returns GstPoll
  is native(gstreamer)
  is export
{ * }

sub gst_poll_new_timer ()
  returns GstPoll
  is native(gstreamer)
  is export
{ * }

sub gst_poll_read_control (GstPoll $set)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_poll_remove_fd (GstPoll $set, GstPollFD $fd)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_poll_restart (GstPoll $set)
  is native(gstreamer)
  is export
{ * }

sub gst_poll_set_controllable (
  GstPoll $set,
  gboolean $controllable
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_poll_set_flushing (GstPoll $set, gboolean $flushing)
  is native(gstreamer)
  is export
{ * }

sub gst_poll_wait (GstPoll $set, GstClockTime $timeout)
  returns gint
  is native(gstreamer)
  is export
{ * }

sub gst_poll_write_control (GstPoll $set)
  returns uint32
  is native(gstreamer)
  is export
{ * }
