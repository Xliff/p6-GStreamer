use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GLib::Roles::Pointers;

unit package GStreamer::Raw::Definitions;

# Number of forced compiles made.
constant forced = 1;

constant GstClockTime              is export := int64;
constant GstClockTimeDiff          is export := int64;
constant GstElementFactoryListType is export := uint64;

# cw: I now realize, that at some point, ALL of these will have to be functions
#     to account for the various distributions and OSes out there.
constant gstreamer is export = 'gstreamer-1.0',v0;

constant GstBufferListFunc                 is export := Pointer;
constant GstBusSyncHandler                 is export := Pointer;
constant GstClockCallback                  is export := Pointer;
constant GstClockID                        is export := Pointer;
constant GstElementCallAsyncFunc           is export := Pointer;
constant GstElementForeachPadFunc          is export := Pointer;
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
constant GstPadProbeCallback               is export := Pointer;
constant GstPadQueryFunction               is export := Pointer;
constant GstPadStickyEventsForeachFunction is export := Pointer;
constant GstPadUnlinkFunction              is export := Pointer;
constant GstPluginInitFullFunc             is export := Pointer;
constant GstPluginInitFunc                 is export := Pointer;
constant GstStructureFilterMapFunc         is export := Pointer;
constant GstStructureForeachFunc           is export := Pointer;
constant GstStructureMapFunc               is export := Pointer;
constant GstTagForeachFunc                 is export := Pointer;
constant GstTagMergeFunc                   is export := Pointer;
constant GstTaskFunction                   is export := Pointer;
constant GstMetaInitFunction               is export := Pointer;
constant GstMetaFreeFunction               is export := Pointer;
constant GstMetaTransformFunction          is export := Pointer;
constant GstBufferForeachMetaFunc          is export := Pointer;
constant GstCapsFilterMapFunc              is export := Pointer;
constant GstCapsForeachFunc                is export := Pointer;
constant GstCapsMapFunc                    is export := Pointer;

#class GstAllocator              is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstAllocationParams       is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstAtomicQueue            is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstBin                    is repr('CPointer') does GLib::Roles::Pointers is export { }
#class GstBuffer                 is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstBufferList             is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstBufferPool             is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstBus                    is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstCaps                   is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstChildProxy             is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstClock                  is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstContext                is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstControlBinding         is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstDevice                 is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstDeviceProviderFactory  is repr('CPointer') does GLib::Roles::Pointers is export { }
#class GstDateTime               is repr('CPointer') does GLib::Roles::Pointers is export { }
#class GstElement                is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstElementFactory         is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstEvent                  is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstGhostPad               is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstIterator               is repr('CPointer') does GLib::Roles::Pointers is export { }
#class GstMessage                is repr('CPointer') does GLib::Roles::Pointers is export { }
#class GstObject                 is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstPad                    is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstPadProbeInfo           is repr('CPointer') does GLib::Roles::Pointers is export { }
#class GstPadTemplate            is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstParseContext           is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstPipeline               is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstPlugin                 is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstPluginFeature          is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstProbeInfo              is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstProxyPad               is repr('CPointer') does GLib::Roles::Pointers is export { }
#class GstQuery                  is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstSample                 is repr('CPointer') does GLib::Roles::Pointers is export { }
#class GstStaticCaps             is repr('CPointer') does GLib::Roles::Pointers is export { }
#class GstStaticPadTemplate      is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstStream                 is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstStreamCollection       is repr('CPointer') does GLib::Roles::Pointers is export { }
#class GstStructure              is repr('CPointer') does GLib::Roles::Pointers is export { }
#class GstTagList                is repr('CPointer') does GLib::Roles::Pointers is export { }
#class GstToc                    is repr('CPointer') does GLib::Roles::Pointers is export { }
#class GstTocEntry               is repr('CPointer') does GLib::Roles::Pointers is export { }

class GstMapInfo                is repr('CPointer') does GLib::Roles::Pointers is export { }
#class GstMemory                 is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstMeta                   is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstParentBufferMeta       is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstReferenceTimestampMeta is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstUri                    is repr('CPointer') does GLib::Roles::Pointers is export { }
class GstURIHandler             is repr('CPointer') does GLib::Roles::Pointers is export { }

constant GST_OBJECT_FLAG_LAST      is export = 1 +< 4;
constant GST_CLOCK_TIME_NONE       is export = 18446744073709551615;
constant GST_TIME_FORMAT           is export = '%u:%02u:%02u.%09u';
constant GST_SECOND                is export = 1000000000;

constant GST_ELEMENT_METADATA_LONGNAME    is export = 'long-name';
constant GST_ELEMENT_METADATA_DESCRIPTION is export = 'description';
constant GST_ELEMENT_METADATA_AUTHOR      is export = 'author';
constant GST_ELEMENT_METADATA_DOC_URI     is export = 'doc-uri';
constant GST_ELEMENT_METADATA_ICON_NAME   is export = 'icon-name';

constant GST_PADDING = 4;
