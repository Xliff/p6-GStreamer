use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

unit package GStreamer::Player::Raw::Visualization;

### /usr/include/gstreamer-1.0/gst/player/gstplayer-visualization.h

sub gst_player_visualization_copy (GstPlayerVisualization $vis)
  returns GstPlayerVisualization
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_visualization_free (GstPlayerVisualization $vis)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_visualization_get_type ()
  returns GType
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_visualizations_free (GstPlayerVisualization $viss)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_visualizations_get ()
  returns CArray[Pointer[GstPlayerVisualization]]
  is native(gstreamer-player)
  is export
{ * }
