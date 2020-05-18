use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;

use GStreamer::Element;

our subset GstAudioVisualizerAncestry is export of Mu
  where GstAudioVisualizer | GstElementAncestry;

class GStreamer::PBUtils::AudioVisualizer is GStreamer::Element {
  has GstAudioVisualizer $!av;

  submethod BUILD (:$audio-visualizer) {
    self.setGstAudioVisualizer($audio-visualizer) if $audio-visualizer;
  }

  method setGstAudioVisualizer(GstAudioVisualizerAncestry $_) {
    my $to-parent;

    $!av = do  {
      when GstAudioVisualizer {
        $to-parent = cast(GstElement, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstAudioVisualizer, $_);
      }
    }
    self.setGstElement($to-parent);
  }

  method GStreamer::Raw::Structs::GstAudioVisualizer
    is also<GstAudioVisualizer>
  { $!av }

  method new (GstAudioVisualizerAncestry $audio-visualizer) {
    $audio-visualizer ?? self.bless( :$audio-visualizer ) !! Nil;
  }

  # Type: guint
  method shade-amount is rw  is also<shade_amount> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('shade-amount', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT );
        $gv.uint = $val;
        self.prop_set('shade-amount', $gv);
      }
    );
  }


  # Type: GstAudioVisualizerShader (pointer to...)
  method shader is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('shader', $gv)
        );

        my $va = cast(CArray[GstAudioVisualizerShader], $gv.pointer);
        GstAudioVisualizerShaderEnum( $va[0] );
      },
      STORE => -> $, Int() $val is copy {
        my GstAudioVisualizerShader $vs = $val;
        my $va = CArray[GstAudioVisualizerShader].new($vs);

        $gv = GLib::Value.new( G_TYPE_POINTER );
        $gv.pointer = cast(Pointer, $va);
        self.prop_set('shader', $gv);
      }
    );
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_audio_visualizer_get_type, $n, $t );
  }

}

sub gst_audio_visualizer_get_type ()
  returns GType
  is export
  is native(gstreamer-pbutils)
{ * }
