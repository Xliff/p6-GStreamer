use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

role GStreamer::Roles::Signals::Object {
  has %!signals-gst-o;

  # GstObject, GstObject, GParamSpec, gpointer
  method connect-deep-notify (
    $obj,
    $signal = 'deep-notify',
    &handler?
  ) {
    my $hid;
    %!signals-gst-o{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-deep-notify($obj, $signal,
        -> $, $got, $gp, $gr {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $got, $gp, $gr ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-gst-o{$signal}[0].tap(&handler) with &handler;
    %!signals-gst-o{$signal}[0];
  }

}

# GstObject, GstObject, GParamSpec, gpointer
sub g-connect-deep-notify(
  Pointer $app,
  Str $name,
  &handler (GstObject, GstObject, GParamSpec, gpointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }
