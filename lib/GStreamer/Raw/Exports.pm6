use v6.c;

unit package GStreamer::Raw::Exports;

our @gst-exports is export;

BEGIN {
  @gst-exports = <
    GStreamer::Raw::Definitions
    GStreamer::Raw::Enums
    GStreamer::Raw::Structs
    GStreamer::Raw::SDP::Structs
    GStreamer::Raw::Subs
    GStreamer::Raw::Audio::Enums
    GStreamer::Raw::Audio::Structs
    GStreamer::Raw::Audio::Subs
    GStreamer::Raw::PBUtils::Enums
    GStreamer::Raw::PBUtils::Structs
  >;
}
