use v6.c;

use GStreamer::Raw::Types;

use GLib::Convert;
use GLib::MainLoop;
use GLib::Object::IsType;
use GStreamer::DateTime;
use GStreamer::Main;
use GStreamer::Player;
use GStreamer::Player::AudioInfo;
use GStreamer::Player::MainContextSignalDispatcher;
use GStreamer::Player::MediaInfo;
use GStreamer::Player::SubtitleInfo;
use GStreamer::Player::VideoInfo;
use GStreamer::URI;

my %data;

constant VOLUME_STEPS = 20;

sub GENERATE-USAGE ($, |) {
  my $usage = &*GENERATE-USAGE(&MAIN, &MAIN.signature);

  $usage ~~ s/'[<items> ...]'/FILE1|URI1 [FILE2|URI2] [FILE3|URI3] .../;
  $usage;
}

sub usage {
  GENERATE-USAGE($).say
}

sub next-item {
  if !play-next() {
    say "Reached end of play list.";
    %data<mainloop>.quit;
  }
}

sub on-end {
  CATCH { default { .message.say } }
  &say();
  next-item;
}

sub on-error ($, $e, $) {
  CATCH { default { .message.say } }
  warn "ERROR { $e.message } for { %data<uris>[%data<cur-idx>] }";
  %data<repeat> = False;
  next-item;
}

sub on-update ($, $pos, $) {
  CATCH { default { .message.say } }
  my $dur = %data<player>.duration;

  return unless $pos == -1 || $dur <= 0;

  my $ps = $pos.fmt("{ GST_TIME_FORMAT }", |time-args($pos)).substr(0, 8);
  my $ds = $dur.fmt("{ GST_TIME_FORMAT }", |time-args($dur)).substr(0, 8);
  say "{ $ps } / { $ds } { ' ' x 63 }";
}

sub on-state-changed ($, $s, $) {
  say "State changed:  { GStreamer::Player::State.get-name($s)  }";
}

sub print-one-tag ($l, $t) {
  my $num-tags = $l.get-tag-size($t);

  for ^$num-tags {
    my $v = $l.get-value-index($t, $_);

    say "    { $t } : {
      do if $v.type == GStreamer::DateTime.get-type {
        my $dt = GStreamer::DateTime.new( cast(GstDateTime, $v.boxed) );
        die 'Could not retrieve date time value!' unless $dt;

        "{ $dt.to-iso8601-string }";
      } elsif $v.type ∈ GTypeEnum.enums.values {
        "{ $v.value }";
      } else {
        "tag of type '{ get_gtype_name($v) }'";
      }
    }";
  }
}

multi sub print-video-info {
  samewith( %data<player>.get-current-video-track );
}
multi sub print-video-info ($vi) {
  return unless $vi;

  say qq:to/INFO/;
                   width: { $vi.width }
                  height: { $vi.height }
             max-bitrate: { $vi.max-bitrate }
               framerate: { my $f = $vi.framerate; ($f[0] / $f[1]).fmt('%.2f') }
      pixel-aspect-ratio: { my $a =  $vi.aspect-ratio; "{ $a[0] }:{ $a[1] }" }
    INFO
}

multi sub print-audio-info {
  samewith( %data<player>.get-current-audio-track );
}
multi sub print-audio-info ($ai) {
  return unless $ai;

  say qq:to/INFO/;
      sample rate : { $ai.sample-rate }
         channels : { $ai.channels }
      max_bitrate : { $ai.max-bitrate }
          bitrate : { $ai.bitrate }
         language : { $ai.language }
    INFO
}

multi sub print-subtitle-info {
  samewith( %data<player>.get-current-subtitle-track );
}
multi sub print-subtitle-info ($si) {
  return unless $si;
  say "  language : { $si.get-language }";
}

sub print-all-stream-info ($i) {
  say qq:to/INFO/;
    URI : { $i.get-uri }
    Duration: { sprintf("{ GST_TIME_FORMAT }", |time-args($i.get-duration)) }
    Global taglist:
    INFO

  if $i.get-tags() -> $t {
    print-one-tag($_) for $t;
  } else {
    say '  (nil) ';
  }

  my $list = $i.get-stream-list;
  return unless $list;

  say 'All Stream information';
  for $list.kv -> $k, $v {
    my $t = $v.get-stream-type;
    say qq:to/SINFO/;
       Stream # { $k + 1 }
        type : { $t }_{ $v.get-index }
      SINFO
    if $v.get-tags -> $t {
      say '  taglist : ';
      print-one-tag($_) for $t;
    }

    my $si = $v.GstPlayerStreamInfo;
    if $t eq 'video' {
      print-video-info( GStreamer::Player::VideoInfo.new($si) )
    } elsif 'audio' {
      print-audio-info( GStreamer::Player::AudioInfo.new($si) )
    } else {
      print-subtitle-info( GStreamer::Player::SubtitleInfo.new($si) )
    }
  }
}

sub print-common ($i, \c, $g, &p) {
  my $list = $i."{ $g }"();
  return unless $list;

  for $list {
    my $si = c.new($_);

    say "{ $si.get-stream-type }_{ $si.get-index } #";
    &p($i);
  }
}

sub print-all-video-stream ($i) {
  my \C := GStreamer::Player::VideoInfo;

  say "All video streams: ";
  print-common($i, C, 'get-video-streams', &print-audio-info);
}

sub print-all-subtitle-stream ($i) {
  my \C := GStreamer::Player::SubtitleInfo;

  say "All subtitle streams: ";
  print-common($i, C, 'get-subtitle-streams', &print-audio-info);
}

sub print-all-audio-stream ($i) {
  my \C := GStreamer::Player::AudioInfo;

  say "All audio streams: ";
  print-common($i, C, 'get-audio-streams', &print-audio-info);
}

sub print-current-tracks {
  say "Current video track:\n{    print-video-info    }";
  say "Current audio track:\n{    print-audio-info    }";
  say "Current subtitle track:\n{ print-subtitle-info }";
}

sub print-media-info ($mi) {
  print-all-stream-info($mi)    ; &say();
  print-all-video-stream($mi)   ; &say();
  print-all-audio-stream($mi)   ; &say();
  print-all-subtitle-stream($mi); &say();
}

sub on-media-update ($, $i, $) {
  CATCH { default { .message.say } }

  once {
    print-media-info( GStreamer::Player::MediaInfo.new($i) );
    print-current-tracks;
  }
}

sub play-new (@uris, $volume) {
  %data<uris cur-idx> = (@uris, -1);
  %data<dispatcher> = GStreamer::Player::MainContextSignalDispatcher.new();
  %data<player> = GStreamer::Player.new( %data<dispatcher> );

  %data<player>.position-updated.tap(   -> *@a { on-update(        |@a ) });
  %data<player>.state-changed.tap(      -> *@a { on-state-changed( |@a ) });
  %data<player>.error.tap(              -> *@a { on-error(         |@a ) });
  %data<player>.media-info-updated.tap( -> *@a { on-media-update(  |@a ) });
  %data<player>.end-of-stream.tap(      -> *@a { on-end                  });

  %data<player>.buffering.tap(-> *@a {
    CATCH { default { .message.say } }
    say "Buffering: { @a[1] }"
  });

  %data<mainloop> = GLib::MainLoop.new;
  %data<desired-state> = GST_STATE_PLAYING;

  relative-vol($volume - 1e0);

  Nil;
}

sub play-free {
  %data{$_}.unref for <player loop>;
}

sub relative-vol ($vs) {
  my $vol = %data<player>.volume;

  $vol = ($vol + $vs).round * VOLUME_STEPS / VOLUME_STEPS;
  $vol = 0e0  if $vol < 0e0;
  $vol = 10e0 if $vol > 10e0;
  %data<player>.volume = $vol;

  say "Volume: { ($vol * 100e0).fmt('%.0f') }%                  ";
}

sub play-uri-get-display-name ($u) {
  do if GStreamer::URI.has-protocol($u, 'file') {
    GLib::Convert.filename-from-uri($u);
  } elsif GStreamer::URI.has_protocol($u, 'pushfile') {
    GLib::Convert.filename-from-uri( $u.substr(4) )
  } else {
    $u
  }
}

sub play-uri ($u) {
  #play-reset;

  say "Now playing { play-uri-get-display-name($u) }";
  %data<player>.uri = $u;
  %data<player>.play;
}

sub play-next {
  if %data<cur-idx> + 1 >= %data<uris>.elems {
    return False unless %data<repeat>;
    say 'Looping playlist';
    %data<play>.cur-idx = -1;
  }
  play-uri( %data<uris>[ ++%data<cur-idx> ] );
  True;
}

sub play-prev {
  return False if %data<cur-idx>.not || %data<uris>.elems < 1;
  play-uri( %data<uris>[ --%data<cur-idx> ] );
  True;
}

sub do-play {
  say "{ .fmt('%4u') } : { %data<playlist>[$_] }" for ^%data<playlist>;
  return unless play-next;
  %data<mainloop>.run;
}

sub add-to-playlist($f) {
  if GStreamer::URI.is-valid($f) {
    %data<playlist>.push: $f;
    return;
  }

  if $f.IO.d {
    %data<playlist>.push($_) for $f.IO.dir(test => *.IO.f);
    return;
  }

  if ( my $uri = GLib::Convert.filename-to-uri($f) ) {
    %data<playlist>.push: $uri;
  } else {
    say "Could not make URI out of filename '{ $uri }'";
  }
}

sub toggle-paused {
  %data<desired-state> = do given %data<desired-state> {
    when GST_STATE_PLAYING { %data<player>.pause; GST_STATE_PAUSED;  }
    when GST_STATE_PAUSED  { %data<player>.play;  GST_STATE_PLAYING; }
  }
}

sub relative-seek ($per) {
  return unless $per ~~ -1e0 .. 1e0;

  my ($pos, $dur) = %data<player>.get_data_int64('position', 'duration');

  if $dur < 0 {
    say "\nCould not seek.";
    return;
  }

  $pos += $dur * $per;
  $pos = 0 if $pos < 0;
  %data<player>.seek($pos);
}

sub on-key ($key, $data) {
  given $key.substr(0, 1).lc {
    when 'i'    { my $media-info = %data<player>.get-media-info;
                  if $media-info {
                    print-media-info($media-info);
                    print-current-tracks;
                  }
                }
    when ' '    { toggle-paused         }
    when 'q'    { %data<mainloop>.quit  }
    when '<'    { play-prev             }
    when '>'    { if play-next.not {
                    say "\nReached end of play list.";
                    %data<mainloop>.quit;
                  }
                }
    when '\033' { %data<mainloop>.quit if $key.chars == 1; }

    default {
      when $key eq GST_PLAY_KB_ARROW_RIGHT { relative-seek( 0.08)            }
      when $key eq GST_PLAY_KB_ARROW_LEFT  { relative-seek(-0.01)            }
      when $key eq GST_PLAY_KB_ARROW_UP    { relative-vol( 1 / VOLUME_STEPS) }
      when $key eq GST_PLAY_KB_ARROW_DOWN  { relative-vol(-1 / VOLUME_STEPS) }

      default                              { say "  code { .fmt('%3d') }"
                                               for $key.comb                 }
    }
  }
}

sub print-version {
  say "\n10-player.t version v0.0.1";
  exit;
}

sub MAIN (
  Bool :$version,                #= Print version information and exit
  Bool :$shuffle,                #= Shuffle playlist
  Bool :$interractive,           #= Interactive control via keyboard
  Num  :$volume         = 1e0,   #= Volume
  Str  :$playlist,               #= Playlist file containing input media files
  Bool :loop(:$repeat),          #= Loop playback
  *@items
) {
  print-version if $version;
  if $playlist {
    die "Playlist file '{ $playlist }' does not exist!"
      unless $playlist.IO.e;
  }

  add-to-playlist($_) for ($playlist ?? $playlist.IO.lines !! @items);
  %data<playlist>.sort({ rand }) if $shuffle;

  play-new(%data<playlist>, $volume);
  %data<repeat> = $repeat;

  if $interractive {
    #if set-key-handler(&on-key) {
    #  LEAVE { gst_play_kb_set_key_handler (NULL, NULL) }
    #} else {
    #  say "Interractive keyboard handling in terminal not available";
    #}
  }

  do-play;
  #play-free($play);
  &say();
  # # gst_deinit(); # Convert to Raku
}
