use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GStreamer::Raw::Definitions;

use GStreamer::Raw::Enums;

unit package GStreamer::Raw::Structs;

class GstObject            is repr<CStruct>      does GLib::Roles::Pointers is export {
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

class GstMiniObject        is repr<CStruct>      does GLib::Roles::Pointers is export {
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

class GstAllocator         is repr<CStruct>      does GLib::Roles::Pointers is export {
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
class GstDateTime          is repr<CStruct>      does GLib::Roles::Pointers is export {
  HAS GstMiniObject        $.mini_object;
  has GDateTime            $!datetime;
  has GstDateTimeFields    $!fields;
}

class GstDeviceMonitor     is repr<CStruct>      does GLib::Roles::Pointers is export {
  has GstObject            $.parent;
  has Pointer              $!priv;
  has gpointer             $!gst_reserved0;
  has gpointer             $!gst_reserved1;
  has gpointer             $!gst_reserved2;
  has gpointer             $!gst_reserved3;
};

class GstDeviceProvider    is repr<CStruct>      does GLib::Roles::Pointers is export {
  has GstObject            $!parent;
  # Protected by the Object lock
  has GList                $!devices;
  has Pointer              $!priv;
  has gpointer             $!gst_reserved0;
  has gpointer             $!gst_reserved1;
  has gpointer             $!gst_reserved2;
  has gpointer             $!gst_reserved3;
};

class GstElement           is repr<CStruct>      does GLib::Roles::Pointers is export {
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

class GstMessage           is repr<CStruct>      does GLib::Roles::Pointers is export {
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
class GstFormatDefinition  is repr<CStruct>      does GLib::Roles::Pointers is export {
  has guint                $.value; # GstFormat
  has Str                  $.nick;
  has Str                  $.description;
  has GQuark               $.quark;
}

class GstMemory            is repr<CStruct>      does GLib::Roles::Pointers is export {
  HAS GstMiniObject        $.mini_object;
  has GstAllocator         $.allocator;
  has GstMemory            $.parent;
  has gsize                $.maxsize;
  has gsize                $.align;
  has gsize                $.offset;
  has gsize                $.size;
}


class GstMetaInfo          is repr<CStruct>      does GLib::Roles::Pointers is export {
  has GType                $.api;
  has GType                $.type;
  has gsize                $.size;

  has gpointer             $!init_func;
  has gpointer             $!free_func;
  has gpointer             $!transform_func;
}

class GstPluginDesc        is repr<CStruct>      does GLib::Roles::Pointers is export {
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

class GstQuery             is repr<CStruct>      does GLib::Roles::Pointers is export {
  HAS GstMiniObject $!mini_object;
  has GstQueryType  $!type;

  method type is rw {
    Proxy.new:
      FETCH => -> $           { GstQueryTypeEnum($!type) },
      STORE => -> $, Int() \t { $!type = t               };
  }
}

class GstStructure         is repr<CStruct>      does GLib::Roles::Pointers is export {
  has GType                $.type;

  has GQuark $!name;
}

class GstSegment           is repr<CStruct>      does GLib::Roles::Pointers is export {
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

class GstTagList           is repr<CStruct>      does GLib::Roles::Pointers is export {
  HAS GstMiniObject        $.mini_object;
}

# NOTE -- For all CStruct definitions marked as Opaque -- this opens us up
#         to ABI changes. This means that any changes in the ABI MUST be
#         accounted for, but it is unknown if Perl6 has a mechanism to allow
#         us to do so. If that happens, then version checking MUST be performed
#         to insure we are working a supported library!!

# Opaque. Grabbed from the implementation for struct-size purposes.
class GstToc               is repr<CStruct>      does GLib::Roles::Pointers is export {
  HAS GstMiniObject        $.mini_object;

  has GstTocScope          $!scope;
  has GList                $!entries;
  has GstTagList           $!tags;
}

# Opaque. Grabbed from the implementation for struct-size purposes.
class GstTocEntry          is repr<CStruct>      does GLib::Roles::Pointers is export {
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
class GstCapsFeatures      is repr<CStruct>      does GLib::Roles::Pointers is export {
  has GType                $!type;
  has CArray[gint]         $!parent_refcount;   # gint *parent_refcount
  has GArray               $!array;
  has gboolean             $!is_any;
}

class GstPadStruct_abi     is repr<CStruct> {
  has GType                $.gtype;
}

class GstPadStruct_resv    is repr<CStruct> {
  has gpointer             $!r0;
  has gpointer             $!r1;
  has gpointer             $!r2;
  has gpointer             $!r3;
}

class GstPadStructABI      is repr<CUnion> {
  HAS GstPadStruct_resv    $!reserved;
  HAS GstPadStruct_abi     $!abi;
}

class GstPadTemplate       is repr<CStruct>     does GLib::Roles::Pointers is export {
  has GstObject	           $!object;
  has Str                  $.name_template;
  has GstPadDirection      $.direction;
  has GstPadPresence       $.presence;
  has GstCaps	             $.caps;
  HAS GstPadStructABI      $!ABI;
};

class GstStaticCaps        is repr<CStruct>      does GLib::Roles::Pointers is export {
  has GstCaps              $.caps;
  has Str                  $.string;
  has gpointer             $!r0;
  has gpointer             $!r1;
  has gpointer             $!r2;
  has gpointer             $!r3;
}

# Test assumption: If the last element is HAS, it will be interpreted as if it were a NULL pointer.
class GstStaticPadTemplate is repr<CStruct>      does GLib::Roles::Pointers is export {
  has Str                  $.name_template;
  has GstPadDirection      $.direction;
  has GstPadPresence       $.presence;
  HAS GstStaticCaps        $.static_caps;
};

class GstColorBalanceChannel is repr<CStruct>    does GLib::Roles::Pointers is export {
  HAS GObjectStruct        $!parent;
  has Str                  $!label;
  has gint                 $.min_value is rw;
  has gint                 $.max_value is rw;

  # private
  has gpointer             $!gst_reserved0;
  has gpointer             $!gst_reserved1;
  has gpointer             $!gst_reserved2;
  has gpointer             $!gst_reserved3;

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

class GstPlayerVisualization is repr<CStruct>  does GLib::Roles::Pointers is export {
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

class GstBitReader           is repr<CStruct>  does GLib::Roles::Pointers is export {
  has CArray[guint8] $!data;
  has guint          $.size;
  has guint          $.byte;
  has guint          $.bit;

  has gpointer       $!gst_reserved0;
  has gpointer       $!gst_reserved1;
  has gpointer       $!gst_reserved2;
  has gpointer       $!gst_reserved3;

  method data is rw {
    Proxy.new:
      FETCH => -> $ { self.^attributes[0].get_value(self)    },

      STORE => -> $, CArray[guint8] \d {
        self.^attributes[0].set_value(self, d)
      };
  }
}

class GstBitWriter           is repr<CStruct>  does GLib::Roles::Pointers is export {
  has CArray[guint8] $!data;
  has guint          $!bit_size;

  has guint    $!bit_capacity;
  has gboolean $!auto_grow;
  has gboolean $!owned;
  has gpointer $!gst_reserved0;
  has gpointer $!gst_reserved1;
  has gpointer $!gst_reserved2;
  has gpointer $!gst_reserved3;

  method data is rw {
    Proxy.new:
      FETCH => -> $ { self.^attributes[0].get_value(self)    },

      STORE => -> $, CArray[guint8] \d {
        self.^attributes[0].set_value(self, d)
      };
  }
}
