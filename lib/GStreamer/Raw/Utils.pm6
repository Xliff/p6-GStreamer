use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GStreamer::Raw::Types;

unit package GStreamer::Raw::Utils;

sub gst_element_create_all_pads (GstElement $element)
  is native(gstreamer)
  is export
{ * }

sub gst_element_factory_can_sink_all_caps (
  GstElementFactory $factory,
  GstCaps $caps
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_factory_can_sink_any_caps (
  GstElementFactory $factory,
  GstCaps $caps
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_factory_can_src_all_caps (
  GstElementFactory $factory,
  GstCaps $caps
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_factory_can_src_any_caps (
  GstElementFactory $factory,
  GstCaps $caps
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_get_compatible_pad (
  GstElement $element,
  GstPad $pad,
  GstCaps $caps
)
  returns GstPad
  is native(gstreamer)
  is export
{ * }

sub gst_element_get_compatible_pad_template (
  GstElement $element,
  GstPadTemplate $compattempl
)
  returns GstPadTemplate
  is native(gstreamer)
  is export
{ * }

sub gst_bin_find_unlinked_pad (
  GstBin $bin,
  guint $direction # GstPadDirection $direction
)
  returns GstPad
  is native(gstreamer)
  is export
{ * }

sub gst_bin_sync_children_states (GstBin $bin)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_calculate_linear_regression (
  GstClockTime $xy,
  GstClockTime $temp,
  guint $n,
  GstClockTime $m_num,
  GstClockTime $m_denom,
  GstClockTime $b,
  GstClockTime $xbase,
  gdouble $r_squared
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_object_default_error (
  GstObject $source,
  CArray[Pointer[GError]] $error,
  Str $debug
)
  is native(gstreamer)
  is export
{ * }

sub gst_pad_create_stream_id (GstPad $pad, GstElement $parent, Str $stream_id)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_pad_get_parent_element (GstPad $pad)
  returns GstElement
  is native(gstreamer)
  is export
{ * }

sub gst_pad_get_stream (GstPad $pad)
  returns GstStream
  is native(gstreamer)
  is export
{ * }

sub gst_pad_get_stream_id (GstPad $pad)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_pad_link_maybe_ghosting (GstPad $src, GstPad $sink)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_link_maybe_ghosting_full (
  GstPad $src,
  GstPad $sink,
  guint $flags               # GstPadLinkCheck $flags
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_peer_query_accept_caps (GstPad $pad, GstCaps $caps)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_peer_query_caps (GstPad $pad, GstCaps $filter)
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

sub gst_pad_peer_query_convert (
  GstPad $pad,
  guint $src_format,         # GstFormat $src_format,
  gint64 $src_val,
  guint $dest_format,        # GstFormat $dest_format,
  gint64 $dest_val
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_peer_query_duration (
  GstPad $pad,
  guint $format,             # GstFormat $format,
  gint64 $duration
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_peer_query_position (
  GstPad $pad,
  guint $format,             # GstFormat $format,
  gint64 $cur
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_proxy_query_accept_caps (GstPad $pad, GstQuery $query)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_proxy_query_caps (GstPad $pad, GstQuery $query)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_query_accept_caps (GstPad $pad, GstCaps $caps)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_query_caps (GstPad $pad, GstCaps $filter)
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

sub gst_pad_query_convert (
  GstPad $pad,
  guint $src_format,         # GstFormat $src_format,
  gint64 $src_val,
  guint $dest_format,        # GstFormat $dest_format,
  gint64 $dest_val
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_query_duration (
  GstPad $pad,
  guint $format,             # GstFormat $format,
  gint64 $duration
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_query_position (
  GstPad $pad,
  guint $format,             # GstFormat $format,
  gint64 $cur
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_use_fixed_caps (GstPad $pad)
  is native(gstreamer)
  is export
{ * }

sub gst_parse_bin_from_description (
  Str $bin_description,
  gboolean $ghost_unlinked_pads,
  CArray[Pointer[GError]] $err
)
  returns GstElement
  is native(gstreamer)
  is export
{ * }

sub gst_parse_bin_from_description_full (
  Str $bin_description,
  gboolean $ghost_unlinked_pads,
  GstParseContext $context,
  guint $flags,              # GstParseFlags $flags,
  CArray[Pointer[GError]] $err
)
  returns GstElement
  is native(gstreamer)
  is export
{ * }

sub gst_state_change_get_name (
  guint $transition          # GstStateChange $transition
)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_util_array_binary_search (
  gpointer $array,
  guint $num_elements,
  gsize $element_size,
  GCompareDataFunc $search_func,
  guint $mode,               # GstSearchMode $mode,
  gconstpointer $search_data,
  gpointer $user_data
)
  returns Pointer
  is native(gstreamer)
  is export
{ * }

sub gst_util_double_to_fraction (gdouble $src, gint $dest_n, gint $dest_d)
  is native(gstreamer)
  is export
{ * }

sub gst_util_dump_buffer (GstBuffer $buf)
  is native(gstreamer)
  is export
{ * }

sub gst_util_dump_mem (guchar $mem, guint $size)
  is native(gstreamer)
  is export
{ * }

sub gst_util_fraction_add (
  gint $a_n,
  gint $a_d,
  gint $b_n,
  gint $b_d,
  gint $res_n,
  gint $res_d
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_util_fraction_compare (gint $a_n, gint $a_d, gint $b_n, gint $b_d)
  returns gint
  is native(gstreamer)
  is export
{ * }

sub gst_util_fraction_multiply (
  gint $a_n,
  gint $a_d,
  gint $b_n,
  gint $b_d,
  gint $res_n,
  gint $res_d
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_util_fraction_to_double (gint $src_n, gint $src_d, gdouble $dest)
  is native(gstreamer)
  is export
{ * }

sub gst_util_gdouble_to_guint64 (gdouble $value)
  returns guint64
  is native(gstreamer)
  is export
{ * }

# sub gst_util_get_object_array (GObject $object, Str $name, GValueArray $array)
#   returns uint32
#   is native(gstreamer)
#   is export
# { * }

sub gst_util_get_timestamp ()
  returns GstClockTime
  is native(gstreamer)
  is export
{ * }

sub gst_util_greatest_common_divisor (gint $a, gint $b)
  returns gint
  is native(gstreamer)
  is export
{ * }

sub gst_util_greatest_common_divisor_int64 (gint64 $a, gint64 $b)
  returns gint64
  is native(gstreamer)
  is export
{ * }

sub gst_util_group_id_next ()
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_util_guint64_to_gdouble (guint64 $value)
  returns gdouble
  is native(gstreamer)
  is export
{ * }

sub gst_util_seqnum_compare (guint32 $s1, guint32 $s2)
  returns gint32
  is native(gstreamer)
  is export
{ * }

sub gst_util_seqnum_next ()
  returns guint32
  is native(gstreamer)
  is export
{ * }

sub gst_util_set_object_arg (GObject $object, Str $name, Str $value)
  is native(gstreamer)
  is export
{ * }

# sub gst_util_set_object_array (GObject $object, Str $name, GValueArray $array)
#   returns uint32
#   is native(gstreamer)
#   is export
# { * }

sub gst_util_set_value_from_string (GValue $value, Str $value_str)
  is native(gstreamer)
  is export
{ * }

sub gst_util_uint64_scale (guint64 $val, guint64 $num, guint64 $denom)
  returns guint64
  is native(gstreamer)
  is export
{ * }

sub gst_util_uint64_scale_ceil (guint64 $val, guint64 $num, guint64 $denom)
  returns guint64
  is native(gstreamer)
  is export
{ * }

sub gst_util_uint64_scale_int (guint64 $val, gint $num, gint $denom)
  returns guint64
  is native(gstreamer)
  is export
{ * }

sub gst_util_uint64_scale_int_ceil (guint64 $val, gint $num, gint $denom)
  returns guint64
  is native(gstreamer)
  is export
{ * }

sub gst_util_uint64_scale_int_round (guint64 $val, gint $num, gint $denom)
  returns guint64
  is native(gstreamer)
  is export
{ * }

sub gst_util_uint64_scale_round (guint64 $val, guint64 $num, guint64 $denom)
  returns guint64
  is native(gstreamer)
  is export
{ * }

sub gst_element_link (GstElement $src, GstElement $dest)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_link_filtered (
  GstElement $src,
  GstElement $dest,
  GstCaps $filter
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_link_pads (
  GstElement $src,
  Str $srcpadname,
  GstElement $dest,
  Str $destpadname
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_link_pads_filtered (
  GstElement $src,
  Str $srcpadname,
  GstElement $dest,
  Str $destpadname,
  GstCaps $filter
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_link_pads_full (
  GstElement $src,
  Str $srcpadname,
  GstElement $dest,
  Str $destpadname,
  guint $flags               # GstPadLinkCheck $flags
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_query_convert (
  GstElement $element,
  guint $src_format,         # GstFormat $src_format,
  gint64 $src_val,
  guint $dest_format,        # GstFormat $dest_format,
  gint64 $dest_val
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_query_duration (
  GstElement $element,
  guint $format,             # GstFormat $format,
  gint64 $duration
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_query_position (
  GstElement $element,
  guint $format,             # GstFormat $format,
  gint64 $cur
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_seek_simple (
  GstElement $element,
  guint $src_format,         # GstFormat $src_format,
  guint $seek_flags,         # GstSeekFlags $seek_flags,
  gint64 $seek_pos
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_state_change_return_get_name (
  guint $state_ret           # GstStateChangeReturn $state_ret
)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_element_state_get_name (
  guint $state               # GstState $state
)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_element_unlink (GstElement $src, GstElement $dest)
  is native(gstreamer)
  is export
{ * }

sub gst_element_unlink_pads (
  GstElement $src,
  Str $srcpadname,
  GstElement $dest,
  Str $destpadname
)
  is native(gstreamer)
  is export
{ * }
