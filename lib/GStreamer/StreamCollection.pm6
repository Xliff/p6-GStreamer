use v6.c;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::StreamCollection;

use GStreamer::Object;
use GStreamer::Stream;

our subset StreamCollectionAncestry is export of Mu
  where GstStreamCollection | GstObject;

class GStreamer::StreamCollection is GStreamer::Object {
  has GstStreamCollection $!sc;

  submethod BUILD (:$collection) {
    self.setStreamCollection($collection) if $collection.defined;
  }

  method setStreamCollection(StreamCollectionAncestry $_) {
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

  method GStreamer::Raw::Types::GStreamCollection
  { $!sc }

  multi method new (GstStreamCollection $collection) {
    self.bless( :$collection );
  }
  multi method new (Str() $upstream_id) {
    self.bless( collection => gst_stream_collection_new($upstream_id) );
  }

  method add_stream (GstStream() $stream) {
    so gst_stream_collection_add_stream($!sc, $stream);
  }

  method get_size {
    gst_stream_collection_get_size($!sc);
  }

  method get_stream (Int() $index, :$raw = False) {
    my guint $i = $index;
    my $s = gst_stream_collection_get_stream($!sc, $i);

    $s ??
      ( $raw ?? $s !! GStreamer::Stream.new($s) )
      !!
      Nil;
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_stream_collection_get_type, $n, $t );
  }

  method get_upstream_id {
    gst_stream_collection_get_upstream_id($!sc);
  }

}
