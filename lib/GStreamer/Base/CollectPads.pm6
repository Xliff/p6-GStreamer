use v6.c;

use NativeCall;

use GStreamer::Raw::Types;
use GStreamer::Raw::Base::CollectPads;

use GStreamer::Object;

our subset GstCollectPadsAncestry is export of Mu
  where GstCollectPads | GstObject;

class GStreamer::Base::CollectPads is GStreamer::Object {
  has GstCollectPads $!cp;

  submethod BUILD (:$collect-pad) {
    self.setGstCollectPad($collect-pad);
  }

  method setGstCollectPad(GstCollectPadsAncestry $_) {
    my $to-parent;

    $!cp = do  {
      when GstCollectPads {
        $to-parent = cast(GstObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstCollectPads, $_);
      }
    }
    self.setGstObject($to-parent);
  }

  method GStreamer::Raw::Structs::GstCollectPads
  #  is also<GstCollectPad>
  { $!cp }

  multi method new (GstCollectPadsAncestry $collect-pad) {
    $collect-pad ?? self.bless( :$collect-pad ) !! Nil;
  }
  multi method new {
    my $collect-pad = gst_collect_pads_new();

    $collect-pad ?? self.bless( :$collect-pad ) !! Nil;
  }

  proto method add_pad (|)
  { * }

  multi method add_pad (
    GstPad() $pad,
    Int() $size,
    Int() $lock,
    :$raw = False
  ) {
    samewith($pad, $size, $, $lock, :$raw);
  }
  multi method add_pad (
    GstPad() $pad,
    Int() $size,
    gpointer $destroy_notify,
    Int() $lock,
    :$raw = False
  ) {
    my gboolean $l = $lock.so.Int;
    my guint $s = $size,
    my $cd = gst_collect_pads_add_pad($!cp, $pad, $s, $destroy_notify, $l);

    $cd ??
      ( $raw ?? $cd !! GStreamer::CollectData.new($cd) )
      !!
      Nil;
  }

  method available {
    gst_collect_pads_available($!cp);
  }

  proto method clip_running_time (|)
  { * }

  multi method clip_running_time (
    GstCollectData() $cdata,
    GstBuffer() $buf,
    gpointer $user_data = gpointer
  ) {
    samewith($cdata, $buf, $, $user_data);
  }
  multi method clip_running_time (
    GstCollectData() $cdata,
    GstBuffer() $buf,
    $outbuf is rw,
    gpointer $user_data = gpointer
  ) {
    my $ob = CArray[Pointer[GstBuffer]].new;
    $ob[0] = Pointer[GstBuffer];

    gst_collect_pads_clip_running_time($!cp, $cdata, $buf, $ob, $user_data);
    $outbuf = ppr($ob);
  }

  # Inferred from struct!
  method data (:$glist = False, :$raw = False) {
    my $l = $!cp.data;

    return Nil unless $l;
    return $l if $glist && $raw;

    $l = GLib::GList.new($l) but GLib::Roles::ListData[GstCollectData];
    $glist ?? $l !! $l.Array;
  }

  method event_default (
    GstCollectData() $data,
    GstEvent() $event,
    Int() $discard
  ) {
    my gboolean $d = $discard.so.Int;

    so gst_collect_pads_event_default($!cp, $data, $event, $discard);
  }

  method flush (GstCollectData $data, guint $size) {
    gst_collect_pads_flush($!cp, $data, $size);
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_collect_pads_get_type, $n, $t );
  }

  method peek (GstCollectData() $data, :$raw = False) {
    my $b = gst_collect_pads_peek($!cp, $data);

    $b ??
      ( $raw ?? $b !! GStreamer::Buffer.new($b) )
      !!
      Nil;
  }

  method pop (GstCollectData() $data, :$raw = False) {
    my $b = gst_collect_pads_pop($!cp, $data);

    $b ??
      ( $raw ?? $b !! GStreamer::Buffer.new($b) )
      !!
      Nil;
  }

  method query_default (
    GstCollectData() $data,
    GstQuery() $query,
    Int() $discard
  ) {
    my gboolean $d = $discard.so.Int;

    so gst_collect_pads_query_default($!cp, $data, $query, $d);
  }

  method read_buffer (GstCollectData() $data, Int() $size, :$raw = False) {
    my guint $s = $size;
    my $b = gst_collect_pads_read_buffer($!cp, $data, $s);

    $b ??
      ( $raw ?? $b !! GStreamer::Buffer.new($b) )
      !!
      Nil;
  }

  method remove_pad (GstPad() $pad) {
    so gst_collect_pads_remove_pad($!cp, $pad);
  }

  method set_buffer_function (&func, gpointer $user_data = gpointer) {
    gst_collect_pads_set_buffer_function($!cp, &func, $user_data);
  }

  method set_clip_function (&clipfunc, gpointer $user_data = gpointer) {
    gst_collect_pads_set_clip_function($!cp, &clipfunc, $user_data);
  }

  method set_compare_function (&func, gpointer $user_data = gpointer) {
    gst_collect_pads_set_compare_function($!cp, &func, $user_data);
  }

  method set_event_function (&func, gpointer $user_data = gpointer) {
    gst_collect_pads_set_event_function($!cp, &func, $user_data);
  }

  method set_flush_function (&func, gpointer $user_data = gpointer) {
    gst_collect_pads_set_flush_function($!cp, &func, $user_data);
  }

  method set_flushing (Int() $flushing) {
    my gboolean $f = $flushing.so.Int;

    gst_collect_pads_set_flushing($!cp, $f);
  }

  method set_function (&func, gpointer $user_data = gpointer) {
    gst_collect_pads_set_function($!cp, &func, $user_data);
  }

  method set_query_function (&func, gpointer $user_data = gpointer) {
    gst_collect_pads_set_query_function($!cp, &func, $user_data);
  }

  method set_waiting (GstCollectData() $data, Int() $waiting) {
    my gboolean $w = $waiting.so.Int;

    gst_collect_pads_set_waiting($!cp, $data, $w);
  }

  method src_event_default (GstPad() $pad, GstEvent() $event) {
    gst_collect_pads_src_event_default($!cp, $pad, $event);
  }

  method start {
    gst_collect_pads_start($!cp);
  }

  method stop {
    gst_collect_pads_stop($!cp);
  }

  method take_buffer (GstCollectData() $data, Int() $size) {
    my guint $s = $size;

    gst_collect_pads_take_buffer($!cp, $data, $s);
  }

}
