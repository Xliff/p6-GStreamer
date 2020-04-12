use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Player::Raw::StreamInfo;

use GStreamer::Player::StreamInfo;

our subset GstPlayerSubtitleInfoAncestry is export of Mu
  where GstPlayerSubtitleInfo | GstPlayerStreamInfo;

class GStreamer::Player::SubtitleInfo is GStreamer::Player::StreamInfo {
  has GstPlayerSubtitleInfo $!si;

  submethod BUILD (:$subtitle-info) {
    self.setSubtitleInfo($subtitle-info);
  }

  method setSubtitleInfo (GstPlayerSubtitleInfoAncestry $_) {
    my $to-parent;

    $!ai = do {
      when GstPlayerSubtitleInfo {
        $to-parent = cast(GstPlayerStreamInfo, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstPlayerSubtitleInfo, $_);
      }
    }
    self.setStreamInfo($to-parent);
  }

  method GStreamer::Raw::Definitions::GstPlayerSubtitleInfo
    is also<GstPlayerSubtitleInfo>
  { $!ai }

  method new (GstPlayerSubtitleInfoAncestry $subtitle-info) {
    $subtitle-info ?? self.bless( :$subtitle-info ) !! Nil;
  }

  method get_language is also<get-language> {
    gst_player_subtitle_info_get_language($!si);
  }

}
