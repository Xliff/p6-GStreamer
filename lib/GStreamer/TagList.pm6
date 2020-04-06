use v6.c;

use Method::Also;
use NativeCall;

use GStreamer::Raw::Types;
use GStreamer::Raw::TagList;
use GStreamer::Raw::Tags;

use GLib::Value;

use GStreamer::Raw::Subs;

use GStreamer::MiniObject;
use GStreamer::Sample;

our subset GstTagListAncestry is export of Mu
  where GstTagList | GstMiniObject;

class GStreamer::TagList is GStreamer::MiniObject {
  has GstTagList $!tl;

  submethod BUILD (:$taglist) {
    self.setTagList($taglist);
  }

  method setTagList (GstTagListAncestry $_) {
    my $to-parent;

    $!tl = do {
      when GstTagList {
        $to-parent = cast(GstMiniObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstTagList, $_);
      }
    }
    self.setMiniObject($to-parent);
  }

  method GStreamer::Raw::Types::GstTagList
    is also<GstTagList>
  { * }

  multi method new {
    GStreamer::TagList.new_empty;
  }
  multi method new (GstTagListAncestry $taglist) {
    $taglist ?? self.bless( :$taglist ) !! Nil;
  }
  multi method new (Str $string) {
    GStreamer::TagList.new_from_string($string);
  }
  multi method new (*@a) {
    my $o = GStreamer::TagList.new;
    $o.add_values(|@a);
    $o;
  }

  method new_empty is also<new-empty> {
    my $taglist = gst_tag_list_new_empty();

    $taglist ?? self.bless( :$taglist ) !! Nil;
  }

  method new_from_string (Str() $string ) is also<new-from-string> {
    my $taglist = gst_tag_list_new_from_string($string);

    $taglist ?? self.bless( :$taglist ) !! Nil;
  }

  method scope is rw {
    Proxy.new(
      FETCH => sub ($) {
        GstTagScopeEnum( gst_tag_list_get_scope($!tl) );
      },
      STORE => sub ($, Int() $scope is copy) {
        my GstTagScope $s = $scope;

        gst_tag_list_set_scope($!tl, $s);
      }
    );
  }

  # method add_valist (GstTagMergeMode $mode, Str $tag, va_list $var_args) {
  #   gst_tag_list_add_valist($!tl, $mode, $tag, $var_args);
  # }
  #
  # method add_valist_values (GstTagMergeMode $mode, Str $tag, va_list $var_args) {
  #   gst_tag_list_add_valist_values($!tl, $mode, $tag, $var_args);
  # }

  method add (Str() $tag, $value) {
    warn 'GStreamer::TagList.add NYI';
  }

  method add_valuesv (Int() $mode, *@a) is also<add-valuesv> {
    die 'Values portion of list must be a GValue'
      unless @a.skip(1).rotor(1 => 1).all ~~ (GLib::Value, GValue).any;

    for @a.rotor(2) -> ($t, $v) {
      self.add_value($mode, $t, $v);
    }
  }

  multi method add_value (Int() $mode, Str() $tag, GValue() $value)
    is also<add-value>
  {
    my GstTagMergeMode $m = $mode;

    gst_tag_list_add_value($!tl, $mode, $tag, $value);
  }

  multi method add_values (Int() $mode, *@a) is also<add-values> {
    self.add_valuesv($mode, |@a);
  }

  method copy (GstTagList() $orig, :$raw = False) {
    my $c = cast(
      GstTagList,
      GStreamer::MiniObject.copy( cast(GstMiniObject, $orig), :raw )
    );

    $c ??
      ( $raw ?? $c !! GStreamer::TagList.new($c) )
      !!
      GstTagList;
  }

  proto method copy_value (|)
    is also<copy-value>
  { * }

  multi method copy_value (
    Str() $tag,
    :$all = False,
    :$raw = False
  ) {
    my $d = GValue.new;

    my $rv = self.copy_value($d, $!tl, $tag, :all, :$raw);
    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method copy_value (
    GStreamer::TagList:U:
    GValue() $dest,
    GstTagList() $list,
    Str() $tag,
    :$all = False,
    :$raw = False
  ) {
    my $rv = gst_tag_list_copy_value($dest, $list, $tag);

    $dest = $dest ??
      ( $raw ?? $dest !! GLib::Value.new($dest) )
      !!
      GValue;

    $all.not ?? $rv !! ($rv, $dest);
  }

  method foreach (
    GstTagForeachFunc $func,
    gpointer $user_data = gpointer
  ) {
    gst_tag_list_foreach($!tl, $func, $user_data);
  }

  proto method get_boolean (|)
      is also<get-boolean>
  { * }

  multi method get_boolean (Str() $tag) {
    my $rv = samewith($tag, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_boolean (Str() $tag, $value is rw, :$all = False) {
    my gboolean $v = 0;
    my $rv = gst_tag_list_get_boolean($!tl, $tag, $v);

    $value = $v;
    $all.not ?? $rv !! ($rv, $value);
  }

  proto method get_boolean_index (|)
      is also<get-boolean-index>
  { * }

  multi method get_boolean_index (Str() $tag) {
    my $rv = samewith($tag, $, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method get_boolean_index (
    Str() $tag,
    $index is rw,
    $value is rw,
    :$all = False
  ) {
    my guint $i = 0;
    my gboolean $v = 0;
    my $rv = gst_tag_list_get_boolean_index($!tl, $tag, $i, $v);

    ($index, $value) = ($i, $v);
    ($rv, $index, $value);
  }

  proto method get_date (|)
      is also<get-date>
  { * }

  multi method get_date (Str() $tag) {
    my $rv = samewith($tag, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_date (Str() $tag, $value is rw, :$all = False) {
    my $v = CArray[GDate].new;
    $v[0] = 0;

    my $rv = gst_tag_list_get_date($!tl, $tag, $v);

    $value = ppr($v);
    $all.not ?? $rv !! ($rv, $value);
  }

  proto method get_date_index (|)
      is also<get-date-index>
  { * }

  multi method get_date_index (Str() $tag, Int() $index) {
    my $rv = samewith($tag, $index, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_date_index (
    Str() $tag,
    Int() $index,
    $value is rw,
    :$all = False
  ) {
    my guint $i = 0;
    my $v = CArray[GDate].new;
    $v[0] = 0;

    my $rv = gst_tag_list_get_date_index($!tl, $tag, $i, $v);
    $value = ppr($v);
    $all.not ?? $rv !! ($rv, $value);
  }

  proto method get_date_time (|)
      is also<get-date-time>
  { * }

  multi method get_date_time (Str() $tag, :$all = False) {
    my $rv = samewith($tag, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_date_time (Str() $tag, $value is rw, :$all = False) {
    my $da = CArray[Pointer[GstDateTime]].new;
    $da[0] = Pointer[GstDateTime].new;

    my $rv = gst_tag_list_get_date_time($!tl, $tag, $da);

    ($value) = ppr($da);
    $all.not ?? $rv !! ($rv, $value);
  }

  proto method get_date_time_index (|)
      is also<get-date-time-index>
  { * }

  multi method get_date_time_index (Str() $tag, Int() $index) {
    my $rv = samewith($tag, $index, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_date_time_index (
    Str() $tag,
    Int() $index,
    $value is rw,
    :$all = False
  ) {
    my guint $i = 0;
    my $da = CArray[Pointer[GstDateTime]].new;
    $da[0] = Pointer[GstDateTime].new;

    my $rv = gst_tag_list_get_date_time_index($!tl, $tag, $i, $da);
    $value = ppr($da);
    $all.not ?? $rv !! ($rv, $value);
  }

  proto method get_double (|)
      is also<get-double>
  { * }

  multi method get_double (Str() $tag) {
    my $rv = samewith($tag, $, :all);
  }
  multi method get_double (Str() $tag, $value is rw, :$all = False) {
    my gdouble $v = 0e0;
    my $rv = gst_tag_list_get_double($!tl, $tag, $v);

    $value = $v;
    $all.not ?? $rv !! ($rv, $value);
  }

  proto method get_double_index (|)
      is also<get-double-index>
  { * }

  multi method get_double_index (Str() $tag, Int() $index) {
    my $rv = samewith($tag, $index, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_double_index (
    Str() $tag,
    Int() $index,
    $value is rw,
    :$all = False
  ) {
    my gint $i = $index;
    my gdouble $v = 0e0;
    my $rv = gst_tag_list_get_double_index($!tl, $tag, $i, $v);

    $value = $v;
    $all.not ?? $rv !! ($rv, $value);
  }

  proto method get_float (|)
      is also<get-float>
  { * }

  multi method get_float (Str() $tag) {
    my $rv = samewith($tag, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_float (Str() $tag, $value is rw, :$all = False) {
    my gfloat $v = 0e0;
    my $rv = gst_tag_list_get_float($!tl, $tag, $v);

    $value = $v;
    $all.not ?? $rv !! ($rv, $value);
  }

  proto method get_float_index (|)
      is also<get-float-index>
  { * }

  multi method get_float_index (Str() $tag) {
    my $rv = samewith($tag, $, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method get_float_index (
    Str() $tag,
    $index is rw,
    $value is rw,
    :$all = False
  ) {
    my guint $i = 0;
    my gfloat $v = 0e0;
    my $rv = gst_tag_list_get_float_index($!tl, $tag, $i, $v);

    ($index, $value) = ($i, $v);
    ($rv, $index, $value);
  }

  proto method get_int (|)
      is also<get-int>
  { * }

  multi method get_int (Str() $tag) {
    my $rv = samewith($tag, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_int (Str() $tag, $value is rw, :$all = False) {
    my gint $v = 0;
    my $rv = gst_tag_list_get_int($!tl, $tag, $v);

    $value = $v;
    $all.not ?? $rv !! ($rv, $value);
  }

  proto method get_int64 (|)
      is also<get-int64>
  { * }

  multi method get_int64 (Str() $tag)  {
    my $rv = samewith($tag, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_int64 (Str $tag, $value is rw, :$all = False) {
    my guint64 $v = 0;
    my $rv = gst_tag_list_get_int64($!tl, $tag, $v);

    $value = $v;
    $all.not ?? $rv !! ($rv, $value);
  }

  proto method get_int64_index (|)
      is also<get-int64-index>
  { * }

  multi method get_int64_index (Str() $tag) {
    my $rv = samewith($tag, $, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method get_int64_index (
    Str() $tag,
    $index is rw,
    $value is rw,
    :$all = False
  ) {
    my guint $i = 0;
    my gint64 $v = 0;

    my $rv = gst_tag_list_get_int64_index($!tl, $tag, $i, $v);
    ($index, $value) = ($i, $v);
    $all.not ?? $rv !! ($rv, $index, $value);
  }

  proto method get_int_index (|)
      is also<get-int-index>
  { * }

  multi method get_int_index (Str() $tag) {
    my $rv = samewith($tag, $, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method get_int_index (
    Str() $tag,
    $index is rw,
    $value is rw,
    :$all = False
  ) {
    my guint $i = 0;
    my gint $v = 0;

    my $rv = gst_tag_list_get_int_index($!tl, $tag, $i, $v);
    ($index, $value) = ($i, $v);
    $all.not ?? $rv !! ($rv, $index, $value);
  }

  proto method get_pointer (|)
      is also<get-pointer>
  { * }

  multi method get_pointer (Str() $tag) {
    my $rv = samewith($tag, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_pointer (Str() $tag, $value is rw, :$all = False) {
    my gpointer $v = gpointer.new;
    my $rv = gst_tag_list_get_pointer($!tl, $tag, $v);

    $value = $v;
    $all.not ?? $rv !! ($rv, $value);
  }

  proto method get_pointer_index (|)
      is also<get-pointer-index>
  { * }

  multi method get_pointer_index (Str() $tag) {
    my $rv = samewith($tag, $, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method get_pointer_index (
    Str() $tag,
    $index is rw,
    $value is rw,
    :$all = False
  ) {
    my guint $i = 0;
    my gpointer $v = gpointer.new;
    my $rv = gst_tag_list_get_pointer_index($!tl, $tag, $index, $value);

    ($index, $value) = ($i, $v);
    $all.not ?? $rv !! ($rv, $index, $value)
  }

  proto method get_sample (|)
      is also<get-sample>
  { * }

  multi method get_sample (Str() $tag, :$all = False, :$raw = False) {
    my $rv = samewith($tag, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_sample (
    Str() $tag,
    $sample is rw,
    :$all = False,
    :$raw = False
  ) {
    my $sa = CArray[Pointer[GstSample]].new;
    $sa[0] = Pointer[GstSample].new;

    my $rv = gst_tag_list_get_sample($!tl, $tag, $sample);
    ($sample) = ppr($sa);
    $sample = GStreamer::Sample.new($sample) unless $raw;
    $all.not ?? $rv !! ($rv, $sample);
  }

  proto method get_sample_index (|)
      is also<get-sample-index>
  { * }

  multi method get_sample_index (Str() $tag, :$raw = False) {
    my $rv = samewith($tag, $, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method get_sample_index (
    Str() $tag,
    $index is rw,
    $sample is rw,
    :$all = False,
    :$raw = False
  ) {
    my guint $i = 0;
    my $sa = CArray[Pointer[GstSample]].new;
    $sa[0] = Pointer[GstSample].new;

    my $rv = gst_tag_list_get_sample_index($!tl, $tag, $i, $sa);
    ($index, $sample) = ppr($i, $sa);
    $sample = GStreamer::Sample.new($sample) unless $raw;
    $all.not ?? $rv !! ($rv, $index, $sample);
  }

  proto method get_string (|)
      is also<get-string>
  { * }

  multi method get_string (Str() $tag) {
    my $rv = samewith($tag, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_string (
    Str() $tag,
    $value is rw,
    :$all = False,
  ) {
    my $sa = CArray[Str].new;
    $sa[0] = Str;

    my $rv = gst_tag_list_get_string($!tl, $tag, $sa);

    ($value) = ppr($sa);
    $all.not ?? $rv !! ($rv, $value);
  }

  proto method get_string_index (|)
      is also<get-string-index>
  { * }

  multi method get_string_index (Str() $tag) {
    my $rv = samewith($tag, $, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method get_string_index (
    Str() $tag,
    $index is rw,
    $value is rw,
    :$all = False
  ) {
    my guint $i = 0;
    my $sa = CArray[Str].new;
    $sa[0] = Str;

    my $rv = gst_tag_list_get_string_index($!tl, $tag, $i, $sa);
    ($index, $value) = ppr($i, $sa);
    $all.not ?? $rv !! ($rv, $index, $value);
  }

  method get_tag_size (Str() $tag) is also<get-tag-size> {
    gst_tag_list_get_tag_size($!tl, $tag);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_tag_list_get_type, $n, $t );
  }

  proto method get_uint (|)
      is also<get-uint>
  { * }

  multi method get_uint (Str() $tag, :$all = False) {
    my $rv = samewith($tag, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_uint (Str() $tag, $value is rw, :$all = False) {
    my guint $v = 0;
    my $rv = gst_tag_list_get_uint($!tl, $tag, $v);

    $value = $v;
    $all.not ?? $rv !! ($rv, $value);
  }

  proto method get_uint64 (|)
      is also<get-uint64>
  { * }

  multi method get_uint64 (Str() $tag) {
    my $rv = samewith($tag, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method get_uint64 (Str() $tag, $value is rw, :$all = False) {
    my guint64 $v = 0;
    my $rv = gst_tag_list_get_uint64($!tl, $tag, $v);

    $value = $v;
    $all.not ?? $rv !! ($rv, $value);
  }

  proto method get_uint64_index (|)
      is also<get-uint64-index>
  { * }

  multi method get_uint64_index (Str() $tag) {
    my $rv = samewith($tag, $, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method get_uint64_index (
    Str() $tag,
    $index is rw,
    $value is rw,
    :$all = False
  ) {
    my guint $i = 0;
    my guint64 $v = 0;
    my $rv = gst_tag_list_get_uint64_index($!tl, $tag, $i, $v);

    ($index, $value) = ($i, $v);
    $all.not ?? $rv !! ($rv, $index, $value);
  }

  proto method get_uint_index (|)
      is also<get-uint-index>
  { * }

  multi method get_uint_index (Str() $tag) {
    my $rv = samewith($tag, $, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method get_uint_index (
    Str() $tag,
    $index is rw,
    $value is rw,
    :$all = False
  ) {
    my guint ($i, $v) = 0 xx 2;
    my $rv = gst_tag_list_get_uint_index($!tl, $tag, $i, $v);

    ($index, $value) = ($i, $v);
    ($rv, $index, $value);
  }

  proto method get_value_index (|)
      is also<get-value-index>
  { * }

  multi method get_value_index (Str() $tag, :$raw = False) {
    samewith($tag, $, $, :$raw);
  }
  multi method get_value_index (Str() $tag, Int() $index, :$raw = False) {
    my guint $i = $index;
    my $v = gst_tag_list_get_value_index($!tl, $tag, $index);

    $v ??
      ( $raw ?? $v !! GLib::Value.new($v) )
      !!
      GValue;
  }

  multi method insert (GstTagList() $from, Int() $mode) {
    GStreamer::TagList.insert($!tl, $from, $mode);
  }
  multi method insert (
    GStreamer::TagList:U:
    GstTagList() $to, GstTagList() $from, Int() $mode
  ) {
    my GstTagMergeMode $m = $mode;

    gst_tag_list_insert($to, $from, $m);
  }

  proto method is_empty (|)
      is also<is-empty>
  { * }

  multi method is_empty {
    GStreamer::TagList.is_empty($!tl);
  }
  multi method is_empty (GStreamer::TagList:U: GstTagList() $e) {
    so gst_tag_list_is_empty($e);
  }

  proto method is_equal (|)
      is also<is-equal>
  { * }

  multi method is_equal (GstTagList() $list2) {
    GStreamer::TagList.is_equal($!tl, $list2);
  }
  multi method is_equal (
    GStreamer::TagList:U:
    GstTagList() $list1, GstTagList() $list2
  ) {
    so gst_tag_list_is_equal($list1, $list2);
  }

  proto method merge (|)
  { * }

  multi method merge (GstTagList() $list2, Int() $mode) {
    GStreamer::TagList.merge($!tl, $list2, $mode);
  }
  multi method merge (
    GStreamer::TagList:U:
    GstTagList() $list1, GstTagList() $list2, Int() $mode
  ) {
    my GstTagMergeMode $m = $mode;

    gst_tag_list_merge($list1, $list2, $mode);
  }

  method n_tags
    is also<
      n-tags
      elems
    >
  {
    gst_tag_list_n_tags($!tl);
  }

  method nth_tag_name (Int() $index) is also<nth-tag-name> {
    my guint $i = $index;

    gst_tag_list_nth_tag_name($!tl, $i);
  }

  proto method peek_string_index (|)
      is also<peek-string-index>
  { * }

  multi method peek_string_index (Str() $tag, Int() $index) {
    my $rv = samewith($tag, $index, $, :all);

    $rv[0] ?? $rv[1] !! Nil;
  }
  multi method peek_string_index (
    Str() $tag,
    Int() $index,
    $value is rw,
    :$all = False
  ) {
    my guint $i = $index;
    my $sa = CArray[Str].new;
    $sa[0] = Str;

    my $rv = gst_tag_list_peek_string_index($!tl, $tag, $i, $sa);
    ($value) = ppr($sa);
    $all.not ?? $rv !! ($rv, $value);
  }

  method remove_tag (Str() $tag) is also<remove-tag> {
    gst_tag_list_remove_tag($!tl, $tag);
  }

  method to_string
    is also<
      to-string
      Str
    >
  {
    gst_tag_list_to_string($!tl);
  }

}
