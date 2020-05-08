use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Enums;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::Player::Visualization;

### /usr/include/gstreamer-1.0/gst/player/gstplayer-visualization.h

sub gst_player_visualization_copy (GstPlayerVisualization $vis)
  returns GstPlayerVisualization
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_visualization_free (Pointer $vis)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_visualization_get_type ()
  returns GType
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_visualizations_free (
  CArray[Pointer[GstPlayerVisualization]] $viss
)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_visualizations_get ()
  returns CArray[Pointer[GstPlayerVisualization]]
  is native(gstreamer-player)
  is export
{ * }
