use v6.c;

use Method::Also;
use NativeCall;

use GStreamer::Raw::Types;
use GStreamer::Raw::PBUtils::Discoverer;

use GLib::GList;
use GStreamer::Caps;
use GStreamer::TagList;
use GStreamer::Toc;

use GLib::Roles::Object;

use GStreamer::Roles::Signals::PBUtils::Discoverer;

our subset GstDiscovererAncestry is export of Mu
  where GstDiscoverer | GObject;

class GStreamer::PBUtils::Discoverer::Info { ... }

class GStreamer::PBUtils::Discoverer {
  also does GLib::Roles::Object;

  has GstDiscoverer $!d;

  submethod BUILD (:$discoverer) {
    self.setGstDiscoverer($discoverer) if $discoverer;
  }

  method setGstDiscoverer (GstDiscovererAncestry $_) {
    my $to-parent;

    $!d = do {
      when GstDiscoverer {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstDiscoverer, $_);
      }
    }
    self!setObject($to-parent);
  }

  method GStreamer::Raw::Definitions::GstDiscoverer
    is also<GstDiscoverer>
  { $!d }

  multi method new (GstDiscovererAncestry $discoverer, :$ref = True) {
    return Nil unless $discoverer;

    my $o = self.bless( :$discoverer );
    $o.ref if $ref;
    $o;
  }
  multi method new (Int() $timeout, CArray[Pointer[GError]] $err = gerror) {
    my GstClockTime $t = $timeout;

    clear_error;
    my $discoverer = gst_discoverer_new($!d, $err);
    set_error($err);

    $discoverer ?? self.bless( :$discoverer ) !! Nil;
  }

  # Type: guint64
  method timeout is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('timeout', $gv)
        );
        $gv.uint64;
      },
      STORE => -> $, Int() $val is copy {
        warn 'timeout is a construct-only attribute'
      }
    );
  }

  # Type: gboolean
  method use-cache is rw  is also<use_cache> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('use-cache', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        warn 'use-cache is a construct-only attribute'
      }
    );
  }

  # Is originally:
  # GstDiscoverer, GstDiscovererInfo, GError, gpointer
  method discovered {
    self.connect-discovered($!d);
  }

  # Is originally:
  # GstDiscoverer, gpointer
  method finished {
    self.connect($!d, 'finished');
  }

  # Is originally:
  # GstDiscoverer, GstElement, gpointer
  method source-setup is also<source_setup> {
    self.connect-source-setup($!d);
  }

  # Is originally:
  # GstDiscoverer, gpointer
  method starting {
    self.connect($!d, 'starting');
  }

  method discover_uri (
    Str()                   $uri,
    CArray[Pointer[GError]] $err  = gerror,
                            :$raw = False
  ) is also<discover-uri> {
    clear_error;
    my $di = gst_discoverer_discover_uri($!d, $uri, $err);
    set_error($err);

    $di ?? (
              $raw ?? $di
                   !! GStreamer::PBUtils::Discoverer::Info.new($di, :!ref)
           )
        !! Nil
  }

  method discover_uri_async (Str() $uri) is also<discover-uri-async> {
    so gst_discoverer_discover_uri_async($!d, $uri);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &gst_discoverer_get_type,
      $n,
      $t
    );
  }

  method start {
    gst_discoverer_start($!d);
  }

  method stop {
    gst_discoverer_stop($!d);
  }

}

our subset GstDiscovererStreamInfoAncestry is export of Mu
  where GstDiscovererStreamInfo | GObject;

class GStreamer::PBUtils::Discoverer::StreamInfo {
  also does GLib::Roles::Object;

  has GstDiscovererStreamInfo $!si;

  submethod BUILD (:$discoverer) {
    self.setGstDiscovererStreamInfo($discoverer) if $discoverer;
  }

  method setGstDiscovererStreamInfo (GstDiscovererStreamInfoAncestry $_) {
    my $to-parent;

    $!si = do {
      when GstDiscovererStreamInfo {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstDiscovererStreamInfo, $_);
      }
    }
    self!setObject($to-parent);
  }

  method GStreamer::Raw::Definitions::GstDiscovererStreamInfo
    is also<GstDiscovererStreamInfo>
  { $!si }

  multi method new (
    GstDiscovererStreamInfoAncestry $discoverer,
                                    :$ref       = True
  ) {
    return Nil unless $discoverer;

    my $o = self.bless( :$discoverer );
    $o.ref if $ref;
    $o;
  }

  method get_caps (:$raw = False) is also<get-caps> {
    my $c = gst_discoverer_stream_info_get_caps($!si);

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c, :!ref) )
      !!
      Nil;
  }

  # Deprecated, use gst_discoverer_info_get_missing_elements_installer_details
  # method get_misc (:$raw = False) {
  #   my $s = gst_discoverer_stream_info_get_misc($!si);
  #
  #   $s ??
  #     ( $raw ?? $s !! GStreamer::Structure.new($s, :!ref) )
  #     !!
  #     Nil;
  # }

  method get_next (:$raw = False) is also<get-next> {
    my $si = gst_discoverer_stream_info_get_next($!si);

    $si ?? (
             $raw ?? $si
                  !! GStreamer::PBUtils::Discoverer::StreamInfo.new(
                       $si,
                       :!ref
                     )
            )
        !!  Nil
  }

  method get_previous (:$raw = False) is also<get-previous> {
    my $si = gst_discoverer_stream_info_get_previous($!si);

    $si ?? (
             $raw ?? $si
                  !! GStreamer::PBUtils::Discoverer::StreamInfo.new(
                       $si,
                       :!ref
                     )
            )
        !!  Nil
  }

  method get_stream_id is also<get-stream-id> {
    gst_discoverer_stream_info_get_stream_id($!si);
  }

  method get_stream_type_nick is also<get-stream-type-nick> {
    gst_discoverer_stream_info_get_stream_type_nick($!si);
  }

  method get_tags (:$raw = False) is also<get-tags> {
    my $tl = gst_discoverer_stream_info_get_tags($!si);

    # Transfer: none = :ref
    $tl ??
      ( $raw ?? $tl !! GStreamer::TagList.new($tl) )
      !!
      Nil
  }

  method get_toc (:$raw = False) is also<get-toc> {
    my $toc = gst_discoverer_stream_info_get_toc($!si);

    # Transfer: none = :ref
    $toc ??
      ( $raw ?? $toc !! GStreamer::Toc.new($toc) )
      !!
      Nil
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &gst_discoverer_stream_info_get_type,
      $n,
      $t
    );
  }

  method list_free (
    GStreamer::PBUtils::Discoverer::StreamInfo:U:
    GList() $l
  )
    is also<list-free>
  {
    gst_discoverer_stream_info_list_free($l);
  }

}

our subset GstDiscovererAudioInfoAncestry is export of Mu
  where GstDiscovererAudioInfo | GstDiscovererStreamInfoAncestry;


class GStreamer::PBUtils::Discoverer::AudioInfo is GStreamer::PBUtils::Discoverer::StreamInfo {
  has GstDiscovererAudioInfo $!ai;

  submethod BUILD (:$audio-discoverer) {
    self.setGstDiscovererAudioInfo($audio-discoverer) if $audio-discoverer;
  }

  method setGstDiscovererAudioInfo (GstDiscovererAudioInfoAncestry $_) {
    my $to-parent;

    $!ai = do {
      when GstDiscovererAudioInfo {
        $to-parent = cast(GstDiscovererStreamInfo, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstDiscovererAudioInfo, $_);
      }
    }
    self.setGstDiscovererStreamInfo($to-parent);
  }

  method GStreamer::Raw::Definitions::GstDiscovererAudioInfo
    is also<GstDiscovererAudioInfo>
  { $!ai }

  multi method new (
    GstDiscovererAudioInfoAncestry $audio-discoverer,
                                   :$ref       = True
  ) {
    return Nil unless $audio-discoverer;

    my $o = self.bless( :$audio-discoverer );
    $o.ref if $ref;
    $o;
  }

  method get_bitrate is also<get-bitrate> {
    gst_discoverer_audio_info_get_bitrate($!ai);
  }

  method get_channel_mask is also<get-channel-mask> {
    gst_discoverer_audio_info_get_channel_mask($!ai);
  }

  method get_channels is also<get-channels> {
    gst_discoverer_audio_info_get_channels($!ai);
  }

  method get_depth is also<get-depth> {
    gst_discoverer_audio_info_get_depth($!ai);
  }

  method get_language is also<get-language> {
    gst_discoverer_audio_info_get_language($!ai);
  }

  method get_max_bitrate is also<get-max-bitrate> {
    gst_discoverer_audio_info_get_max_bitrate($!ai);
  }

  method get_sample_rate is also<get-sample-rate> {
    gst_discoverer_audio_info_get_sample_rate($!ai);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &gst_discoverer_audio_info_get_type,
      $n,
      $t
    );
  }

}

our subset GstDiscovererContainerInfoAncestry is export of Mu
  where GstDiscovererContainerInfo | GstDiscovererStreamInfoAncestry;

class GStreamer::PBUtils::Discoverer::ContainerInfo is GStreamer::PBUtils::Discoverer::StreamInfo {
  has GstDiscovererContainerInfo $!ci;

  submethod BUILD (:$container-discoverer) {
    self.setGstDiscovererContainerInfo($container-discoverer)
      if $container-discoverer;
  }

  method setGstDiscovererContainerInfo (GstDiscovererContainerInfoAncestry $_) {
    my $to-parent;

    $!ci = do {
      when GstDiscovererContainerInfo {
        $to-parent = cast(GstDiscovererStreamInfo, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstDiscovererContainerInfo, $_);
      }
    }
    self.setGstDiscovererStreamInfo($to-parent);
  }

  method GStreamer::Raw::Definitions::GstDiscovererContainerInfo
    is also<GstDiscovererContainerInfo>
  { $!ci }

  multi method new (
    GstDiscovererContainerInfoAncestry $container-discoverer,
                                       :$ref       = True
  ) {
    return Nil unless $container-discoverer;

    my $o = self.bless( :$container-discoverer );
    $o.ref if $ref;
    $o;
  }

  method get_streams (:$glist = False, :$raw = False) is also<get-streams> {
    my $sl  = gst_discoverer_container_info_get_streams($!ci),
    my $ret = returnGList(
      $sl,
      $glist,
      $raw,
      GstDiscovererStreamInfo,
      GStreamer::PBUtils::Discoverer::StreamInfo
    );
    GStreamer::PBUtils::Discoverer::StreamInfo.list_free($sl) unless $raw;
    $ret;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &gst_discoverer_container_info_get_type,
      $n,
      $t
    );
  }

}

our subset GstDiscovererSubtitleInfoAncestry is export of Mu
  where GstDiscovererSubtitleInfo | GstDiscovererStreamInfoAncestry;

class GStreamer::PBUtil::Discoverer::SubtitleInfo {
  has GstDiscovererSubtitleInfo $!si;

  submethod BUILD (:$subtitle-discoverer) {
    self.setGstDiscovererSubtitleInfo($subtitle-discoverer)
      if $subtitle-discoverer;
  }

  method setGstDiscovererSubtitleInfo (GstDiscovererSubtitleInfoAncestry $_) {
    my $to-parent;

    $!si = do {
      when GstDiscovererSubtitleInfo {
        $to-parent = cast(GstDiscovererStreamInfo, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstDiscovererSubtitleInfo, $_);
      }
    }
    self.setGstDiscovererStreamInfo($to-parent);
  }

  method GStreamer::Raw::Definitions::GstDiscovererSubtitleInfo
    is also<GstDiscovererSubtitleInfo>
  { $!si }

  multi method new (
    GstDiscovererSubtitleInfoAncestry $subtitle-discoverer,
                                       :$ref       = True
  ) {
    return Nil unless $subtitle-discoverer;

    my $o = self.bless( :$subtitle-discoverer );
    $o.ref if $ref;
    $o;
  }

  method get_language is also<get-language> {
    gst_discoverer_subtitle_info_get_language($!si);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &gst_discoverer_subtitle_info_get_type,
      $n,
      $t
    );
  }

}

our subset GstDiscovererVideoInfoAncestry is export of Mu
  where GstDiscovererVideoInfo | GstDiscovererStreamInfoAncestry;

class GStreamer::PBUtil::Discoverer::VideoInfo {
  has GstDiscovererVideoInfo $!vi;

  submethod BUILD (:$video-discoverer) {
    self.setGstDiscovererVideoInfo($video-discoverer) if $video-discoverer;
  }

  method setGstDiscovererVideoInfo (GstDiscovererVideoInfoAncestry $_) {
    my $to-parent;

    $!vi = do {
      when GstDiscovererVideoInfo {
        $to-parent = cast(GstDiscovererStreamInfo, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstDiscovererVideoInfo, $_);
      }
    }
    self.setGstDiscovererStreamInfo($to-parent);
  }

  method GStreamer::Raw::Definitions::GstDiscovererVideoInfo
    is also<GstDiscovererVideoInfo>
  { $!vi }

  multi method new (
    GstDiscovererVideoInfoAncestry $video-discoverer,
                                   :$ref             = True
  ) {
    return Nil unless $video-discoverer;

    my $o = self.bless( :$video-discoverer );
    $o.ref if $ref;
    $o;
  }

  method get_bitrate is also<get-bitrate> {
    gst_discoverer_video_info_get_bitrate($!vi);
  }

  method get_depth is also<get-depth> {
    gst_discoverer_video_info_get_depth($!vi);
  }

  method get_framerate_denom is also<get-framerate-denom> {
    gst_discoverer_video_info_get_framerate_denom($!vi);
  }

  method get_framerate_num is also<get-framerate-num> {
    gst_discoverer_video_info_get_framerate_num($!vi);
  }

  method get_height is also<get-height> {
    gst_discoverer_video_info_get_height($!vi);
  }

  method get_max_bitrate is also<get-max-bitrate> {
    gst_discoverer_video_info_get_max_bitrate($!vi);
  }

  method get_par_denom is also<get-par-denom> {
    gst_discoverer_video_info_get_par_denom($!vi);
  }

  method get_par_num is also<get-par-num> {
    gst_discoverer_video_info_get_par_num($!vi);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &gst_discoverer_video_info_get_type,
      $n,
      $t
    );
  }

  method get_width is also<get-width> {
    gst_discoverer_video_info_get_width($!vi);
  }

  method is_image is also<is-image> {
    so gst_discoverer_video_info_is_image($!vi);
  }

  method is_interlaced is also<is-interlaced> {
    so gst_discoverer_video_info_is_interlaced($!vi);
  }

}

our subset GstDiscovererInfoAncestry is export of Mu
  where GstDiscovererInfo | GObject;

class GStreamer::PBUtils::Discoverer::Info {
  also does GLib::Roles::Object;

  has GstDiscovererInfo $!di;

  submethod BUILD (:$discoverer-info) {
    self.setGstDiscovererInfo($discoverer-info) if $discoverer-info;
  }

  method setGstDiscovererInfo (GstDiscovererInfoAncestry $_) {
    my $to-parent;

    $!di = do {
      when GstDiscovererInfo {
        $to-parent = cast(GObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstDiscovererInfo, $_);
      }
    }
    self!setObject($to-parent);
  }

  method GStreamer::Raw::Definitions::GstDiscovererInfo
    is also<GstDiscovererInfo>
  { $!di }

  multi method new (GstDiscovererInfoAncestry $discoverer-info, :$ref = True) {
    return Nil unless $discoverer-info;

    my $o = self.bless( :$discoverer-info );
    $o.ref if $ref;
    $o;
  }

  method copy (:$raw = False) {
    my $c = gst_discoverer_info_copy($!di);

    $c ??
      ( $raw ?? $c !! GStreamer::PBUtils::Discoverer::Info.new_($c, :!ref) )
      !!
      Nil;
  }

  method from_variant (
    GStreamer::PBUtils::Discoverer::Info:U:
    GVariant() $v,
               :$raw = False
  )
    is also<from-variant>
  {
    my $di = gst_discoverer_info_from_variant($v);

    $di ??
      ( $raw ?? $di !! GStreamer::PBUtil::Discoverer::Info.new($di, :!ref) )
      !!
      Nil;
  }

  method get_audio_streams (:$glist = False, :$raw = False) is also<get-audio-streams> {
    my $as  = gst_discoverer_info_get_audio_streams($!di);
    my $ret = returnGList(
      $as,
      $glist,
      $raw,
      GstDiscovererAudioInfo,
      GStreamer::PBUtils::Discoverer::AudioInfo
    );
    GStreamer::PBUtils::Discoverer::StreamInfo.list_free($as) unless $raw;
    $ret;
  }

  method get_container_streams (:$glist = False, :$raw = False)
    is also<get-container-streams>
  {
    my $cs  = gst_discoverer_info_get_container_streams($!di);
    my $ret = returnGList(
      $cs,
      $glist,
      $raw,
      GstDiscovererContainerInfo,
      GStreamer::PBUtils::Discoverer::ContainerInfo
    );
    GStreamer::PBUtils::Discoverer::StreamInfo.list_free($cs) unless $raw;
    $ret;
  }

  method get_duration is also<get-duration> {
    gst_discoverer_info_get_duration($!di);
  }

  method get_live is also<get-live> {
    so gst_discoverer_info_get_live($!di);
  }

  # DEPRECATED!
  # method get_misc {
  #   gst_discoverer_info_get_misc($!di);
  # }

  method get_missing_elements_installer_details is also<get-missing-elements-installer-details> {
    CStringArrayToArray(
      gst_discoverer_info_get_missing_elements_installer_details($!di)
    );
  }

  method get_result is also<get-result> {
    GstDiscovererResultEnum( gst_discoverer_info_get_result($!di) );
  }

  method get_seekable is also<get-seekable> {
    so gst_discoverer_info_get_seekable($!di);
  }

  method get_stream_info (:$raw = False) is also<get-stream-info> {
    my $si = gst_discoverer_info_get_stream_info($!di);

    $si
      ?? (
           $raw ?? $si
                !! GStreamer::PBUtils::Discoverer::StreamInfo.new(
                     $si,
                     :!ref
                   )
         )
      !! Nil;

  }

  method get_stream_list (:$glist = False, :$raw = False)
    is also<get-stream-list>
  {
    my $sl = gst_discoverer_info_get_stream_list($!di);
    my $ret = returnGList(
      $sl,
      $glist,
      $raw,
      GstDiscovererStreamInfo,
      GStreamer::PBUtils::Discoverer::StreamInfo
    );
    GStreamer::PBUtils::Discoverer::StreamInfo.list_free($sl) unless $raw;
    $ret;
  }

  method get_streams (GType $streamtype, :$glist = False, :$raw = False)
    is also<get-streams>
  {
    my GType $s = $streamtype;

    my $sl  = gst_discoverer_info_get_streams($!di, $streamtype);
    my $ret = returnGList(
      $sl,
      $glist,
      $raw,
      GstDiscovererStreamInfo,
      GStreamer::PBUtils::Discoverer::StreamInfo
    );
    GStreamer::PBUtils::Discoverer::StreamInfo.list_free($sl) unless $raw;
    $ret;
  }

  method get_subtitle_streams (:$glist = False, :$raw = False)
    is also<get-subtitle-streams>
  {
    my $ss  = gst_discoverer_info_get_subtitle_streams($!di);
    my $ret = returnGList(
      $glist,
      $ss,
      $raw,
      GstDiscovererSubtitleInfo,
      GStreamer::PBUtils::Discoverer::SubtitleInfo
    );
    GStreamer::PBUtils::Discoverer::StreamInfo.list_free($ss) unless $raw;
    $ret;
  }

  method get_tags (:$raw = False) is also<get-tags> {
    my $tl = gst_discoverer_info_get_tags($!di);

    # Transfer: none = :ref
    $tl ??
      ( $raw ?? $tl !! GStreamer::TagList.new($tl) )
      !!
      Nil;
  }

  method get_toc (:$raw = False) is also<get-toc> {
    my $toc = gst_discoverer_info_get_toc($!di);

    # Transfer: none = :ref
    $toc ??
      ( $raw ?? $toc !! GStreamer::Toc.new($toc) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name;
      &gst_discoverer_info_get_type,
      $n,
      $t
     );
  }

  method get_uri is also<get-uri> {
    gst_discoverer_info_get_uri($!di);
  }

  method get_video_streams (:$glist = False, :$raw = False) is also<get-video-streams> {
    my $vsl = gst_discoverer_info_get_video_streams($!di);
    my $ret = returnGList(
      $vsl,
      $glist,
      $raw,
      GstDiscovererVideoInfo,
      GStreamer::PBUtils::Discoverer::VideoInfo
    );
    GStreamer::PBUtils::Discoverer::StreamInfo.list_free($vsl) unless $raw;
    $ret;
  }

  method to_variant (Int() $flags, :$raw = False) is also<to-variant> {
    my GstDiscovererSerializeFlags $f = $flags;

    my $v = gst_discoverer_info_to_variant($!di, $f);

    $v ??
      ( $raw ?? $v !! GLib::Variant.new($v, :!ref) )
      !!
      Nil;
  }

}
