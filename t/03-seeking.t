use v6.c;

use GStreamer::Raw::Types;

use GTK::Compat::Value;

use GStreamer::ElementFactory;
use GStreamer::Main;
use GStreamer::Message;
use GStreamer::Query;

my %data;

sub handle_msg ($msg) {
  my ($err, $debug);

  given $msg.type {
    when GST_MESSAGE_ERROR {
      ($err, $debug) = $msg.parse-error;
      say "Error received from element { $msg.src.name }: { $err.message }";
      say "Debugging information: { $debug  }" if $debug;
      %data<terminate> = True;
    }

    when GST_MESSAGE_EOS {
      say "\nEnd-Of-Stream reached.";
      %data<terminate> = True;
    }

    when GST_MESSAGE_DURATION_CHANGED {
      %data<duration> = GST_CLOCK_TIME_NONE;
    }

    when GST_MESSAGE_STATE_CHANGED {
      my ($os, $ns) = $msg.parse-state-changed;
      my ($osn, $nsn) = ($os, $ns).map({
        GStreamer::Element.state-get-name($_)
      });

      if +$msg.src.p == %data<playbin>.GstObject.p {
        say "Pipeline state changed from { $osn } to { $nsn }";

        if %data<playing> = ($ns == GST_STATE_PLAYING) {
          my $query = GStreamer::Query.new(:seeking, GST_FORMAT_TIME);
          if %data<playbin>.query($query) {
            my ($start, $end);
            ($, %data<seek-enabled>, $start, $end) = $query.parse-seeking;
            if %data<seek-enabled> {
              sprintf(
                "Seeking is ENABLED from {GST_TIME_FORMAT} to {GST_TIME_FORMAT}",
                |$start.&time-args, |$end.&time-args
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
    gv_str(
      'https://www.freedesktop.org/software/gstreamer-sdk/data/media/sintel_trailer-480p.webm'
    )
  );

  if %data<playbin>.set_state(GST_STATE_PLAYING) == GST_STATE_CHANGE_FAILURE {
    say 'Unable to set the pipeline to the playing state';
    %data<playbin>.unref;
    exit -1;
  }

  my $bus = %data<playbin>.bus;
  repeat {
    my $msg = $bus.timed-pop-filtered(
      100 * 1e6,
      [+|]( GST_MESSAGE_STATE_CHANGED, GST_MESSAGE_ERROR, GST_MESSAGE_EOS,
            GST_MESSAGE_DURATION_CHANGED )
    );

    if $msg {
      handle_msg($msg);
    } else {
      if %data<playing> {
        my $f = GST_FORMAT_TIME;
        my ($current, $qf) = %data<playbin>.query-position($f, :all);
        say "Could not query current position.\n" unless $qf;

        if %data<duration> == GST_CLOCK_TIME_NONE {
          (%data<duration>, $qf) = %data<playbin>.query-duration($f, :all);
          say 'Could not query current duration' unless $qf;
        }

        sprintf(
          "Position {GST_TIME_FORMAT} / {GST_TIME_FORMAT}\r",
          |$current.&time-args, |%data<duration>.&time-args
        ).print;

        if [&&](
          %data<seek-enabled>,
          %data<seek-done>.not,
          $current > 10sec
        ) {
          say 'Reached 10s, performing seek...';
          %data<playbin>.seek-simple(
            GST_FORMAT_TIME,
            GST_SEEK_FLAG_FLUSH +| GST_SEEK_FLAG_KEY_UNIT,
            30sec
          );
          %data<seek-done> = True;
        }
      }
    }
  } while not %data<terminate>;

  %data<playbin>.set_state(GST_STATE_NULL);
  .unref for $bus, %data<playbin>;
}
