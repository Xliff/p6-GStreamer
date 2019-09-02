use v6.c;

use Method::Also;

use NativeCall;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::Query;

use GStreamer::Raw::Subs;

use GStreamer::MiniObject;
use GStreamer::Allocator;
use GStreamer::Structure;

our subset QueryAncestry is export of Mu
  where GstQuery | GstMiniObject;

class GStreamer::Query is GStreamer::MiniObject {
  has GstQuery $!q handles <type>;

  submethod BUILD (:$query) {
    self.setQuery($query);
  }

  method setQuery (QueryAncestry $_) {
    my $to-parent;

    $!q = do {
      when GstQuery {
        $to-parent = cast(GstMiniObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstQuery, $_);
      }
    }
    self.setMiniObject($to-parent);
  }

  method GStreamer::Raw::Types::GstQuery
  { $!q }

  multi method new (GstQuery $query) {
    self.bless( :$query ) if $query.defined;
  }

  multi method new (GstCaps() $c, :accept-caps(:$accept_caps) is required) {
    GStreamer::Query.new_accept_caps($c);
  }
  method new_accept_caps (GstCaps() $c) is also<new-accept-caps> {
    self.bless( query => gst_query_new_accept_caps($c) );
  }

  multi method new (
    GstCaps() $c,
    Int() $need_pool,
    :new-allocation(:$new_allocation) is required
  ) {
    GStreamer::Query.new_allocation($c, $need_pool);
  }
  method new_allocation (GstCaps() $c, Int() $need_pool)
    is also<new-allocation>
  {
    my gboolean $n = $need_pool.so.Int;

    self.bless( query => gst_query_new_allocation($c, $need_pool) );
  }

  multi method new (:$bitrate is required) {
    GStreamer::Query.new_bitrate;
  }
  method new_bitrate is also<new-bitrate> {
    self.bless( query  => gst_query_new_bitrate() );
  }

  multi method new (Int() $format, :$buffering is required) {
    GStreamer::Query.new_buffering($format);
  }
  method new_buffering (Int() $format) is also<new-buffering> {
    my GstFormat $f = $format;

    self.bless( query => gst_query_new_buffering($f) );
  }

  multi method new (GstCaps() $f, :$caps is required) {
    GStreamer::Query.new_caps($f);
  }
  method new_caps (GstCaps() $f) is also<new-caps> {
    self.bless( querry => gst_query_new_caps($f) );
  }

  multi method new (Str() $ctxt, :$context is required) {
    GStreamer::Query.new_context($ctxt);
  }
  method new_context (Str() $context) is also<new-context> {
    self.bless( query => gst_query_new_context($context) );
  }

  multi method new (
    Int() $src_format,
    Int() $value,
    Int() $dest_format,
    :$convert is required
  ) {
    GStreamer::Query.new_convert($src_format, $value, $dest_format);
  }
  method new_convert (Int() $src_format, Int() $value, Int() $dest_format)
    is also<new-convert>
  {
    my gint64 $v = 0;
    my GstFormat ($sf, $df) = ($src_format, $dest_format);

    self.bless( query => gst_query_new_convert($sf, $v, $df) );
  }

  multi method new (
    Int() $type,
    GstStructure() $structure,
    :$custom is required
  ) {
    GStreamer::Query.new_custom($type, $structure);
  }
  method new_custom (Int() $type, GstStructure() $structure)
    is also<new-custom>
  {
    self.bless( query => gst_query_new_custom($type, $structure) );
  }

  multi method new (:$drain is required) {
    GStreamer::Query.new_drain;
  }
  method new_drain is also<new-drain> {
    self.bless( query => gst_query_new_drain() );
  }

  multi method new (Int() $format, :$duration is required) {
    GStreamer::Query.new_duration($format);
  }
  method new_duration (Int() $format) is also<new-duration> {
    my GstFormat $f = $format;

    self.bless( query => gst_query_new_duration($f) );
  }

  multi method new (:$formats is required) {
    GStreamer::Query.new_formats;
  }
  method new_formats is also<new-formats> {
    self.bless( query => gst_query_new_formats() );
  }

  multi method new (:$latency is required) {
    GStreamer::Query.new_latency;
  }
  method new_latency is also<new-latency> {
    self.bless( query => gst_query_new_latency() );
  }

  multi method new (Int() $format, :$position is required) {
    GStreamer::Query.new_position($format);
  }
  method new_position (Int() $format) is also<new-position> {
    my GstFormat $f = $format;

    self.bless( query => gst_query_new_position($f) );
  }

  multi method new (:$scheduling is required) {
    GStreamer::Query.new_scheduling();
  }
  method new_scheduling is also<new-scheduling> {
    self.bless( query => gst_query_new_scheduling() );
  }

  multi method new (Int() $format, :$seeking is required) {
    GStreamer::Query.new_seeking($format);
  }
  method new_seeking (Int() $format) is also<new-seeking> {
    my GstFormat $f = $format;

    self.bless( query => gst_query_new_seeking($f) );
  }

  multi method new (Int() $format, :$segment is required) {
    GStreamer::Query.new_segment($format);
  }
  method new_segment (Int() $format) is also<new-segment> {
    my GstFormat $f = $format;

    self.bless( query => gst_query_new_segment($f) );
  }

  multi method new (:$uri is required) {
    GStreamer::Query.new_uri;
  }
  method new_uri is also<new-uri> {
    self.bless( query => gst_query_new_uri() );
  }

  method add_allocation_meta (Int() $api, GstStructure() $params)
    is also<add-allocation-meta>
  {
    my GType $a = $api;

    gst_query_add_allocation_meta($!q, $a, $params);
  }

  method add_allocation_param (
    GstAllocator() $allocator,
    GstAllocationParams() $params
  )
    is also<add-allocation-param>
  {
    gst_query_add_allocation_param($!q, $allocator, $params);
  }

  method add_allocation_pool (
    GstBufferPool() $pool,
    Int() $size,
    Int() $min_buffers,
    Int() $max_buffers
  )
    is also<add-allocation-pool>
  {
    my guint ($s, $mnb, $mxb) = ($size, $min_buffers, $max_buffers);
    gst_query_add_allocation_pool($!q, $pool, $s, $mnb, $mxb);
  }

  method add_buffering_range (Int() $start, Int() $stop)
    is also<add-buffering-range>
  {
    my ($st, $sp) = ($start, $stop);

    gst_query_add_buffering_range($!q, $st, $sp);
  }

  method add_scheduling_mode (Int() $mode) is also<add-scheduling-mode> {
    my GstPadMode $m = $mode;

    gst_query_add_scheduling_mode($!q, $m);
  }

  # method copy {
  #   self.bless( query => GStreamer::MiniObject.copy($!q.GstMiniObject) );
  # }

  method find_allocation_meta (Int() $api, Int() $index)
    is also<find-allocation-meta>
  {
    my GType $a = $api;
    my guint $i = $index;

    so gst_query_find_allocation_meta($!q, $api, $index);
  }

  method get_n_allocation_metas is also<get-n-allocation-metas> {
    gst_query_get_n_allocation_metas($!q);
  }

  method get_n_allocation_params is also<get-n-allocation-params> {
    gst_query_get_n_allocation_params($!q);
  }

  method get_n_allocation_pools is also<get-n-allocation-pools> {
    gst_query_get_n_allocation_pools($!q);
  }

  method get_n_buffering_ranges is also<get-n-buffering-ranges> {
    gst_query_get_n_buffering_ranges($!q);
  }

  method get_n_scheduling_modes is also<get-n-scheduling-modes> {
    gst_query_get_n_scheduling_modes($!q);
  }

  method get_structure (:$raw = False) is also<get-structure> {
    my $s = gst_query_get_structure($!q);

    $s ??
      ( $raw ?? $s !! GStreamer::Structure.new($s) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_query_get_type, $n, $t );
  }

  method has_scheduling_mode (Int() $mode) is also<has-scheduling-mode> {
    my GstPadMode $m = $mode;

    so gst_query_has_scheduling_mode($!q, $m);
  }

  method has_scheduling_mode_with_flags (
    Int() $mode,
    Int() $flags
  )
    is also<has-scheduling-mode-with-flags>
  {
    my GstPadMode $m = $mode;
    my GstSchedulingFlags $f = $flags;

    so gst_query_has_scheduling_mode_with_flags($!q, $m, $f);
  }

  proto method parse_accept_caps (|)
      is also<parse-accept-caps>
  { * }

  multi method parse_accept_caps {
    samewith ($);
  }
  multi method parse_accept_caps ($caps is rw) {
    my $c = CArray[Pointer[GstCaps]].new;
    $c[0] = Pointer[GstCaps].new;

    my $rc = gst_query_parse_accept_caps($!q, $c);
    ($caps) = ppr( $c[0] );
    $caps;
  }

  proto method parse_accept_caps_result (|)
      is also<parse-accept-caps-result>
  { * }

  multi method parse_accept_caps_result  {
    samewith($);
  }
  multi method parse_accept_caps_result ($result is rw, :$all = False) {
    my gboolean $r = 0;

    gst_query_parse_accept_caps_result($!q, $r);
    $result = $r;
  }

  proto method parse_allocation (|)
      is also<parse-allocation>
  { * }

  multi method parse_allocation {
    samewith ($, $);
  }
  multi method parse_allocation ($caps is rw, $need_pool is rw) {
    my gboolean $np = 0;
    my $c = CArray[Pointer[GstCaps]].new;
    $c[0] = Pointer[GstCaps].new;

    gst_query_parse_allocation($!q, $c, $np);
    ($caps, $need_pool) = ppr($c, $np);
  }

  proto method parse_bitrate (|)
      is also<parse-bitrate>
  { * }

  multi method parse_bitrate {
    samewith($, $);
  }
  multi method parse_bitrate ($nominal_bitrate is rw) {
    my guint $nb = 0;
    gst_query_parse_bitrate($!q, $nb);

    $nominal_bitrate = $nb;
  }

  proto method parse_buffering_percent (|)
      is also<parse-buffering-percent>
  { * }

  multi method parse_buffering_percent {
    samewith($, $);
  }
  multi method parse_buffering_percent ($busy is rw, $percent is rw) {
    my guint ($b, $p) = 0 xx 2;
    gst_query_parse_buffering_percent($!q, $b, $p);

    ($busy, $percent) = ($b, $p);
  }

  proto method parse_buffering_range (|)
      is also<parse-buffering-range>
  { * }

  multi method parse_buffering_range {
    samewith($, $, $, $);
  }
  multi method parse_buffering_range (
    $format          is rw,
    $start           is rw,
    $stop            is rw,
    $estimated_total is rw
  ) {
    my GstFormat $f = 0;
    my gint64 ($st, $sp, $et) = 0 xx 3;
    gst_query_parse_buffering_range($!q, $f, $st, $sp, $et);

    ($format, $start, $stop, $estimated_total) = ($f, $st, $sp, $et);
  }

  proto method parse_buffering_stats (|)
      is also<parse-buffering-stats>
  { * }

  multi method parse_buffering_stats {
    samewith($, $, $, $);
  }
  multi method parse_buffering_stats (
    $mode           is rw,
    $avg_in         is rw,
    $avg_out        is rw,
    $buffering_left is rw
  ) {
    my GstBufferingMode $m = $mode;
    my gint ($ai, $ao) = ($avg_in, $avg_out);
    my gint64 $bl = $buffering_left;
    gst_query_parse_buffering_stats($!q, $m, $ai, $ao, $bl);

    ($mode ,$avg_in ,$avg_out ,$buffering_left) = ($m, $ai, $ao, $bl);
  }

  proto method parse_caps (|)
    is also<parse-caps>
  { * }

  multi method parse_caps {
    samewith($);
  }
  multi method parse_caps ($filter is rw) {
    my $fa = CArray[Pointer[GstCaps]].new;

    $fa[0] = Pointer[GstCaps].new;
    gst_query_parse_caps($!q, $fa);
    ($filter) = ppr($fa);
    $filter;
  }

  proto method parse_caps_result (|)
    is also<parse-caps-result>
  { * }

  multi method parse_caps_result {
    samewith($);
  }
  multi method parse_caps_result ($caps is rw) {
    my $ca = CArray[Pointer[GstCaps]].new;

    $ca[0] = Pointer[GstCaps].new;
    gst_query_parse_caps_result($!q, $ca);
    ($caps) = ppr($ca);
    $caps;
  }

  proto method parse_context (|)
    is also<parse-context>
  { * }

  multi method parse_context {
    samewith($);
  }
  multi method parse_context ($context is rw)  {
    my $ca = CArray[Pointer[GstContext]].new;

    $ca[0] = Pointer[GstContext].new;
    gst_query_parse_context($!q, $ca);
    ($context) = ppr($ca);
    $context;
  }

  proto method parse_context_type (|)
    is also<parse-context-type>
  { * }

  multi method parse_context_type {
    samewith($);
  }
  multi method parse_context_type ($context_type is rw)  {
    my $cta = CArray[Str].new;

    $cta[0] = Str;
    gst_query_parse_context_type($!q, $cta);
    ($context_type) = ppr($cta);
    $context_type;
  }

  proto method parse_convert (|)
    is also<parse-convert>
  { *  }

  multi method parse_convert {
    samewith($, $, $, $);
  }
  multi method parse_convert (
    $src_format  is rw,
    $src_value   is rw,
    $dest_format is rw,
    $dest_value  is rw
  ) {
    my GstFormat ($sf, $df) = 0 xx 2;
    my gint64 ($sv, $dv) = 0 xx 2;

    gst_query_parse_convert($!q, $sf, $sv, $df, $dv);
    ($src_format, $src_value, $dest_format, $dest_value) = ($sf, $sv, $df, $dv);
  }

  proto method parse_duration (|)
    is also<parse-duration>
  { * }

  multi method parse_duration {
    samewith($, $);
  }
  multi method parse_duration ($format is rw, $duration is rw) {
    my GstFormat $f = 0;
    my gint64 $d = 0;

    gst_query_parse_duration($!q, $f, $d);
    ($format, $duration) = ($f, $d);
  }

  proto method parse_latency (|)
    is also<parse-latency>
  { * }

  multi method parse_latency {
    samewith($, $, $);
  }
  multi method parse_latency (
    $live        is rw,
    $min_latency is rw,
    $max_latency is rw
  )
  {
    my gboolean $l = 0;
    my GstClockTime ($mnl, $mxl) = 0 xx 2;

    gst_query_parse_latency($!q, $live, $min_latency, $max_latency);
    ($live, $min_latency, $max_latency) = ($l, $mnl, $mxl);
  }

  proto method parse_n_formats (|)
    is also<parse-n-formats>
  { * }

  multi method parse_n_formats {
    samewith($);
  }
  multi method parse_n_formats ($n_formats is rw)  {
    my gint $nf = 0;

    gst_query_parse_n_formats($!q, $nf);
    $n_formats = $nf;
  }

  proto method parse_nth_allocation_meta (|)
    is also<parse-nth-allocation-meta>
  { * }

  multi method parse_nth_allocation_meta (Int() $index) {
    samewith($index, $);
  }
  multi method parse_nth_allocation_meta (Int() $index, $params is rw) {
    my guint $i = $index;
    my $sa = CArray[Pointer[GstStructure]].new;

    $sa[0] = Pointer[GstStructure].new;
    gst_query_parse_nth_allocation_meta($!q, $i, $sa);
    $params = ppr($sa);
  }

  proto method parse_nth_allocation_param (|)
    is also<parse-nth-allocation-param>
  { * }

  multi method parse_nth_allocation_param (
    Int() $index,
    GstAllocationParams() $params
  ) {
    samewith($index, $, $params);
  }
  multi method parse_nth_allocation_param (
    Int() $index,
    $allocator is rw,
    GstAllocationParams() $params
  ) {
    my guint $i = $index;
    my $aa = CArray[Pointer[GstAllocator]].new;

    $aa[0] = Pointer[GstAllocator].new;
    gst_query_parse_nth_allocation_param($!q, $i, $aa, $params);
    ($allocator) = ppr($aa);
    $allocator;
  }

  proto method parse_nth_allocation_pool (|)
  { * }

  multi method parse_nth_allocation_pool (Int() $index) {
    samewith($index, $, $, $, $);
  }
  multi method parse_nth_allocation_pool (
    Int() $index,
    $pool        is rw,
    $size        is rw,
    $min_buffers is rw,
    $max_buffers is rw
  )
    is also<parse-nth-allocation-pool>
  {
    my guint $i = $index;
    my guint ($s, $mnb, $mxb) = 0 xx 3;
    my $ba = CArray[Pointer[GstBufferPool]].new;

    $ba[0] = Pointer[GstBufferPool].new;
    gst_query_parse_nth_allocation_pool($!q, $i, $ba, $s, $mnb, $mxb);
    ($pool, $size, $min_buffers, $max_buffers) = ($ba, $s, $mnb, $mxb);
  }

  proto method parse_nth_buffering_range (|)
    is also<parse-nth-buffering-range>
  { * }

  multi method parse_nth_buffering_range (Int() $index) {
    samewith($index, $, $);
  }
  multi method parse_nth_buffering_range (
    Int() $index,
    $start is rw,
    $stop  is rw
  ) {
    my guint $i =  $index;
    my gint64 ($st, $sp) = 0 xx 2;

    gst_query_parse_nth_buffering_range($!q, $i, $st, $sp);
    ($start, $stop) = ($st, $sp);
  }

  proto method parse_nth_format (|)
    is also<parse-nth-format>
  { * }

  multi method parse_nth_format (Int() $index) {
    samewith($index, $);
  }
  multi method parse_nth_format (Int() $index, $format is rw) {
    my GstFormat $f = 0;
    my guint $i =  $index;

    gst_query_parse_nth_format($!q, $i, $f);
    $format = $f;
  }

  method parse_nth_scheduling_mode (Int() $index)
    is also<parse-nth-scheduling-mode>
  {
    my guint $i =  $index;

    GstPadModeEnum( gst_query_parse_nth_scheduling_mode($!q, $i) );
  }

  # There is no line, here.

  proto method parse_position (|)
    is also<parse-position>
  { * }

  multi method parse_position {
    samewith($, $);
  }
  multi method parse_position ($format is rw, $cur is rw) {
    my GstFormat $f = 0;
    my gint64    $c = 0;

    gst_query_parse_position($!q, $f, $c);
    ($format, $cur) = ($f, $c);
  }

  proto method parse_scheduling (|)
    is also<parse-scheduling>
  { * }

  multi method parse_scheduling {
    samewith($, $, $, $);
  }
  multi method parse_scheduling (
    $flags   is rw,
    $minsize is rw,
    $maxsize is rw,
    $align   is rw
  ) {
    my GstSchedulingFlags $f = 0;
    my gint ($mns, $mxs, $a) = 0 xx 3;

    gst_query_parse_scheduling($!q, $f, $mns, $mxs, $a);
    ($flags, $minsize, $maxsize, $align) = ($f, $mns, $mxs, $a);
  }

  proto method parse_seeking (|)
      is also<parse-seeking>
  { * }

  multi method parse_seeking {
    samewith($, $, $, $);
  }
  multi method parse_seeking (
    $format        is rw,
    $seekable      is rw,
    $segment_start is rw,
    $segment_end   is rw
  ) {
    my GstFormat $f = 0;
    my gboolean  $s = 0;
    my gint64    ($ss, $se) = 0 xx 2;

    gst_query_parse_seeking($!q, $f, $s, $ss, $se);
    ($format, $seekable, $segment_start, $segment_end) = ($f, $s, $ss, $se);
  }


  proto method parse_segment (|)
    is also<parse-segment>
  { * }

  multi method parse_segment {
    samewith($, $, $, $);
  }
  multi method parse_segment (
    $rate        is rw,
    $format      is rw,
    $start_value is rw,
    $stop_value  is rw
  ) {
    my gdouble $r = 0e0;
    my GstFormat $f = 0;
    my gint64 ($stv, $spv) = 0 xx 2;

    gst_query_parse_segment($!q, $r, $f, $stv, $spv);
    ($rate, $format, $start_value, $stop_value) = ($r, $f, $stv, $spv);
  }

  proto method parse_uri (|)
    is also<parse-uri>
  { * }

  multi method parse_uri {
    samewith($);
  }
  multi method parse_uri ($uri is rw) {
    my $sa = CArray[Str].new;
    $sa[0] = Str;

    gst_query_parse_uri($!q, $sa);
    ($uri) = ppr($sa);
    $uri
  }

  proto method parse_uri_redirection (|)
    is also<parse-uri-redirection>
  { * }

  multi method parse_uri_redirection {
    samewith($);
  }
  multi method parse_uri_redirection ($uri is rw) {
    my $sa = CArray[Str].new;
    $sa[0] = Str;

    gst_query_parse_uri_redirection($!q, $uri);
    ($uri) = ppr($sa);
    $uri
  }

  proto method parse_uri_redirection_permanent (|)
    is also<parse-uri-redirection-permanent>
  { * }

  multi method parse_uri_redirection_permanent {
    samewith($);
  }
  multi method parse_uri_redirection_permanent ($permanent is rw) {
    my gboolean $p = 0;

    gst_query_parse_uri_redirection_permanent($!q, $p);
    $permanent = $p;
  }

  method remove_nth_allocation_meta (Int() $index)
    is also<remove-nth-allocation-meta>
  {
    my gint $i = $index;

    gst_query_remove_nth_allocation_meta($!q, $i);
  }

  method remove_nth_allocation_param (Int() $index)
    is also<remove-nth-allocation-param>
  {
    my gint $i = $index;

    gst_query_remove_nth_allocation_param($!q, $i);
  }

  method remove_nth_allocation_pool (Int() $index)
    is also<remove-nth-allocation-pool>
  {
    my gint $i = $index;

    gst_query_remove_nth_allocation_pool($!q, $i);
  }

  method replace (GstQuery() $q) {
    my $nq = CArray[Pointer[GstQuery]].new;
    $nq[0] = Pointer[GstQuery].new;

    my $rc = gst_query_replace($nq, $q);
    if $rc {
      ($nq) = ppr($nq);
      if $nq {
        self.setQuery($nq)
      } else {
        $rc = False;
      }
    }
    $rc;
  }

  method set_accept_caps_result (Int() $result)
    is also<set-accept-caps-result>
  {
    my gboolean $r = $result;

    gst_query_set_accept_caps_result($!q, $r);
  }

  method set_bitrate (Int() $nominal_bitrate) is also<set-bitrate> {
    my guint $nb = $nominal_bitrate;

    gst_query_set_bitrate($!q, $nb);
  }

  method set_buffering_percent (Int() $busy, Int() $percent)
    is also<set-buffering-percent>
  {
    my gboolean $b = 0;
    my gint     $p = 0;

    gst_query_set_buffering_percent($!q, $b, $p);
  }

  method set_buffering_range (
    Int() $format,
    Int() $start,
    Int() $stop,
    Int() $estimated_total
  )
    is also<set-buffering-range>
  {
    my GstFormat $f = $format;
    my gint64 ($st, $sp, $et) = ($start, $stop ,$estimated_total);

    gst_query_set_buffering_range($!q, $f, $st, $sp, $et);
  }

  method set_buffering_stats (
    Int() $mode,
    Int() $avg_in,
    Int() $avg_out,
    Int() $buffering_left
  )
    is also<set-buffering-stats>
  {
    my GstBufferingMode $m = $mode;
    my gint ($ai, $ao) = ($avg_in, $avg_out);
    my gint64 $bl = $buffering_left;

    gst_query_set_buffering_stats($!q, $m, $ai, $ao, $bl);
  }

  method set_caps_result (GstCaps() $caps) is also<set-caps-result> {
    gst_query_set_caps_result($!q, $caps);
  }

  method set_context (GstContext() $context) is also<set-context> {
    gst_query_set_context($!q, $context);
  }

  method set_convert (
    Int() $src_format,
    Int() $src_value,
    Int() $dest_format,
    Int() $dest_value
  )
    is also<set-convert>
  {
    my GstFormat ($sf, $df) = ($src_format, $dest_format);
    my gint64 ($sv, $dv) = ($src_value, $dest_value);

    gst_query_set_convert($!q, $sf, $sv, $df, $dv);
  }

  method set_duration (Int() $format, Int() $duration)
    is also<set-duration>
  {
    my GstFormat $f = $format;
    my gint64 $d = $duration;

    gst_query_set_duration($!q, $f, $d);
  }

  proto method set_formatsv
    is also<set-formatsv>
  { * }

  multi method set_formats (*@formats) {
    my $fa = CArray[GstFormat].new;

    my $nf = @formats.elems;
    $fa[$_] = @formats[$_] ^$nf;
    self.set_formatsv($nf, $fa);
  }
  multi method set_formatsv (Int() $n_formats, CArray[GstFormat] $formats) {
    my gint $nf = $n_formats;

    gst_query_set_formatsv($!q, $nf, $formats);
  }

  method set_latency (
    Int() $live,
    Int() $min_latency,
    Int() $max_latency
  )
    is also<set-latency>
  {
    my gboolean $l = $live;
    my GstClockTime ($mnl, $mxl) = ($min_latency, $max_latency);

    gst_query_set_latency($!q, $l, $mnl, $mxl);
  }

  proto method set_nth_allocation_param (|)
    is also<set-nth-allocation-param>
  { * }

  multi method set_nth_allocation_param  (
    Int() $index,
    GstAllocator() $allocator,
    @params
  ) {
    die '@params must only contain GStreamer::Allocator-compatible values'
      unless @params.all ~~ (GStreamer::Allocator, GstAllocator).any;

    my $ne = @params.elems;
    my $p = GTK::Compat::Roles::TypedBuffer[GstAllocator].new( size => $ne );

    $p.bind($_, @params[$_]) for ^$ne;
    samewith($index, $allocator, $p.p);
  }
  multi method set_nth_allocation_param (
    Int() $index,
    GstAllocator() $allocator,
    gpointer $params
  ) {
    my guint $i = $index;

    gst_query_set_nth_allocation_param($!q, $index, $allocator, $params);
  }

  method set_nth_allocation_pool (
    Int() $index,
    GstBufferPool() $pool,
    Int() $size,
    Int() $min_buffers,
    Int() $max_buffers
  )
    is also<set-nth-allocation-pool>
  {
    my guint ($i, $s, $mnb, $mxb) = ($index, $size, $min_buffers, $max_buffers);

    gst_query_set_nth_allocation_pool($!q, $i, $pool, $size, $mnb, $mxb);
  }

  method set_position (Int() $format, Int() $cur) is also<set-position> {
    my GstFormat $f = $format;
    my gint64    $c = $cur;

    gst_query_set_position($!q, $f, $c);
  }

  method set_scheduling (
    Int() $flags,
    Int() $minsize,
    Int() $maxsize,
    Int() $align
  )
    is also<set-scheduling>
  {
    my GstSchedulingFlags $f = $flags;
    my gint ($mns, $mxs, $a) = ($minsize, $maxsize, $align);

    gst_query_set_scheduling($!q, $f, $mns, $mxs, $a);
  }

  method set_seeking (
    Int() $format,
    Int() $seekable,
    Int() $segment_start,
    Int() $segment_end
  )
    is also<set-seeking>
  {
    my GstFormat $f = $format;
    my gboolean $s = $seekable;
    my gint64 ($ss, $se) = ($segment_start, $segment_end);

    gst_query_set_seeking($!q, $f, $s, $ss, $se);
  }

  method set_segment (
    Num() $rate,
    Int() $format,
    Int() $start_value,
    Int() $stop_value
  )
    is also<set-segment>
  {
    my gdouble $r = $rate;
    my GstFormat $f = $format;
    my gint64 ($stv, $spv) = ($start_value, $stop_value);

    gst_query_set_segment($!q, $r, $f, $stv, $spv);
  }

  method set_uri (Str() $uri) is also<set-uri> {
    gst_query_set_uri($!q, $uri);
  }

  method set_uri_redirection (Str() $uri) is also<set-uri-redirection> {
    gst_query_set_uri_redirection($!q, $uri);
  }

  method set_uri_redirection_permanent (Int() $permanent)
    is also<set-uri-redirection-permanent>
  {
    my gboolean $p = $permanent;

    gst_query_set_uri_redirection_permanent($!q, $p);
  }

  method type_get_flags (GStreamer::Query:U: Int() $type)
    is also<type-get-flags>
  {
    my GstQueryType $qt = $type;

    gst_query_type_get_flags($qt);
  }

  method type_get_name (GStreamer::Query:U: Int() $type)
    is also<type-get-name>
  {
    my GstQueryType $qt = $type;

    gst_query_type_get_name($qt);
  }

  method type_to_quark (GStreamer::Query:U: Int() $type)
    is also<type-to-quark>
  {
    my GstQueryType $qt = $type;

    gst_query_type_to_quark($qt);
  }

  method writable_structure (:$raw = False) is also<writable-structure> {
    my $s = gst_query_writable_structure($!q);

    $s ??
      ( $raw ?? $s !! GStreamer::Structure.new($s) )
      !!
      Nil;
  }

}
