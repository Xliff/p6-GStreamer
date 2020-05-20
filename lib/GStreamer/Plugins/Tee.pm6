use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;

use GStreamer::Element;
use GStreamer::Object;
use GStreamer::Pad;

use GLib::Roles::Pointers;

unit package GStreamer::Plugins::Tee;

constant GstTeePullMode is export := guint32;
our enum GstTeePullModeEnum is export <
  GST_TEE_PULL_MODE_NEVER
  GST_TEE_PULL_MODE_SINGLE
>;

class GstTee                     is repr<CStruct>     does GLib::Roles::Pointers is export {
  HAS GstElement      $.element;
  # Private
  has GstPad          $!sinkpad;
  has GstPad          $!allocpad;
  has GHashTable      $!pad_indexes;
  has guint           $!next_pad_index;
  has gboolean        $!has_chain;
  has gboolean        $!silent;
  has Str             $!last_message;
  has GstPadMode      $!sink_mode;
  has GstTeePullMode  $!pull_mode;
  has GstPad          $!pull_pad;
  has gboolean        $!allow_not_linked;
}

our subset GstTeeAncestry is export of Mu
  where GstTee | GstElementAncestry;

class GStreamer::Plugins::Tee is GStreamer::Element {
  has GstTee $!t;

  submethod BUILD (:$tee) {
    self.setTee($tee);
  }

  method setTee (GstTeeAncestry $_) {
    my $to-parent;

    $!t = do {
      when GstTee {
        $to-parent = cast(GstElement, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstTee, $_);
      }
    }
    self.setElementSrc($to-parent);
  }

  method GStreamer::Plugins::Core::Tee::GstTee
    is also<GstTee>
  { $!t }

  method new (GstTeeAncestry $tee) {
    $tee ?? self.bless( :$tee ) !! Nil;
  }

  # Type: GstPad
  method alloc-pad (:$raw = False) is rw  is also<alloc_pad> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('alloc-pad', $gv)
        );

        my $p = $gv.object;
        return Nil unless $p;;

        $p = cast(GstPad, $p);
        return $p if $raw;

        GStreamer::Pad.new($p);
      },
      STORE => -> $, GstPad() $val is copy {
        $gv = GLib::Value.new( GStreamer::Pad.get_type );
        $gv.object = $val;
        self.prop_set('alloc-pad', $gv);
      }
    );
  }

  # Type: gboolean
  method allow-not-linked is rw  is also<allow_not_linked> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('allow-not-linked', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_BOOLEAN );
        $gv.boolean = $val;
        self.prop_set('allow-not-linked', $gv);
      }
    );
  }

  # Type: gboolean
  method has-chain is rw  is also<has_chain> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('has-chain', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_BOOLEAN );
        $gv.boolean = $val;
        self.prop_set('has-chain', $gv);
      }
    );
  }

  # Type: gchararray
  method last-message is rw  is also<last_message> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('last-message', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'last-message does not allow writing'
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

  # Type: gint
  method num-src-pads is rw  is also<num_src_pads> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('num-src-pads', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        warn 'num-src-pads does not allow writing'
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
        return $o if $raw;

        GStreamer::Object.new($o);
      },
      STORE => -> $, GstObject() $val is copy {
        $gv = GLib::Value.new( GStreamer::Object.get_type );
        $gv.object = $val;
        self.prop_set('parent', $gv);
      }
    );
  }

  # Type: Tee-pull-mode
  method pull-mode is rw  is also<pull_mode> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('pull-mode', $gv)
        );
        GstTeePullModeEnum( $gv.enum );
      },
      STORE => -> $,  $val is copy {
        $gv = GLib::Value.new( GLib::Value.typeFromEnum(GstTeePullMode) );
        $gv.valueFromEnum(GstTeePullMode) = $val;
        self.prop_set('pull-mode', $gv);
      }
    );
  }

  # Type: gboolean
  method silent is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('silent', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_BOOLEAN );
        $gv.boolean = $val;
        self.prop_set('silent', $gv);
      }
    );
  }

}
