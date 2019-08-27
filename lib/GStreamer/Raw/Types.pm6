use v6.c;

use GTK::Compat::Types;

unit package GStreamer::Raw::Types;

sub nocr ($s) is export {
  $s.subst("\n", ' ', :g);
}

constant GstClockTime     is export := guint32
constant GstClockTimeDiff is export := int64;

constant GstBusSyncHandler                 is export := Pointer;
constant GstElementCallAsyncFunc           is export := Pointer;
constant GstElementForeachPadFunc          is export := Pointer;
constant GstIteratorCopyFunction           is export := Pointer;
constant GstIteratorFoldFunction           is export := Pointer;
constant GstIteratorForeachFunction        is export := Pointer;
constant GstIteratorFreeFunction           is export := Pointer;
constant GstIteratorItemFunction           is export := Pointer;
constant GstIteratorNextFunction           is export := Pointer;
constant GstIteratorResyncFunction         is export := Pointer;
constant GstPadActivateFunction            is export := Pointer;
constant GstPadActivateModeFunction        is export := Pointer;
constant GstPadChainFunction               is export := Pointer;
constant GstPadChainListFunction           is export := Pointer;
constant GstPadEventFullFunction           is export := Pointer;
constant GstPadEventFunction               is export := Pointer;
constant GstPadForwardFunction             is export := Pointer;
constant GstPadGetRangeFunction            is export := Pointer;
constant GstPadIterIntLinkFunction         is export := Pointer;
constant GstPadLinkFunction                is export := Pointer;
constant GstPadStickyEventsForeachFunction is export := Pointer;
constant GstPadQueryFunction               is export := Pointer;
constant GstPadProbeCallback               is export := Pointer;
constant GstPadUnlinkFunction              is export := Pointer;
constant GstPluginInitFullFunc             is export := Pointer;
constant GstPluginInitFunc                 is export := Pointer;
constant GstTaskFunction                   is export := Pointer;

class GstBin               is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstBuffer            is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstBufferList        is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstBus               is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstChildProxy        is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstClock             is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstContext           is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstControlBinding    is repr('CPointer') does GTK::Roles::Pointers is export { }
#class GstElement           is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstElementFactory    is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstEvent             is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstIterator          is repr('CPointer') does GTK::Roles::Pointers is export { }
#class GstMessage           is repr('CPointer') does GTK::Roles::Pointers is export { }
#class GstObject            is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstPad               is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstPadProbeInfo      is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstPadTemplate       is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstPipeline          is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstPlugin            is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstPluginFeature     is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstProbeInfo         is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstQuery             is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstStaticPadTemplate is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstStructure         is repr('CPointer') does GTK::Roles::Pointers is export { }

our enum GstBufferingMode is export <
  GST_BUFFERING_STREAM
  GST_BUFFERING_DOWNLOAD
  GST_BUFFERING_TIMESHIFT
  GST_BUFFERING_LIVE
>;

our enum GstBusSyncReply is export (
  GST_BUS_DROP  => 0,
  GST_BUS_PASS  => 1,
  GST_BUS_ASYNC => 2,
);

our enum GstCapsIntersectMode is export (
  GST_CAPS_INTERSECT_ZIG_ZAG => 0,
  GST_CAPS_INTERSECT_FIRST   => 1,
);

our enum GstClockEntryType is export <
  GST_CLOCK_ENTRY_SINGLE
  GST_CLOCK_ENTRY_PERIODIC
>;

our enum GstClockReturn is export (
  GST_CLOCK_OK          => 0,
  GST_CLOCK_EARLY       => 1,
  GST_CLOCK_UNSCHEDULED => 2,
  GST_CLOCK_BUSY        => 3,
  GST_CLOCK_BADTIME     => 4,
  GST_CLOCK_ERROR       => 5,
  GST_CLOCK_UNSUPPORTED => 6,
  GST_CLOCK_DONE        => 7,
);

our enum GstClockType is export (
  GST_CLOCK_TYPE_REALTIME  => 0,
  GST_CLOCK_TYPE_MONOTONIC => 1,
  GST_CLOCK_TYPE_OTHER     => 2,
);

our enum GstCollectPadsStateFlags is export (
  GST_COLLECT_PADS_STATE_EOS         => 1 +< 0,
  GST_COLLECT_PADS_STATE_FLUSHING    => 1 +< 1,
  GST_COLLECT_PADS_STATE_NEW_SEGMENT => 1 +< 2,
  GST_COLLECT_PADS_STATE_WAITING     => 1 +< 3,
  GST_COLLECT_PADS_STATE_LOCKED      => 1 +< 4,
);

our enum GstCoreError is export (
  GST_CORE_ERROR_FAILED =>  1,
  'GST_CORE_ERROR_TOO_LAZY',
  'GST_CORE_ERROR_NOT_IMPLEMENTED',
  'GST_CORE_ERROR_STATE_CHANGE',
  'GST_CORE_ERROR_PAD',
  'GST_CORE_ERROR_THREAD',
  'GST_CORE_ERROR_NEGOTIATION',
  'GST_CORE_ERROR_EVENT',
  'GST_CORE_ERROR_SEEK',
  'GST_CORE_ERROR_CAPS',
  'GST_CORE_ERROR_TAG',
  'GST_CORE_ERROR_MISSING_PLUGIN',
  'GST_CORE_ERROR_CLOCK',
  'GST_CORE_ERROR_DISABLED',
  'GST_CORE_ERROR_NUM_ERRORS'
);

our enum GstDebugColorFlags is export (
  GST_DEBUG_FG_BLACK   => 0x0000,
  GST_DEBUG_FG_RED     => 0x0001,
  GST_DEBUG_FG_GREEN   => 0x0002,
  GST_DEBUG_FG_YELLOW  => 0x0003,
  GST_DEBUG_FG_BLUE    => 0x0004,
  GST_DEBUG_FG_MAGENTA => 0x0005,
  GST_DEBUG_FG_CYAN    => 0x0006,
  GST_DEBUG_FG_WHITE   => 0x0007,
  GST_DEBUG_BG_BLACK   => 0x0000,
  GST_DEBUG_BG_RED     => 0x0010,
  GST_DEBUG_BG_GREEN   => 0x0020,
  GST_DEBUG_BG_YELLOW  => 0x0030,
  GST_DEBUG_BG_BLUE    => 0x0040,
  GST_DEBUG_BG_MAGENTA => 0x0050,
  GST_DEBUG_BG_CYAN    => 0x0060,
  GST_DEBUG_BG_WHITE   => 0x0070,
  GST_DEBUG_BOLD       => 0x0100,
  GST_DEBUG_UNDERLINE  => 0x0200,
);

our enum GstDebugColorMode is export (
  GST_DEBUG_COLOR_MODE_OFF  =>  0,
  GST_DEBUG_COLOR_MODE_ON   =>  1,
  GST_DEBUG_COLOR_MODE_UNIX =>  2,
);

our enum GstDebugLevel is export (
  GST_LEVEL_NONE    => 0,
  GST_LEVEL_ERROR   => 1,
  GST_LEVEL_WARNING => 2,
  GST_LEVEL_FIXME   => 3,
  GST_LEVEL_INFO    => 4,
  GST_LEVEL_DEBUG   => 5,
  GST_LEVEL_LOG     => 6,
  GST_LEVEL_TRACE   => 7,
  GST_LEVEL_MEMDUMP => 9,
  'GST_LEVEL_COUNT'
);

our enum GstEventTypeFlags is export (
  GST_EVENT_TYPE_UPSTREAM     =>  1 +< 0,
  GST_EVENT_TYPE_DOWNSTREAM   =>  1 +< 1,
  GST_EVENT_TYPE_SERIALIZED   =>  1 +< 2,
  GST_EVENT_TYPE_STICKY       =>  1 +< 3,
  GST_EVENT_TYPE_STICKY_MULTI =>  1 +< 4,
);

our enum GstFormat is export (
  GST_FORMAT_UNDEFINED => 0,
  GST_FORMAT_DEFAULT   => 1,
  GST_FORMAT_BYTES     => 2,
  GST_FORMAT_TIME      => 3,
  GST_FORMAT_BUFFERS   => 4,
  GST_FORMAT_PERCENT   => 5,
);

our enum GstInterpolationMode is export <
  GST_INTERPOLATION_MODE_NONE
  GST_INTERPOLATION_MODE_LINEAR
  GST_INTERPOLATION_MODE_CUBIC
  GST_INTERPOLATION_MODE_CUBIC_MONOTONIC
>;

our enum GstIteratorItem is export (
  GST_ITERATOR_ITEM_SKIP =>  0,
  GST_ITERATOR_ITEM_PASS =>  1,
  GST_ITERATOR_ITEM_END  =>  2,
);

our enum GstIteratorResult is export (
  GST_ITERATOR_DONE   =>  0,
  GST_ITERATOR_OK     =>  1,
  GST_ITERATOR_RESYNC =>  2,
  GST_ITERATOR_ERROR  =>  3,
);

our enum GstLFOWaveform is export <
  GST_LFO_WAVEFORM_SINE
  GST_LFO_WAVEFORM_SQUARE
  GST_LFO_WAVEFORM_SAW
  GST_LFO_WAVEFORM_REVERSE_SAW
  GST_LFO_WAVEFORM_TRIANGLE
>;

our enum GstLibraryError is export (
  GST_LIBRARY_ERROR_FAILED =>  1,
  'GST_LIBRARY_ERROR_TOO_LAZY',
  'GST_LIBRARY_ERROR_INIT',
  'GST_LIBRARY_ERROR_SHUTDOWN',
  'GST_LIBRARY_ERROR_SETTINGS',
  'GST_LIBRARY_ERROR_ENCODE',
  'GST_LIBRARY_ERROR_NUM_ERRORS'
);

our enum GstLockFlags (
  GST_LOCK_FLAG_READ      => 1,
  GST_LOCK_FLAG_WRITE     => (1 +< 1),
  GST_LOCK_FLAG_EXCLUSIVE => (1 +< 2),
  GST_LOCK_FLAG_LAST      => (1 +< 8)
);

our enum GstMiniObjectFlags is export (
  GST_MINI_OBJECT_FLAG_LOCKABLE      => 1,
  GST_MINI_OBJECT_FLAG_LOCK_READONLY => (1 +< 1),
  GST_MINI_OBJECT_FLAG_MAY_BE_LEAKED => (1 +< 2),
  # Padding
  GST_MINI_OBJECT_FLAG_LAST          => (1 +< 4)
);


our enum GstPadDirection is export <
  GST_PAD_UNKNOWN
  GST_PAD_SRC
  GST_PAD_SINK
>;

our enum GstPadMode is export <
  GST_PAD_MODE_NONE
  GST_PAD_MODE_PUSH
  GST_PAD_MODE_PULL
>;

our enum GstPadPresence is export <
  GST_PAD_ALWAYS
  GST_PAD_SOMETIMES
  GST_PAD_REQUEST
>;

our enum GstPadProbeReturn is export <
  GST_PAD_PROBE_DROP
  GST_PAD_PROBE_OK
  GST_PAD_PROBE_REMOVE
  GST_PAD_PROBE_PASS
  GST_PAD_PROBE_HANDLED
>;

our enum GstParseError is export <
  GST_PARSE_ERROR_SYNTAX
  GST_PARSE_ERROR_NO_SUCH_ELEMENT
  GST_PARSE_ERROR_NO_SUCH_PROPERTY
  GST_PARSE_ERROR_LINK
  GST_PARSE_ERROR_COULD_NOT_SET_PROPERTY
  GST_PARSE_ERROR_EMPTY_BIN
  GST_PARSE_ERROR_EMPTY
  GST_PARSE_ERROR_DELAYED_LINK
>;

our enum GstPluginError is export <
  GST_PLUGIN_ERROR_MODULE
  GST_PLUGIN_ERROR_DEPENDENCIES
  GST_PLUGIN_ERROR_NAME_MISMATCH
>;

our enum GstProgressType is export (
  GST_PROGRESS_TYPE_START    =>  0,
  GST_PROGRESS_TYPE_CONTINUE =>  1,
  GST_PROGRESS_TYPE_COMPLETE =>  2,
  GST_PROGRESS_TYPE_CANCELED =>  3,
  GST_PROGRESS_TYPE_ERROR    =>  4,
);

our enum GstPromiseResult is export <
  GST_PROMISE_RESULT_PENDING
  GST_PROMISE_RESULT_INTERRUPTED
  GST_PROMISE_RESULT_REPLIED
  GST_PROMISE_RESULT_EXPIRED
>;

our enum GstQOSType is export (
  GST_QOS_TYPE_OVERFLOW  =>  0,
  GST_QOS_TYPE_UNDERFLOW =>  1,
  GST_QOS_TYPE_THROTTLE  =>  2,
);

our enum GstQueryTypeFlags is export (
  GST_QUERY_TYPE_UPSTREAM   =>  1 +< 0,
  GST_QUERY_TYPE_DOWNSTREAM =>  1 +< 1,
  GST_QUERY_TYPE_SERIALIZED =>  1 +< 2,
);

our enum GstRank is export (
  GST_RANK_NONE      =>  0,
  GST_RANK_MARGINAL  =>  64,
  GST_RANK_SECONDARY =>  128,
  GST_RANK_PRIMARY   =>  256,
);

our enum GstResourceError is export (
  GST_RESOURCE_ERROR_FAILED =>  1,
  'GST_RESOURCE_ERROR_TOO_LAZY',
  'GST_RESOURCE_ERROR_NOT_FOUND',
  'GST_RESOURCE_ERROR_BUSY',
  'GST_RESOURCE_ERROR_OPEN_READ',
  'GST_RESOURCE_ERROR_OPEN_WRITE',
  'GST_RESOURCE_ERROR_OPEN_READ_WRITE',
  'GST_RESOURCE_ERROR_CLOSE',
  'GST_RESOURCE_ERROR_READ',
  'GST_RESOURCE_ERROR_WRITE',
  'GST_RESOURCE_ERROR_SEEK',
  'GST_RESOURCE_ERROR_SYNC',
  'GST_RESOURCE_ERROR_SETTINGS',
  'GST_RESOURCE_ERROR_NO_SPACE_LEFT',
  'GST_RESOURCE_ERROR_NOT_AUTHORIZED',
  'GST_RESOURCE_ERROR_NUM_ERRORS'
);

our enum GstSearchMode is export (
  GST_SEARCH_MODE_EXACT =>  0,
  'GST_SEARCH_MODE_BEFORE',
  'GST_SEARCH_MODE_AFTER'
);

our enum GstSeekType is export (
  GST_SEEK_TYPE_NONE =>  0,
  GST_SEEK_TYPE_SET =>  1,
  GST_SEEK_TYPE_END =>  2,
);

our enum GstStackTraceFlags is export (
  GST_STACK_TRACE_SHOW_FULL =>  1 +< 0,
);

our enum GstState is export (
  GST_STATE_VOID_PENDING =>  0,
  GST_STATE_NULL =>  1,
  GST_STATE_READY =>  2,
  GST_STATE_PAUSED =>  3,
  GST_STATE_PLAYING =>  4,
);

our enum GstStateChangeReturn is export (
  GST_STATE_CHANGE_FAILURE =>  0,
  GST_STATE_CHANGE_SUCCESS =>  1,
  GST_STATE_CHANGE_ASYNC =>  2,
  GST_STATE_CHANGE_NO_PREROLL =>  3,
);

our enum GstStreamError is export (
  GST_STREAM_ERROR_FAILED =>  1,
  'GST_STREAM_ERROR_TOO_LAZY',
  'GST_STREAM_ERROR_NOT_IMPLEMENTED',
  'GST_STREAM_ERROR_TYPE_NOT_FOUND',
  'GST_STREAM_ERROR_WRONG_TYPE',
  'GST_STREAM_ERROR_CODEC_NOT_FOUND',
  'GST_STREAM_ERROR_DECODE',
  'GST_STREAM_ERROR_ENCODE',
  'GST_STREAM_ERROR_DEMUX',
  'GST_STREAM_ERROR_MUX',
  'GST_STREAM_ERROR_FORMAT',
  'GST_STREAM_ERROR_DECRYPT',
  'GST_STREAM_ERROR_DECRYPT_NOKEY',
  'GST_STREAM_ERROR_NUM_ERRORS'
);

our enum GstStreamStatusType is export (
  GST_STREAM_STATUS_TYPE_CREATE =>  0,
  GST_STREAM_STATUS_TYPE_ENTER =>  1,
  GST_STREAM_STATUS_TYPE_LEAVE =>  2,
  GST_STREAM_STATUS_TYPE_DESTROY =>  3,
  GST_STREAM_STATUS_TYPE_START =>  8,
  GST_STREAM_STATUS_TYPE_PAUSE =>  9,
  GST_STREAM_STATUS_TYPE_STOP =>  10,
);

our enum GstStreamType is export (
  GST_STREAM_TYPE_UNKNOWN =>  1 +< 0,
  GST_STREAM_TYPE_AUDIO =>  1 +< 1,
  GST_STREAM_TYPE_VIDEO =>  1 +< 2,
  GST_STREAM_TYPE_CONTAINER =>  1 +< 3,
  GST_STREAM_TYPE_TEXT =>  1 +< 4,
);

our enum GstStructureChangeType is export (
  GST_STRUCTURE_CHANGE_TYPE_PAD_LINK =>  0,
  GST_STRUCTURE_CHANGE_TYPE_PAD_UNLINK =>  1,
);

our enum GstTagFlag is export <
  GST_TAG_FLAG_UNDEFINED
  GST_TAG_FLAG_META
  GST_TAG_FLAG_ENCODED
  GST_TAG_FLAG_DECODED
  GST_TAG_FLAG_COUNT
>;

our enum GstTagMergeMode is export <
  GST_TAG_MERGE_UNDEFINED
  GST_TAG_MERGE_REPLACE_ALL
  GST_TAG_MERGE_REPLACE
  GST_TAG_MERGE_APPEND
  GST_TAG_MERGE_PREPEND
  GST_TAG_MERGE_KEEP
  GST_TAG_MERGE_KEEP_ALL
  GST_TAG_MERGE_COUNT
>;

our enum GstTagScope is export <
  GST_TAG_SCOPE_STREAM
  GST_TAG_SCOPE_GLOBAL
>;

our enum GstTaskState is export <
  GST_TASK_STARTED
  GST_TASK_STOPPED
  GST_TASK_PAUSED
>;

our enum GstTocLoopType is export (
  GST_TOC_LOOP_NONE =>  0,
  'GST_TOC_LOOP_FORWARD',
  'GST_TOC_LOOP_REVERSE',
  'GST_TOC_LOOP_PING_PONG'
);

our enum GstTocScope is export (
  GST_TOC_SCOPE_GLOBAL =>  1,
  GST_TOC_SCOPE_CURRENT =>  2,
);

our enum GstTracerValueScope is export <
  GST_TRACER_VALUE_SCOPE_PROCESS
  GST_TRACER_VALUE_SCOPE_THREAD
  GST_TRACER_VALUE_SCOPE_ELEMENT
  GST_TRACER_VALUE_SCOPE_PAD
>;

our enum GstTypeFindProbability is export (
  GST_TYPE_FIND_NONE =>  0,
  GST_TYPE_FIND_MINIMUM =>  1,
  GST_TYPE_FIND_POSSIBLE =>  50,
  GST_TYPE_FIND_LIKELY =>  80,
  GST_TYPE_FIND_NEARLY_CERTAIN =>  99,
  GST_TYPE_FIND_MAXIMUM =>  100,
);

our enum GstURIError is export <
  GST_URI_ERROR_UNSUPPORTED_PROTOCOL
  GST_URI_ERROR_BAD_URI
  GST_URI_ERROR_BAD_STATE
  GST_URI_ERROR_BAD_REFERENCE
>;

our enum GstURIType is export <
  GST_URI_UNKNOWN
  GST_URI_SINK
  GST_URI_SRC
>;

constant GST_PADDING = 4;

class GstObject is repr<CStruct> does GTK::Roles::Pointers is export {
  HAS GObjectStruct     $.object;  # GInitiallyUnowned
  HAS GMutex            $.lock;
  has gchar             $.name;
  has GstObject         $.parent;
  has guint32           $.flags;

  has GList             $!control_bindings;
  has guint64           $!control_rate;
  has guint64           $!last_sync;
  has gpointer          $!gst_reserved;
}

class GstMiniObject is repr<CStruct> does GTK::Roles::Pointers is export {
  has GType    $.type;

  has gint     $.refcount;
  has gint     $.lockstate;
  has guint    $.flags;

  has gpointer $.copy;     # GstMiniObjectCopyFunction
  has gpointer $.dispose;  # GstMiniObjectDisposeFunction
  has gpointer $.free;     # GstMiniObjectFreeFunction

  has guint    $!priv_uint;
  has gpointer $!priv_pointer;
};

class GstElement is repr<CStruct> does GTK::Roles::Pointers is export {
  HAS GstObject        $.object;
  HAS GRecMutex        $.state_lock;
  HAS GCond            $.state_cond;
  has guint32          $.state_cookie;
  has GstState         $.target_state;
  has GstState         $.current_state;
  has GstState         $.next_state;
  has GstState         $.pending_state;
  has guint            $.last_return;     # GstStateChangeReturn
  has GstBus           $.bus;
  has GstClock         $.clock;
  has GstClockTimeDiff $.base_time;
  has GstClockTime     $.start_time;
  has guint16          $.numpads;
  has GList            $.pads;
  has guint16          $.numsrcpads;
  has GList            $.srcpads;
  has guint16          $.numsinkpads;
  has GList            $.sinkpads;
  has guint32          $.pads_cookie;
  has GList            $.contexts;

  gpointer             $!gst_reserved0;
  gpointer             $!gst_reserved1;
  gpointer             $!gst_reserved2;
  gpointer             $!gst_reserved3;
}

class GstMessage is repr<CStruct> does GTK::Roles::Pointers is export {
  HAS GstMiniObject   $.mini_object;
  has guint           $!type;        # GstMessageType
  has guint64         $.timestamp;
  has GstObject       $.src;
  has guint32         $.seqnum;
  HAS GMutex          $!lock;
  HAS GCond           $!cond;

  method type is rw {
    Proxy.new:
      FETCH => -> $           { GstMessageType($!type) },
      STORE => -> $, Int() \t { $!type = t             };
  }

};
