use v6.c;

use NativeCall;


use GStreamer::Raw::Types;

unit package GStreamer::Raw::BufferPool;

sub gst_buffer_pool_acquire_buffer (
  GstBufferPool $pool,
  CArray[Pointer[GstBuffer]] $buffer,
  CArray[Pointer[GstBufferPoolAcquireParams]] $params
)
  returns GstFlowReturn
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_pool_config_add_option (GstStructure $config, Str $option)
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_pool_config_get_allocator (
  GstStructure $config,
  CArray[Pointer[GstAllocator]] $allocator,
  GstAllocationParams $params is rw
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_pool_config_get_option (GstStructure $config, guint $index is rw)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_pool_config_get_params (
  GstStructure $config,
  CArray[Pointer[GstCaps]] $caps,
  guint $size        is rw,
  guint $min_buffers is rw,
  guint $max_buffers is rw
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_pool_config_has_option (GstStructure $config, Str $option)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_pool_config_n_options (GstStructure $config)
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_pool_config_set_allocator (
  GstStructure $config,
  GstAllocator $allocator,
  GstAllocationParams $params
)
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_pool_config_set_params (
  GstStructure $config,
  GstCaps $caps,
  guint $size,
  guint $min_buffers,
  guint $max_buffers
)
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_pool_config_validate_params (
  GstStructure $config,
  GstCaps $caps,
  guint $size,
  guint $min_buffers,
  guint $max_buffers
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_pool_get_config (GstBufferPool $pool)
  returns GstStructure
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_pool_get_options (GstBufferPool $pool)
  returns CArray[Str]
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_pool_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_pool_has_option (GstBufferPool $pool, Str $option)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_pool_is_active (GstBufferPool $pool)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_pool_new ()
  returns GstBufferPool
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_pool_release_buffer (GstBufferPool $pool, GstBuffer $buffer)
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_pool_set_active (GstBufferPool $pool, gboolean $active)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_pool_set_config (GstBufferPool $pool, GstStructure $config)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_pool_set_flushing (GstBufferPool $pool, gboolean $flushing)
  is native(gstreamer)
  is export
{ * }
