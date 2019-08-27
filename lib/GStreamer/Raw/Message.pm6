use v6.c;

use GTK::Compat::Types;
use GStreamer::Raw::Types;

unit package GStreamer::Raw::Message;

sub gst_message_add_redirect_entry (
  GstMessage $message,
  Str $location,
  GstTagList $tag_list,
  GstStructure $entry_struct
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_get_num_redirect_entries (GstMessage $message)
  returns gsize
  is native(gstreamer)
  is export
{ * }

sub gst_message_get_structure (GstMessage $message)
  returns GstStructure
  is native(gstreamer)
  is export
{ * }

sub gst_message_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_message_has_name (GstMessage $message, Str $name)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_application (GstObject $src, GstStructure $structure)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_async_done (GstObject $src, GstClockTime $running_time)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_async_start (GstObject $src)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_buffering (GstObject $src, gint $percent)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_clock_lost (GstObject $src, GstClock $clock)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_clock_provide (
  GstObject $src,
  GstClock $clock,
  gboolean $ready
)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_custom (
  guint $type, # GstMessageType $type
  GstObject $src,
  GstStructure $structure
)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_device_added (GstObject $src, GstDevice $device)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_device_changed (
  GstObject $src,
  GstDevice $device,
  GstDevice $changed_device
)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_device_removed (GstObject $src, GstDevice $device)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_duration_changed (GstObject $src)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_element (GstObject $src, GstStructure $structure)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_eos (GstObject $src)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_error (
  GstObject $src,
  GError $error,
  Str $debug
)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_error_with_details (
  GstObject $src,
  GError $error,
  Str $debug,
  GstStructure $details
)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_have_context (GstObject $src, GstContext $context)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_info (
  GstObject $src,
  GError $error,
  Str $debug
)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_info_with_details (
  GstObject $src,
  GError $error,
  Str $debug,
  GstStructure $details
)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_latency (GstObject $src)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_need_context (GstObject $src, Str $context_type)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_new_clock (GstObject $src, GstClock $clock)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_progress (
  GstObject $src,
  guint $type, # GstProgressType $type,
  Str $code,
  Str $text
)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_property_notify (
  GstObject $src,
  Str $property_name,
  GValue $val
)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_qos (
  GstObject $src,
  gboolean $live,
  guint64 $running_time,
  guint64 $stream_time,
  guint64 $timestamp,
  guint64 $duration
)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_redirect (
  GstObject $src,
  Str $location,
  GstTagList $tag_list,
  GstStructure $entry_struct
)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_request_state (GstObject $src, GstState $state)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_reset_time (GstObject $src, GstClockTime $running_time)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_segment_done (
  GstObject $src,
  GstFormat $format,
  gint64 $position
)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_segment_start (
  GstObject $src,
  GstFormat $format,
  gint64 $position
)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_state_changed (
  GstObject $src,
  guint $oldstate,  # GstState $oldstate,
  guint $newstate,  # GstState $newstate,
  guint $pending    # GstState $pending
)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_state_dirty (GstObject $src)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_step_done (
  GstObject $src,
  GstFormat $format,
  guint64 $amount,
  gdouble $rate,
  gboolean $flush,
  gboolean $intermediate,
  guint64 $duration,
  gboolean $eos
)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_step_start (
  GstObject $src,
  gboolean $active,
  GstFormat $format,
  guint64 $amount,
  gdouble $rate,
  gboolean $flush,
  gboolean $intermediate)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_stream_collection (
  GstObject $src,
  GstStreamCollection $collection
)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_stream_start (GstObject $src)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_stream_status (
  GstObject $src,
  GstStreamStatusType $type,
  GstElement $owner
)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_streams_selected (
  GstObject $src,
  GstStreamCollection $collection
)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_structure_change (
  GstObject $src,
  GstStructureChangeType $type,
  GstElement $owner,
  gboolean $busy
)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_tag (GstObject $src, GstTagList $tag_list)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_toc (GstObject $src, GstToc $toc, gboolean $updated)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_warning (
  GstObject $src,
  GError $error,
  Str $debug
)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_new_warning_with_details (
  GstObject $src,
  GError $error,
  Str $debug,
  GstStructure $details
)
  returns GstMessage
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_async_done (
  GstMessage $message,
  GstClockTime $running_time is rw
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_buffering (
  GstMessage $message,
  gint $percent is rw
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_buffering_stats (
  GstMessage $message,
  guint $mode            is rw, # GstBufferingMode $mode,
  gint $avg_in           is rw,
  gint $avg_out          is rw,
  gint64 $buffering_left is rw
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_clock_lost (
  GstMessage $message,
  CArray[Pointer[GstClock]] $clock
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_clock_provide (
  GstMessage $message,
  CArray[Pointer[GstClock]] $clock,
  gboolean $ready is rw
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_context_type (
  GstMessage $message,
  CArray[Str] $context_type
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_device_added (
  GstMessage $message,
  CArray[Pointer[GstDevice]] $device
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_device_changed (
  GstMessage $message,
  CArray[Pointer[GstDevice]] $device,
  CArray[Pointer[GstDevice]] $changed_device
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_device_removed (
  GstMessage $message,
  CArray[Pointer[GstDevice]] $device
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_error (
  GstMessage $message,
  CArray[Pointer[GError]] $gerror,
  CArray[Str] $debug
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_error_details (
  GstMessage $message,
  CArray[Pointer[GstStructure]] $structure
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_group_id (
  GstMessage $message,
  guint $group_id is rw
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_have_context (
  GstMessage $message,
  CArray[Pointer[GstContext]] $context
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_info (
  GstMessage $message,
  CArray[Pointer[GError]] $gerror,
  CArray[Str] $debug
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_info_details (
  GstMessage $message,
  CArray[Pointer[GstStructure]] $structure
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_new_clock (
  GstMessage $message,
  CArray[Pointer[GstClock]] $clock
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_progress (
  GstMessage $message,
  guint $type is rw, # GstProgressType $type,
  CArray[Str] $code,
  CArray[Str] $text
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_property_notify (
  GstMessage $message,
  CArray[GstObject]] $object,
  CArray[Str]] $property_name,
  CArray[GValue]] $property_value
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_qos (
  GstMessage $message,
  gboolean $live        is rw,
  guint64 $running_time is rw,
  guint64 $stream_time  is rw,
  guint64 $timestamp    is rw,
  guint64 $duration     is rw
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_qos_stats (
  GstMessage $message,
  CArray[Pointer[GstFormat]] $format,
  guint64 $processed is rw,
  guint64 $dropped   is rw
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_qos_values (
  GstMessage $message,
  gint64 $jitter      is rw,
  gdouble $proportion is rw,
  gint $quality       is rw
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_redirect_entry (
  GstMessage $message,
  gsize $entry_index is rw,
  CArray[Pointer[Str]] $location,
  CArray[Pointer[GstTagList]] $tag_list,
  CArray[Pointer[GstStructure]] $entry_struct
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_request_state (
  GstMessage $message,
  CArray[Pointer[GstState]] $state
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_reset_time (
  GstMessage $message,
  GstClockTime $running_time is rw
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_segment_done (
  GstMessage $message,
  CArray[Pointer[GstFormat]] $format,
  gint64 $position is rw
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_segment_start (
  GstMessage $message,
  CArray[Pointer[GstFormat]] $format,
  gint64 $position is rw
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_state_changed (
  GstMessage $message,
  guint $oldstate is rw,   # GstState $oldstate,
  guint $newstate is rw,   # GstState $newstate,
  guint $pending  is rw     # GstState $pending
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_step_done (
  GstMessage $message,
  CArray[Pointer[GstFormat]] $format,
  guint64 $amount        is rw,
  gdouble $rate          is rw,
  gboolean $flush        is rw,
  gboolean $intermediate is rw,
  guint64 $duration      is rw,
  gboolean $eos          is rw
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_step_start (
  GstMessage $message,
  gboolean $active       is rw,
  CArray[Pointer[GstFormat]] $format,
  guint64 $amount        is rw,
  gdouble $rate          is rw,
  gboolean $flush        is rw,
  gboolean $intermediate is rw
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_stream_collection (
  GstMessage $message,
  CArray[Pointer[GstStreamCollection]] $collection
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_stream_status (
  GstMessage $message,
  guint $type is rw, # GstStreamStatusType $type,
  CArray[Pointer[GstElement]] $owner
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_streams_selected (
  GstMessage $message,
  CArray[Pointer[GstStreamCollection]] $collection
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_structure_change (
  GstMessage $message,
  guint $type    is rw, # GstStructureChangeType $type,
  CArray[Pointer[GstElement]] $owner,
  gboolean $busy is rw
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_tag (
  GstMessage $message,
  CArray[Pointer[GstTagList]] $tag_list
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_toc (
  GstMessage $message,
  CArray[Pointer[GstToc]] $toc,
  gboolean $updated is rw
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_warning (
  GstMessage $message,
  CArray[Pointer[GError]] $gerror,
  CArray[Str] $debug
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_parse_warning_details (
  GstMessage $message,
  CArray[Pointer[GstStructure]] $structure
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_set_buffering_stats (
  GstMessage $message,
  guint $mode, # GstBufferingMode $mode,
  gint $avg_in,
  gint $avg_out,
  gint64 $buffering_left
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_set_group_id (GstMessage $message, guint $group_id)
  is native(gstreamer)
  is export
{ * }

sub gst_message_set_qos_stats (
  GstMessage $message,
  GstFormat $format,
  guint64 $processed,
  guint64 $dropped
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_set_qos_values (
  GstMessage $message,
  gint64 $jitter,
  gdouble $proportion,
  gint $quality
)
  is native(gstreamer)
  is export
{ * }

sub gst_message_streams_selected_add (GstMessage $message, GstStream $stream)
  is native(gstreamer)
  is export
{ * }

sub gst_message_streams_selected_get_size (GstMessage $message)
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_message_streams_selected_get_stream (GstMessage $message, guint $idx)
  returns GstStream
  is native(gstreamer)
  is export
{ * }

sub gst_message_type_get_name (
  guint $type # GstMessageType $type
)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_message_type_to_quark (
  guint $type # GstMessageType $type
)
  returns GQuark
  is native(gstreamer)
  is export
{ * }

sub gst_message_writable_structure (GstMessage $message)
  returns GstStructure
  is native(gstreamer)
  is export
{ * }

sub gst_message_get_seqnum (GstMessage $message)
  returns guint32
  is native(gstreamer)
  is export
{ * }

sub gst_message_get_stream_status_object (GstMessage $message)
  returns GValue
  is native(gstreamer)
  is export
{ * }

sub gst_message_set_seqnum (GstMessage $message, guint32 $seqnum)
  is native(gstreamer)
  is export
{ * }

sub gst_message_set_stream_status_object (GstMessage $message, GValue $object)
  is native(gstreamer)
  is export
{ * }
