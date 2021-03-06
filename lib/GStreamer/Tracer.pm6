use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;

use GStreamer::Object;

use GLib::Roles::Object;

our subset GstTracerAncestry is export of Mu
  where GstTracer | GstObject;

class GStreamer::Tracer is GStreamer::Object {
  has GstTracer $!t;

  submethod BUILD (:$tracer) {
    self.setGstTracer($tracer);
  }

  method setGstTracer (GstTracerAncestry $_) {
    my $to-parent;

    $!t = do {
      when GstTracer {
        $to-parent = cast(GstObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstTracer, $_);
      }
    }
    self.setGstObject($to-parent);
  }

  method GStreamer::Raw::Definitions::GstTracer
    is also<GstTracer>
  { $!t }

  multi method new (GstTracerAncestry $tracer) {
    $tracer ?? self.bless( :$tracer ) !! Nil;
  }
  multi method new {
    my $tracer = cast(
      GstTracer,
      GLib::Roles::Object.new-object-ptr( GStreamer::Tracer.get-type )
    );

    $tracer ?? self.bless( :$tracer ) !! Nil;
  }

  # Type: gchar
  method params is rw  {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('params', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        warn 'params is a construct-only attribute'
      }
    );
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_tracer_get_type, $n, $t );
  }

  method gst_tracing_register_hook (Str() $detail, &func)
    is also<gst-tracing-register-hook>
  {
    gst_tracing_register_hook($!t, $detail, &func);
  }

  method register (
    GStreamer::Tracer:U:
    GstPlugin() $plugin,
    Str() $name,
    Int() $type
  ) {
    my GType $t = $type;

    so gst_tracer_register($plugin, $name, $type);
  }

}


### /usr/include/gstreamer-1.0/gst/gsttracer.h

sub gst_tracer_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_tracing_register_hook (
  GstTracer $tracer,
  Str $detail,
  &func ()
)
  is native(gstreamer)
  is export
{ * }

sub gst_tracer_register (GstPlugin $plugin, Str $name, GType $type)
  returns uint32
  is native(gstreamer)
  is export
{ * }
