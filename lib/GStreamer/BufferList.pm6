use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::BufferList;

use GStreamer::MiniObject;

use GStreamer::Buffer;

our subset BufferListAncestry is export of Mu
  where GstBufferList | GstMiniObject;

class GStreamer::BufferList is GStreamer::MiniObject {
  has GstBufferList $!bl;

  submethod BUILD (:$buffer-list) {
    self.setBufferList($buffer-list);
  }

  method setBufferList(BufferListAncestry $_) {
    my $to-parent;

    $!bl = do {
      when GstBufferList {
        $to-parent = cast(GstMiniObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstBufferList, $_);
      }
    }
    self.setMiniObject($to-parent);
  }

  method GStreamer::Raw::Types::GstBufferList
    is also<GstBufferList>
  { $!bl }

  multi method new (GstBufferList $buffer-list) {
    $buffer-list ?? self.bless( :$buffer-list ) !! Nil;
  }
  multi method new {
    my $buffer-list = gst_buffer_list_new();

    $buffer-list ?? self.bless( :$buffer-list ) !! Nil;
  }

  method new_sized (Int() $size) is also<new-sized> {
    my guint $s = $size;
    my $buffer-list = gst_buffer_list_new_sized($s);

    $buffer-list ?? self.bless( :$buffer-list ) !! Nil;
  }

  method calculate_size is also<calculate-size> {
    gst_buffer_list_calculate_size($!bl);
  }

  # multi method copy (:$raw = False) {
  #   GStreamer::BufferList.copy($!bl, :$raw);
  # }
  # multi method copy (GstBufferList() $cpy, :$raw = False) {
  #   my $c = cast(
  #     GstBufferList,
  #     GStreamer::MiniObject.copy( cast(GstMiniObject, $cpy) )
  #   );
  #
  #   $c ??
  #     ( $raw ?? $c !! GStreamer::BufferList.new($c) )
  #     !!
  #     GstBufferList;
  # }

  proto method copy_deep (|)
    is also<
      copy
      copy-deep
    >
  { * }

  multi method copy_deep (:$raw = False)  {
    GStreamer::BufferList.copy_deep($!bl, :$raw);
  }
  multi method copy_deep (
    GStreamer::BufferList:U:
    GstBufferList() $cpy,
    :$raw = False
  ) {
    my $c = gst_buffer_list_copy_deep($cpy);

    $c ??
      ( $raw ?? $c !! GStreamer::BufferList.new($c) )
      !!
      Nil;
  }

  method foreach (
    GstBufferListFunc $func,
    gpointer $user_data = gpointer
  ) {
    gst_buffer_list_foreach($!bl, $func, $user_data);
  }

  method get (Int() $idx, :$raw = False) {
    my guint $i = $idx;
    my $b = gst_buffer_list_get($!bl, $i);

    $b ??
      ( $raw ?? $b !! GStreamer::Buffer.new($b) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_buffer_list_get_type, $n, $t );
  }

  method get_writable (Int() $idx, :$raw = False) is also<get-writable> {
    my guint $i = $idx;
    my $b = gst_buffer_list_get_writable($!bl, $i);

    $b ??
      ( $raw ?? $b !! GStreamer::Buffer.new($b) )
      !!
      Nil;
  }

  method insert (Int() $idx, GstBuffer() $buffer) {
    my guint $i = $idx;

    gst_buffer_list_insert($!bl, $idx, $buffer);
  }

  method length {
    gst_buffer_list_length($!bl);
  }

  method remove (Int() $idx, Int() $length) {
    my guint ($i, $l) = ($idx, $length);

    gst_buffer_list_remove($!bl, $i, $l);
  }

  #define gst_buffer_list_is_writable(list) gst_mini_object_is_writable (GST_MINI_OBJECT_CAST (list))
  #define gst_buffer_list_make_writable(list) GST_BUFFER_LIST_CAST (gst_mini_object_make_writable (GST_MINI_OBJECT_CAST (list)))
}
