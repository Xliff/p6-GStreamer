use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

unit package GStreamer::Raw::TagList;

# sub gst_tag_list_add_valist (GstTagList $list, GstTagMergeMode $mode, Str $tag, va_list $var_args)
#   is native(gstreamer)
#   is export
# { * }

# sub gst_tag_list_add_valist_values (GstTagList $list, GstTagMergeMode $mode, Str $tag, va_list $var_args)
#   is native(gstreamer)
#   is export
# { * }

sub gst_tag_list_add_value (
  GstTagList      $list,
  GstTagMergeMode $mode,
  Str             $tag,
  GValue          $value
)
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_copy_value (GValue $dest, GstTagList $list, Str $tag)
  returns uint32
  is      native(gstreamer)
  is      export
{ * }

sub gst_tag_list_foreach (
  GstTagList $list,
  GstTagForeachFunc $func,
  gpointer $user_data
)
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_boolean (
  GstTagList $list,
  Str $tag, gboolean
  $value is rw
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_boolean_index (
  GstTagList $list,
  Str $tag,
  guint $index,
  gboolean $value is rw
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_date (
  GstTagList $list,
  Str $tag,
  CArray[Pointer[GDate]] $value
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_date_index (
  GstTagList $list,
  Str $tag,
  guint $index,
  CArray[Pointer[GDate]] $value
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_date_time (
  GstTagList $list,
  Str $tag,
  CArray[Pointer[GstDateTime]] $value
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_date_time_index (
  GstTagList $list,
  Str $tag,
  guint $index,
  CArray[Pointer[GstDateTime]] $value
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_double (GstTagList $list, Str $tag, gdouble $value is rw)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_double_index (
  GstTagList $list,
  Str $tag,
  guint $index,
  gdouble $value is rw
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_float (GstTagList $list, Str $tag, gfloat $value is rw)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_float_index (
  GstTagList $list,
  Str $tag,
  guint $index,
  gfloat $value is rw
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_int (GstTagList $list, Str $tag, gint $value is rw)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_int64 (GstTagList $list, Str $tag, gint64 $value is rw)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_int64_index (
  GstTagList $list,
  Str $tag,
  guint $index,
  gint64 $value is rw
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_int_index (
  GstTagList $list,
  Str $tag,
  guint $index,
  gint $value is rw
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_pointer (GstTagList $list, Str $tag, gpointer $value)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_pointer_index (
  GstTagList $list,
  Str $tag,
  guint $index,
  gpointer $value
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_sample (
  GstTagList $list,
  Str $tag,
  CArray[Pointer[GstSample]] $sample
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_sample_index (
  GstTagList $list,
  Str $tag,
  guint $index,
  CArray[Pointer[GstSample]] $sample
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_scope (GstTagList $list)
  returns GstTagScope
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_string (
  GstTagList            $list,
  Str                   $tag,
  CArray[CArray[uint8]] $value
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_string_index (
  GstTagList $list,
  Str $tag,
  guint $index,
  CArray[Str] $value
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_tag_size (GstTagList $list, Str $tag)
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_uint (GstTagList $list, Str $tag, guint $value is rw)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_uint64 (GstTagList $list, Str $tag, guint64 $value is rw)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_uint64_index (
  GstTagList $list,
  Str $tag,
  guint $index,
  guint64 $value is rw
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_uint_index (
  GstTagList $list,
  Str $tag,
  guint $index,
  guint $value is rw
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_get_value_index (GstTagList $list, Str $tag, guint $index)
  returns GValue
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_insert (
  GstTagList $into,
  GstTagList $from,
  GstTagMergeMode $mode
)
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_is_empty (GstTagList $list)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_is_equal (GstTagList $list1, GstTagList $list2)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_merge (
  GstTagList $list1,
  GstTagList $list2,
  GstTagMergeMode $mode
)
  returns GstTagList
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_n_tags (GstTagList $list)
  returns gint
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_new_empty ()
  returns GstTagList
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_new_from_string (Str $str)
  returns GstTagList
  is native(gstreamer)
  is export
{ * }

# sub gst_tag_list_new_valist (va_list $var_args)
#   returns GstTagList
#   is native(gstreamer)
#   is export
# { * }

sub gst_tag_list_nth_tag_name (GstTagList $list, guint $index)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_peek_string_index (
  GstTagList $list,
  Str $tag,
  guint $index,
  CArray[Str] $value
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_remove_tag (GstTagList $list, Str $tag)
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_set_scope (GstTagList $list, GstTagScope $scope)
  is native(gstreamer)
  is export
{ * }

sub gst_tag_list_to_string (GstTagList $list)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_tag_exists (Str $tag)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_get_description (Str $tag)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_tag_get_flag (Str $tag)
  returns GstTagFlag
  is native(gstreamer)
  is export
{ * }

sub gst_tag_get_nick (Str $tag)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_tag_get_type (Str $tag)
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_tag_is_fixed (Str $tag)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_tag_merge_strings_with_comma (GValue $dest, GValue $src)
  is native(gstreamer)
  is export
{ * }

sub gst_tag_merge_use_first (GValue $dest, GValue $src)
  is native(gstreamer)
  is export
{ * }

sub gst_tag_register (
  Str $name,
  GstTagFlag $flag,
  GType $type,
  Str $nick,
  Str $blurb,
  GstTagMergeFunc $func
)
  is native(gstreamer)
  is export
{ * }

sub gst_tag_register_static (
  Str $name,
  GstTagFlag $flag,
  GType $type,
  Str $nick,
  Str $blurb,
  GstTagMergeFunc $func
)
  is native(gstreamer)
  is export
{ * }
