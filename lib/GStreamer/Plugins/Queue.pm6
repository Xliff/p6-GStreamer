use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;

use GStreamer::Element;
use GStreamer::Object;

use GLib::Roles::Signals::Generic;

unit package GStreamer::Plugins::Queue;

constant GstQueueLeaky is export := guint32;
our enum GstQueueLeakyEnum is export (
  GST_QUEUE_NO_LEAK             => 0,
  GST_QUEUE_LEAK_UPSTREAM       => 1,
  GST_QUEUE_LEAK_DOWNSTREAM     => 2
);

class GstQueueSize               is repr<CStruct>     does GLib::Roles::Pointers is export {
  has guint   $.buffers is rw;
  has guint   $.bytes   is rw;
  has guint64 $.time    is rw;
}

class GstQueue                   is repr<CStruct>     does GLib::Roles::Pointers is export {
  HAS GstElement           $.element;
  # Private
  has GstPad               $!sinkpad;
  has GstPad               $!srcpad;
  # segments to keep track of timestamps
  HAS GstSegment           $!sink_segment;
  HAS GstSegment           $!src_segment;
  # position of src/sink
  has GstClockTimeDiff     $!sinktime;
  has GstClockTimeDiff     $!srctime;
  # TRUE if either position needs to be recalculated
  has gboolean             $!sink_tainted,
  has gboolean             $!src_tainted;
  # flowreturn when srcpad is paused
  has GstFlowReturn        $!srcresult;
  has gboolean             $!unexpected;
  has gboolean             $!eos;
  # the queue of data we're keeping our grubby hands on
  has GstQueueArray        $!queue;
  HAS GstQueueSize         $!cur_level;                                    #= currently in the queue
  HAS GstQueueSize         $!max_size;                                     #= max. amount of data allowed in the queue
  HAS GstQueueSize         $!min_threshold;                                #= min. amount of data required to wake reader
  HAS GstQueueSize         $!orig_min_threshold;                           #= Original min.threshold, for reset in EOS
  # whether we leak data, and at which end
  has gint                 $!leaky;
  HAS GMutex               $!qlock;                                        #= lock for queue (vs object lock)
  has gboolean             $!waiting_add;
  HAS GCond                $!item_add;                                     #= signals buffers now available for reading
  has gboolean             $!waiting_del;
  HAS GCond                $!item_del;                                     #= signals space now available for writing
  has gboolean             $!head_needs_discont;
  has gboolean             $!tail_needs_discont;
  has gboolean             $!push_newsegment;
  has gboolean             $!silent;                                       #= don't emit signals
  # whether the first new segment has been applied to src
  has gboolean             $!newseg_applied_to_src;
  HAS GCond                $!query_handled;
  has gboolean             $!last_query;
  has GstQuery             $!last_handled_query;
  has gboolean             $!flush_on_eos;                                 #= flush on EOS
}

our subset GstQueueAncestry is export of Mu
  where GstQueue | GstElementAncestry;

class GStreamer::Plugins::Queue is GStreamer::Element {
  also does GLib::Roles::Signals::Generic;

  has GstQueue $!q;

  submethod BUILD (:$queue) {
    self.setGstQueue($queue) if $queue;
  }

  method setGstQueue(GstQueueAncestry $_) {
    my $to-parent;

    $!q = do  {
      when GstQueue {
        $to-parent = cast(GstElement, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstQueue, $_);
      }
    }
    self.setGstElement($to-parent);
  }

  method GStreamer::Raw::Structs::GstQueue
    is also<GstQueue>
  { $!q }

  method new (GstQueueAncestry $queue) {
    $queue ?? self.bless( :$queue ) !! Nil;
  }

  # Type: guint
  method current-level-buffers is rw  is also<current_level_buffers> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('current-level-buffers', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        warn 'current-level-buffers does not allow writing'
      }
    );
  }

  # Type: guint
  method current-level-bytes is rw  is also<current_level_bytes> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('current-level-bytes', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        warn 'current-level-bytes does not allow writing'
      }
    );
  }

  # Type: guint64
  method current-level-time is rw  is also<current_level_time> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('current-level-time', $gv)
        );
        $gv.uint64;
      },
      STORE => -> $, Int() $val is copy {
        warn 'current-level-time does not allow writing'
      }
    );
  }

  # Type: gboolean
  method flush-on-eos is rw  is also<flush_on_eos> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('flush-on-eos', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_BOOLEAN );
        $gv.boolean = $val;
        self.prop_set('flush-on-eos', $gv);
      }
    );
  }

  # Type: Queue-leaky
  method leaky is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('leaky', $gv)
        );
        GstQueueLeakyEnum( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( GLib::Value.typeFromEnum(GstQueueLeaky) );
        # cw: For future refactoring, this form is to be used SPARINGLY!
        $gv.valueFromEnum(GstQueueLeaky) = $val;
        self.prop_set('leaky', $gv);
      }
    );
  }

  # Type: guint
  method max-size-buffers is rw  is also<max_size_buffers> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('max-size-buffers', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT );
        $gv.uint = $val;
        self.prop_set('max-size-buffers', $gv);
      }
    );
  }

  # Type: guint
  method max-size-bytes is rw  is also<max_size_bytes> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('max-size-bytes', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT );
        $gv.uint = $val;
        self.prop_set('max-size-bytes', $gv);
      }
    );
  }

  # Type: guint64
  method max-size-time is rw  is also<max_size_time> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('max-size-time', $gv)
        );
        $gv.uint64;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT64 );
        $gv.uint64 = $val;
        self.prop_set('max-size-time', $gv);
      }
    );
  }

  # Type: guint
  method min-threshold-buffers is rw  is also<min_threshold_buffers> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('min-threshold-buffers', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT );
        $gv.uint = $val;
        self.prop_set('min-threshold-buffers', $gv);
      }
    );
  }

  # Type: guint
  method min-threshold-bytes is rw  is also<min_threshold_bytes> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('min-threshold-bytes', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT );
        $gv.uint = $val;
        self.prop_set('min-threshold-bytes', $gv);
      }
    );
  }

  # Type: guint64
  method min-threshold-time is rw  is also<min_threshold_time> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('min-threshold-time', $gv)
        );
        $gv.uint64;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT64 );
        $gv.uint64 = $val;
        self.prop_set('min-threshold-time', $gv);
      }
    );
  }

  # Type: gchararray
  method name is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('name', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv = GLib::Value.new( G_TYPE_STRING );
        $gv.string = $val;
        self.prop_set('name', $gv);
      }
    );
  }

  # Type: GstObject
  method parent (:$raw = False) is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('parent', $gv)
        );

        my $o = $gv.object;

        return Nil unless $o;
        return ( $o = cast(GstObject, $o) ) if $raw;

        GStreamer::Object.new($o);
      },
      STORE => -> $, GstObject() $val is copy {
        $gv = GLib::Value.new( GStreamer::Object.get_type );
        $gv.object = $val;
        self.prop_set('parent', $gv);
      }
    );
  }

  # Type: gboolean
  method silent is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('silent', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_BOOLEAN );
        $gv.boolean = $val;
        self.prop_set('silent', $gv);
      }
    );
  }

  # Is originally:
  # GstElement, gpointer
  method overrun {
    self.connect($!q, 'overrun');
  }

  # Is originally:
  # GstElement, gpointer
  method pushing {
    self.connect($!q, 'pushing');
  }

  # Is originally:
  # GstElement, gpointer
  method running {
    self.connect($!q, 'running');
  }

  # Is originally:
  # GstElement, gpointer
  method underrun {
    self.connect($!q, 'underrun');
  }

}
