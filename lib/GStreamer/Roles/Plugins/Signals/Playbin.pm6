use v6.c;

use NativeCall;

use GLib::Raw::ReturnedValue;
use GStreamer::Raw::Types;
use GStreamer::Roles::Plugins::Raw::Playbin;

role GStreamer::Roles::Plugins::Signals::Playbin {
  has %!signals-pb;

  # GstPlayBin, gint, gpointer
  method connect-tags-changed (
    $obj,
    $signal,
    &handler?
  ) {
    my $hid;
    %!signals-pb{$signal} //= do {
      my $s = Supplier.new;
      $hid = g-connect-tags-changed($obj, $signal,
        -> $, $g, $ud {
          CATCH {
            default { $s.note($_) }
          }

          $s.emit( [self, $g, $ud ] );
        },
        Pointer, 0
      );
      [ $s.Supply, $obj, $hid ];
    };
    %!signals-pb{$signal}[0].tap(&handler) with &handler;
    %!signals-pb{$signal}[0];
  }

  # GstPlayBin, GstCaps, gpointer --> GstSample
  method connect-convert-sample (
    $obj,
    $signal = 'convert-sample',
    &handler?
  ) {
    my $hid;
    %!signals-pb{$signal} //= do {
      my $s = Supplier.new;
      $hid = g-connect-convert-sample($obj, $signal,
        -> $, $gc, $ud --> GstSample {
          CATCH {
            default { $s.note($_) }
          }

          my $r = ReturnedValue.new;
          $s.emit( [self, $gc, $ud, $r] );
          $r.r;
        },
        Pointer, 0
      );
      [ $s.Supply, $obj, $hid ];
    };
    %!signals-pb{$signal}[0].tap(&handler) with &handler;
    %!signals-pb{$signal}[0];
  }

  # GstPlayBin, gint, gpointer --> GstPad
  method connect-get-pad (
    $obj,
    $signal,
    &handler?
  ) {
    my $hid;
    %!signals-pb{$signal} //= do {
      my $s = Supplier.new;
      $hid = g-connect-get-pad($obj, $signal,
        -> $, $g, $ud --> GstPad {
          CATCH {
            default { $s.note($_) }
          }

          my $r = ReturnedValue.new;
          $s.emit( [self, $g, $ud, $r] );
          $r.r;
        },
        Pointer, 0
      );
      [ $s.Supply, $obj, $hid ];
    };
    %!signals-pb{$signal}[0].tap(&handler) with &handler;
    %!signals-pb{$signal}[0];
  }

  # GstPlayBin, gint, gpointer --> GstTagList
  method connect-get-tags (
    $obj,
    $signal,
    &handler?
  ) {
    my $hid;
    %!signals-pb{$signal} //= do {
      my $s = Supplier.new;
      $hid = g-connect-get-tags($obj, $signal,
        -> $, $g, $ud --> GstTagList {
          CATCH {
            default { $s.note($_) }
          }

          my $r = ReturnedValue.new;
          $s.emit( [self, $g, $ud, $r] );
          $r.r;
        },
        Pointer, 0
      );
      [ $s.Supply, $obj, $hid ];
    };
    %!signals-pb{$signal}[0].tap(&handler) with &handler;
    %!signals-pb{$signal}[0];
  }

  # GstPlayBin, GstElement, gpointer
  method connect-source-setup (
    $obj,
    $signal = 'source-setup',
    &handler?
  ) {
    my $hid;
    %!signals-pb{$signal} //= do {
      my $s = Supplier.new;
      $hid = g-connect-source-setup($obj, $signal,
        -> $, $ge, $ud {
          CATCH {
            default { $s.note($_) }
          }

          $s.emit( [self, $ge, $ud ] );
        },
        Pointer, 0
      );
      [ $s.Supply, $obj, $hid ];
    };
    %!signals-pb{$signal}[0].tap(&handler) with &handler;
    %!signals-pb{$signal}[0];
  }

}
