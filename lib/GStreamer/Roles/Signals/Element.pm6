use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GStreamer::Raw::Types;

use GTK::Roles::Signals::Generic;

role GStreamer::Roles::Signals::Element {
  also does GTK::Roles::Signals::Generic;

  has %!signals-e;

  # GstElement, GstPad, gpointer
  method connect-pad (
    $obj,
    $signal,
    &handler?
  ) {
    my $hid;
    %!signals-e{$signal} //= do {
      my $s = Supplier.new;
      $hid = g-connect-pad($obj, $signal,
        -> $, $gp, $ud {
          CATCH {
            default { $s.quit($_) }
          }

          $s.emit( [self, $gp, $ud ] );
        },
        Pointer, 0
      );
      [ $s.Supply, $obj, $hid ];
    };
    %!signals-e{$signal}[0].tap(&handler) with &handler;
    %!signals-e{$signal}[0];
  }

}

# GstElement, GstPad, gpointer
sub g-connect-pad(
  Pointer $app,
  Str $name,
  &handler (Pointer, GstPad, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native('gobject-2.0')
  is symbol('g_signal_connect_object')
  { * }
