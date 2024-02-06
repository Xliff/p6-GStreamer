use v6;

use GLib::Raw::Exports;
use GIO::Raw::Exports;
use GStreamer::Raw::Exports;

my constant forced = 270;

unit package GStreamer::Raw::Types;

need GLib::Raw::Debug;
need GLib::Raw::Types;
need GLib::Raw::Definitions;
need GLib::Raw::Enums;
need GLib::Raw::Exceptions;
need GLib::Raw::Object;
need GLib::Raw::Structs;
need GLib::Raw::Subs;
need GLib::Raw::Struct_Subs;
need GLib::Roles::Pointers;
need GLib::Roles::Implementor;
need GIO::Raw::Definitions;
need GIO::Raw::Enums;
need GIO::Raw::Quarks;
need GIO::Raw::Structs;
need GIO::Raw::Subs;
need GIO::DBus::Raw::Types;
need GStreamer::Raw::Definitions;
need GStreamer::Raw::Enums;
need GStreamer::Raw::Structs;
need GStreamer::Raw::SDP::Structs;
need GStreamer::Raw::Subs;
need GStreamer::Raw::Audio::Enums;
need GStreamer::Raw::Audio::Structs;
need GStreamer::Raw::Audio::Subs;
need GStreamer::Raw::PBUtils::Enums;
need GStreamer::Raw::PBUtils::Structs;
need GStreamer::Raw::Controller::Structs;

BEGIN {
  glib-re-export($_) for |@glib-exports,
                         |@gio-exports,
                         |@gst-exports;
}