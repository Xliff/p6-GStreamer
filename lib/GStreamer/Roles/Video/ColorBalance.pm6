use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Video::ColorBalance;

use GLib::GList;
use GStreamer::Video::ColorBalanceChannel;

use GLib::Roles::ListData;

role GStreamer::Roles::Video::ColorBalance {
  has GstColorBalance $!cb;

  submethod TWEAK {
    self!roleInit-ColorBalance;
  }

  method GStreamer::Raw::Definitions::GstColorBalance
    is also<GstColorBalance>
  { $!cb }

  method !roleInit-ColorBalance {
    my \i = findProperImplementor(self.^attributes);

    $!cb = cast( GstColorBalance, i.get_value(self) );
  }

  method get_balance_type {
    GstColorBalanceTypeEnum( gst_color_balance_get_balance_type($!cb) )
  }

  method colorbalance_get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_color_balance_get_type, $n, $t );
  }

  method get_value (GstColorBalanceChannel() $channel) {
    gst_color_balance_get_value($!cb, $channel);
  }

  method list_channels (:$glist = False, :$raw = False) {
    my $cl = gst_color_balance_list_channels($!cb);

    return Nil unless $cl;
    return $cl if $glist;

    $cl = GLib::Value.new($cl)
      but GLib::Roles::ListData[GstColorBalanceChannel];
    $cl ?? $cl.Array
        !! $cl.Array.map({ GStreamer::Video::ColorBalanceChannel.new($_) });
  }

  method set_value (GstColorBalanceChannel() $channel, Int() $value) {
    my gint $v = $value;

    gst_color_balance_set_value($!cb, $channel, $v);
  }

  method value_changed (GstColorBalanceChannel() $channel, Int() $value) {
    my gint $v = $value;

    gst_color_balance_value_changed($!cb, $channel, $v);
  }

}
