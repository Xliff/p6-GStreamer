use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

role GStreamer::Roles::Signals::PBUtils::Discoverer {
  has %!signals-d;

  # GstDiscoverer, GstDiscovererInfo, GError, gpointer
  method connect-discovered (
    $obj,
    $signal = 'discovered',
    &handler?
  ) {
    my $hid;
    %!signals-d{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-discovered($obj, $signal,
        -> $, $gdio, $g, $gr   {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $gdio, $g, $gr ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-d{$signal}[0].tap(&handler) with &handler;
    %!signals-d{$signal}[0];
  }

  # GstDiscoverer, GstElement, gpointer
  method connect-source-setup (
    $obj,
    $signal = 'source-setup',
    &handler?
  ) {
    my $hid;
    %!signals-d{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-source-setup($obj, $signal,
        -> $, $get, $gr   {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $get, $gr ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-d{$signal}[0].tap(&handler) with &handler;
    %!signals-d{$signal}[0];
  }

}

# GstDiscoverer, GstDiscovererInfo, GError, gpointer
sub g-connect-discovered(
  Pointer $app,
  Str $name,
  &handler (GstDiscoverer, GstDiscovererInfo, GError, gpointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }


# GstDiscoverer, GstElement, gpointer
sub g-connect-source-setup(
  Pointer $app,
  Str $name,
  &handler (GstDiscoverer, GstElement, gpointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }
