use v6.c;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::Sample;

use GStreamer::MiniObject;

class GStreamer::Sample is GStreamer::MiniObject {
  has GstSample $!s;

  multi method new (GstSample $sample) {
    self.bless( :$sample );
  }
  method new (
    GstBuffer() $buffer,
    GstCaps() $caps,
    GstSegment() $segment,
    GstStructure() $info
  ) {
    self.bless( sample => gst_sample_new($buffer, $caps, $segment, $info) );
  }

  method buffer is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_sample_get_buffer($!s);
      },
      STORE => sub ($, $buffer is copy) {
        gst_sample_set_buffer($!s, $buffer);
      }
    );
  }

  method buffer_list is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_sample_get_buffer_list($!s);
      },
      STORE => sub ($, $buffer_list is copy) {
        gst_sample_set_buffer_list($!s, $buffer_list);
      }
    );
  }

  method caps is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_sample_get_caps($!s);
      },
      STORE => sub ($, $caps is copy) {
        gst_sample_set_caps($!s, $caps);
      }
    );
  }

  method info is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_sample_get_info($!s);
      },
      STORE => sub ($, $info is copy) {
        gst_sample_set_info($!s, $info);
      }
    );
  }

  method segment is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_sample_get_segment($!s);
      },
      STORE => sub ($, $segment is copy) {
        gst_sample_set_segment($!s, $segment);
      }
    );
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_sample_get_type, $n, $t );
  }

}
