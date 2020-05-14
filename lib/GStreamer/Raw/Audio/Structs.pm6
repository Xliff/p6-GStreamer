use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GLib::Raw::Subs;
use GLib::Raw::Struct_Subs;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Structs;
use GStreamer::Raw::Enums;
use GStreamer::Raw::Audio::Enums;

use GLib::Roles::Pointers;

unit package GStreamer::Raw::Audio::Structs;

class GstAudioFormatInfo         is repr<CStruct>     does GLib::Roles::Pointers is export {
  has GstAudioFormat        $.format         is rw;
  has Str                   $!name;
  has Str                   $!description;
  has GstAudioFormatFlags   $.flags          is rw;
  has gint                  $.endianness     is rw;
  has gint                  $.width          is rw;
  has gint                  $.depth          is rw;
  has guint8                @.silence[8]     is CArray;

  has GstAudioFormat        $.unpack_format  is rw;
  has Pointer               $!unpack_func;
  has Pointer               $!pack_func;

  HAS GstPadding            $!padding;

  method name is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[1].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[1].set_value(self, s) };
  }

  method description is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[2].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[2].set_value(self, s) };
  }

};

class GstAudioInfo               is repr<CStruct>     does GLib::Roles::Pointers is export {
  has GstAudioFormatInfo        $.finfo;
  has GstAudioFlags             $.flags        is rw;
  has GstAudioLayout            $.layout       is rw;
  has gint                      $.rate         is rw;
  has gint                      $.channels     is rw;
  has gint                      $.bpf          is rw;
  has GstAudioChannelPosition   @.position[64] is CArray;

  HAS GstPadding                $!padding;
}

class GstAudioRingBufferSpec     is repr<CStruct>     does GLib::Roles::Pointers is export {
  HAS GstCaps                       $.caps;               #= the caps of the buffer

  has GstAudioRingBufferFormatType  $.type        is rw;
  has GstAudioInfo                  $.info        is rw;

  has guint64                       $.latency_time;         #= the required/actual latency time, this is the
                                                            #= actual the size of one segment and the
                                                            #= minimum possible latency we can achieve.
  has guint64                       $.buffer_time is rw;    #= the required/actual time of the buffer, this is
                                                            #= the total size of the buffer and maximum
                                                            #= latency we can compensate for.
  has gint                          $.segsize     is rw;    #= size of one buffer segment in bytes, this value
                                                            #= should be chosen to match latency_time as
                                                            #= well as possible. */
  has gint                          $.segtotal    is rw;    #= total number of segments, this value is the
                                                            #= number of segments of @segsize and should be
                                                            #= chosen so that it matches buffer_time as
                                                            #= close as possible. */
  # ABI added 0.10.20
  has gint                          $.seglatency  is rw;    #= number of segments queued in the lower
                                                            #= level device, defaults to segtotal.

  HAS GstPadding                    $!padding;

  method debug_buff {
    gst_audio_ring_buffer_debug_spec_buff(self);
  }

  method debug_caps {
    gst_audio_ring_buffer_debug_spec_caps(self);
  }

  method parse_caps (GstCaps() $caps) {
    so gst_audio_ring_buffer_parse_caps(self, $caps);
  }

  ### /usr/include/gstreamer-1.0/gst/audio/gstaudioringbuffer.h

  sub gst_audio_ring_buffer_debug_spec_buff (GstAudioRingBufferSpec $spec)
    is native(gstreamer-audio)
  { * }

  sub gst_audio_ring_buffer_debug_spec_caps (GstAudioRingBufferSpec $spec)
    is native(gstreamer-audio)
  { * }

  sub gst_audio_ring_buffer_parse_caps (
    GstAudioRingBufferSpec $spec,
    GstCaps $caps
  )
    returns uint32
    is native(gstreamer-audio)
  { * }

}

class GstAudioRingBuffer         is repr<CStruct>     does GLib::Roles::Pointers is export {
  HAS GstObject               $.object;

  # Public - With LOCK
  HAS GCond                   $.cond;
  has gboolean                $.open                           is rw;
  has gboolean                $.acquired                       is rw;
  has guint8                  $.memory                         is rw;
  has gsize                   $.size                           is rw;
  # Private
  has CArray[GstClockTime]    $!timestamps;
  # Public - With LOCK
  HAS GstAudioRingBufferSpec  $.spec;
  has gint                    $!samples_per_seg;
  has CArray[guint8]          $.empty_seg;

  # ATOMIC
  has gint                    $.state                          is rw;
  has gint                    $.segdone                        is rw;
  has gint                    $.segbase                        is rw;
  has gint                    $.waiting                        is rw;

  # Private
  has Pointer                 $!callback;          #= GstAudioRingBufferCallback
  has gpointer                $!cb_data;
  has gboolean                $!need_reorder;
  #gst[channel_reorder_map[i]] = device[i]
  HAS gint                    @!channel_reorder_map[64]        is CArray;
  has gboolean                $!flushing;

  # ATOMIC
  has gint                    $!may_start;
  has gboolean                $!active;

  has GDestroyNotify          $!cb_data_notify;

  # Generates error:
  # ===SORRY!===
  #   Cannot invoke this object (REPR: Null; VMNull)
  #has gpointer               @!padding[GST_PADDING - 1];

  has gpointer                $!padding0;
  has gpointer                $!padding1;
  has gpointer                $!padding2;
}

class GstAudioBaseSink           is repr<CStruct>     does GLib::Roles::Pointers is export {
  HAS GstBaseSink        $.element;

  # protected, with LOCK
  has GstAudioRingBuffer $.ringbuffer;

  # required buffer and latency in microseconds
  has guint64            $.buffer_time;
  has guint64            $.latency_time;

  # the next sample to write
  has guint64            $.next_sample;

  # clock
  has GstClock           $.provided_clock;

  # with g_atomic_; currently rendering eos
  has gboolean           $.eos_rendering;

  has gpointer           $!priv;            #= GstAudioBaseSinkPrivate
  has GstPadding         $!padding
}
