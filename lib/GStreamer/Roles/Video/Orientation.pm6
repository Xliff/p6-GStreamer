use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Video::Orientation;

role GStreamer::Roles::Video::Orientation {
  has GstVideoOrientation $!vo;

  method roleInit-GstOrientation is also<roleInit_GstOrientation> {
    my \i = findProperImplementor(self.^attributes);

    $!vo = cast( GstVideoOrientation, i.get_value(self) );
  }

  method GStreamer::Raw::Definitions::GstVideoOrientation
  { $!vo }

  method video_orientation_get_type
    is also<video-orientation-get-type>
  {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_video_orientation_get_type, $n, $t );
  }

  proto method get_hcenter (|)
      is also<get-hcenter>
  { * }

  multi method get_hcenter {
    samewith($);
  }
  multi method get_hcenter ($center is rw) {
    my gint $c = 0;
    my $rv = gst_video_orientation_get_hcenter($!vo, $c);

    $center = $c;
    ($rv, $center);
  }

  proto method get_hflip (|)
      is also<get-hflip>
  { * }

  multi method get_hflip {
    samewith($);
  }
  multi method get_hflip ($flip is rw) {
    my gboolean $f = 0;
    my $rv = so gst_video_orientation_get_hflip($!vo, $f);

    $flip = $f.so;
    ($rv, $f);
  }

  proto method get_vcenter (|)
      is also<get-vcenter>
  { * }

  multi method get_vcenter {
    samewith($);
  }
  multi method get_vcenter ($center is rw) {
    my gint $c = 0;
    my $rv = so gst_video_orientation_get_vcenter($!vo, $c);

    $center = $c;
    ($rv, $c);
  }

  proto method get_vflip (|)
      is also<get-vflip>
  { * }

  multi method get_vflip {
    samewith($);
  }
  multi method get_vflip ($flip is rw) {
    my gboolean $f = 0;
    my $rv = so gst_video_orientation_get_vflip($!vo, $f);

    $flip = $f.so;
    ($rv, $flip);
  }

  method set_hcenter (Int() $center) is also<set-hcenter> {
    my gint $c = $center;

    so gst_video_orientation_set_hcenter($!vo, $c);
  }

  method set_hflip (Int() $flip) is also<set-hflip> {
    my gboolean $f = $flip.so.Int;

    so gst_video_orientation_set_hflip($!vo, $f);
  }

  method set_vcenter (Int() $center) is also<set-vcenter> {
    my gint $c = $center;

    so gst_video_orientation_set_vcenter($!vo, $center);
  }

  method set_vflip (Int() $flip) is also<set-vflip> {
    my gboolean $f = $flip.so.Int;

    so gst_video_orientation_set_vflip($!vo, $flip);
  }

}
