use v6;

use CompUnit::Util :re-export;

use GLib::Raw::Exports;
use GIO::Raw::Exports;
use GStreamer::Raw::Exports;

constant forced = 8;

unit package GStreamer::Raw::Types;

need GLib::Raw::Definitions;
need GLib::Raw::Enums;
need GLib::Raw::Structs;
need GLib::Raw::Struct_Subs;
need GLib::Raw::Subs;
need GIO::Raw::Definitions;
need GIO::Raw::Enums;
need GIO::Raw::Structs;
need GIO::Raw::Subs;
need GIO::DBus::Raw::Types;
need GStreamer::Raw::Definitions;
need GStreamer::Raw::Enums;
need GStreamer::Raw::Structs;
need GStreamer::Raw::Subs;


BEGIN {
  re-export($_) for |@glib-exports,
                    |@gio-exports,
                    |@gst-exports;
}