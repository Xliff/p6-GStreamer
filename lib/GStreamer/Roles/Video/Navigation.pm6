use v6.c;

use GStreamer::Raw::Types;
use GStreamer::Raw::Video::Navigation;

use GStreamer::Event;

role GStreamer::Roles::Video::Navigation {
  has GstNavigation $!n;

  method roleInit-Navigation {
    my \i = findProperImplementor(self.^attributes);

    $!n = cast( GstNavigation, i.get_value(self) );
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_navigation_get_type, $n, $t );
  }

  method send_command (Int() $command) {
    my GstNavigationCommand $c = $command;

    gst_navigation_send_command($!n, $c);
  }

  method send_event (GstStructure() $structure) {
    gst_navigation_send_event($!n, $structure);
  }

  method send_key_event (Str() $event, Str() $key) {
    gst_navigation_send_key_event($!n, $event, $key);
  }

  method send_mouse_event (Str() $event, Int() $button, Num() $x, Num() $y) {
    my gint $b = $button;
    my gdouble ($xx, $yy) = ($x, $y);

    gst_navigation_send_mouse_event($!n, $event, $b, $xx, $yy);
  }

}
