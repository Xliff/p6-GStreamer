use v6.c;

use GTK::Compat::Types;
use GStreamer::Raw::Types;

use GLib::Quark;

use GStreamer::Caps;
use GStreamer::Pad;
use GStreamer::Main;

sub print-caps ($caps, $pfx) {
  return unless $caps.defined;

  say "{ $pfx }ANY"    && return if $caps.is-any;
  say "{ $pfx }EMPTY " && return if $caps.is-empty;

  for ^$caps.get-size {
    my $s = $caps.get_structur($i);

    say "{ $pfx }{ $structure.get-name }";
    $structure.foreach(-> *@a --> gboolean {
      my $v = GTK::Compat::Value.new( @a[1] );
      my $s = $v.serialize;

      say "{ $pfx }{ GLib::Quark.to_string( @a[0] ).fmt('%15s') }{ $s }";
      1;
    });
  }
}

sub print-pad-templates-information ($f) {
  say "Pad Templates for { $f.longname }:";
  say '  none' && return unless $f.num-pad-templates;

  for $pads.static-pad-templates -> $pt {
    my $cs = do given $pt.direction {
      when GST_PAD_SRC  { '  SRC template:'        }
      when GST_PAD_SINK { '  SINK template:'       }
      default           { '  UNKNOWN!!! template:' }
    }
    say "{ $cs }{ $pt.name-template };"

    $cs = given $pt.presence {
      when GST_PAD_ALWAYS    { 'Always'     }
      when GST_PAD_SOMETIMES { 'Sometimes'  }
      when GST_PAD_REQUEST   { 'On request' }
      default                { 'UNKNOWN!!!' }
    }
    say "    Availability: { $cs }";

    if $pt.static_caps.string {
      say "    Capabilities:";
      print-caps( (my $caps = $pt.get), ' ' x 6);
      $caps.unref;
    }

    say '';
  }
}
