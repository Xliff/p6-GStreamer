use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::TypeFindFactory;

use GLib::GList;
use GStreamer::Caps;
use GStreamer::PluginFeature;

use GLib::Roles::ListData;

our subset GstTypeFindFactoryAncestry is export of Mu
  where GstTypeFindFactory | GstPluginFeatureAncestry;

class GStreamer::TypeFindFactory is GStreamer::PluginFeature {
  has GstTypeFindFactory $!tff;

  submethod BUILD (:$find-factory) {
    self.setGstTypeFindFactory($find-factory) if $find-factory;
  }

  method setGstTypeFindFactory (GstTypeFindFactoryAncestry $_) {
    my $to-parent;

    $!tff = do {
      when GstTypeFindFactory {
        $to-parent = cast(GstPluginFeature, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstTypeFindFactory, $_);
      }
    }
    self.setGstPluginFeature($to-parent);
  }

  method GStreamer::Raw::Structs::GstTypeFindFactory
    is also<GstTypeFindFactory>
  { $!tff }

  method new (GstTypeFindFactoryAncestry $find-factory) {
    $find-factory ?? self.bless( :$find-factory ) !! Nil;
  }

  method call_function (GstTypeFind() $find) is also<call-function> {
    gst_type_find_factory_call_function($!tff, $find);
  }

  method get_caps (:$raw = False)
    is also<
      get-caps
      caps
    >
  {
    my $c = gst_type_find_factory_get_caps($!tff);

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

  method get_extensions
    is also<
      get-extensions
      extensions
    >
  {
    CStringArrayToArray( gst_type_find_factory_get_extensions($!tff) );
  }

  method get_list (
    GStreamer::TypeFindFactory:U:
    :$glist = False,
    :$raw = False
  )
    is also<get-list>
  {
    my $tffl = gst_type_find_factory_get_list();

    return Nil unless $tffl;
    return $tffl if $glist && $raw;

    $tffl = GLib::GList.new($tffl)
      but GLib::Roles::ListData[GstTypeFindFactory];
    return $tffl if $glist;

    $raw ?? $tffl.Array
         !! $tffl.Array.map({ GStreamer::TypeFindFactory.new($_) });
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_type_find_factory_get_type, $n, $t );
  }

  method has_function is also<has-function> {
    so gst_type_find_factory_has_function($!tff);
  }

}
