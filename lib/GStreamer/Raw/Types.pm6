use v6.c;

use NativeCall;

use GTK::Compat::Types;

unit package GStreamer::Raw::Types;

sub nocr ($s) is export {
  $s.subst("\n", ' ', :g);
}

constant GstClockTime     is export := gint64;
constant GstClockTimeDiff is export := int64;

# cw: I now realize, that at some point, ALL of these will have to be functions
#     to account for the various distributions and OSes out there.
constant gstreamer is export = 'gstreamer-1.0',v0;

constant GstBusSyncHandler                 is export := Pointer;
constant GstElementCallAsyncFunc           is export := Pointer;
constant GstElementForeachPadFunc          is export := Pointer;
constant GstClockCallback                  is export := Pointer;
constant GstClockID                        is export := Pointer;
constant GstIteratorCopyFunction           is export := Pointer;
constant GstIteratorFoldFunction           is export := Pointer;
constant GstIteratorForeachFunction        is export := Pointer;
constant GstIteratorFreeFunction           is export := Pointer;
constant GstIteratorItemFunction           is export := Pointer;
constant GstIteratorNextFunction           is export := Pointer;
constant GstIteratorResyncFunction         is export := Pointer;
constant GstMiniObjectCopyFunction         is export := Pointer;
constant GstMiniObjectDisposeFunction      is export := Pointer;
constant GstMiniObjectFreeFunction         is export := Pointer;
constant GstMiniObjectNotify               is export := Pointer;
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
class GstCaps              is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstChildProxy        is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstClock             is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstContext           is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstControlBinding    is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstDevice            is repr('CPointer') does GTK::Roles::Pointers is export { }
#class GstElement           is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstElementFactory    is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstEvent             is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstIterator          is repr('CPointer') does GTK::Roles::Pointers is export { }
#class GstMessage           is repr('CPointer') does GTK::Roles::Pointers is export { }
#class GstObject            is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstPad               is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstPadProbeInfo      is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstPadTemplate       is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstParseContext      is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstPipeline          is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstPlugin            is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstPluginFeature     is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstProbeInfo         is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstQuery             is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstStaticPadTemplate is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstStream            is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstStreamCollection  is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstStructure         is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstTagList           is repr('CPointer') does GTK::Roles::Pointers is export { }
class GstToc               is repr('CPointer') does GTK::Roles::Pointers is export { }

constant GST_OBJECT_FLAG_LAST is export = 1 +< 4;
constant GST_CLOCK_TIME_NONE  is export = 18446744073709551615;
constant GST_TIME_FORMAT      is export = '%u:%02u:%02u.%09u';

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

our enum GstClockFlags is export (
  GST_CLOCK_FLAG_CAN_DO_SINGLE_SYNC     => (GST_OBJECT_FLAG_LAST +< 0),
  GST_CLOCK_FLAG_CAN_DO_SINGLE_ASYNC    => (GST_OBJECT_FLAG_LAST +< 1),
  GST_CLOCK_FLAG_CAN_DO_PERIODIC_SYNC   => (GST_OBJECT_FLAG_LAST +< 2),
  GST_CLOCK_FLAG_CAN_DO_PERIODIC_ASYNC  => (GST_OBJECT_FLAG_LAST +< 3),
  GST_CLOCK_FLAG_CAN_SET_RESOLUTION     => (GST_OBJECT_FLAG_LAST +< 4),
  GST_CLOCK_FLAG_CAN_SET_MASTER         => (GST_OBJECT_FLAG_LAST +< 5),
  GST_CLOCK_FLAG_NEEDS_STARTUP_SYNC     => (GST_OBJECT_FLAG_LAST +< 6),
  GST_CLOCK_FLAG_LAST                   => (GST_OBJECT_FLAG_LAST +< 8)
);

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

our enum GstElementFlags is export (
  GST_ELEMENT_FLAG_LOCKED_STATE   => (GST_OBJECT_FLAG_LAST +< 0),
  GST_ELEMENT_FLAG_SINK           => (GST_OBJECT_FLAG_LAST +< 1),
  GST_ELEMENT_FLAG_SOURCE         => (GST_OBJECT_FLAG_LAST +< 2),
  GST_ELEMENT_FLAG_PROVIDE_CLOCK  => (GST_OBJECT_FLAG_LAST +< 3),
  GST_ELEMENT_FLAG_REQUIRE_CLOCK  => (GST_OBJECT_FLAG_LAST +< 4),
  GST_ELEMENT_FLAG_INDEXABLE      => (GST_OBJECT_FLAG_LAST +< 5),
  GST_ELEMENT_FLAG_LAST           => (GST_OBJECT_FLAG_LAST +< 10)
);

our enum GstEventTypeFlags is export (
  GST_EVENT_TYPE_UPSTREAM     =>  1 +< 0,
  GST_EVENT_TYPE_DOWNSTREAM   =>  1 +< 1,
  GST_EVENT_TYPE_SERIALIZED   =>  1 +< 2,
  GST_EVENT_TYPE_STICKY       =>  1 +< 3,
  GST_EVENT_TYPE_STICKY_MULTI =>  1 +< 4,
);

constant GST_EVENT_TYPE_BOTH is export = GST_EVENT_TYPE_UPSTREAM +| GST_EVENT_TYPE_DOWNSTREAM;

our enum GstEventType is export (
  GST_EVENT_UNKNOWN                  => 0,

  # bidirectional events
  GST_EVENT_FLUSH_START              => 10 +< 8 +| GST_EVENT_TYPE_BOTH,
  GST_EVENT_FLUSH_STOP               => 20 +< 8 +| GST_EVENT_TYPE_BOTH +| GST_EVENT_TYPE_SERIALIZED.Int,

  # downstream serialized events
  GST_EVENT_STREAM_START             => 40  +< 8 +| GST_EVENT_TYPE_DOWNSTREAM.Int +| GST_EVENT_TYPE_SERIALIZED.Int +| GST_EVENT_TYPE_STICKY.Int,
  GST_EVENT_CAPS                     => 50  +< 8 +| GST_EVENT_TYPE_DOWNSTREAM.Int +| GST_EVENT_TYPE_SERIALIZED.Int +| GST_EVENT_TYPE_STICKY.Int,
  GST_EVENT_SEGMENT                  => 70  +< 8 +| GST_EVENT_TYPE_DOWNSTREAM.Int +| GST_EVENT_TYPE_SERIALIZED.Int +| GST_EVENT_TYPE_STICKY.Int,
  GST_EVENT_STREAM_COLLECTION        => 75  +< 8 +| GST_EVENT_TYPE_DOWNSTREAM.Int +| GST_EVENT_TYPE_SERIALIZED.Int +| GST_EVENT_TYPE_STICKY.Int +| GST_EVENT_TYPE_STICKY_MULTI.Int,
  GST_EVENT_TAG                      => 80  +< 8 +| GST_EVENT_TYPE_DOWNSTREAM.Int +| GST_EVENT_TYPE_SERIALIZED.Int +| GST_EVENT_TYPE_STICKY.Int +| GST_EVENT_TYPE_STICKY_MULTI.Int,
  GST_EVENT_BUFFERSIZE               => 90  +< 8 +| GST_EVENT_TYPE_DOWNSTREAM.Int +| GST_EVENT_TYPE_SERIALIZED.Int +| GST_EVENT_TYPE_STICKY.Int,
  GST_EVENT_SINK_MESSAGE             => 100 +< 8 +| GST_EVENT_TYPE_DOWNSTREAM.Int +| GST_EVENT_TYPE_SERIALIZED.Int +| GST_EVENT_TYPE_STICKY.Int +| GST_EVENT_TYPE_STICKY_MULTI.Int,
  GST_EVENT_STREAM_GROUP_DONE        => 105 +< 8 +| GST_EVENT_TYPE_DOWNSTREAM.Int +| GST_EVENT_TYPE_SERIALIZED.Int +| GST_EVENT_TYPE_STICKY.Int,
  GST_EVENT_EOS                      => 110 +< 8 +| GST_EVENT_TYPE_DOWNSTREAM.Int +| GST_EVENT_TYPE_SERIALIZED.Int +| GST_EVENT_TYPE_STICKY.Int,
  GST_EVENT_TOC                      => 120 +< 8 +| GST_EVENT_TYPE_DOWNSTREAM.Int +| GST_EVENT_TYPE_SERIALIZED.Int +| GST_EVENT_TYPE_STICKY.Int +| GST_EVENT_TYPE_STICKY_MULTI.Int,
  GST_EVENT_PROTECTION               => 130 +< 8 +| GST_EVENT_TYPE_DOWNSTREAM.Int +| GST_EVENT_TYPE_SERIALIZED.Int +| GST_EVENT_TYPE_STICKY.Int +| GST_EVENT_TYPE_STICKY_MULTI.Int,

  # non-sticky downstream serialized
  GST_EVENT_SEGMENT_DONE             => 150 +< 8 +| GST_EVENT_TYPE_DOWNSTREAM.Int +| GST_EVENT_TYPE_SERIALIZED.Int,
  GST_EVENT_GAP                      => 160 +< 8 +| GST_EVENT_TYPE_DOWNSTREAM.Int +| GST_EVENT_TYPE_SERIALIZED.Int,

  # upstream events
  GST_EVENT_QOS                      => 190 +< 8 +| GST_EVENT_TYPE_UPSTREAM.Int,
  GST_EVENT_SEEK                     => 200 +< 8 +| GST_EVENT_TYPE_UPSTREAM.Int,
  GST_EVENT_NAVIGATION               => 210 +< 8 +| GST_EVENT_TYPE_UPSTREAM.Int,
  GST_EVENT_LATENCY                  => 220 +< 8 +| GST_EVENT_TYPE_UPSTREAM.Int,
  GST_EVENT_STEP                     => 230 +< 8 +| GST_EVENT_TYPE_UPSTREAM.Int,
  GST_EVENT_RECONFIGURE              => 240 +< 8 +| GST_EVENT_TYPE_UPSTREAM.Int,
  GST_EVENT_TOC_SELECT               => 250 +< 8 +| GST_EVENT_TYPE_UPSTREAM.Int,
  GST_EVENT_SELECT_STREAMS           => 260 +< 8 +| GST_EVENT_TYPE_UPSTREAM.Int,

  # custom events start here
  GST_EVENT_CUSTOM_UPSTREAM          => 270 +< 8 +| GST_EVENT_TYPE_UPSTREAM.Int,
  GST_EVENT_CUSTOM_DOWNSTREAM        => 280 +< 8 +| GST_EVENT_TYPE_DOWNSTREAM.Int +| GST_EVENT_TYPE_SERIALIZED.Int,
  GST_EVENT_CUSTOM_DOWNSTREAM_OOB    => 290 +< 8 +| GST_EVENT_TYPE_DOWNSTREAM.Int,
  GST_EVENT_CUSTOM_DOWNSTREAM_STICKY => 300 +< 8 +| GST_EVENT_TYPE_DOWNSTREAM.Int +| GST_EVENT_TYPE_SERIALIZED.Int +| GST_EVENT_TYPE_STICKY.Int +| GST_EVENT_TYPE_STICKY_MULTI.Int,
  GST_EVENT_CUSTOM_BOTH              => 310 +< 8 +| GST_EVENT_TYPE_BOTH           +| GST_EVENT_TYPE_SERIALIZED.Int,
  GST_EVENT_CUSTOM_BOTH_OOB          => 320 +< 8 +| GST_EVENT_TYPE_BOTH
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

constant GstLockFlags is export := guint;
our enum GstLockFlagsEnum (
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

# C wants gint, but Perl might get confused. At the time of this writing,
# there are issues with NativeCall and unsigned integers. For now, will
# treat as UINT32, and will adjust as needed.
our enum GstMessageType is export (
  GST_MESSAGE_UNKNOWN           => 0,
  GST_MESSAGE_EOS               => (1 +< 0),
  GST_MESSAGE_ERROR             => (1 +< 1),
  GST_MESSAGE_WARNING           => (1 +< 2),
  GST_MESSAGE_INFO              => (1 +< 3),
  GST_MESSAGE_TAG               => (1 +< 4),
  GST_MESSAGE_BUFFERING         => (1 +< 5),
  GST_MESSAGE_STATE_CHANGED     => (1 +< 6),
  GST_MESSAGE_STATE_DIRTY       => (1 +< 7),
  GST_MESSAGE_STEP_DONE         => (1 +< 8),
  GST_MESSAGE_CLOCK_PROVIDE     => (1 +< 9),
  GST_MESSAGE_CLOCK_LOST        => (1 +< 10),
  GST_MESSAGE_NEW_CLOCK         => (1 +< 11),
  GST_MESSAGE_STRUCTURE_CHANGE  => (1 +< 12),
  GST_MESSAGE_STREAM_STATUS     => (1 +< 13),
  GST_MESSAGE_APPLICATION       => (1 +< 14),
  GST_MESSAGE_ELEMENT           => (1 +< 15),
  GST_MESSAGE_SEGMENT_START     => (1 +< 16),
  GST_MESSAGE_SEGMENT_DONE      => (1 +< 17),
  GST_MESSAGE_DURATION_CHANGED  => (1 +< 18),
  GST_MESSAGE_LATENCY           => (1 +< 19),
  GST_MESSAGE_ASYNC_START       => (1 +< 20),
  GST_MESSAGE_ASYNC_DONE        => (1 +< 21),
  GST_MESSAGE_REQUEST_STATE     => (1 +< 22),
  GST_MESSAGE_STEP_START        => (1 +< 23),
  GST_MESSAGE_QOS               => (1 +< 24),
  GST_MESSAGE_PROGRESS          => (1 +< 25),
  GST_MESSAGE_TOC               => (1 +< 26),
  GST_MESSAGE_RESET_TIME        => (1 +< 27),
  GST_MESSAGE_STREAM_START      => (1 +< 28),
  GST_MESSAGE_NEED_CONTEXT      => (1 +< 29),
  GST_MESSAGE_HAVE_CONTEXT      => (1 +< 30),
  GST_MESSAGE_EXTENDED          => (1 +< 31),
  GST_MESSAGE_DEVICE_ADDED      => (1 +< 31) + 1,
  GST_MESSAGE_DEVICE_REMOVED    => (1 +< 31) + 2,
  GST_MESSAGE_PROPERTY_NOTIFY   => (1 +< 31) + 3,
  GST_MESSAGE_STREAM_COLLECTION => (1 +< 31) + 4,
  GST_MESSAGE_STREAMS_SELECTED  => (1 +< 31) + 5,
  GST_MESSAGE_REDIRECT          => (1 +< 31) + 6,
  GST_MESSAGE_DEVICE_CHANGED    => (1 +< 31) + 7,
  GST_MESSAGE_ANY               => 0xffffffff
);

our enum GstPadDirection is export <
  GST_PAD_UNKNOWN
  GST_PAD_SRC
  GST_PAD_SINK
>;

our constant GstFlowReturn is export := gint;
our enum GstFlowReturnEnum is export (
  GST_FLOW_CUSTOM_SUCCESS_2 => 102,
  GST_FLOW_CUSTOM_SUCCESS_1 => 101,
  GST_FLOW_CUSTOM_SUCCESS   => 100,
  GST_FLOW_OK		            =>  0,
  GST_FLOW_NOT_LINKED       => -1,
  GST_FLOW_FLUSHING         => -2,
  GST_FLOW_EOS              => -3,
  GST_FLOW_NOT_NEGOTIATED   => -4,
  GST_FLOW_ERROR	          => -5,
  GST_FLOW_NOT_SUPPORTED    => -6,
  GST_FLOW_CUSTOM_ERROR     => -100,
  GST_FLOW_CUSTOM_ERROR_1   => -101,
  GST_FLOW_CUSTOM_ERROR_2   => -102
);

our enum GstPadLinkCheck is export (
  GST_PAD_LINK_CHECK_NOTHING        => 0,
  GST_PAD_LINK_CHECK_HIERARCHY      => 1,
  GST_PAD_LINK_CHECK_TEMPLATE_CAPS  => 1 +< 1,
  GST_PAD_LINK_CHECK_CAPS           => 1 +< 2,
  GST_PAD_LINK_CHECK_NO_RECONFIGURE => 1 +< 3,
  GST_PAD_LINK_CHECK_DEFAULT        => 1 +| (1 +< 2)
);

our constant GstPadLinkReturn is export := gint;
our enum GstPadLinkReturnEnum is export (
  GST_PAD_LINK_OK               =>  0,
  GST_PAD_LINK_WRONG_HIERARCHY  => -1,
  GST_PAD_LINK_WAS_LINKED       => -2,
  GST_PAD_LINK_WRONG_DIRECTION  => -3,
  GST_PAD_LINK_NOFORMAT         => -4,
  GST_PAD_LINK_NOSCHED          => -5,
  GST_PAD_LINK_REFUSED          => -6
);

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

our enum GstPadProbeType is export (
  GST_PAD_PROBE_TYPE_INVALID          => 0,
  GST_PAD_PROBE_TYPE_IDLE             => (1 +< 0),
  GST_PAD_PROBE_TYPE_BLOCK            => (1 +< 1),
  GST_PAD_PROBE_TYPE_BUFFER           => (1 +< 4),
  GST_PAD_PROBE_TYPE_BUFFER_LIST      => (1 +< 5),
  GST_PAD_PROBE_TYPE_EVENT_DOWNSTREAM => (1 +< 6),
  GST_PAD_PROBE_TYPE_EVENT_UPSTREAM   => (1 +< 7),
  GST_PAD_PROBE_TYPE_EVENT_FLUSH      => (1 +< 8),
  GST_PAD_PROBE_TYPE_QUERY_DOWNSTREAM => (1 +< 9),
  GST_PAD_PROBE_TYPE_QUERY_UPSTREAM   => (1 +< 10),
  GST_PAD_PROBE_TYPE_PUSH             => (1 +< 12),
  GST_PAD_PROBE_TYPE_PULL             => (1 +< 13),

  GST_PAD_PROBE_TYPE_BLOCKING         => 0         +| (1 +< 1),
  GST_PAD_PROBE_TYPE_DATA_DOWNSTREAM  => (1 +< 4)  +| (1 +< 5) +| (1 +< 6),
  GST_PAD_PROBE_TYPE_DATA_UPSTREAM    => (1 +< 7),
  GST_PAD_PROBE_TYPE_DATA_BOTH        => (1 +< 4)  +| (1 +< 5) +| (1 +< 6) +| (1 +< 7),
  GST_PAD_PROBE_TYPE_BLOCK_DOWNSTREAM => (1 +< 1)  +| (1 +< 4) +| (1 +< 5) +| (1 +< 6),
  GST_PAD_PROBE_TYPE_BLOCK_UPSTREAM   => (1 +< 1)  +| (1 +< 7),
  GST_PAD_PROBE_TYPE_EVENT_BOTH       => (1 +< 6)  +| (1 +< 7),
  GST_PAD_PROBE_TYPE_QUERY_BOTH       => (1 +< 9)  +| (1 +< 10),
  GST_PAD_PROBE_TYPE_ALL_BOTH         => (1 +< 4)  +| (1 +< 5) +| (1 +< 6) +| (1 +< 7) +| (1 +< 9) +| (1 +< 10),
  GST_PAD_PROBE_TYPE_SCHEDULING       => (1 +< 12) +| (1 +< 13)
);

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

our enum GstParseFlags is export (
  GST_PARSE_FLAG_NONE                   => 0,
  GST_PARSE_FLAG_FATAL_ERRORS           => 1,
  GST_PARSE_FLAG_NO_SINGLE_ELEMENT_BINS => (1 +< 1),
  GST_PARSE_FLAG_PLACE_IN_BIN           => (1 +< 2)
);

our enum GstPluginDependencyFlags is export (
  GST_PLUGIN_DEPENDENCY_FLAG_NONE                      => 0,
  GST_PLUGIN_DEPENDENCY_FLAG_RECURSE                   => 1,
  GST_PLUGIN_DEPENDENCY_FLAG_PATHS_ARE_DEFAULT_ONLY    => (1 +< 1),
  GST_PLUGIN_DEPENDENCY_FLAG_FILE_NAME_IS_SUFFIX       => (1 +< 2),
  GST_PLUGIN_DEPENDENCY_FLAG_FILE_NAME_IS_PREFIX       => (1 +< 3),
  GST_PLUGIN_DEPENDENCY_FLAG_PATHS_ARE_RELATIVE_TO_EXE => (1 +< 4)
);

our enum GstPluginError is export <
  GST_PLUGIN_ERROR_MODULE
  GST_PLUGIN_ERROR_DEPENDENCIES
  GST_PLUGIN_ERROR_NAME_MISMATCH
>;

our enum GstPluginFlags is export (
  GST_PLUGIN_FLAG_CACHED      => (GST_OBJECT_FLAG_LAST +< 0),
  GST_PLUGIN_FLAG_BLACKLISTED => (GST_OBJECT_FLAG_LAST +< 1)
);

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

our enum GstSeekFlags is export (
  GST_SEEK_FLAG_NONE                        => 0,
  GST_SEEK_FLAG_FLUSH                       => 1,
  GST_SEEK_FLAG_ACCURATE                    => (1 +< 1),
  GST_SEEK_FLAG_KEY_UNIT                    => (1 +< 2),
  GST_SEEK_FLAG_SEGMENT                     => (1 +< 3),
  GST_SEEK_FLAG_TRICKMODE                   => (1 +< 4),
  GST_SEEK_FLAG_SKIP                        => (1 +< 4),
  GST_SEEK_FLAG_SNAP_BEFORE                 => (1 +< 5),
  GST_SEEK_FLAG_SNAP_AFTER                  => (1 +< 6),
  GST_SEEK_FLAG_SNAP_NEAREST                => (1 +< 5) +| (1 +< 6),
  GST_SEEK_FLAG_TRICKMODE_KEY_UNITS         => (1 +< 7),
  GST_SEEK_FLAG_TRICKMODE_NO_AUDIO          => (1 +< 8),
  GST_SEEK_FLAG_TRICKMODE_FORWARD_PREDICTED => (1 +< 9),
);

our enum GstSegmentFlags is export (
  GST_SEGMENT_FLAG_NONE                        => GST_SEEK_FLAG_NONE.Int,
  GST_SEGMENT_FLAG_RESET                       => GST_SEEK_FLAG_FLUSH.Int,
  GST_SEGMENT_FLAG_TRICKMODE                   => GST_SEEK_FLAG_TRICKMODE.Int,
  GST_SEGMENT_FLAG_SKIP                        => GST_SEEK_FLAG_TRICKMODE.Int,
  GST_SEGMENT_FLAG_SEGMENT                     => GST_SEEK_FLAG_SEGMENT.Int,
  GST_SEGMENT_FLAG_TRICKMODE_KEY_UNITS         => GST_SEEK_FLAG_TRICKMODE_KEY_UNITS.Int,
  GST_SEGMENT_FLAG_TRICKMODE_FORWARD_PREDICTED => GST_SEEK_FLAG_TRICKMODE_FORWARD_PREDICTED.Int,
  GST_SEGMENT_FLAG_TRICKMODE_NO_AUDIO          => GST_SEEK_FLAG_TRICKMODE_NO_AUDIO.Int
);

our enum GstSeekType is export (
  GST_SEEK_TYPE_NONE => 0,
  GST_SEEK_TYPE_SET  => 1,
  GST_SEEK_TYPE_END  => 2,
);

our enum GstStackTraceFlags is export (
  GST_STACK_TRACE_SHOW_FULL =>  1 +< 0,
);

our enum GstState is export (
  GST_STATE_VOID_PENDING =>  0,
  GST_STATE_NULL         =>  1,
  GST_STATE_READY        =>  2,
  GST_STATE_PAUSED       =>  3,
  GST_STATE_PLAYING      =>  4,
);

our enum GstStateChange is export (
  GST_STATE_CHANGE_NULL_TO_READY      => (GST_STATE_NULL.Int    +< 3) +| GST_STATE_READY.Int,
  GST_STATE_CHANGE_READY_TO_PAUSED    => (GST_STATE_READY.Int   +< 3) +| GST_STATE_PAUSED.Int,
  GST_STATE_CHANGE_PAUSED_TO_PLAYING  => (GST_STATE_PAUSED.Int  +< 3) +| GST_STATE_PLAYING.Int,
  GST_STATE_CHANGE_PLAYING_TO_PAUSED  => (GST_STATE_PLAYING.Int +< 3) +| GST_STATE_PAUSED.Int,
  GST_STATE_CHANGE_PAUSED_TO_READY    => (GST_STATE_PAUSED.Int  +< 3) +| GST_STATE_READY.Int,
  GST_STATE_CHANGE_READY_TO_NULL      => (GST_STATE_READY.Int   +< 3) +| GST_STATE_NULL.Int,
  GST_STATE_CHANGE_NULL_TO_NULL       => (GST_STATE_NULL.Int    +< 3) +| GST_STATE_NULL.Int,
  GST_STATE_CHANGE_READY_TO_READY     => (GST_STATE_READY.Int   +< 3) +| GST_STATE_READY.Int,
  GST_STATE_CHANGE_PAUSED_TO_PAUSED   => (GST_STATE_PAUSED.Int  +< 3) +| GST_STATE_PAUSED.Int,
  GST_STATE_CHANGE_PLAYING_TO_PLAYING => (GST_STATE_PLAYING.Int +< 3) +| GST_STATE_PLAYING.Int
);


our enum GstStateChangeReturn is export (
  GST_STATE_CHANGE_FAILURE    => 0,
  GST_STATE_CHANGE_SUCCESS    => 1,
  GST_STATE_CHANGE_ASYNC      => 2,
  GST_STATE_CHANGE_NO_PREROLL => 3,
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
  GST_STREAM_STATUS_TYPE_CREATE  => 0,
  GST_STREAM_STATUS_TYPE_ENTER   => 1,
  GST_STREAM_STATUS_TYPE_LEAVE   => 2,
  GST_STREAM_STATUS_TYPE_DESTROY => 3,
  GST_STREAM_STATUS_TYPE_START   => 8,
  GST_STREAM_STATUS_TYPE_PAUSE   => 9,
  GST_STREAM_STATUS_TYPE_STOP    => 10,
);

our enum GstStreamType is export (
  GST_STREAM_TYPE_UNKNOWN   => 1 +< 0,
  GST_STREAM_TYPE_AUDIO     => 1 +< 1,
  GST_STREAM_TYPE_VIDEO     => 1 +< 2,
  GST_STREAM_TYPE_CONTAINER => 1 +< 3,
  GST_STREAM_TYPE_TEXT      => 1 +< 4,
);

our enum GstStructureChangeType is export (
  GST_STRUCTURE_CHANGE_TYPE_PAD_LINK   => 0,
  GST_STRUCTURE_CHANGE_TYPE_PAD_UNLINK => 1,
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
  GST_TOC_SCOPE_GLOBAL  => 1,
  GST_TOC_SCOPE_CURRENT => 2,
);

our enum GstTracerValueScope is export <
  GST_TRACER_VALUE_SCOPE_PROCESS
  GST_TRACER_VALUE_SCOPE_THREAD
  GST_TRACER_VALUE_SCOPE_ELEMENT
  GST_TRACER_VALUE_SCOPE_PAD
>;

our enum GstTypeFindProbability is export (
  GST_TYPE_FIND_NONE           => 0,
  GST_TYPE_FIND_MINIMUM        => 1,
  GST_TYPE_FIND_POSSIBLE       => 50,
  GST_TYPE_FIND_LIKELY         => 80,
  GST_TYPE_FIND_NEARLY_CERTAIN => 99,
  GST_TYPE_FIND_MAXIMUM        => 100,
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
  has Str               $.name;
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
  has guint            $.target_state;    # GstState
  has guint            $.current_state;   # GstState
  has guint            $.next_state;      # GstState
  has guint            $.pending_state;   # GstState
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

  has gpointer         $!gst_reserved0;
  has gpointer         $!gst_reserved1;
  has gpointer         $!gst_reserved2;
  has gpointer         $!gst_reserved3;
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

# Modification is currently NYI.
class GstFormatDefinition is repr<CStruct>     does GTK::Roles::Pointers is export {
  has guint  $.value; # GstFormat
  has Str    $.nick;
  has Str    $.description;
  has GQuark $.quark;
}

class GstPluginDesc       is repr<CStruct>     does GTK::Roles::Pointers is export {
  has gint      $.major_version;
  has gint      $.minor_version;
  has Str       $.name;
  has Str       $.description;
  has gpointer  $.plugin_init; # GstPluginInitFunc
  has Str       $.version;
  has Str       $.license;
  has Str       $.source;
  has Str       $.package;
  has Str       $.origin;
  has Str       $.release_datetime;

  # private
  has gpointer  $!gst_reserved0;
  has gpointer  $!gst_reserved1;
  has gpointer  $!gst_reserved2;
  has gpointer  $!gst_reserved3;
};
