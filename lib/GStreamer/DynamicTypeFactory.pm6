use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;

use GStreamer::PluginFeature;

our subset GstDynamicTypeFactoryAncestry is export of Mu
  where GstDynamicTypeFactory | GstPluginFeatureAncestry;

class GStreamer::DynamicTypeFactory is GStreamer::PluginFeature {
  has GstDynamicTypeFactory $!dtf;

  submethod BUILD (:$factory) {
    self.setGstDynamicTypeFactory($factory);
  }

  method setGstDynamicTypeFactory (GstDynamicTypeFactoryAncestry $_) {
    my $to-parent;

    $!dtf = do {
      when GstDynamicTypeFactory {
        $to-parent = cast(GstPluginFeature, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstDynamicTypeFactory, $_);
      }
    }
    self.setGstPluginFeature($to-parent);
  }

  method GStreamer::Raw::Definitions::GstDynamicTypeFactory
    is also<GstDynamicTypeFactory>
  { $!dtf }

  method new (GstDynamicTypeFactory $factory) {
    $factory ?? self.bless( :$factory ) !! Nil;
  }

  method load (Str() $name) {
    GTypeEnum( gst_dynamic_type_factory_load($name) );
  }

  method gst_dynamic_type_register (
    GstPlugin() $plugin,
    Int() $type
  )
    is also<gst-dynamic-type-register>
  {
    my GType $t = $type;

    gst_dynamic_type_register($plugin, $t);
  }

}


### /usr/include/gstreamer-1.0/gst/gstdynamictypefactory.h

sub gst_dynamic_type_factory_load (Str $factoryname)
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_dynamic_type_register (GstPlugin $plugin, GType $type)
  returns uint32
  is native(gstreamer)
  is export
{ * }
