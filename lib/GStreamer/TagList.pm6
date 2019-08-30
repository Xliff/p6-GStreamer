use v6.c;

use Method::Also;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::TagList;
use GStreamer::Raw::Tags;

use GTK::Comat::Value;

use GStreamer::MiniObject;
use GStreamer::Sample;

our subset TagListAncestry is export of Mu
  where GstTagList | GstMiniObject;

class GStreamer::TagList is GStreamer::MiniObject {
  has GstTagList $!tl;

  submethod BUILD (:$taglist) {
    self.setTagList($taglist);
  }

  method setTagList (TagListAncestry $_) {
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
  multi method new (GstTagList $taglist) {
    self.bless( :$taglist )
  }
  multi method new (Str() $string) {
    GStreamer::TagList.new_from_string($string);
  }
  multi method new (*@a) {
    my $o = GStreamer::TagList.new;
    $o.add_values(|@a);
    $o;
  }

  method new_empty is also<new-empty> {
    self.bless( taglist => gst_tag_list_new_empty() );
  }

  method new_from_string (Str() $string ) is also<new-from-string> {
    self.bless( taglist => gst_tag_list_new_from_string($string) );
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
  method add_values (*@a) is also<add-values> {
    for @a.rotor(2) -> ($t, $v) {
      $o.add($t, $v);
    }
  }

  method add_valuesv (Int() $mode, *@a) is also<add-valuesv> {
    die 'Values portion of list must be a GValue'
      unless @a.skip(1).rotor(1 => 1).all ~~ (GTK::Compat::Value, GValue).any;

    for @a.rotor(2) -> ($t, $v) {
      self.add_value($mode, $t, $v);
    }
  }

  method add_value (Int() $mode, Str() $tag, GValue() $value) is also<add-value> {
    my GstTagMergeMode $m = $mode;

    gst_tag_list_add_value($!tl, $mode, $tag, $value);
  }

  method copy (GstTagList() $orig, :$raw = False) {
    my $c = cast(
      GstTagList,
      GStreamer::MiniObject.copy( cast(GstMiniObject, $orig), :raw )
    );

    $c ??
      ( $raw ?? $c !! GStreamer::TagList.new($c) )
      !!
      Nil;
  }


  method copy_value (GstTagList() $list, Str() $tag) is also<copy-value> {
    gst_tag_list_copy_value($!tl, $list, $tag);
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

  multi method get_boolean (Str() $tag, :$all = False) {
    samewith($tag, $, :$all);
  }
  multi method get_boolean (Str() $tag, $value is rw, :$all = False) {
    my gboolean $v = 0;
    my $rc = gst_tag_list_get_boolean($!tl, $tag, $v);

    $value = $v;
    $all.not ?? $value !! ($value, $rc);
  }

  proto method get_boolean_index (|)
      is also<get-boolean-index>
  { * }

  multi method get_boolean_index (Str() $tag) {
    samewith($tag, $, $);
  }
  multi method get_boolean_index (
    Str() $tag,
    $index is rw,
    $value is rw,
  ) {
    my guint $i = 0;
    my gboolean $v = 0;
    my $rc = gst_tag_list_get_boolean_index($!tl, $tag, $i, $v);

    ($index, $value) = ($i, $v);
    ($index, $value, $rc);
  }

  proto method get_date (|)
      is also<get-date>
  { * }

  multi method get_date (Str() $tag, :$all = False) {
    samewith($tag, $, :$all);
  }
  method get_date (Str() $tag, GDate $value, :$all = False) {
    my GDate $v = 0;
    my $rc = gst_tag_list_get_date($!tl, $tag, $v);

    $value = $v;
    $all.not ?? $value !! ($value, $rc);
  }

  proto method get_date_index (|)
      is also<get-date-index>
  { * }

  multi method get_date_index (Str() $tag) {
    samewith($tag, $, $);
  }
  multi method get_date_index (Str() $tag, $index is rw, $value is rw) {
    my guint $index = 0;
    my GDate $value = 0;

    my $rc = gst_tag_list_get_date_index($!tl, $tag, $i, $v);
    ($index, $value) = ($i, $v);
    ($index, $value, $rc)
  }

  proto method get_date_time (|)
      is also<get-date-time>
  { * }

  multi method get_date_time (Str() $tag(), :$all = False) {
    samewith($tag, $, :$all);
  }
  multi method get_date_time (Str() $tag, $value is rw) {
    my $da = CArray[Pointer[GstDateTime]].new;

    $da[0] = Pointer[GstDateTime].new;
    my $rc = gst_tag_list_get_date_time($!tl, $tag, $da);

    ($value) = ppr($da);
    $all.not ?? $value !! ($value, $rc);
  }

  proto method get_date_time_index (|)
      is also<get-date-time-index>
  { * }

  multi method get_date_time_index (Str() $tag) {
    samewith($tag, $, $);
  }
  method get_date_time_index (Str() $tag, $index is rw, $value is rw) {
    my guint $i = 0;
    my $da = CArray[Pointer[GstDateTime]].new;

    $da[0] = Pointer[GstDateTime].new;
    my $rc = gst_tag_list_get_date_time_index($!tl, $tag, $i, $da);
    ($index, $value) = ppr($i, $da);
    ($index, $value, $rc)
  }

  proto method get_double (|)
      is also<get-double>
  { * }

  multi method get_double (Str() $tag, :$all = False) {
    samewith($tag, $, :$all);
  }
  method get_double (Str() $tag, $value is rw, :$all = False) {
    my gdouble $v = 0e0;
    my $rc = gst_tag_list_get_double($!tl, $tag, $v);

    $value = $v;
    $all.not ?? $value !! ($value, $rc);
  }

  proto method get_double_index (|)
      is also<get-double-index>
  { * }

  multi method get_double_index (Str() $tag) {
    samewith($tag, $, $);
  }
  multi method get_double_index (Str() $tag, $index is rw, $value is rw) {
    my gint $i = 0;
    my gdouble $v = 0e0;
    my $rc = gst_tag_list_get_double_index($!tl, $tag, $i, $v);

    ($index, $value) = ($i, $v);
    ($index, $value, $rc);
  }

  proto method get_float (|)
      is also<get-float>
  { * }

  multi method get_float (Str() $tag, :$all = False) {
    samewith($tag, $, :$all);
  }
  multi method get_float (Str() $tag, $value is rw. :$all = False) {
    my gfloat $v = 0e0;
    my $rc = gst_tag_list_get_float($!tl, $tag, $v);

    $value = $v;
    $all.not ?? $value !! ($value, $fc
  }

  proto method get_float_index (|)
      is also<get-float-index>
  { * }

  method get_float_index (Str() $tag) {
    samewith($tag, $, $);
  }
  method get_float_index (Str() $tag, $index is rw, $value is rw) {
    my guint $i = 0;
    my gfloat $v = 0;
    my $rc = gst_tag_list_get_float_index($!tl, $tag, $i, $v);

    ($index, $value) = ($i, $v);
    ($index, $value, $rc);
  }

  proto method get_int (|)
      is also<get-int>
  { * }

  method get_int (Str() $tag, :$all = False) {
    samewith($tag, $, :$all);
  }
  method get_int (Str() $tag, $value is rw, :$all = False) {
    my gint $v = 0;
    my $rc = gst_tag_list_get_int($!tl, $tag, $v);

    $value = $v;
    $all.not ?? $value !! ($value, $rc);
  }

  proto method get_int64 (|)
      is also<get-int64>
  { * }

  multi method get_int64 (Str() $tag, :$all = False)  {
    samewith($tag, $, :$all);
  }
  multi method get_int64 (Str $tag, $value is rw, :$all = False) {
    my guint64 $v = 0;
    my $rc = gst_tag_list_get_int64($!tl, $tag, $v);

    $value = $v;
    $all.not ?? $value !! ($value, $rc);
  }

  proto method get_int64_index (|)
      is also<get-int64-index>
  { * }

  multi method get_int64_index (Str() $tag) {
    samewith($tag, $, $);
  }
  multi method get_int64_index (Str() $tag, $index is rw, $value is rw) {
    my guint $i = 0;
    my gin64 $v = 0;

    my $rc = gst_tag_list_get_int64_index($!tl, $tag, $i, $v);
    ($index, $value) = ($i, $v);
    ($index, $value, $rc);
  }

  proto method get_int_index (|)
      is also<get-int-index>
  { * }

  method get_int_index (Str() $tag) {
    samewith($tag, $, $);
  }
  method get_int_index (Str() $tag, $index is rw, $value is rw) {
    my guint $i = 0;
    my gint $v = 0;

    my $rc = gst_tag_list_get_int_index($!tl, $tag, $i, $v);
    ($index, $value) = ($i, $v);
    ($index, $value, $rc);
  }

  proto method get_pointer (|)
      is also<get-pointer>
  { * }

  multi method get_pointer (Str() $tag, :$all = False) {
    samewith($tag, $, :$all);
  }
  multi method get_pointer (Str() $tag, $value is rw, :$all = False) {
    my gpointer $v = gpointer.new;
    my $rc = gst_tag_list_get_pointer($!tl, $tag, $v);

    $value = $v;
    $all.not ? $value ?? ($value, $rc);
  }

  proto method get_pointer_index (|)
      is also<get-pointer-index>
  { * }

  multi method get_pointer_index (Str() $tag) {
    samewith($tag, $, $);
  }
  multi method get_pointer_index (Str() $tag, $index is rw, $value is rw) {
    my guint $i = 0;
    my gpointer $v = gpointer.new;
    my $rc = gst_tag_list_get_pointer_index($!tl, $tag, $index, $value);

    ($index, $value) = ($i, $v);
    ($index, $value, $rc)
  }

  proto method get_sample (|)
      is also<get-sample>
  { * }

  multi method get_sample (Str() $tag, :$all = False, :$raw = False) {
    samewith($tag, $, :$all);
  }
  multi method get_sample (
    Str() $tag,
    $sample is rw,
    :$all = False,
    :$raw = False
  ) {
    my $sa = CArray[Pointer[GstSample]].new;

    $sa[0] = Pointer[GstSample].new;
    my $rc = gst_tag_list_get_sample($!tl, $tag, $sample);
    ($sample) = ppr($sa);
    $sample = GStreamer::Sample.new($sample) unless $raw;
    $all.not ?? $sample !! ($sample, $rc);
  }

  proto method get_sample_index (|)
      is also<get-sample-index>
  { * }

  multi method get_sample_index (Str() $tag, :$raw = False) {
    samewith($tag, $, $);
  }
  multi method get_sample_index (
    Str() $tag,
    $index is rw,
    $sample is rw,
    :$raw = False
  ) {
    my guint $i = 0;
    my $sa = CArray[Pointer[GstSample]].new;

    $sa[0] = Pointer[GstSample].new;
    gst_tag_list_get_sample_index($!tl, $tag, $i, $sa);
    ($index, $sample) = ppr($i, $sa);
    $sample = GStreamer::Sample.new($sample) unless $raw;
    ($index, $sample, $rc);
  }

  proto method get_string (|)
      is also<get-string>
  { * }

  multi method get_string (Str() $tag, :$all = False) {
    samewith($tag, $, :$all);
  }
  multi method get_string (Str() $tag, $value is rw, :$all = False) {
    my $sa = CArray[Str].new;
    $sa[0] = Str;

    my $rc = gst_tag_list_get_string($!tl, $tag, $sa);
    ($value) = ppr($sa);
    $all.not ?? $value !! ($value, $v);
  }

  proto method get_string_index (|)
      is also<get-string-index>
  { * }

  multi method get_string_index (Str() $tag) {
    samewith($tag, $, $);
  }
  multi method get_string_index (Str() $tag, $index is rw, $value is rw) {
    my guint $i = 0;
    my $sa = CArray[Str].new;
    $sa[0] = Str;

    my $rc = gst_tag_list_get_string_index($!tl, $tag, $i, $sa);
    ($index, $value) = ppr($i, $sa);
    ($index, $value, $rc);
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

  method get_uint (Str() $tag, :$all = False) {
    samewith($tag, $, :$all);
  method get_uint (Str() $tag, $value is rw) {
    my guint $v = 0;
    my $rc = gst_tag_list_get_uint($!tl, $tag, $v);
    $value = $v;
    $all.not ?? $value !! ($value, $rc);
  }

  proto method get_uint64 (|)
      is also<get-uint64>
  { * }

  multi method get_uint64 (Str() $tag, :$all = False) {
    samewith($tag, $, :$all);
  }
  multi method get_uint64 (Str() $tag, $value is rw, :$all = False) {
    my guint64 $v = 0;
    my $rc = gst_tag_list_get_uint64($!tl, $tag, $v);

    $value = $v;
    $all.not ?? $value !! ($value, $rc);
  }

  proto method get_uint64_index (|)
      is also<get-uint64-index>
  { * }

  multi method get_uint64_index (Str() $tag) {
    samewith($tag, $, $);
  }
  multi method get_uint64_index (Str() $tag, $index is rw, $value is rw) {
    my guint $i = 0;
    my guint64 $v = 0;
    my $rc = gst_tag_list_get_uint64_index($!tl, $tag, $i, $v);

    ($index, $value) = ($i, $v);
    ($index, $value, $rc);
  }

  proto method get_uint_index (|)
      is also<get-uint-index>
  { * }

  multi method get_uint_index (Str() $tag) {
    samewith($tag, $, $);
  }
  multi method get_uint_index (Str $tag, $index is rw, $value is rw) {
    my guint ($i, $v) = 0 xx 2;
    my $rc = gst_tag_list_get_uint_index($!tl, $tag, $i, $v);

    ($index, $value) = ($i, $v);
    ($index, $value, $rc);
  }

  proto method get_value_index (|)
      is also<get-value-index>
  { * }

  multi method get_value_index (Str() $tag, :$raw = False) {
    samewith($tag, $, $, :$raw);
  }
  method get_value_index (Str() $tag, Int() $index, :$raw = False) {
    my guint $i = $index;
    my $v = gst_tag_list_get_value_index($!tl, $tag, $index);

    $v ??
      ( $raw ?? $v !! GTK::Compat::Value.new($v) )
      !!
      Nil;
  }

  proto method insert (|)
  { * }

  method insert (GstTagList() $from, Int() $mode) {
    GStreamer::TagList.insert($!tl, $from, $mode);
  }
  method insert (
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

  method merge (GstTagList() $list2, Int() $mode)
    GStreamer::TagList.merge($!tl, $list2, $mode);
  }
  method merge (
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

  method peek_string_index (Str() $tag, Int() $index, :$all = False) {
    samewith($tag, $index, $, :$all);
  }
  method peek_string_index (
    Str() $tag,
    Int() $index,
    $value is rw,$all = False
  ) {
    my guint $i = $index;
    my $sa = CArray[Str].new;

    $sa[0] = Str;
    my $rc = gst_tag_list_peek_string_index($!tl, $tag, $i, $sa);
    ($value) = ppr($sa);
    $all.not ?? $value !! ($value, $rc);
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