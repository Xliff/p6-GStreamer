use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Plugins::GST::AutoDetect::Raw;

use GStreamer::Bin;

# We skip GstAutoDetect since it's only a struct.
our subset GstAutoVideoSrcAncestry is export of Mu
  where GstAutoVideoSrc | GstBinAncestry;

class GStreamer::Plugins::AutoVideoSrc is GStreamer::Bin {
  has GstAutoVideoSrc $!avs;

  submethod BUILD (:$video-src) {
    self.setGstAutoVideoSrc($video-src);
  }

  method setGstAutoVideoSrc (GstAutoVideoSrcAncestry $_) {
    my $to-parent;

    $!avs = do {
      when GstAutoVideoSrc {
        $to-parent = cast(GstBin, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstAutoVideoSrc, $_);
      }
    }
    self.setGstBin($to-parent);
  }

  method GStreamer::Raw::Structs::GstAutoVideoSrc
    is also<GstAutoVideoSrc>
  { $!avs }

  method new (GstAutoVideoSrcAncestry $video-src) {
    $video-src ?? self.bless( :$video-src ) !! Nil;
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

}
