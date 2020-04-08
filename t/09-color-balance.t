use v6.c;

use GStreamer::Raw::Types;

use GLib::IOChannel;
use GLib::MainLoop;
use GStreamer::Element;
use GStreamer::Main;
use GStreamer::Parse;

use GStreamer::Roles::Plugins::Playbin;

my %data;

sub update-color-channel ($name, $dir) {
  my $channel = (%data<pipeline>.get_channels){$name};

  return unless $channel;

  my $step = 0.1 * ($channel.max-value - $channel.min-value);
  my $value = %data<pipeline>.get_channel_value($channel);

  $value += $step * $dir;
  $value = $channel.max-value if $value > $channel.max-value;
  $value = $channel.min-value if $value < $channel.min-value;
  %data<pipeline>.set_value($channel, $value);
}

sub print-current-values {
  my @channels = %data<pipeline>.list_channels;

  for @channels {
    # Segfault here. Are structs the same size?
    my $val = %data<pipeline>.get_channel_value($_);
    my $per = 100 * ($val - .min-value ) / (.max-value - .min-value);

    print "{ .label }: { $per }%  ";
  }
  &say();
}

sub handle-keyboard {
  my $str;

  return True unless %data<stdin>.read-line($str, $, $) == G_IO_STATUS_NORMAL;

  given $str.substr(0, 1) {
    when 'c' { update-color-channel(  'CONTRAST', -1) }
    when 'C' { update-color-channel(  'CONTRAST',  1) }
    when 'b' { update-color-channel('BRIGHTNESS', -1) }
    when 'B' { update-color-channel('BRIGHTNESS',  1) }
    when 'h' { update-color-channel(       'HUE', -1) }
    when 'H' { update-color-channel(       'HUE',  1) }
    when 's' { update-color-channel('SATURATION', -1) }
    when 'S' { update-color-channel('SATURATION',  1) }

    when 'q' | 'Q' { %data<mainloop>.quit }
  }
  print-current-values;
}

sub MAIN {
  GStreamer::Main.init;

  say q:to/END/;
    USAGE: Choose one of the following options, then press enter:
     'C' to increase contrast, 'c' to decrease contrast
     'B' to increase brightness, 'b' to decrease brightness
     'H' to increase hue, 'h' to decrease hue
     'S' to increase saturation, 's' to decrease saturation
     'Q' to quit
  END

  %data<pipeline> = GStreamer::Parse.launch(
    'playbin uri=https://www.freedesktop.org/software/gstreamer-sdk/data/media/sintel_trailer-480p.webm'
  ) but GStreamer::Roles::Plugins::Playbin;

  %data<stdin> = GLib::IOChannel.unix_new($*IN.native-descriptor);
  %data<stdin>.add_watch(G_IO_IN, -> *@a --> gboolean {
    CATCH { default { .message.say } }
    handle-keyboard;
    1
  });

  if %data<pipeline>.set_state(GST_STATE_PLAYING) == GST_STATE_CHANGE_FAILURE {
    say 'Unable to set the pipeline to the playing state!';
    %data<pipeline>.unref;
    exit 1;
  }
  print-current-values;

  ( %data<mainloop> = GLib::MainLoop.new ).run;

  LEAVE {
    %data<pipeline>.set-state(GST_STATE_NULL) if %data<pipeline>.defined;
    for %data.values {
      .unref if .defined
    }
  }
}
