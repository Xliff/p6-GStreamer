use v6.c;

use NativeCall;
use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Base::Src;

use GStreamer::Allocator;
use GStreamer::BufferPool;
use GStreamer::Element;

our subset GstBaseSrcAncestry is export of Mu
  where GstBaseSrc | GstElementAncestry;

class GStreamer::Base::Src is GStreamer::Element {
  has GstBaseSrc $!bs;

  submethod BUILD (:$base-src) {
    self.setGstBaseSrc($base-src) if $base-src;
  }

  method setGstBaseSrc (GstBaseSrcAncestry $_) {
    my $to-parent;

    $!bs = do {
      when GstBaseSrc {
        $to-parent = cast(GstElement, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstBaseSrc, $_);
      }
    }
    self.setGstElement($to-parent);
  }

  method GStreamer::Raw::Structs::GstBaseSrc
    is also<GstBaseSrc>
  { $!bs }

  method new (GstBaseSrcAncestry $base-src) {
    $base-src ?? self.bless( :$base-src ) !! Nil;
  }

  # Type: guint
  method blocksize is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('blocksize', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT );
        $gv.uint = $val;
        self.prop_set('blocksize', $gv);
      }
    );
  }

  # Type: gboolean
  method do-timestamp is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('do-timestamp', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_BOOLEAN );
        $gv.boolean = $val;
        self.prop_set('do-timestamp', $gv);
      }
    );
  }

  # Type: gint
  method num-buffers is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('num-buffers', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_INT );
        $gv.int = $val;
        self.prop_set('num-buffers', $gv);
      }
    );
  }

  # Type: gboolean
  method typefind is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('typefind', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_BOOLEAN );
        $gv.boolean = $val;
        self.prop_set('typefind', $gv);
      }
    );
  }

  proto method get_allocator (|)
      is also<get-allocator>
  { * }

  multi method get_allocator (:$raw = False) {
    samewith($, $, :$raw);
  }
  multi method get_allocator ($allocator is rw, $params is rw, :$raw = False) {
    my GstAllocationParams $p = 0;
    my $aa = CArray[Pointer[GstAllocator]].new;

    $aa[0] = Pointer[GstAllocator];
    gst_base_src_get_allocator($!bs, $aa, $p);
    ($allocator, $params) = ppr($aa, $p);
    $allocator = GStreamer::Allocator.new($allocator)
      unless $raw || $allocator.not;
    ($allocator, $params);
  }

  method get_blocksize is also<get-blocksize> {
    gst_base_src_get_blocksize($!bs);
  }

  method get_buffer_pool (:$raw = False) is also<get-buffer-pool> {
    my $bp = gst_base_src_get_buffer_pool($!bs);

    $bp ??
      ( $raw ?? $bp !! GStreamer::BufferPool.new($bp) )
      !!
      Nil;
  }

  method get_do_timestamp is also<get-do-timestamp> {
    so gst_base_src_get_do_timestamp($!bs);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_base_src_get_type, $n, $t );
  }

  method is_async is also<is-async> {
    so gst_base_src_is_async($!bs);
  }

  method is_live is also<is-live> {
    so gst_base_src_is_live($!bs);
  }

  method new_seamless_segment (
    Int() $start,
    Int() $stop,
    Int() $time
  )
    is also<new-seamless-segment>
  {
    my gint64 ($st, $sp, $t) = ($start, $stop, $time);

    so gst_base_src_new_seamless_segment($!bs, $st, $sp, $t);
  }

  proto method query_latency (|)
      is also<query-latency>
  { * }

  multi method query_latency {
    my $rv = samewith($, $, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method query_latency (
    $live        is rw,
    $min_latency is rw,
    $max_latency is rw,
    :$all = False
  ) {
    my gboolean $l = 0;
    my GstClockTime ($mnl, $mxl) = 0 xx 2;

    my $rv = gst_base_src_query_latency($!bs, $l, $mnl, $mxl);
    ($live, $min_latency, $max_latency) = ($l, $mnl, $mxl);
    $all.not ?? $rv !! ($rv, $live, $min_latency, $max_latency);
  }

  method set_async (Int() $async) is also<set-async> {
    my gboolean $a = $async.so.Int;

    gst_base_src_set_async($!bs, $a);
  }

  method set_automatic_eos (Int() $automatic_eos) is also<set-automatic-eos> {
    my gboolean $a = $automatic_eos.so.Int;

    gst_base_src_set_automatic_eos($!bs, $a);
  }

  method set_blocksize (Int() $blocksize) is also<set-blocksize> {
    my guint $b = $blocksize;

    gst_base_src_set_blocksize($!bs, $b);
  }

  method set_caps (GstCaps() $caps) is also<set-caps> {
    gst_base_src_set_caps($!bs, $caps);
  }

  method set_do_timestamp (Int() $timestamp) is also<set-do-timestamp> {
    my gboolean $t = $timestamp.so.Int;

    gst_base_src_set_do_timestamp($!bs, $t);
  }

  method set_dynamic_size (Int() $dynamic) is also<set-dynamic-size> {
    my gboolean $d = $dynamic.so.Int;

    gst_base_src_set_dynamic_size($!bs, $dynamic);
  }

  method set_format (Int() $format) is also<set-format> {
    my GstFormat $f = $format;

    gst_base_src_set_format($!bs, $f);
  }

  method set_live (Int() $live) is also<set-live> {
    my gboolean $l = $live.so.Int;

    gst_base_src_set_live($!bs, $l);
  }

  method start_complete (Int() $ret) is also<start-complete> {
    my GstFlowReturn $r = $ret;

    gst_base_src_start_complete($!bs, $r);
  }

  method start_wait is also<start-wait> {
    GstFlowReturnEnum( gst_base_src_start_wait($!bs) );
  }

  method submit_buffer_list (GstBufferList() $buffer_list)
    is also<submit-buffer-list>
  {
    gst_base_src_submit_buffer_list($!bs, $buffer_list);
  }

  method wait_playing is also<wait-playing> {
    GstFlowReturnEnum( gst_base_src_wait_playing($!bs) );
  }

}
