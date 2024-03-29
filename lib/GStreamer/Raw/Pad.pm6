use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

unit package GStreamer::Raw::Pad;

sub gst_pad_activate_mode (
  GstPad   $pad,
  guint    $mode,                   # GstPadMode $mode,
  gboolean $active
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_add_probe (
  GstPad              $pad,
  guint               $mask,                   # GstPadProbeType $mask,
  GstPadProbeCallback $callback,
  gpointer            $user_data,
  GDestroyNotify      $destroy_data
)
  returns gulong
  is native(gstreamer)
  is export
{ * }

sub gst_pad_can_link (GstPad $srcpad, GstPad $sinkpad)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_chain (GstPad $pad, GstBuffer $buffer)
  returns GstFlowReturn
  is native(gstreamer)
  is export
{ * }

sub gst_pad_chain_list (GstPad $pad, GstBufferList $list)
  returns GstFlowReturn
  is native(gstreamer)
  is export
{ * }

sub gst_pad_check_reconfigure (GstPad $pad)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_create_stream_id (
  GstPad     $pad,
  GstElement $parent,
  Str        $stream_id
)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_pad_event_default (GstPad $pad, GstObject $parent, GstEvent $event)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_forward (
  GstPad $pad,
  GstPadForwardFunction $forward,
  gpointer $user_data
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_get_allowed_caps (GstPad $pad)
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

sub gst_pad_get_current_caps (GstPad $pad)
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

sub gst_pad_get_direction (GstPad $pad)
  returns GstPadDirection
  is native(gstreamer)
  is export
{ * }

sub gst_pad_get_last_flow_return (GstPad $pad)
  returns GstFlowReturn
  is native(gstreamer)
  is export
{ * }

sub gst_pad_get_pad_template (GstPad $pad)
  returns GstPadTemplate
  is native(gstreamer)
  is export
{ * }

sub gst_pad_get_pad_template_caps (GstPad $pad)
  returns GstCaps
  is native(gstreamer)
  is export
{ * }

sub gst_pad_get_parent_element (GstPad $pad)
  returns GstElement
  is native(gstreamer)
  is export
{ * }

sub gst_pad_get_peer (GstPad $pad)
  returns GstPad
  is native(gstreamer)
  is export
{ * }

sub gst_pad_get_range (
  GstPad $pad,
  guint64 $offset,
  guint $size,
  GstBuffer $buffer
)
  returns GstFlowReturn
  is native(gstreamer)
  is export
{ * }

sub gst_pad_get_sticky_event (
  GstPad $pad,
  guint $event_type,             # GstEventType $event_type,
  guint $idx
)
  returns GstEvent
  is native(gstreamer)
  is export
{ * }

sub gst_pad_get_task_state (GstPad $pad)
  returns GstTaskState
  is native(gstreamer)
  is export
{ * }

sub gst_pad_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_flow_get_name (
  GstFlowReturn $ret
)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_flow_to_quark (
  GstFlowReturn $ret
)
  returns GQuark
  is native(gstreamer)
  is export
{ * }

sub gst_pad_has_current_caps (GstPad $pad)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_is_active (GstPad $pad)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_is_blocked (GstPad $pad)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_is_blocking (GstPad $pad)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_is_linked (GstPad $pad)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_iterate_internal_links (GstPad $pad)
  returns GstIterator
  is native(gstreamer)
  is export
{ * }

sub gst_pad_iterate_internal_links_default (GstPad $pad, GstObject $parent)
  returns GstIterator
  is native(gstreamer)
  is export
{ * }

sub gst_pad_link (GstPad $srcpad, GstPad $sinkpad)
  returns GstPadLinkReturn
  is native(gstreamer)
  is export
{ * }

sub gst_pad_link_full (
  GstPad          $srcpad,
  GstPad          $sinkpad,
  GstPadLinkCheck $flags
)
  returns GstPadLinkReturn
  is native(gstreamer)
  is export
{ * }

sub gst_pad_link_get_name (
  GstPadLinkReturn $ret
)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_pad_mark_reconfigure (GstPad $pad)
  is native(gstreamer)
  is export
{ * }

sub gst_pad_mode_get_name (
  GstPadMode $mode
)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_pad_needs_reconfigure (GstPad $pad)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_new (
  Str             $name,
  GstPadDirection $direction
)
  returns GstPad
  is native(gstreamer)
  is export
{ * }

sub gst_pad_new_from_static_template (GstStaticPadTemplate $templ, Str $name)
  returns GstPad
  is native(gstreamer)
  is export
{ * }

sub gst_pad_new_from_template (GstPadTemplate $templ, Str $name)
  returns GstPad
  is native(gstreamer)
  is export
{ * }

sub gst_pad_pause_task (GstPad $pad)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_peer_query (GstPad $pad, GstQuery $query)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_probe_info_get_buffer (GstPadProbeInfo $info)
  returns GstBuffer
  is native(gstreamer)
  is export
{ * }

sub gst_pad_probe_info_get_buffer_list (GstPadProbeInfo $info)
  returns GstBufferList
  is native(gstreamer)
  is export
{ * }

sub gst_pad_probe_info_get_event (GstPadProbeInfo $info)
  returns GstEvent
  is native(gstreamer)
  is export
{ * }

sub gst_pad_probe_info_get_query (GstPadProbeInfo $info)
  returns GstQuery
  is native(gstreamer)
  is export
{ * }

sub gst_pad_pull_range (
  GstPad    $pad,
  guint64   $offset,
  guint     $size,
  GstBuffer $buffer
)
  returns GstFlowReturn
  is native(gstreamer)
  is export
{ * }

sub gst_pad_push (GstPad $pad, GstBuffer $buffer)
  returns GstFlowReturn
  is native(gstreamer)
  is export
{ * }

sub gst_pad_push_event (GstPad $pad, GstEvent $event)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_push_list (GstPad $pad, GstBufferList $list)
  returns GstFlowReturn
  is native(gstreamer)
  is export
{ * }

sub gst_pad_query (GstPad $pad, GstQuery $query)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_query_default (GstPad $pad, GstObject $parent, GstQuery $query)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_remove_probe (GstPad $pad, gulong $id)
  is native(gstreamer)
  is export
{ * }

sub gst_pad_send_event (GstPad $pad, GstEvent $event)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_set_activate_function_full (
  GstPad                 $pad,
                         &activate (GstPad, GstObject --> gboolean),
  gpointer               $user_data,
  GDestroyNotify         $notify
)
  is native(gstreamer)
  is export
{ * }

sub gst_pad_set_activatemode_function_full (
  GstPad   $pad,
           &activatemode (
             GstPad,
             GstObject,
             GstPadMode,
             gboolean
             --> gboolean
           ),
  gpointer $user_data,
           &notify (gpointer)
)
  is native(gstreamer)
  is export
{ * }

sub gst_pad_set_active (GstPad $pad, gboolean $active)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_set_chain_function_full (
  GstPad   $pad,
           &chain (GstPad, GstObject, GstBuffer --> GstFlowReturn),
  gpointer $user_data,
           &notify (gpointer)
)
  is native(gstreamer)
  is export
{ * }

sub gst_pad_set_chain_list_function_full (
  GstPad   $pad,
           &chain (GstPad, GstObject, GstBufferList --> GstFlowReturn),
  gpointer $user_data,
           &notify (gpointer)
)
  is native(gstreamer)
  is export
{ * }

sub gst_pad_set_event_full_function_full (
  GstPad   $pad,
           &event (GstPad, GstObject, GstEvent --> GstFlowReturn),
  gpointer $user_data,
           &notify (gpointer)
)
  is native(gstreamer)
  is export
{ * }

sub gst_pad_set_event_function_full (
  GstPad   $pad,
           &event (GstPad, GstObject, GstEvent --> gboolean),
  gpointer $user_data,
           &notify (gpointer)
)
  is native(gstreamer)
  is export
{ * }

sub gst_pad_set_getrange_function_full (
  GstPad   $pad,
           &get (
            GstPad,
            GstObject,
            gint64,
            guint,
            CArray[Pointer[GstBuffer]]
            --> GstFlowReturn
          ),
  gpointer $user_data,
           &notify (gpointer)
)
  is native(gstreamer)
  is export
{ * }

sub gst_pad_set_iterate_internal_links_function_full (
  GstPad   $pad,
           & (GstPad, GstObject --> GstIterator),
  gpointer $user_data,
           &notify (gpointer)
)
  is native(gstreamer)
  is export
{ * }

sub gst_pad_set_link_function_full (
  GstPad   $pad,
           & (GstPad, GstObject, GstPad --> GstPadLinkReturn),
  gpointer $user_data,
           &notify (gpointer)
)
  is native(gstreamer)
  is export
{ * }

sub gst_pad_set_query_function_full (
  GstPad   $pad,
           & (GstPad, GstObject, GstQuery --> gboolean),
  gpointer $user_data,
           &notify (gpointer)
)
  is native(gstreamer)
  is export
{ * }

sub gst_pad_set_unlink_function_full (
  GstPad   $pad,
           & (GstPad, GstObject),
  gpointer $user_data,
           &notify (gpointer)
)
  is native(gstreamer)
  is export
{ * }

sub gst_pad_start_task (
  GstPad   $pad,
           & (GstTask, GThread, gpointer),
  gpointer $user_data,
           &notify (gpointer)
)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_sticky_events_foreach (
  GstPad   $pad,
           & (GstPad, CArray[Pointer[GstEvent]], gpointer --> gboolean),
  gpointer $user_data
)
  is native(gstreamer)
  is export
{ * }

sub gst_pad_stop_task (GstPad $pad)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_store_sticky_event (GstPad $pad, GstEvent $event)
  returns GstFlowReturn
  is native(gstreamer)
  is export
{ * }

sub gst_pad_unlink (GstPad $srcpad, GstPad $sinkpad)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_pad_get_element_private (GstPad $pad)
  returns Pointer
  is native(gstreamer)
  is export
{ * }

sub gst_pad_get_offset (GstPad $pad)
  returns gint64
  is native(gstreamer)
  is export
{ * }

sub gst_pad_set_element_private (GstPad $pad, gpointer $priv)
  is native(gstreamer)
  is export
{ * }

sub gst_pad_set_offset (GstPad $pad, gint64 $offset)
  is native(gstreamer)
  is export
{ * }
