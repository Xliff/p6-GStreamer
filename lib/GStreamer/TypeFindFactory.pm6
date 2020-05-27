use v6.c;

use GStreamer::Raw::Types;
use GStreamer::Raw::TypeFindFactory;

use GLib::GList;
use GStreamer::Caps;
use GStreamer::PluginFeature;

use GLib::Roles::ListData;

our GstTypeFindFactoryAncestry is export of Mu
  where GstTypeFindFactory | GstPluginFeatureAncestry;

class GStreamer::TypeFindFactory is GStreamer::PluginFeature {
  has GstTypeFindFactory $!tff;

  method call_function (GstTypeFind() $find) {
    gst_type_find_factory_call_function($!tff, $find);
  }

  method get_caps (:$raw = False) {
    my $c = gst_type_find_factory_get_caps($!tff);

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

  method get_extensions {
    CStringArrayToArray( gst_type_find_factory_get_extensions($!tff) );
  }

  method get_list (
    GStreamer::TypeFindFactory:U:
    :$glist = False,
    :$raw = False
  ) {
    my $tffl = gst_type_find_factory_get_list();

    return Nil unless $tffl;
    return $tffl if $glist && $raw;

    $tffl = GLib::GList.new($tffl)
      but GLib::Roles::ListData[GstTypeFindFactory];
    return $tffl if $glist;

    $raw ?? $tffl.Array
         !! $tffl.Array.map({ GStreamer::TypeFindFactory.new($_) });
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_type_find_factory_get_type, $n, $t );
  }

  method has_function {
    so gst_type_find_factory_has_function($!tff);
  }

}
