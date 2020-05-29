use v6.c;

use NativeCall;
use Method::Also;

use GLib::Raw::Definitions;
use GLib::Raw::Object;
use GLib::Raw::Structs;
use GLib::Raw::Subs;
use GLib::Raw::Struct_Subs;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Enums;

unit package GStreamer::Raw::Structs;

class GstPollFD                  is repr<CStruct>     does GLib::Roles::Pointers is export {
  has gint $.fd  is rw;
  has gint $!idx;
}

class GstPadding                 is repr<CStruct>     does GLib::Roles::Pointers is export {
  has gpointer             $!r0;
  has gpointer             $!r1;
  has gpointer             $!r2;
  has gpointer             $!r3;
}

class GstObject                  is repr<CStruct>      does GLib::Roles::Pointers is export {
  HAS GObject              $.object;  # GInitiallyUnowned
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
}

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
}


class GstBuffer                  is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS GstMiniObject        $.mini_object is rw;
  has GstBufferPool        $.pool;
  has GstClockTime         $.pts         is rw;
  has GstClockTime         $.dts         is rw;
  has GstClockTime         $.duration    is rw;
  has guint64              $.offset      is rw;
  has guint64              $.offset_end  is rw;
}

class GstClock                   is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS GstObject  $.object;
  has Pointer    $!priv;
  HAS GstPadding $!padding;
}

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
}

class GstDeviceProvider          is repr<CStruct>      does GLib::Roles::Pointers is export {
  has GstObject            $!parent;
  # Protected by the Object lock
  has GList                $!devices;
  has Pointer              $!priv;
  has gpointer             $!gst_reserved0;
  has gpointer             $!gst_reserved1;
  has gpointer             $!gst_reserved2;
  has gpointer             $!gst_reserved3;
}

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

class GstBin                     is repr<CStruct>      does GLib::Roles::Pointers is export {
  HAS GstElement $.element;

  # Public, with LOCK
  has gint       $.numchildren;
  has GList      $.children;
  has guint32    $.children_cookie;

  has GstBus     $.child_bus;
  has GList      $.messages;

  has gboolean   $.polling;
  has gboolean   $.state_dirty;

  has gboolean   $.clock_dirty;
  has GstClock   $.provided_clock;
  has GstElement $.clock_provider;
  # Private
  has Pointer    $!priv;
  HAS GstPadding $!padding;
};

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
  has GstAllocator         $!allocator;
  has GstMemory            $!parent;
  has gsize                $.maxsize   is rw;
  has gsize                $.align     is rw;
  has gsize                $.offset    is rw;
  has gsize                $.size      is rw;

  method allocator is rw {
    Proxy.new:
      FETCH => -> $                    { self.^attributes[1].get_value(self)    },
      STORE => -> $, GstAllocator() \a { self.^attributes[1].set_value(self, a) };
  }

  method parent is rw {
    Proxy.new:
      FETCH => -> $                  { self.^attributes[2].get_value(self)     },
      STORE => -> $, GstMemory() \mm { self.^attributes[2].set_value(self, mm) };
  }
}

class GstMapInfo                 is repr<CStruct>      does GLib::Roles::Pointers is export {
  has GstMemory    $!memory;
  has GstMapFlags  $.flags;
  has guint8       $.data;
  has gsize        $.size;
  has gsize        $.maxsize;

  HAS gpointer     @!user_data[4] is CArray;
  HAS GstPadding   $!padding;

  method memory is rw {
    Proxy.new:
      FETCH => -> $                  { self.^attributes[0].get_value(self)    },
      STORE => -> $, GstMemory() \mm { self.^attributes[0].set_value(self, mm) };
  }

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
}

class GstSystemClock           is repr<CStruct>      does GLib::Roles::Pointers is export {
  HAS GstClock       $.clock;
  has Pointer        $!private;
  HAS GstPadding     $!padding;
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

  method name-template { $.name_template }
};

class GstStaticCaps          is repr<CStruct>      does GLib::Roles::Pointers is export {
  has GstCaps              $.caps;
  has Str                  $.string;
  HAS GstPadding           $!padding;

  method Str { self.string }
}

# Test assumption: If the last element is HAS, it will be interpreted as if it were a NULL pointer.
class GstStaticPadTemplate       is repr<CStruct>      does GLib::Roles::Pointers is export {
  has Str                  $.name_template;
  has GstPadDirection      $.direction;
  has GstPadPresence       $.presence;
  HAS GstStaticCaps        $.static_caps;
}

class GstTask                    is repr<CStruct>      does GLib::Roles::Pointers is export {
  HAS GstObject      $.object;

  # with LOCK
  has GstTaskState    $.state     is rw;
  has GCond           $.cond;
  has GRecMutex       $!lock;
  has Pointer         $!func;     #= (gpointer $user_data);
  has gpointer        $.user_data is rw;
  has GDestroyNotify  $.notify;
  has gboolean        $.running   is rw;
  has GThread         $.thread;
  has Pointer         $!priv;     #= GstTaskPrivate

  HAS GstPadding      $!padding;

  method getLock {
    $!lock;
  }

  method lock is rw {
    Proxy.new:
      FETCH => -> $                  { self.^attributes[3].get_value(self)     },
      STORE => -> $, GRecMutex() \mm { self.^attributes[3].set_value(self, mm) };
  }

  multi method func is rw {
    Proxy.new:
      FETCH => -> $ { $!func },
      STORE => -> $, &func {
        $!func := set_func_pointer( &func, &sprintf-P);
      };
  }

  method user_data is rw {
    Proxy.new:
      FETCH => -> $             { self.^attributes[5].get_value(self)    },
      STORE => -> $, Pointer \p { self.^attributes[5].set_value(self, p) };
  }

}

class GstTaskPool                is repr<CStruct>      does GLib::Roles::Pointers is export {
  HAS GstObject   $.object;

  has GThreadPool $!pool;

  HAS GstPadding  $!padding;
}

class GstControlBinding          is repr<CStruct>      does GLib::Roles::Pointers is export {
  HAS GstObject   $.parent;

  has Str         $!name;
  has GParamSpec  $!pspec;

#ifndef GST_DISABLE_DEPRECATED
#  GstObject *object;            /* GstObject owning the property                                 * (== parent when bound) */
#else
  has gpointer    $!object;
#endif

  has gboolean    $.disabled is rw;

  HAS GstPadding  $!padding;

  method name is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[1].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[1].set_value(self, s) };
  }

  method pspec is rw {
    Proxy.new:
      FETCH => -> $                   { self.^attributes[2].get_value(self)     },
      STORE => -> $, GParamSpec() \ps { self.^attributes[2].set_value(self, ps) };
  }

}

class GstTimedValue              is repr<CStruct>      does GLib::Roles::Pointers is export {
  has GstClockTime $.timestamp is rw;
  has gdouble      $.value     is rw
}

class GstControlSource           is repr<CStruct>      does GLib::Roles::Pointers is export {
  HAS GstObject $.parent;

  has Pointer $!get_value;
  has Pointer $!get_value_array;

  HAS GstPadding $!padding;

  multi method get_value is rw {
    Proxy.new:
      FETCH => -> $ { $!get_value },
      STORE => -> $, &func {
        $!get_value := set_func_pointer( &func, &sprintf-GetValueFunc);
      };
  }

  multi method get_value is rw {
    Proxy.new:
      FETCH => -> $ { $!get_value_array },
      STORE => -> $, &func {
        $!get_value_array := set_func_pointer( &func, &sprintf-GetValueArrayFunc);
      };
  }

  sub sprintf-GetValueFunc (
    Blob,
    Str,
    & (GstControlSource, GstClockTime, gdouble is rw --> gboolean),
  )
    returns int64
    is native
    is symbol('sprintf')
  { * }

  sub sprintf-GetValueArrayFunc (
    Blob,
    Str,
    & (GstControlSource, GstClockTime, GstClockTime, guint, CArray[gdouble] --> gboolean),
  )
    returns int64
    is native
    is symbol('sprintf')
  { * }

}

class GstMetaTransformCopy       is repr<CStruct>    does GLib::Roles::Pointers is export {
  has gboolean $.region is rw;
  has gsize    $.offset is rw;
  has gsize    $.size   is rw;
}

# Predeclare
class GstMetaInfo                is repr<CStruct>      does GLib::Roles::Pointers is export { ... }

class GstMeta                    is repr<CStruct>    does GLib::Roles::Pointers is export {
  has GstMetaFlags  $.flags is rw;
  has GstMetaInfo   $!info;

  method info is rw {
    Proxy.new:
      FETCH => -> $                   { self.^attributes[1].get_value(self)    },
      STORE => -> $, GstMetaInfo() \i { self.^attributes[1].set_value(self, i) };
  }
}

class GstMetaInfo{
  has GType                $.api;
  has GType                $.type;
  has gsize                $.size;

  has gpointer             $!init_func;
  has gpointer             $!free_func;
  has gpointer             $!transform_func;

  multi method init_func is rw {
    Proxy.new:
      FETCH => -> $ { $!init_func },
      STORE => -> $, &func {
        $!init_func := set_func_pointer( &func, &sprintf-InitFunc );
      };
  }

  multi method init_func is rw {
    Proxy.new:
      FETCH => -> $ { $!free_func },
      STORE => -> $, &func {
        $!free_func := set_func_pointer( &func, &sprintf-FreeFunc );
      };
  }

  multi method transform_func is rw {
    Proxy.new:
      FETCH => -> $ { $!transform_func },
      STORE => -> $, &func {
        $!transform_func := set_func_pointer( &func, &sprintf-TransformFunc );
      };
  }

  sub sprintf-InitFunc (
    Blob,
    Str,
    & (GstMeta, gpointer, GstBuffer --> gboolean),
  )
    returns int64
    is native
    is symbol('sprintf')
  { * }

  sub sprintf-FreeFunc (
    Blob,
    Str,
    & (GstMeta, GstBuffer),
  )
    returns int64
    is native
    is symbol('sprintf')
  { * }

  sub sprintf-TransformFunc (
    Blob,
    Str,
    & (GstMeta, GstMeta, GstBuffer, GQuark, gpointer --> gboolean),
  )
    returns int64
    is native
    is symbol('sprintf')
  { * }
}

class GstProtectionMeta          is repr<CStruct>  does GLib::Roles::Pointers is export {
  HAS GstMeta      $.meta;

  has GstStructure $.info;

  method info is rw {
    Proxy.new:
      FETCH => -> $                    { self.^attributes[1].get_value(self)    },
      STORE => -> $, GstStructure() \s { self.^attributes[1].set_value(self, s) };
  }

  method api_get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_protection_meta_api_get_type, $n, $t );
  }

  ### /usr/include/gstreamer-1.0/gst/gstprotection.h

  sub gst_protection_meta_api_get_type ()
    returns GType
    is native(gstreamer)
  { * }
}

class GstTracer                  is repr<CStruct>  does GLib::Roles::Pointers is export {
  HAS GstObject   $.parent;

  has Pointer     $!priv;
  HAS GstPadding  $!padding;
}

# BASE

class GstCollectPads             is repr<CStruct>  does GLib::Roles::Pointers is export {
  HAS GstObject     $.object;

  # with LOCK and/or STREAM_LOCK
  has GSList        $.data;                 #= list of CollectData items
  HAS GRecMutex     $!stream_lock;          #= used to serialize collection among several streams

  has Pointer       $!priv;

  HAS GstPadding    $!padding;
};

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

class GstPad                     is repr<CStruct>  does GLib::Roles::Pointers is export {
  HAS GstObject                  $.object;
  # Public
  has gpointer                   $.element_private;
  has GstPadTemplate             $.padtemplate;
  has GstPadDirection            $.direction;
  # Private
  has GRecMutex                  $!stream_rec_lock;
  has GstTask                    $!task;
  has GCond                      $!block_cond;
  has GHookList                  $!probes;
  has GstPadMode                 $!mode;
  has Pointer                    $!activatefunc;        #= GstPadActivateFunction
  has gpointer                   $!activatedata;
  has Pointer                    $!activatenotify;      #= GDestroyNotify
  has Pointer                    $!activatemodefunc;    #= GstPadActivateModeFunction
  has gpointer                   $!activatemodedata;
  has Pointer                    $!activatemodenotify;  #= GDestroyNotify
  # Pad Link
  has GstPad                     $!peer;
  has Pointer                    $!linkfunc;            #= GstPadLinkFunction
  has gpointer                   $!linkdata;
  has Pointer                    $!linknotify;          #= GDestroyNotify
  has Pointer                    $!unlinkfunc;          #= GstPadUnlinkFunction
  has gpointer                   $!unlinkdata;
  has Pointer                    $!unlinknotify;        #= GDestroyNotify
  # data transport functions
  has Pointer                    $!chainfunc;           #= GstPadChainFunction
  has gpointer                   $!chaindata;
  has Pointer                    $!chainnotify;         #= GDestroyNotify
  has Pointer                    $!chainlistfunc;       #= GstPadChainListFunction
  has gpointer                   $!chainlistdata;
  has Pointer                    $!chainlistnotify;     #= GDestroyNotify
  has Pointer                    $!getrangefunc;        #= GstPadGetRangeFunction
  has gpointer                   $!getrangedata;
  has Pointer                    $!getrangenotify;      #= GDestroyNotify
  has Pointer                    $!eventfunc;           #= GstPadEventFunction
  has gpointer                   $!eventdata;
  has Pointer                    $!eventnotify;         #= GDestroyNotify
  # pad offset
  has gint64                     $!offset;
  # generic query method
  has Pointer                    $!queryfunc;           #= GstPadQueryFunction
  has gpointer                   $!querydata;
  has Pointer                    $!querynotify;         #= GDestroyNotify
  # internal links
  has gpointer                   $!iterintlinkfunc;     #= GstPadIterIntLinkFunction
  has gpointer                   $!iterintlinkdata;
  has Pointer                    $!iterintlinknotify;   #= GDestroyNotify
  # counts number of probes attached
  has gint                       $!num_probes;
  has gint                       $!num_blocked;
  has Pointer                    $!priv;
  HAS GstPadding                 $!padding;
}

class GstCollectData             is repr<CStruct>  does GLib::Roles::Pointers is export {
  # with STREAM_LOCK of @collect
  has GstCollectPads            $.collect;

  has GstPad                    $!pad;
  has GstBuffer                 $!buffer;
  has guint                     $.pos     is rw;
  HAS GstSegment                $.segment;

  # Private
  has GstCollectPadsStateFlags  $!state;
  has Pointer                   $!priv;

  HAS GstPaddingLarge           $!padding;

  method pad is rw {
    Proxy.new:
      FETCH => -> $              { self.^attributes[1].get_value(self)    },
      STORE => -> $, GstPad() \p { self.^attributes[1].set_value(self, p) };
  }

  method buffer is rw {
    Proxy.new:
      FETCH => -> $                 { self.^attributes[2].get_value(self)    },
      STORE => -> $, GstBuffer() \b { self.^attributes[2].set_value(self, b) };
  }
};

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
}

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
  HAS GObject              $!parent;
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

  HAS GstPaddingLarge $!padding;

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

  method get_type (GstVideoCodecFrame:U:) {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_video_codec_frame_get_type, $n, $t );
  }

  method get_user_data {
    gst_video_codec_frame_get_user_data(self);
  }

  method set_user_data (
    gpointer $user_data,
    GDestroyNotify $notify = Pointer
  ) {
    gst_video_codec_frame_set_user_data(self, $user_data, $notify);
  }

  # union {
  #   struct {
  #     GstClockTime ts;
  #     GstClockTime ts2;
  #   } ABI;
  #   gpointer padding[GST_PADDING_LARGE];
  # } abidata;

  ### /usr/include/gstreamer-1.0/gst/video/gstvideoutils.h

  sub gst_video_codec_frame_get_user_data (GstVideoCodecFrame $frame)
    returns Pointer
    is native(gstreamer-video)
  { * }

  sub gst_video_codec_frame_set_user_data (
    GstVideoCodecFrame $frame,
    gpointer $user_data,
    GDestroyNotify $notify
  )
    is native(gstreamer-video)
  { * }

  sub gst_video_codec_frame_get_type ()
    returns GType
    is native(gstreamer-video)
  { * }

  sub gst_video_codec_frame_ref (GstVideoCodecFrame $frame)
    returns GstVideoCodecFrame
    is native(gstreamer-video)
  { * }

  sub gst_video_codec_frame_unref (GstVideoCodecFrame $frame)
    is native(gstreamer-video)
  { * }

}

class GstVideoFormatInfo         is repr<CStruct>    does GLib::Roles::Pointers is export {
  has GstVideoFormat $.format;
  has Str                  $!name;
  has Str                  $!description;
  has GstVideoFormatFlags  $.flags                                  is rw;
  has guint                $.bits                                   is rw;
  has guint                $.n_components                           is rw;
  has guint                @.shift[GST_VIDEO_MAX_COMPONENTS]        is CArray;
  has guint                @.depth[GST_VIDEO_MAX_COMPONENTS]        is CArray;
  has gint                 @.pixel_stride[GST_VIDEO_MAX_COMPONENTS] is CArray;
  has guint                $.n_planes                               is rw;
  has guint                @.plane[GST_VIDEO_MAX_COMPONENTS]        is CArray;
  has guint                @.poffset[GST_VIDEO_MAX_COMPONENTS]      is CArray;
  has guint                @.w_sub[GST_VIDEO_MAX_COMPONENTS]        is CArray;
  has guint                @.h_sub[GST_VIDEO_MAX_COMPONENTS]        is CArray;

  has GstVideoFormat       $.unpack_format                          is rw;
  has Pointer              $.unpack_func;                           # GstVideoUnpack func
  has gint                 $.pack_lines                             is rw;
  has Pointer              $.pack_func;                             # GstVideoPack   func

  has guint                $.tile_mode                              is rw;   # GstVideoTileMode
  has guint                $.tile_ws                                is rw;
  has guint                $.tile_hs                                is rw;

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

  HAS GstPaddingLarge $!padding;

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

  method ref is also<upref> {
    gst_video_codec_state_ref(self);
  }

  method unref is also<downref> {
    gst_video_codec_state_unref(self);
  }

  sub gst_video_codec_state_ref (GstVideoCodecState $state)
    returns GstVideoCodecState
    is native(gstreamer-video)
  { * }

  sub gst_video_codec_state_unref (GstVideoCodecState $state)
    returns GstVideoCodecState
    is native(gstreamer-video)
  { * }
}

class GstVideoFrame              is repr<CStruct>    does GLib::Roles::Pointers is export {
  HAS GstVideoInfo       $.info;
  has GstVideoFrameFlags $.flags is rw;

  has GstBuffer          $!buffer;
  has gpointer           $!meta;
  has gint               $.id is rw;

  has gpointer           @.data[GST_VIDEO_MAX_PLANES] is CArray;
  has GstMapInfo         @.map[GST_VIDEO_MAX_PLANES]  is CArray;

  has GstPadding         $!padding;

  method info is rw {
    Proxy.new:
      FETCH => -> $ { $.info },

      STORE => -> $, GstVideoInfo() \i {
        $.info."$_"() = i."$_"() for <
          interlace_mode
          flags
          width
          height
          size
          views
          chroma_site
          colorimetry
          par_n
          par_d
          fps_n
          fps_d
        >;
      }
  }

  method buffer is rw {
    Proxy.new:
      FETCH => -> $                 { self.^attributes[2].get_value(self)    },
      STORE => -> $, GstBuffer() \b { self.^attributes[2].set_value(self, b) };
  }

  method meta is rw {
    Proxy.new:
      FETCH => -> $              { self.^attributes[3].get_value(self)    },
      STORE => -> $, gpointer \p { self.^attributes[3].set_value(self, p) };
  }
}


role MetaRole is export {
  # Originally defined method meta, here. This did not work due to the fact
  # that roles and attribute contruction of repr<CStructs> are problematic
  #
  # Now left for identification purposes, ala:
  #   $obj ~~ MetaRole
}

class GstVideoMeta               is repr<CStruct>    does GLib::Roles::Pointers is export {
  also does MetaRole;

  HAS GstMeta            $!meta;
  has GstBuffer          $!buffer;

  has GstVideoFrameFlags $.flags  is rw;
  has GstVideoFormat     $.format is rw;
  has gint               $.id     is rw;
  has guint              $.width  is rw;
  has guint              $.height is rw;

  has guint              $.n_planes;
  has gsize              @.offset[GST_VIDEO_MAX_PLANES] is CArray;
  has gint               @.stride[GST_VIDEO_MAX_PLANES] is CArray;

  has Pointer            $!map;    # (GstVideoMeta *meta, guint plane,
                                   #  GstMapInfo *info, gpointer *data,
                                   #  gint *stride, GstMapFlags flags --> gboolean);

  has Pointer            $!unmap;  # (GstVideoMeta *meta, guint plane,
                                   #  GstMapInfo *info);

  method meta is rw {
    Proxy.new:
      FETCH => -> $ { $!meta },
      STORE => -> $, GstMeta() $m {
        $!meta.flags = $m.flags;
        $!meta.info  = $m.info;
      };
  }

  method buffer is rw {
    Proxy.new:
      FETCH => -> $                 { self.^attributes[1].get_value(self)    },
      STORE => -> $, GstBuffer() \b { self.^attributes[1].set_value(self, b) };
  }

  method get_info (GstVideoMeta:U:) {
    gst_video_meta_get_info();
  }

  multi method map is rw {
    Proxy.new:
      FETCH => -> $ { $!map },
      STORE => -> $, \func {
        $!map := set_func_pointer( &(func), &sprintf-GstMapFunc);
      };
  }
  multi method map (
    GstVideoMeta $meta,
    guint $plane,
    GstMapInfo $info,
    gpointer $data,
    gint $stride is rw,
    GstMapFlags $flags
  ) {
    gst_video_meta_map($meta, $plane, $info, $data, $stride, $flags);
  }

  multi method unmap is rw {
    Proxy.new:
      FETCH => -> $ { $!unmap },
      STORE => -> $, \func {
        $!unmap := set_func_pointer( &(func), &sprintf-GstUnmapFunc);
      };
  }
  multi method unmap (Int() $plane, GstMapInfo $info) {
    my guint $p = $plane;

    gst_video_meta_unmap(self, $p, $info);
  }

  ### /usr/include/gstreamer-1.0/gst/video/gstvideometa.h

  sub gst_video_meta_get_info ()
    returns GstMetaInfo
    is native(gstreamer-video)
  { * }

  sub gst_video_meta_map (
    GstVideoMeta $meta,
    guint $plane,
    GstMapInfo $info,
    gpointer $data,
    gint $stride is rw,
    GstMapFlags $flags
  )
    returns uint32
    is native(gstreamer-video)
  { * }

  sub gst_video_meta_unmap (
    GstVideoMeta $meta,
    guint $plane,
    GstMapInfo $info
  )
    returns uint32
    is native(gstreamer-video)
  { * }

  sub sprintf-GstMapFunc (
    Blob,
    Str,
    & (Pointer, guint, Pointer, Pointer, gint is rw, GstMapFlags --> gboolean),
  )
    returns int64
    is native
    is symbol('sprintf')
  { * }

  sub sprintf-GstUnmapFunc (
    Blob,
    Str,
    & (Pointer, guint, Pointer --> gboolean),
  )
    returns int64
    is native
    is symbol('sprintf')
  { * }

}

class GstVideoCropMeta           is repr<CStruct>    does GLib::Roles::Pointers is export {
  also does MetaRole;

  HAS GstMeta $!meta;
  has guint   $.x      is rw;
  has guint   $.y      is rw;
  has guint   $.width  is rw;
  has guint   $.height is rw;

  method meta is rw {
    Proxy.new:
      FETCH => -> $ { $!meta },
      STORE => -> $, GstMeta() $m {
        $!meta.flags = $m.flags;
        $!meta.info  = $m.info;
      };
  }

  method api_get_type (GstVideoCropMeta:U:) {
    gst_video_crop_meta_api_get_type();
  }

  method get_info (GstVideoCropMeta:U:) {
    gst_video_crop_meta_get_info();
  }

  ### /usr/include/gstreamer-1.0/gst/video/gstvideometa.h

  sub gst_video_crop_meta_api_get_type ()
    returns GType
    is native(gstreamer-video)
  { * }

  sub gst_video_crop_meta_get_info ()
    returns GstMetaInfo
    is native(gstreamer-video)
  { * }

}

class GstVideoMetaTransform       is repr<CStruct>    does GLib::Roles::Pointers is export {
  has GstVideoInfo $.in_info;
  has GstVideoInfo $.out_info;
}

class GstVideoGLTextureUploadMeta is repr<CStruct>    does GLib::Roles::Pointers is export {
  also does MetaRole;

  HAS GstMeta                      $!meta;

  has GstVideoGLTextureOrientation $.texture_orientation is rw;
  has guint                        $.n_textures          is rw;
  HAS GstVideoGLTextureType        @.texture_type[4]     is CArray;

  has GstBuffer                    $!buffer;
  has GstVideoGLTextureUpload      $!upload;
  has Pointer                      $!user_data;
  has Pointer                      $!user_data_copy;
  has Pointer                      $!user_data_free;

  method meta is rw {
    Proxy.new:
      FETCH => -> $ { $!meta },
      STORE => -> $, GstMeta() $m {
        $!meta.flags = $m.flags;
        $!meta.info  = $m.info;
      };
  }

  method api_get_type (GstVideoGLTextureUploadMeta:U:) is also<api-get-type> {
    gst_video_gl_texture_upload_meta_api_get_type();
  }

  method get_info (GstVideoGLTextureUploadMeta:U:) is also<get-info> {
    gst_video_gl_texture_upload_meta_get_info();
  }

  method upload (Int() $texture_id) {
    my guint $t = $texture_id;

    gst_video_gl_texture_upload_meta_upload(self, $t);
  }

  ### /usr/include/gstreamer-1.0/gst/video/gstvideometa.h

  sub gst_video_gl_texture_upload_meta_api_get_type ()
    returns GType
    is native(gstreamer-video)
  { * }

  sub gst_video_gl_texture_upload_meta_get_info ()
    returns GstMetaInfo
    is native(gstreamer-video)
  { * }

  sub gst_video_gl_texture_upload_meta_upload (
    GstVideoGLTextureUploadMeta $meta,
    guint $texture_id
  )
    returns uint32
    is native(gstreamer-video)
  { * }

}

class GstVideoTimeCodeMeta            is repr<CStruct>    does GLib::Roles::Pointers is export {
  also does MetaRole;

  HAS GstMeta          $!meta;
  has GstVideoTimeCode $.tc is rw;

  method meta is rw {
    Proxy.new:
      FETCH => -> $ { $!meta },
      STORE => -> $, GstMeta() $m {
        $!meta.flags = $m.flags;
        $!meta.info  = $m.info;
      };
  }

  method api_get_type (GstVideoTimeCodeMeta:U:) {
    gst_video_time_code_meta_api_get_type();
  }

  method get_info (GstVideoTimeCodeMeta:U:) {
    gst_video_time_code_meta_get_info();
  }

  sub gst_video_time_code_meta_api_get_type ()
    returns GType
    is native(gstreamer-video)
  { * }

  sub gst_video_time_code_meta_get_info ()
    returns GstMetaInfo
    is native(gstreamer-video)
  { * }
}

class GstVideoRegionOfInterestMeta
  is repr<CStruct>
  does GLib::Roles::Pointers
  is export
{
  also does MetaRole;

  HAS GstMeta $!meta;

  has GQuark $.roi_type  is rw;
  has gint   $.id        is rw;
  has gint   $.parent_id is rw;
  has guint  $.x         is rw;
  has guint  $.y         is rw;
  has guint  $.w         is rw;
  has guint  $.h         is rw;

  has GList  $.params;

  method meta is rw {
    Proxy.new:
      FETCH => -> $ { $!meta },
      STORE => -> $, GstMeta() $m {
        $!meta.flags = $m.flags;
        $!meta.info  = $m.info;
      };
  }

  method add_param (GstStructure() $s) {
    gst_video_region_of_interest_meta_add_param(self, $s);
  }

  method api_get_type (GstVideoRegionOfInterestMeta:U:) {
    gst_video_region_of_interest_meta_api_get_type();
  }

  method get_info (GstVideoRegionOfInterestMeta:U:) {
    gst_video_region_of_interest_meta_get_info();
  }

  method get_param (Str() $name) {
    gst_video_region_of_interest_meta_get_param(self, $name);
  }

  ### /usr/include/gstreamer-1.0/gst/video/gstvideometa.h

  sub gst_video_region_of_interest_meta_add_param (
    GstVideoRegionOfInterestMeta $meta,
    GstStructure $s
  )
    is native(gstreamer-video)
  { * }

  sub gst_video_region_of_interest_meta_api_get_type ()
    returns GType
    is native(gstreamer-video)
  { * }

  sub gst_video_region_of_interest_meta_get_info ()
    returns GstMetaInfo
    is native(gstreamer-video)
  { * }

  sub gst_video_region_of_interest_meta_get_param (
    GstVideoRegionOfInterestMeta $meta,
    Str $name
  )
    returns GstStructure
    is native(gstreamer-video)
  { * }

}

class GstVideoOverlayCompositionMeta
  is repr<CStruct>
  does GLib::Roles::Pointers
  is export
{
  also does MetaRole;

  HAS GstMeta                    $!meta;
  has GstVideoOverlayComposition $.overlay;

  method meta is rw {
    Proxy.new:
      FETCH => -> $ { $!meta },
      STORE => -> $, GstMeta() $m {
        $!meta.flags = $m.flags;
        $!meta.info  = $m.info;
      };
  }

  method get_info (GstVideoOverlayRectangle:U:) {
    gst_video_overlay_composition_meta_get_info();
  }

  ### /usr/include/gstreamer-1.0/gst/video/video-overlay-composition.h
  sub gst_video_overlay_composition_meta_get_info ()
    returns GstMetaInfo
    is native(gstreamer-video)
    is export
  { * }
}

class GstVideoResampler          is repr<CStruct> does GLib::Roles::Pointers is export {
  has gint            $.in_size    is rw;
  has gint            $.out_size   is rw;
  has guint           $.max_taps   is rw;
  has guint           $.n_phases   is rw;
  has CArray[guint32] $.offset;
  has CArray[guint32] $.phase;
  has CArray[guint32] $.n_taps;
  has CArray[gdouble] $.taps;

  HAS GstPadding      $!padding;

  method clear {
    gst_video_resampler_clear(self);
  }

  method init (
    GstVideoResamplerMethod $method,
    GstVideoResamplerFlags  $flags,
    guint                   $n_phases,
    guint                   $n_taps,
    gdouble                 $shift,
    guint                   $in_size,
    guint                   $out_size,
    GstStructure            $options
  ) {
    gst_video_resampler_init(
      self,
      $method,
      $flags,
      $n_phases,
      $n_taps,
      $shift,
      $in_size,
      $out_size,
      $options
    );
  }

  ### /usr/include/gstreamer-1.0/gst/video/video-resampler.h

  sub gst_video_resampler_clear (GstVideoResampler $resampler)
    is native(gstreamer-video)
    is export
  { * }

  sub gst_video_resampler_init (GstVideoResampler $resampler, GstVideoResamplerMethod $method, GstVideoResamplerFlags $flags, guint $n_phases, guint $n_taps, gdouble $shift, guint $in_size, guint $out_size, GstStructure $options)
    returns uint32
    is native(gstreamer-video)
    is export
  { * }
}

class GstVideoFilter             is repr<CStruct>  does GLib::Roles::Pointers is export {
  HAS GstBaseTransform $.element;

  has gboolean         $.negotiated is rw;
  has GstVideoInfo     $.in_info;
  has GstVideoInfo     $.out_info;

  HAS GstPadding       $!padding;
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

class GstPromise                 is repr<CStruct>  does GLib::Roles::Pointers is export {
  HAS GstMiniObject $.parent;
}

class GstAppSink                 is repr<CStruct>  does GLib::Roles::Pointers is export {
  HAS GstBaseSink $.basesink;

  has Pointer     $!priv;
  HAS GstPadding  $!padding;
}

class GstAppSinkCallbacks        is repr<CStruct>  does GLib::Roles::Pointers is export {
  has Pointer     $.eos;             #= (GstAppSink, gpointer)
  has Pointer     $.new_preroll;     #= (GstAppSink, gpointer --> GstFlowReturn)
  has Pointer     $.new_sample;      #= (GstAppSink, gpointer --> GstFlowReturn)

  HAS GstPadding  $!padding;

  multi method eos is rw {
    Proxy.new:
      FETCH => -> $ { $!eos },
      STORE => -> $, \func {
        $!eos := set_func_pointer( &(func), &sprintf-eos);
      };
  }

  multi method new_preroll is rw {
    Proxy.new:
      FETCH => -> $ { $!new_preroll },
      STORE => -> $, \func {
        $!new_preroll := set_func_pointer( &(func), &sprintf-rGstFlowReturn);
      };
  }

  multi method new_sample is rw {
    Proxy.new:
      FETCH => -> $ { $!new_sample },
      STORE => -> $, \func {
        $!new_sample := set_func_pointer( &(func), &sprintf-rGstFlowReturn);
      };
  }

  sub sprintf-eos (
    Blob,
    Str,
    & (GstAppSink, gpointer --> gboolean),
  )
    returns int64
    is native
    is symbol('sprintf')
  { * }

  sub sprintf-rGstFlowReturn (
    Blob,
    Str,
    & (GstAppSink, gpointer --> gboolean),
  )
    returns int64
    is native
    is symbol('sprintf')
  { * }
}


# NET

class GstNetClientClock          is repr<CStruct>  does GLib::Roles::Pointers is export {
  HAS GstSystemClock $.clock;
  # Private
  has Pointer        $!priv;
  HAS GstPadding     $!padding;
}

class GstNetTimeProvider         is repr<CStruct>  does GLib::Roles::Pointers is export {
  HAS GstObject   $.parent;
  # Private
  has Pointer     $!priv;
  HAS GstPadding  $!padding;
};

class GstTypeFind                is repr<CStruct>  does GLib::Roles::Pointers is export {
  has Pointer     $!peek;       #= (gpointer         data,
                                #=  gint64           offset,
                                #=  guint            size --> CArray[guint8])
  has Pointer     $!suggest;    #= (gpointer         data,
                                #=  guint            probability,
                                #=  GstCaps         *caps)
  has gpointer    $!data;
  # Optional
  has Pointer     $!get_length; #= (gpointer data --> guint64);
  HAS GstPadding  $!padding;
}
