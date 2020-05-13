use v6.c;

use NativeCall;

use GLib::Raw::ReturnedValue;
use GStreamer::Raw::Types;

use GLib::Roles::Signals::Generic;

role GStreamer::App::Roles::Signals::Sink {
  also does GLib::Roles::Signals::Generic;

  has %!signals-as;

  # GstAppSink, gpointer --> GstFlowReturn
  method connect-rGstFlowReturn (
    $obj,
    $signal,
    &handler?
  ) {
    my $hid;
    %!signals-as{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-rGstFlowReturn($obj, $signal,
        -> $, $gr --> GstFlowReturn {
          CATCH {
            default { 𝒮.note($_) }
          }

          my $r = ReturnedValue.new;
          𝒮.emit( [self, $gr, $r] );
          $r.r;
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-as{$signal}[0].tap(&handler) with &handler;
    %!signals-as{$signal}[0];
  }

  # GstAppSink, gpointer --> GstSample
  method connect-rGstSample (
    $obj,
    $signal,
    &handler?
  ) {
    my $hid;
    %!signals-as{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-rGstSample($obj, $signal,
        -> $, $gr  --> GstSample {
          CATCH {
            default { 𝒮.note($_) }
          }

          my $r = ReturnedValue.new;
          𝒮.emit( [self, $gr, $r] );
          $r.r;
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-as{$signal}[0].tap(&handler) with &handler;
  }

  # GstAppSink, guint64, gpointer --> GstSample
  method connect-long-rGstSample (
    $obj,
    $signal,
    &handler?
  ) {
    my $hid;
    %!signals-as{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-long-rGstSample($obj, $signal,
        -> $, $gt, $gr --> GstSample {
          CATCH {
            default { 𝒮.note($_) }
          }

          my $r = ReturnedValue.new;
          𝒮.emit( [self, $gt, $gr, $r] );
          $r.r;
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-as{$signal}[0].tap(&handler) with &handler;
    %!signals-as{$signal}[0];
  }

}

# GstAppSink, gpointer --> GstFlowReturn
sub g-connect-rGstFlowReturn(
  Pointer $app,
  Str $name,
  &handler (GstAppSink, gpointer --> GstFlowReturn),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }

# GstAppSink, gpointer --> GstSample
sub g-connect-rGstSample(
  Pointer $app,
  Str $name,
  &handler (GstAppSink, gpointer --> GstSample),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }

# GstAppSink, guint64, gpointer --> GstSample
sub g-connect-long-rGstSample (
  Pointer $app,
  Str $name,
  &handler (GstAppSink, guint64, gpointer --> GstSample),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }
