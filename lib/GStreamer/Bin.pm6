use v6.c;

use Method::Also;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::Bin;

use GStreamer::Element;

use GStreamer::Roles::ChildProxy;

our subset BinAncestry is export of Mu
  where GstBin | GstChildProxy | ElementAncestry;

class GStreamer::Bin is GStreamer::Element {
  also does GStreamer::Roles::ChildProxy;

  has GstBin $!b;

  submethod BUILD (:$bin) {
    self.setBin($bin);
  }

  method setBin(BinAncestry $_) {
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
  }

  method GStreamer::Raw::Types::GstBin
    is also<GstBin>
  { $!b }

  multi method new (GstBin $bin) {
    self.bless( :$bin );
  }
  multi method new (Str() $name) {
    self.bless( bin => gst_bin_new($name) );
  }

  method suppressed_flags is rw is also<suppressed-flags> {
    Proxy.new(
      FETCH => sub ($) {
        GstElementFlags( gst_bin_get_suppressed_flags($!b) );
      },
      STORE => sub ($, Int() $flags is copy) {
        gst_bin_set_suppressed_flags($!b, $flags);
      }
    );
  }

  method add (GstElement() $element) {
    gst_bin_add($!b, $element);
  }

  method add_many (*@e) is also<add-many> {
    my $dieMsg = qq:to/DIE/.&nocr;
      Items passed to GStreamer::Bin.add_many must be GStreamer::Element
      compatible!
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
    my $dieMsg = qq:to/DIE/.&nocr;
      Items passed to GStreamer::Bin.remove_many must be GStreamer::Element
      compatible!
      DIE

    die $dieMsg unless @e.all ~~ (GStreamer::Element, GstElement).any;
    self.remove($_) for @e;
  }

}
