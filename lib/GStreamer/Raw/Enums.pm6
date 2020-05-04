use v6.c;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;

unit package GStreamer::Raw::Enums;

# CORE

constant GstMiniObjectFlags is export := guint;
our enum GstMiniObjectFlagsEnum is export (
  GST_MINI_OBJECT_FLAG_LOCKABLE      => 1,
  GST_MINI_OBJECT_FLAG_LOCK_READONLY => (1 +< 1),
  GST_MINI_OBJECT_FLAG_MAY_BE_LEAKED => (1 +< 2),
  # Padding
  GST_MINI_OBJECT_FLAG_LAST          => (1 +< 4)
);

constant GstBufferCopyFlags is export := guint32;
our enum GstBufferCopyFlagsEnum is export (
  GST_BUFFER_COPY_NONE           => 0,
  GST_BUFFER_COPY_FLAGS          => 1,
  GST_BUFFER_COPY_TIMESTAMPS     => (1 +< 1),
  GST_BUFFER_COPY_META           => (1 +< 2),
  GST_BUFFER_COPY_MEMORY         => (1 +< 3),
  GST_BUFFER_COPY_MERGE          => (1 +< 4),
  GST_BUFFER_COPY_DEEP           => (1 +< 5)
);

constant GstBufferFlags is export := guint32;
our enum GstBufferFlagsEnum is export (
  GST_BUFFER_FLAG_LIVE          => (GST_MINI_OBJECT_FLAG_LAST +< 0),
  GST_BUFFER_FLAG_DECODE_ONLY   => (GST_MINI_OBJECT_FLAG_LAST +< 1),
  GST_BUFFER_FLAG_DISCONT       => (GST_MINI_OBJECT_FLAG_LAST +< 2),
  GST_BUFFER_FLAG_RESYNC        => (GST_MINI_OBJECT_FLAG_LAST +< 3),
  GST_BUFFER_FLAG_CORRUPTED     => (GST_MINI_OBJECT_FLAG_LAST +< 4),
  GST_BUFFER_FLAG_MARKER        => (GST_MINI_OBJECT_FLAG_LAST +< 5),
  GST_BUFFER_FLAG_HEADER        => (GST_MINI_OBJECT_FLAG_LAST +< 6),
  GST_BUFFER_FLAG_GAP           => (GST_MINI_OBJECT_FLAG_LAST +< 7),
  GST_BUFFER_FLAG_DROPPABLE     => (GST_MINI_OBJECT_FLAG_LAST +< 8),
  GST_BUFFER_FLAG_DELTA_UNIT    => (GST_MINI_OBJECT_FLAG_LAST +< 9),
  GST_BUFFER_FLAG_TAG_MEMORY    => (GST_MINI_OBJECT_FLAG_LAST +< 10),
  GST_BUFFER_FLAG_SYNC_AFTER    => (GST_MINI_OBJECT_FLAG_LAST +< 11),
  GST_BUFFER_FLAG_NON_DROPPABLE => (GST_MINI_OBJECT_FLAG_LAST +< 12),

  GST_BUFFER_FLAG_LAST          => (GST_MINI_OBJECT_FLAG_LAST +< 16)
);

constant GstBufferingMode is export := guint;
our enum GstBufferingModeEnum is export <
  GST_BUFFERING_STREAM
  GST_BUFFERING_DOWNLOAD
  GST_BUFFERING_TIMESHIFT
  GST_BUFFERING_LIVE
>;

constant GstBufferPoolAcquireFlags is export := guint;
our enum GstBufferPoolAcquireFlagsEnum is export (
  GST_BUFFER_POOL_ACQUIRE_FLAG_NONE     => 0,
  GST_BUFFER_POOL_ACQUIRE_FLAG_KEY_UNIT => 1,
  GST_BUFFER_POOL_ACQUIRE_FLAG_DONTWAIT => (1 +< 1),
  GST_BUFFER_POOL_ACQUIRE_FLAG_DISCONT  => (1 +< 2),
  GST_BUFFER_POOL_ACQUIRE_FLAG_LAST     => (1 +< 16),
);

constant GstBusSyncReply is export := guint;
our enum GstBusSyncReplyEnum is export (
  GST_BUS_DROP  => 0,
  GST_BUS_PASS  => 1,
  GST_BUS_ASYNC => 2,
);

constant GstCapsIntersectMode is export := guint;
our enum GstCapsIntersectModeEnum is export (
  GST_CAPS_INTERSECT_ZIG_ZAG => 0,
  GST_CAPS_INTERSECT_FIRST   => 1,
);

constant GstClockEntryType is export := guint;
our enum GstClockEntryTypeEnum is export <
  GST_CLOCK_ENTRY_SINGLE
  GST_CLOCK_ENTRY_PERIODIC
>;

constant GstClockFlags is export := guint;
our enum GstClockFlagsEnum is export (
  GST_CLOCK_FLAG_CAN_DO_SINGLE_SYNC     => (GST_OBJECT_FLAG_LAST +< 0),
  GST_CLOCK_FLAG_CAN_DO_SINGLE_ASYNC    => (GST_OBJECT_FLAG_LAST +< 1),
  GST_CLOCK_FLAG_CAN_DO_PERIODIC_SYNC   => (GST_OBJECT_FLAG_LAST +< 2),
  GST_CLOCK_FLAG_CAN_DO_PERIODIC_ASYNC  => (GST_OBJECT_FLAG_LAST +< 3),
  GST_CLOCK_FLAG_CAN_SET_RESOLUTION     => (GST_OBJECT_FLAG_LAST +< 4),
  GST_CLOCK_FLAG_CAN_SET_MASTER         => (GST_OBJECT_FLAG_LAST +< 5),
  GST_CLOCK_FLAG_NEEDS_STARTUP_SYNC     => (GST_OBJECT_FLAG_LAST +< 6),
  GST_CLOCK_FLAG_LAST                   => (GST_OBJECT_FLAG_LAST +< 8)
);

constant GstClockReturn is export := guint;
our enum GstClockReturnEnum is export (
  GST_CLOCK_OK          => 0,
  GST_CLOCK_EARLY       => 1,
  GST_CLOCK_UNSCHEDULED => 2,
  GST_CLOCK_BUSY        => 3,
  GST_CLOCK_BADTIME     => 4,
  GST_CLOCK_ERROR       => 5,
  GST_CLOCK_UNSUPPORTED => 6,
  GST_CLOCK_DONE        => 7,
);

constant GstClockType is export := guint;
our enum GstClockTypeEnum is export (
  GST_CLOCK_TYPE_REALTIME  => 0,
  GST_CLOCK_TYPE_MONOTONIC => 1,
  GST_CLOCK_TYPE_OTHER     => 2,
);

constant GstCollectPadsStateFlags is export := guint;
our enum GstCollectPadsStateFlagsEnum is export (
  GST_COLLECT_PADS_STATE_EOS         => 1 +< 0,
  GST_COLLECT_PADS_STATE_FLUSHING    => 1 +< 1,
  GST_COLLECT_PADS_STATE_NEW_SEGMENT => 1 +< 2,
  GST_COLLECT_PADS_STATE_WAITING     => 1 +< 3,
  GST_COLLECT_PADS_STATE_LOCKED      => 1 +< 4,
);

constant GstCoreError is export := guint;
our enum GstCoreErrorEnum is export (
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

constant GstDateTimeFields is export := guint;
our enum GstDateTimeFieldsEnum is export (
  GST_DATE_TIME_FIELDS_INVALID => 0,
  'GST_DATE_TIME_FIELDS_Y',       # have year
  'GST_DATE_TIME_FIELDS_YM',      # have year and month
  'GST_DATE_TIME_FIELDS_YMD',     # have year, month and day
  'GST_DATE_TIME_FIELDS_YMD_HM',
  'GST_DATE_TIME_FIELDS_YMD_HMS'
);

constant GstDebugColorFlags is export := guint;
our enum GstDebugColorFlagsEnum is export (
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

constant GstDebugColorMode is export := guint;
our enum GstDebugColorModeEnum is export (
  GST_DEBUG_COLOR_MODE_OFF  =>  0,
  GST_DEBUG_COLOR_MODE_ON   =>  1,
  GST_DEBUG_COLOR_MODE_UNIX =>  2,
);

constant GstDebugLevel is export := guint;
our enum GstDebugLevelEnum is export (
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

constant GstElementFlags is export := guint;
our enum GstElementFlagsEnum is export (
  GST_ELEMENT_FLAG_LOCKED_STATE   => (GST_OBJECT_FLAG_LAST +< 0),
  GST_ELEMENT_FLAG_SINK           => (GST_OBJECT_FLAG_LAST +< 1),
  GST_ELEMENT_FLAG_SOURCE         => (GST_OBJECT_FLAG_LAST +< 2),
  GST_ELEMENT_FLAG_PROVIDE_CLOCK  => (GST_OBJECT_FLAG_LAST +< 3),
  GST_ELEMENT_FLAG_REQUIRE_CLOCK  => (GST_OBJECT_FLAG_LAST +< 4),
  GST_ELEMENT_FLAG_INDEXABLE      => (GST_OBJECT_FLAG_LAST +< 5),
  GST_ELEMENT_FLAG_LAST           => (GST_OBJECT_FLAG_LAST +< 10)
);

constant GstEventTypeFlags is export := guint;
our enum GstEventTypeFlagsEnum is export (
  GST_EVENT_TYPE_UPSTREAM     =>  1 +< 0,
  GST_EVENT_TYPE_DOWNSTREAM   =>  1 +< 1,
  GST_EVENT_TYPE_SERIALIZED   =>  1 +< 2,
  GST_EVENT_TYPE_STICKY       =>  1 +< 3,
  GST_EVENT_TYPE_STICKY_MULTI =>  1 +< 4,
);

constant GST_EVENT_TYPE_BOTH is export = GST_EVENT_TYPE_UPSTREAM +| GST_EVENT_TYPE_DOWNSTREAM;

constant GstEventType is export := guint;
our enum GstEventTypeEnum is export (
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

our constant GstFlowReturn is export := gint;
our enum GstFlowReturnEnum is export (
  GST_FLOW_CUSTOM_SUCCESS_2 =>  102,
  GST_FLOW_CUSTOM_SUCCESS_1 =>  101,
  GST_FLOW_CUSTOM_SUCCESS   =>  100,
  GST_FLOW_OK		            =>    0,
  GST_FLOW_NOT_LINKED       =>   -1,
  GST_FLOW_FLUSHING         =>   -2,
  GST_FLOW_EOS              =>   -3,
  GST_FLOW_NOT_NEGOTIATED   =>   -4,
  GST_FLOW_ERROR	          =>   -5,
  GST_FLOW_NOT_SUPPORTED    =>   -6,
  GST_FLOW_CUSTOM_ERROR     => -100,
  GST_FLOW_CUSTOM_ERROR_1   => -101,
  GST_FLOW_CUSTOM_ERROR_2   => -102
);

constant GstFormat is export := guint;
our enum GstFormatEnum is export (
  GST_FORMAT_UNDEFINED => 0,
  GST_FORMAT_DEFAULT   => 1,
  GST_FORMAT_BYTES     => 2,
  GST_FORMAT_TIME      => 3,
  GST_FORMAT_BUFFERS   => 4,
  GST_FORMAT_PERCENT   => 5,
);

constant GstGLUploadReturn is export := gint32;
our enum GstGLUploadReturnEnum is export (
    GST_GL_UPLOAD_DONE                =>     1,
    GST_GL_UPLOAD_ERROR               =>    -1,
    GST_GL_UPLOAD_UNSUPPORTED         =>    -2,
    GST_GL_UPLOAD_RECONFIGURE         =>    -3,
    GST_GL_UPLOAD_UNSHARED_GL_CONTEXT =>  -100,
);

constant GstInterpolationMode is export := guint;
our enum GstInterpolationModeEnum is export <
  GST_INTERPOLATION_MODE_NONE
  GST_INTERPOLATION_MODE_LINEAR
  GST_INTERPOLATION_MODE_CUBIC
  GST_INTERPOLATION_MODE_CUBIC_MONOTONIC
>;

constant GstIteratorItem is export := guint;
our enum GstIteratorItemEnum is export (
  GST_ITERATOR_ITEM_SKIP =>  0,
  GST_ITERATOR_ITEM_PASS =>  1,
  GST_ITERATOR_ITEM_END  =>  2,
);

constant GstIteratorResult is export := guint;
our enum GstIteratorResultEnum is export (
  GST_ITERATOR_DONE   =>  0,
  GST_ITERATOR_OK     =>  1,
  GST_ITERATOR_RESYNC =>  2,
  GST_ITERATOR_ERROR  =>  3,
);

constant GstLFOWaveform is export := guint;
our enum GstLFOWaveformEnum is export <
  GST_LFO_WAVEFORM_SINE
  GST_LFO_WAVEFORM_SQUARE
  GST_LFO_WAVEFORM_SAW
  GST_LFO_WAVEFORM_REVERSE_SAW
  GST_LFO_WAVEFORM_TRIANGLE
>;

constant GstLibraryError is export := guint;
our enum GstLibraryErrorEnum is export (
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

constant GstMapFlags is export := guint32;
our enum GstMapFlagsEnum is export (
  GST_MAP_READ      => GST_LOCK_FLAG_READ,
  GST_MAP_WRITE     => GST_LOCK_FLAG_WRITE,
  GST_MAP_FLAG_LAST => (1 +< 16)
);

constant GstMemoryFlags is export := guint32;
our enum GstMemoryFlagsEnum is export (
  GST_MEMORY_FLAG_READONLY              => GST_MINI_OBJECT_FLAG_LOCK_READONLY,
  GST_MEMORY_FLAG_NO_SHARE              => (GST_MINI_OBJECT_FLAG_LAST +< 0),
  GST_MEMORY_FLAG_ZERO_PREFIXED         => (GST_MINI_OBJECT_FLAG_LAST +< 1),
  GST_MEMORY_FLAG_ZERO_PADDED           => (GST_MINI_OBJECT_FLAG_LAST +< 2),
  GST_MEMORY_FLAG_PHYSICALLY_CONTIGUOUS => (GST_MINI_OBJECT_FLAG_LAST +< 3),
  GST_MEMORY_FLAG_NOT_MAPPABLE          => (GST_MINI_OBJECT_FLAG_LAST +< 4),
  GST_MEMORY_FLAG_LAST                  => (GST_MINI_OBJECT_FLAG_LAST +< 16)
);

constant GstMetaFlags is export := guint32;
our enum GstMetaFlagsEnum is export (
  GST_META_FLAG_NONE        => 0,
  GST_META_FLAG_READONLY    => (1 +< 0),
  GST_META_FLAG_POOLED      => (1 +< 1),
  GST_META_FLAG_LOCKED      => (1 +< 2),
  GST_META_FLAG_LAST        => (1 +< 16)
);

constant GstMIKEYType is export := gint32;
our enum GstMIKEYTypeEnum is export (
  GST_MIKEY_TYPE_INVALID    => -1,
  GST_MIKEY_TYPE_PSK_INIT   =>  0,
  GST_MIKEY_TYPE_PSK_VERIFY =>  1,
  GST_MIKEY_TYPE_PK_INIT    =>  2,
  GST_MIKEY_TYPE_PK_VERIFY  =>  3,
  GST_MIKEY_TYPE_DH_INIT    =>  4,
  GST_MIKEY_TYPE_DH_RESP    =>  5,
  GST_MIKEY_TYPE_ERROR      =>  6,
);

# C wants gint, but Perl might get confused. At the time of this writing,
# there are issues with NativeCall and unsigned integers. For now, will
# treat as UINT32, and will adjust as needed.
constant GstMessageType is export := guint;
our enum GstMessageTypeEnum is export (
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

constant GstPadDirection is export := guint;
our enum GstPadDirectionEnum is export <
  GST_PAD_UNKNOWN
  GST_PAD_SRC
  GST_PAD_SINK
>;

constant GstPadLinkCheck is export := guint;
our enum GstPadLinkCheckEnum is export (
  GST_PAD_LINK_CHECK_NOTHING        => 0,
  GST_PAD_LINK_CHECK_HIERARCHY      => 1,
  GST_PAD_LINK_CHECK_TEMPLATE_CAPS  => 1 +< 1,
  GST_PAD_LINK_CHECK_CAPS           => 1 +< 2,
  GST_PAD_LINK_CHECK_NO_RECONFIGURE => 1 +< 3,
  GST_PAD_LINK_CHECK_DEFAULT        => 1 +| (1 +< 2)
);

constant GstPadLinkReturn is export := gint;
our enum GstPadLinkReturnEnum is export (
  GST_PAD_LINK_OK               =>  0,
  GST_PAD_LINK_WRONG_HIERARCHY  => -1,
  GST_PAD_LINK_WAS_LINKED       => -2,
  GST_PAD_LINK_WRONG_DIRECTION  => -3,
  GST_PAD_LINK_NOFORMAT         => -4,
  GST_PAD_LINK_NOSCHED          => -5,
  GST_PAD_LINK_REFUSED          => -6
);

constant GstPadMode is export := guint;
our enum GstPadModeEnum is export <
  GST_PAD_MODE_NONE
  GST_PAD_MODE_PUSH
  GST_PAD_MODE_PULL
>;

constant GstPadPresence is export := guint;
our enum GstPadPresenceEnum is export <
  GST_PAD_ALWAYS
  GST_PAD_SOMETIMES
  GST_PAD_REQUEST
>;

constant GstPadProbeReturn is export := guint;
our enum GstPadProbeReturnEnum is export <
  GST_PAD_PROBE_DROP
  GST_PAD_PROBE_OK
  GST_PAD_PROBE_REMOVE
  GST_PAD_PROBE_PASS
  GST_PAD_PROBE_HANDLED
>;

constant GstPadProbeType is export := guint;
our enum GstPadProbeTypeEnum is export (
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

constant GstParseError is export := guint;
our enum GstParseErrorEnum is export <
  GST_PARSE_ERROR_SYNTAX
  GST_PARSE_ERROR_NO_SUCH_ELEMENT
  GST_PARSE_ERROR_NO_SUCH_PROPERTY
  GST_PARSE_ERROR_LINK
  GST_PARSE_ERROR_COULD_NOT_SET_PROPERTY
  GST_PARSE_ERROR_EMPTY_BIN
  GST_PARSE_ERROR_EMPTY
  GST_PARSE_ERROR_DELAYED_LINK
>;

constant GstParseFlags is export := guint;
our enum GstParseFlagsEnum is export (
  GST_PARSE_FLAG_NONE                   => 0,
  GST_PARSE_FLAG_FATAL_ERRORS           => 1,
  GST_PARSE_FLAG_NO_SINGLE_ELEMENT_BINS => (1 +< 1),
  GST_PARSE_FLAG_PLACE_IN_BIN           => (1 +< 2)
);

constant GstPluginDependencyFlags is export := guint;
our enum GstPluginDependencyFlagsEnum is export (
  GST_PLUGIN_DEPENDENCY_FLAG_NONE                      => 0,
  GST_PLUGIN_DEPENDENCY_FLAG_RECURSE                   => 1,
  GST_PLUGIN_DEPENDENCY_FLAG_PATHS_ARE_DEFAULT_ONLY    => (1 +< 1),
  GST_PLUGIN_DEPENDENCY_FLAG_FILE_NAME_IS_SUFFIX       => (1 +< 2),
  GST_PLUGIN_DEPENDENCY_FLAG_FILE_NAME_IS_PREFIX       => (1 +< 3),
  GST_PLUGIN_DEPENDENCY_FLAG_PATHS_ARE_RELATIVE_TO_EXE => (1 +< 4)
);

constant GstPluginError is export := guint;
our enum GstPluginErrorEnum is export <
  GST_PLUGIN_ERROR_MODULE
  GST_PLUGIN_ERROR_DEPENDENCIES
  GST_PLUGIN_ERROR_NAME_MISMATCH
>;

constant GstPluginFlags is export := guint;
our enum GstPluginFlagsEnum is export (
  GST_PLUGIN_FLAG_CACHED      => (GST_OBJECT_FLAG_LAST +< 0),
  GST_PLUGIN_FLAG_BLACKLISTED => (GST_OBJECT_FLAG_LAST +< 1)
);

constant GstProgressType is export := guint;
our enum GstProgressTypeEnum is export (
  GST_PROGRESS_TYPE_START    =>  0,
  GST_PROGRESS_TYPE_CONTINUE =>  1,
  GST_PROGRESS_TYPE_COMPLETE =>  2,
  GST_PROGRESS_TYPE_CANCELED =>  3,
  GST_PROGRESS_TYPE_ERROR    =>  4,
);

constant GstPromiseResult is export := guint;
our enum GstPromiseResultEnum is export <
  GST_PROMISE_RESULT_PENDING
  GST_PROMISE_RESULT_INTERRUPTED
  GST_PROMISE_RESULT_REPLIED
  GST_PROMISE_RESULT_EXPIRED
>;

constant GstQOSType is export := guint;
our enum GstQOSTypeEnum is export (
  GST_QOS_TYPE_OVERFLOW  =>  0,
  GST_QOS_TYPE_UNDERFLOW =>  1,
  GST_QOS_TYPE_THROTTLE  =>  2,
);

constant GstQueryTypeFlags is export := guint;
our enum GstQueryTypeFlagsEnum is export (
  GST_QUERY_TYPE_UPSTREAM   =>  1 +< 0,
  GST_QUERY_TYPE_DOWNSTREAM =>  1 +< 1,
  GST_QUERY_TYPE_SERIALIZED =>  1 +< 2,
);

constant GST_QUERY_TYPE_BOTH is export =
  GST_QUERY_TYPE_UPSTREAM +| GST_QUERY_TYPE_DOWNSTREAM;

constant GstQueryType is export := guint;
our enum GstQueryTypeEnum is export (
  GST_QUERY_UNKNOWN      =>   (0 +< 8),
  GST_QUERY_POSITION     =>  (10 +< 8) +| GST_QUERY_TYPE_BOTH,
  GST_QUERY_DURATION     =>  (20 +< 8) +| GST_QUERY_TYPE_BOTH,
  GST_QUERY_LATENCY      =>  (30 +< 8) +| GST_QUERY_TYPE_BOTH,
  GST_QUERY_JITTER       =>  (40 +< 8) +| GST_QUERY_TYPE_BOTH,
  GST_QUERY_RATE         =>  (50 +< 8) +| GST_QUERY_TYPE_BOTH,
  GST_QUERY_SEEKING      =>  (60 +< 8) +| GST_QUERY_TYPE_BOTH,
  GST_QUERY_SEGMENT      =>  (70 +< 8) +| GST_QUERY_TYPE_BOTH,
  GST_QUERY_CONVERT      =>  (80 +< 8) +| GST_QUERY_TYPE_BOTH,
  GST_QUERY_FORMATS      =>  (90 +< 8) +| GST_QUERY_TYPE_BOTH,
  GST_QUERY_BUFFERING    => (110 +< 8) +| GST_QUERY_TYPE_BOTH,
  GST_QUERY_CUSTOM       => (120 +< 8) +| GST_QUERY_TYPE_BOTH,
  GST_QUERY_URI          => (130 +< 8) +| GST_QUERY_TYPE_BOTH,
  GST_QUERY_ALLOCATION   => (140 +< 8) +| GST_QUERY_TYPE_DOWNSTREAM +| GST_QUERY_TYPE_SERIALIZED,
  GST_QUERY_SCHEDULING   => (150 +< 8) +| GST_QUERY_TYPE_UPSTREAM,
  GST_QUERY_ACCEPT_CAPS  => (160 +< 8) +| GST_QUERY_TYPE_BOTH,
  GST_QUERY_CAPS         => (170 +< 8) +| GST_QUERY_TYPE_BOTH,
  GST_QUERY_DRAIN        => (180 +< 8) +| GST_QUERY_TYPE_DOWNSTREAM +| GST_QUERY_TYPE_SERIALIZED,
  GST_QUERY_CONTEXT      => (190 +< 8) +| GST_QUERY_TYPE_BOTH,
  GST_QUERY_BITRATE      => (200 +< 8) +| GST_QUERY_TYPE_DOWNSTREAM,
);

constant GstRank is export := guint;
our enum GstRankEnum is export (
  GST_RANK_NONE      =>  0,
  GST_RANK_MARGINAL  =>  64,
  GST_RANK_SECONDARY =>  128,
  GST_RANK_PRIMARY   =>  256,
);

constant GstResourceError is export := guint;
our enum GstResourceErrorEnum is export (
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

constant GstRTCPSDESType is export := gint32;
our enum GstRTCPSDESTypeEnum is export (
    GST_RTCP_SDES_INVALID =>  -1,
    GST_RTCP_SDES_END     =>   0,
    GST_RTCP_SDES_CNAME   =>   1,
    GST_RTCP_SDES_NAME    =>   2,
    GST_RTCP_SDES_EMAIL   =>   3,
    GST_RTCP_SDES_PHONE   =>   4,
    GST_RTCP_SDES_LOC     =>   5,
    GST_RTCP_SDES_TOOL    =>   6,
    GST_RTCP_SDES_NOTE    =>   7,
    GST_RTCP_SDES_PRIV    =>   8,
);

constant GstRTCPXRType is export := gint32;
our enum GstRTCPXRTypeEnum is export (
    GST_RTCP_XR_TYPE_INVALID      =>  -1,
    GST_RTCP_XR_TYPE_LRLE         =>  1,
    GST_RTCP_XR_TYPE_DRLE         =>  2,
    GST_RTCP_XR_TYPE_PRT          =>  3,
    GST_RTCP_XR_TYPE_RRT          =>  4,
    GST_RTCP_XR_TYPE_DLRR         =>  5,
    GST_RTCP_XR_TYPE_SSUMM        =>  6,
    GST_RTCP_XR_TYPE_VOIP_METRICS =>  7,
);

constant GstRTSPResult is export := gint32;
our enum GstRTSPResultEnum is export (
    GST_RTSP_OK          =>   0,
    GST_RTSP_ERROR       =>  -1,
    GST_RTSP_EINVAL      =>  -2,
    GST_RTSP_EINTR       =>  -3,
    GST_RTSP_ENOMEM      =>  -4,
    GST_RTSP_ERESOLV     =>  -5,
    GST_RTSP_ENOTIMPL    =>  -6,
    GST_RTSP_ESYS        =>  -7,
    GST_RTSP_EPARSE      =>  -8,
    GST_RTSP_EWSASTART   =>  -9,
    GST_RTSP_EWSAVERSION =>  -10,
    GST_RTSP_EEOF        =>  -11,
    GST_RTSP_ENET        =>  -12,
    GST_RTSP_ENOTIP      =>  -13,
    GST_RTSP_ETIMEOUT    =>  -14,
    GST_RTSP_ETGET       =>  -15,
    GST_RTSP_ETPOST      =>  -16,
    GST_RTSP_ELAST       =>  -17,
);

constant GstSDPResult is export := gint32;
our enum GstSDPResultEnum is export (
    GST_SDP_OK =>  0,
    GST_SDP_EINVAL =>  -1,
);

constant GstSearchMode is export := guint;
our enum GstSearchModeEnum is export (
  GST_SEARCH_MODE_EXACT =>  0,
  'GST_SEARCH_MODE_BEFORE',
  'GST_SEARCH_MODE_AFTER'
);

constant GstSeekFlags is export := guint;
our enum GstSeekFlagsEnum is export (
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

constant GstSegmentFlags is export := guint;
our enum GstSegmentFlagsEnum is export (
  GST_SEGMENT_FLAG_NONE                        => GST_SEEK_FLAG_NONE.Int,
  GST_SEGMENT_FLAG_RESET                       => GST_SEEK_FLAG_FLUSH.Int,
  GST_SEGMENT_FLAG_TRICKMODE                   => GST_SEEK_FLAG_TRICKMODE.Int,
  GST_SEGMENT_FLAG_SKIP                        => GST_SEEK_FLAG_TRICKMODE.Int,
  GST_SEGMENT_FLAG_SEGMENT                     => GST_SEEK_FLAG_SEGMENT.Int,
  GST_SEGMENT_FLAG_TRICKMODE_KEY_UNITS         => GST_SEEK_FLAG_TRICKMODE_KEY_UNITS.Int,
  GST_SEGMENT_FLAG_TRICKMODE_FORWARD_PREDICTED => GST_SEEK_FLAG_TRICKMODE_FORWARD_PREDICTED.Int,
  GST_SEGMENT_FLAG_TRICKMODE_NO_AUDIO          => GST_SEEK_FLAG_TRICKMODE_NO_AUDIO.Int
);

constant GstSeekType is export := guint;
our enum GstSeekTypeEnum is export (
  GST_SEEK_TYPE_NONE => 0,
  GST_SEEK_TYPE_SET  => 1,
  GST_SEEK_TYPE_END  => 2,
);

constant GstSchedulingFlags is export := guint;
our enum GstSchedulingFlagsEnum is export (
  GST_SCHEDULING_FLAG_SEEKABLE          => 1,
  GST_SCHEDULING_FLAG_SEQUENTIAL        => (1 +< 1),
  GST_SCHEDULING_FLAG_BANDWIDTH_LIMITED => (1 +< 2)
);

constant GstStackTraceFlags is export := guint;
our enum GstStackTraceFlagsEnum is export (
  GST_STACK_TRACE_SHOW_FULL =>  1 +< 0,
);

constant GstState is export := guint;
our enum GstStateEnum is export (
  GST_STATE_VOID_PENDING =>  0,
  GST_STATE_NULL         =>  1,
  GST_STATE_READY        =>  2,
  GST_STATE_PAUSED       =>  3,
  GST_STATE_PLAYING      =>  4,
);

constant GstStateChange is export := guint;
our enum GstStateChangeEnum is export (
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

constant GstStateChangeReturn is export := guint;
our enum GstStateChangeReturnEnum is export (
  GST_STATE_CHANGE_FAILURE    => 0,
  GST_STATE_CHANGE_SUCCESS    => 1,
  GST_STATE_CHANGE_ASYNC      => 2,
  GST_STATE_CHANGE_NO_PREROLL => 3,
);

constant GstStreamError is export := guint;
our enum GstStreamErrorEnum is export (
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

constant GstStreamFlags is export := guint;
our enum GstStreamFlagsEnum is export (
  GST_STREAM_FLAG_NONE     => 0,
  GST_STREAM_FLAG_SPARSE   => 1,
  GST_STREAM_FLAG_SELECT   => (1 +< 1),
  GST_STREAM_FLAG_UNSELECT => (1 +< 2)
);

constant GstStreamStatusType is export := guint;
our enum GstStreamStatusTypeEnum is export (
  GST_STREAM_STATUS_TYPE_CREATE  => 0,
  GST_STREAM_STATUS_TYPE_ENTER   => 1,
  GST_STREAM_STATUS_TYPE_LEAVE   => 2,
  GST_STREAM_STATUS_TYPE_DESTROY => 3,
  GST_STREAM_STATUS_TYPE_START   => 8,
  GST_STREAM_STATUS_TYPE_PAUSE   => 9,
  GST_STREAM_STATUS_TYPE_STOP    => 10,
);

constant GstStreamType is export := guint;
our enum GstStreamTypeEnum is export (
  GST_STREAM_TYPE_UNKNOWN   => 1 +< 0,
  GST_STREAM_TYPE_AUDIO     => 1 +< 1,
  GST_STREAM_TYPE_VIDEO     => 1 +< 2,
  GST_STREAM_TYPE_CONTAINER => 1 +< 3,
  GST_STREAM_TYPE_TEXT      => 1 +< 4,
);

constant GstStructureChangeType is export := guint;
our enum GstStructureChangeTypeEnum is export (
  GST_STRUCTURE_CHANGE_TYPE_PAD_LINK   => 0,
  GST_STRUCTURE_CHANGE_TYPE_PAD_UNLINK => 1,
);

constant GstTagFlag is export := guint;
our enum GstTagFlagEnum is export <
  GST_TAG_FLAG_UNDEFINED
  GST_TAG_FLAG_META
  GST_TAG_FLAG_ENCODED
  GST_TAG_FLAG_DECODED
  GST_TAG_FLAG_COUNT
>;

constant GstTagImageType is export := gint32;
our enum GstTagImageTypeEnum is export (
    GST_TAG_IMAGE_TYPE_NONE =>  -1,
    GST_TAG_IMAGE_TYPE_UNDEFINED =>  0,
    'GST_TAG_IMAGE_TYPE_FRONT_COVER',
    'GST_TAG_IMAGE_TYPE_BACK_COVER',
    'GST_TAG_IMAGE_TYPE_LEAFLET_PAGE',
    'GST_TAG_IMAGE_TYPE_MEDIUM',
    'GST_TAG_IMAGE_TYPE_LEAD_ARTIST',
    'GST_TAG_IMAGE_TYPE_ARTIST',
    'GST_TAG_IMAGE_TYPE_CONDUCTOR',
    'GST_TAG_IMAGE_TYPE_BAND_ORCHESTRA',
    'GST_TAG_IMAGE_TYPE_COMPOSER',
    'GST_TAG_IMAGE_TYPE_LYRICIST',
    'GST_TAG_IMAGE_TYPE_RECORDING_LOCATION',
    'GST_TAG_IMAGE_TYPE_DURING_RECORDING',
    'GST_TAG_IMAGE_TYPE_DURING_PERFORMANCE',
    'GST_TAG_IMAGE_TYPE_VIDEO_CAPTURE',
    'GST_TAG_IMAGE_TYPE_FISH',
    'GST_TAG_IMAGE_TYPE_ILLUSTRATION',
    'GST_TAG_IMAGE_TYPE_BAND_ARTIST_LOGO',
    'GST_TAG_IMAGE_TYPE_PUBLISHER_STUDIO_LOGO'
);

constant GstTagMergeMode is export := guint;
our enum GstTagMergeModeEnum is export <
  GST_TAG_MERGE_UNDEFINED
  GST_TAG_MERGE_REPLACE_ALL
  GST_TAG_MERGE_REPLACE
  GST_TAG_MERGE_APPEND
  GST_TAG_MERGE_PREPEND
  GST_TAG_MERGE_KEEP
  GST_TAG_MERGE_KEEP_ALL
  GST_TAG_MERGE_COUNT
>;

constant GstTagScope is export := guint;
our enum GstTagScopeEnum is export <
  GST_TAG_SCOPE_STREAM
  GST_TAG_SCOPE_GLOBAL
>;

constant GstTaskState is export := guint;
our enum GstTaskStateEnum is export <
  GST_TASK_STARTED
  GST_TASK_STOPPED
  GST_TASK_PAUSED
>;

constant GstTocEntryType is export := gint32;
our enum GstTocEntryTypeEnum is export (
    GST_TOC_ENTRY_TYPE_ANGLE   =>  -3,
    GST_TOC_ENTRY_TYPE_VERSION =>  -2,
    GST_TOC_ENTRY_TYPE_EDITION =>  -1,
    GST_TOC_ENTRY_TYPE_INVALID =>   0,
    GST_TOC_ENTRY_TYPE_TITLE   =>   1,
    GST_TOC_ENTRY_TYPE_TRACK   =>   2,
    GST_TOC_ENTRY_TYPE_CHAPTER =>   3,
);

constant GstTocLoopType is export := guint;
our enum GstTocLoopTypeEnum is export (
  GST_TOC_LOOP_NONE =>  0,
  'GST_TOC_LOOP_FORWARD',
  'GST_TOC_LOOP_REVERSE',
  'GST_TOC_LOOP_PING_PONG'
);

constant GstTocScope is export := guint;
our enum GstTocScopeEnum is export (
  GST_TOC_SCOPE_GLOBAL  => 1,
  GST_TOC_SCOPE_CURRENT => 2,
);

constant GstTracerValueScope is export := guint;
our enum GstTracerValueScopeEnum is export <
  GST_TRACER_VALUE_SCOPE_PROCESS
  GST_TRACER_VALUE_SCOPE_THREAD
  GST_TRACER_VALUE_SCOPE_ELEMENT
  GST_TRACER_VALUE_SCOPE_PAD
>;

constant GstTypeFindProbability is export := guint;
our enum GstTypeFindProbabilityEnum is export (
  GST_TYPE_FIND_NONE           => 0,
  GST_TYPE_FIND_MINIMUM        => 1,
  GST_TYPE_FIND_POSSIBLE       => 50,
  GST_TYPE_FIND_LIKELY         => 80,
  GST_TYPE_FIND_NEARLY_CERTAIN => 99,
  GST_TYPE_FIND_MAXIMUM        => 100,
);

constant GstURIError is export := guint;
our enum GstURIErrorEnum is export <
  GST_URI_ERROR_UNSUPPORTED_PROTOCOL
  GST_URI_ERROR_BAD_URI
  GST_URI_ERROR_BAD_STATE
  GST_URI_ERROR_BAD_REFERENCE
>;

constant GstURIType is export := guint;
our enum GstURITypeEnum is export <
  GST_URI_UNKNOWN
  GST_URI_SINK
  GST_URI_SRC
>;

# VIDEO

constant GstColorBalanceType is export := guint32;
enum GstColorBalanceTypeEnum is export <
  GST_COLOR_BALANCE_HARDWARE
  GST_COLOR_BALANCE_SOFTWARE
>;

constant GstNavigationEventType is export := guint32;
our enum GstNavigationEventTypeEnum is export (
    GST_NAVIGATION_EVENT_INVALID              =>  0,
    GST_NAVIGATION_EVENT_KEY_PRESS            =>  1,
    GST_NAVIGATION_EVENT_KEY_RELEASE          =>  2,
    GST_NAVIGATION_EVENT_MOUSE_BUTTON_PRESS   =>  3,
    GST_NAVIGATION_EVENT_MOUSE_BUTTON_RELEASE =>  4,
    GST_NAVIGATION_EVENT_MOUSE_MOVE           =>  5,
    GST_NAVIGATION_EVENT_COMMAND              =>  6,
);

constant GstNavigationMessageType is export := guint32;
our enum GstNavigationMessageTypeEnum is export <
    GST_NAVIGATION_MESSAGE_INVALID
    GST_NAVIGATION_MESSAGE_MOUSE_OVER
    GST_NAVIGATION_MESSAGE_COMMANDS_CHANGED
    GST_NAVIGATION_MESSAGE_ANGLES_CHANGED
    GST_NAVIGATION_MESSAGE_EVENT
>;

constant GstNavigationQueryType is export := guint32;
our enum GstNavigationQueryTypeEnum is export (
    GST_NAVIGATION_QUERY_INVALID  =>  0,
    GST_NAVIGATION_QUERY_COMMANDS =>  1,
    GST_NAVIGATION_QUERY_ANGLES   =>  2,
);

constant GstVideoAlphaMode is export := guint32;
our enum GstVideoAlphaModeEnum is export <
    GST_VIDEO_ALPHA_MODE_COPY
    GST_VIDEO_ALPHA_MODE_SET
    GST_VIDEO_ALPHA_MODE_MULT
>;

constant GstVideoChromaFlags is export := guint32;
our enum GstVideoChromaFlagsEnum is export (
    GST_VIDEO_CHROMA_FLAG_NONE       => 0,
    GST_VIDEO_CHROMA_FLAG_INTERLACED => 1,
);

constant GstVideoChromaMethod is export := guint32;
our enum GstVideoChromaMethodEnum is export <
    GST_VIDEO_CHROMA_METHOD_NEAREST
    GST_VIDEO_CHROMA_METHOD_LINEAR
>;

constant GstVideoChromaMode is export := guint32;
our enum GstVideoChromaModeEnum is export <
    GST_VIDEO_CHROMA_MODE_FULL
    GST_VIDEO_CHROMA_MODE_UPSAMPLE_ONLY
    GST_VIDEO_CHROMA_MODE_DOWNSAMPLE_ONLY
    GST_VIDEO_CHROMA_MODE_NONE
>;

constant GstVideoCodecFrameFlags is export := guint32;
our enum GstVideoCodecFrameFlagsEnum is export (
    GST_VIDEO_CODEC_FRAME_FLAG_DECODE_ONLY            =>  1,
    GST_VIDEO_CODEC_FRAME_FLAG_SYNC_POINT             =>  (1 +< 1),
    GST_VIDEO_CODEC_FRAME_FLAG_FORCE_KEYFRAME         =>  (1 +< 2),
    GST_VIDEO_CODEC_FRAME_FLAG_FORCE_KEYFRAME_HEADERS =>  (1 +< 3),
);

constant GstVideoDitherFlags is export := guint32;
our enum GstVideoDitherFlagsEnum is export (
    GST_VIDEO_DITHER_FLAG_NONE       => 0,
    GST_VIDEO_DITHER_FLAG_INTERLACED => 1,
    GST_VIDEO_DITHER_FLAG_QUANTIZE   => (1 +< 1),
);

constant GstVideoDitherMethod is export := guint32;
our enum GstVideoDitherMethodEnum is export <
    GST_VIDEO_DITHER_NONE
    GST_VIDEO_DITHER_VERTERR
    GST_VIDEO_DITHER_FLOYD_STEINBERG
    GST_VIDEO_DITHER_SIERRA_LITE
    GST_VIDEO_DITHER_BAYER
>;

constant GstVideoFieldOrder is export := guint32;
our enum GstVideoFieldOrderEnum is export (
    GST_VIDEO_FIELD_ORDER_UNKNOWN            => 0,
    GST_VIDEO_FIELD_ORDER_TOP_FIELD_FIRST    => 1,
    GST_VIDEO_FIELD_ORDER_BOTTOM_FIELD_FIRST => 2,
);

constant GstVideoFlags is export := guint32;
our enum GstVideoFlagsEnum is export (
    GST_VIDEO_FLAG_NONE                => 0,
    GST_VIDEO_FLAG_VARIABLE_FPS        => (1 +< 0),
    GST_VIDEO_FLAG_PREMULTIPLIED_ALPHA => (1 +< 1),
);

constant GstVideoFormatFlags is export := guint32;
our enum GstVideoFormatFlagsEnum is export (
    GST_VIDEO_FORMAT_FLAG_YUV     =>  (1 +< 0),
    GST_VIDEO_FORMAT_FLAG_RGB     =>  (1 +< 1),
    GST_VIDEO_FORMAT_FLAG_GRAY    =>  (1 +< 2),
    GST_VIDEO_FORMAT_FLAG_ALPHA   =>  (1 +< 3),
    GST_VIDEO_FORMAT_FLAG_LE      =>  (1 +< 4),
    GST_VIDEO_FORMAT_FLAG_PALETTE =>  (1 +< 5),
    GST_VIDEO_FORMAT_FLAG_COMPLEX =>  (1 +< 6),
    GST_VIDEO_FORMAT_FLAG_UNPACK  =>  (1 +< 7),
    GST_VIDEO_FORMAT_FLAG_TILED   =>  (1 +< 8),
);

constant GstVideoFrameFlags is export := guint32;
our enum GstVideoFrameFlagsEnum is export (
  GST_VIDEO_FRAME_FLAG_NONE            => 0,
  GST_VIDEO_FRAME_FLAG_INTERLACED      => (1 +< 0),
  GST_VIDEO_FRAME_FLAG_TFF             => (1 +< 1),
  GST_VIDEO_FRAME_FLAG_RFF             => (1 +< 2),
  GST_VIDEO_FRAME_FLAG_ONEFIELD        => (1 +< 3),
  GST_VIDEO_FRAME_FLAG_MULTIPLE_VIEW   => (1 +< 4),
  GST_VIDEO_FRAME_FLAG_FIRST_IN_BUNDLE => (1 +< 5),
  GST_VIDEO_FRAME_FLAG_TOP_FIELD       => (1 +< 1) +| (1 +< 3), #= GST_VIDEO_FRAME_FLAG_TFF | GST_VIDEO_FRAME_FLAG_ONEFIELD
  GST_VIDEO_FRAME_FLAG_BOTTOM_FIELD    => (1 +< 3)              #= GST_VIDEO_FRAME_FLAG_ONEFIELD
);

constant GstVideoFrameMapFlags is export := guint32;
our enum GstVideoFrameMapFlagsEnum is export (
    GST_VIDEO_FRAME_MAP_FLAG_NO_REF => (GST_MAP_FLAG_LAST +< 0),
    GST_VIDEO_FRAME_MAP_FLAG_LAST   => (GST_MAP_FLAG_LAST +< 8),
);

constant GstVideoGLTextureOrientation is export := guint32;
our enum GstVideoGLTextureOrientationEnum is export <
    GST_VIDEO_GL_TEXTURE_ORIENTATION_X_NORMAL_Y_NORMAL
    GST_VIDEO_GL_TEXTURE_ORIENTATION_X_NORMAL_Y_FLIP
    GST_VIDEO_GL_TEXTURE_ORIENTATION_X_FLIP_Y_NORMAL
    GST_VIDEO_GL_TEXTURE_ORIENTATION_X_FLIP_Y_FLIP
>;

constant GstVideoGLTextureType is export := guint32;
our enum GstVideoGLTextureTypeEnum is export <
  GST_VIDEO_GL_TEXTURE_TYPE_LUMINANCE
  GST_VIDEO_GL_TEXTURE_TYPE_LUMINANCE_ALPHA
  GST_VIDEO_GL_TEXTURE_TYPE_RGB16
  GST_VIDEO_GL_TEXTURE_TYPE_RGB
  GST_VIDEO_GL_TEXTURE_TYPE_RGBA
  GST_VIDEO_GL_TEXTURE_TYPE_R
  GST_VIDEO_GL_TEXTURE_TYPE_RG
>;

constant GstVideoGammaMode is export := guint32;
our enum GstVideoGammaModeEnum is export <
    GST_VIDEO_GAMMA_MODE_NONE
    GST_VIDEO_GAMMA_MODE_REMAP
>;

constant GstVideoInterlaceMode is export := guint32;
our enum GstVideoInterlaceModeEnum is export (
    GST_VIDEO_INTERLACE_MODE_PROGRESSIVE =>  0,
    'GST_VIDEO_INTERLACE_MODE_INTERLEAVED',
    'GST_VIDEO_INTERLACE_MODE_MIXED',
    'GST_VIDEO_INTERLACE_MODE_FIELDS',
    'GST_VIDEO_INTERLACE_MODE_ALTERNATE'
);

constant GstVideoMatrixMode is export := guint32;
our enum GstVideoMatrixModeEnum is export <
    GST_VIDEO_MATRIX_MODE_FULL
    GST_VIDEO_MATRIX_MODE_INPUT_ONLY
    GST_VIDEO_MATRIX_MODE_OUTPUT_ONLY
    GST_VIDEO_MATRIX_MODE_NONE
>;

constant GstVideoMultiviewFlags is export := guint32;
our enum GstVideoMultiviewFlagsEnum is export (
    GST_VIDEO_MULTIVIEW_FLAGS_NONE             => 0,
    GST_VIDEO_MULTIVIEW_FLAGS_RIGHT_VIEW_FIRST => (1 +< 0),
    GST_VIDEO_MULTIVIEW_FLAGS_LEFT_FLIPPED     => (1 +< 1),
    GST_VIDEO_MULTIVIEW_FLAGS_LEFT_FLOPPED     => (1 +< 2),
    GST_VIDEO_MULTIVIEW_FLAGS_RIGHT_FLIPPED    => (1 +< 3),
    GST_VIDEO_MULTIVIEW_FLAGS_RIGHT_FLOPPED    => (1 +< 4),
    GST_VIDEO_MULTIVIEW_FLAGS_HALF_ASPECT      => (1 +< 14),
    GST_VIDEO_MULTIVIEW_FLAGS_MIXED_MONO       => (1 +< 15),
);

constant GstVideoMultiviewMode is export := gint32;
our enum GstVideoMultiviewModeEnum is export (
    GST_VIDEO_MULTIVIEW_MODE_NONE                      =>  -1,
    GST_VIDEO_MULTIVIEW_MODE_MONO                      =>  0,
    'GST_VIDEO_MULTIVIEW_MODE_LEFT',
    'GST_VIDEO_MULTIVIEW_MODE_RIGHT',
    'GST_VIDEO_MULTIVIEW_MODE_SIDE_BY_SIDE',
    'GST_VIDEO_MULTIVIEW_MODE_SIDE_BY_SIDE_QUINCUNX',
    'GST_VIDEO_MULTIVIEW_MODE_COLUMN_INTERLEAVED',
    'GST_VIDEO_MULTIVIEW_MODE_ROW_INTERLEAVED',
    'GST_VIDEO_MULTIVIEW_MODE_TOP_BOTTOM',
    'GST_VIDEO_MULTIVIEW_MODE_CHECKERBOARD',
    GST_VIDEO_MULTIVIEW_MODE_FRAME_BY_FRAME            =>  32,
    'GST_VIDEO_MULTIVIEW_MODE_MULTIVIEW_FRAME_BY_FRAME',
    'GST_VIDEO_MULTIVIEW_MODE_SEPARATED'
);

constant GstVideoMultiviewFramePacking is export := guint32;
our enum GstVideoMultiviewFramePackingEnum is export (
    GST_VIDEO_MULTIVIEW_FRAME_PACKING_NONE                  =>  GST_VIDEO_MULTIVIEW_MODE_NONE,
    GST_VIDEO_MULTIVIEW_FRAME_PACKING_MONO                  =>  GST_VIDEO_MULTIVIEW_MODE_MONO,
    GST_VIDEO_MULTIVIEW_FRAME_PACKING_LEFT                  =>  GST_VIDEO_MULTIVIEW_MODE_LEFT,
    GST_VIDEO_MULTIVIEW_FRAME_PACKING_RIGHT                 =>  GST_VIDEO_MULTIVIEW_MODE_RIGHT,
    GST_VIDEO_MULTIVIEW_FRAME_PACKING_SIDE_BY_SIDE          =>  GST_VIDEO_MULTIVIEW_MODE_SIDE_BY_SIDE,
    GST_VIDEO_MULTIVIEW_FRAME_PACKING_SIDE_BY_SIDE_QUINCUNX =>  GST_VIDEO_MULTIVIEW_MODE_SIDE_BY_SIDE_QUINCUNX,
    GST_VIDEO_MULTIVIEW_FRAME_PACKING_COLUMN_INTERLEAVED    =>  GST_VIDEO_MULTIVIEW_MODE_COLUMN_INTERLEAVED,
    GST_VIDEO_MULTIVIEW_FRAME_PACKING_ROW_INTERLEAVED       =>  GST_VIDEO_MULTIVIEW_MODE_ROW_INTERLEAVED,
    GST_VIDEO_MULTIVIEW_FRAME_PACKING_TOP_BOTTOM            =>  GST_VIDEO_MULTIVIEW_MODE_TOP_BOTTOM,
    GST_VIDEO_MULTIVIEW_FRAME_PACKING_CHECKERBOARD          =>  GST_VIDEO_MULTIVIEW_MODE_CHECKERBOARD,
);

constant GstVideoMultiviewViewLabel is export := guint32;
our enum GstVideoMultiviewViewLabelEnum is export (
    GST_VIDEO_MULTIVIEW_VIEW_UNKNOWN => 0,
    GST_VIDEO_MULTIVIEW_VIEW_MONO    => 1,
    GST_VIDEO_MULTIVIEW_VIEW_LEFT    => 2,
    GST_VIDEO_MULTIVIEW_VIEW_RIGHT   => 3,
);

constant GstVideoOverlayFormatFlags is export := guint32;
our enum GstVideoOverlayFormatFlagsEnum is export (
    GST_VIDEO_OVERLAY_FORMAT_FLAG_NONE                => 0,
    GST_VIDEO_OVERLAY_FORMAT_FLAG_PREMULTIPLIED_ALPHA => (1 +< 0),
    GST_VIDEO_OVERLAY_FORMAT_FLAG_GLOBAL_ALPHA        => (1 +< 1),
);

constant GstVideoPackFlags is export := guint32;
our enum GstVideoPackFlagsEnum is export (
    GST_VIDEO_PACK_FLAG_NONE           => 0,
    GST_VIDEO_PACK_FLAG_TRUNCATE_RANGE => (1 +< 0),
    GST_VIDEO_PACK_FLAG_INTERLACED     => (1 +< 1),
);

constant GstVideoPrimariesMode is export := guint32;
our enum GstVideoPrimariesModeEnum is export <
    GST_VIDEO_PRIMARIES_MODE_NONE
    GST_VIDEO_PRIMARIES_MODE_MERGE_ONLY
    GST_VIDEO_PRIMARIES_MODE_FAST
>;

constant GstVideoResamplerFlags is export := guint32;
our enum GstVideoResamplerFlagsEnum is export (
    GST_VIDEO_RESAMPLER_FLAG_NONE      => 0,
    GST_VIDEO_RESAMPLER_FLAG_HALF_TAPS => (1 +< 0),
);

constant GstVideoResamplerMethod is export := guint32;
our enum GstVideoResamplerMethodEnum is export <
    GST_VIDEO_RESAMPLER_METHOD_NEAREST
    GST_VIDEO_RESAMPLER_METHOD_LINEAR
    GST_VIDEO_RESAMPLER_METHOD_CUBIC
    GST_VIDEO_RESAMPLER_METHOD_SINC
    GST_VIDEO_RESAMPLER_METHOD_LANCZOS
>;

constant GstVideoScalerFlags is export := guint32;
our enum GstVideoScalerFlagsEnum is export (
    GST_VIDEO_SCALER_FLAG_NONE       => 0,
    GST_VIDEO_SCALER_FLAG_INTERLACED => 1 +< 0,
);

constant GstVideoTileType is export := guint32;
our enum GstVideoTileTypeEnum is export (
    GST_VIDEO_TILE_TYPE_INDEXED =>  0,
);

constant GstVideoTimeCodeFlags is export := guint32;
our enum GstVideoTimeCodeFlagsEnum is export (
    GST_VIDEO_TIME_CODE_FLAGS_NONE       => 0,
    GST_VIDEO_TIME_CODE_FLAGS_DROP_FRAME => (1 +< 0),
    GST_VIDEO_TIME_CODE_FLAGS_INTERLACED => (1 +< 1),
);

constant GstVideoVBIParserResult is export := guint32;
our enum GstVideoVBIParserResultEnum is export (
    GST_VIDEO_VBI_PARSER_RESULT_DONE  => 0,
    GST_VIDEO_VBI_PARSER_RESULT_OK    => 1,
    GST_VIDEO_VBI_PARSER_RESULT_ERROR => 2,
);

constant GstVideoFormat is export := guint32;
our enum GstVideoFormatEnum is export <
  GST_VIDEO_FORMAT_UNKNOWN
  GST_VIDEO_FORMAT_ENCODED
  GST_VIDEO_FORMAT_I420
  GST_VIDEO_FORMAT_YV12
  GST_VIDEO_FORMAT_YUY2
  GST_VIDEO_FORMAT_UYVY
  GST_VIDEO_FORMAT_AYUV
  GST_VIDEO_FORMAT_RGBx
  GST_VIDEO_FORMAT_BGRx
  GST_VIDEO_FORMAT_xRGB
  GST_VIDEO_FORMAT_xBGR
  GST_VIDEO_FORMAT_RGBA
  GST_VIDEO_FORMAT_BGRA
  GST_VIDEO_FORMAT_ARGB
  GST_VIDEO_FORMAT_ABGR
  GST_VIDEO_FORMAT_RGB
  GST_VIDEO_FORMAT_BGR
  GST_VIDEO_FORMAT_Y41B
  GST_VIDEO_FORMAT_Y42B
  GST_VIDEO_FORMAT_YVYU
  GST_VIDEO_FORMAT_Y444
  GST_VIDEO_FORMAT_v210
  GST_VIDEO_FORMAT_v216
  GST_VIDEO_FORMAT_NV12
  GST_VIDEO_FORMAT_NV21
  GST_VIDEO_FORMAT_GRAY8
  GST_VIDEO_FORMAT_GRAY16_BE
  GST_VIDEO_FORMAT_GRAY16_LE
  GST_VIDEO_FORMAT_v308
  GST_VIDEO_FORMAT_RGB16
  GST_VIDEO_FORMAT_BGR16
  GST_VIDEO_FORMAT_RGB15
  GST_VIDEO_FORMAT_BGR15
  GST_VIDEO_FORMAT_UYVP
  GST_VIDEO_FORMAT_A420
  GST_VIDEO_FORMAT_RGB8P
  GST_VIDEO_FORMAT_YUV9
  GST_VIDEO_FORMAT_YVU9
  GST_VIDEO_FORMAT_IYU1
  GST_VIDEO_FORMAT_ARGB64
  GST_VIDEO_FORMAT_AYUV64
  GST_VIDEO_FORMAT_r210
  GST_VIDEO_FORMAT_I420_10BE
  GST_VIDEO_FORMAT_I420_10LE
  GST_VIDEO_FORMAT_I422_10BE
  GST_VIDEO_FORMAT_I422_10LE
  GST_VIDEO_FORMAT_Y444_10BE
  GST_VIDEO_FORMAT_Y444_10LE
  GST_VIDEO_FORMAT_GBR
  GST_VIDEO_FORMAT_GBR_10BE
  GST_VIDEO_FORMAT_GBR_10LE
  GST_VIDEO_FORMAT_NV16
  GST_VIDEO_FORMAT_NV24
  GST_VIDEO_FORMAT_NV12_64Z32
  GST_VIDEO_FORMAT_A420_10BE
  GST_VIDEO_FORMAT_A420_10LE
  GST_VIDEO_FORMAT_A422_10BE
  GST_VIDEO_FORMAT_A422_10LE
  GST_VIDEO_FORMAT_A444_10BE
  GST_VIDEO_FORMAT_A444_10LE
  GST_VIDEO_FORMAT_NV61
  GST_VIDEO_FORMAT_P010_10BE
  GST_VIDEO_FORMAT_P010_10LE
  GST_VIDEO_FORMAT_IYU2
  GST_VIDEO_FORMAT_VYUY
  GST_VIDEO_FORMAT_GBRA
  GST_VIDEO_FORMAT_GBRA_10BE
  GST_VIDEO_FORMAT_GBRA_10LE
  GST_VIDEO_FORMAT_GBR_12BE
  GST_VIDEO_FORMAT_GBR_12LE
  GST_VIDEO_FORMAT_GBRA_12BE
  GST_VIDEO_FORMAT_GBRA_12LE
  GST_VIDEO_FORMAT_I420_12BE
  GST_VIDEO_FORMAT_I420_12LE
  GST_VIDEO_FORMAT_I422_12BE
  GST_VIDEO_FORMAT_I422_12LE
  GST_VIDEO_FORMAT_Y444_12BE
  GST_VIDEO_FORMAT_Y444_12LE
  GST_VIDEO_FORMAT_GRAY10_LE32
  GST_VIDEO_FORMAT_NV12_10LE32
  GST_VIDEO_FORMAT_NV16_10LE32
  GST_VIDEO_FORMAT_NV12_10LE40
  GST_VIDEO_FORMAT_Y210
  GST_VIDEO_FORMAT_Y410
  GST_VIDEO_FORMAT_VUYA
  GST_VIDEO_FORMAT_BGR10A2_LE
>;

constant GstVideoChromaSite is export := guint32;
our enum GstVideoChromaSiteEnum is export (
  GST_VIDEO_CHROMA_SITE_UNKNOWN   => 0,
  GST_VIDEO_CHROMA_SITE_NONE      => 1,
  GST_VIDEO_CHROMA_SITE_H_COSITED => (1 +< 1),
  GST_VIDEO_CHROMA_SITE_V_COSITED => (1 +< 2),
  GST_VIDEO_CHROMA_SITE_ALT_LINE  => (1 +< 3),
  GST_VIDEO_CHROMA_SITE_COSITED   => (1 +< 1) +| (1 +< 2),
                                     # (GST_VIDEO_CHROMA_SITE_H_COSITED | GST_VIDEO_CHROMA_SITE_V_COSITED),
  GST_VIDEO_CHROMA_SITE_JPEG      => 1,
                                     # (GST_VIDEO_CHROMA_SITE_NONE),
  GST_VIDEO_CHROMA_SITE_MPEG2     => (1 +< 1),
                                     # (GST_VIDEO_CHROMA_SITE_H_COSITED),
  GST_VIDEO_CHROMA_SITE_DV        => (1 +< 1) +| (1 +< 2) +| (1 +< 3)
                                     # (GST_VIDEO_CHROMA_SITE_COSITED |
                                     #  GST_VIDEO_CHROMA_SITE_ALT_LINE),
);

constant GstVideoColorRange is export := guint32;
our enum GstVideoColorRangeEnum is export (
  GST_VIDEO_COLOR_RANGE_UNKNOWN => 0,
  'GST_VIDEO_COLOR_RANGE_0_255',
  'GST_VIDEO_COLOR_RANGE_16_235'
);

constant GstVideoColorMatrix is export := guint32;
our enum GstVideoColorMatrixEnum is export (
  GST_VIDEO_COLOR_MATRIX_UNKNOWN => 0,
  'GST_VIDEO_COLOR_MATRIX_RGB',
  'GST_VIDEO_COLOR_MATRIX_FCC',
  'GST_VIDEO_COLOR_MATRIX_BT709',
  'GST_VIDEO_COLOR_MATRIX_BT601',
  'GST_VIDEO_COLOR_MATRIX_SMPTE240M',
  'GST_VIDEO_COLOR_MATRIX_BT2020'
);

constant GstVideoTransferFunction is export := guint32;
our enum GstVideoTransferFunctionEnum is export (
  GST_VIDEO_TRANSFER_UNKNOWN => 0,
  'GST_VIDEO_TRANSFER_GAMMA10',
  'GST_VIDEO_TRANSFER_GAMMA18',
  'GST_VIDEO_TRANSFER_GAMMA20',
  'GST_VIDEO_TRANSFER_GAMMA22',
  'GST_VIDEO_TRANSFER_BT709',
  'GST_VIDEO_TRANSFER_SMPTE240M',
  'GST_VIDEO_TRANSFER_SRGB',
  'GST_VIDEO_TRANSFER_GAMMA28',
  'GST_VIDEO_TRANSFER_LOG100',
  'GST_VIDEO_TRANSFER_LOG316',
  'GST_VIDEO_TRANSFER_BT2020_12',
  'GST_VIDEO_TRANSFER_ADOBERGB'
);

constant GstVideoColorPrimaries is export := guint32;
enum GstVideoColorPrimariesEnum is export (
  GST_VIDEO_COLOR_PRIMARIES_UNKNOWN => 0,
  'GST_VIDEO_COLOR_PRIMARIES_BT709',
  'GST_VIDEO_COLOR_PRIMARIES_BT470M',
  'GST_VIDEO_COLOR_PRIMARIES_BT470BG',
  'GST_VIDEO_COLOR_PRIMARIES_SMPTE170M',
  'GST_VIDEO_COLOR_PRIMARIES_SMPTE240M',
  'GST_VIDEO_COLOR_PRIMARIES_FILM',
  'GST_VIDEO_COLOR_PRIMARIES_BT2020',
  'GST_VIDEO_COLOR_PRIMARIES_ADOBERGB',
  'GST_VIDEO_COLOR_PRIMARIES_SMPTEST428',
  'GST_VIDEO_COLOR_PRIMARIES_SMPTERP431',
  'GST_VIDEO_COLOR_PRIMARIES_SMPTEEG432',
  'GST_VIDEO_COLOR_PRIMARIES_EBU3213'
);

constant GstPlayerColorBalanceType is export := guint32;
our enum GstPlayerColorBalanceTypeEnum is export <
  GST_PLAYER_COLOR_BALANCE_BRIGHTNESS
  GST_PLAYER_COLOR_BALANCE_CONTRAST
  GST_PLAYER_COLOR_BALANCE_SATURATION
  GST_PLAYER_COLOR_BALANCE_HUE
>;

constant GstPlayerError is export := guint32;
our enum GstPlayerErrorEnum is export (
  GST_PLAYER_ERROR_FAILED => 0
);

constant GstPlayerSnapshotFormat is export := guint32;
enum GstPlayerSnapshotFormatEnum is export (
  GST_PLAYER_THUMBNAIL_RAW_NATIVE => 0,
  'GST_PLAYER_THUMBNAIL_RAW_xRGB',
  'GST_PLAYER_THUMBNAIL_RAW_BGRx',
  'GST_PLAYER_THUMBNAIL_JPG',
  'GST_PLAYER_THUMBNAIL_PNG'
);

constant GstPlayerState is export := guint32;
our enum GstPlayerStateEnum is export <
  GST_PLAYER_STATE_STOPPED
  GST_PLAYER_STATE_BUFFERING
  GST_PLAYER_STATE_PAUSED
  GST_PLAYER_STATE_PLAYING
>;

# BASE

constant GstBaseSrcFlags is export := guint32;
our enum GstBaseSrcFlagsEnum is export (
    GST_BASE_SRC_FLAG_STARTING => 1,
    GST_BASE_SRC_FLAG_STARTED  => (GST_ELEMENT_FLAG_LAST +< 1),
    GST_BASE_SRC_FLAG_LAST     => (GST_ELEMENT_FLAG_LAST +< 6),
);

constant GstBaseParseFrameFlags is export := guint32;
our enum GstBaseParseFrameFlagsEnum is export (
  GST_BASE_PARSE_FRAME_FLAG_NONE         => 0,
  GST_BASE_PARSE_FRAME_FLAG_NEW_FRAME    => 1,
  GST_BASE_PARSE_FRAME_FLAG_NO_FRAME     => 1 +< 1,
  GST_BASE_PARSE_FRAME_FLAG_CLIP         => 1 +< 2,
  GST_BASE_PARSE_FRAME_FLAG_DROP         => 1 +< 3,
  GST_BASE_PARSE_FRAME_FLAG_QUEUE        => 1 +< 4
);
