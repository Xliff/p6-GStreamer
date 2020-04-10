use v6.c;

use GStreamer::Raw::Types;
use GStreamer::Player::Raw::Player;

use GStreamer::Element;
use GStreamer::Player::AudioInfo;
use GStreamer::Player::GstPlayerVideoInfo;
use GStreamer::Player::SubtitleInfo;
use GStreamer::Player::VideoInfo;
use GStreamer::Object;
use GStreamer::Sample;
use GStreamer::Structure;

use GLib::Roles::StaticClass;

our subset GstPlayerAncestry is export of Mu
  where GstPlayer | GstObject;

class GStreamer::Player is GStreamer::Object {
  has GstPlayer $!p;

  submethod BUILD (:$player) {
    self.setPlayer($player);
  }

  method setPlayer (GstPlayerAncestry $_) {
    my $to-parent;

    $!p = do {
      when GstPlayer {
        $to-parent = cast(GstObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstPlayer, $_);
      }
    }
    self.setObject($to-player);
  }

  method GStreamer::Raw::Definitions::GstPlayer
  { $!p }

  method new (
    GstPlayerVideoRenderer() $renderer,
    GstPlayerSignalDispatcher() $dispatcher
  ) {
    my $player = gst_player_new($!p, $renderer, $dispatcher);

    $player ?? self.bless(:$player) !! Nil;
  }

  method color_balance_type_get_name {
    gst_player_color_balance_type_get_name($!p);
  }

  method color_balance_type_get_type {
    gst_player_color_balance_type_get_type();
  }

  method config_get_position_update_interval {
    gst_player_config_get_position_update_interval($!p);
  }

  method config_get_seek_accurate {
    gst_player_config_get_seek_accurate($!p);
  }

  method config_get_user_agent {
    gst_player_config_get_user_agent($!p);
  }

  method config_set_position_update_interval (Int() $interval) {
    my guint $i = $interval;

    gst_player_config_set_position_update_interval($!p, $i);
  }

  method config_set_seek_accurate (Int() $accurate) {
    my gboolean $a = $accurate.so.Int;

    gst_player_config_set_seek_accurate($!p, $a);
  }

  method config_set_user_agent (Str() $agent) {
    gst_player_config_set_user_agent($!p, $agent);
  }

  method error_get_name {
    gst_player_error_get_name($!p);
  }

  method error_get_type {
    gst_player_error_get_type();
  }

  method error_quark {
    gst_player_error_quark();
  }

  method get_audio_video_offset {
    gst_player_get_audio_video_offset($!p);
  }

  method get_color_balance (Int() $type) {
    my GstPlayerColorBalanceType $t = $type;

    gst_player_get_color_balance($!p, $t);
  }

  method get_config (:$raw = False) {
    my $s = gst_player_get_config($!p);

    $s ??
      ( $raw ?? $s !! GStreamer::Structure.new($s) )
      !!
      GstStructure;
  }

  method get_current_audio_track (:$raw = False) {
    my $a = gst_player_get_current_audio_track($!p);

    $a ?/
      ( $raw ?? $a !! GStreamer::Player::AudioInfo.new($a) )
      !!
      GstPlayerAudioInfo;
  }

  method get_current_subtitle_track (:$raw = False) {
    my $st = gst_player_get_current_subtitle_track($!p);

    $st ??
      ( $raw ?? $st !! GStreamer::Player::SubtitleInfo.new($st) )
      !!
      GstPlayerSubtitleInfo;
  }

  method get_current_video_track (:$raw = False) {
    my $vt = gst_player_get_current_video_track($!p);

    $vt ??
      ( $raw ?? $vt !! GStreamer::Player::VideoInfo.new($vt))
      !!
      GstPlayerVideoInfo;
  }

  method get_current_visualization {
    gst_player_get_current_visualization($!p);
  }

  method get_duration {
    gst_player_get_duration($!p);
  }

  method get_media_info (:$raw = False) {
    my $mi = gst_player_get_media_info($!p);

    $vi ??
      ( $raw ?/ $vi !! GStreamer::Player::VideoInfo.new($vi) )
      !!
      GstPlayerVideoInfo;
  }

  # Make so flags can be checked using ∈/(elem) !
  method get_multiview_flags {
    gst_player_get_multiview_flags($!p);
  }

  method get_multiview_mode {
    GstVideoMultiviewFramePackingEnum( gst_player_get_multiview_mode($!p) );
  }

  method get_mute {
    so gst_player_get_mute($!p);
  }

  method get_pipeline (:$raw = False) {
    my $e = gst_player_get_pipeline($!p);

    $e ??
      ( $raw ?? $e !! GStreamer::Element.new($e) )
      !!
      GstElement;
  }

  method get_position {
    gst_player_get_position($!p);
  }

  method get_rate {
    gst_player_get_rate($!p);
  }

  method get_subtitle_uri {
    gst_player_get_subtitle_uri($!p);
  }

  method get_subtitle_video_offset {
    gst_player_get_subtitle_video_offset($!p);
  }

  method get_type {
    gst_player_get_type();
  }

  method get_uri {
    gst_player_get_uri($!p);
  }

  method get_video_snapshot (
    Int() $format,
    GstStructure() $config,
    :$raw = False
  ) {
    my GstPlayerSnapshotFormat $f = $format;
    my $s = gst_player_get_video_snapshot($!p, $f, $config);

    $s ??
      ( $raw ?? $s !! GStreamer::Sample.new($s) )
      !!
      GstSample;
  }

  method get_volume {
    gst_player_get_volume($!p);
  }

  method has_color_balance {
    gst_player_has_color_balance($!p);
  }

  method pause {
    gst_player_pause($!p);
  }

  method play {
    gst_player_play($!p);
  }

  method seek (Int() $position) {
    my GstClockTime $p = $position;

    gst_player_seek($!p, $p);
  }

  method set_audio_track (Int() $stream_index) {
    my gint $si = $stream_index;

    so gst_player_set_audio_track($!p, $si);
  }

  method set_audio_track_enabled (Int() $enabled) {
    my gboolean $e = $enabled.so.Int;

    gst_player_set_audio_track_enabled($!p, $e);
  }

  method set_audio_video_offset (Int() $offset) {
    my gint64 $o = $offset;

    gst_player_set_audio_video_offset($!p, $o);
  }

  method set_color_balance (Int() $type, Num() $value) {
    my GstPlayerColorBalanceType $t = $type;
    my gdouble $v = $value;

    gst_player_set_color_balance($!p, $t, $v);
  }

  method set_config (GstStructure() $config) {
    so gst_player_set_config($!p, $config);
  }

  method set_multiview_flags (Int() $flags) {
    my GstVideoMultiviewFlags $f = $flags;

    gst_player_set_multiview_flags($!p, $flags);
  }

  method set_multiview_mode (Int() $mode) {
    my GstVideoMultiviewFramePacking $m = $mode;

    gst_player_set_multiview_mode($!p, $m);
  }

  method set_mute (Int() $val) {
    my gboolean $v = $val.so.Int;

    gst_player_set_mute($!p, $v);
  }

  method set_rate (Num() $rate) {
    my gdouble $r = $rate;

    gst_player_set_rate($!p, $rate);
  }

  method set_subtitle_track (Int() $stream_index) {
    my gint $si = $stream_index;

    so gst_player_set_subtitle_track($!p, $si);
  }

  method set_subtitle_track_enabled (Int() $enabled) {
    my gboolean $e = $enabled.so.Int;

    gst_player_set_subtitle_track_enabled($!p, $e);
  }

  method set_subtitle_uri (Str() $uri) {
    gst_player_set_subtitle_uri($!p, $uri);
  }

  method set_subtitle_video_offset (Int() $offset) {
    my gint64 $o = $offset;

    gst_player_set_subtitle_video_offset($!p, $o);
  }

  method set_uri (Str() $uri) {
    gst_player_set_uri($!p, $uri);
  }

  method set_video_track (Int() $stream_index) {
    my gint $si = $stream_index;

    so gst_player_set_video_track($!p, $si);
  }

  method set_video_track_enabled (Int() $enabled) {
    my gboolean $e = $enabled.so.Int;

    gst_player_set_video_track_enabled($!p, $e);
  }

  method set_visualization (Str() $name) {
    so st_player_set_visualization($!p, $name);
  }

  method set_visualization_enabled (Int() $enabled) {
    my gboolean $e = $enabled.so.Int;

    gst_player_set_visualization_enabled($!p, $enabled);
  }

  method set_volume (Num() $val) {
    my gdouble $v = $val;

    gst_player_set_volume($!p, $v);
  }

  method stop {
    gst_player_stop($!p);
  }

}

class GStreamer::Player::State {
  also does GLib::Roles::StaticClass;

  method get_name (Int() $s) {
    gst_player_state_get_name($s);
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_player_state_get_type, $n, $t );
  }

}
