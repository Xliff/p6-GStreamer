use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::StreamCollection;

use GStreamer::Object;
use GStreamer::Stream;

our subset GstStreamCollectionAncestry is export of Mu
  where GstStreamCollection | GstObject;

class GStreamer::StreamCollection is GStreamer::Object {
  has GstStreamCollection $!sc;

  submethod BUILD (:$collection) {
    self.setStreamCollection($collection) if $collection.defined;
  }

  method setStreamCollection(GstStreamCollectionAncestry $_) {
    my $to-parent;
    $!sc = do {
      when GstStreamCollection {
        $to-parent = cast(GstObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstStreamCollection, $_);
      }
    }
    self.setGstObject($to-parent);
  }

  method GStreamer::Raw::Definitions::GstStreamCollection
    is also<GstStreamCollection>
  { $!sc }

  multi method new (GstStreamCollectionAncestry $collection) {
    $collection ?? self.bless( :$collection ) !! Nil;
  }
  multi method new (Str() $upstream_id) {
    my $collection = gst_stream_collection_new($upstream_id);

    $collection ?? self.bless( :$collection ) !! Nil;
  }

  # Is originally:
  # GstStreamCollection, GstStream, GParamSpec, gpointer
  method stream-notify {
    self.connect-stream-notify($!sc);
  }

  method add_stream (GstStream() $stream) is also<add-stream> {
    so gst_stream_collection_add_stream($!sc, $stream);
  }

  method get_size is also<get-size> {
    gst_stream_collection_get_size($!sc);
  }

  method get_stream (Int() $index, :$raw = False) is also<get-stream> {
    my guint $i = $index;
    my $s = gst_stream_collection_get_stream($!sc, $i);

    $s ??
      ( $raw ?? $s !! GStreamer::Stream.new($s) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_stream_collection_get_type, $n, $t );
  }

  method get_upstream_id
    is also<
      get-upstream-id
      upstream_id
      upstream-id
    >
  {
    gst_stream_collection_get_upstream_id($!sc);
  }

}
