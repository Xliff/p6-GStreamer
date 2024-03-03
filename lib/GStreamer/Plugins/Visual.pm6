use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;

use GStreamer::PBUtils::AudioVisualizer;

use GLib::Roles::Pointers;

unit package GStreamer::Plugins::Visual;

class GstVisual                  is repr<CStruct>     does GLib::Roles::Pointers is export {
  HAS GstAudioVisualizer   $.AudioVisualizer;

  has Pointer              $!audio; #= VisAudio
  has Pointer              $!video; #= VisVideo
  has Pointer              $!actor; #= VisActor
}

our subset GstVisualAncestry is export of Mu
  where GstVisual | GstAudioVisualizerAncestry;

class GStreamer::Plugins::Visual is GStreamer::PBUtils::AudioVisualizer {
  has GstVisual $!v;

  submethod BUILD (:$visualizer) {
    self.setGstVisual($visualizer) if $visualizer;
  }

  method setGstVisual(GstVisualAncestry $_) {
    my $to-parent;

    $!v = do  {
      when GstVisual {
        $to-parent = cast(GstAudioVisualizer, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstAudioVisualizer, $_);
      }
    }
    self.setGstAudioVisualizer($to-parent);
  }

  method GStreamer::Raw::Structs::GstVisual
    is also<GstVisual>
  { $!v }

  multi method new (GstVisualAncestry $visualizer) {
    $visualizer ?? self.bless( :$visualizer ) !! Nil;
  }

}
