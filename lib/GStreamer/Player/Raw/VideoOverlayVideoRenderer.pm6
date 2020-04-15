use v6.c

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Structs;

unit package GStreamer::Player::Raw::VideoOverlayVideoRenderer;

### /usr/include/gstreamer-1.0/gst/player/gstplayer-video-overlay-video-renderer.h

sub gst_player_video_overlay_video_renderer_expose (
  GstPlayerVideoOverlayVideoRenderer $self
)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_video_overlay_video_renderer_get_render_rectangle (
  GstPlayerVideoOverlayVideoRenderer $self,
  gint $x is rw,
  gint $y is rw,
  gint $width is rw,
  gint $height is rw
)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_video_overlay_video_renderer_get_type ()
  returns GType
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_video_overlay_video_renderer_get_window_handle (
  GstPlayerVideoOverlayVideoRenderer $self
)
  returns Pointer
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_video_overlay_video_renderer_new (gpointer $window_handle)
  returns GstPlayerVideoRenderer
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_video_overlay_video_renderer_new_with_sink (
  gpointer $window_handle,
  GstElement $video_sink
)
  returns GstPlayerVideoRenderer
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_video_overlay_video_renderer_set_render_rectangle (
  GstPlayerVideoOverlayVideoRenderer $self,
  gint $x,
  gint $y,
  gint $width,
  gint $height
)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_video_overlay_video_renderer_set_window_handle (
  GstPlayerVideoOverlayVideoRenderer $self,
  gpointer $window_handle
)
  is native(gstreamer-player)
  is export
{ * }
