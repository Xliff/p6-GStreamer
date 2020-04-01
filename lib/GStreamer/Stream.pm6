use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Stream;

use GStreamer::Object;

use GStreamer::Caps;
use GStreamer::TagList;

our subset GstStreamAncestry is export of Mu
  where GstStream | GstObject;

class GStreamer::Stream is GStreamer::Object {
  has GstStream $!s;

  submethod BUILD (:$stream) {
    self.setStream($stream) if $stream.defined;
  }

  method setStream(GstStreamAncestry $_) {
    my $to-parent;

    $!s = do {
      when GstStream {
        $to-parent = cast(GstObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstStream, $_);
      }
    }
    self.setGstObject($to-parent);
  }

  method GStreamer::Raw::Types::GstStream
    is also<GstStream>
  { $!s }

  multi method new (GstStreamAncestry $stream) {
    $stream ?? self.bless( :$stream ) !! Nil;
  }
  multi method new (
    Str() $stream_id,
    GstCaps() $caps,
    Int() $type,
    Int() $flags
  ) {
    my GstStreamType $t = $type;
    my GstStreamFlags $f = $flags;
    my $stream = gst_stream_new($stream_id, $caps, $t, $f);
    
    $stream ?? self.bless( :$stream ) !! Nil;
  }

  method caps (:$raw = False) is rw {
    Proxy.new(
      FETCH => sub ($) {
        my $c = gst_stream_get_caps($!s);

        $c ??
          ( $raw ?? $c !! GStreamer::Caps.new($c) )
          !!
          Nil;
      },
      STORE => sub ($, GstCaps() $caps is copy) {
        gst_stream_set_caps($!s, $caps);
      }
    );
  }

  method stream_flags is rw is also<stream-flags> {
    Proxy.new(
      FETCH => sub ($) {
        GstStreamFlagsEnum( gst_stream_get_stream_flags($!s) );
      },
      STORE => sub ($, Int() $flags is copy) {
        my GstStreamFlags $f = $flags;

        gst_stream_set_stream_flags($!s, $f);
      }
    );
  }

  method stream_type is rw is also<stream-type> {
    Proxy.new(
      FETCH => sub ($) {
        GstStreamTypeEnum( gst_stream_get_stream_type($!s) );
      },
      STORE => sub ($, Int() $stream_type is copy) {
        my GstStreamType $st = $stream_type;

        gst_stream_set_stream_type($!s, $st);
      }
    );
  }

  method tags (:$raw = False) is rw {
    Proxy.new(
      FETCH => sub ($) {
        my $t = gst_stream_get_tags($!s);

        $t ??
          ( $raw ?? $t !! GStreamer::TagList.new($t) )
          !!
          Nil;
      },
      STORE => sub ($, GstTagList() $tags is copy) {
        gst_stream_set_tags($!s, $tags);
      }
    );
  }

  method get_stream_id is also<get-stream-id> {
    gst_stream_get_stream_id($!s);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_stream_get_type, $n, $t );
  }

  method type_get_name (
    GStreamer::Stream:U:
    Int() $type
  ) is also<type-get-name> {
    my GstStreamType $t = $type;

    gst_stream_type_get_name($t);
  }

}
