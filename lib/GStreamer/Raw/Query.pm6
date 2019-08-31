use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GStreamer::Raw::Types;

unit package GStreamer::Raw::Query;

sub gst_query_add_allocation_meta (
  GstQuery $query,
  GType $api,
  GstStructure $params
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_add_allocation_param (
  GstQuery $query,
  GstAllocator $allocator,
  GstAllocationParams $params
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_add_allocation_pool (
  GstQuery $query,
  GstBufferPool $pool,
  guint $size,
  guint $min_buffers,
  guint $max_buffers
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_add_buffering_range (
  GstQuery $query,
  gint64 $start,
  gint64 $stop
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_query_add_scheduling_mode (GstQuery $query, GstPadMode $mode)
  is native(gstreamer)
  is export
{ * }

sub gst_query_find_allocation_meta (GstQuery $query, GType $api, guint $index)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_query_get_n_allocation_metas (GstQuery $query)
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_query_get_n_allocation_params (GstQuery $query)
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_query_get_n_allocation_pools (GstQuery $query)
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_query_get_n_buffering_ranges (GstQuery $query)
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_query_get_n_scheduling_modes (GstQuery $query)
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_query_get_structure (GstQuery $query)
  returns GstStructure
  is native(gstreamer)
  is export
{ * }

sub gst_query_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_query_has_scheduling_mode (GstQuery $query, GstPadMode $mode)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_query_has_scheduling_mode_with_flags (
  GstQuery $query,
  guint $mode,     # GstPadMode $mode,
  guint $flags     # GstSchedulingFlags $flags
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_query_new_accept_caps (GstCaps $caps)
  returns GstQuery
  is native(gstreamer)
  is export
{ * }

sub gst_query_new_allocation (GstCaps $caps, gboolean $need_pool)
  returns GstQuery
  is native(gstreamer)
  is export
{ * }

sub gst_query_new_bitrate ()
  returns GstQuery
  is native(gstreamer)
  is export
{ * }

sub gst_query_new_buffering (GstFormat $format)
  returns GstQuery
  is native(gstreamer)
  is export
{ * }

sub gst_query_new_caps (GstCaps $filter)
  returns GstQuery
  is native(gstreamer)
  is export
{ * }

sub gst_query_new_context (Str $context_type)
  returns GstQuery
  is native(gstreamer)
  is export
{ * }

sub gst_query_new_convert (
  GstFormat $src_format,
  gint64 $value,
  GstFormat $dest_format
)
  returns GstQuery
  is native(gstreamer)
  is export
{ * }

sub gst_query_new_custom (
  guint $type,     # GstQueryType $type,
  GstStructure $structure
)
  returns GstQuery
  is native(gstreamer)
  is export
{ * }

sub gst_query_new_drain ()
  returns GstQuery
  is native(gstreamer)
  is export
{ * }

sub gst_query_new_duration (GstFormat $format)
  returns GstQuery
  is native(gstreamer)
  is export
{ * }

sub gst_query_new_formats ()
  returns GstQuery
  is native(gstreamer)
  is export
{ * }

sub gst_query_new_latency ()
  returns GstQuery
  is native(gstreamer)
  is export
{ * }

sub gst_query_new_position (GstFormat $format)
  returns GstQuery
  is native(gstreamer)
  is export
{ * }

sub gst_query_new_scheduling ()
  returns GstQuery
  is native(gstreamer)
  is export
{ * }

sub gst_query_new_seeking (GstFormat $format)
  returns GstQuery
  is native(gstreamer)
  is export
{ * }

sub gst_query_new_segment (GstFormat $format)
  returns GstQuery
  is native(gstreamer)
  is export
{ * }

sub gst_query_new_uri ()
  returns GstQuery
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_accept_caps (GstQuery $query, GstCaps $caps)
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_accept_caps_result (GstQuery $query, gboolean $result)
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_allocation (
  GstQuery $query,
  GstCaps $caps,
  gboolean $need_pool
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_bitrate (GstQuery $query, guint $nominal_bitrate)
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_buffering_percent (
  GstQuery $query,
  gboolean $busy,
  gint $percent
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_buffering_range (
  GstQuery $query,
  guint $format, # GstFormat $format,
  gint64 $start,
  gint64 $stop,
  gint64 $estimated_total
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_buffering_stats (
  GstQuery $query,
  GstBufferingMode $mode,
  gint $avg_in,
  gint $avg_out,
  gint64 $buffering_left
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_caps (GstQuery $query, GstCaps $filter)
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_caps_result (GstQuery $query, GstCaps $caps)
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_context (GstQuery $query, GstContext $context)
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_context_type (GstQuery $query, Str $context_type)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_convert (
  GstQuery $query,
  GstFormat $src_format,
  gint64 $src_value,
  GstFormat $dest_format,
  gint64 $dest_value
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_duration (
  GstQuery $query,
  GstFormat $format,
  gint64 $duration
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_latency (
  GstQuery $query,
  gboolean $live,
  GstClockTime $min_latency,
  GstClockTime $max_latency
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_n_formats (GstQuery $query, guint $n_formats)
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_nth_allocation_meta (
  GstQuery $query,
  guint $index,
  GstStructure $params
)
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_nth_allocation_param (
  GstQuery $query,
  guint $index,
  GstAllocator $allocator,
  GstAllocationParams $params
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_nth_allocation_pool (
  GstQuery $query,
  guint $index,
  GstBufferPool $pool,
  guint $size,
  guint $min_buffers,
  guint $max_buffers
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_nth_buffering_range (
  GstQuery $query,
  guint $index,
  gint64 $start,
  gint64 $stop
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_nth_format (GstQuery $query, guint $nth, GstFormat $format)
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_nth_scheduling_mode (GstQuery $query, guint $index)
  returns GstPadMode
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_position (GstQuery $query, GstFormat $format, gint64 $cur)
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_scheduling (
  GstQuery $query,
  GstSchedulingFlags $flags,
  gint $minsize,
  gint $maxsize,
  gint $align
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_seeking (
  GstQuery $query,
  GstFormat $format     is rw,
  gboolean $seekable    is rw,
  gint64 $segment_start is rw,
  gint64 $segment_end   is rw
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_segment (
  GstQuery $query,
  gdouble $rate,
  GstFormat $format,
  gint64 $start_value,
  gint64 $stop_value
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_uri (GstQuery $query, Str $uri)
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_uri_redirection (GstQuery $query, Str $uri)
  is native(gstreamer)
  is export
{ * }

sub gst_query_parse_uri_redirection_permanent (
  GstQuery $query,
  gboolean $permanent
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_remove_nth_allocation_meta (GstQuery $query, guint $index)
  is native(gstreamer)
  is export
{ * }

sub gst_query_remove_nth_allocation_param (GstQuery $query, guint $index)
  is native(gstreamer)
  is export
{ * }

sub gst_query_remove_nth_allocation_pool (GstQuery $query, guint $index)
  is native(gstreamer)
  is export
{ * }

sub gst_query_set_accept_caps_result (GstQuery $query, gboolean $result)
  is native(gstreamer)
  is export
{ * }

sub gst_query_set_bitrate (GstQuery $query, guint $nominal_bitrate)
  is native(gstreamer)
  is export
{ * }

sub gst_query_set_buffering_percent (
  GstQuery $query,
  gboolean $busy,
  gint $percent
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_set_buffering_range (
  GstQuery $query,
  GstFormat $format,
  gint64 $start,
  gint64 $stop,
  gint64 $estimated_total
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_set_buffering_stats (
  GstQuery $query,
  GstBufferingMode $mode,
  gint $avg_in,
  gint $avg_out,
  gint64 $buffering_left
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_set_caps_result (GstQuery $query, GstCaps $caps)
  is native(gstreamer)
  is export
{ * }

sub gst_query_set_context (GstQuery $query, GstContext $context)
  is native(gstreamer)
  is export
{ * }

sub gst_query_set_convert (
  GstQuery $query,
  GstFormat $src_format,
  gint64 $src_value,
  GstFormat $dest_format,
  gint64 $dest_value
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_set_duration (
  GstQuery $query,
  GstFormat $format,
  gint64 $duration
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_set_formatsv (
  GstQuery $query,
  gint $n_formats,
  GstFormat $formats
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_set_latency (
  GstQuery $query,
  gboolean $live,
  GstClockTime $min_latency,
  GstClockTime $max_latency
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_set_nth_allocation_param (
  GstQuery $query,
  guint $index,
  GstAllocator $allocator,
  GstAllocationParams $params
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_set_nth_allocation_pool (
  GstQuery $query,
  guint $index,
  GstBufferPool $pool,
  guint $size,
  guint $min_buffers,
  guint $max_buffers
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_set_position (GstQuery $query, GstFormat $format, gint64 $cur)
  is native(gstreamer)
  is export
{ * }

sub gst_query_set_scheduling (
  GstQuery $query,
  GstSchedulingFlags $flags,
  gint $minsize,
  gint $maxsize,
  gint $align
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_set_seeking (
  GstQuery $query,
  GstFormat $format,
  gboolean $seekable,
  gint64 $segment_start,
  gint64 $segment_end
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_set_segment (
  GstQuery $query,
  gdouble $rate,
  GstFormat $format,
  gint64 $start_value,
  gint64 $stop_value
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_set_uri (GstQuery $query, Str $uri)
  is native(gstreamer)
  is export
{ * }

sub gst_query_set_uri_redirection (GstQuery $query, Str $uri)
  is native(gstreamer)
  is export
{ * }

sub gst_query_set_uri_redirection_permanent (
  GstQuery $query,
  gboolean $permanent
)
  is native(gstreamer)
  is export
{ * }

sub gst_query_type_get_flags (GstQueryType $type)
  returns GstQueryTypeFlags
  is native(gstreamer)
  is export
{ * }

sub gst_query_type_get_name (GstQueryType $type)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_query_type_to_quark (GstQueryType $type)
  returns GQuark
  is native(gstreamer)
  is export
{ * }

sub gst_query_writable_structure (GstQuery $query)
  returns GstStructure
  is native(gstreamer)
  is export
{ * }
