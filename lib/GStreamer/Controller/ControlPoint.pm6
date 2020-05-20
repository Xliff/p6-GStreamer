use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Controller::TimedValueControlSource; # For raw defs

class GStreamer::Controller::ControlPoint {
  has GstControlPoint $!cp;

  submethod BUILD (:$point) {
    $!cp = $point;
  }

  method new (GstControlPoint $point) {
    $point ?? self.bless( :$point ) !! Nil;
  }

  method GStreamer::Raw::Controller::GstControlPoint
    is also<GstControlPoint>
  { $!cp }

  method copy (:$raw = False) {
    my $c = gst_control_point_copy($!cp);

    $c ??
      ( $raw ?? $c !! GStreamer::Controller::ControlPoint.new($c) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_control_point_get_type, $n, $t );
  }

}

sub gst_control_point_get_type ()
  returns GType
  is native(gstreamer-controller)
  is export
{ * }
