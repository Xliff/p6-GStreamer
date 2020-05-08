use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Enums;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::Video::Navigation;

### /usr/include/gstreamer-1.0/gst/video/navigation.h

sub gst_navigation_event_get_type (GstEvent $event)
  returns GstNavigationEventType
  is native(gstreamer-video)
  is export
{ * }

sub gst_navigation_event_parse_command (
  GstEvent $event,
  GstNavigationCommand $command
)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_navigation_event_parse_key_event (GstEvent $event, Str $key)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_navigation_event_parse_mouse_button_event (
  GstEvent $event,
  gint $button,
  gdouble $x,
  gdouble $y
)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_navigation_event_parse_mouse_move_event (
  GstEvent $event,
  gdouble $x,
  gdouble $y
)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_navigation_get_type ()
  returns GType
  is native(gstreamer-video)
  is export
{ * }

sub gst_navigation_message_get_type (GstMessage $message)
  returns GstNavigationMessageType
  is native(gstreamer-video)
  is export
{ * }

sub gst_navigation_message_new_angles_changed (
  GstObject $src,
  guint $cur_angle,
  guint $n_angles
)
  returns GstMessage
  is native(gstreamer-video)
  is export
{ * }

sub gst_navigation_message_new_commands_changed (GstObject $src)
  returns GstMessage
  is native(gstreamer-video)
  is export
{ * }

sub gst_navigation_message_new_event (GstObject $src, GstEvent $event)
  returns GstMessage
  is native(gstreamer-video)
  is export
{ * }

sub gst_navigation_message_new_mouse_over (GstObject $src, gboolean $active)
  returns GstMessage
  is native(gstreamer-video)
  is export
{ * }

sub gst_navigation_message_parse_angles_changed (
  GstMessage $message,
  guint $cur_angle is rw,
  guint $n_angles  is rw
)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_navigation_message_parse_event (
  GstMessage $message,
  CArray[Pointer[GstEvent]] $event
)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_navigation_message_parse_mouse_over (
  GstMessage $message,
  gboolean $active is rw
)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_navigation_query_get_type (GstQuery $query)
  returns GstNavigationQueryType
  is native(gstreamer-video)
  is export
{ * }

sub gst_navigation_query_new_angles ()
  returns GstQuery
  is native(gstreamer-video)
  is export
{ * }

sub gst_navigation_query_new_commands ()
  returns GstQuery
  is native(gstreamer-video)
  is export
{ * }

sub gst_navigation_query_parse_angles (
  GstQuery $query,
  guint $cur_angle is rw,
  guint $n_angles  is rw
)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_navigation_query_parse_commands_length (
  GstQuery $query,
  guint $n_cmds is rw
)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_navigation_query_parse_commands_nth (
  GstQuery $query,
  guint $nth,
  GstNavigationCommand $cmd is rw
)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_navigation_query_set_angles (
  GstQuery $query,
  guint $cur_angle,
  guint $n_angles
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_navigation_query_set_commandsv (
  GstQuery $query,
  gint $n_cmds,
  CArray[GstNavigationCommand] $cmds
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_navigation_send_command (
  GstNavigation $navigation,
  GstNavigationCommand $command
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_navigation_send_event (
  GstNavigation $navigation,
  GstStructure $structure
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_navigation_send_key_event (
  GstNavigation $navigation,
  Str $event,
  Str $key
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_navigation_send_mouse_event (
  GstNavigation $navigation,
  Str $event,
  gint $button,
  gdouble $x,
  gdouble $y
)
  is native(gstreamer-video)
  is export
{ * }
