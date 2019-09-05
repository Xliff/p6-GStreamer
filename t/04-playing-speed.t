#!/usr/bin/env perl6
use v6.c;

use GTK::Compat::Types;
use GStreamer::Raw::Types;

use GDK::Threads;
use GTK::Compat::IOChannel;
use GTK::Compat::MainLoop;

use GStreamer::Element;
use GStreamer::Event;
use GStreamer::Query;
use GStreamer::Main;
use GStreamer::Parse;

use GStreamer::Roles::Plugins::Playbin;

my %data;

sub reset-sink {
  %data<video-sink> = %data<pipeline>.video-sink
    unless %data<video-sink>.defined;
}

sub send-seek-event {
  my ($pos, $rc) = %data<pipeline>.query-position(GST_FORMAT_TIME, :all);

  unless $rc {
    say 'Unable to retrieve current position.';
    exit 1;
  }

  my @ep = (
    %data<rate>,
    GST_FORMAT_TIME,
    GST_SEEK_FLAG_FLUSH +| GST_SEEK_FLAG_ACCURATE,
    GST_SEEK_TYPE_SET,
    %data<rate> > 0 ?? $pos !! 0,
    GST_SEEK_TYPE_END,
    %data<rate> > 0 ?? 0 !! $pos,
  );
  my $seek-event = GStreamer::Event.new(:seek, |@ep);

  reset-sink;
  %data<video-sink>.send-event($seek-event);
  say "Current rate: { %data<rate> }";
}

sub handle-keyboard {
  CATCH { default { .message.say } }

  my ($in, $, $, $rc) = %data<stdin>.read_line;

  return unless $rc = G_IO_STATUS_NORMAL;

  given $in.substr(0, 1) {
    when 'p' | 'P' {
      %data<playing> .= not;
      %data<pipeline>.set_state(
        %data<playing> ?? GST_STATE_PLAYING !! GST_STATE_PAUSED
      );
    }

    when 's' | 'S' {
      %data<rate> *= $_ eq 'S' ?? 2 !! 0.5;
      send-seek-event;
    }

    when 'D' | 'd' {
      %data<rate> *= -1;
      send-seek-event;
    }

    when 'N' | 'n' {
      reset-sink;
      %data<video-sink>.send-event(
        GStreamer::Event.new(
          :step,
          GST_FORMAT_BUFFERS,
          1,
          %data<rate>.abs,
          True,
          False
        )
      );
      say 'Stepping one frame';
    }

    when 'q'  | 'Q' { %data<loop>.quit }
  }

  # cw: Do we have to worry about freeing $in??
}

sub MAIN  {
  GStreamer::Main.init;

  say q:to/INSTRUCTIONS/;
    USAGE: Choose one of the following options, then press enter:
      'P' to toggle between PAUSE and PLAY
      'S' to increase playback speed, 's' to decrease playback speed
      'D' to toggle playback direction
      'N' to move to next frame (in the current direction, better in PAUSE)
      'Q' to quit
    INSTRUCTIONS

  %data<pipeline> = GStreamer::Parse.launch(
    "playbin uri=https://www.freedesktop.org/software/gstreamer-sdk/data/media/sintel_trailer-480p.webm"
  ) but GStreamer::Roles::Plugins::Playbin;

  %data<stdin> = GTK::Compat::IOChannel.unix_new($*IN.native-descriptor);
  %data<stdin>.add_watch(G_IO_IN, -> *@a --> gboolean { handle-keyboard; 1 });

  if %data<pipeline>.set-state(GST_STATE_PLAYING) == GST_STATE_CHANGE_FAILURE {
    say 'Unable to set the pipeline to the playing state';

    exit 1;
  }
  %data<playing> = True;
  %data<rate> = 1;
  ( %data<loop> = GTK::Compat::MainLoop.new ).run;


  LEAVE {
    %data<pipeline>.set-state(GST_STATE_NULL) if %data<pipeline>.defined;
    for %data<video-sink pipeline io-channel loop> {
      .unref if .defined
    }
  }
}
