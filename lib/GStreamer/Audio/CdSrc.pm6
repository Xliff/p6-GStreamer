use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;

use GStreamer::Base::PushSrc;

our subset GstAudioCdSrcAncestry is export of Mu
  where GstAudioCdSrc | GstPushSrcAncestry;

class GStreamer::Audio::CdSrc is GStreamer::Base::PushSrc {
  has GstAudioCdSrc $!acs;

  submethod BUILD (:$cd-src) {
    self.setGstAudioCdSrc($cd-src);
  }

  method setGstAudioCdSrc(GstAudioCdSrc $_) {
    my $to-parent;

    $!acs = do {
      when GstAudioCdSrc {
        $to-parent = cast(GstPushSrc, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstAudioCdSrc, $_);
      }
    }
    self.setGstPushSrc($to-parent);
  }

  method GStreamer::Raw::Structs::GstAudioCdSrc
    is also<GstAudioCdSrc>
  { $!acs }

  method new (GstAudioCdSrcAncestry $cd-src) {
    $cd-src ?? self.bless( :$cd-src ) !! Nil;
  }

  # Type: gchar
  method device is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('device', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv = GLib::Value.new( G_TYPE_STRING );
        $gv.string = $val;
        self.prop_set('device', $gv);
      }
    );
  }

  # Type: GstAudioCdSrcMode
  method mode is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('mode', $gv)
        );
        GstAudioCdSrcModeEnum( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT );
        $gv.uint = $val;
        self.prop_set('mode', $gv);
      }
    );
  }

  # Type: guint
  method track is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('track', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_UINT );
        $gv.uint = $val;
        self.prop_set('track', $gv);
      }
    );
  }

  method add_track (GstAudioCdSrcTrack $track) is also<add-track> {
    gst_audio_cd_src_add_track($!acs, $track);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_audio_cd_src_get_type, $n, $t );
  }
}

### /usr/include/gstreamer-1.0/gst/audio/gstaudiocdsrc.h

sub gst_audio_cd_src_add_track (GstAudioCdSrc $src, GstAudioCdSrcTrack $track)
  returns uint32
  is native(gstreamer-audio)
  is export
{ * }

sub gst_audio_cd_src_get_type ()
  returns GType
  is native(gstreamer-audio)
  is export
{ * }
