use v6.c;

use Method::Also;

use GLib::Raw::Enums;

use GLib::Value;

role GStreamer::Roles::Plugins::TcpClientSrc {

  # Type: gchar
  method host is rw  {
    my GLib::Value $gv .= new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('host', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('host', $gv);
      }
    );
  }

  # Type: gint
  method port is rw  {
    my GLib::Value $gv .= new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('port', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('port', $gv);
      }
    );
  }

  # Type: GstTCPProtocol
  method protocol is rw  {
    my GLib::Value $gv .= new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('protocol', $gv)
        );
        $gv.uint
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('protocol', $gv);
      }
    );
  }

}
