use v6.c;

use GTK::Compat::Types;
use GStreamer::Raw::Types;

use GLib::Quark;

use GStreamer::Caps;
use GStreamer::ElementFactory;
use GStreamer::Pad;
use GStreamer::Main;
use GStreamer::Message;
use GStreamer::Pipeline;
use GStreamer::Value;

sub print-caps ($caps, $pfx) {
  return unless $caps.defined;

  if $caps.is-any {
    say "{ $pfx }ANY";
    return;
  }
  if $caps.is-empty {
    say "{ $pfx }EMPTY ";
    return;
  }

  for ^$caps.get-size {
    my $s = $caps.get-structure($_);

    say "{ $pfx }{ $s.name }";
    $s.foreach(-> *@a --> gboolean {
      CATCH { default { .message.say } }

      my $v = GStreamer::Value.new( @a[1] );
      my $s = $v.serialize;

      say "{ $pfx }{ GLib::Quark.to_string( @a[0] ).fmt('%15s') }: { $s }";
      1;
    });
  }
}

sub print-pad-templates-information ($f) {
  say "Pad Templates for { $f.longname }:";
  say '  none' && return unless $f.num-pad-templates;

  for $f.static-pad-templates -> $pt {
    my $cs = do given $pt.direction {
      when GST_PAD_SRC  { '  SRC template:'        }
      when GST_PAD_SINK { '  SINK template:'       }
      default           { '  UNKNOWN!!! template:' }
    }
    say "{ $cs } { $pt.name-template }";

    # Unless $pt.get is called, $pt will not contain .static_caps data!
    # This is not necessary in the C version.
    my $ppt = $pt.get;

    $cs = do given $pt.presence {
      when GST_PAD_ALWAYS    { 'Always'     }
      when GST_PAD_SOMETIMES { 'Sometimes'  }
      when GST_PAD_REQUEST   { 'On request' }
      default                { 'UNKNOWN!!!' }
    }
    say "    Availability: { $cs }";

    my $sc = $pt.static-caps;
    if $sc.defined && $sc.string {
      say "    Capabilities:";
      print-caps( (my $caps = $sc.get), ' ' x 6);
      $caps.unref;
    }

    say '';
  }
}

sub print-pad-capabilities ($e, $p) {
  unless ( my $pad = $e.get-static-pad($p) ) {
    say "Could not retrieve pad: { $p }";
    exit 1;
  }

  my $caps = $pad.current-caps;
  $caps = $pad.query-caps unless $caps;

  say "Caps for the { $p } pad:";
  print-caps($caps, ' ' x 6);
  .unref for $caps, $pad;
}

sub MAIN {
  GStreamer::Main.init;

  my $source-factory = GStreamer::ElementFactory.find('audiotestsrc');
  my $sink-factory = GStreamer::ElementFactory.find('autoaudiosink');
  unless $source-factory && $sink-factory {
    say 'Not all element factories could be created.';
    exit 1;
  }

  print-pad-templates-information($_) for $source-factory, $sink-factory;

  my $source   = $source-factory.create('source');
  my $sink     = $sink-factory.create('sink');
  my $pipeline = GStreamer::Pipeline.new('test-pipeline');

  unless $source && $sink && $pipeline {
    say 'not all elements could be created.';
    exit 1;
  }

  $pipeline.add-many($source, $sink);
  unless $source.link($sink) {
    say 'Elements could not be linked.';
    exit 1;
  }

  say 'In NULL state:';
  print-pad-capabilities($sink, 'sink');

  say 'Unable to set the pipeline to the playing state (check the bus for error messages).'
    if $pipeline.set-state(GST_STATE_PLAYING) == GST_STATE_CHANGE_FAILURE;

  my ($bus, $terminate) = ($pipeline.bus, False);

  repeat {
    my $msg = $bus.timed-pop-filtered(
      GST_CLOCK_TIME_NONE,
      [+|](GST_MESSAGE_ERROR, GST_MESSAGE_EOS, GST_MESSAGE_STATE_CHANGED)
    );

    if $msg.defined {
      given $msg.type {
        when GST_MESSAGE_ERROR {
          my ($error, $debug) = $msg.parse-error;
          say "Error received from element {$msg.src.name}: {$error.message}";
          say "Debugging information: {$debug // 'none'}";
          $terminate = True;
        }

        when GST_MESSAGE_EOS {
          say 'End-Of-Stream reached';
          $terminate = True;
        }

        when GST_MESSAGE_STATE_CHANGED {
          if +$msg.src.p == +$pipeline {
            my ($os, $ns, $ps) = $msg.parse-state-changed;
            my ($osn, $nsn) = ($os, $ns).map({
              GStreamer::Element.state-get-name($_)
            });
            say "\nPipeline changed from {$osn} to {$nsn}";
            print-pad-capabilities($sink, 'sink');
          }
        }

        default { say 'Unexpected message received' }
      }
      $msg.unref;
    }
  } until $terminate;

  $pipeline.set-state(GST_STATE_NULL);
  .unref for $bus, $pipeline, $source-factory, $sink-factory;
}
