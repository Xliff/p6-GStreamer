use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

unit package GStreamer::Raw::Element;

sub gst_element_abort_state (GstElement $element)
  is native(gstreamer)
  is export
{ * }

sub gst_element_add_pad (GstElement $element, GstPad $pad)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_add_property_deep_notify_watch (
  GstElement $element,
  Str $property_name,
  gboolean $include_value
)
  returns gulong
  is native(gstreamer)
  is export
{ * }

sub gst_element_add_property_notify_watch (
  GstElement $element,
  Str $property_name,
  gboolean $include_value
)
  returns gulong
  is native(gstreamer)
  is export
{ * }

sub gst_element_call_async (
  GstElement $element,
  GstElementCallAsyncFunc $func,
  gpointer $user_data,
  GDestroyNotify $destroy_notify
)
  is native(gstreamer)
  is export
{ * }

sub gst_element_change_state (
  GstElement $element,
  guint $transition # GstStateChange $transition
)
  returns guint # GstStateChangeReturn
  is native(gstreamer)
  is export
{ * }

# sub gst_element_class_add_metadata (
#   GstElementClass $klass,
#   Str $key,
#   Str $value
# )
#   is native(gstreamer)
#   is export
# { * }
#
# sub gst_element_class_add_pad_template (
#   GstElementClass $klass,
#   GstPadTemplate $templ
# )
#   is native(gstreamer)
#   is export
# { * }
#
# sub gst_element_class_add_static_metadata (
#   GstElementClass $klass,
#   Str $key,
#   Str $value
# )
#   is native(gstreamer)
#   is export
# { * }
#
# sub gst_element_class_add_static_pad_template (
#   GstElementClass $klass,
#   GstStaticPadTemplate $static_templ
# )
#   is native(gstreamer)
#   is export
# { * }
#
# sub gst_element_class_add_static_pad_template_with_gtype (
#   GstElementClass $klass,
#   GstStaticPadTemplate $static_templ,
#   GType $pad_type
# )
#   is native(gstreamer)
#   is export
# { * }
#
# sub gst_element_class_get_metadata (
#   GstElementClass $klass,
#   Str $key
# )
#   returns Str
#   is native(gstreamer)
#   is export
# { * }
#
# sub gst_element_class_get_pad_template (
#   GstElementClass $element_class,
#   Str $name
# )
#   returns GstPadTemplate
#   is native(gstreamer)
#   is export
# { * }
#
# sub gst_element_class_get_pad_template_list (
#   GstElementClass $element_class
# )
#   returns GList
#   is native(gstreamer)
#   is export
# { * }
#
# sub gst_element_class_set_metadata (
#   GstElementClass $klass,
#   Str $longname,
#   Str $classification,
#   Str $description,
#   Str $author
# )
#   is native(gstreamer)
#   is export
# { * }
#
# sub gst_element_class_set_static_metadata (
#   GstElementClass $klass,
#   Str $longname,
#   Str $classification,
#   Str $description,
#   Str $author
# )
#   is native(gstreamer)
#   is export
# { * }

sub gst_element_continue_state (
  GstElement $element,
  guint $ret # GstStateChangeReturn $ret
)
  returns guint # GstStateChangeReturn
  is native(gstreamer)
  is export
{ * }

sub gst_element_foreach_pad (
  GstElement $element,
  GstElementForeachPadFunc $func,
  gpointer $user_data
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_foreach_sink_pad (
  GstElement $element,
  GstElementForeachPadFunc $func,
  gpointer $user_data
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_foreach_src_pad (
  GstElement $element,
  GstElementForeachPadFunc $func,
  gpointer $user_data
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_get_base_time (GstElement $element)
  returns GstClockTime
  is native(gstreamer)
  is export
{ * }

sub gst_element_get_bus (GstElement $element)
  returns GstBus
  is native(gstreamer)
  is export
{ * }

sub gst_element_get_clock (GstElement $element)
  returns GstClock
  is native(gstreamer)
  is export
{ * }

sub gst_element_get_context (GstElement $element, Str $context_type)
  returns GstContext
  is native(gstreamer)
  is export
{ * }

sub gst_element_get_context_unlocked (GstElement $element, Str $context_type)
  returns GstContext
  is native(gstreamer)
  is export
{ * }

sub gst_element_get_contexts (GstElement $element)
  returns GList
  is native(gstreamer)
  is export
{ * }

sub gst_element_get_factory (GstElement $element)
  returns GstElementFactory
  is native(gstreamer)
  is export
{ * }

sub gst_element_get_metadata (GstElement $element, Str $key)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_element_get_pad_template (GstElement $element, Str $name)
  returns GstPadTemplate
  is native(gstreamer)
  is export
{ * }

sub gst_element_get_pad_template_list (GstElement $element)
  returns GList
  is native(gstreamer)
  is export
{ * }

sub gst_element_get_request_pad (GstElement $element, Str $name)
  returns GstPad
  is native(gstreamer)
  is export
{ * }

sub gst_element_get_start_time (GstElement $element)
  returns GstClockTime
  is native(gstreamer)
  is export
{ * }

sub gst_element_get_state (
  GstElement $element,
  guint $state,   # GstState $state,
  guint $pending, # GstState $pending,
  GstClockTime $timeout
)
  returns guint   # GstStateChangeReturn
  is native(gstreamer)
  is export
{ * }

sub gst_element_get_static_pad (GstElement $element, Str $name)
  returns GstPad
  is native(gstreamer)
  is export
{ * }

sub gst_element_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_element_is_locked_state (GstElement $element)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_iterate_pads (GstElement $element)
  returns GstIterator
  is native(gstreamer)
  is export
{ * }

sub gst_element_iterate_sink_pads (GstElement $element)
  returns GstIterator
  is native(gstreamer)
  is export
{ * }

sub gst_element_iterate_src_pads (GstElement $element)
  returns GstIterator
  is native(gstreamer)
  is export
{ * }

sub gst_element_lost_state (GstElement $element)
  is native(gstreamer)
  is export
{ * }

sub gst_element_message_full (
  GstElement $element,
  guint $type, # GstMessageType $type
  GQuark $domain,
  gint $code,
  Str $text,
  Str $debug,
  Str $file,
  Str $function,
  gint $line
)
  is native(gstreamer)
  is export
{ * }

sub gst_element_message_full_with_details (
  GstElement $element,
  guint $type, # GstMessageType $type
  GQuark $domain,
  gint $code,
  Str $text,
  Str $debug,
  Str $file,
  Str $function,
  gint $line,
  GstStructure $structure
)
  is native(gstreamer)
  is export
{ * }

sub gst_element_no_more_pads (GstElement $element)
  is native(gstreamer)
  is export
{ * }

sub gst_element_post_message (GstElement $element, GstMessage $message)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_provide_clock (GstElement $element)
  returns GstClock
  is native(gstreamer)
  is export
{ * }

sub gst_element_query (GstElement $element, GstQuery $query)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_release_request_pad (GstElement $element, GstPad $pad)
  is native(gstreamer)
  is export
{ * }

sub gst_element_remove_pad (GstElement $element, GstPad $pad)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_remove_property_notify_watch (
  GstElement $element,
  gulong $watch_id
)
  is native(gstreamer)
  is export
{ * }

sub gst_element_request_pad (
  GstElement $element,
  GstPadTemplate $templ,
  Str $name,
  GstCaps $caps
)
  returns GstPad
  is native(gstreamer)
  is export
{ * }

sub gst_element_seek (
  GstElement $element,
  gdouble $rate,
  guint $format,       # GstFormat $format,
  guint $flags,        # GstSeekFlags $flags,
  guint $start_type,   # GstSeekType $start_type,
  gint64 $start,
  guint $stop_type,    # GstSeekType $stop_type,
  gint64 $stop
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_send_event (GstElement $element, GstEvent $event)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_set_base_time (GstElement $element, GstClockTime $time)
  is native(gstreamer)
  is export
{ * }

sub gst_element_set_bus (GstElement $element, GstBus $bus)
  is native(gstreamer)
  is export
{ * }

sub gst_element_set_clock (GstElement $element, GstClock $clock)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_set_context (GstElement $element, GstContext $context)
  is native(gstreamer)
  is export
{ * }

sub gst_element_set_locked_state (GstElement $element, gboolean $locked_state)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_element_set_start_time (GstElement $element, GstClockTime $time)
  is native(gstreamer)
  is export
{ * }

sub gst_element_set_state (
  GstElement $element,
  guint $state # GstState $state
)
  returns guint # GstStateChangeReturn
  is native(gstreamer)
  is export
{ * }

sub gst_element_sync_state_with_parent (GstElement $element)
  returns uint32
  is native(gstreamer)
  is export
{ * }
