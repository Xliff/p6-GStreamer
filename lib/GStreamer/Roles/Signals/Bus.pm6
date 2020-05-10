use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

role GStreamer::Roles::Signals::Bus {
  has %!signals-b;

  # GstBus, GstMessage, gpointer
  method connect-message (
    $obj,
    $signal = 'message',
    &handler?
  ) {
    my $hid;
    %!signals-b{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-message($obj, $signal,
        -> $, $gme, $gr   {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $gme, $gr ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-b{$signal}[0].tap(&handler) with &handler;
    %!signals-b{$signal}[0];
  }

}

# GstBus, GstMessage, gpointer
sub g-connect-message(
  Pointer $app,
  Str $name,
  &handler (GstBus, GstMessage, gpointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }
