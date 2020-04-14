use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

use GLib::Roles::Signals::Generic;

role GStreamer::Roles::Signals::Player {
  also does GLib::Roles::Signals::Generic;

  has %!signals-p;

  # GstPlayer, GError, gpointer
  # Move into GLib::Raw::Signals::Generic
  method connect-error (
    $obj,
    $signal = 'error',
    &handler?
  ) {
    my $hid;
    %!signals-p{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-error($obj, $signal,
        -> $, $, $ud {
          CATCH {
            default { $s.note($_) }
          }

          $s.emit( [self, $, $ud ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-p{$signal}[0].tap(&handler) with &handler;
    %!signals-p{$signal}[0];
  }

  # GstPlayer, GstPlayerMediaInfo, gpointer
  method connect-media-info-updated (
    $obj,
    $signal = 'media-info-updated',
    &handler?
  ) {
    my $hid;
    %!signals-p{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-media-info-updated($obj, $signal,
        -> $, $gpmi, $ud {
          CATCH {
            default { $s.note($_) }
          }

          $s.emit( [self, $gpmi, $ud ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-p{$signal}[0].tap(&handler) with &handler;
    %!signals-p{$signal}[0];
  }

}


# GstPlayer, GError, gpointer
sub g-connect-error(
  Pointer $app,
  Str $name,
  &handler (Pointer, GError, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }

# GstPlayer, GstPlayerMediaInfo, gpointer
sub g-connect-media-info-updated(
  Pointer $app,
  Str $name,
  &handler (Pointer, GstPlayerMediaInfo, Pointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }
