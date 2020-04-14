use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;
use GStreamer::Raw::GhostPad;

use GStreamer::Iterator;
use GStreamer::Pad;

our subset GstProxyPadAncestry is export of Mu
  where GstProxyPad | GstPadAncestry;

class GStreamer::ProxyPad is GStreamer::Pad {
  has GstProxyPad $!pp;

  submethod BUILD (:$proxypad) {
    self.setProxyPad($proxypad) if $proxypad;
  }

  method setProxyPad (GstProxyPadAncestry $proxypad) {
    my $to-parent;

    $!pp = do {
      when GstProxyPad {
        $to-parent = cast(GstPad, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstProxyPad, $_);
      }
    }
    self.setPad($to-parent);
  }

  method GStreamer::Raw::Definitions::GstProxyPad
  { $!pp }

  method new (GstProxyPadAncestry $proxypad) {
    $proxypad ?? self.bless(:$proxypad) !! Nil;
  }

  method chain_default (
    GStreamer::ProxyPad:U:
    GstPad() $pad,
    GstObject() $parent,
    GstBuffer() $buffer
  ) is also<chain-default> {
    GstFlowReturnEnum( gst_proxy_pad_chain_default($pad, $parent, $buffer) );
  }

  method chain_list_default (
    GStreamer::ProxyPad:U:
    GstPad() $pad,
    GstObject() $parent,
    GstBufferList() $list
  ) is also<chain-list-default> {
    GstFlowReturnEnum( gst_proxy_pad_chain_list_default($pad, $parent, $list) )
  }

  method get_internal (:$raw = False) is also<get-internal> {
    my $pp = gst_proxy_pad_get_internal($!pp);

    $pp ??
      ( $raw ?? $pp !! GStreamer::ProxyPad.new($pp) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_proxy_pad_get_type, $n, $t );
  }

  proto method getrange_default (|)
      is also<getrange-default>
  { * }

  multi method getrange_default (
    GStreamer::ProxyPad:U:
    GstPad() $pad,
    GstObject() $parent,
    Int() $offset,
    Int() $size,
    :$raw = False
  ) {
    samewith($pad, $parent, $offset, $size, $, :$raw);
  }
  multi method getrange_default (
    GStreamer::ProxyPad:U:
    GstPad() $pad,
    GstObject() $parent,
    Int() $offset,
    Int() $size,
    $buffer is rw,
    :$raw = False;
  ) {
    my guint64 $o = $offset;
    my guint $s = $size;
    my $ba = CArray[Pointer[GstBuffer]].new;

    $ba[0] = Pointer[GstBuffer];
    my $fr = GstFlowReturnEnum(
      gst_proxy_pad_getrange_default($pad, $parent, $o, $s, $ba)
    );
    ($buffer) = ppr($ba);
    $buffer = GStreamer::Buffer.new($buffer) unless $raw || $buffer.not;
    ($fr, $buffer);
  }

  method iterate_internal_links_default (
    GStreamer::ProxyPad:U:
    GstPad() $pad,
    GstObject() $parent,
    :$raw = False
  ) {
    my $i = gst_proxy_pad_iterate_internal_links_default($pad, $parent);

    $i ??
      ( $raw ?? $i !! GStreamer::Iterator.new($i) )
      !!
      Nil;
  }

}
