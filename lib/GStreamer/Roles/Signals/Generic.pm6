use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

role GStreamer::Roles::Signals::Generic {
  has %!signals-gstreamer;

  # CLASS, GstPad, gpointer
  method connect-pad (
    $obj,
    $signal,
    &handler?
  ) {
    my $hid;
    %!signals-gstreamer{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-pad-created($obj, $signal,
        -> $, $gpd, $gr   {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $gpd, $gr ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-gstreamer{$signal}[0].tap(&handler) with &handler;
    %!signals-gstreamer{$signal}[0];
  }

  # CLASS, GstPlugin, gpointer
  method connect-plugin-feature (
    $obj,
    $signal,
    &handler?
  ) {
    my $hid;
    %!signals-gstreamer{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-plugin-feature($obj, $signal,
        -> $, $gpn, $gr   {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $gpn, $gr ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-gstreamer{$signal}[0].tap(&handler) with &handler;
    %!signals-gstreamer{$signal}[0];
  }

}

# GstPadTemplate, GstPad, gpointer
sub g-connect-pad-created (
  Pointer $app,
  Str $name,
  &handler (GstPadTemplate, GstPad, gpointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }

# GstRegistry, GstPlugin, gpointer
sub g-connect-plugin-feature (
  Pointer $app,
  Str $name,
  &handler (GstRegistry, GstPlugin, gpointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }
