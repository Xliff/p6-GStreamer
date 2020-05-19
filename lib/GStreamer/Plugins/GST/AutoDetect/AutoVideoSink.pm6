use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Plugins::GST::AutoDetect::Raw;

use GStreamer::Bin;

# We skip GstAutoDetect since it's only a struct.
our subset GstAutoVideoSinkAncestry is export of Mu
  where GstAutoVideoSink | GstBinAncestry;

class GStreamer::Plugins::AutoVideoSink is GStreamer::Bin {
  has GstAutoVideoSink $!avs;

  submethod BUILD (:$video-sink) {
    self.setGstAutoVideoSink($video-sink);
  }

  method setGstAutoVideoSink (GstAutoVideoSinkAncestry $_) {
    my $to-parent;

    $!avs = do {
      when GstAutoVideoSink {
        $to-parent = cast(GstBin, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstAutoVideoSink, $_);
      }
    }
    self.setGstBin($to-parent);
  }

  method GStreamer::Raw::Structs::GstAutoVideoSink
    is also<GstAutoVideoSink>
  { $!avs }

  method new (GstAutoVideoSinkAncestry $video-sink) {
    $video-sink ?? self.bless( :$video-sink ) !! Nil;
  }

  # Type: gboolean
  method async-handling is rw  is also<async_handling> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('async-handling', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_BOOLEAN );
        $gv.boolean = $val;
        self.prop_set('async-handling', $gv);
      }
    );
  }

  # Type: GstCaps
  method filter-caps (:$raw = False) is rw is also<filter_caps> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('filter-caps', $gv)
        );

        my $c = $gv.pointer;
        return Nil unless $c;

        $c = cast(GstCaps, $c);
        return $c  if $raw;

        GStreamer::Caps.new($c);
      },
      STORE => -> $,  $val is copy {
        $gv = GLib::Value.new( G_TYPE_POINTER );
        $gv.pointer = $val;
        self.prop_set('filter-caps', $gv);
      }
    );
  }

  # Type: gboolean
  method message-forward is rw  is also<message_forward> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('message-forward', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_BOOLEAN );
        $gv.boolean = $val;
        self.prop_set('message-forward', $gv);
      }
    );
  }

  # Type: gchararray
  method name is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('name', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv = GLib::Value.new( G_TYPE_STRING );
        $gv.string = $val;
        self.prop_set('name', $gv);
      }
    );
  }

  # Type: GstObject
  method parent (:$raw = False) is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('parent', $gv)
        );

        my $o = $gv.object;
        return Nil unless $o;

        $o = cast(GstObject, $o);
        return $o  if $raw;

        GStreamer::Object.new($o);
      },
      STORE => -> $, GstObject() $val is copy {
        $gv = GLib::Value.new( GStreamer::Object.get_type );
        $gv.object = $val;
        self.prop_set('parent', $gv);
      }
    );
  }

  # Type: gboolean
  method sync is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('sync', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_BOOLEAN );
        $gv.boolean = $val;
        self.prop_set('sync', $gv);
      }
    );
  }

  # Type: gint64
  method ts-offset is rw  is also<ts_offset> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('ts-offset', $gv)
        );
        $gv.int64;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_INT64 );
        $gv.int64 = $val;
        self.prop_set('ts-offset', $gv);
      }
    );
  }

}
