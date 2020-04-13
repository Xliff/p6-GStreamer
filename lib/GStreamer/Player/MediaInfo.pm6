use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Player::Raw::StreamInfo;

use GStreamer::Object;
use GStreamer::Sample;

our subset GstPlayerMediaInfoAncestry is export of Mu
  where GstPlayerMediaInfo | GstObject;

class GStreamer::Player::MediaInfo is GStreamer::Object {
  has GstPlayerMediaInfo $!mi;

  submethod BUILD (:$video-info) {
    self.setMediaInfo($video-info);
  }

  method setMediaInfo (GstPlayerMediaInfoAncestry $_) {
    my $to-parent;

    $!mi = do {
      when GstPlayerMediaInfo {
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

  method GStreamer::Raw::Definitions::GstPlayerMediaInfo
    is also<GstPlayerMediaInfo>
  { $!mi }

  method new (GstPlayerMediaInfoAncestry $media-info) {
    $media-info ?? self.bless( :$media-info ) !! Nil;
  }

  method get_audio_streams (:$glist = False, :$raw = False)
    is also<
      get-audio-streams
      audio_streams
      audio-streams
    >
  {
    my $asl = gst_player_media_info_get_audio_streams($!mi);

    return Nil unless $asl;
    # -- TODO::GLOBAL --
    # Note to self... ahhh.. heh... the logic on this should be
    # `if $glist && $raw`.... mea culpa!
    # Yes, this applies to the ENTIRE PRODUCT LINE!
    return $asl if $glist && $raw;

    $asl = GLib::GList.new($asl) but GLib::Roles::ListData[GstPlayerAudioInfo];

    return $asl if $glist;

    $raw ?? $asl.Array
         !! $asl.Array.map({ GStreamer::Player::AudioInfo.new($_) });
  }

  method get_container_format is also<get-container-format> {
    gst_player_media_info_get_container_format($!mi);
  }

  method get_duration is also<get-duration> {
    gst_player_media_info_get_duration($!mi);
  }

  method get_image_sample (:$raw = False)
    is also<
      get-image-sample
      image_sample
      image-sample
    >
  {
    my $s = gst_player_media_info_get_image_sample($!mi);

    # TODO::GLOBAL
    # Wow! The point of the whole refactor was to make sure that strongly typed
    # values would work. After testing, the initial behavior of returnning Nil
    # WAS the proper way to do this. Please go back and revert JUST those
    # changes

    $s ??
      ( $raw ?? $s !! GStreamer::Sample.new($s) )
      !!
      Nil;
  }

  method get_number_of_audio_streams
    is also<
      get-number-of-audio-streams
      number_of_audio_streams
      number-of-audio-streams
      num_audio
      num-audio
    >
  {
    gst_player_media_info_get_number_of_audio_streams($!mi);
  }

  method get_number_of_streams
    is also<
      get-number-of-streams
      number_of_streams
      number-of-streams
      num_streams
      num-streams
    >
  {
    gst_player_media_info_get_number_of_streams($!mi);
  }

  method get_number_of_subtitle_streams
    is also<
      get-number-of-subtitle-streams
      number_of_subtitle_streams
      number-of-subtitle-streams
      num_subs
      num-subs
    >
  {
    gst_player_media_info_get_number_of_subtitle_streams($!mi);
  }

  method get_number_of_video_streams
    is also<
      get-number-of-video-streams
      number_of_video_streams
      number-of-video-streams
      num_video
      num-video
    >
  {
    gst_player_media_info_get_number_of_video_streams($!mi);
  }

  method get_stream_list (:$glist = False, :$raw = False)
    is also<
      get-stream-list
      stream_list
      stream-list
    >
  {
    my $sl = gst_player_media_info_get_stream_list($!mi);

    return Nil unless $sl;
    return $sl if $glist && $raw;

    $sl = GLib::GList.new($sl) but GLib::Roles::ListData[GstPlayerStreamInfo];

    return $sl if $glist;

    $raw ?? $sl.Array
         !! $sl.Array.map({ GStreamer::Player::StreamInfo.new($_) })
  }

  method get_subtitle_streams (:$glist = False, :$raw = False)
    is also<
      get-subtitle-streams
      subtitle_streams
      subtitle-streams
    >
  {
    my $ssl = gst_player_media_info_get_subtitle_streams($!mi);

    return Nil unless $ssl;
    return $ssl if $glist && $raw;

    $ssl = GLib::GList.new($ssl) but GLib::Roles::ListData[GstPlayerMediaInfo];

    return $ssl if $glist;

    $raw ?? $ssl.Array
         !! $ssl.Array.map({ GStreamer::Player::StreamInfo.new($_) })
  }

  method get_tags (:$raw = False) is also<get-tags> {
    my $tl = gst_player_media_info_get_tags($!mi);

    $tl ??
      ( $raw ?? $tl !! GStreamer::TagList.new($tl) )
      !!
      Nil;
  }

  method get_title is also<get-title> {
    gst_player_media_info_get_title($!mi);
  }

  method get_uri is also<get-uri> {
    gst_player_media_info_get_uri($!mi);
  }

  method get_video_streams (:$glist = False, :$raw = False)
    is also<
      get-video-streams
      video_streams
      video-streams
    >
  {
    my $vsl = gst_player_media_info_get_video_streams($!mi);

    return Nil unless $vsl;
    return $vsl if $glist && $raw;

    $vsl = GLib::GList.new($vsl) but GLib::Roles::ListData[GstPlayerVideoInfo];

    return $vsl if $glist;

    $raw ?? $vsl.Array
         !! $vsl.Array.map({ GStreamer::Player::VideoInfo.new($_) })
  }

  method is_live is also<is-live> {
    so gst_player_media_info_is_live($!mi);
  }

  method is_seekable is also<is-seekable> {
    so gst_player_media_info_is_seekable($!mi);
  }

}
