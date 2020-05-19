use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

use GLib::Roles::Pointers;

unit package GStreamer::Plugins::GST::AutoDetect::Raw;

class GstAutoDetect              is repr<CStruct>     does GLib::Roles::Pointers is export {
  HAS GstBin          $.parent;

  # configuration for subclasses
  has Str             $!media_klass;       #= Audio/Video/...
  has GstElementFlags $.flag        is rw; #= GST_ELEMENT_FLAG_{SINK/SOURCE}

  # explicit pointers to stuff used */
  has GstPad          $!pad;
  has GstCaps         $!filter_caps;
  has gboolean        $.sync        is rw;

  # Private
  has GstElement      $!kid;
  has gboolean        $!has_sync;
  has Str             $!type_klass;        #= Source/Sink
  has Str             $!media_klass_lc;
  has Str             $!type_klass_lc;     #= lower case versions

  method media_klass is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[1].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[1].set_value(self, s) };
  }

  method pad is rw {
    Proxy.new:
      FETCH => -> $              { self.^attributes[3].get_value(self)    },
      STORE => -> $, GstPad() \p { self.^attributes[3].set_value(self, p) };
  }

  method filter_caps is rw {
    Proxy.new:
      FETCH => -> $               { self.^attributes[4].get_value(self)    },
      STORE => -> $, GstCaps() \c { self.^attributes[4].set_value(self, c) };
  }
}

class GstAutoAudioSink           is repr<CStruct>     does GLib::Roles::Pointers is export {
  HAS GstAutoDetect    $.parent;
  has GstClockTimeDiff $.ts_offset is rw;
}

class GstAutoAudioSrc            is repr<CStruct>     does GLib::Roles::Pointers is export {
  HAS GstAutoDetect    $.parent;
}

class GstAutoVideoSink           is repr<CStruct>     does GLib::Roles::Pointers is export {
  HAS GstAutoDetect    $.parent;
  has GstClockTimeDiff $.ts_offset is rw;
}

class GstAutoVideoSrc            is repr<CStruct>     does GLib::Roles::Pointers is export {
  HAS GstAutoDetect    $.parent;
}
