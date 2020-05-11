use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;
use GStreamer::Raw::Base::Aggregator;

use GStreamer::Allocator;
use GStreamer::Buffer;
use GStreamer::BufferPool;
use GStreamer::Element;
use GStreamer::Pad;

use GStreamer::Roles::Signals::Generic;

our subset GstAggregatorAncestry is export of Mu
  where GstAggregator | GstElementAncestry;

class GStreamer::Base::Aggregator is GStreamer::Element {
  has GstAggregator $!a;

  submethod BUILD (:$aggregator) {
    self.setAggregator($aggregator);
  }

  method setAggregator(GstAggregatorAncestry $_) {
    my $to-parent;

    $!a = do  {
      when GstAggregator {
        $to-parent = cast(GstElement, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstAggregator, $_);
      }
    }
    self.setGstElement($to-parent);
  }

  method GStreamer::Raw::Structs::GstAggregator
    is also<GstAggregator>
  { $!a }

  method new (GstAggregatorAncestry $aggregator) {
    $aggregator ?? self.bless( :$aggregator ) !! Nil;
  }

  # Type: guint64
  method latency is rw  {
    Proxy.new:
      FETCH => -> $           { self.get_latency },
      STORE => -> $, Int() \i { self.set_latency(i) }
  }

  # Type: guint64
  method min-upstream-latency is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('min-upstream-latency', $gv)
        );
        $gv.uint64;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT64 );
        $gv.uint64 = $val;
        self.prop_set('min-upstream-latency', $gv);
      }
    );
  }

  # Type: guint64
  method start-time is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('start-time', $gv)
        );
        $gv.uint64;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT64 );
        $gv.uint64 = $val;
        self.prop_set('start-time', $gv);
      }
    );
  }

  # Type: GObject
  method start-time-selection (:$raw = False) is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('start-time-selection', $gv)
        );

        my $v = cast(GObject, $gv.object);
        $v = GLib::Object.new($v) unless $v.not || $raw;
        $v;
      },
      STORE => -> $, GObject() $val is copy {
        $gv = GLib::Value.new( G_TYPE_OBJECT );
        $gv.object = $val;
        self.prop_set('start-time-selection', $gv);
      }
    );
  }

  method finish_buffer (GstBuffer() $buffer) is also<finish-buffer> {
    GstFlowReturnEnum( gst_aggregator_finish_buffer($!a, $buffer) );
  }

  # Protected
  proto method get_allocator (|)
      is also<get-allocator>
  { * }

  multi method get_allocator (:$raw = False) {
    samewith($, $, :$raw);
  }
  multi method get_allocator (
    $allocator is rw,
    $params is rw,
    :$raw = False
  ) {
    my $a = CArray[Pointer[GstAllocator]].new;
    my GstAllocationParams $p = 0;

    $a[0] = Pointer[GstAllocator];
    gst_aggregator_get_allocator($!a, $a, $p);

    $allocator = Nil unless $a[0];
    $params = $p;
    if $allocator {
      $allocator .= deref;
      $allocator = GStreamer::Allocator.new($allocator) unless $raw;
    }
    ($allocator, $params);
  }

  method get_buffer_pool (:$raw = False) is also<get-buffer-pool> {
    my $bp = gst_aggregator_get_buffer_pool($!a);

    $bp ??
      ( $raw ?? $bp !! GStreamer::BufferPool.new($bp) )
      !!
      Nil;
  }

  method get_latency is also<get-latency> {
    gst_aggregator_get_latency($!a);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_aggregator_get_type, $n, $t );
  }

  method set_latency (GstClockTime $min_latency, GstClockTime $max_latency)
    is also<set-latency>
  {
    my GstClockTime ($mn, $mx) = ($min_latency, $max_latency);

    gst_aggregator_set_latency($!a, $mn, $mx);
  }

  method set_src_caps (GstCaps() $caps) is also<set-src-caps> {
    gst_aggregator_set_src_caps($!a, $caps);
  }

  method simple_get_next_time is also<simple-get-next-time> {
    gst_aggregator_simple_get_next_time($!a);
  }

}


our subset GstAggregatorPadAncestry is export of Mu
  where GstAggregatorPad | GstPad;

class GStreamer::Base::AggregatorPad is GStreamer::Pad {
  also does GStreamer::Roles::Signals::Generic;

  has GstAggregatorPad $!ap;

  submethod BUILD (:$aggregator-pad) {
    self.setAggregatorPad($aggregator-pad);
  }

  method setAggregatorPad(GstAggregatorPadAncestry $_) {
    my $to-parent;

    $!ap = do  {
      when GstAggregatorPad {
        $to-parent = cast(GstPad, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstAggregatorPad, $_);
      }
    }
    self.setGstPad($to-parent);
  }

  method GStreamer::Raw::Definitions::GstAggregatorPad
    is also<GstAggregatorPad>
  { $!ap }

  method new (GstAggregatorPadAncestry $aggregator-pad ) {
    $aggregator-pad ?? self.bless( :$aggregator-pad ) !! Nil;
  }

  # Type: gboolean
  method emit-signals is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('emit-signals', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_BOOLEAN );
        $gv.boolean = $val;
        self.prop_set('emit-signals', $gv);
      }
    );
  }

  # Is originally:i
  # GstAggregatorPad, GstBuffer, gpointer
  method buffer-consumed {
    self.connect-buffer($!ap, 'buffer-consumed');
  }

  method drop_buffer is also<drop-buffer> {
    so gst_aggregator_pad_drop_buffer($!ap);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_aggregator_pad_get_type, $n, $t );
  }

  method has_buffer is also<has-buffer> {
    so gst_aggregator_pad_has_buffer($!ap);
  }

  method is_eos is also<is-eos> {
    so gst_aggregator_pad_is_eos($!ap);
  }

  method peek_buffer (:$raw = False) is also<peek-buffer> {
    my $b = gst_aggregator_pad_peek_buffer($!ap);

    $b ??
      ( $raw ?? $b !! GStreamer::Buffer.new($b) )
      !!
      Nil;
  }

  method pop_buffer (:$raw = False) is also<pop-buffer> {
    my $b = gst_aggregator_pad_pop_buffer($!ap);

    $b ??
      ( $raw ?? $b !! GStreamer::Buffer.new($b) )
      !!
      Nil;
  }

}
