use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Enums;

unit package GStreamer::Raw::Structs;

class GstObject                  is repr<CStruct>      does GLib::Roles::Pointers is export {
  HAS GObjectStruct        $.object;  # GInitiallyUnowned
  HAS GMutex               $.lock;
  has Str                  $.name;
  has GstObject            $.parent;
  has guint32              $.flags;

  has GList                $!control_bindings;
  has guint64              $!control_rate;
  has guint64              $!last_sync;
  has gpointer             $!gst_reserved;
}

class GstMiniObject            is repr<CStruct>      does GLib::Roles::Pointers is export {
  has GType                $.type;

  has gint                 $.refcount;
  has gint                 $.lockstate;
  has guint                $.flags;

  has gpointer             $.copy;     # GstMiniObjectCopyFunction
  has gpointer             $.dispose;  # GstMiniObjectDisposeFunction
  has gpointer             $.free;     # GstMiniObjectFreeFunction

  has guint                $!priv_uint;
  has gpointer             $!priv_pointer;
}

class GstAllocator               is repr<CStruct>      does GLib::Roles::Pointers is export {
  HAS GstObject            $!object;

  has Str                  $.mem_type;
  has gpointer             $!mem_map;         # GstMemoryMapFunction
  has gpointer             $!mem_unmap;       # GstMemoryUnmapFunction

  has gpointer             $!mem_copy;        # GstMemoryCopyFunction
  has gpointer             $!mem_share;       # GstMemoryShareFunction
  has gpointer             $!mem_is_span;     # GstMemoryIsSpanFunction

  has gpointer             $!mem_map_full;    # GstMemoryMapFullFunction
  has gpointer             $!mem_unmap_full;  # GstMemoryUnmapFullFunction

  # private
  has gpointer             $!gst_reserved0;
  has gpointer             $!gst_reserved1;
  has gpointer             $!priv;
};

class GstBufferPoolAcquireParams is repr<CStruct> does GLib::Roles::Pointers is export {
  has GstFormat                  $.format is rw;
  has gint64                     $.start  is rw;
  has gint64                     $.stop   is rw;
  has GstBufferPoolAcquireFlags  $.flags  is rw;

  # private
  has gpointer                   $!gst_reserved0;
  has gpointer                   $!gst_reserved1;
  has gpointer                   $!gst_reserved2;
  has gpointer                   $!gst_reserved3;
};


class GstBuffer                  is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS GstMiniObject        $.mini_object is rw;
  has GstBufferPool        $.pool;
  has GstClockTime         $.pts         is rw;
  has GstClockTime         $.dts         is rw;
  has GstClockTime         $.duration    is rw;
  has guint64              $.offset      is rw;
  has guint64              $.offset_end  is rw;
};

# Cheat. This really should be considered opaque.
class GstDateTime                is repr<CStruct>      does GLib::Roles::Pointers is export {
  HAS GstMiniObject        $.mini_object;
  has GDateTime            $!datetime;
  has GstDateTimeFields    $!fields;
}

class GstDeviceMonitor           is repr<CStruct>      does GLib::Roles::Pointers is export {
  has GstObject            $.parent;
  has Pointer              $!priv;
  has gpointer             $!gst_reserved0;
  has gpointer             $!gst_reserved1;
  has gpointer             $!gst_reserved2;
  has gpointer             $!gst_reserved3;
};

class GstDeviceProvider          is repr<CStruct>      does GLib::Roles::Pointers is export {
  has GstObject            $!parent;
  # Protected by the Object lock
  has GList                $!devices;
  has Pointer              $!priv;
  has gpointer             $!gst_reserved0;
  has gpointer             $!gst_reserved1;
  has gpointer             $!gst_reserved2;
  has gpointer             $!gst_reserved3;
};

class GstElement                 is repr<CStruct>      does GLib::Roles::Pointers is export {
  HAS GstObject            $.object;
  HAS GRecMutex            $.state_lock;
  HAS GCond                $.state_cond;
  has guint32              $.state_cookie;
  has GstState             $.target_state;
  has GstState             $.current_state;
  has GstState             $.next_state;
  has GstState             $.pending_state;
  has GstStateChangeReturn $.last_return;
  has GstBus               $.bus;
  has GstClock             $.clock;
  has GstClockTimeDiff     $.base_time;
  has GstClockTime         $.start_time;
  has guint16              $.numpads;
  has GList                $.pads;
  has guint16              $.numsrcpads;
  has GList                $.srcpads;
  has guint16              $.numsinkpads;
  has GList                $.sinkpads;
  has guint32              $.pads_cookie;
  has GList                $.contexts;

  has gpointer             $!gst_reserved0;
  has gpointer             $!gst_reserved1;
  has gpointer             $!gst_reserved2;
}

class GstMessage                 is repr<CStruct>      does GLib::Roles::Pointers is export {
  HAS GstMiniObject        $!mini_object;
  has GstMessageType       $!type;
  has guint64              $.timestamp;
  has GstObject            $.src;
  has guint32              $.seqnum;
  HAS GMutex               $!lock;
  HAS GCond                $!cond;

  method type is rw {
    Proxy.new:
      FETCH => -> $           { GstMessageTypeEnum($!type) },
      STORE => -> $, Int() \t { $!type = t                 };
  }

}

# Modification is currently NYI.
class GstFormatDefinition        is repr<CStruct>      does GLib::Roles::Pointers is export {
  has guint                $.value; # GstFormat
  has Str                  $.nick;
  has Str                  $.description;
  has GQuark               $.quark;
}

class GstMemory                  is repr<CStruct>      does GLib::Roles::Pointers is export {
  HAS GstMiniObject        $.mini_object;
  has GstAllocator         $.allocator;
  has GstMemory            $.parent;
  has gsize                $.maxsize;
  has gsize                $.align;
  has gsize                $.offset;
  has gsize                $.size;
}


class GstMetaInfo                is repr<CStruct>      does GLib::Roles::Pointers is export {
  has GType                $.api;
  has GType                $.type;
  has gsize                $.size;

  has gpointer             $!init_func;
  has gpointer             $!free_func;
  has gpointer             $!transform_func;
}

class GstPluginDesc              is repr<CStruct>      does GLib::Roles::Pointers is export {
  has gint                 $.major_version;
  has gint                 $.minor_version;
  has Str                  $.name;
  has Str                  $.description;
  has gpointer             $.plugin_init; # GstPluginInitFunc
  has Str                  $.version;
  has Str                  $.license;
  has Str                  $.source;
  has Str                  $.package;
  has Str                  $.origin;
  has Str                  $.release_datetime;

  # private
  has gpointer             $!gst_reserved0;
  has gpointer             $!gst_reserved1;
  has gpointer             $!gst_reserved2;
  has gpointer             $!gst_reserved3;
}

class GstQuery                   is repr<CStruct>      does GLib::Roles::Pointers is export {
  HAS GstMiniObject $!mini_object;
  has GstQueryType  $!type;

  method type is rw {
    Proxy.new:
      FETCH => -> $           { GstQueryTypeEnum($!type) },
      STORE => -> $, Int() \t { $!type = t               };
  }
}

class GstStructure               is repr<CStruct>      does GLib::Roles::Pointers is export {
  has GType                $.type;

  has GQuark $!name;
}

class GstSegment                 is repr<CStruct>      does GLib::Roles::Pointers is export {
  has GstSegmentFlags      $.flags        is rw;
  has gdouble              $.rate         is rw;
  has gdouble              $.applied_rate is rw;
  has GstFormat            $.format       is rw;
  has guint64              $.base         is rw;
  has guint64              $.offset       is rw;
  has guint64              $.start        is rw;
  has guint64              $.stop         is rw;
  has guint64              $.time         is rw;
  has guint64              $.position     is rw;
  has guint64              $.duration     is rw;

  # private
  has gpointer             $!gst_reserved0;
  has gpointer             $!gst_reserved1;
  has gpointer             $!gst_reserved2;
  has gpointer             $!gst_reserved3;
};

class GstTagList                 is repr<CStruct>      does GLib::Roles::Pointers is export {
  HAS GstMiniObject        $.mini_object;
}

# NOTE -- For all CStruct definitions marked as Opaque -- this opens us up
#         to ABI changes. This means that any changes in the ABI MUST be
#         accounted for, but it is unknown if Perl6 has a mechanism to allow
#         us to do so. If that happens, then version checking MUST be performed
#         to insure we are working a supported library!!

# Opaque. Grabbed from the implementation for struct-size purposes.
class GstToc                     is repr<CStruct>      does GLib::Roles::Pointers is export {
  HAS GstMiniObject        $.mini_object;

  has GstTocScope          $!scope;
  has GList                $!entries;
  has GstTagList           $!tags;
}

# Opaque. Grabbed from the implementation for struct-size purposes.
class GstTocEntry                is repr<CStruct>      does GLib::Roles::Pointers is export {
  HAS GstMiniObject        $.mini_object;

  has GstToc               $!toc;
  has GstTocEntry          $!parent;
  has gchar                $!uid;
  has GstTocEntryType      $!type;
  has GstClockTime         $!start;
  has GstClockTime         $!stop;
  has GList                $!subentries;
  has GstTagList           $!tags;
  has GstTocLoopType       $!loop_type;
  has gint                 $!repeat_count;
}

# BOXED! - Also Opaque.
class GstCapsFeatures            is repr<CStruct>      does GLib::Roles::Pointers is export {
  has GType                $!type;
  has CArray[gint]         $!parent_refcount;   # gint *parent_refcount
  has GArray               $!array;
  has gboolean             $!is_any;
}

class GstPadStruct_abi           is repr<CStruct> {
  has GType                $.gtype;
}

class GstPadding                 is repr<CStruct>     does GLib::Roles::Pointers is export {
  has gpointer             $!r0;
  has gpointer             $!r1;
  has gpointer             $!r2;
  has gpointer             $!r3;
}

class GstPadStructABI            is repr<CUnion> {
  HAS GstPadding           $!reserved;
  HAS GstPadStruct_abi     $!abi;
}

class GstPadTemplate             is repr<CStruct>     does GLib::Roles::Pointers is export {
  has GstObject	           $!object;
  has Str                  $.name_template;
  has GstPadDirection      $.direction;
  has GstPadPresence       $.presence;
  has GstCaps	             $.caps;
  HAS GstPadStructABI      $!ABI;
};

class GstStaticCaps          is repr<CStruct>      does GLib::Roles::Pointers is export {
  has GstCaps              $.caps;
  has Str                  $.string;
  HAS GstPadding           $!padding
}

# Test assumption: If the last element is HAS, it will be interpreted as if it were a NULL pointer.
class GstStaticPadTemplate       is repr<CStruct>      does GLib::Roles::Pointers is export {
  has Str                  $.name_template;
  has GstPadDirection      $.direction;
  has GstPadPresence       $.presence;
  HAS GstStaticCaps        $.static_caps;
}

# PLAYER

class GstPlayerVisualization     is repr<CStruct>  does GLib::Roles::Pointers is export {
  has Str $!name;
  has Str $!description;

  method name is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[0].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[0].set_value(self, s) };
  }

  method description is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[1].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[1].set_value(self, s) };
  }
}

# BASE

class GstBitReader               is repr<CStruct>  does GLib::Roles::Pointers is export {
  has CArray[guint8] $!data;
  has guint          $.size is rw;
  has guint          $.byte is rw;
  has guint          $.bit  is rw;

  HAS GstPadding     $!reserved;

  method data is rw {
    Proxy.new:
      FETCH => -> $ { self.^attributes[0].get_value(self)    },

      STORE => -> $, CArray[guint8] \d {
        self.^attributes[0].set_value(self, d)
      };
  }
}

class GstBitWriter               is repr<CStruct>  does GLib::Roles::Pointers is export {
  has CArray[guint8] $!data;
  has guint          $!bit_size;

  has guint          $!bit_capacity;
  has gboolean       $!auto_grow;
  has gboolean       $!owned;
  HAS GstPadding     $!padding;

  method data is rw {
    Proxy.new:
      FETCH => -> $ { self.^attributes[0].get_value(self)    },

      STORE => -> $, CArray[guint8] \d {
        self.^attributes[0].set_value(self, d)
      };
  }
}

class GstPaddingLarge            is repr<CStruct>  does GLib::Roles::Pointers is export {
  HAS GstPadding      $!padding0;
  HAS GstPadding      $!padding1;
  HAS GstPadding      $!padding2;
  HAS GstPadding      $!padding3;
  HAS GstPadding      $!padding4;
}

class GstAggregator              is repr<CStruct>  does GLib::Roles::Pointers is export {
  HAS GstElement      $.parent;
  has GstPad          $.segment;
  has gpointer        $!private;

  HAS GstPaddingLarge $!padding;
}

class GstAggregatorPad           is repr<CStruct>  does GLib::Roles::Pointers is export {
  HAS GstPad          $.parent;
  HAS GstSegment      $.segment;
  has gpointer        $!private;

  HAS GstPadding      $!padding;
}

class GstBaseParseFrame          is repr<CStruct>  does GLib::Roles::Pointers is export {
  has GstBuffer $!buffer;
  has GstBuffer $!out_buffer;
  has guint     $.flags    is rw;
  has guint64   $.offset   is rw;
  has gint      $.overhead is rw;
  # Private
  has gint      $!size;
  has guint     $!ri0;
  has guint     $!ri1;
  has gpointer  $!reserved0;
  has gpointer  $!reserved1;
  has guint     $!private_flags;

  method buffer is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[0].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[0].set_value(self, s) };
  }

  method out_buffer is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[1].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[1].set_value(self, s) };
  }
}

class GstBaseParse               is repr<CStruct>  does GLib::Roles::Pointers is export {
  has GstElement      $.element;

  # Protected
  has GstPad          $.sinkpad;
  has GstPad          $.srcpad;
  has guint           $.flags;
  has GstSegment      $.segment;

  HAS GstPaddingLarge $!padding;
  has Pointer         $!private;
}

class GstCollectPads             is repr<CStruct>  does GLib::Roles::Pointers is export {
  has GstObject                $!object;
  has GSList                   $.data;
  has GRecMutex                $!stream-lock;
  has Pointer                  $!private;
  HAS GstPadding               $!padding;
}

class GstCollectData             is repr<CStruct>  does GLib::Roles::Pointers is export {
  has GstCollectPads           $!collect;
  has GstPad                   $!pad;
  has GstBuffer                $!buffer;
  has guint                    $!pos;
  has GstSegment               $!segment;

  has GstCollectPadsStateFlags $!state;
  has gpointer                 $!private;
  HAS GstPadding               $!padding;

  method ABI-abi-dts {
    +$!padding[0];
  }
}

class GstBaseSink                is repr<CStruct>  does GLib::Roles::Pointers is export {
  has GstElement       $.element;

  # Protected
  has GstPad           $.sinkpad;
  has GstPadMode       $.pad_mode;

  # Protected WITH LOCK
  has guint64          $.offset;
  has gboolean         $.can_activate_pull;
  has gboolean         $.can_activate_push;

  # Protected WITH PREROLL LOCK
  has GMutex           $.preroll_lock;
  has GCond            $.preroll_cond;
  has gboolean         $.eos;
  has gboolean         $.need_preroll;
  has gboolean         $.have_preroll;
  has gboolean         $.playing_async;

  # Protectedf WITH STREAM LOCK
  has gboolean         $.have_newsegment;
  has GstSegment       $.segment;

  # Private
  has GstClockID       $!clock_id;
  has gboolean         $!sync;
  has gboolean         $!flushing;
  has gboolean         $!running;
  has gint64           $!max_lateness;
  has Pointer          $!priv;

  HAS GstPaddingLarge  $!padding;
}

class GstBaseSrc                 is repr<CStruct>  does GLib::Roles::Pointers is export {
  has GstElement       $.element;

  # Protected
  has GstPad           $.srcpad;

  # MT-Protected with LIVE_LOCK
  has GMutex           $!live_lock;
  has GCond            $!live_cond;
  has gboolean         $!is_live;
  has gboolean         $!live_running;

  # MT-Protected with LOCK
  has guint            $!blocksize;             #= size of buffers when operating push based
  has gboolean         $!can_activate_push;     #= some scheduling properties
  has gboolean         $!random_access;

  has GstClockID       $!clock_id;              #= for syncing

  # MT-protected (with STREAM_LOCK *and* OBJECT_LOCK)
  has GstSegment       $!segment;
  # MT-protected (with STREAM_LOCK)
  has gboolean         $!need_newsegment;
  has gint             $!num_buffers;
  has gint             $!num_buffers_left;

  #ifndef GST_REMOVE_DEPRECATED
  has gboolean         $!typefind;              #= unused
  #endif

  has gboolean         $!running;
  has GstEvent         $!pending_seek;

  has Pointer          $!priv;

  # Private
  HAS GstPaddingLarge  $!padding;
};

class GstBaseTransform           is repr<CStruct>  does GLib::Roles::Pointers is export {
  has GstElement          $.element;

  # Protected
  has GstPad              $.sinkpad;
  has GstPad              $.srcpad;

  # MT-protected (with STREAM_LOCK)
  has gboolean            $.have_segment;
  has GstSegment          $.segment;
  # Default submit_input_buffer places the buffer here,
  # for consumption by the generate_output method:
  has GstBuffer           $.queued_buf;

  has Pointer             $!priv;

  HAS GstPaddingLarge     $!padding;
}

class GstDataQueueItem           is repr<CStruct>  does GLib::Roles::Pointers is export {
  has GstMiniObject   $!object;
  has guint           $.size     is rw;
  has guint64         $.duration is rw;
  has gboolean        $.visible  is rw;
  has GDestroyNotify  $!destroy;                #= Setting $!destroy is currently NYI
  HAS GstPadding      $!padding
};

class GstDataQueueSize           is repr<CStruct>  does GLib::Roles::Pointers is export {
  has guint           $.visible is rw;
  has guint           $.bytes   is rw;
  has guint64         $.time    is rw;
};

class GstByteReader              is repr<CStruct>  does GLib::Roles::Pointers is export {
  has CArray[guint8]  $!data;
  has guint           $.size    is rw;
  has guint           $.byte    is rw;
  HAS GstPadding      $!padding;

  method data is rw {
    Proxy.new:
      FETCH => -> $                    { self.^attributes[0].get_value(self)    },
      STORE => -> $, CArray[guint8] \a { self.^attributes[0].set_value(self, a) };
  }
}

class GstByteWriter              is repr<CStruct>  does GLib::Roles::Pointers is export {
  # HAS does not suppport delegation via handles<> trait!
  HAS GstByteReader $.parent;

  has guint    $.alloc_size is rw;
  has gboolean $.fixed      is rw;
  has gboolean $.owned      is rw;

  method data is rw { $.parent.data }
  method size is rw { $.parent.size }
  method byte is rw { $.parent.byte }
}

class GstPushSrc               is repr<CStruct>  does GLib::Roles::Pointers is export {
  HAS GstBaseSrc $!parent;
  HAS GstPadding $!padding;

  method srcpad { $!parent.src_pad; }
};

# VIDEO

class GstVideoRectangle          is repr<CStruct>    does GLib::Roles::Pointers is export {
  has gint                 $.x is rw;
  has gint                 $.y is rw;
  has gint                 $.w is rw;
  has gint                 $.h is rw;
}

class GstVideoSink               is repr<CStruct>    does GLib::Roles::Pointers is export {
  HAS GstBaseSink          $!element;
  has gint                 $.width   is rw;
  has gint                 $.height  is rw;

  has Pointer              $!priv;
  HAS GstPadding           $!padding;
}

class GstColorBalanceChannel     is repr<CStruct>    does GLib::Roles::Pointers is export {
  HAS GObjectStruct        $!parent;
  has Str                  $!label;
  has gint                 $.min_value is rw;
  has gint                 $.max_value is rw;

  # private
  HAS GstPadding           $!padding;

  method min-value is rw {
    self.min_value;
  }

  method max-value is rw {
    self.max_value;
  }

  method label is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[1].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[1].set_value(self, s) };
  }

}

class GstVideoTimeCodeConfig     is repr<CStruct>    does GLib::Roles::Pointers is export {
  has guint                 $.fps_n        is rw;
  has guint                 $.fps_d        is rw;
  has GstVideoTimeCodeFlags $.flags        is rw;

  has GDateTime             $!latest_daily_jam;

  method latest_daily_jam is rw {
    Proxy.new:
      FETCH => -> $                 { self.^attributes[3].get_value(self)    },
      STORE => -> $, GDateTime() \d { self.^attributes[3].set_value(self, d) };
  }
}

class GstVideoTimeCode           is repr<CStruct>    does GLib::Roles::Pointers is export {
  HAS GstVideoTimeCodeConfig $.config;

  has guint                  $.hours       is rw;
  has guint                  $.minutes     is rw;
  has guint                  $.seconds     is rw;
  has guint                  $.frames      is rw;
  has guint                  $.field_count is rw;
}

class GstVideoTimeCodeInterval   is repr<CStruct>    does GLib::Roles::Pointers is export {
  has guint                  $.hours       is rw;
  has guint                  $.minutes     is rw;
  has guint                  $.seconds     is rw;
  has guint                  $.frames      is rw;
}

class GstVideoCodecFrame         is repr<CStruct>    does GLib::Roles::Pointers is export {
  has gint                $!ref_count;                  #= PRIVATE
  has guint32             $!flags;                      #= PRIVATE

  has guint32             $.system_frame_number is rw;  #= ED

  has guint32             $!decode_frame_number;        #= PRIVATE - ED
  has guint32             $!presentation_frame_number;  #= PRIVATE - ED


  has GstClockTime        $.dts                is rw;   #= ED
  has GstClockTime        $.pts                is rw;   #= ED
  has GstClockTime        $.duration           is rw;   #= ED
  has gint                $.distance_from_sync is rw;   #= ED

  has GstBuffer           $!input_buffer;               #= ED
  has GstBuffer           $!output_buffer;              #= ED

  has GstClockTime        $.deadline is rw;             #= D

  has GList               $!events;                     #= PRIVATE - ED */

  has gpointer            $!user_data;
  has GDestroyNotify      $!user_data_destroy_notify;

  method input_buffer is rw {
    Proxy.new:
      FETCH => -> $                 { self.^attributes[9].get_value(self)    },
      STORE => -> $, GstBuffer() \b { self.^attributes[9].set_value(self, b) };
  }

  method output_buffer is rw {
    Proxy.new:
      FETCH => -> $                 { self.^attributes[10].get_value(self)    },
      STORE => -> $, GstBuffer() \b { self.^attributes[10].set_value(self, b) };
  }

  # union {
  #   struct {
  #     GstClockTime ts;
  #     GstClockTime ts2;
  #   } ABI;
  #   gpointer padding[GST_PADDING_LARGE];
  # } abidata;

  HAS GstPaddingLarge $!padding;
}

class GstVideoFormatInfo         is repr<CStruct>    does GLib::Roles::Pointers is export {
  has GstVideoFormat $.format;
  has Str                  $.name;
  has Str                  $.description;
  has GstVideoFormatFlags  $.flags           is rw;
  has guint                $.bits            is rw;
  has guint                $.n_components    is rw;
  has guint                @.shift[GST_VIDEO_MAX_COMPONENTS]       is CArray;
  has guint                @.depth[GST_VIDEO_MAX_COMPONENTS]       is CArray;
  has gint                 @.pixel_stride[GST_VIDEO_MAX_COMPONENTS]is CArray;
  has guint                $.n_planes        is rw;
  has guint                @.plane[GST_VIDEO_MAX_COMPONENTS]       is CArray;
  has guint                @.poffset[GST_VIDEO_MAX_COMPONENTS]     is CArray;
  has guint                @.w_sub[GST_VIDEO_MAX_COMPONENTS]       is CArray;
  has guint                @.h_sub[GST_VIDEO_MAX_COMPONENTS]       is CArray;

  has GstVideoFormat       $.unpack_format   is rw;
  has Pointer              $.unpack_func;             # GstVideoUnpack func
  has gint                 $.pack_lines      is rw;
  has Pointer              $.pack_func;               # GstVideoPack   func

  has guint                $.tile_mode       is rw;   # GstVideoTileMode
  has guint                $.tile_ws         is rw;
  has guint                $.tile_hs         is rw;

  HAS GstPadding           $!padding;

  method name is rw {
    Proxy.new:
      FETCH => -> $            { self.^attributes[1].get_value(self)    },
      STORE => -> $, Str() \s  { self.^attributes[1].set_value(self, s) };
  }

  method description is rw {
    Proxy.new:
      FETCH => -> $            { self.^attributes[2].get_value(self)    },
      STORE => -> $, Str() \s  { self.^attributes[2].set_value(self, s) };
  }

}

class GstVideoColorimetry        is repr<CStruct>    does GLib::Roles::Pointers is export {
  has GstVideoColorRange        $.range     is rw;
  has GstVideoColorMatrix       $.matrix    is rw;
  has GstVideoTransferFunction  $.transfer  is rw;
  has GstVideoColorPrimaries    $.primaries is rw;
}

class GstVideoInfo               is repr<CStruct>    does GLib::Roles::Pointers is export {
  has GstVideoFormatInfo     $.finfo;

  has GstVideoInterlaceMode  $.interlace_mode is rw;
  has GstVideoFlags          $.flags          is rw;
  has gint                   $.width          is rw;
  has gint                   $.height         is rw;
  has gsize                  $.size           is rw;
  has gint                   $.views          is rw;

  has GstVideoChromaSite     $.chroma_site    is rw;
  has GstVideoColorimetry    $.colorimetry    is rw;

  has gint                   $.par_n          is rw;
  has gint                   $.par_d          is rw;
  has gint                   $.fps_n          is rw;
  has gint                   $.fps_d          is rw;

  HAS gsize                  @.offset[GST_VIDEO_MAX_PLANES] is CArray;
  HAS gint                   @.stride[GST_VIDEO_MAX_PLANES] is CArray;

  # union {
  #   struct {
  #     GstVideoMultiviewMode     multiview_mode;
  #     GstVideoMultiviewFlags    multiview_flags;
  #     GstVideoFieldOrder        field_order;
  #   } abi;
  #   /*< private >*/
  #   gpointer _gst_reserved[GST_PADDING];
  # } ABI;

  HAS GstPadding             $!padding;
}

class GstVideoCodecState         is repr<CStruct>    does GLib::Roles::Pointers is export {
  has gint            $!ref_count;

  HAS GstVideoInfo    $.info;
  has GstCaps         $!caps;
  has GstBuffer       $!codec_data;
  has GstCaps         $!allocation_caps;

  method caps is rw {
    Proxy.new:
      FETCH => -> $                 { self.^attributes[2].get_value(self)    },
      STORE => -> $, GstCaps() \c   { self.^attributes[2].set_value(self, c) };
  }

  method codec_data is rw {
    Proxy.new:
      FETCH => -> $                 { self.^attributes[3].get_value(self)    },
      STORE => -> $, GstBuffer() \b { self.^attributes[3].set_value(self, b) };
  }

  method allocation_caps is rw {
    Proxy.new:
      FETCH => -> $                 { self.^attributes[4].get_value(self)    },
      STORE => -> $, GstCaps() \c   { self.^attributes[4].set_value(self, c) };
  }

  HAS GstPaddingLarge $!padding;
}
