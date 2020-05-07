use v6.c;

use NativeCall;
use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;
use GStreamer::Raw::SDP::Message;

class GStreamer::SDP::Message {
  has GstSDPMessage $!sm;
  has $!init;

  submethod BUILD (:$message) {
    $!sm = $message;
  }

  multi method new (GstSDPMessage $message) {
    $message ?? self.bless( :$message ) !! Nil;
  }
  multi method new ($message is rw) {
    my $m = CArray[Pointer[GstSDPMessage]].new;
    my $rv = GstSDPResultEnum( gst_sdp_message_new($m) );

    $message = ppr($m);
    return Nil unless $message;

    $message = self.bless( :$message );
    ($rv, $message);
  }
  multi method new {
    my $rv = samewith($);

    $rv ?? $rv[1] !! Nil;
  }

  proto method new_from_text (|)
      is also<new-from-text>
  { * }

  multi method new_from_text (Str() $text) {
    samewith($text, $, $);
  }
  multi method new_from_text (Str() $text, $result is rw) {
    samewith($text, $, $result)
  }
  multi method new_from_text (
    Str() $text,
    $msg is rw,
    $result is rw
  ) {
    my $m = CArray[Pointer[GstSDPMessage]].new;
    my $message := $m[0] = Pointer[GstSDPMessage];

    $result = GstSDPResultEnum( gst_sdp_message_new_from_text($text, $m) );
    $msg = $message ?? self.bless( :$message ) !! Nil;
  }

  method add_attribute (Str() $key, Str() $value) is also<add-attribute> {
    GstSDPResultEnum( gst_sdp_message_add_attribute($!sm, $key, $value) );
  }

  method add_bandwidth (Str() $bwtype, Int() $bandwidth) is also<add-bandwidth> {
    my guint $b = $bandwidth;

    GstSDPResultEnum(
      gst_sdp_message_add_bandwidth($!sm, $bwtype, $bandwidth)
    );
  }

  method add_email (Str() $email) is also<add-email> {
    GstSDPResultEnum( gst_sdp_message_add_email($!sm, $email) );
  }

  method add_media (GstSDPMedia $media) is also<add-media> {
    GstSDPResultEnum( gst_sdp_message_add_media($!sm, $media) );
  }

  method add_phone (Str() $phone) is also<add-phone> {
    GstSDPResultEnum( gst_sdp_message_add_phone($!sm, $phone) );
  }

  method add_time (Str() $start, Str() $stop, Str() $repeat)
    is also<add-time>
  {
    GstSDPResultEnum(
      gst_sdp_message_add_time($!sm, $start, $stop, $repeat)
    );
  }

  method add_zone (Str() $adj_time, Str() $typed_time) is also<add-zone> {
    GstSDPResultEnum(
      gst_sdp_message_add_zone($!sm, $adj_time, $typed_time)
    );
  }

  method as_text is also<as-text> {
    gst_sdp_message_as_text($!sm);
  }

  method as_uri (Str() $scheme, GstSDPMessage $msg) is also<as-uri> {
    gst_sdp_message_as_uri($scheme, $msg);
  }

  method attributes_len is also<attributes-len> {
    gst_sdp_message_attributes_len($!sm);
  }

  proto method attributes_to_caps (|)
      is also<attributes-to-caps>
  { * }

  multi method attributes_to_caps (:$raw = False) {
    samewith($, :$raw);
  }
  multi method attributes_to_caps ($caps is rw, :$raw = False) {
    my $c = CArray[GstCaps];

    $c[0] = GstCaps;
    gst_sdp_message_attributes_to_caps($!sm, $c);

    $caps = $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

  method bandwidths_len is also<bandwidths-len> {
    gst_sdp_message_bandwidths_len($!sm);
  }

  multi method copy (:$raw = False) {
    my $copy;

    samewith($copy, :$raw);
    $copy;
  }
  multi method copy ($result is rw, :$raw) {
    my $copy;

    $result = samewith($copy, :$raw);
    $copy;
  }
  multi method copy ($copy is rw, :$raw = False) {
    my $c = CArray[Pointer[GstSDPMessage]].new;

    $c[0] = Pointer[GstSDPMessage];
    my $result = GstSDPResultEnum( gst_sdp_message_copy($!sm, $c) );
    $copy = ppr($c);
    $copy = GStreamer::SDP::Message.new($copy) unless $raw;

    $result;
  }

  method dump {
    GstSDPResultEnum( gst_sdp_message_dump($!sm) );
  }

  method emails_len is also<emails-len> {
    gst_sdp_message_emails_len($!sm);
  }

  method free {
    GstSDPResult( gst_sdp_message_free($!sm) )
  }

  method get_attribute (Int() $idx) is also<get-attribute> {
    my guint $i = $idx;

    gst_sdp_message_get_attribute($!sm, $i);
  }

  method get_attribute_val (Str() $key) is also<get-attribute-val> {
    gst_sdp_message_get_attribute_val($!sm, $key);
  }

  method get_attribute_val_n (Str() $key, Int() $nth)
    is also<get-attribute-val-n>
  {
    my guint $n = $nth;

    gst_sdp_message_get_attribute_val_n($!sm, $key, $n);
  }

  method get_bandwidth (Int() $idx) is also<get-bandwidth> {
    my guint $i = $idx;

    gst_sdp_message_get_bandwidth($!sm, $i);
  }

  method get_connection is also<get-connection> {
    gst_sdp_message_get_connection($!sm);
  }

  method get_email (Int() $idx) is also<get-email> {
    my guint $i = $idx;

    gst_sdp_message_get_email($!sm, $i);
  }

  method get_information is also<get-information> {
    gst_sdp_message_get_information($!sm);
  }

  method get_key is also<get-key> {
    gst_sdp_message_get_key($!sm);
  }

  method get_media (Int() $idx) is also<get-media> {
    my guint $i = $idx;

    gst_sdp_message_get_media($!sm, $i);
  }

  method get_origin is also<get-origin> {
    gst_sdp_message_get_origin($!sm);
  }

  method get_phone (Int() $idx) is also<get-phone> {
    my guint $i = $idx;

    gst_sdp_message_get_phone($!sm, $i);
  }

  method get_session_name is also<get-session-name> {
    gst_sdp_message_get_session_name($!sm);
  }

  method get_time (Int() $idx) is also<get-time> {
    my guint $i = $idx;

    gst_sdp_message_get_time($!sm, $i);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_sdp_message_get_type, $n, $t );
  }

  method get_uri is also<get-uri> {
    gst_sdp_message_get_uri($!sm);
  }

  method get_version is also<get-version> {
    gst_sdp_message_get_version($!sm);
  }

  method get_zone (guint $idx) is also<get-zone> {
    gst_sdp_message_get_zone($!sm, $idx);
  }

  method init {
    $!init = True;
    gst_sdp_message_init($!sm);
  }

  method insert_attribute (Int() $idx, GstSDPAttribute $attr)
    is also<insert-attribute>
  {
    my guint $i = $idx;

    gst_sdp_message_insert_attribute($!sm, $i, $attr);
  }

  method insert_bandwidth (Int() $idx, GstSDPBandwidth $bw)
    is also<insert-bandwidth>
  {
    my guint $i = $idx;

    gst_sdp_message_insert_bandwidth($!sm, $i, $bw);
  }

  method insert_email (Int() $idx, Str() $email) is also<insert-email> {
    my guint $i = $idx;

    gst_sdp_message_insert_email($!sm, $i, $email);
  }

  method insert_phone (Int() $idx, Str() $phone) is also<insert-phone> {
    my guint $i = $idx;

    gst_sdp_message_insert_phone($!sm, $i, $phone);
  }

  method insert_time (Int() $idx, GstSDPTime $t) is also<insert-time> {
    my guint $i = $idx;

    gst_sdp_message_insert_time($!sm, $idx, $t);
  }

  method insert_zone (Int() $idx, GstSDPZone $zone) is also<insert-zone> {
    my guint $i = $idx;

    gst_sdp_message_insert_zone($!sm, $idx, $zone);
  }

  method medias_len is also<medias-len> {
    gst_sdp_message_medias_len($!sm);
  }

  proto method parse_buffer (|)
      is also<parse-buffer>
  { * }

  multi method parse_buffer (GStreamer::SDP::Message:U: Buf() $data) {
    my $msg;
    my $rv = samewith($data, $msg);
    ($rv, $msg);
  }
  multi method parse_buffer (
    GStreamer::SDP::Message:U:
    Buf() $data,
    $msg is rw
  ) {
    samewith( CArray[guint8].new( $data.list ), $data.bytes, $msg )
  }
  multi method parse_buffer (
    GStreamer::SDP::Message:U:
    CArray[guint8] $data,
    Int() $size
  ) {
    my $msg;
    my $rv = samewith($data, $size, $msg);
    ($rv, $msg);
  }
  multi method parse_buffer (
    GStreamer::SDP::Message:U:
    CArray[guint8] $data,
    Int() $size,
    $msg is rw
  ) {
    my guint $s = $size;

    $msg = GstSDPMessage.new;
    GstSDPResult( gst_sdp_message_parse_buffer($data, $s, $msg) );
  }

  proto method parse_keymgmt (|)
    is also<parse-keymgmt>
  { * }

  multi method parse_keymgmt {
    my $mikey;
    my $rv = samewith($mikey);

    ($rv, $mikey);
  }
  multi method parse_keymgmt ($mikey is rw) {
    my $m = CArray[Pointer[GstMIKEYMessage]].new;

    $m[0] = Pointer[GstMIKEYMessage];
    my $rv = GstSDPResultEnum( gst_sdp_message_parse_keymgmt($!sm, $m) );
    $mikey = ppr($m);
    $rv;
  }

  method parse_uri (
    GStreamer::SDP::Message:U:
    Str() $uri,
    GstSDPMessage $msg
  )
    is also<parse-uri>
  {
    GstSDPResultEnum( gst_sdp_message_parse_uri($uri, $msg) );
  }

  method phones_len is also<phones-len> {
    gst_sdp_message_phones_len($!sm);
  }

  method remove_attribute (Int() $idx) is also<remove-attribute> {
    my guint $i = $idx;

    GstSDPResultEnum( gst_sdp_message_remove_attribute($!sm, $i) );
  }

  method remove_bandwidth (Int() $idx) is also<remove-bandwidth> {
    my guint $i = $idx;

    GstSDPResultEnum( gst_sdp_message_remove_bandwidth($!sm, $i) );
  }

  method remove_email (Int() $idx) is also<remove-email> {
    my guint $i = $idx;

    GstSDPResultEnum( gst_sdp_message_remove_email($!sm, $i) );
  }

  method remove_phone (Int() $idx) is also<remove-phone> {
    my guint $i = $idx;

    GstSDPResultEnum( gst_sdp_message_remove_phone($!sm, $i) );
  }

  method remove_time (Int() $idx) is also<remove-time> {
    my guint $i = $idx;

    GstSDPResultEnum( gst_sdp_message_remove_time($!sm, $i) );
  }

  method remove_zone (Int() $idx) is also<remove-zone> {
    my guint $i = $idx;

    GstSDPResultEnum( gst_sdp_message_remove_zone($!sm, $i) );
  }

  method replace_attribute (Int() $idx, GstSDPAttribute $attr)
    is also<replace-attribute>
  {
    my guint $i = $idx;

    GstSDPResult( gst_sdp_message_replace_attribute($!sm, $i, $attr) );
  }

  method replace_bandwidth (Int() $idx, GstSDPBandwidth $bw)
    is also<replace-bandwidth>
  {
    my guint $i = $idx;

    GstSDPResult( gst_sdp_message_replace_bandwidth($!sm, $i, $bw) );
  }

  method replace_email (Int() $idx, Str() $email) is also<replace-email> {
    my guint $i = $idx;

    GstSDPResultEnum( gst_sdp_message_replace_email($!sm, $i, $email) );
  }

  method replace_phone (Int() $idx, Str() $phone) is also<replace-phone> {
    my guint $i = $idx;

    gst_sdp_message_replace_phone($!sm, $i, $phone);
  }

  method replace_time (Int() $idx, GstSDPTime $t) is also<replace-time> {
    my guint $i = $idx;

    GstSDPResultEnum( gst_sdp_message_replace_time($!sm, $i, $t) );
  }

  method replace_zone (Int() $idx, GstSDPZone $zone) is also<replace-zone> {
    my guint $i = $idx;

    GstSDPResultEnum( gst_sdp_message_replace_zone($!sm, $idx, $zone) );
  }

  method set_connection (
    Str() $nettype,
    Str() $addrtype,
    Str() $address,
    Int() $ttl,
    Int() $addr_number
  )
    is also<set-connection>
  {
    my guint ($t, $a) = ($t, $a);

    GstSDPResultEnum(
      gst_sdp_message_set_connection(
        $!sm,
        $nettype,
        $addrtype,
        $address,
        $t,
        $a
      )
    );
  }

  method set_information (Str() $information) is also<set-information> {
    GstSDPResultEnum( gst_sdp_message_set_information($!sm, $information) );
  }

  method set_key (Str() $type, Str() $data) is also<set-key> {
    GstSDPResultEnum(
      gst_sdp_message_set_key($!sm, $type, $data)
    );
  }

  method set_origin (
    Str() $username,
    Str() $sess_id,
    Str() $sess_version,
    Str() $nettype,
    Str() $addrtype,
    Str() $addr
  )
    is also<set-origin>
  {
    GstSDPResultEnum(
      gst_sdp_message_set_origin(
        $!sm,
        $username,
        $sess_id,
        $sess_version,
        $nettype,
        $addrtype,
        $addr
      )
    );
  }

  method set_session_name (Str() $session_name) is also<set-session-name> {
    GstSDPResultEnum( gst_sdp_message_set_session_name($!sm, $session_name) );
  }

  method set_uri (Str() $uri) is also<set-uri> {
    GstSDPResultEnum( gst_sdp_message_set_uri($!sm, $uri) );
  }

  method set_version (Str() $version) is also<set-version> {
    GstSDPResultEnum( gst_sdp_message_set_version($!sm, $version) );
  }

  method times_len is also<times-len> {
    gst_sdp_message_times_len($!sm);
  }

  method uninit {
    unless $!init {
      warn 'Object not allocated with .init! Skipping!' if $DEBUG;
      return;
    }
    GstSDPResultEnum( gst_sdp_message_uninit($!sm) );
  }

  method zones_len is also<zones-len> {
    gst_sdp_message_zones_len($!sm);
  }

  method address_is_multicast (
    GStreamer::SDP::Message:U:
    Str() $nettype,
    Str() $addrtype,
    Str() $addr
  )
    is also<address-is-multicast>
  {
    so gst_sdp_address_is_multicast($nettype, $addrtype, $addr);
  }

  method make_keymgmt (GStreamer::SDP::Message:U: Str() $uri, Str() $base64) is also<make-keymgmt> {
    gst_sdp_make_keymgmt($uri, $base64);
  }

}
