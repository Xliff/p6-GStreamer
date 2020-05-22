use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GLib::Roles::Pointers;

unit package GStreamer::Raw::Definitions;

# Number of forced compiles made.
constant forced = 8;

constant GstClockTime              is export := int64;
constant GstClockTimeDiff          is export := int64;
constant GstElementFactoryListType is export := uint64;

# cw: I now realize, that at some point, ALL of these will have to be functions
#     to account for the various distributions and OSes out there.
constant gstreamer            is export = 'gstreamer-1.0',v0;
constant gstreamer-video      is export = 'gstvideo-1.0',v0;
constant gstreamer-player     is export = 'gstplayer-1.0',v0;
constant gstreamer-base       is export = 'gstbase-1.0',v0;
constant gstreamer-sdp        is export = 'gstsdp-1.0',v0;
constant gstreamer-audio      is export = 'gstaudio-1.0',v0;
constant gstreamer-pbutils    is export = 'gstpbutils-1.0',v0;
constant gstreamer-controller is export = 'gstcontroller-1.0',v0;

constant GstBufferListFunc                 is export := Pointer;
constant GstBusSyncHandler                 is export := Pointer;
constant GstClockCallback                  is export := Pointer;
constant GstClockID                        is export := Pointer;
constant GstColorBalance                   is export := Pointer;
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
constant GstVideoGLTextureUpload           is export := Pointer;

class GstAdapter                  is repr<CPointer> does GLib::Roles::Pointers is export { }
#class GstAllocator                is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstAllocationParams         is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstAtomicQueue              is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstAudioConverter           is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstAudioStreamAlign         is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstBin                      is repr<CPointer> does GLib::Roles::Pointers is export { }
#class GstBuffer                   is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstBufferList               is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstBufferPool               is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstBus                      is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstCaps                     is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstChildProxy               is repr<CPointer> does GLib::Roles::Pointers is export { }
#class GstClock                    is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstContext                  is repr<CPointer> does GLib::Roles::Pointers is export { }
#class GstControlBinding           is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstDataQueue                is repr<CPointer> does GLib::Roles::Pointers is export { }
#class GstControlSource            is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstDevice                   is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstDeviceProviderFactory    is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstDynamicTypeFactory       is repr<CPointer> does GLib::Roles::Pointers is export { }
#class GstDateTime                 is repr<CPointer> does GLib::Roles::Pointers is export { }
#class GstElement                  is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstElementFactory           is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstEvent                    is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstFlowCombiner             is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstGhostPad                 is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstIterator                 is repr<CPointer> does GLib::Roles::Pointers is export { }
#class GstMessage                  is repr<CPointer> does GLib::Roles::Pointers is export { }
#class GstObject                   is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstNavigation               is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstPad                      is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstPadProbeInfo             is repr<CPointer> does GLib::Roles::Pointers is export { }
#class GstPadTemplate              is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstParseContext             is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstPipeline                 is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstPlayer                   is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstPlugin                   is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstPluginFeature            is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstPoll                     is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstPreset                   is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstProbeInfo                is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstProxyPad                 is repr<CPointer> does GLib::Roles::Pointers is export { }
#class GstQuery                    is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstQueueArray               is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstRegistry                 is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstSample                   is repr<CPointer> does GLib::Roles::Pointers is export { }
#class GstStaticCaps               is repr<CPointer> does GLib::Roles::Pointers is export { }
#class GstStaticPadTemplate        is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstStream                   is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstStreamCollection         is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstTracerFactory            is repr<CPointer> does GLib::Roles::Pointers is export { }
#class GstStructure                is repr<CPointer> does GLib::Roles::Pointers is export { }
#class GstTagList                  is repr<CPointer> does GLib::Roles::Pointers is export { }
#class GstToc                      is repr<CPointer> does GLib::Roles::Pointers is export { }
#class GstTocEntry                 is repr<CPointer> does GLib::Roles::Pointers is export { }

#class GstMapInfo                  is repr<CPointer> does GLib::Roles::Pointers is export { }
#class GstMemory                   is repr<CPointer> does GLib::Roles::Pointers is export { }
#class GstMeta                     is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstParentBufferMeta         is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstPlayerAudioInfo          is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstPlayerMediaInfo          is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstPlayerSignalDispatcher   is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstPlayerStreamInfo         is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstPlayerSubtitleInfo       is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstPlayerVideoInfo          is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstPlayerVideoRenderer      is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstReferenceTimestampMeta   is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstVideoChromaResample      is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstVideoConverter           is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstVideoDecoder             is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstVideoDither              is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstVideoEncoder             is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstVideoOrientation         is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstVideoOverlayComposition  is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstVideoOverlayRectangle    is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstVideoScaler              is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstUri                      is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstURIHandler               is repr<CPointer> does GLib::Roles::Pointers is export { }

class GstMIKEYDecryptInfo         is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstMIKEYEncryptInfo         is repr<CPointer> does GLib::Roles::Pointers is export { }

class GstPlayerVideoOverlayVideoRenderer   is repr<CPointer> does GLib::Roles::Pointers is export { }
class GstPlayerMainContextSignalDispatcher is repr<CPointer> does GLib::Roles::Pointers is export { }

constant GST_OBJECT_FLAG_LAST      is export = 1 +< 4;
constant GST_CLOCK_TIME_NONE       is export = 18446744073709551615;
constant GST_TIME_FORMAT           is export = '%u:%02u:%02u.%09u';
constant GST_SECOND                is export = 1000000000;
constant GST_MSECOND               is export = 1000000;
constant GST_USECOND               is export = 1000;
constant GST_NSECOND               is export = 1;

constant GST_PLAY_KB_ARROW_UP      is export = "\033[A";
constant GST_PLAY_KB_ARROW_DOWN    is export = "\033[B";
constant GST_PLAY_KB_ARROW_RIGHT   is export = "\033[C";
constant GST_PLAY_KB_ARROW_LEFT    is export = "\033[D";

constant GST_ELEMENT_METADATA_LONGNAME    is export = 'long-name';
constant GST_ELEMENT_METADATA_DESCRIPTION is export = 'description';
constant GST_ELEMENT_METADATA_AUTHOR      is export = 'author';
constant GST_ELEMENT_METADATA_DOC_URI     is export = 'doc-uri';
constant GST_ELEMENT_METADATA_ICON_NAME   is export = 'icon-name';
constant GST_ELEMENT_METADATA_KLASS       is export = 'klass';

constant GST_PADDING = 4;

constant GST_VIDEO_MAX_PLANES         is export = 4;
constant GST_VIDEO_MAX_COMPONENTS     is export = 4;
constant GST_VIDEO_DECODER_MAX_ERRORS is export = 10;
constant GST_VIDEO_DECODER_SINK_NAME  is export = 'sink';
constant GST_VIDEO_DECODER_SRC_NAME   is export = 'src';

constant GST_CAPS_FEATURE_META_GST_VIDEO_OVERLAY_COMPOSITION is export = 'meta:GstVideoOverlayComposition';

constant GST_VIDEO_OVERLAY_COMPOSITION_BLEND_FORMATS is export =
  "\{ BGRx, RGBx, xRGB, xBGR, RGBA, BGRA, ARGB, ABGR, RGB, BGR, {''
  }I420, YV12, AYUV, YUY2, UYVY, v308, Y41B, Y42B, Y444, {''
  }NV12, NV21, A420, YUV9, YVU9, IYU1, GRAY8 \}";

constant GST_AUDIO_CONVERTER_OPT_RESAMPLER_METHOD        is export = 'GstAudioConverter.resampler-method';
constant GST_AUDIO_CONVERTER_OPT_DITHER_METHOD           is export = 'GstAudioConverter.dither-method';
constant GST_AUDIO_CONVERTER_OPT_NOISE_SHAPING_METHOD    is export = 'GstAudioConverter.noise-shaping-method';
constant GST_AUDIO_CONVERTER_OPT_QUANTIZATION            is export = 'GstAudioConverter.quantization';
constant GST_AUDIO_CONVERTER_OPT_MIX_MATRIX              is export = 'GstAudioConverter.mix-matrix';

constant GST_VIDEO_SCALER_OPT_DITHER_METHOD              is export = 'GstVideoScaler.dither-method';
constant GST_VIDEO_CONVERTER_OPT_RESAMPLER_METHOD        is export = 'GstVideoConverter.resampler-method';
constant GST_VIDEO_CONVERTER_OPT_CHROMA_RESAMPLER_METHOD is export = 'GstVideoConverter.chroma-resampler-method';
constant GST_VIDEO_CONVERTER_OPT_RESAMPLER_TAPS          is export = 'GstVideoConverter.resampler-taps';
constant GST_VIDEO_CONVERTER_OPT_DITHER_METHOD           is export = 'GstVideoConverter.dither-method';
constant GST_VIDEO_CONVERTER_OPT_DITHER_QUANTIZATION     is export = 'GstVideoConverter.dither-quantization';
constant GST_VIDEO_CONVERTER_OPT_SRC_X                   is export = 'GstVideoConverter.src-x';
constant GST_VIDEO_CONVERTER_OPT_SRC_Y                   is export = 'GstVideoConverter.src-y';
constant GST_VIDEO_CONVERTER_OPT_SRC_WIDTH               is export = 'GstVideoConverter.src-width';
constant GST_VIDEO_CONVERTER_OPT_SRC_HEIGHT              is export = 'GstVideoConverter.src-height';
constant GST_VIDEO_CONVERTER_OPT_DEST_X                  is export = 'GstVideoConverter.dest-x';
constant GST_VIDEO_CONVERTER_OPT_DEST_Y                  is export = 'GstVideoConverter.dest-y';
constant GST_VIDEO_CONVERTER_OPT_DEST_WIDTH              is export = 'GstVideoConverter.dest-width';
constant GST_VIDEO_CONVERTER_OPT_DEST_HEIGHT             is export = 'GstVideoConverter.dest-height';
constant GST_VIDEO_CONVERTER_OPT_FILL_BORDER             is export = 'GstVideoConverter.fill-border';
constant GST_VIDEO_CONVERTER_OPT_ALPHA_VALUE             is export = 'GstVideoConverter.alpha-value';
constant GST_VIDEO_CONVERTER_OPT_ALPHA_MODE              is export = 'GstVideoConverter.alpha-mode';
constant GST_VIDEO_CONVERTER_OPT_BORDER_ARGB             is export = 'GstVideoConverter.border-argb';
constant GST_VIDEO_CONVERTER_OPT_CHROMA_MODE             is export = 'GstVideoConverter.chroma-mode';
constant GST_VIDEO_CONVERTER_OPT_MATRIX_MODE             is export = 'GstVideoConverter.matrix-mode';
constant GST_VIDEO_CONVERTER_OPT_GAMMA_MODE              is export = 'GstVideoConverter.gamma-mode';
constant GST_VIDEO_CONVERTER_OPT_PRIMARIES_MODE          is export = 'GstVideoConverter.primaries-mode';
constant GST_VIDEO_CONVERTER_OPT_THREADS                 is export = 'GstVideoConverter.threads';
