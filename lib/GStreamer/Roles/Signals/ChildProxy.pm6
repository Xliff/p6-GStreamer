use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

role GStreamer::Roles::Signals::ChildProxy {
  has %signals-cp;

  # GstChildProxy, GObject, gchar, gpointer
  method connect-child (
    $obj,
    $signal,
    &handler?
  ) {
    my $hid;
    %!signals-cp{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-child($obj, $signal,
        -> $, $g, $gr1, $gr2   {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $g, $gr1, $gr2 ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-cp{$signal}[0].tap(&handler) with &handler;
    %!signals-cp{$signal}[0];
  }
}

# GstChildProxy, GObject, gchar, gpointer
sub g-connect-child(
  Pointer $app,
  Str $name,
  &handler (GstChildProxy, GObject, Str, gpointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }
