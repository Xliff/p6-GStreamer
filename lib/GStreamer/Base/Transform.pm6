use v6.c;

use NativeCall;
use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Base::Transform;

use GStreamer::Allocator;
use GStreamer::BufferPool;
use GStreamer::Element;

our subset GstBaseTransformAncestry is export of Mu
  where GstBaseTransform | GstElementAncestry;

class GStreamer::Base::Transform is GStreamer::Element {
  has GstBaseTransform $!bt;

  submethod BUILD ( :$base-src ) {
    self.setGstBaseTransform($base-src) if $base-src
  }

  method setGstBaseTransform (GstBaseTransformAncestry $_) {
    my $to-parent;

    $!bt = do {
      when GstBaseTransform {
        $to-parent = cast(GstElement, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstBaseTransform, $_);
      }
    }
    self.setGstElement($to-parent);
  }

  method GStreamer::Raw::Structs::GstBaseTransform
    is also<GstBaseTransform>
  { $!bt }

  method new (GstBaseTransformAncestry $base-src) {
    $base-src ?? self.bless( :$base-src ) !! Nil;
  }

  method qos is rw {
    Proxy.new:
      FETCH => -> $           { self.is_qos_enabled },
      STORE => -> $, Int() $e { self.set_qos_enabled($e) };
  }

  proto method get_allocator (|)
    is also<get-allocator>
  { * }

  multi method get_allocator ( :$raw = False, :$enum = True ) {
    samewith($, $, :$raw, :$enum);
  }
  multi method get_allocator (
     $allocator is rw,
     $params    is rw,
    :$raw              = False,
    :$enum             = True;
  ) {
    my $p  = GstAllocationParams.new;
    my $aa = newCArray(GstAllocator);

    gst_base_transform_get_allocator($!bt, $aa, $p);
    $aa = propReturnObject(
      ppr($aa),
      $raw,
      |GStreamer::Allocator.getTypePair
    );
    $p = propReturnObject(
      cast( GstAllocationParams, Pointer.new($p) ),
      $raw,
      |GStreamer::Allocation::Params.getTypePair
    );

    ($allocator, $params) = ($aa, $p);
  }

  method get_buffer_pool (:$raw = False) is also<get-buffer-pool> {
    propReturnObject(
      gst_base_transform_get_buffer_pool($!bt),
      $raw,
      |GStreamer::BufferPool.getTypePair
    );
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_base_transform_get_type, $n, $t );
  }

  method is_in_place is also<is-in-place> {
    so gst_base_transform_is_in_place($!bt);
  }

  method is_passthrough is also<is-passthrough> {
    so gst_base_transform_is_passthrough($!bt);
  }

  method is_qos_enabled is also<is-qos-enabled> {
    so gst_base_transform_is_qos_enabled($!bt);
  }

  method reconfigure_sink is also<reconfigure-sink> {
    gst_base_transform_reconfigure_sink($!bt);
  }

  method reconfigure_src is also<reconfigure-src> {
    gst_base_transform_reconfigure_src($!bt);
  }

  method set_gap_aware (Int() $gap_aware) is also<set-gap-aware> {
    my gboolean $g = $gap_aware.so.Int;

    gst_base_transform_set_gap_aware($!bt, $g);
  }

  method set_in_place (Int() $in_place) is also<set-in-place> {
    my gboolean $i = $in_place.so.Int;

    gst_base_transform_set_in_place($!bt, $i);
  }

  method set_passthrough (Int() $passthrough) is also<set-passthrough> {
    my gboolean $p = $passthrough.so.Int;

    gst_base_transform_set_passthrough($!bt, $p);
  }

  method set_prefer_passthrough (Int() $prefer_passthrough)
    is also<set-prefer-passthrough>
  {
    my gboolean $p = $prefer_passthrough.so.Int;

    gst_base_transform_set_prefer_passthrough($!bt, $p);
  }

  method set_qos_enabled (Int() $enabled) is also<set-qos-enabled> {
    my gboolean $e = $enabled.so.Int;

    gst_base_transform_set_qos_enabled($!bt, $e);
  }

  method update_qos (
    Num() $proportion,
    Int() $diff,
    Int() $timestamp
  )
    is also<update-qos>
  {
    my gdouble          $p = $proportion;
    my GstClockTimeDiff $d = $diff;
    my GstClockTime     $t = $timestamp;

    gst_base_transform_update_qos($!bt, $p, $d, $t);
  }

  method update_src_caps (GstCaps() $updated_caps) is also<update-src-caps> {
    gst_base_transform_update_src_caps($!bt, $updated_caps);
  }

}
