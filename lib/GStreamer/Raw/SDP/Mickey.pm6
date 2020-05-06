use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Enums;
use GStreamer::Raw::Structs;
use GStreamer::Raw::SDP::Structs;

unit package GStreamer::Raw::SDP::Mickey;

### /usr/include/gstreamer-1.0/gst/sdp/gstmikey.h

sub gst_mikey_message_add_cs_srtp (
  GstMIKEYMessage $msg,
  guint8 $policy,
  guint32 $ssrc,
  guint32 $roc
)
  returns uint32
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_message_add_payload (
  GstMIKEYMessage $msg,
  GstMIKEYPayload $payload
)
  returns uint32
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_message_add_pke (
  GstMIKEYMessage $msg,
  GstMIKEYCacheType $C,
  guint16 $data_len,
  CArray[guint8] $data,
)
  returns uint32
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_message_add_rand (
  GstMIKEYMessage $msg,
  guint8 $len,
  CArray[guint8] $rand,
)
  returns uint32
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_message_add_rand_len (GstMIKEYMessage $msg, guint8 $len)
  returns uint32
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_message_add_t (
  GstMIKEYMessage $msg,
  GstMIKEYTSType $type,
  CArray[guint8] $ts_value,
)
  returns uint32
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_message_add_t_now_ntp_utc (GstMIKEYMessage $msg)
  returns uint32
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_message_base64_encode (GstMIKEYMessage $msg)
  returns Str
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_message_find_payload (
  GstMIKEYMessage $msg,
  GstMIKEYPayloadType $type,
  guint $nth
)
  returns GstMIKEYPayload
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_message_get_cs_srtp (GstMIKEYMessage $msg, guint $idx)
  returns GstMIKEYMapSRTP
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_message_get_n_cs (GstMIKEYMessage $msg)
  returns guint
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_message_get_n_payloads (GstMIKEYMessage $msg)
  returns guint
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_message_get_payload (GstMIKEYMessage $msg, guint $idx)
  returns GstMIKEYPayload
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_message_insert_cs_srtp (
  GstMIKEYMessage $msg,
  gint $idx,
  GstMIKEYMapSRTP $map
)
  returns uint32
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_message_insert_payload (
  GstMIKEYMessage $msg,
  guint $idx,
  GstMIKEYPayload $payload
)
  returns uint32
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_message_new ()
  returns GstMIKEYMessage
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_message_new_from_bytes (
  GBytes $bytes,
  GstMIKEYDecryptInfo $info,
  CArray[Pointer[GError]] $error
)
  returns GstMIKEYMessage
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_message_new_from_caps (GstCaps $caps)
  returns GstMIKEYMessage
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_message_new_from_data (
  gconstpointer $data,
  gsize $size,
  GstMIKEYDecryptInfo $info,
  CArray[Pointer[GError]] $error
)
  returns GstMIKEYMessage
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_message_remove_cs_srtp (GstMIKEYMessage $msg, gint $idx)
  returns uint32
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_message_remove_payload (GstMIKEYMessage $msg, guint $idx)
  returns uint32
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_message_replace_cs_srtp (
  GstMIKEYMessage $msg,
  gint $idx,
  GstMIKEYMapSRTP $map
)
  returns uint32
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_message_replace_payload (
  GstMIKEYMessage $msg,
  guint $idx,
  GstMIKEYPayload $payload
)
  returns uint32
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_message_set_info (
  GstMIKEYMessage $msg,
  guint8 $version,
  GstMIKEYType $type,
  gboolean $V,
  GstMIKEYPRFFunc $prf_func,
  guint32 $CSB_id,
  GstMIKEYMapType $map_type
)
  returns uint32
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_message_to_bytes (
  GstMIKEYMessage $msg,
  GstMIKEYEncryptInfo $info,
  CArray[Pointer[GError]] $error
)
  returns GBytes
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_message_to_caps (GstMIKEYMessage $msg, GstCaps $caps)
  returns uint32
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_payload_kemac_add_sub (
  GstMIKEYPayload $payload,
  GstMIKEYPayload $newpay
)
  returns uint32
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_payload_kemac_get_n_sub (GstMIKEYPayload $payload)
  returns guint
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_payload_kemac_remove_sub (
  GstMIKEYPayload $payload,
  guint $idx
)
  returns uint32
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_payload_key_data_set_interval (
  GstMIKEYPayload $payload,
  guint8 $vf_len,
  CArray[guint8] $vf_data,
  guint8 $vt_len,
  CArray[guint8] $vt_data,
)
  returns uint32
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_payload_key_data_set_key (
  GstMIKEYPayload $payload,
  GstMIKEYKeyDataType $key_type,
  guint16 $key_len,
  CArray[guint8] $key_data,
)
  returns uint32
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_payload_key_data_set_salt (
  GstMIKEYPayload $payload,
  guint16 $salt_len,
  CArray[guint8] $salt_data,
)
  returns uint32
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_payload_key_data_set_spi (
  GstMIKEYPayload $payload,
  guint8 $spi_len,
  CArray[guint8] $spi_data,
)
  returns uint32
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_payload_new (GstMIKEYPayloadType $type)
  returns GstMIKEYPayload
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_payload_sp_add_param (
  GstMIKEYPayload $payload,
  guint8 $type,
  guint8 $len,
  CArray[guint8] $val,
)
  returns uint32
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_payload_sp_get_n_params (GstMIKEYPayload $payload)
  returns guint
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_payload_sp_get_param (GstMIKEYPayload $payload, guint $idx)
  returns GstMIKEYPayloadSPParam
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_payload_sp_remove_param (GstMIKEYPayload $payload, guint $idx)
  returns gboolean
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_mikey_payload_sp_set (
  GstMIKEYPayload $payload,
  guint $policy,
  GstMIKEYSecProto $proto
)
  returns gboolean
  is native(gstreamer-sdp)
  is export
{ * }
