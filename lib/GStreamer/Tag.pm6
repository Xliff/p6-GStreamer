use v6.c;

use Method::Also;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::TagList;

class GStreamer::Tag {

  method new (|) {
    warn 'GStreamer::Tag is a static class and does not need instantiation.'
      if $DEBUG;

    GStreamer::Tags;
  }

  method exists (Str() $tag) {
    gst_tag_exists($tag);
  }

  method get_description (Str() $tag) is also<get-description> {
    gst_tag_get_description($tag);
  }

  method get_flag (Str() $tag) is also<get-flag> {
    gst_tag_get_flag($tag);
  }

  method get_nick (Str() $tag) is also<get-nick> {
    gst_tag_get_nick($tag);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_tag_get_type, $n, $t );
  }

  method is_fixed (Str() $tag) is also<is-fixed> {
    so gst_tag_is_fixed($tag);
  }

  method merge_strings_with_comma (GValue() $dest, GValue() $src)
    is also<merge-strings-with-comma>
  {
    gst_tag_merge_strings_with_comma($dest, $src);
  }

  method merge_use_first (GValue() $dest, GValue() $src)
    is also<merge-use-first>
  {
    gst_tag_merge_use_first($dest, $src);
  }

  method register (
    Str() $tag,
    Int() $flag,
    Int() $type,
    Str() $nick,
    Str() $blurb,
    GstTagMergeFunc $func
  ) {
    my GstTagFlag $f = $flag;
    my GType $t = $type;

    gst_tag_register($tag, $f, $t, $nick, $blurb, $func);
  }

  method register_static (
    Str() $tag,
    Int() $flag,
    Int() $type,
    Str() $nick,
    Str() $blurb,
    GstTagMergeFunc $func
  )
    is also<register-static>
  {
    my GstTagFlag $f = $flag;
    my GType $t = $type;

    gst_tag_register_static($tag, $f, $t, $nick, $blurb, $func);
  }

}
