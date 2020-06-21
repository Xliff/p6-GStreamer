use v6.c;

use NativeCall;

use GLib::Raw::ReturnedValue;

use GStreamer::Raw::Types;

role GSteramer::App::Roles::Src {
  has %!signals-app;

  # GstAppSrc, gpointer --> GstFlowReturn
  method connect-end-of-stream (
    $obj,
    $signal = 'end-of-stream',
    &handler?
  ) {
    my $hid;
    %!signals-app{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-end-of-stream($obj, $signal,
        -> $, $ud --> GstFlowReturn {
          CATCH {
            default { 𝒮.note($_) }
          }

          my $r = ReturnedValue.new;
          𝒮.emit( [self, $ud, $r] );
          $r.r;
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-app{$signal}[0].tap(&handler) with &handler;
    %!signals-app{$signal}[0];
  }

  # gpointer --> GstAppSrc
  method connect-enough-data (
    $obj,
    $signal = 'enough-data',
    &handler?
  ) {
    my $hid;
    %!signals-app{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-enough-data($obj, $signal,
        -> $, $ud --> GstAppSrc {
          CATCH {
            default { 𝒮.note($_) }
          }

          my $r = ReturnedValue.new;
          𝒮.emit( [self, $ud, $r] );
          $r.r;
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-app{$signal}[0].tap(&handler) with &handler;
    %!signals-app{$signal}[0];
  }

  # guint, gpointer --> GstAppSrc
  method connect-need-data (
    $obj,
    $signal = 'need-data',
    &handler?
  ) {
    my $hid;
    %!signals-app{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-need-data($obj, $signal,
        -> $, $ud --> GstAppSrc {
          CATCH {
            default { 𝒮.note($_) }
          }

          my $r = ReturnedValue.new;
          𝒮.emit( [self, $ud, $r] );
          $r.r;
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-app{$signal}[0].tap(&handler) with &handler;
    %!signals-app{$signal}[0];
  }

  # GstAppSrc, GstBuffer, gpointer --> GstFlowReturn
  method connect-push-buffer (
    $obj,
    $signal = 'push-buffer',
    &handler?
  ) {
    my $hid;
    %!signals-app{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-push-buffer($obj, $signal,
        -> $, $gbr, $ud --> GstFlowReturn {
          CATCH {
            default { 𝒮.note($_) }
          }

          my $r = ReturnedValue.new;
          𝒮.emit( [self, $gbr, $ud, $r] );
          $r.r;
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-app{$signal}[0].tap(&handler) with &handler;
    %!signals-app{$signal}[0];
  }

  # GstAppSrc, GstSample, gpointer --> GstFlowReturn
  method connect-push-sample (
    $obj,
    $signal = 'push-sample',
    &handler?
  ) {
    my $hid;
    %!signals-app{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-push-sample($obj, $signal,
        -> $, $gse, $ud --> GstFlowReturn {
          CATCH {
            default { 𝒮.note($_) }
          }

          my $r = ReturnedValue.new;
          𝒮.emit( [self, $gse, $ud, $r] );
          $r.r;
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-app{$signal}[0].tap(&handler) with &handler;
    %!signals-app{$signal}[0];
  }

}

# GstAppSrc, gpointer --> GstFlowReturn
sub g-connect-end-of-stream(
  Pointer $app,
  Str $name,
  &handler (Pointer, Pointer --> GstFlowReturn),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }

# gpointer --> GstAppSrc
sub g-connect-enough-data(
  Pointer $app,
  Str $name,
  &handler (Pointer, Pointer --> GstAppSrc),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }

# guint, gpointer --> GstAppSrc
sub g-connect-need-data(
  Pointer $app,
  Str $name,
  &handler (Pointer, Pointer --> GstAppSrc),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }

# GstAppSrc, GstBuffer, gpointer --> GstFlowReturn
sub g-connect-push-buffer(
  Pointer $app,
  Str $name,
  &handler (Pointer, GstBuffer, Pointer --> GstFlowReturn),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }

# GstAppSrc, GstSample, gpointer --> GstFlowReturn
sub g-connect-push-sample(
  Pointer $app,
  Str $name,
  &handler (Pointer, GstSample, Pointer --> GstFlowReturn),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }
