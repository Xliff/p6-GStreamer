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
  has GstPlayerStreamInfo $!si;

  submethod BUILD (:$stream-info) {
    self.setStreamInfo($stream-info);
  }

  method setStreamInfo (GstPlayerStreamInfoAncestry $_) {
    my $to-parent;

    $!si = do {
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
  { $!si }

  method new (GstPlayerStreamInfoAncestry $video-info) {
    $video-info ?? self.bless( :$stream-info ) !! Nil;
  }

  method get_caps (:$raw = False) is also<get-caps> {
    my $c = gst_player_stream_info_get_caps($!si);

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

  method get_codec
    is also<
      get-codec
      codec
    >
  {
    gst_player_stream_info_get_codec($!si);
  }

  method get_index
    is also<
      get-index
      index
    >
  {
    gst_player_stream_info_get_index($!si);
  }

  method get_stream_type
    is also<
      get-stream-type
      stream_type
      stream-type
    >
  {
    gst_player_stream_info_get_stream_type($!si);
  }

  method get_tags (:$raw = False)
    is also<
      get-tags
      tags
    >
  {
    my $tl = gst_player_stream_info_get_tags($!si);

    $tl ??
      ( $raw ?? $tl !! GStreamer::TagList.new($tl) )
      !!
      Nil;
  }

}