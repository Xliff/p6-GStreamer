use v6.c;

use NativeCall;

use GLib::Raw::ReturnedValue;
use GStreamer::Raw::Types;

role GStreamer::Roles::Signals::Bin {
  has %!signals-b;

  # GstBin, GstBin, GstElement, gpointer
  method connect-deep-element (
    $obj,
    $signal,
    &handler?
  ) {
    my $hid;
    %!signals-b{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-deep-element($obj, $signal,
        -> $, $gbn, $get, $ud  {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $gbn, $get, $ud] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-b{$signal}[0].tap(&handler) with &handler;
    %!signals-b{$signal}[0];
  }

  # GstBin, GstElement, gpointer
  method connect-element (
    $obj,
    $signal,
    &handler?
  ) {
    my $hid;
    %!signals-b{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-element($obj, $signal,
        -> $, $ge, $ud  {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $ge, $ud] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-b{$signal}[0].tap(&handler) with &handler;
    %!signals-b{$signal}[0];
  }

  # GstBin, GstMessage
  method connect-handle-message (
    $obj,
    $signal = 'connect-handle-message',
    &handler?
  ) {
    my $hid;
    %!signals-b{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-handle-message($obj, $signal,
        -> $, $gm {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $gm] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-b{$signal}[0].tap(&handler) with &handler;
    %!signals-b{$signal}[0];
  }

  # GstBin, GstElement --> gboolean
  method connect-remove-element (
    $obj,
    $signal = 'connect-remove-element',
    &handler?
  ) {
    my $hid;
    %!signals-b{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-remove-element($obj, $signal,
        -> $, $ge {
          CATCH {
            default { 𝒮.note($_) }
          }

          my $r = ReturnedValue.new;
          𝒮.emit( [self, $ge, $r] );
          $r.r;
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-b{$signal}[0].tap(&handler) with &handler;
    %!signals-b{$signal}[0];
  }

}


# GstBin, GstBin, GstElement, gpointer
sub g-connect-deep-element(
  Pointer $app,
  Str $name,
  &handler (GstBin, GstBin, GstElement, gpointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }

# GstBin, GstElement, gpointer
sub g-connect-element(
  Pointer $app,
  Str $name,
  &handler (GstBin, GstElement, gpointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }

# GstBin, GstElement, gpointer
sub g-connect-handle-message(
  Pointer $app,
  Str $name,
  &handler (GstBin, GstMessage),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }

# GstBin, GstElement, gpointer
sub g-connect-remove-element(
  Pointer $app,
  Str $name,
  &handler (GstBin, GstElement --> gboolean),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }
