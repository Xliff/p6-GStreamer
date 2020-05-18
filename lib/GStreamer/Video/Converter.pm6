use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

use GStreamer::Structure;

class GStreamer::Video::Converter {
  has GstVideoConverter $!vc;

  submethod BUILD (:$video-converter) {
    $!vc = $video-converter;
  }

  method GStreamer::Raw::Definitions::GstVideoConverter
  { $!vc }

  multi method new (GstVideoConverter $video-converter) {
    $video-converter ?? self.bless( :$video-converter ) !! Nil;
  }
  multi method new (GstVideoInfo $in_info, GstVideoInfo $out_info, GstStructure() $config) {
    my $video-converter = gst_video_converter_new(
      $in_info,
      $out_info,
      $config
    );

    $video-converter ?? self.bless( :$video-converter ) !! Nil;
  }

  method frame (GstVideoFrame $src, GstVideoFrame $dest) {
    gst_video_converter_frame($!vc, $src, $dest);
  }

  method free {
    gst_video_converter_free($!vc);
  }

  method get_config (:$raw = False) {
    my $s = gst_video_converter_get_config($!vc);

    $s ??
      ( $raw ?? $s !! GStreamer::Structure.new($s) )
      !!
      Nil;
  }

  method set_config (GstStructure() $config) {
    gst_video_converter_set_config($!vc, $config);
  }

}

### /usr/include/gstreamer-1.0/gst/video/video-converter.h

sub gst_video_converter_frame (
  GstVideoConverter $convert,
  GstVideoFrame $src,
  GstVideoFrame $dest
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_converter_free (GstVideoConverter $convert)
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_converter_get_config (GstVideoConverter $convert)
  returns GstStructure
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_converter_new (
  GstVideoInfo $in_info,
  GstVideoInfo $out_info,
  GstStructure $config
)
  returns GstVideoConverter
  is native(gstreamer-video)
  is export
{ * }

sub gst_video_converter_set_config (
  GstVideoConverter $convert,
  GstStructure $config
)
  returns uint32
  is native(gstreamer-video)
  is export
{ * }
