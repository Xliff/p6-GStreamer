use v6.c;

use Method::Also;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::Iterator;

class GStreamer::Iterator {
  has GstIterator $!i;

  submethod BUILD (:$iterator) {
    $!i = $iterator;
  }

  method new (
    guint $size,
    GType $type,
    GMutex $lock,
    guint32 $master_cookie,
    GstIteratorCopyFunction $copy,
    GstIteratorNextFunction $next,
    GstIteratorItemFunction $item,
    GstIteratorResyncFunction $resync,
    GstIteratorFreeFunction $free
  ) {
    self.bless(
      iterator => gst_iterator_new(
        $size,
        $type,
        $lock,
        $master_cookie,
        $copy,
        $next,
        $item,
        $resync,
        $free
      )
    );
  }

  method new_list (
    GType $type,
    GMutex $lock,
    guint32 $master_cookie,
    GList $list,
    GObject $owner,
    GstIteratorItemFunction $item
  )
    is also<new-list>
  {
    self.bless(
      iterator => gst_iterator_new_list(
        $type,
        $lock,
        $master_cookie,
        $list,
        $owner,
        $item
      )
    );
  }

  method new_single (GValue() $object) is also<new-single> {
    self.bless( iterator => gst_iterator_new_single($!i, $object) );
  }

  method copy {
    GStreamer::Iterator.new( iterator => gst_iterator_copy($!i) );
  }

  method filter (
    GCompareFunc $func,
    GValue() $user_data = gpointer
  ) {
    GStreamer::Iterator.new(
      iterator => gst_iterator_filter($!i, $func, $user_data)
    );
  }

  method find_custom (
    GCompareFunc $func,
    GValue() $elem,
    gpointer $user_data = gpointer
  )
    is also<find-custom>
  {
    gst_iterator_find_custom($!i, $func, $elem, $user_data);
  }

  method fold (
    GstIteratorFoldFunction $func,
    GValue() $ret,
    gpointer $user_data = gpointer
  ) {
    GstIteratorResult( gst_iterator_fold($!i, $func, $ret, $user_data) );
  }

  method foreach (
    GstIteratorForeachFunction $func,
    gpointer $user_data = gpointer
  ) {
    GstIteratorResult( gst_iterator_foreach($!i, $func, $user_data) );
  }

  method free {
    gst_iterator_free($!i);
  }

  method get_type is also<get-type> {
    state ($n, $t);
    unstable_get_type( self.^name, &gst_iterator_get_type, $n, $t );
  }

  method next (GValue() $elem) {
    GstIteratorResult( gst_iterator_next($!i, $elem) );
  }

  method push (GstIterator() $other) {
    gst_iterator_push($!i, $other);
  }

  method resync {
    gst_iterator_resync($!i);
  }

}
