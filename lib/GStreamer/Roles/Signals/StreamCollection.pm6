use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

role GStreamer::Roles::Signals::StreamCollection {
  has %!signals-sc;

  # GstStreamCollection, GstStream, GParamSpec, gpointer
  method connect-stream-notify (
    $obj,
    $signal = 'stream-notify',
    &handler?
  ) {
    my $hid;
    %!signals-sc{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-stream-notify($obj, $signal,
        -> $, $gsm, $g, $gr   {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $gsm, $g, $gr ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-sc{$signal}[0].tap(&handler) with &handler;
    %!signals-sc{$signal}[0];
  }
}

# GstStreamCollection, GstStream, GParamSpec, gpointer
sub g-connect-stream-notify(
  Pointer $app,
  Str $name,
  &handler (GstStreamCollection, GstStream, GParamSpec, gpointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }
