use v6.c;

use NativeCall;

use GStreamer::Raw::Types;
use GStreamer::Raw::Meta;

use GLib::Roles::StaticClass;

class GStreamer::Meta {
  has GstMeta $!m;

  submethod BUILD (:$meta) {
    $!m = $meta;
  }

  method GStreamer::Raw::Structs::GstMeta
  { $!m }

  method new (GstMeta $meta) {
    $meta ?? self.bless( :$meta ) !! Nil;
  }

  method compare_seqnum (GstMeta() $meta2) {
    gst_meta_compare_seqnum($!m, $meta2);
  }

  method get_info (
    GStreamer::Meta:U:
    Str() $impl
  ) {
    gst_meta_get_info($impl);
  }

  method get_seqnum {
    gst_meta_get_seqnum($!m);
  }

  method register (
    GStreamer::Meta:U:
    Int() $api,
    Str() $impl,
    Int() $size,
    :&init_func      = Callable,
    :&free_func      = Callable,
    :&transform_func = Callable,
    :$raw = False
  ) {
    my GType $a = $api;
    my gsize $s = $size;

    gst_meta_register(
      $a,
      $impl,
      $s,
      &init_func,
      &free_func,
      &transform_func
    );
  }

}

class GStreamer::Meta::API {
  also does GLib::Roles::StaticClass;

  method get_tags (Int() $api) {
    my GType $a = $api;
    my $saa = gst_meta_api_type_get_tags($a);

    return Nil unless $saa[0];
    CStringArrayToArray($saa[0]);
  }

  method has_tag (Int() $api, GQuark $tag) {
    my GType $a = $api;

    gst_meta_api_type_has_tag($a, $tag);
  }

  multi method register (Str() $api, @tags) {
    samewith( $api, ArrayToCArray(Str, @tags) )
  }
  multi method register (Str() $api, CArray[Str] $tags) {
    gst_meta_api_type_register($api, $tags);
  }

}
