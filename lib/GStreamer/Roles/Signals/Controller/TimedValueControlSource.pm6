use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

role GStreamer::Roles::Signals::Controller::TimedValueControlSource {
  has %!signals-tvcs;

  # GstTimedValueControlSource, GstControlPoint, gpointer
  method connect-control-point (
    $obj,
    $signal,
    &handler?
  ) {
    my $hid;
    %!signals-tvcs{$signal} //= do {
      my \𝒮 = Supplier.new;
      $hid = g-connect-control-point($obj, $signal,
        -> $, $gcpt, $gr   {
          CATCH {
            default { 𝒮.note($_) }
          }

          𝒮.emit( [self, $gcpt, $gr ] );
        },
        Pointer, 0
      );
      [ 𝒮.Supply, $obj, $hid ];
    };
    %!signals-tvcs{$signal}[0].tap(&handler) with &handler;
    %!signals-tvcs{$signal}[0];
  }

}

# GstTimedValueControlSource, GstControlPoint, gpointer
sub g-connect-control-point(
  Pointer $app,
  Str $name,
  &handler (GstTimedValueControlSource, GstControlPoint, gpointer),
  Pointer $data,
  uint32 $flags
)
  returns uint64
  is native(gobject)
  is symbol('g_signal_connect_object')
{ * }
