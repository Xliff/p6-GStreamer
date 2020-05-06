use v6.c;

use NativeCall;
use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::SDP::Mickey;

use GStreamer::MiniObject;

our subset GstMikeyPayloadAncestry is export of Mu
  where GstMIKEYPayload | GstMiniObject;

class GStreamer::SDP::Mikey::Payload is GStreamer::MiniObject {
  has GstMIKEYPayload $!p;

  submethod BUILD (:$payload) {
    self.setGstMikeyPayload($payload);
  }

  method setGstMikeyPayload (GstMikeyPayloadAncestry $_) {
    my $to-parent;

    $!p = do {
      when GstAllocator {
        $to-parent = cast(GstMiniObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstMIKEYPayload, $_);
      }
    };
    self.setGstMiniObject($to-parent);
  }

  method GStreamer::Raw::Structs::GstMIKEYPayload
    is also<GstMIKEYPayload>
  { $!p }

  multi method new (GstMIKEYPayload $payload) {
    $payload ?? self.bless( :$payload ) !! Nil;
  }
  multi method new (GstMIKEYPayloadType $type) {
    my GstMIKEYPayloadType $t = $type;

    my $payload = gst_mikey_payload_new($t);

    $payload ?? self.bless( :$payload ) !! Nil;
  }

  method kemac_add_sub (GstMIKEYPayload() $newpay) is also<kemac-add-sub> {
    gst_mikey_payload_kemac_add_sub($!p, $newpay);
  }

  method kemac_get_n_sub is also<kemac-get-n-sub> {
    gst_mikey_payload_kemac_get_n_sub($!p);
  }

  method kemac_remove_sub (Int() $idx) is also<kemac-remove-sub> {
    my gint $i = $idx;

    gst_mikey_payload_kemac_remove_sub($!p, $i);
  }

  method key_data_set_interval (
    Int() $vf_len,
    CArray[guint8] $vf_data,
    Int() $vt_len,
    CArray[guint8] $vt_data,
  )
    is also<key-data-set-interval>
  {
    my ($vf, $vt) = ($vf_len, $vt_len);

    gst_mikey_payload_key_data_set_interval($!p, $vf, $vf_data, $vt, $vt_data);
  }

  proto method key_data_set_key (|)
      is also<key-data-set-key>
  { * }

  multi method key_data_set_key (Int() $key_type, Buf() $key) {
    samewith( $key_type, $key.chars, CArray[guint8].new( $key.list ) )
  }
  multi method key_data_set_key (
    Int() $key_type,
    Int() $key_len,
    CArray[guint8] $key_data is rw
  ) {
    my GstMIKEYKeyDataType $kt = $key_type;
    my guint16 $k = $key_len;

    gst_mikey_payload_key_data_set_key($!p, $kt, $k, $key_data);
  }

  proto method key_data_set_salt (|)
      is also<key-data-set-salt>
  { * }

  multi method key_data_set_salt (Buf() $salt_data) {
    samewith( $salt_data.bytes, CArray[guint8].new($salt_data).list )
  }
  multi method key_data_set_salt (Int() $salt_len, CArray[guint8] $salt_data) {
    my guint16 $l = $salt_len;

    gst_mikey_payload_key_data_set_salt($!p, $l, $salt_data);
  }

  proto method key_data_set_spi (|)
      is also<key-data-set-spi>
  { * }

  multi method key_data_set_spi (Buf() $spi_data) {
    samewith( $spi_data.bytes, CArray[guint8].new($spi_data.list) );
  }
  multi method key_data_set_spi (Int() $spi_len, CArray[guint8] $spi_data) {
    my guint8 $l = $spi_len;

    gst_mikey_payload_key_data_set_spi($!p, $l, $spi_data);
  }

  proto method sp_add_param (|)
      is also<sp-add-param>
  { * }

  multi method sp_add_param (Int() $type, Buf() $val) {
    samewith( $type, $val.bytes, CArray[guint8].new($val) )
  }
  multi method sp_add_param (Int() $type, Int() $len, CArray[guint8] $val) {
    my guint $t = $type;
    my guint8 $l = $len;

    so gst_mikey_payload_sp_add_param($!p, $t, $l, $val);
  }

  method sp_get_param (Int() $idx) is also<sp-get-param> {
    my guint $i = $idx;

    gst_mikey_payload_sp_get_param($!p, $i);
  }

  method sp_get_n_params  is also<sp-get-n-params> {
    gst_mikey_payload_sp_get_n_params($!p);
  }

  method sp_remove_param (Int() $idx) is also<sp-remove-param> {
    my guint $i = $idx;

    so gst_mikey_payload_sp_remove_param ($!p, $i);
  }

  method sp_set (Int() $policy, GstMIKEYSecProto $proto) is also<sp-set> {
    my guint $p = $policy;

    so gst_mikey_payload_sp_set($!p, $p, $proto);
  }

}

class GStreamer::SDP::Mikey::Message is GStreamer::MiniObject {
  has GstMIKEYMessage $!mm;

  submethod BUILD (:$message) {
    $!mm = $message;
  }

  method setGstMikeyPayload (GstMikeyPayloadAncestry $_) {
  my $to-parent;

  $!mm = do {
    when GstAllocator {
      $to-parent = cast(GstMiniObject, $_);
      $_;
    }

    default {
      $to-parent = $_;
      cast(GstMIKEYPayload, $_);
    }
  };
  self.setGstMiniObject($to-parent);
}

  method GStreamer::Raw::SDB::Mikey::GstMIKEYMessage
    is also<GstMIKEYMessage>
  { $!mm }

  multi method new (GstMIKEYMessage $message) {
    $message ?? self.bless( :$message ) !! Nil;
  }
  multi method new {
    my $message = gst_mikey_message_new();

    $message ?? self.bless( :$message ) !! Nil;
  }

  method new_from_bytes (
    GBytes() $bytes,
    GstMIKEYDecryptInfo $info,
    CArray[Pointer[GError]] $error = gerror
  )
    is also<new-from-bytes>
  {
    clear_error;
    my $message = gst_mikey_message_new_from_bytes($bytes, $info, $error);
    set_error($error);

    $message ?? self.bless( :$message ) !! Nil;
  }

  method new_from_caps (GstCaps() $caps) is also<new-from-caps> {
    my $message = gst_mikey_message_new_from_caps($caps);

    $message ?? self.bless( :$message ) !! Nil;
  }

  proto method new_from_data (|)
      is also<new-from-data>
  { * }

  multi method new_from_data (
    Buf() $data,
    GstMIKEYDecryptInfo $info,
    CArray[Pointer[GError]] $error = gerror
  ) {
    samewith( CArray[guint8].new($data.list), $data.bytes, $info, $error );
  }
  multi method new_from_data (
    CArray[uint8] $data,
    Int() $size,
    GstMIKEYDecryptInfo $info,
    CArray[Pointer[GError]] $error = gerror
  ) {
    samewith( cast(gpointer, $data), $size, $info, $error)
  }
  multi method new_from_data (
    gpointer $data,
    Int() $size,
    GstMIKEYDecryptInfo $info,
    CArray[Pointer[GError]] $error = gerror
  ) {
    my gsize $s = $size;

    clear_error;
    my $message = gst_mikey_message_new_from_data($data, $size, $info, $error);
    set_error($error);

    $message ?? self.bless( :$message ) !! Nil;
  }

  method add_cs_srtp (
    Int() $policy,
    Int() $ssrc,
    Int() $roc
  )
    is also<add-cs-srtp>
  {
    my guint8 $p = $policy;
    my guint32 ($s, $r) = ($ssrc, $roc);

    so gst_mikey_message_add_cs_srtp($!mm, $p, $s, $r);
  }

  method add_payload (GstMIKEYPayload() $payload) is also<add-payload> {
    gst_mikey_message_add_payload($!mm, $payload);
  }

  proto method add_pke (|)
      is also<add-pke>
  { * }

  multi method add_pke (Int() $C, Buf() $data) {
    samewith( $C, $data.bytes, CArray[guint8].new( $data.list ) );
  }
  multi method add_pke (Int() $C, @data) {
    for @data {
      die '@data must only contain uint8 elements!'
        unless $_ ~~ Int && $_ < 256;
    }
    samewith($C, @data.elems, ArrayToCArray(guint8, @data) );
  }
  multi method add_pke (
    Int() $C,
    Int() $data_len,
    CArray[guint8] $data is rw
  ) {
    my GstMIKEYCacheType $ct = $C;
    my guint16 $d = $data_len;

    so gst_mikey_message_add_pke($!mm, $ct, $d, $data);
  }

  proto method add_rand (|)
      is also<add-rand>
  { * }

  multi method add_rand (Buf() $data) {
    samewith( $data.bytes, CArray[guint8].new( $data.list ) )
  }
  multi method add_rand (Int() $len, CArray[guint8] $rand) {
    my guint8 $l = $len;

    so gst_mikey_message_add_rand($!mm, $l, $rand);
  }

  method add_rand_len (Int() $len) is also<add-rand-len> {
    my guint8 $l = $len;

    so gst_mikey_message_add_rand_len($!mm, $l);
  }

  proto method add_t (|)
      is also<add-t>
  { * }

  multi method add_t (Int() $type, Buf() $ts_value) {
    samewith( $type, CArray[guint8].new( $ts_value.list ) );
  }
  multi method add_t (GstMIKEYTSType $type, CArray[guint8] $ts_value) {
    my GstMIKEYTSType $t = $type;

    so gst_mikey_message_add_t($!mm, $t, $ts_value);
  }

  method add_t_now_ntp_utc is also<add-t-now-ntp-utc> {
    so gst_mikey_message_add_t_now_ntp_utc($!mm);
  }

  method base64_encode is also<base64-encode> {
    gst_mikey_message_base64_encode($!mm);
  }

  method find_payload (Int() $type, Int() $nth) is also<find-payload> {
    my GstMIKEYPayloadType $t = $type;
    my guint $n = $nth;

    gst_mikey_message_find_payload($!mm, $t, $n);
  }

  method get_cs_srtp (Int() $idx) is also<get-cs-srtp> {
    my guint $i = $idx;

    gst_mikey_message_get_cs_srtp($!mm, $i);
  }

  method get_n_cs is also<get-n-cs> {
    gst_mikey_message_get_n_cs($!mm);
  }

  method get_n_payloads is also<get-n-payloads> {
    gst_mikey_message_get_n_payloads($!mm);
  }

  method get_payload (Int() $idx) is also<get-payload> {
    my guint $i = $idx;

    gst_mikey_message_get_payload($!mm, $i);
  }

  method insert_cs_srtp (Int() $idx, GstMIKEYMapSRTP $map)
    is also<insert-cs-srtp>
  {
    my guint $i = $idx;

    so gst_mikey_message_insert_cs_srtp($!mm, $idx, $map);
  }

  method insert_payload (Int() $idx, GstMIKEYPayload() $payload)
    is also<insert-payload>
  {
    my guint $i = $idx;

    so gst_mikey_message_insert_payload($!mm, $idx, $payload);
  }

  method remove_cs_srtp (Int() $idx) is also<remove-cs-srtp> {
    my guint $i = $idx;

    so gst_mikey_message_remove_cs_srtp($!mm, $idx);
  }

  method remove_payload (Int() $idx) is also<remove-payload> {
    my guint $i = $idx;

    so gst_mikey_message_remove_payload($!mm, $idx);
  }

  method replace_cs_srtp (Int() $idx, GstMIKEYMapSRTP $map)
    is also<replace-cs-srtp>
  {
    my guint $i = $idx;

    so gst_mikey_message_replace_cs_srtp($!mm, $idx, $map);
  }

  method replace_payload (Int() $idx, GstMIKEYPayload() $payload)
    is also<replace-payload>
  {
    my guint $i = $idx;

    so gst_mikey_message_replace_payload($!mm, $idx, $payload);
  }

  method set_info (
    Int() $version,
    Int() $type,
    Int() $V,
    Int() $prf_func,
    Int() $CSB_id,
    Int() $map_type
  )
    is also<set-info>
  {
    my guint8 $v = $version;
    my GstMIKEYType $t = $type;
    my gboolean $vb = $V.so.Int;
    my GstMIKEYPRFFunc $p = $prf_func;
    my guint32 $c = $CSB_id;
    my GstMIKEYMapType $m = $map_type;

    so gst_mikey_message_set_info($!mm, $v, $t, $vb, $p, $c, $m);
  }

  method to_bytes (
    GstMIKEYEncryptInfo $info,
    CArray[Pointer[GError]] $error = gerror,
    :$raw = False
  )
    is also<to-bytes>
  {
    clear_error;
    my $b = gst_mikey_message_to_bytes($!mm, $info, $error);
    set_error($error);

    $b ??
      ( $raw ?? $b !! GLib::Bytes.new($b) )
      !!
      Nil;
  }

  method to_caps (GstCaps() $caps) is also<to-caps> {
    so gst_mikey_message_to_caps($!mm, $caps);
  }

}
