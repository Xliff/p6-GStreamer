use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Player;

use GLib::Value;
use GStreamer::Element;
use GStreamer::Object;
use GStreamer::Player::AudioInfo;
use GStreamer::Player::MainContextSignalDispatcher;
use GStreamer::Player::MediaInfo;
use GStreamer::Player::SubtitleInfo;
use GStreamer::Player::VideoInfo;
use GStreamer::Sample;
use GStreamer::Structure;

use GStreamer::Roles::Signals::Player;

our subset GstPlayerAncestry is export of Mu
  where GstPlayer | GstObject;

class GStreamer::Player is GStreamer::Object {
  also does GStreamer::Roles::Signals::Player;

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
    self.setGstObject($to-parent);
  }

  method GStreamer::Raw::Definitions::GstPlayer
    is also<GstPlayer>
  { $!p }

  subset DispatchOrObject of Mu
    where GstPlayerSignalDispatcher |
          GStreamer::Player::MainContextSignalDispatcher;

  multi method new (DispatchOrObject $dispatcher is copy) {
    samewith(GstPlayerVideoRenderer, $dispatcher);
  }
  multi method new (
    GstPlayerVideoRenderer() $renderer,
    GstPlayerSignalDispatcher() $dispatcher
  ) {
    my $player = gst_player_new($renderer, $dispatcher);

    $player ?? self.bless(:$player) !! Nil;
  }

  # Type: GstPlayerAudioInfo
  method current-audio-track (:$raw = False) is rw {
    my $gv = GLib::Value.new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('current-audio-track', $gv);

        return Nil unless $gv.object;

        my $ai = cast(GstPlayerAudioInfo, $gv.object);
        $raw ?? $ai !! GStreamer::Player::AudioInfo.new($ai);
      },
      STORE => -> $,  $val is copy {
        warn 'current-audio-track does not allow writing'
      }
    );
  }

  # Type: GstPlayerSubtitleInfo
  method current-subtitle-track (:$raw = False) is rw  {
    my $gv = GLib::Value.new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('current-subtitle-track', $gv);

        return Nil unless $gv.object;

        my $si = cast(GstPlayerAudioInfo, $gv.object);
        $raw ?? $si !! GStreamer::Player::AudioInfo.new($si);
      },
      STORE => -> $, $val is copy {
        warn 'current-subtitle-track does not allow writing'
      }
    );
  }

  # Type: GstPlayerVideoInfo
  method current-video-track (:$raw = False) is rw  {
    my $gv = GLib::Value.new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('current-video-track', $gv);

        return Nil unless $gv.object;

        my $vi = cast(GstPlayerVideoInfo, $gv.object);
        $raw ?? $vi !! GStreamer::Player::VideoInfo.new($vi);
      },
      STORE => -> $, $val is copy {
        warn 'current-video-track does not allow writing'
      }
    );
  }

  # Type: guint64
  method duration is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT64 );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('duration', $gv);
        $gv.uint64;
      },
      STORE => -> $, Int() $val is copy {
        warn 'duration does not allow writing'
      }
    );
  }

  # Type: GstPlayerMediaInfo
  method media-info (:$raw = False) is rw  {
    my $gv = GLib::Value.new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('media-info', $gv);

        return Nil unless $gv.object;

        my $mi = cast(GstPlayerAudioInfo, $gv.object);
        $raw ?? $mi !! GStreamer::Player::MediaInfo.new($mi);
      },
      STORE => -> $,  $val is copy {
        warn 'media-info does not allow writing'
      }
    );
  }

  # Type: gboolean
  method mute is rw  {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('mute', $gv);
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('mute', $gv);
      }
    );
  }

  # Type: GstElement
  method pipeline (:$raw = False) is rw  {
    my $gv = GLib::Value.new( GStreamer::Element.get-type );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('pipeline', $gv);

        return Nil unless $gv.object;

        my $e = cast(GstElement, $gv.object);
        $raw ?? $e !! GStreamer::Element.new($e);
      },
      STORE => -> $,  $val is copy {
        warn 'pipeline does not allow writing'
      }
    );
  }

  # Type: guint64
  method position is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT64 );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('position', $gv);
        $gv.uint64;
      },
      STORE => -> $, Int() $val is copy {
        warn 'position does not allow writing'
      }
    );
  }

  # Type: guint
  method position-update-interval is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('position-update-interval', $gv);
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('position-update-interval', $gv);
      }
    );
  }

  # Type: gdouble
  method rate is rw  {
    my $gv = GLib::Value.new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('rate', $gv);
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('rate', $gv);
      }
    );
  }

  # Type: GstPlayerSignalDispatcher
  method signal-dispatcher is rw  {
    my $gv = GLib::Value.new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => sub ($) {
        warn 'signal-dispatcher does not allow reading' if $DEBUG;
        0;
      },
      STORE => -> $, GstPlayerSignalDispatcher() $val is copy {
        $gv.object = $val;
        self.prop_set('signal-dispatcher', $gv);
      }
    );
  }

  # Type: gchar
  method suburi is rw  {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('suburi', $gv);
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('suburi', $gv);
      }
    );
  }

  # Type: gchar
  method uri is rw  {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('uri', $gv);
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('uri', $gv);
      }
    );
  }

  # Type: GstPlayerVideoRenderer
  method video-renderer is rw  {
    my $gv = GLib::Value.new( G_TYPE_OBJECT );
    Proxy.new(
      FETCH => sub ($) {
        warn 'video-renderer does not allow reading' if $DEBUG;
        0;
      },
      STORE => -> $, GstPlayerVideoRenderer() $val is copy {
        $gv.object = $val;
        self.prop_set('video-renderer', $gv);
      }
    );
  }

  # Type: gdouble
  method volume is rw  {
    my $gv = GLib::Value.new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('volume', $gv);
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('volume', $gv);
      }
    );
  }

  # Is originally:
  # GstPlayer, gint, gpointer --> void
  method buffering {
    self.connect-int($!p, 'buffering');
  }

  # Is originally:
  # GstPlayer, guint64, gpointer --> void
  method duration-changed {
    self.connect-long($!p, 'duration-changed');
  }

  # Is originally:
  # GstPlayer, gpointer --> void
  method end-of-stream {
    self.connect($!p, 'end-of-stream');
  }

  # Is originally:
  # GstPlayer, GError, gpointer --> void
  method error {
    self.connect-error($!p);
  }

  # Is originally:
  # GstPlayer, GstPlayerMediaInfo, gpointer --> void
  method media-info-updated {
    self.connect-media-info-updated($!p);
  }

  # Is originally:
  # GstPlayer, gpointer --> void
  method mute-changed {
    self.connect($!p, 'mute-changed');
  }

  # Is originally:
  # GstPlayer, guint64, gpointer --> void
  method position-updated {
    self.connect-long($!p, 'position-updated');
  }

  # Is originally:
  # GstPlayer, guint64, gpointer --> void
  method seek-done {
    self.connect-long($!p, 'seek-done');
  }

  # Is originally:
  # GstPlayer, GstPlayerState, gpointer --> void
  method state-changed {
    self.connect-uint($!p, 'state-changed');
  }

  # Is originally:
  # GstPlayer, gint, gint, gpointer --> void
  method video-dimensions-changed {
    self.connect-intint($!p, 'video-dimensions-changed');
  }

  # Is originally:
  # GstPlayer, gpointer --> void
  method volume-changed {
    self.connect($!p, 'volume-changed');
  }

  # Is originally:
  # GstPlayer, GError, gpointer --> void
  method warning {
    self.connect-error($!p, 'warning');
  }

  method error_get_name is also<error-get-name> {
    gst_player_error_get_name($!p);
  }

  method error_get_type is also<error-get-type> {
    gst_player_error_get_type();
  }

  method error_quark is also<error-quark> {
    gst_player_error_quark();
  }

  method get_audio_video_offset is also<get-audio-video-offset> {
    gst_player_get_audio_video_offset($!p);
  }

  method get_color_balance (Int() $type) is also<get-color-balance> {
    my GstPlayerColorBalanceType $t = $type;

    gst_player_get_color_balance($!p, $t);
  }

  method get_config (:$raw = False) is also<get-config> {
    my $s = gst_player_get_config($!p);

    $s ??
      ( $raw ?? $s !! GStreamer::Structure.new($s) )
      !!
      Nil;
  }

  method get_current_audio_track (:$raw = False)
    is also<get-current-audio-track>
  {
    my $a = gst_player_get_current_audio_track($!p);

    $a ??
      ( $raw ?? $a !! GStreamer::Player::AudioInfo.new($a) )
      !!
      Nil;
  }

  method get_current_subtitle_track (:$raw = False)
    is also<get-current-subtitle-track>
  {
    my $st = gst_player_get_current_subtitle_track($!p);

    $st ??
      ( $raw ?? $st !! GStreamer::Player::SubtitleInfo.new($st) )
      !!
      Nil;
  }

  method get_current_video_track (:$raw = False)
    is also<get-current-video-track>
  {
    my $vt = gst_player_get_current_video_track($!p);

    $vt ??
      ( $raw ?? $vt !! GStreamer::Player::VideoInfo.new($vt))
      !!
      Nil;
  }

  method get_current_visualization is also<get-current-visualization> {
    gst_player_get_current_visualization($!p);
  }

  method get_duration is also<get-duration> {
    gst_player_get_duration($!p);
  }

  method get_media_info (:$raw = False) is also<get-media-info> {
    my $mi = gst_player_get_media_info($!p);

    $mi ??
      ( $raw ?? $mi !! GStreamer::Player::MediaInfo.new($mi) )
      !!
      Nil;
  }

  # Make so flags can be checked using ∈/(elem) !
  method get_multiview_flags is also<get-multiview-flags> {
    gst_player_get_multiview_flags($!p);
  }

  method get_multiview_mode is also<get-multiview-mode> {
    GstVideoMultiviewFramePackingEnum( gst_player_get_multiview_mode($!p) );
  }

  method get_mute is also<get-mute> {
    so gst_player_get_mute($!p);
  }

  method get_pipeline (:$raw = False) is also<get-pipeline> {
    my $e = gst_player_get_pipeline($!p);

    $e ??
      ( $raw ?? $e !! GStreamer::Element.new($e) )
      !!
      Nil;
  }

  method get_position is also<get-position> {
    gst_player_get_position($!p);
  }

  method get_rate is also<get-rate> {
    gst_player_get_rate($!p);
  }

  method get_subtitle_uri is also<get-subtitle-uri> {
    gst_player_get_subtitle_uri($!p);
  }

  method get_subtitle_video_offset is also<get-subtitle-video-offset> {
    gst_player_get_subtitle_video_offset($!p);
  }

  method get_type is also<get-type> {
    gst_player_get_type();
  }

  method get_uri is also<get-uri> {
    gst_player_get_uri($!p);
  }

  method get_video_snapshot (
    Int() $format,
    GstStructure() $config,
    :$raw = False
  )
    is also<get-video-snapshot>
  {
    my GstPlayerSnapshotFormat $f = $format;
    my $s = gst_player_get_video_snapshot($!p, $f, $config);

    $s ??
      ( $raw ?? $s !! GStreamer::Sample.new($s) )
      !!
      Nil;
  }

  method get_volume is also<get-volume> {
    gst_player_get_volume($!p);
  }

  method has_color_balance is also<has-color-balance> {
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

  method set_audio_track (Int() $stream_index) is also<set-audio-track> {
    my gint $si = $stream_index;

    so gst_player_set_audio_track($!p, $si);
  }

  method set_audio_track_enabled (Int() $enabled)
    is also<set-audio-track-enabled>
  {
    my gboolean $e = $enabled.so.Int;

    gst_player_set_audio_track_enabled($!p, $e);
  }

  method set_audio_video_offset (Int() $offset)
    is also<set-audio-video-offset>
  {
    my gint64 $o = $offset;

    gst_player_set_audio_video_offset($!p, $o);
  }

  method set_color_balance (Int() $type, Num() $value)
    is also<set-color-balance>
  {
    my GstPlayerColorBalanceType $t = $type;
    my gdouble $v = $value;

    gst_player_set_color_balance($!p, $t, $v);
  }

  method set_config (GstStructure() $config) is also<set-config> {
    so gst_player_set_config($!p, $config);
  }

  method set_multiview_flags (Int() $flags) is also<set-multiview-flags> {
    my GstVideoMultiviewFlags $f = $flags;

    gst_player_set_multiview_flags($!p, $flags);
  }

  method set_multiview_mode (Int() $mode) is also<set-multiview-mode> {
    my GstVideoMultiviewFramePacking $m = $mode;

    gst_player_set_multiview_mode($!p, $m);
  }

  method set_mute (Int() $val) is also<set-mute> {
    my gboolean $v = $val.so.Int;

    gst_player_set_mute($!p, $v);
  }

  method set_rate (Num() $rate) is also<set-rate> {
    my gdouble $r = $rate;

    gst_player_set_rate($!p, $rate);
  }

  method set_subtitle_track (Int() $stream_index)
    is also<set-subtitle-track>
  {
    my gint $si = $stream_index;

    so gst_player_set_subtitle_track($!p, $si);
  }

  method set_subtitle_track_enabled (Int() $enabled)
    is also<set-subtitle-track-enabled>
  {
    my gboolean $e = $enabled.so.Int;

    gst_player_set_subtitle_track_enabled($!p, $e);
  }

  method set_subtitle_uri (Str() $uri) is also<set-subtitle-uri> {
    gst_player_set_subtitle_uri($!p, $uri);
  }

  method set_subtitle_video_offset (Int() $offset)
    is also<set-subtitle-video-offset>
  {
    my gint64 $o = $offset;

    gst_player_set_subtitle_video_offset($!p, $o);
  }

  method set_uri (Str() $uri) is also<set-uri> {
    gst_player_set_uri($!p, $uri);
  }

  method set_video_track (Int() $stream_index) is also<set-video-track> {
    my gint $si = $stream_index;

    so gst_player_set_video_track($!p, $si);
  }

  method set_video_track_enabled (Int() $enabled)
    is also<set-video-track-enabled>
  {
    my gboolean $e = $enabled.so.Int;

    gst_player_set_video_track_enabled($!p, $e);
  }

  method set_visualization (Str() $name) is also<set-visualization> {
    so gst_player_set_visualization($!p, $name);
  }

  method set_visualization_enabled (Int() $enabled)
    is also<set-visualization-enabled>
  {
    my gboolean $e = $enabled.so.Int;

    gst_player_set_visualization_enabled($!p, $enabled);
  }

  method set_volume (Num() $val) is also<set-volume> {
    my gdouble $v = $val;

    gst_player_set_volume($!p, $v);
  }

  method stop {
    gst_player_stop($!p);
  }

}

use GLib::Roles::StaticClass;

class GStreamer::Player::Config {
  also does GLib::Roles::StaticClass;

  method get_position_update_interval (GstStructure() $c)
    is also<get-position-update-interval>
  {
    gst_player_config_get_position_update_interval($c);
  }

  method get_seek_accurate (GstStructure() $c) is also<get-seek-accurate> {
    gst_player_config_get_seek_accurate($c);
  }

  method get_user_agent (GstStructure() $c) is also<get-user-agent> {
    gst_player_config_get_user_agent($c);
  }

  method set_position_update_interval (GstStructure() $c, Int() $interval)
    is also<set-position-update-interval>
  {
    my guint $i = $interval;

    gst_player_config_set_position_update_interval($c, $i);
  }

  method set_seek_accurate (GstStructure() $c, Int() $accurate)
    is also<set-seek-accurate>
  {
    my gboolean $a = $accurate.so.Int;

    gst_player_config_set_seek_accurate($c, $a);
  }

  method set_user_agent (GstStructure() $c, Str() $agent)
    is also<set-user-agent>
  {
    gst_player_config_set_user_agent($c, $agent);
  }
}

class GStreamer::Player::ColorBalance {
  also does GLib::Roles::StaticClass;

  method get_name (Int() $v) is also<get-name> {
    gst_player_color_balance_type_get_name($v);
  }

  method get_type is also<get-type> {
    gst_player_color_balance_type_get_type();
  }
}

class GStreamer::Player::State {
  also does GLib::Roles::StaticClass;

  method get_name (Int() $s) is also<get-name> {
    gst_player_state_get_name($s);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_player_state_get_type, $n, $t );
  }

}
