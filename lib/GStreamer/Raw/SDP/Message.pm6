use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Enums;
use GStreamer::Raw::SDP::Structs;

unit package GStreamer::Raw::SDP::Message;

### /usr/include/gstreamer-1.0/gst/sdp/gstsdpmessage.h

sub gst_sdp_message_add_attribute (GstSDPMessage $msg, Str $key, Str $value)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_add_bandwidth (
  GstSDPMessage $msg,
  Str $bwtype,
  guint $bandwidth
)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_add_email (GstSDPMessage $msg, Str $email)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_add_media (GstSDPMessage $msg, GstSDPMedia $media)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_add_phone (GstSDPMessage $msg, Str $phone)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_add_time (
  GstSDPMessage $msg,
  Str $start,
  Str $stop,
  Str $repeat
)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_add_zone (
  GstSDPMessage $msg,
  Str $adj_time,
  Str $typed_time
)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_as_text (GstSDPMessage $msg)
  returns Str
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_as_uri (Str $scheme, GstSDPMessage $msg)
  returns Str
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_attributes_len (GstSDPMessage $msg)
  returns guint
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_attributes_to_caps (GstSDPMessage $msg, GstCaps $caps)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_bandwidths_len (GstSDPMessage $msg)
  returns guint
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_copy (GstSDPMessage $msg, GstSDPMessage $copy)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_dump (GstSDPMessage $msg)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_emails_len (GstSDPMessage $msg)
  returns guint
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_free (GstSDPMessage $msg)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_get_attribute (GstSDPMessage $msg, guint $idx)
  returns GstSDPAttribute
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_get_attribute_val (GstSDPMessage $msg, Str $key)
  returns Str
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_get_attribute_val_n (
  GstSDPMessage $msg,
  Str $key,
  guint $nth
)
  returns Str
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_get_bandwidth (GstSDPMessage $msg, guint $idx)
  returns GstSDPBandwidth
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_get_connection (GstSDPMessage $msg)
  returns GstSDPConnection
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_get_email (GstSDPMessage $msg, guint $idx)
  returns Str
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_get_information (GstSDPMessage $msg)
  returns Str
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_get_key (GstSDPMessage $msg)
  returns GstSDPKey
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_get_media (GstSDPMessage $msg, guint $idx)
  returns GstSDPMedia
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_get_origin (GstSDPMessage $msg)
  returns GstSDPOrigin
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_get_phone (GstSDPMessage $msg, guint $idx)
  returns Str
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_get_session_name (GstSDPMessage $msg)
  returns Str
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_get_time (GstSDPMessage $msg, guint $idx)
  returns GstSDPTime
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_get_type ()
  returns GType
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_get_uri (GstSDPMessage $msg)
  returns Str
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_get_version (GstSDPMessage $msg)
  returns Str
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_get_zone (GstSDPMessage $msg, guint $idx)
  returns GstSDPZone
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_init (GstSDPMessage $msg)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_insert_attribute (
  GstSDPMessage $msg,
  gint $idx,
  GstSDPAttribute $attr
)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_insert_bandwidth (
  GstSDPMessage $msg,
  gint $idx,
  GstSDPBandwidth $bw
)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_insert_email (GstSDPMessage $msg, gint $idx, Str $email)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_insert_phone (GstSDPMessage $msg, gint $idx, Str $phone)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_insert_time (GstSDPMessage $msg, gint $idx, GstSDPTime $t)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_insert_zone (
  GstSDPMessage $msg,
  gint $idx,
  GstSDPZone $zone
)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_medias_len (GstSDPMessage $msg)
  returns guint
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_new (GstSDPMessage $msg)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_new_from_text (Str $text, GstSDPMessage $msg)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_parse_buffer (
  CArray[guint8] $data,
  guint $size,
  GstSDPMessage $msg
)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_parse_keymgmt (GstSDPMessage $msg, GstMIKEYMessage $mikey)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_parse_uri (Str $uri, GstSDPMessage $msg)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_phones_len (GstSDPMessage $msg)
  returns guint
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_remove_attribute (GstSDPMessage $msg, guint $idx)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_remove_bandwidth (GstSDPMessage $msg, guint $idx)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_remove_email (GstSDPMessage $msg, guint $idx)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_remove_phone (GstSDPMessage $msg, guint $idx)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_remove_time (GstSDPMessage $msg, guint $idx)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_remove_zone (GstSDPMessage $msg, guint $idx)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_replace_attribute (
  GstSDPMessage $msg,
  guint $idx,
  GstSDPAttribute $attr
)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_replace_bandwidth (
  GstSDPMessage $msg,
  guint $idx,
  GstSDPBandwidth $bw
)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_replace_email (GstSDPMessage $msg, guint $idx, Str $email)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_replace_phone (GstSDPMessage $msg, guint $idx, Str $phone)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_replace_time (
  GstSDPMessage $msg,
  guint $idx,
  GstSDPTime $t
)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_replace_zone (
  GstSDPMessage $msg,
  guint $idx,
  GstSDPZone $zone
)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_set_connection (
  GstSDPMessage $msg,
  Str $nettype,
  Str $addrtype,
  Str $address,
  guint $ttl,
  guint $addr_number
)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_set_information (GstSDPMessage $msg, Str $information)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_set_key (GstSDPMessage $msg, Str $type, Str $data)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_set_origin (
  GstSDPMessage $msg,
  Str $username,
  Str $sess_id,
  Str $sess_version,
  Str $nettype,
  Str $addrtype,
  Str $addr
)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_set_session_name (GstSDPMessage $msg, Str $session_name)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_set_uri (GstSDPMessage $msg, Str $uri)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_set_version (GstSDPMessage $msg, Str $version)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_times_len (GstSDPMessage $msg)
  returns guint
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_uninit (GstSDPMessage $msg)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_message_zones_len (GstSDPMessage $msg)
  returns guint
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_address_is_multicast (Str $nettype, Str $addrtype, Str $addr)
  returns uint32
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_make_keymgmt (Str $uri, Str $base64)
  returns Str
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_add_attribute (GstSDPMedia $media, Str $key, Str $value)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_add_bandwidth (
  GstSDPMedia $media,
  Str $bwtype,
  guint $bandwidth
)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_add_connection (
  GstSDPMedia $media,
  Str $nettype,
  Str $addrtype,
  Str $address,
  guint $ttl,
  guint $addr_number
)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_add_format (GstSDPMedia $media, Str $format)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_as_text (GstSDPMedia $media)
  returns Str
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_attributes_len (GstSDPMedia $media)
  returns guint
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_attributes_to_caps (GstSDPMedia $media, GstCaps $caps)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_bandwidths_len (GstSDPMedia $media)
  returns guint
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_connections_len (GstSDPMedia $media)
  returns guint
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_copy (GstSDPMedia $media, GstSDPMedia $copy)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_formats_len (GstSDPMedia $media)
  returns guint
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_free (GstSDPMedia $media)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_get_attribute (GstSDPMedia $media, guint $idx)
  returns GstSDPAttribute
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_get_attribute_val (GstSDPMedia $media, Str $key)
  returns Str
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_get_attribute_val_n (
  GstSDPMedia $media,
  Str $key,
  guint $nth
)
  returns Str
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_get_bandwidth (GstSDPMedia $media, guint $idx)
  returns GstSDPBandwidth
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_get_caps_from_media (GstSDPMedia $media, gint $pt)
  returns GstCaps
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_get_connection (GstSDPMedia $media, guint $idx)
  returns GstSDPConnection
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_get_format (GstSDPMedia $media, guint $idx)
  returns Str
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_get_information (GstSDPMedia $media)
  returns Str
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_get_key (GstSDPMedia $media)
  returns GstSDPKey
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_get_media (GstSDPMedia $media)
  returns Str
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_get_num_ports (GstSDPMedia $media)
  returns guint
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_get_port (GstSDPMedia $media)
  returns guint
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_get_proto (GstSDPMedia $media)
  returns Str
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_init (GstSDPMedia $media)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_insert_attribute (
  GstSDPMedia $media,
  gint $idx,
  GstSDPAttribute $attr
)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_insert_bandwidth (
  GstSDPMedia $media,
  gint $idx,
  GstSDPBandwidth $bw
)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_insert_connection (
  GstSDPMedia $media,
  gint $idx,
  GstSDPConnection $conn
)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_insert_format (GstSDPMedia $media, gint $idx, Str $format)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_new (GstSDPMedia $media)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_parse_keymgmt (GstSDPMedia $media, GstMIKEYMessage $mikey)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_remove_attribute (GstSDPMedia $media, guint $idx)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_remove_bandwidth (GstSDPMedia $media, guint $idx)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_remove_connection (GstSDPMedia $media, guint $idx)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_remove_format (GstSDPMedia $media, guint $idx)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_replace_attribute (
  GstSDPMedia $media,
  guint $idx,
  GstSDPAttribute $attr
)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_replace_bandwidth (
  GstSDPMedia $media,
  guint $idx,
  GstSDPBandwidth $bw
)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_replace_connection (
  GstSDPMedia $media,
  guint $idx,
  GstSDPConnection $conn
)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_replace_format (GstSDPMedia $media, guint $idx, Str $format)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_set_information (GstSDPMedia $media, Str $information)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_set_key (GstSDPMedia $media, Str $type, Str $data)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_set_media (GstSDPMedia $media, Str $med)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_set_media_from_caps (GstCaps $caps, GstSDPMedia $media)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_set_port_info (
  GstSDPMedia $media,
  guint $port,
  guint $num_ports
)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_set_proto (GstSDPMedia $media, Str $proto)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }

sub gst_sdp_media_uninit (GstSDPMedia $media)
  returns GstSDPResult
  is native(gstreamer-sdp)
  is export
{ * }
