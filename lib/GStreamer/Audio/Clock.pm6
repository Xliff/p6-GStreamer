use v6.c;

use GStreamer::Raw::Types;
use GStreamer::Raw::Audio::Clock;

use GStreamer::SystemClock;

our subset GstAudioClockAncestry is export of Mu
  where GstAudioClock | GstClock;

class GStreamer::Audio::Clock is GStreamer::SystemClock {
  has GstAudioClock $!ac;

  submethod BUILD (:$audio-clock) {
    self.setAudioClock($audio-clock);
  }

  method setAudioClock (GstAudioClockAncestry $_) {
    my $to-parent;

    $!ac = do {
      when GstAudioClock {
        $to-parent = cast(GstClock, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstAudioClock, $_);
      }
    }
    self.setClock($to-parent);
  }

  multi method new (GstAudioClockAncestry $audio-clock) {
    $audio-clock ?? self.bless(:$audio-clock) !! Nil;
  }
  multi method new (
    Str() $name,
    &func,
    gpointer $user_data            = gpointer,
    GDestroyNotify $destroy_notify = gpointer
  ) {
    my $audio-clock = gst_audio_clock_new(
      $name,
      &func,
      $user_data,
      $destroy_notify
    );

    $audio-clock ?? self.bless( :$audio-clock ) !! Nil;
  }

  method adjust (Int() $time) {
    my GstClockTime $t = $time;

    gst_audio_clock_adjust($!ac, $t);
  }

  method get_time {
    gst_audio_clock_get_time($!ac);
  }

  method invalidate {
    gst_audio_clock_invalidate($!ac);
  }

  method reset (Int() $time) {
    my GstClockTime $t = $time;

    gst_audio_clock_reset($!ac, $t);
  }

}
