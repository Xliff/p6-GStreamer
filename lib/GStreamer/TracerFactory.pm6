use v6.c;

use Method::Also;

use GStreamer::Raw::Types;

use GStreamer::PluginFeature;

our subset GstTracerFactoryAncestry is export of Mu
  where GstTracerFactory | GstPluginFeatureAncestry;

class GStreamer::TracerFactory is GStreamer::PluginFeature {
  has GstTracerFactory $!tf;

  submethod BUILD (:$tracer-factory) {
    self.setBus($tracer-factory);
  }

  method setBus(GstTracerFactoryAncestry $_) {
    my $to-parent;

    $!tf = do {
      when GstTracerFactory {
        $to-parent = cast(GstPluginFeature, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstTracerFactory, $_);
      }
    }
    self.setGstObject($to-parent);
  }

  method GStreamer::Raw::Definitions::GstTracerFactory
    is also<GstTracerFactory>
  { $!tf }

  multi method new (GstTracerFactoryAncestry $tracer-factory) {
    $tracer-factory ?? self.bless( :$tracer-factory ) !! Nil;
  }

  method get_list (:$glist = False, :$raw = False) is also<get-list> {
    my $tl = gst_tracer_factory_get_list();

    return Nil unless $tl;
    return $tl if     $glist && $raw;

    $tl = GLib::GList.new($tl) but GLib::Roles::ListData[GstTracerFactory];

    $raw ?? $tl.Array
         !! $tl.Array.map({ GStreamer::TracerFactory.new($_) });
  }

  method get_tracer_type is also<get-tracer-type> {
    GTypeEnum( gst_tracer_factory_get_tracer_type($!tf) );
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_tracer_factory_get_type, $n, $t );
  }
}

### /usr/include/gstreamer-1.0/gst/gsttracerfactory.h

sub gst_tracer_factory_get_list ()
  returns GList
  is native(gstreamer)
  is export
{ * }

sub gst_tracer_factory_get_tracer_type (GstTracerFactory $factory)
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_tracer_factory_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }
