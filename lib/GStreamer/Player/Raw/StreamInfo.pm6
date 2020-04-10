use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

unit package GStreamer::Player::Raw::VideoInfo;

### /usr/include/gstreamer-1.0/gst/player/gstplayer-media-info.h

sub gst_player_audio_info_get_bitrate (GstPlayerAudioInfo $info)
  returns gint
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_audio_info_get_channels (GstPlayerAudioInfo $info)
  returns gint
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_audio_info_get_language (GstPlayerAudioInfo $info)
  returns Str
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_audio_info_get_max_bitrate (GstPlayerAudioInfo $info)
  returns gint
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_audio_info_get_sample_rate (GstPlayerAudioInfo $info)
  returns gint
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_media_info_get_audio_streams (GstPlayerMediaInfo $info)
  returns GList
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_media_info_get_container_format (GstPlayerMediaInfo $info)
  returns Str
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_media_info_get_duration (GstPlayerMediaInfo $info)
  returns GstClockTime
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_media_info_get_image_sample (GstPlayerMediaInfo $info)
  returns GstSample
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_media_info_get_number_of_audio_streams (
  GstPlayerMediaInfo $info
)
  returns guint
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_media_info_get_number_of_streams (GstPlayerMediaInfo $info)
  returns guint
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_media_info_get_number_of_subtitle_streams (
  GstPlayerMediaInfo $info
)
  returns guint
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_media_info_get_number_of_video_streams (
  GstPlayerMediaInfo $info
)
  returns guint
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_media_info_get_stream_list (GstPlayerMediaInfo $info)
  returns GList
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_media_info_get_subtitle_streams (GstPlayerMediaInfo $info)
  returns GList
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_media_info_get_tags (GstPlayerMediaInfo $info)
  returns GstTagList
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_media_info_get_title (GstPlayerMediaInfo $info)
  returns Str
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_media_info_get_uri (GstPlayerMediaInfo $info)
  returns Str
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_media_info_get_video_streams (GstPlayerMediaInfo $info)
  returns GList
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_media_info_is_live (GstPlayerMediaInfo $info)
  returns uint32
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_media_info_is_seekable (GstPlayerMediaInfo $info)
  returns uint32
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_stream_info_get_caps (GstPlayerStreamInfo $info)
  returns GstCaps
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_stream_info_get_codec (GstPlayerStreamInfo $info)
  returns Str
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_stream_info_get_index (GstPlayerStreamInfo $info)
  returns gint
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_stream_info_get_stream_type (GstPlayerStreamInfo $info)
  returns Str
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_stream_info_get_tags (GstPlayerStreamInfo $info)
  returns GstTagList
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_subtitle_info_get_language (GstPlayerSubtitleInfo $info)
  returns Str
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_video_info_get_bitrate (GstPlayerVideoInfo $info)
  returns gint
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_video_info_get_framerate (
  GstPlayerVideoInfo $info,
  gint $fps_n is rw,
  gint $fps_d is rw
)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_video_info_get_height (GstPlayerVideoInfo $info)
  returns gint
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_video_info_get_max_bitrate (GstPlayerVideoInfo $info)
  returns gint
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_video_info_get_pixel_aspect_ratio (
  GstPlayerVideoInfo $info,
  guint $par_n is rw,
  guint $par_d is rw
)
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_video_info_get_width (GstPlayerVideoInfo $info)
  returns gint
  is native(gstreamer-player)
{ * }
a

# Trimmed: 3
# 34:  (gst_player_media_info_get_video_streams) GList*        gst_player_get_video_streams    (const GstPlayerMediaInfo *info);
# 35:  (gst_player_media_info_get_audio_streams) GList*        gst_player_get_audio_streams    (const GstPlayerMediaInfo *info);
# 36:  (gst_player_media_info_get_subtitle_streams) GList*        gst_player_get_subtitle_streams (const GstPlayerMediaInfo *info);
