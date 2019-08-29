use v6.c;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::TagList;
use GStreamer::Raw::Tags;

use GStreamer::MiniObject;

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

  method new_empty {
    self.bless( taglist => gst_tag_list_new_empty() );
  }

  method new_from_string (Str() $string ) {
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
  method add_values (*@a) {
    for @a.rotor(2) -> ($t, $v) {
      $o.add($t, $v);
    }
  }

  method add_valuesv (Int() $mode, *@a) {
    die 'Values portion of list must be a GValue'
      unless @a.skip(1).rotor(1 => 1).all ~~ (GTK::Compat::Value, GValue).any;

    for @a.rotor(2) -> ($t, $v) {
      self.add_value($mode, $t, $v);
    }
  }

  method add_value (Int() $mode, Str() $tag, GValue() $value) {
    my GstTagMergeMode $m = $mode;

    gst_tag_list_add_value($!tl, $mode, $tag, $value);
  }

  method copy (GstTagList() $orig, :$raw = False) {
    my $c = GStreamer::MiniObject.copy( cast(GstMiniObject, $orig), :raw );

    $c ??
      ( $raw ?? $c !! GStreamer::TagList.new($c) )
      !!
      Nil;
  }


  method copy_value (GstTagList() $list, Str() $tag) {
    gst_tag_list_copy_value($!tl, $list, $tag);
  }

  method foreach (
    GstTagForeachFunc $func,
    gpointer $user_data = gpointer
  ) {
    gst_tag_list_foreach($!tl, $func, $user_data);
  }

  proto method get_boolean (|)
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
  { * }

  method get_int (Str() $tag, :$all = False) {
    samewith($tag, $, :$all);
  }
  method get_int (Str $tag, $value is rw, :$all = False) {
    my gint $v = 0;
    my $rc = gst_tag_list_get_int($!tl, $tag, $v);

    $value = $v;
    $all.not ?? $value !! ($value, $rc);
  }

  proto method method get_int64 (|)
  { * }

  multi method get_int64 (Str() $tag, :$all = False) {
    samewith($tag, $, :$all);
  }
  multi method get_int64 (Str $tag, $value is rw, :$all = False) {
    my guint64 $v = 0;
    my $rc = gst_tag_list_get_int64($!tl, $tag, $v);

    $value = $v;
    $all.not ?? $value !! ($value, $rc);
  }

  proto method get_int64_index (|)
  { * }

  multi method get_int64_index (Str() $tag) {
    samewith($tag, $, $);
  }
  multi method get_int64_index (Str $tag, guint $index, gint64 $value) {
    my guint $i = 0;
    my gin64 $v = 0;

    my $rc = gst_tag_list_get_int64_index($!tl, $tag, $i, $v);
    ($index, $value) = ($i, $v);
    ($index, $value, $rc);
  }

  proto method get_int_index (|)
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

  method get_pointer (Str $tag, gpointer $value) {
    gst_tag_list_get_pointer($!tl, $tag, $value);
  }

  method get_pointer_index (Str $tag, guint $index, gpointer $value) {
    gst_tag_list_get_pointer_index($!tl, $tag, $index, $value);
  }

  method get_sample (Str $tag, GstSample $sample) {
    gst_tag_list_get_sample($!tl, $tag, $sample);
  }

  method get_sample_index (Str $tag, guint $index, GstSample $sample) {
    gst_tag_list_get_sample_index($!tl, $tag, $index, $sample);
  }

  method get_string (Str $tag, Str $value) {
    gst_tag_list_get_string($!tl, $tag, $value);
  }

  method get_string_index (Str $tag, guint $index, Str $value) {
    gst_tag_list_get_string_index($!tl, $tag, $index, $value);
  }

  method get_tag_size (Str $tag) {
    gst_tag_list_get_tag_size($!tl, $tag);
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_tag_list_get_type, $n, $t );
  }

  method get_uint (Str $tag, guint $value is rw) {
    my guint $v = 0;

    gst_tag_list_get_uint($!tl, $tag, $value);
  }

  method get_uint64 (Str $tag, guint64 $value) {
    gst_tag_list_get_uint64($!tl, $tag, $value);
  }

  method get_uint64_index (Str $tag, guint $index, guint64 $value) {
    gst_tag_list_get_uint64_index($!tl, $tag, $index, $value);
  }

  method get_uint_index (Str $tag, guint $index, guint $value) {
    gst_tag_list_get_uint_index($!tl, $tag, $index, $value);
  }

  method get_value_index (Str $tag, guint $index) {
    gst_tag_list_get_value_index($!tl, $tag, $index);
  }

  method insert (GstTagList $from, GstTagMergeMode $mode) {
    gst_tag_list_insert($!tl, $from, $mode);
  }

  method is_empty {
    gst_tag_list_is_empty($!tl);
  }

  method is_equal (GstTagList $list2) {
    gst_tag_list_is_equal($!tl, $list2);
  }

  method merge (GstTagList $list2, GstTagMergeMode $mode) {
    gst_tag_list_merge($!tl, $list2, $mode);
  }

  method n_tags {
    gst_tag_list_n_tags($!tl);
  }

  method nth_tag_name (guint $index) {
    gst_tag_list_nth_tag_name($!tl, $index);
  }

  method peek_string_index (Str $tag, guint $index, Str $value) {
    gst_tag_list_peek_string_index($!tl, $tag, $index, $value);
  }

  method remove_tag (Str $tag) {
    gst_tag_list_remove_tag($!tl, $tag);
  }

  method to_string {
    gst_tag_list_to_string($!tl);
  }

}
