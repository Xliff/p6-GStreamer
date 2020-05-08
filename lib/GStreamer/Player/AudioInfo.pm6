use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Player::StreamInfo;

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

  method get_bitrate
    is also<
      get-bitrate
      bitrate
    >
  {
    gst_player_audio_info_get_bitrate($!ai);
  }

  method get_channels
    is also<
      get-channels
      channels
    >
  {
    gst_player_audio_info_get_channels($!ai);
  }

  method get_language
    is also<
      get-language
      language
    >
  {
    gst_player_audio_info_get_language($!ai);
  }

  method get_max_bitrate
    is also<
      get-max-bitrate
      max_bitrate
      max-bitrate
    >
  {
    gst_player_audio_info_get_max_bitrate($!ai);
  }

  method get_sample_rate
    is also<
      get-sample-rate
      sample_rate
      sample-rate
    >
  {
    gst_player_audio_info_get_sample_rate($!ai);
  }

}
