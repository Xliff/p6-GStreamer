my @defs = <
  GstPluginFeature
  GstDynamicTypeFactory
  GstFlowCombiner
  GstQueueArray
  GstAggregatorPad
  GstDataQueue
  GstParseContext
  GstPoll
  GstPoll
  GstTaskPool
  GstElementFactory
  GstCaps
  GstEvent
  GstStreamCollection
  GstVideoConverter
  GstVideoOverlayRectangle
  GstVideoOverlayComposition
  GstVideoDither
  GstVideoDecoder
  GstVideoEncoder
  GstVideoScaler
  GstStream
  GstDevice
  GstGhostPad
  GstClockID
  GstTracer
  GstSample
  GstBufferList
  GstUri
  GstPlugin
  GstPlayer
  GstContext
  GstPlayerSubtitleInfo
  GstPlayerMediaInfo
  GstPlayerVideoOverlayVideoRenderer
  GstPlayerVideoRenderer
  GstPlayerStreamInfo
  GstPlayerAudioInfo
  GstPlayerVideoInfo
  GstPlayerMainContextSignalDispatcher
  GstPlayerSignalDispatcher
  GstPlayerVideoRenderer
  GstPlayerSignalDispatcher
  GstBus
  GstTracerFactory
  GstProxyPad
  GstColorBalance
  GstVideoOrientation
  GstURIHandler
  GstChildProxy
  GstPreset
  GstRegistry
  GstAudioStreamAlign
  GstAudioConverter
  GstPipeline
  GstAtomicQueue
>;

my $fn = "t/00-struct-sizes.c";
my $o = $fn.IO;
my @out;

die "File not found: { $fn }" unless $o.e;

my $changed = False;
for $o.slurp.lines -> $l {
  if $l ~~ /^^ 's(' (\w+) / {
    if $/[0] eq @defs.any {
      $changed = True;
      @out.push: '//' ~ $l;
    } else {
      @out.push: $l;
    }
  } else {
    @out.push: $l;
  }
}

exit unless $changed;
$o.rename($fn ~ '.bak');
$fn.IO.spurt: @out.join("\n");
