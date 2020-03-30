use v6.c;

unit package GStreamer::Raw::Exports;

our @gst-exports is export;

BEGIN {
  @gst-exports = <
    GStreamer::Raw::Definitions
    GStreamer::Raw::Enums
    GStreamer::Raw::Structs
    GStreamer::Raw::Subs
  >;
}
