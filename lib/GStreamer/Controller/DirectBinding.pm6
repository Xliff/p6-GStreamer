use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;

use GLib::Value;
use GStreamer::ControlBinding;

our subset GstDirectControlBindingAncestry is export of Mu
  where GstDirectControlBinding | GstControlBinding;

class GStreamer::Controller::DirectBinding
  is GStreamer::ControlBinding
{
  has GstDirectControlBinding $!dcb;

  submethod BUILD (:$direct-binding) {
    self.setGstDirectControlBinding($direct-binding);
  }

  method setGstDirectControlBinding (GstDirectControlBindingAncestry $_) {
    my $to-parent;

    $!dcb = do {
      when GstDirectControlBinding {
        $to-parent = cast(GstControlBinding, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstDirectControlBinding, $_);
      }
    }
    self.setGstControlBinding($to-parent);
  }

  method GStreamer::Raw::Structs::GstDirectControlBinding
    is also<GstDirectControlBinding>
  { $!dcb }

  multi method new (GstDirectControlBindingAncestry $direct-binding) {
    $direct-binding ?? self.bless( :$direct-binding ) !! Nil;
  }
  multi method new (
    GstObject()        $object,
    Str()              $property_name,
    GstControlSource() $cs
  ) {
    my $direct-binding = gst_direct_control_binding_new(
      $object,
      $property_name,
      $cs
    );

    $direct-binding ?? self.bless( :$direct-binding ) !! Nil;
  }

  method new_absolute (
    GstObject()        $object,
    Str()              $property_name,
    GstControlSource() $cs
  )
    is also<new-absolute>
  {
    my $direct-binding = gst_direct_control_binding_new_absolute(
      $object,
      $property_name,
      $cs
    );

    $direct-binding ?? self.bless( :$direct-binding ) !! Nil;
  }

    # Type: gboolean
  method absolute is rw  {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('absolute', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv = GLib::Value.new( G_TYPE_BOOLEAN );
        $gv.boolean = $val;
        self.prop_set('absolute', $gv);
      }
    );
  }

  # Type: GstControlSource
  method control-source(:$raw = False) is rw  is also<control_source> {
    my $gv;
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('control-source', $gv)
        );

        my $o = $gv.object;
        return Nil unless $o;

        $o = cast(GstControlSource, $o);
        return $o if $raw;

        GStreamer::ControlSource.new($o);
      },
      STORE => -> $, GstControlSource() $val is copy {
        $gv = GLib::Value.new( GStreamer::ControlSoruce.get_type );
        $gv.object = $val;
        self.prop_set('control-source', $gv);
      }
    );
  }

}

### /usr/include/gstreamer-1.0/gst/controller/gstdirectcontrolbinding.h

sub gst_direct_control_binding_new (
  GstObject        $object,
  Str              $property_name,
  GstControlSource $cs
)
  returns GstDirectControlBinding
  is      native(gstreamer-controller)
  is      export
{ * }

sub gst_direct_control_binding_new_absolute (
  GstObject        $object,
  Str              $property_name,
  GstControlSource $cs
)
  returns GstDirectControlBinding
  is      native(gstreamer-controller)
  is      export
{ * }
