use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

unit package GStreamer::Player::Raw::Player;

### /usr/include/gstreamer-1.0/gst/player/gstplayer.h

sub gst_player_color_balance_type_get_name (GstPlayerColorBalanceType $type)
  returns Str
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_color_balance_type_get_type ()
  returns GType
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_config_get_position_update_interval (GstStructure $config)
  returns guint
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_config_get_seek_accurate (GstStructure $config)
  returns uint32
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_config_get_user_agent (GstStructure $config)
  returns Str
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_config_set_position_update_interval (
  GstStructure $config,
  guint $interval
)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_config_set_seek_accurate (
  GstStructure $config,
  gboolean $accurate
)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_config_set_user_agent (GstStructure $config, Str $agent)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_error_get_name (GstPlayerError $error)
  returns Str
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_error_get_type ()
  returns GType
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_error_quark ()
  returns GQuark
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_get_audio_video_offset (GstPlayer $player)
  returns gint64
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_get_color_balance (
  GstPlayer $player,
  GstPlayerColorBalanceType $type
)
  returns gdouble
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_get_config (GstPlayer $player)
  returns GstStructure
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_get_current_audio_track (GstPlayer $player)
  returns GstPlayerAudioInfo
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_get_current_subtitle_track (GstPlayer $player)
  returns GstPlayerSubtitleInfo
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_get_current_video_track (GstPlayer $player)
  returns GstPlayerVideoInfo
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_get_current_visualization (GstPlayer $player)
  returns Str
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_get_duration (GstPlayer $player)
  returns GstClockTime
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_get_media_info (GstPlayer $player)
  returns GstPlayerMediaInfo
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_get_multiview_flags (GstPlayer $player)
  returns GstVideoMultiviewFlags
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_get_multiview_mode (GstPlayer $player)
  returns GstVideoMultiviewFramePacking
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_get_mute (GstPlayer $player)
  returns uint32
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_get_pipeline (GstPlayer $player)
  returns GstElement
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_get_position (GstPlayer $player)
  returns GstClockTime
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_get_rate (GstPlayer $player)
  returns gdouble
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_get_subtitle_uri (GstPlayer $player)
  returns Str
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_get_subtitle_video_offset (GstPlayer $player)
  returns gint64
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_get_type ()
  returns GType
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_get_uri (GstPlayer $player)
  returns Str
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_get_video_snapshot (
  GstPlayer $player,
  GstPlayerSnapshotFormat $format,
  GstStructure $config
)
  returns GstSample
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_get_volume (GstPlayer $player)
  returns gdouble
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_has_color_balance (GstPlayer $player)
  returns uint32
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_new (
  GstPlayerVideoRenderer $video_renderer,
  GstPlayerSignalDispatcher $signal_dispatcher
)
  returns GstPlayer
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_pause (GstPlayer $player)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_play (GstPlayer $player)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_seek (GstPlayer $player, GstClockTime $position)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_set_audio_track (GstPlayer $player, gint $stream_index)
  returns uint32
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_set_audio_track_enabled (GstPlayer $player, gboolean $enabled)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_set_audio_video_offset (GstPlayer $player, gint64 $offset)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_set_color_balance (
  GstPlayer $player,
  GstPlayerColorBalanceType $type,
  gdouble $value
)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_set_config (GstPlayer $player, GstStructure $config)
  returns uint32
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_set_multiview_flags (
  GstPlayer $player,
  GstVideoMultiviewFlags $flags
)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_set_multiview_mode (
  GstPlayer $player,
  GstVideoMultiviewFramePacking $mode
)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_set_mute (GstPlayer $player, gboolean $val)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_set_rate (GstPlayer $player, gdouble $rate)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_set_subtitle_track (GstPlayer $player, gint $stream_index)
  returns uint32
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_set_subtitle_track_enabled (
  GstPlayer $player,
  gboolean $enabled
)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_set_subtitle_uri (GstPlayer $player, Str $uri)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_set_subtitle_video_offset (GstPlayer $player, gint64 $offset)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_set_uri (GstPlayer $player, Str $uri)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_set_video_track (GstPlayer $player, gint $stream_index)
  returns uint32
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_set_video_track_enabled (GstPlayer $player, gboolean $enabled)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_set_visualization (GstPlayer $player, Str $name)
  returns uint32
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_set_visualization_enabled (GstPlayer $player, gboolean $enabled)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_set_volume (GstPlayer $player, gdouble $val)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_state_get_name (GstPlayerState $state)
  returns Str
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_state_get_type ()
  returns GType
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_stop (GstPlayer $player)
  is native(gstreamer-player)
  is export
{ * }
