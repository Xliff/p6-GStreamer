use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Enums;
use GStreamer::Raw::PBUtils::Enums;
use GStreamer::Raw::PBUtils::Structs;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::PBUtils::Discoverer;

### /usr/include/gstreamer-1.0/gst/pbutils/gstdiscoverer.h

sub gst_discoverer_audio_info_get_bitrate (GstDiscovererAudioInfo $info)
  returns guint
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_audio_info_get_channel_mask (GstDiscovererAudioInfo $info)
  returns guint64
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_audio_info_get_channels (GstDiscovererAudioInfo $info)
  returns guint
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_audio_info_get_depth (GstDiscovererAudioInfo $info)
  returns guint
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_audio_info_get_language (GstDiscovererAudioInfo $info)
  returns Str
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_audio_info_get_max_bitrate (GstDiscovererAudioInfo $info)
  returns guint
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_audio_info_get_sample_rate (GstDiscovererAudioInfo $info)
  returns guint
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_audio_info_get_type ()
  returns GType
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_container_info_get_streams (GstDiscovererContainerInfo $info)
  returns GList
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_container_info_get_type ()
  returns GType
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_discover_uri (
  GstDiscoverer           $discoverer,
  Str                     $uri,
  CArray[Pointer[GError]] $err
)
  returns GstDiscovererInfo
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_discover_uri_async (GstDiscoverer $discoverer, Str $uri)
  returns uint32
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_get_type ()
  returns GType
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_info_copy (GstDiscovererInfo $ptr)
  returns GstDiscovererInfo
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_info_from_variant (GVariant $variant)
  returns GstDiscovererInfo
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_info_get_audio_streams (GstDiscovererInfo $info)
  returns GList
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_info_get_container_streams (GstDiscovererInfo $info)
  returns GList
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_info_get_duration (GstDiscovererInfo $info)
  returns GstClockTime
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_info_get_live (GstDiscovererInfo $info)
  returns uint32
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_info_get_misc (GstDiscovererInfo $info)
  returns GstStructure
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_info_get_missing_elements_installer_details (
  GstDiscovererInfo $info
)
  returns Str
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_info_get_result (GstDiscovererInfo $info)
  returns GstDiscovererResult
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_info_get_seekable (GstDiscovererInfo $info)
  returns uint32
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_info_get_stream_info (GstDiscovererInfo $info)
  returns GstDiscovererStreamInfo
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_info_get_stream_list (GstDiscovererInfo $info)
  returns GList
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_info_get_streams (GstDiscovererInfo $info, GType $streamtype)
  returns GList
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_info_get_subtitle_streams (GstDiscovererInfo $info)
  returns GList
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_info_get_tags (GstDiscovererInfo $info)
  returns GstTagList
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_info_get_toc (GstDiscovererInfo $info)
  returns GstToc
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_info_get_type ()
  returns GType
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_info_get_uri (GstDiscovererInfo $info)
  returns Str
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_info_get_video_streams (GstDiscovererInfo $info)
  returns GList
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_info_to_variant (
  GstDiscovererInfo           $info,
  GstDiscovererSerializeFlags $flags
)
  returns GVariant
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_new (GstClockTime $timeout, CArray[Pointer[GError]] $err)
  returns GstDiscoverer
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_start (GstDiscoverer $discoverer)
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_stop (GstDiscoverer $discoverer)
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_stream_info_get_caps (GstDiscovererStreamInfo $info)
  returns GstCaps
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_stream_info_get_misc (GstDiscovererStreamInfo $info)
  returns GstStructure
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_stream_info_get_next (GstDiscovererStreamInfo $info)
  returns GstDiscovererStreamInfo
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_stream_info_get_previous (GstDiscovererStreamInfo $info)
  returns GstDiscovererStreamInfo
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_stream_info_get_stream_id (GstDiscovererStreamInfo $info)
  returns Str
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_stream_info_get_stream_type_nick (
  GstDiscovererStreamInfo $info
)
  returns Str
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_stream_info_get_tags (GstDiscovererStreamInfo $info)
  returns GstTagList
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_stream_info_get_toc (GstDiscovererStreamInfo $info)
  returns GstToc
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_stream_info_get_type ()
  returns GType
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_stream_info_list_free (GList $infos)
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_subtitle_info_get_language (GstDiscovererSubtitleInfo $info)
  returns Str
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_subtitle_info_get_type ()
  returns GType
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_video_info_get_bitrate (GstDiscovererVideoInfo $info)
  returns guint
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_video_info_get_depth (GstDiscovererVideoInfo $info)
  returns guint
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_video_info_get_framerate_denom (GstDiscovererVideoInfo $info)
  returns guint
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_video_info_get_framerate_num (GstDiscovererVideoInfo $info)
  returns guint
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_video_info_get_height (GstDiscovererVideoInfo $info)
  returns guint
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_video_info_get_max_bitrate (GstDiscovererVideoInfo $info)
  returns guint
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_video_info_get_par_denom (GstDiscovererVideoInfo $info)
  returns guint
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_video_info_get_par_num (GstDiscovererVideoInfo $info)
  returns guint
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_video_info_get_type ()
  returns GType
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_video_info_get_width (GstDiscovererVideoInfo $info)
  returns guint
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_video_info_is_image (GstDiscovererVideoInfo $info)
  returns uint32
  is native(gstreamer-pbutils)
  is export
{ * }

sub gst_discoverer_video_info_is_interlaced (GstDiscovererVideoInfo $info)
  returns uint32
  is native(gstreamer-pbutils)
  is export
{ * }
