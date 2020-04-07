use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Video::ColorBalance;

use GLib::Roles::Object;
use GLib::Roles::Signals::Generic;

class GStreamer::Video::ColorBalanceChannel {
  also does GLib::Roles::Object;
  also does GLib::Roles::Signals::Generic;

  has GstColorBalanceChannel $!cbc is implementor handles <
    label
    min_value
    min-value
    max_value
    max-value
  >;

  submethod BUILD (:$channel) {
    $!cbc = $channel;
  }

  method GStreamer::Raw::Structs::GstColorBalanceChannel
    is also<GstColorBalanceChannel>
  { $!cbc }

  method new (GstColorBalanceChannel $channel) {
    $channel ?? self.bless( :$channel ) !! Nil;
  }

  method value-changed is also<value_changed> {
    self.connect-int($!cbc.GObject, 'value-changed');
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &gst_color_balance_channel_get_type,
      $n,
      $t
    );
  }

}
