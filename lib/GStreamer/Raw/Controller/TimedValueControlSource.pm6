use v6.c;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Structs;
use GStreamer::Raw::Controller::Structs;

unit package GStreamer::Raw::Controller::TimedValueControlSource;

### /usr/include/gstreamer-1.0/gst/controller/gsttimedvaluecontrolsource.h

sub gst_timed_value_control_source_find_control_point_iter (
  GstTimedValueControlSource $self,
  GstClockTime $timestamp
)
  returns GSequenceIter
  is native(gstreamer-controller)
  is export
{ * }

sub gst_timed_value_control_source_get_all (GstTimedValueControlSource $self)
  returns GList
  is native(gstreamer-controller)
  is export
{ * }

sub gst_timed_value_control_source_get_count (GstTimedValueControlSource $self)
  returns gint
  is native(gstreamer-controller)
  is export
{ * }

sub gst_timed_value_control_source_set (
  GstTimedValueControlSource $self,
  GstClockTime $timestamp,
  gdouble $value
)
  returns uint32
  is native(gstreamer-controller)
  is export
{ * }

sub gst_timed_value_control_source_set_from_list (
  GstTimedValueControlSource $self,
  GSList $timedvalues
)
  returns uint32
  is native(gstreamer-controller)
  is export
{ * }

sub gst_timed_value_control_source_unset (
  GstTimedValueControlSource $self,
  GstClockTime $timestamp
)
  returns uint32
  is native(gstreamer-controller)
  is export
{ * }

sub gst_timed_value_control_source_unset_all (GstTimedValueControlSource $self)
  is native(gstreamer-controller)
  is export
{ * }

sub gst_control_point_copy (GstControlPoint $cp)
  returns GstControlPoint
  is native(gstreamer-controller)
  is export
{ * }

sub gst_control_point_free (GstControlPoint $cp)
  is native(gstreamer-controller)
  is export
{ * }

sub gst_timed_value_control_invalidate_cache (GstTimedValueControlSource $self)
  is native(gstreamer-controller)
  is export
{ * }
