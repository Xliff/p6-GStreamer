use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::MiniObject;

class GStreamer::MiniObject {
  has GstMiniObject $!mo;

  submethod BUILD (:$mini-object) {
    self.setMiniObject($mini-object) if $mini-object.defined;
  }

  method setMiniObject (GstMiniObject $mini-object) {
    $!mo = $mini-object;
  }

  method GStreamer::Raw::Structs::GstMiniObject
    is also<GstMiniObject>
  { * }

  method new (GstMiniObject $mini-object) {
    $mini-object ?? self.bless( :$mini-object ) !! Nil;
  }

  method add_parent (GstMiniObject() $parent) is also<add-parent> {
    gst_mini_object_add_parent($!mo, $parent);
  }

  method get_qdata (GQuark $quark) is also<get-qdata> {
    gst_mini_object_get_qdata($!mo, $quark);
  }

  method clear {
    GStreamer::MiniObject.clear_mini_object($!mo);
  }

  method clear_mini_object (
    GStreamer::MiniObject:U:
    GstMiniObject $o
  )
    is also<clear-mini-object>
  {
    gst_clear_mini_object($o);
  }

  method copy (GstMiniObject $orig, :$raw) {
    my $c = gst_mini_object_copy($orig);

    $c ??
      ( $raw ?? $c !! GStreamer::MiniObject.new($c) )
      !!
      Nil;
  }

  method init (
    GstMiniObject $obj,
    Int() $flags,
    Int() $type,
    GstMiniObjectCopyFunction $copy_func,
    GstMiniObjectDisposeFunction $dispose_func,
    GstMiniObjectFreeFunction $free_func
  ) {
    my guint ($f, $t) = ($flags, $type);

    gst_mini_object_init($obj, $f, $t, $copy_func, $dispose_func, $free_func);
  }

  method is_writable is also<is-writable> {
    so gst_mini_object_is_writable($!mo);
  }

  method lock (Int() $flags) {
    my guint $f = $flags;

    so gst_mini_object_lock($!mo, $f);
  }

  method make_writable (:$raw = False) is also<make-writable> {
    my $o = gst_mini_object_make_writable($!mo);

    $o ??
      ( $raw ?? $o !! GStreamer::MiniObject.new($o) )
      !!
      Nil;
  }

  method ref is also<upref> {
    gst_mini_object_ref($!mo);
  }

  method remove_parent (GstMiniObject() $parent) is also<remove-parent> {
    gst_mini_object_remove_parent($!mo, $parent);
  }

  method replace (GstMiniObject() $newdata) {
    gst_mini_object_replace($!mo, $newdata);
  }

  method set_qdata (
    GQuark $quark,
    gpointer $data,
    GDestroyNotify $destroy
  )
    is also<set-qdata>
  {
    gst_mini_object_set_qdata($!mo, $quark, $data, $destroy);
  }

  method steal {
    gst_mini_object_steal($!mo);
  }

  method steal_qdata (GQuark $quark) is also<steal-qdata> {
    gst_mini_object_steal_qdata($!mo, $quark);
  }

  method take (GstMiniObject() $newdata) {
    gst_mini_object_take($!mo, $newdata);
  }

  method unlock (
    Int() $flags # GstLockFlags $flags
  ) {
    my guint $f = $flags;

    gst_mini_object_unlock($!mo, $f);
  }

  method unref is also<downref> {
    gst_mini_object_unref($!mo);
  }

  method weak_ref (GstMiniObjectNotify $notify, gpointer $data)
    is also<
      weak-ref
      weak_upref
      weak-upref
    >
  {
    gst_mini_object_weak_ref($!mo, $notify, $data);
    self;
  }

  method weak_unref (GstMiniObjectNotify $notify, gpointer $data)
    is also<
      weak-unref
      weak_downref
      weak-downref
    >
  {
    gst_mini_object_weak_unref($!mo, $notify, $data);
  }

}
