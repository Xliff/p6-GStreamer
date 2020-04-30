use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Enums;

unit package GStreamer::Raw::Video::Orientation;

### /usr/include/gstreamer-1.0/gst/video/videoorientation.h

sub gst_video_orientation_get_type ()
  returns GType
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_orientation_get_hcenter (
  GstVideoOrientation $video_orientation,
  gint $center is rw
)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_orientation_get_hflip (
  GstVideoOrientation $video_orientation,
  gboolean $flip is rw
)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_orientation_get_vcenter (
  GstVideoOrientation $video_orientation,
  gint $center is rw
)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_orientation_get_vflip (
  GstVideoOrientation $video_orientation,
  gboolean $flip is rw
)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_orientation_set_hcenter (
  GstVideoOrientation $video_orientation,
  gint $center
)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_orientation_set_hflip (
  GstVideoOrientation $video_orientation,
  gboolean $flip
)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_orientation_set_vcenter (
  GstVideoOrientation $video_orientation,
  gint $center
)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_orientation_set_vflip (
  GstVideoOrientation $video_orientation,
  gboolean $flip
)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }
