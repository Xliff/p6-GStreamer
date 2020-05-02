use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Enums;
use GStreamer::Raw::Structs;

### /usr/include/gstreamer-1.0/gst/video/gstvideometa.h

sub gst_buffer_add_video_gl_texture_upload_meta (
  GstBuffer $buffer,
  GstVideoGLTextureOrientation $texture_orientation,
  guint $n_textures,
  GstVideoGLTextureType $texture_type,
  GstVideoGLTextureUpload $upload,
  gpointer $user_data,
  GBoxedCopyFunc $user_data_copy,
  GBoxedFreeFunc $user_data_free
)
  returns GstVideoGLTextureUploadMeta
  is native(gstreamer-video)
  is export
{ * }

sub gst_buffer_add_video_meta (
  GstBuffer $buffer,
  GstVideoFrameFlags $flags,
  GstVideoFormat $format,
  guint $width,
  guint $height
)
  returns GstVideoMeta
  is native(gstreamer-video)
  is export
{ * }

sub gst_buffer_add_video_meta_full (
  GstBuffer $buffer,
  GstVideoFrameFlags $flags,
  GstVideoFormat $format,
  guint $width,
  guint $height,
  guint $n_planes,
  gsize $offset,
  gint $stride
)
  returns GstVideoMeta
  is native(gstreamer-video)
  is export
{ * }

sub gst_buffer_add_video_region_of_interest_meta (
  GstBuffer $buffer,
  Str $roi_type,
  guint $x,
  guint $y,
  guint $w,
  guint $h
)
  returns GstVideoRegionOfInterestMeta
  is native(gstreamer-video)
  is export
{ * }

sub gst_buffer_add_video_region_of_interest_meta_id (
  GstBuffer $buffer,
  GQuark $roi_type,
  guint $x,
  guint $y,
  guint $w,
  guint $h
)
  returns GstVideoRegionOfInterestMeta
  is native(gstreamer-video)
  is export
{ * }

sub gst_buffer_get_video_meta (GstBuffer $buffer)
  returns GstVideoMeta
  is native(gstreamer-video)
  is export
{ * }

sub gst_buffer_get_video_meta_id (GstBuffer $buffer, gint $id)
  returns GstVideoMeta
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_meta_get_info ()
  returns GstMetaInfo
  is native(gstreamer-video)
  is export
{ * }
