use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Bin;

use GLib::Value;
use GStreamer::Element;
use GStreamer::Iterator;

use GStreamer::Roles::ChildProxy;
use GStreamer::Roles::Signals::Bin;

our subset GstBinAncestry is export of Mu
  where GstBin | GstChildProxy | GstElementAncestry;

class GStreamer::Bin is GStreamer::Element {
  also does GStreamer::Roles::ChildProxy;
  also does GStreamer::Roles::Signals::Bin;

  has GstBin $!b handles <numchildren children_cookie>;

  submethod BUILD (:$bin) {
    self.setBin($bin) if $bin;
  }

  method setGstBin(GstBinAncestry $_) is also<setBin> {
    my $to-parent;

    $!b = do {
      when GstBin {
        $to-parent = cast(GstElement, $_);
        $_
      }

      when GstChildProxy {
        $to-parent = cast(GstElement, $_);
        $!cp = $_;                         # GStreamer::Roles::ChildProxy
        cast(GstBin, $_);
      }

      default {
        $to-parent = $_;
        cast(GstBin, $_);
      }
    }
    $!cp //= cast(GstChildProxy, $_);      # GStreamer::Roles::ChildProxy
    self.setElement($to-parent);
    self.roleInit-ChildProxy unless $!cp;
  }

  method GStreamer::Raw::Structs::GstBin
    is also<GstBin>
  { $!b }

  multi method new (GstBinAncestry $bin) {
    $bin ?? self.bless( :$bin ) !! Nil;
  }
  multi method new (Str() $name) {
    my $bin = gst_bin_new($name);

    $bin ?? self.bless( :$bin ) !! Nil;
  }

  method children (:$glist = False, :$raw = False) {
    return Nil          unless $!b.children;
    return $!b.children if     $glist && $raw;

    my $cl = GLib::GList.new($!b.children)
      but GLib::Roles::ListData[GstElement];
    return if $glist;

    $raw ?? $cl.Array
         !! $cl.Array.map({ GStreamer::Element.new($_) });
  }

  method child-bus (:$raw = False) {
    $!b.child-bus ??
      ( $raw ?? $!b.child-bus !! GStreamer::Bus.new($!b.child-bus) )
      !!
      Nil;
  }

  method messages (:$glist = False, :$raw = False) {
    return Nil          unless $!b.messages;
    return $!b.messages if     $glist && $raw;

    my $cl = GLib::GList.new($!b.messages)
      but GLib::Roles::ListData[GstMessage];
    return if $glist;

    $raw ?? $cl.Array
         !! $cl.Array.map({ GStreamer::Message.new($_) });
  }

  method polling {
    so $!b.polling;
  }

  method state_dirty is also<state-dirty> {
    so $!b.state_dirty;
  }

  method clock_dirty is also<clock-dirty> {
    so $!b.clock-dirty;
  }

  method suppressed_flags is rw is also<suppressed-flags> {
    Proxy.new(
      FETCH => sub ($) {
        GstElementFlagsEnum( gst_bin_get_suppressed_flags($!b) );
      },
      STORE => sub ($, Int() $flags is copy) {
        gst_bin_set_suppressed_flags($!b, $flags);
      }
    );
  }

  # Type: gboolean
  method async-handling is rw  {
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

  # Type: gboolean
  method message-forward is rw  {
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

  # Is originally:
  # GstBin, GstBin, GstElement, gpointer
  method deep-element-added {
    self.connect-deep-element($!b, 'deep-element-added');
  }

  # Is originally:
  # GstBin, GstBin, GstElement, gpointer
  method deep-element-removed {
    self.connect-deep-element($!b, 'deep-element-removed');
  }

  # Is originally:
  # GstBin, gpointer --> gboolean
  method do-latency {
    self.connect-rbool($!b, 'do-latency');
  }

  # Is originally:
  # GstBin, GstElement, gpointer
  method element-added {
    self.connect-element($!b, 'element-added');
  }

  # Is originally:
  # GstBin, GstElement, gpointer
  method element-removed {
    self.connect-element($!b, 'element-removed');
  }

  # Is originally:
  # GstBin, GstMessage
  method handle-message {
    self.connect-handle-message($!b);
  }

  # Is originally:
  # GstBin, GstMessage --> gboolean
  method remove-element {
    self.connect-remove-element($!b);
  }

  method add (GstElement() $element) {
    gst_bin_add($!b, $element);
  }

  method add_many (*@e) is also<add-many> {
    my $dieMsg = qq:to/DIE/.&nolf;
      Items passed to GStreamer::Bin.add_many must be GStreamer::Element {''
      }compatible!
      DIE

    die $dieMsg unless @e.all ~~ (GStreamer::Element, GstElement).any;
    self.add($_) for @e;
  }

  method get_by_interface (GType $iface, :$raw = False)
    is also<get-by-interface>
  {
    my $e = gst_bin_get_by_interface($!b, $iface);

    $e ??
      ( $raw ?? $e !! GStreamer::Element.new($e) )
      !!
      Nil;
  }

  method get_by_name (Str() $name, :$raw = False) is also<get-by-name> {
    my $e = gst_bin_get_by_name($!b, $name);

    $e ??
      ( $raw ?? $e !! GStreamer::Element.new($e) )
      !!
      Nil;
  }

  method get_by_name_recurse_up (Str() $name,:$raw = False)
    is also<get-by-name-recurse-up>
  {
    my $e = gst_bin_get_by_name_recurse_up($!b, $name);

    $e ??
      ( $raw ?? $e !! GStreamer::Element.new($e) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_bin_get_type, $n, $t );
  }

  method iterate_all_by_interface (GType $iface, :$raw = False)
    is also<iterate-all-by-interface>
  {
    my $i = gst_bin_iterate_all_by_interface($!b, $iface);

    $i ??
      ( $raw ?? $i !! GStreamer::Iterator.new($i) )
      !!
      Nil;
  }

  method iterate_elements (:$raw = False) is also<iterate-elements> {
    my $i = gst_bin_iterate_elements($!b);

    $i ??
      ( $raw ?? $i !! GStreamer::Iterator.new($i) )
      !!
      Nil;
  }

  method iterate_recurse (:$raw = False) is also<iterate-recurse> {
    my $i = gst_bin_iterate_recurse($!b);

    $i ??
      ( $raw ?? $i !! GStreamer::Iterator.new($i) )
      !!
      Nil;
  }

  method iterate_sinks (:$raw = False) is also<iterate-sinks> {
    my $i = gst_bin_iterate_sinks($!b);

    $i ??
      ( $raw ?? $i !! GStreamer::Iterator.new($i) )
      !!
      Nil;
  }

  method iterate_sorted (:$raw = False) is also<iterate-sorted> {
    my $i = gst_bin_iterate_sorted($!b);

    $i ??
      ( $raw ?? $i !! GStreamer::Iterator.new($i) )
      !!
      Nil;
  }

  method iterate_sources (:$raw = False) is also<iterate-sources> {
    my $i = gst_bin_iterate_sources($!b);

    $i ??
      ( $raw ?? $i !! GStreamer::Iterator.new($i) )
      !!
      Nil;
  }

  method recalculate_latency is also<recalculate-latency> {
    gst_bin_recalculate_latency($!b);
  }

  method remove (GstElement() $element) {
    gst_bin_remove($!b, $element);
  }

  method remove_many (*@e) is also<remove-many> {
    my $dieMsg = qq:to/DIE/.&nolf;
      Items passed to GStreamer::Bin.remove_many must be GStreamer::Element {''
      }compatible!
      DIE

    die $dieMsg unless @e.all ~~ (GStreamer::Element, GstElement).any;
    self.remove($_) for @e;
  }

}
