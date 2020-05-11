use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

role GStreamer::Roles::Signals::Video::ColorBalance {
  has %!signals-cb;

  # GstColorBalance, GstColorBalanceChannel, gint, gpointer
  method connect-value-changed (
    $obj,
    $signal = 'value-changed',
    &handler?
  ) {
    my $hid;
    %!signals-cb{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-value-changed($obj, $signal,
        -> $, $gcbcl, $gt, $gr   {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $gcbcl, $gt, $gr ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-cb{$signal}[0].tap(&handler) with &handler;
    %!signals-cb{$signal}[0];
  }

}


# GstColorBalance, GstColorBalanceChannel, gint, gpointer
sub g-connect-value-changed(
  Pointer $app,
  Str $name,
  &handler (GstColorBalance, GstColorBalanceChannel, gint, gpointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }
