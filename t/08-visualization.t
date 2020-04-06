use v6.c;

use GStreamer::Raw::Types;

use GLib::Object::IsType;
use GLib::Value;

use GStreamer::ElementFactory;
use GStreamer::Main;
use GStreamer::Parse;
use GStreamer::Registry;

sub filter-vis-features ($f, $d) {
  CATCH { default { .message.say } }

  my $pf = GStreamer::ElementFactory.new($f);
  return 0 unless is_type($f, GStreamer::ElementFactory);
  return 0 unless $pf.get-klass eq 'Visualization';
  return 1;
}

sub MAIN {
  GStreamer::Main.init;

  my $selected-factory;
  my $reg = GStreamer::Registry.new;

  say "Available visualization plugins:";
  for $reg.feature-filter(-> *@a --> gboolean { filter-vis-features(|@a) }, :raw) {
    my $ef = GStreamer::ElementFactory.new($_);
    my $name = $ef.get-longname;

    say "  $name";
    $selected-factory = $ef
      if $selected-factory.defined.not || $name.starts-with('GOOM')
  }

  unless $selected-factory {
    say 'No visualization plugins found!';
    exit -1;
  }

  say "Selected '{ $selected-factory.get-longname }'";

  my $vis-plugin = $selected-factory.create;
  die 'Could not initialize visualization plugin!' unless $vis-plugin;

  my $pipeline = GStreamer::Parse.launch(
    'playbin uri=http://radio.hbr1.com:19800/ambient.ogg'
  );

  die 'Could not create pipeline!' unless $pipeline;

  # $flags | GST_PLAY_FLAGS_VIS
  my $flags = ($pipeline.prop_get_uint('flags') // 0) +| (1 +< 3);
  $pipeline.prop_set_uint('flags', $flags);
  $pipeline.prop_set_ptr('vis-plugin', $vis-plugin.p);
  $pipeline.set_state(GST_STATE_PLAYING);

  my $bus = $pipeline.bus;
  my $msg = $bus.timed-pop-filtered(
    GST_CLOCK_TIME_NONE,
    GST_MESSAGE_ERROR +| GST_MESSAGE_EOS
  );

  $msg.unref if $msg;
  $pipeline.set_state(GST_STATE_NULL);
  .unref for $bus, $pipeline;
}
