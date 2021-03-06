use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Player::StreamInfo;

use GStreamer::Player::StreamInfo;

our subset GstPlayerVideoInfoAncestry is export of Mu
  where GstPlayerVideoInfo | GstPlayerStreamInfo;

class GStreamer::Player::VideoInfo is GStreamer::Player::StreamInfo {
  has GstPlayerVideoInfo $!vi;

  submethod BUILD (:$video-info) {
    self.setVideoInfo($video-info);
  }

  method setVideoInfo (GstPlayerVideoInfoAncestry $_) {
    my $to-parent;

    $!vi = do {
      when GstPlayerVideoInfo {
        $to-parent = cast(GstPlayerStreamInfo, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstPlayerVideoInfo, $_);
      }
    }
    self.setStreamInfo($to-parent);
  }

  method GStreamer::Raw::Definitions::GstPlayerVideoInfo
    is also<GstPlayerVideoInfo>
  { $!vi }

  method new (GstPlayerVideoInfoAncestry $video-info) {
    $video-info ?? self.bless( :$video-info ) !! Nil;
  }

  method get_bitrate is also<
    get-bitrate
    bitrate
  > {
    gst_player_video_info_get_bitrate($!vi);
  }

  proto method get_framerate (|)
      is also<
        get-framerate
        framerate
      >
  { * }

  multi method get_framerate {
    samewith($, $);
  }
  multi method get_framerate ($fps_n is rw, $fps_d is rw) {
    my gint ($n, $d) = 0 xx 2;

    gst_player_video_info_get_framerate($!vi, $n, $d);
    ($fps_n, $fps_d) = ($n, $d);
  }

  method get_height is also<
    get-height
    height
  > {
    gst_player_video_info_get_height($!vi);
  }

  method get_max_bitrate is also<
    get-max-bitrate
    max_bitrate
    max-bitrate
  > {
    gst_player_video_info_get_max_bitrate($!vi);
  }

  proto method get_pixel_aspect_ratio (|)
      is also<
        get-pixel-aspect-ratio
        pixel_aspect_ratio
        pixel-aspect-ratio
        aspect_ratio
        aspect-ratio
      >
  { * }

  multi method get_pixel_aspect_ratio {
    samewith($, $);
  }
  multi method get_pixel_aspect_ratio ($par_n is rw, $par_d is rw) {
    my gint ($n, $d) = 0 xx 2;

    gst_player_video_info_get_pixel_aspect_ratio($!vi, $n, $d);
    ($par_n, $par_d) = ($n, $d);
  }

  method get_width is also<
    get-width
    width
  > {
    gst_player_video_info_get_width($!vi);
  }

  method get_size is also<
    get-size
    size
  > {
    (self.get_width, self.get_height)
  }

}
