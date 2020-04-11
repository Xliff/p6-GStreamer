use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Player::Raw::MediaInfo;

use GStreamer::Player::StreamInfo;

our subset GstPlayerAudioInfoAncestry is export of Mu
  where GstPlayerAudioInfo | GstPlayerStreamInfo;

class GStreamer::Player::AudioInfo is GStreamer::Player::StreamInfo {
  has GstPlayerAudioInfo $!ai;

  submethod BUILD (:$audio-info) {
    self.setAudioInfo($audio-info);
  }

  method setAudioInfo (GstPlayerAudioInfoAncestry $_) {
    my $to-parent;

    $!ai = do {
      when GstPlayerAudioInfo {
        $to-parent = cast(GstPlayerStreamInfo, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstPlayerAudioInfo, $_);
      }
    }
    self.setStreamInfo($to-parent);
  }

  method GStreamer::Raw::Definitions::GstPlayerAudioInfo
    is also<GstPlayerAudioInfo>
  { $!ai }

  method new (GstPlayerAudioInfoAncestry $audio-info) {
    $audio-info ?? self.bless( :$audio-info ) !! Nil;
  }

  method get_bitrate {
    gst_player_audio_info_get_bitrate($!p);
  }

  method get_channels {
    gst_player_audio_info_get_channels($!p);
  }

  method get_language {
    gst_player_audio_info_get_language($!p);
  }

  method get_max_bitrate {
    gst_player_audio_info_get_max_bitrate($!p);
  }

  method get_sample_rate {
    gst_player_audio_info_get_sample_rate($!p);
  }

}
