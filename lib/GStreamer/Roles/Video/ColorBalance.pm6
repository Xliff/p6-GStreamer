use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Video::ColorBalance;

use GLib::GList;
use GStreamer::Video::ColorBalanceChannel;

use GLib::Roles::ListData;
use GStreamer::Roles::Signals::Video::ColorBalance;

role GStreamer::Roles::Video::ColorBalance {
  also does GStreamer::Roles::Signals::Video::ColorBalance;

  has GstColorBalance $!cb;

  method roleInit-ColorBalance {
    return if $!cb;

    my \i = findProperImplementor(self.^attributes);

    $!cb = cast( GstColorBalance, i.get_value(self) );
  }

  method GStreamer::Raw::Definitions::GstColorBalance
    is also<GstColorBalance>
  { $!cb }

  # Is originally:
  # GstColorBalance, GstColorBalanceChannel, gint, gpointer
  method value-changed {
    self.connect-value-changed($!cb);
  }

  method get_balance_type {
    GstColorBalanceTypeEnum( gst_color_balance_get_balance_type($!cb) )
  }

  method colorbalance_get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_color_balance_get_type, $n, $t );
  }

  # Must be done this way to resolve ambiguity between this and
  # GStreamer::Object.get_value
  multi method get_value (
    GstColorBalanceChannel() $chan,
    :color_channel(:color-channel(:$channel)) is required
  )
    is default
  {
    self.get_channel_value($chan);
  }

  method get_channel_value (GstColorBalanceChannel() $channel) {
    gst_color_balance_get_value($!cb, $channel);
  }

  method list_channels (:$glist = False, :$raw = False) {
    my $cl = gst_color_balance_list_channels($!cb);

    return Nil unless $cl;
    return $cl if $glist;

    $cl = GLib::GList.new($cl)
      but GLib::Roles::ListData[GstColorBalanceChannel];
    $cl ?? $cl.Array
        !! $cl.Array.map({ GStreamer::Video::ColorBalanceChannel.new($_) });
  }

  method get_channels {
    my @channels = self.list_channels;

    (do for @channels { "{ .label }" => $_ }).Hash
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
