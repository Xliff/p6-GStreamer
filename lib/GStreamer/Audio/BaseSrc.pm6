use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Audio::BaseSrc;

use GStreamer::Base::PushSrc;

use GStreamer::Audio::RingBuffer;

our subset GstAudioBaseSrcAncestry is export of Mu
  where GstAudioBaseSrc | GstPushSrcAncestry;

class GStreamer::Audio::BaseSrc is GStreamer::Base::PushSrc {
  has GstAudioBaseSrc $!abs;

  submethod BUILD (:$audio-base-src) {
    self.setGstAudioBaseSrc($audio-base-src);
  }

  method setGstAudioBaseSrc(GstAudioBaseSrcAncestry $_) {
    my $to-parent;

    $!abs = do {
      when GstAudioBaseSrc {
        $to-parent = cast(GstPushSrc, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstAudioBaseSrc, $_);
      }
    }
    self.setGstPushSrc($to-parent);
  }

  method GStreamer::Raw::Structs::GstAudioBaseSrc
    is also<GstAudioBaseSrc>
  { $!abs }

  method new (GstAudioBaseSrcAncestry $audio-base-src) {
    $audio-base-src ?? self.bless( :$audio-base-src ) !! Nil;
  }

  method create_ringbuffer (:$raw = False) is also<create-ringbuffer> {
    my $r = gst_audio_base_src_create_ringbuffer($!abs);

    $r ??
      ( $raw ?? $r !! GStreamer::Audio::RingBuffer.new($r) )
      !!
      Nil;
  }

  method get_provide_clock is also<get-provide-clock> {
    so gst_audio_base_src_get_provide_clock($!abs);
  }

  method get_slave_method is also<get-slave-method> {
    GstAudioBaseSrcSlaveMethodEnum(
      gst_audio_base_src_get_slave_method($!abs)
    );
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(self.^name, &gst_audio_base_src_get_type, $n, $t );
  }

  method set_provide_clock (Int() $provide) is also<set-provide-clock> {
    my gboolean $p = $provide.so.Int;

    gst_audio_base_src_set_provide_clock($!abs, $p);
  }

  method set_slave_method (Int() $method) is also<set-slave-method> {
    my GstAudioBaseSrcSlaveMethod $m = $method;

    gst_audio_base_src_set_slave_method($!abs, $m);
  }

}
