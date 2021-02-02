use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Object;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Structs;
use GStreamer::Raw::Audio::Structs;

use GLib::Roles::Pointers;

unit package GStreamer::Raw::PBUtils::Structs;

class GstAudioVisualizer         is repr<CStruct>     does GLib::Roles::Pointers is export {
  HAS GstElement      $.parent;
  has guint           $.req_spf is rw;  #= min samples per frame wanted by the subclass */
  HAS GstVideoInfo    $.vinfo;          #= video state
  HAS GstAudioInfo    $.ainfo;          #= audio state
  has Pointer         $!priv;
}

class GstDiscoverer              is repr<CStruct>     does GLib::Roles::Pointers is export {
  HAS GObject    $.parent;
  has Pointer    $!priv;
  HAS Pointer    @!reserved[GST_PADDING] is CArray;
}
