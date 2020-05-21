use v6.c;

use GDK::Raw::Enums;
use GStreamer::Raw::Types;

use Cairo;
use GTK::Application;
use GTK::Box;
use GTK::ComboBoxText;
use GTK::DrawingArea;
use GTK::Grid;
use GTK::Label;
use GTK::SpinButton;
use GStreamer::Main;
use GStreamer::Controller::InterpolationControlSource;

my %data;

%data<yval> = [ 0.0, 0.2, 0.8, 0.1, 0.1, 1.0, 0.5 ];

sub clamp ($v, Range $r) {
  max( $r.min, min($r.max, $v) )
}

sub on-graph-draw($widget, $cr, $ud, $r) {
  my $c = Cairo::Context.new($cr);
  my $style = $widget.get-style-context;
  my $alloc = $widget.get-allocation;
  my ($x, $y) = 5 xx 2;
  my ($w, $h) = ($alloc.width, $alloc.height);

  $style.render-background($cr, 0, 0, $w, $h);
  ($w, $h) »-=» (2 * $x, 2 * $y);

  my ($ts, $ts-step) = ( 0, $w / (%data<yval>.elems - 1) );
  %data<cs>.unset-all;
  for %data<yval>[] {
    %data<cs>.set($ts, $_);
    $ts += $ts-step;
  }

  my $data = %data<cs>.get-value-array(0, 1, $w, :raw);
  $c.rgb(0.5, 0.5, 0.5);
  $c.rectangle($x, $y, $w, $h);
  $c.stroke(:preserve);
  $c.rgb(1, 1, 1);
  $c.fill;

  $c.rgb(0, 0, 0);
  $c.line_width = 1;
  $c.move_to($x, $y + $data[0] * $h);
  $c.line_to($x + $_, $y + clamp($data[$_], 0..1) * $h) for ^$w;
  $c.stroke;

  $ts = 0;
  for %data<yval>[] {
    $c.rgb(0, 0, 0);
    $c.arc($x + $ts, $y + $_ * $h, 3.0, 0, 2 * π);
    $c.stroke(:preserve);
    $c.rgb(1, 1, 1);
    $c.fill;
    $ts += $ts-step;
  }

  $r.r = 1;
}

sub MAIN {
  GStreamer::Main.init;

  my $a = GTK::Application.new(
    title  => 'org.genex.gstreamer.controller-graph',
    width  => 320,
    height => 240,
  );

  $a.activate.tap({
    %data<cs> = GStreamer::Controller::InterpolationControlSource.new;
    %data<cs>.mode = GST_INTERPOLATION_MODE_LINEAR;
    $a.window.title = 'GstInterpolationControlSource demo';

    my $layout = GTK::Grid.new;
    my $graph  = GTK::DrawingArea.new;

    $graph.add-events(GDK_POINTER_MOTION_MASK);
    $graph.draw.tap( -> *@a { on-graph-draw(|@a) });
    (.hexpand, .vexpand, .margin-bottom) = (True, True, 3) given $graph;
    $layout.attach($graph, 0, 0, 2, 1);

    my $box = GTK::Box.new-hbox(3);
    (.homogeneous, .margin-bottom) = (True, 3) given $box;
    for %data<yval>[].kv -> $k, $i {
      # Remember, kids! It's never a good idea to use $_ in closures!
      my $spin = GTK::SpinButton.new_with_range(0, 1, 0.05);
      $spin.value = $i;
      $spin.changed.tap({
        %data<yval>[$k] = $spin.value;
        $graph.queue-draw;
      });
      $box.add: $spin;
    }
    $layout.attach($box, 0, 1, 2, 1);

    my $label = GTK::Label.new('Interpolation Mode');
    $layout.attach($label, 0, 2, 1, 1);

    my $combo = GTK::ComboBoxText.new;
    $combo.append-text( .key ) for GstInterpolationModeEnum.enums;
    $combo.active = GST_INTERPOLATION_MODE_LINEAR;
    $combo.changed.tap({
      %data<cs>.mode = $combo.active;
      $graph.queue-draw;
    });
    (.hexpand, .margin-left) = (True, 3) given $combo;
    $layout.attach($combo, 1, 2, 1, 1);

    $a.window.border-width = 6;
    $a.window.add($layout);
    $a.window.show-all;
  });

  $a.run;
}
