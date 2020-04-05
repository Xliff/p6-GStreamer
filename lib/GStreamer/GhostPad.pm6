use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::GhostPad;

use GStreamer::ProxyPad;

our subset GstGhostPadAncestry is export of Mu
  where GstGhostPad | GstProxyPadAncestry;

class GStreamer::GhostPad is GStreamer::ProxyPad {
  has GstGhostPad $!gp;

  submethod BUILD (:$ghostpad) {
    self.setGhostPad($ghostpad);
  }

  method setGhostPad (GstGhostPadAncestry $ghostpad) {
    my $to-parent;

    $!gp = do {
      when GstGhostPad {
        $to-parent = cast(GstProxyPad, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstGhostPad, $_);
      }
    }
    self.setProxyPad($to-parent);
  }

  method GStreamer::Raw::Definitions::GstGhostPad
  { $!gp }

  method new (Str() $name, GstPad() $target) {
    my $ghostpad = gst_ghost_pad_new($name, $target);

    $ghostpad ?? self.bless(:$ghostpad) !! Nil;
  }

  method new_from_template (
    Str() $name,
    GstPad() $target,
    GstPadTemplate() $templ
  ) is also<new-from-template> {
    my $ghostpad = gst_ghost_pad_new_from_template($name, $target, $templ);

    $ghostpad ?? self.bless(:$ghostpad) !! Nil;
  }

  method new_no_target (Str() $name, Int() $dir) is also<new-no-target> {
    my GstPadDirection $d = $dir;
    my $ghostpad = gst_ghost_pad_new_no_target($name, $d);

    $ghostpad ?? self.bless(:$ghostpad) !! Nil;
  }

  method new_no_target_from_template (Str() $name, GstPadTemplate() $templ) is also<new-no-target-from-template> {
    my $ghostpad = gst_ghost_pad_new_no_target_from_template($name, $templ);

    $ghostpad ?? self.bless(:$ghostpad) !! Nil;
  }

  method activate_mode_default (
    GStreamer::GhostPad:U:
    GstPad() $pad,
    GstObject() $parent,
    Int() $mode,
    Int() $active
  ) is also<activate-mode-default> {
    my gboolean $a = $active.so.Int;
    my GstPadMode $m = $mode;

    so gst_ghost_pad_activate_mode_default($pad, $parent, $m, $a);
  }

  method construct {
    so gst_ghost_pad_construct($!gp);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_ghost_pad_get_type, $n, $t );
  }

  method internal_activate_mode_default (
    GStreamer::GhostPad:U:
    GstPad() $pad,
    GstObject() $parent,
    Int() $mode,
    Int() $active
  ) is also<internal-activate-mode-default> {
    my GstPadMode $m = $mode;
    my gboolean $a = $active;

    so gst_ghost_pad_internal_activate_mode_default($pad, $parent, $m, $a);
  }

}
