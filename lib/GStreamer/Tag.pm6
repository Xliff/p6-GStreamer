use v6.c;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::TagList;
use GStreamer::Raw::Tags;

class GStreamer::Tags {
  
  method new (|) {
    warn 'GStreamer::Tags is a static class and does not need instantiation.'
      if $DEBUG;

    GStreamer::Tags;
  }

  method exists {
    gst_tag_exists($!tl);
  }

  method get_description {
    gst_tag_get_description($!tl);
  }

  method get_flag {
    gst_tag_get_flag($!tl);
  }

  method get_nick {
    gst_tag_get_nick($!tl);
  }

  method get_type {
    gst_tag_get_type();
  }

  method is_fixed {
    gst_tag_is_fixed($!tl);
  }

  method merge_strings_with_comma (GValue $src) {
    gst_tag_merge_strings_with_comma($!tl, $src);
  }

  method merge_use_first (GValue $src) {
    gst_tag_merge_use_first($!tl, $src);
  }

  method register (GstTagFlag $flag, GType $type, Str $nick, Str $blurb, GstTagMergeFunc $func) {
    gst_tag_register($!tl, $flag, $type, $nick, $blurb, $func);
  }

  method register_static (GstTagFlag $flag, GType $type, Str $nick, Str $blurb, GstTagMergeFunc $func) {
    gst_tag_register_static($!tl, $flag, $type, $nick, $blurb, $func);
  }

}
