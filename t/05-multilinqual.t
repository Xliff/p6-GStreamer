use v6.c;

use GStreamer::Raw::Types;
use GStreamer::Raw::Tags;

use GLib::IOChannel;
use GLib::MainLoop;

use GStreamer::ElementFactory;
use GStreamer::Main;
use GStreamer::Message;

use GStreamer::Plugins::Playbin;

my %data;

sub MAIN {
  GStreamer::Main.init;

  unless %data<playbin> = GStreamer::Plugins::Playbin.new {
    say 'Not all elements could be created.';
    exit 1;
  }

  %data<playbin>.uri = 'https://www.freedesktop.org/software/gstreamer-sdk/data/media/sintel_cropped_multilingual.webm';
  %data<playbin>.flags = %data<playbin>.flags.&setFlags(
    GST_PLAY_FLAG_VIDEO,
    GST_PLAY_FLAG_AUDIO
  ).&unsetFlags(
    GST_PLAY_FLAG_TEXT
  );
  %data<playbin>.connection-speed = 56;

  %data<bus> = %data<playbin>.bus;

  %data<bus>.add_watch(-> *@a --> gboolean {
    handle-message( @a[1] );
    1
  });

  %data<stdin> = GLib::IOChannel.new(:unix, $*IN.native-descriptor);
  %data<stdin>.add_watch(
    G_IO_IN,
    -> *@a --> gboolean { handle-keyboard; 1 }
  );

  if %data<playbin>.set_state(GST_STATE_PLAYING) == GST_STATE_CHANGE_FAILURE {
    say 'Unable to set the pipeline to the playing state.';
    exit 1;
  }

  ( %data<loop> = GLib::MainLoop.new ).run;

  %data<playbin>.set_state(GST_STATE_NULL);
  for <loop stdin bus playbin> {
    unless %data{$_}.defined {
      say "$_ is not defined!";
      next;
    }
    %data{$_}.unref
  }
}

sub analyze-streams {
  CATCH { default { .message.say } }

  %data{$_} = %data<playbin>."{$_}"() for <n-video n-audio n-text>;

  say sprintf(
    "%d video stream(s), %d audio stream(s), %d text stream(s)\n",
    |%data<n-video n-audio n-text>
  );

  for <n-video n-audio n-text> -> $t {
    for ^( %data{$t} ) -> $sn {

      my $tags = %data<playbin>.emit-get-tags(
        "get-{ $t.substr(2) }-tags",
        $sn
      );

      if $tags.defined {
        given $t {
          when 'n-video' {
            say qq:to/VIDEO/;
              video-stream { $sn }:
                codec: { $tags.get_string(GST_TAG_VIDEO_CODEC) // 'unknown' }
              VIDEO
          }

          when 'n-audio' {
            say qq:to/AUDIO/;
              audio-stream { $sn }:
                codec: { $tags.get_string(GST_TAG_AUDIO_CODEC) // 'unknown' }
                language: { $tags.get_string(GST_TAG_LANGUAGE_CODE) // 'unknown' }
                bitrate: { $tags.get_uint(GST_TAG_BITRATE) // 'unknown' }
              AUDIO
          }

          when 'n-text' {
              say qq:to/TEXT/;
                subtitle-stream { $sn }:
                  language: { $tags.get_string(GST_TAG_LANGUAGE_CODE) // 'unknown' }
                TEXT
          }
        }

        #$tags.unref;
      }
    }
  }

  my @current = 'current-' «~« <video audio text>;
  %data{$_} = %data<playbin>."{$_}"() for @current;
  say sprintf(
    "\nCurrently playing video stream %d, audio stream %d and text stream %d\n",
    |%data{@current}
  );
  say "Type any number and hit ENTER to select a different audio stream";
}

sub handle-message($m is copy) {
  CATCH { default { .message.say } }

  $m = GStreamer::Message.new($m);
  given $m.type {

    when GST_MESSAGE_ERROR {
      my ($err, $debug) = $m.parse-error;

      say qq:to/ERROR/;
        Error received from element { $m.src.name }: { $err.message }
        Debugging information: { $debug // 'none' }
      ERROR

      # Memory management of $err and $debug?!
      %data<loop>.quit;
    }

    when GST_MESSAGE_EOS {
      say 'End-Of-Stream reached.';
      %data<loop>.quit
    }

    when GST_MESSAGE_STATE_CHANGED {
      my ($os, $ns, $ps) = $m.parse-state-changed;

      # Once we are in the playing state, analyze the streams.
      analyze-streams if [&&](
        +$m.src.p == +%data<playbin>.GstElement.p,
        $ns == GST_STATE_PLAYING
      );
    }
  }
}

sub handle-keyboard {
  my ($rs, $in) = %data<stdin>.read_line;

  if $rs == G_IO_STATUS_NORMAL {
    if $in !~~ /^ (\d) $$ / {
      say 'Invalid entry.';
    } elsif $in !~~ 0 ..^ %data<n-audio> {
      say 'Index out of bounds';
    } else {
      say "Setting current audio stream to { $in }";
      %data<playbin>.current-audio = $in
    }
  }
}
