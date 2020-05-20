use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Structs;

use GLib::Roles::Pointers;

unit package GStreamer::Raw::Controller::Structs;

class GstControlPoint            is repr<CStruct>     does GLib::Roles::Pointers is export {
  # fields from GstTimedValue. DO NOT CHANGE!
  has GstClockTime $.timestamp;
  has gdouble      $.value;

  # Caches for the interpolators
  # union {
  #   struct { /* 16 bytes */
  #     gdouble h;
  #     gdouble z;
  #   } cubic;
  #   struct { /* 24 bytes */
  #     gdouble c1s, c2s, c3s;
  #   } cubic_monotonic;
  #   guint8 _gst_reserved[64];
  # } cache;
  HAS guint        @!reserved[64] is CArray;

  # cw: Next question - Was it allocated by Raku or C? Does it matter?
  method free { gst_control_point_free(self) }

  sub gst_control_point_free (GstControlPoint)
    is native(gstreamer-controller)
  { * }

}

class GstTimedValueControlSource is repr<CStruct>     does GLib::Roles::Pointers is export {
  HAS GstControlSource $.parent;
  # Protected
  HAS GMutex           $.lock;
  has GSequence        $.values;         #= List of GstControlPoint
  has gint             $.nvalues;        #= Number of control points
  has gboolean         $.valid_cache;
  # Private
  has Pointer          $!priv;           #= GstTimedValueControlSourcePrivate
  HAS GstPadding       $!padding
}
