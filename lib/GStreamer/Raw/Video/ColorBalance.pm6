use v6.c;

use GStreamer::Raw::Types;
use GStreamer::Raw::Enums;

unit package GStreamer::Raw::Video::ColorBalance;

### /usr/include/gstreamer-1.0/gst/video/colorbalance.h

sub gst_color_balance_get_balance_type (GstColorBalance $balance)
  returns GstColorBalanceType
  is native(gstreamer-video)
  is export
{ * }

sub gst_color_balance_get_type ()
  returns GType
  is native(gstreamer-video)
  is export
{ * }

sub gst_color_balance_get_value (
  GstColorBalance $balance,
  GstColorBalanceChannel $channel
)
  returns gint
  is native(gstreamer-video)
  is export
{ * }

sub gst_color_balance_list_channels (GstColorBalance $balance)
  returns GList
  is native(gstreamer-video)
  is export
{ * }

sub gst_color_balance_set_value (
  GstColorBalance $balance,
  GstColorBalanceChannel $channel,
  gint $value
)
  is native(gstreamer-video)
  is export
{ * }

sub gst_color_balance_value_changed (
  GstColorBalance $balance,
  GstColorBalanceChannel $channel,
  gint $value
)
  is native(gstreamer-video)
  is export
{ * }

### /usr/include/gstreamer-1.0/gst/video/colorbalancechannel.h

sub gst_color_balance_channel_get_type ()
  returns GType
  is native(gstreamer-video)
  is export
{ * }
