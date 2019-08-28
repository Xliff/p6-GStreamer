use v6.c;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::Query;

use GStreamer::MiniObject;

class GStreamer::Query is GStreamer::MiniObject {
  has GstQuery $!q handles <type>;

  submethod BUILD (:$query) {
    self.setMiniObject( cast(GstMiniObject, $!q = $query) );
  }

  multi method new (GstQuery $query) {
    self.bless( :$query ) if $query.defined;
  }

  multi method new (GstCaps() $c, :accept-caps(:$accept_caps) is required) {
    GStreamer::Query.new_accept_caps($c);
  }
  method new_accept_caps (GstCaps() $c) {
    self.bless( query => gst_query_new_accept_caps($c) );
  }

  multi method new (
    GstCaps() $c,
    Int() $need_pool,
    :new-allocation(:$new_allocation) is required
  ) {
    GStreamer::Query.new_allocation($c, $need_pool);
  }
  method new_allocation (GstCaps() $c, Int() $need_pool) {
    my gboolean $n = $need_pool.so.Int;

    self.bless( query => gst_query_new_allocation($c, $need_pool) );
  }

  multi method new (:$bitrate is required) {
    GStreamer::Query.new_bitrate;
  }s
  method new_bitrate {
    self.bless( query  => gst_query_new_bitrate() );
  }

  multi method new (Int() $format, :$buffering is required) {
    GStreamer::Query.new_buffering($format);
  }
  method new_buffering (Int() $format) {
    my GstFormat $f = $format;

    self.bless( query => gst_query_new_buffering($f) );
  }

  multi method new (GstCaps() $f, :$caps is required) {
    GStreamer::Query.new_caps($f);
  }
  method new_caps (GstCaps() $f) {
    self.bless( querry => gst_query_new_caps($f) );
  }

  multi method new (Str() $context, :$context is required) {
    GStreamer::Query.new_context($context);
  }
  method new_context (Str() $context) {
    self.bless( query => gst_query_new_context($context);
  }

  multi method new (
    Int() $src_format,
    Int() $value,
    Int() $dest_format,
    :$convert is required
  ) {
    GStreamer::Query.new_convert($src_format, $value, $dest_format);
  }
  method new_convert (Int() $src_format, Int() $value, Int() $dest_format) {
    my gint64 $value;
    my GstFormat ($sf, $df) = ($src_format, $dest_format);

    self.bless( query => gst_query_new_convert($sf, $value, $df) );
  }

  multi method new (
    Int() $type,
    GstStructure() $structure,
    :$custom is required
  ) {
    GStreamer::Query.new_custom($type, $structure);
  }
  method new_custom (Int() $type, GstStructure() $structure) {
    self.bless( query => gst_query_new_custom($type, $structure) );
  }

  method new (:$drain is required) {
    GStreamer::Query.new_drain;
  }
  method new_drain {
    self.bless( query => gst_query_new_drain() );
  }

  multi method new (Int() $format, :$duration is required) {
    GStreamer::Query.new_duration($format);
  }
  method new_duration (Int() $format) {
    my GstFormat $f = $format;

    self.bless(query => gst_query_new_duration($f) );
  }

  multi method new (:$formats is required) {
    GStreamer::Query.new_formats;
  }
  method new_formats {
    self.bless(query => gst_query_new_formats() );
  }

  multi method new (:$latency is required) {
    GStreamer::Query.new_latency;
  }
  method new_latency {
    self.bless(query => gst_query_new_latency() );
  }

  multi method new_position (Int() $format, :$position is required) {
    GStreamer::Query.new_position($format);
  }
  method new_position (Int() $format) {
    my GstFormat $f = $format;

    self.bless(query => gst_query_new_position($f) );
  }

  multi method new (:$scheduling is required) {
    GStreamer::Query.new_scheduling();
  }
  method new_scheduling {
    self.bless(query => gst_query_new_scheduling() );
  }

  multi method new (Int() $format, :$seeking is required) {
    GStreamer::Query.new_seeking($format);
  }
  method new_seeking (Int() $format) {
    my GstFormat $f = $format;

    self.bless(query => gst_query_new_seeking($f) );
  }

  multi method new (Int() $format, :$segment is required) {
    GStreamer::Query.new_segment($format);
  }
  method new_segment (Int() $format) {
    my GstFormat $f = $format;

    self.bless(query => gst_query_new_segment($f) );
  }

  multi method new (:$uri is required) {
    GStreamer::Query.new_uri;
  }
  method new_uri {
    self.bless(query => gst_query_new_uri() );
  }

  method add_allocation_meta (GType $api, GstStructure $params) {
    gst_query_add_allocation_meta($!q, $api, $params);
  }

  method add_allocation_param (GstAllocator $allocator, GstAllocationParams $params) {
    gst_query_add_allocation_param($!q, $allocator, $params);
  }

  method add_allocation_pool (GstBufferPool $pool, guint $size, guint $min_buffers, guint $max_buffers) {
    gst_query_add_allocation_pool($!q, $pool, $size, $min_buffers, $max_buffers);
  }

  method add_buffering_range (gint64 $start, gint64 $stop) {
    gst_query_add_buffering_range($!q, $start, $stop);
  }

  method add_scheduling_mode (GstPadMode $mode) {
    gst_query_add_scheduling_mode($!q, $mode);
  }

  method find_allocation_meta (GType $api, guint $index) {
    gst_query_find_allocation_meta($!q, $api, $index);
  }

  method get_n_allocation_metas {
    gst_query_get_n_allocation_metas($!q);
  }

  method get_n_allocation_params {
    gst_query_get_n_allocation_params($!q);
  }

  method get_n_allocation_pools {
    gst_query_get_n_allocation_pools($!q);
  }

  method get_n_buffering_ranges {
    gst_query_get_n_buffering_ranges($!q);
  }

  method get_n_scheduling_modes {
    gst_query_get_n_scheduling_modes($!q);
  }

  method get_structure {
    gst_query_get_structure($!q);
  }

  method get_type {
    gst_query_get_type();
  }

  method has_scheduling_mode (GstPadMode $mode) {
    gst_query_has_scheduling_mode($!q, $mode);
  }

  method has_scheduling_mode_with_flags (GstPadMode $mode, GstSchedulingFlags $flags) {
    gst_query_has_scheduling_mode_with_flags($!q, $mode, $flags);
  }

  method parse_accept_caps (GstCaps $caps) {
    gst_query_parse_accept_caps($!q, $caps);
  }

  method parse_accept_caps_result (gboolean $result) {
    gst_query_parse_accept_caps_result($!q, $result);
  }

  method parse_allocation (GstCaps $caps, gboolean $need_pool) {
    gst_query_parse_allocation($!q, $caps, $need_pool);
  }

  method parse_bitrate (guint $nominal_bitrate) {
    gst_query_parse_bitrate($!q, $nominal_bitrate);
  }

  method parse_buffering_percent (gboolean $busy, gint $percent) {
    gst_query_parse_buffering_percent($!q, $busy, $percent);
  }

  method parse_buffering_range (GstFormat $format, gint64 $start, gint64 $stop, gint64 $estimated_total) {
    gst_query_parse_buffering_range($!q, $format, $start, $stop, $estimated_total);
  }

  method parse_buffering_stats (GstBufferingMode $mode, gint $avg_in, gint $avg_out, gint64 $buffering_left) {
    gst_query_parse_buffering_stats($!q, $mode, $avg_in, $avg_out, $buffering_left);
  }

  method parse_caps (GstCaps $filter) {
    gst_query_parse_caps($!q, $filter);
  }

  method parse_caps_result (GstCaps $caps) {
    gst_query_parse_caps_result($!q, $caps);
  }

  method parse_context (GstContext $context) {
    gst_query_parse_context($!q, $context);
  }

  method parse_context_type (Str $context_type) {
    gst_query_parse_context_type($!q, $context_type);
  }

  method parse_convert (GstFormat $src_format, gint64 $src_value, GstFormat $dest_format, gint64 $dest_value) {
    gst_query_parse_convert($!q, $src_format, $src_value, $dest_format, $dest_value);
  }

  method parse_duration (GstFormat $format, gint64 $duration) {
    gst_query_parse_duration($!q, $format, $duration);
  }

  method parse_latency (gboolean $live, GstClockTime $min_latency, GstClockTime $max_latency) {
    gst_query_parse_latency($!q, $live, $min_latency, $max_latency);
  }

  method parse_n_formats (guint $n_formats) {
    gst_query_parse_n_formats($!q, $n_formats);
  }

  method parse_nth_allocation_meta (guint $index, GstStructure $params) {
    gst_query_parse_nth_allocation_meta($!q, $index, $params);
  }

  method parse_nth_allocation_param (guint $index, GstAllocator $allocator, GstAllocationParams $params) {
    gst_query_parse_nth_allocation_param($!q, $index, $allocator, $params);
  }

  method parse_nth_allocation_pool (guint $index, GstBufferPool $pool, guint $size, guint $min_buffers, guint $max_buffers) {
    gst_query_parse_nth_allocation_pool($!q, $index, $pool, $size, $min_buffers, $max_buffers);
  }

  method parse_nth_buffering_range (guint $index, gint64 $start, gint64 $stop) {
    gst_query_parse_nth_buffering_range($!q, $index, $start, $stop);
  }

  method parse_nth_format (guint $nth, GstFormat $format) {
    gst_query_parse_nth_format($!q, $nth, $format);
  }

  method parse_nth_scheduling_mode (guint $index) {
    gst_query_parse_nth_scheduling_mode($!q, $index);
  }

  method parse_position (GstFormat $format, gint64 $cur) {
    gst_query_parse_position($!q, $format, $cur);
  }

  method parse_scheduling (GstSchedulingFlags $flags, gint $minsize, gint $maxsize, gint $align) {
    gst_query_parse_scheduling($!q, $flags, $minsize, $maxsize, $align);
  }

  method parse_seeking (GstFormat $format, gboolean $seekable, gint64 $segment_start, gint64 $segment_end) {
    gst_query_parse_seeking($!q, $format, $seekable, $segment_start, $segment_end);
  }

  method parse_segment (gdouble $rate, GstFormat $format, gint64 $start_value, gint64 $stop_value) {
    gst_query_parse_segment($!q, $rate, $format, $start_value, $stop_value);
  }

  method parse_uri (Str $uri) {
    gst_query_parse_uri($!q, $uri);
  }

  method parse_uri_redirection (Str $uri) {
    gst_query_parse_uri_redirection($!q, $uri);
  }

  method parse_uri_redirection_permanent (gboolean $permanent) {
    gst_query_parse_uri_redirection_permanent($!q, $permanent);
  }

  method remove_nth_allocation_meta (guint $index) {
    gst_query_remove_nth_allocation_meta($!q, $index);
  }

  method remove_nth_allocation_param (guint $index) {
    gst_query_remove_nth_allocation_param($!q, $index);
  }

  method remove_nth_allocation_pool (guint $index) {
    gst_query_remove_nth_allocation_pool($!q, $index);
  }

  method set_accept_caps_result (gboolean $result) {
    gst_query_set_accept_caps_result($!q, $result);
  }

  method set_bitrate (guint $nominal_bitrate) {
    gst_query_set_bitrate($!q, $nominal_bitrate);
  }

  method set_buffering_percent (gboolean $busy, gint $percent) {
    gst_query_set_buffering_percent($!q, $busy, $percent);
  }

  method set_buffering_range (GstFormat $format, gint64 $start, gint64 $stop, gint64 $estimated_total) {
    gst_query_set_buffering_range($!q, $format, $start, $stop, $estimated_total);
  }

  method set_buffering_stats (GstBufferingMode $mode, gint $avg_in, gint $avg_out, gint64 $buffering_left) {
    gst_query_set_buffering_stats($!q, $mode, $avg_in, $avg_out, $buffering_left);
  }

  method set_caps_result (GstCaps $caps) {
    gst_query_set_caps_result($!q, $caps);
  }

  method set_context (GstContext $context) {
    gst_query_set_context($!q, $context);
  }

  method set_convert (GstFormat $src_format, gint64 $src_value, GstFormat $dest_format, gint64 $dest_value) {
    gst_query_set_convert($!q, $src_format, $src_value, $dest_format, $dest_value);
  }

  method set_duration (GstFormat $format, gint64 $duration) {
    gst_query_set_duration($!q, $format, $duration);
  }

  method set_formatsv (gint $n_formats, GstFormat $formats) {
    gst_query_set_formatsv($!q, $n_formats, $formats);
  }

  method set_latency (gboolean $live, GstClockTime $min_latency, GstClockTime $max_latency) {
    gst_query_set_latency($!q, $live, $min_latency, $max_latency);
  }

  method set_nth_allocation_param (guint $index, GstAllocator $allocator, GstAllocationParams $params) {
    gst_query_set_nth_allocation_param($!q, $index, $allocator, $params);
  }

  method set_nth_allocation_pool (guint $index, GstBufferPool $pool, guint $size, guint $min_buffers, guint $max_buffers) {
    gst_query_set_nth_allocation_pool($!q, $index, $pool, $size, $min_buffers, $max_buffers);
  }

  method set_position (GstFormat $format, gint64 $cur) {
    gst_query_set_position($!q, $format, $cur);
  }

  method set_scheduling (GstSchedulingFlags $flags, gint $minsize, gint $maxsize, gint $align) {
    gst_query_set_scheduling($!q, $flags, $minsize, $maxsize, $align);
  }

  method set_seeking (GstFormat $format, gboolean $seekable, gint64 $segment_start, gint64 $segment_end) {
    gst_query_set_seeking($!q, $format, $seekable, $segment_start, $segment_end);
  }

  method set_segment (gdouble $rate, GstFormat $format, gint64 $start_value, gint64 $stop_value) {
    gst_query_set_segment($!q, $rate, $format, $start_value, $stop_value);
  }

  method set_uri (Str $uri) {
    gst_query_set_uri($!q, $uri);
  }

  method set_uri_redirection (Str $uri) {
    gst_query_set_uri_redirection($!q, $uri);
  }

  method set_uri_redirection_permanent (gboolean $permanent) {
    gst_query_set_uri_redirection_permanent($!q, $permanent);
  }

  method type_get_flags {
    gst_query_type_get_flags($!q);
  }

  method type_get_name {
    gst_query_type_get_name($!q);
  }

  method type_to_quark {
    gst_query_type_to_quark($!q);
  }

  method writable_structure {
    gst_query_writable_structure($!q);
  }

}
