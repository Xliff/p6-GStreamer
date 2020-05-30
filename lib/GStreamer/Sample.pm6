use v6.c;

use Method::Also;


use GStreamer::Raw::Types;
use GStreamer::Raw::Sample;

use GStreamer::MiniObject;

use GStreamer::Buffer;
use GStreamer::BufferList;
#use GStreamer::Caps;
use GStreamer::Segment;
use GStreamer::Structure;

class GStreamer::Sample is GStreamer::MiniObject {
  has GstSample $!s;

  submethod BUILD (:$sample) {
    self.setSample($sample);
  }

  method setSample (GstSample $_) {
    my $to-parent;

    $!s = do {
      when GstSample {
        $to-parent = cast(GstMiniObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstSample, $_);
      }
    }
    self.setMiniObject($to-parent);
  }

  method GStreamer::Raw::Definitions::GstSample
    is also<GstSample>
  { $!s }

  multi method new (GstSample $sample) {
    $sample ?? self.bless( :$sample ) !! Nil;
  }
  multi method new (
    GstBuffer() $buffer,
    GstCaps() $caps,
    GstSegment() $segment,
    GstStructure() $info
  ) {
    my $sample = gst_sample_new($buffer, $caps, $segment, $info);

    $sample ?? self.bless( :$sample ) !! Nil;
  }

  method buffer (:$raw = False) is rw {
    Proxy.new(
      FETCH => sub ($) {
        my $b = gst_sample_get_buffer($!s);

        $b ??
          ( $raw ?? $b !! GStreamer::Buffer.new($b) )
          !!
          Nil;
      },
      STORE => sub ($, GstBuffer() $buffer is copy) {
        gst_sample_set_buffer($!s, $buffer);
      }
    );
  }

  method buffer_list (:$raw = False) is rw is also<buffer-list> {
    Proxy.new(
      FETCH => sub ($) {
        my $bl = gst_sample_get_buffer_list($!s);

        $bl ??
          ( $raw ?? $bl !! GStreamer::BufferList.new($bl) )
          !!
          Nil;
      },
      STORE => sub ($, GstBufferList() $buffer_list is copy) {
        gst_sample_set_buffer_list($!s, $buffer_list);
      }
    );
  }

  method caps (:$raw = False) is rw {
    Proxy.new(
      FETCH => sub ($) {
        my $c = gst_sample_get_caps($!s);

        $c ??
          ( $raw ?? $c !! GStreamer::Caps.new($c) )
          !!
          Nil;
      },
      STORE => sub ($, GstCaps() $caps is copy) {
        gst_sample_set_caps($!s, $caps);
      }
    );
  }

  method info (:$raw = False) is rw {
    Proxy.new(
      FETCH => sub ($) {
        my $s = gst_sample_get_info($!s);

        $s ??
          ( $raw ?? $s !! GStreamer::Structure.new($s) )
          !!
          Nil;
      },
      STORE => sub ($, GstStructure() $info is copy) {
        gst_sample_set_info($!s, $info);
      }
    );
  }

  method segment (:$raw = False) is rw {
    Proxy.new(
      FETCH => sub ($) {
        my $s = gst_sample_get_segment($!s);

        $s ??
          ( $raw ?? $s !! GStreamer::Segment.new($s) )
          !!
          Nil;
      },
      STORE => sub ($, GstSegment() $segment is copy) {
        gst_sample_set_segment($!s, $segment);
      }
    );
  }

  # cw: I don't really know what to do with GstMiniObject copy methods.
  #     Most objects do NOT have them, but this is one way of handling it.
  proto method copy (|)
  { * }

  multi method copy (:$raw = False) {
    samewith($!s, :$raw);
  }
  multi method copy (GstSample() $s, :$raw = False) {
    my $sample = cast(
      GstSample,
      GStreamer::MiniObject.copy( cast(GstMiniObject, $s), :$raw )
    );

    $sample ??
      ( $raw ?? $sample !! GStreamer::Sample.new($sample) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_sample_get_type, $n, $t );
  }

}
