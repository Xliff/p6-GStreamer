use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Subs;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::BufferPool;

use GStreamer::Object;

our subset BufferPoolAncestry is export of Mu
  where GstBufferPool | GstObject;

class GStreamer::BufferPool is GStreamer::Object {
  has GstBufferPool $!bp;

  submethod BUILD (:$pool) {
    self.setBufferPool($pool);
  }

  method setBufferPool(BufferPoolAncestry $_) {
    my $to-parent;

    $!bp = do {
      when GstBufferPool {
        $to-parent = cast(GstObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstBufferPool, $_);
      }
    }
    self.setGstObject($to-parent);
  }

  method GStreamer::Raw::Types::GstBufferPool
    is also<GstBufferPool>
  { $!bp }

  method new {
    self.bless( pool => gst_buffer_pool_new() );
  }

  method acquire_buffer (
    $buffer is rw,
    $params is rw
  )
    is also<acquire-buffer>
  {
    my $pa = CArray[Pointer[GstBufferPoolAcquireParams]].new;
    my $ba = CArray[Pointer[GstBuffer]].new;

    $ba[0] = Pointer[GstBuffer].new;
    $pa[0] = Pointer[GstBufferPoolAcquireParams].new;
    my $retVal = GstFlowReturnEnum(
      gst_buffer_pool_acquire_buffer($!bp, $ba, $pa)
    );
    ($buffer, $params) = ppr($ba, $pa);
    ($buffer, $params, $retVal);
  }

  method get_options is also<get-options> {
    gst_buffer_pool_get_options($!bp);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_buffer_pool_get_type, $n, $t );
  }

  method has_option (Str() $option) is also<has-option> {
    so gst_buffer_pool_has_option($!bp, $option);
  }

  method is_active is also<is-active> {
    so gst_buffer_pool_is_active($!bp);
  }

  method release_buffer (GstBuffer() $buffer) is also<release-buffer> {
    gst_buffer_pool_release_buffer($!bp, $buffer);
  }

  method set_active (Int() $active) is also<set-active> {
    my guint $a = $active;

    gst_buffer_pool_set_active($!bp, $a);
  }

  method set_flushing (Int() $flushing) is also<set-flushing> {
    my guint $f = $flushing;

    gst_buffer_pool_set_flushing($!bp, $f);
  }

}

class GStreamer::BufferPoolConfig {

  method new (|) {
    warn 'GStreamer::BufferPoolConfig is a static class and needs no instantiation'
      if $DEBUG;

    GStreamer::BufferPoolConfig;
  }

  method add_option (GstStructure() $s, Str() $option) is also<add-option> {
    gst_buffer_pool_config_add_option($s, $option);
  }

  method get_allocator (
    GstStructure() $s,
    $allocator is rw,
    $params    is rw,
    :$raw = False
  )
    is also<get-allocator>
  {
    my $aa = CArray[Pointer[GstAllocator]];
    my GstAllocationParams $p = 0;

    $aa = Pointer[GstAllocator].new;
    my $rc = gst_buffer_pool_config_get_allocator($s, $aa, $p);

    do if $rc {
      ($allocator, $params) = ppr($aa, $params);
      $allocator = GStreamer::Allocator.new($aa) unless $raw;
      ($allocator, $params, $rc);
    } else {
      Nil xx 3;
    }
  }

  method get_option (GstStructure() $s, Int() $index) is also<get-option> {
    my guint $i = $index;

    gst_buffer_pool_config_get_option($s, $i);
  }

  method get_params (
    GstStructure() $s,
    $caps        is rw,
    $size        is rw,
    $min_buffers is rw,
    $max_buffers is rw,
    :$raw = False;
  )
    is also<get-params>
  {
    my guint ($sz, $mnb, $mxb) = 0 xx 3;
    my $ca = CArray[Pointer[GstCaps]].new;

    $ca[0] = Pointer[GstCaps].new;
    my $rc = gst_buffer_pool_config_get_params($s, $ca, $sz, $mnb, $mxb);

    do if $rc {
      ($caps ,$size ,$min_buffers ,$max_buffers) = ppr($ca, $sz, $mnb, $mxb);
      $caps = GStreamer.Caps.new($caps) unless $raw;
      ($caps ,$size ,$min_buffers ,$max_buffers, $rc);
    } else {
      Nil xx 5;
    }
  }

  method has_option (GstStructure() $s, Str() $option) is also<has-option> {
    so gst_buffer_pool_config_has_option($s, $option);
  }

  method n_options (GstStructure() $s) is also<n-options> {
    gst_buffer_pool_config_n_options($s);
  }

  method set_allocator (
    GstStructure() $s,
    GstAllocator() $allocator,
    Int() $params
  )
    is also<set-allocator>
  {
    my GstAllocationParams $p = $params;

    gst_buffer_pool_config_set_allocator($s, $allocator, $p);
  }

  method set_params (
    GstStructure() $s,
    GstCaps() $caps,
    Int() $size,
    Int() $min_buffers,
    Int() $max_buffers
  )
    is also<set-params>
  {
    my guint ($sz, $mnb, $mxb) = ($size, $min_buffers, $max_buffers);

    gst_buffer_pool_config_set_params($s, $caps, $sz, $mnb, $mxb);
  }

  method validate_params (
    GstStructure() $s,
    GstCaps() $caps,
    Int() $size,
    Int() $min_buffers,
    Int() $max_buffers
  )
    is also<validate-params>
  {
    my guint ($sz, $mnb, $mxb) = ($size, $min_buffers, $max_buffers);

    so gst_buffer_pool_config_validate_params($s, $caps, $sz, $mnb, $mxb);
  }

}
