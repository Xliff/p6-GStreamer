use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

role GStreamer::Player::Roles::SignalDispatcher {
  has GstPlayerSignalDispatcher $!sd;

  method roleInit-SignalDispatcher {
    my \i = findProperImplementor(self.^attributes);

    $!sd = cast(GstPlayerSignalDispatcher, i.get_value(self) );
  }

  method GStreamer::Raw::Definitions::GstPlayerSignalDispatcher
  { $!sd }

  method dispatch (
    GstPlayer() $player,
    &func,
    gpointer $data = gpointer,
    GDestroyNotify $destroy = gpointer
  ) {
    dispatch($!sd, $player, &func, $data, $destroy);
  }

}

sub dispatch(
  GstPlayerSignalDispatcher $dispatch,
  GstPlayer $player,
  &func (gpointer),
  gpointer $data,
  GDestroyNotify $destroy
)
  is native(gstreamer-video)
{ * }
