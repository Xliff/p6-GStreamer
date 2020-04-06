use v6.c;

use Method::Also;

use GLib::Raw::Enums;

use GLib::Value;

use GLib::Roles::Object;

role GStreamer::Roles::Plugins::SubtitleOverlay {

  # Type: gchar
  method font-desc is rw  {
    my GLib::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('font-desc', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('font-desc', $gv);
      }
    );
  }

  # Type: gboolean
  method silent is rw  {
    my GLib::Value $gv .= new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('silent', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('silent', $gv);
      }
    );
  }

  # Type: gchar
  method subtitle-encoding is rw  {
    my GLib::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('subtitle-encoding', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('subtitle-encoding', $gv);
      }
    );
  }

}
