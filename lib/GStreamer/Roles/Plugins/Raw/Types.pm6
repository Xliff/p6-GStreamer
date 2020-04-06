use v6.c;

use GStreamer::Raw::Definitions;

unit package GStreamer::Plugins::Raw::Types;

# Much of this from:
# https://www.freedesktop.org/software/gstreamer-sdk/data/docs/latest/gst-plugins-base-plugins-0.10/gst-plugins-base-plugins-multifdsink.html#GstTCPProtocol
#
# Will need to circle back to this in time.

our constant GstRecoverPolicy is export := uint32;
our enum GstRecoverPolicyEnum is export <
  GST_RECOVER_POLICY_NONE
  GST_RECOVER_POLICY_RESYNC_LATEST
  GST_RECOVER_POLICY_RESYNC_SOFT_LIMIT
  GST_RECOVER_POLICY_RESYNC_KEYFRAME
>;

our constant GstSyncMethod is export := uint32;
our enum GstSyncMethodEnum is export <
  GST_SYNC_METHOD_LATEST
  GST_SYNC_METHOD_NEXT_KEYFRAME
  GST_SYNC_METHOD_LATEST_KEYFRAME
  GST_SYNC_METHOD_BURST
  GST_SYNC_METHOD_BURST_KEYFRAME
  GST_SYNC_METHOD_BURST_WITH_KEYFRAME
>;

constant GstClientStatus is export := uint32;
our enum GstClientStatusEnum is export (
  GST_CLIENT_STATUS_OK          => 0,
  GST_CLIENT_STATUS_CLOSED      => 1,
  GST_CLIENT_STATUS_REMOVED     => 2,
  GST_CLIENT_STATUS_SLOW        => 3,
  GST_CLIENT_STATUS_ERROR       => 4,
  GST_CLIENT_STATUS_DUPLICATE   => 5,
  GST_CLIENT_STATUS_FLUSHING    => 6
);

constant GstTCPProtocol is export := uint32;
our enum GstTCPProtocolEnum is export <
  GST_TCP_PROTOCOL_NONE
  GST_TCP_PROTOCOL_GDP
>;

constant GstTCPUnitType is export := uint32;
enum GstTCPUnitTypeEnum is export <
  GST_TCP_UNIT_TYPE_UNDEFINED
  GST_TCP_UNIT_TYPE_BUFFERS
  GST_TCP_UNIT_TYPE_TIME
  GST_TCP_UNIT_TYPE_BYTES
>;
