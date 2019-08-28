use v6.c;

use GStreamer::Raw::Types;

use GStreamer::ElementFactory;
use GStreamer::Main;
use GStreamer::Message;
use GStreamer::Query;

my $data;

sub handle_msg ($msg) {
  my ($err, $debug);

  given $msg.type {
    when GST_MESSAGE_ERROR {
      ($err, $debug) = $msg.parse-error;
      say "Error received from element { $msg.src.name }: { $error.message }";
      say "Debugging information: { $debug }";
      %data<terminate> = True;
    }

    when GST_MESSAGE_EOS {
      say "End-Of-Stream reached.";
      %data<terminate> = True;
    }

    when GST_MESSAGE_DURATION {
      %data<duration> = GST_CLOCK_TIME_NONE;
    }

    when GST_MESSAGE_STATE_CHANGED {
      my ($os, $ns) = $msg.parse-state-changed;

      if +$msg.src.GstObject.p == %data<playbin>.GstObject.p {
        say "Pipeline state changed from { $os } to { $ns }";
      }

      if %data<playing> = ($ns == GST_STATE_PLAYING) {
        my $query = GStreamer::Query.new-seeking(GST_FORMAT_TIME);
        if %data<playbin>.query($query) {
          my ($start, $end);
          ($, %data<seek-enabled>, $start, $end) = $query.parse-seeking;
          if %data<seek-enabled> {
            sprintf(
              "Seeking is ENABLED from {GST_TIME_FORMAT} to {GST_TIME_FORMAT}",
              $start, $end
            ).say;
          } else {
            say 'Seeking is DISABLED for this stream.';
          }
        } else {
          say 'Seeking query failed.';
        }
        $query.unref;
      }
    }

    default { say 'Unexpected message received.' }
  }

  $msg.unref;
}

sub MAIN {
  GStreamer::Main.init;

  unless %data<playbin> = GStreamer::ElementFactory.make('playbin', 'playbin') {
    say 'Not all elements could be created';
    exit -1;
  }

  %data<playbin>.prop_set(
    'uri',
    'https://www.freedesktop.org/software/gstreamer-sdk/data/media/sintel_trailer-480p.web'
  );

  if %data<playbin>.set_state(GST_STATE_PLAYING) == GST_STATE_CHANGE_FAILURE {
    say 'Unable to set the pipeline to the playing state';
    %data<playbin>.unref;
    exit -1;
  }

  $bus = %data<playbin>.bus;
  loop {
    my $msg = $bus.timed-pop-filtered(
      100 * 1e6,
      [+|]( GST_MESSAGE_STATE_CHANGED, GST_MESSAGE_ERROR, GST_MESSAGE_EOS,
            GST_MESSAGE_DURATION )
    );

    if $msg {
      handle_msg($msg);
    } else {
      if %data<playing> {
        my ($current, $qf) = %data<playbin>.query-position(:all);
        say 'Could not query current position.' unless $qf;

        if %data.duration == GST_CLOCK_TIME_NONE {
          (%data<duration>, $qf) = %data<playbin>.query-duration(:all);
          say 'Could not query duration' unless $qf;
        }

        sprintf(
          "Position {GST_TIME_FORMAT} / {GST_TIME_FORMAT}",
          $current, %data<duration>
        ).say;

        if %data<seel-enabled> && not %data<seek-done> && $current > 10 * 1e9 {
          say 'Reached 10s, performing seek...';
          %data<playbin>.seek-simple(
            GST_FORMAT_TIME,
            GST_SEEK_FLAG_FLUSH +| GST_SEEK_FLAG_KEY_UNIT,
            30 * 1e9
          );
          %data<seek-done> = True;
        }
      }
    }
  } while not %data<terminate>;

  %data<playbin>.set_state(GST_STATE_NULL);
  .unref for $bus, %data<playbin>;
}
