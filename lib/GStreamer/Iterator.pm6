use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Iterator;

class GStreamer::Iterator {
  has GstIterator $!i;

  submethod BUILD (:$iterator) {
    $!i = $iterator;
  }

  multi method new (GstIterator $iterator) {
    $iterator ?? self.bless( :$iterator ) !! Nil;
  }
  multi method new (
    Int() $size,
    Int() $type,
    GMutex() $lock,
    Int() $master_cookie,
    GstIteratorCopyFunction $copy,
    GstIteratorNextFunction $next,
    GstIteratorItemFunction $item,
    GstIteratorResyncFunction $resync,
    GstIteratorFreeFunction $free
  ) {
    my guint $s = $size;
    my GType $t = $type;
    my guint32 $m = $master_cookie;
    my $iterator = gst_iterator_new(
      $s,
      $t,
      $lock,
      $m,
      $copy,
      $next,
      $item,
      $resync,
      $free
    );

    $iterator ?? self.bless( :$iterator ) !! Nil;
  }

  method new_list (
    Int() $type,
    GMutex() $lock,
    Int() $master_cookie,
    GList() $list,
    GObject() $owner,
    GstIteratorItemFunction $item
  )
    is also<new-list>
  {
    my GType $t = $type;
    my guint32 $m = $master_cookie;
    my $iterator = gst_iterator_new_list(
      $t,
      $lock,
      $m,
      $list,
      $owner,
      $item
    );

    $iterator ?? self.bless( :$iterator ) !! Nil;
  }

  method new_single (GValue() $object) is also<new-single> {
    my $iterator = gst_iterator_new_single($!i, $object);

    $iterator ?? self.bless( :$iterator ) !! Nil;
  }

  method copy (:$raw = False) {
    my $c = gst_iterator_copy($!i);

    $c ??
      ( $raw ?? $c !! GStreamer::Iterator.new($c) )
      !!
      GstIterator;
  }

  method filter (
    GCompareFunc $func,
    GValue() $user_data = gpointer,
    :$raw = False
  ) {
    my $i = gst_iterator_filter($!i, $func, $user_data);

    $i ??
      ( $raw ?? $i !! GStreamer::Iterator.new($i) )
      !!
      GstIterator;
  }

  method find_custom (
    GCompareFunc $func,
    GValue() $elem,
    gpointer $user_data = gpointer
  )
    is also<find-custom>
  {
    so gst_iterator_find_custom($!i, $func, $elem, $user_data);
  }

  method fold (
    GstIteratorFoldFunction $func,
    GValue() $ret,
    gpointer $user_data = gpointer
  ) {
    GstIteratorResultEnum( gst_iterator_fold($!i, $func, $ret, $user_data) );
  }

  method foreach (
    GstIteratorForeachFunction $func,
    gpointer $user_data = gpointer
  ) {
    GstIteratorResultEnum( gst_iterator_foreach($!i, $func, $user_data) );
  }

  method free {
    gst_iterator_free($!i);
  }

  method get_type is also<get-type> {
    state ($n, $t);
    
    unstable_get_type( self.^name, &gst_iterator_get_type, $n, $t );
  }

  method next (GValue() $elem) {
    GstIteratorResultEnum( gst_iterator_next($!i, $elem) );
  }

  method push (GstIterator() $other) {
    gst_iterator_push($!i, $other);
  }

  method resync {
    gst_iterator_resync($!i);
  }

}
