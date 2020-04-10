use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Player::Raw::StreamInfo;

use GStreamer::Caps;
use GStreamer::Object;
use GStreamer::TagList;

our subset GstPlayerStreamInfo is export of Mu
  GstPlayerStreamInfo | GstObject;

class GStreamer::Player::StreamInfo is GStreamer::Object {
  has GstPlayerStreamInfo $!vi;

  submethod BUILD (:$video-info) {
    self.setStreamInfo($video-info);
  }

  method setStreamInfo (GstPlayerStreamInfoAncestry $_) {
    my $to-parent;

    $!vi = do {
      when GstPlayerStreamInfo {
        $to-parent = cast(GstObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstPlayerStreamInfo, $_);
      }
    }
    self.setGstObject($to-parent);
  }

  method GStreamer::Raw::Definitions::GstPlayerStreamInfo
    is also<GstPlayerStreamInfo>
  { $!vi }

  method new (GstPlayerStreamInfoAncestry $video-info) {
    $video-info ?? self.bless( :$video-info ) !! Nil;
  }

  method get_caps (:$raw = False) is also<get-caps> {
    my $c = gst_player_stream_info_get_caps($!p);

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      GstCaps;
  }

  method get_codec
    is also<
      get-codec
      codec
    >
  {
    gst_player_stream_info_get_codec($!p);
  }

  method get_index
    is also<
      get-index
      index
    >
  {
    gst_player_stream_info_get_index($!p);
  }

  method get_stream_type
    is also<
      get-stream-type
      stream_type
      stream-type
    >
  {
    gst_player_stream_info_get_stream_type($!p);
  }

  method get_tags (:$raw = False)
    is also<
      get-tags
      tags
    >
  {
    my $tl = gst_player_stream_info_get_tags($!p);

    $tl ??
      ( $raw ?? $tl !! GStreamer::TagList.new($tl) )
      !!
      GstTagList;
  }

}
