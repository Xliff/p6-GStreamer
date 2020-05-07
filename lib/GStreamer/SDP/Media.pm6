use v6.c;

use NativeCall;
use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::SDP::Message;   # Contains ::Media raw defs

use GStreamer::Caps;

class GStreamer::SDP::Media {
  has GstSDPMedia $!m;
  has $!init;

  submethod BUILD (:$media) {
    $!m = $media;
  }

  multi method new {
    my $media;
    my $rv = samewith($media);

    $media ?? self.bless( :$media ) !! Nil;
  }
  multi method new ($media is rw) {
    my $m = CArray[Pointer[GstSDPMedia]].new($media);
    my $rv = GstSDPResultEnum( gst_sdp_media_new($m) );

    $media = ppr($m);
    $rv;
  }

  method add_attribute (Str() $key, Str() $value) is also<add-attribute> {
    GstSDPResultEnum( gst_sdp_media_add_attribute($!m, $key, $value) );
  }

  method add_bandwidth (Str $bwtype, Int() $bandwidth) is also<add-bandwidth> {
    my guint $b = $bandwidth;

    gst_sdp_media_add_bandwidth($!m, $bwtype, $b);
  }

  method add_connection (
    Str() $nettype,
    Str() $addrtype,
    Str() $address,
    Int() $ttl,
    Int() $addr_number
  )
    is also<add-connection>
  {
    my guint ($t, $a) = ($ttl, $addr_number);

    GstSDPResultEnum(
      gst_sdp_media_add_connection(
        $!m,
        $nettype,
        $addrtype,
        $address,
        $t,
        $a
      )
    );
  }

  method add_format (Str() $format) is also<add-format> {
    GstSDPResultEnum( gst_sdp_media_add_format($!m, $format) );
  }

  method as_text is also<as-text> {
    gst_sdp_media_as_text($!m);
  }

  method attributes_len is also<attributes-len> {
    gst_sdp_media_attributes_len($!m);
  }

  proto method attributes_to_caps (|)
      is also<attributes-to-caps>
  { * }

  multi method attributes_to_caps {
    my $caps;

    samewith($caps);
    $caps;
  }
  multi method attributes_to_caps ($caps is rw) {
    $caps = GstCaps.new;
    GstSDPResultEnum( gst_sdp_media_attributes_to_caps($!m, $caps) );
  }

  method bandwidths_len is also<bandwidths-len> {
    gst_sdp_media_bandwidths_len($!m);
  }

  method connections_len is also<connections-len> {
    gst_sdp_media_connections_len($!m);
  }

  multi method copy (:$raw = False) {
    my $copy;
    my $rv = samewith($copy, :$raw);

    ($rv, $copy);
  }
  multi method copy ($copy is rw, :$raw = False) {
    my $c = CArray[Pointer[GstSDPMedia]].new;

    $copy := $c[0] = Pointer[GstSDPMedia];
    my $result = GstSDPResultEnum( gst_sdp_media_copy($!m, $c) );
    $copy = ppr($c);
    $copy = GStreamer::SDP::Media.new($copy) unless $raw;
    $result;
  }

  method formats_len is also<formats-len> {
    gst_sdp_media_formats_len($!m);
  }

  method free {
    GstSDPResultEnum( gst_sdp_media_free($!m) );
  }

  method get_attribute (Int() $idx, :$raw = False) is also<get-attribute> {
    my guint $i = $idx;

    gst_sdp_media_get_attribute($!m, $i);
  }

  method get_attribute_val (Str() $key) is also<get-attribute-val> {
    gst_sdp_media_get_attribute_val($!m, $key);
  }

  method get_attribute_val_n (Str() $key, Int() $nth)
    is also<get-attribute-val-n>
  {
    my guint $n = $nth;

    gst_sdp_media_get_attribute_val_n($!m, $key, $n);
  }

  method get_bandwidth (guint $idx) is also<get-bandwidth> {
    my guint $i = $idx;

    gst_sdp_media_get_bandwidth($!m, $idx);
  }

  method get_caps_from_media (Int() $pt, :$raw = False)
    is also<get-caps-from-media>
  {
    my gint $p = $pt;

    my $c = gst_sdp_media_get_caps_from_media($!m, $p);

    $c ??
      ( $raw ?? $c !! GStreamer::Caps.new($c) )
      !!
      Nil;
  }

  method get_connection (Int() $idx) is also<get-connection> {
    my guint $i = $idx;

    gst_sdp_media_get_connection($!m, $idx);
  }

  method get_format (Int() $idx) is also<get-format> {
    my guint $i = $idx;

    gst_sdp_media_get_format($!m, $idx);
  }

  method get_information is also<get-information> {
    gst_sdp_media_get_information($!m);
  }

  method get_key is also<get-key> {
    gst_sdp_media_get_key($!m);
  }

  method get_media is also<get-media> {
    gst_sdp_media_get_media($!m);
  }

  method get_num_ports is also<get-num-ports> {
    gst_sdp_media_get_num_ports($!m);
  }

  method get_port is also<get-port> {
    gst_sdp_media_get_port($!m);
  }

  method get_proto is also<get-proto> {
    gst_sdp_media_get_proto($!m);
  }

  method init {
    $!init = True;
    GstSDPResultEnum( gst_sdp_media_init($!m) );
  }

  method insert_attribute (gint $idx, GstSDPAttribute $attr)
    is also<insert-attribute>
  {
    my guint $i = $idx;

    gst_sdp_media_insert_attribute($!m, $idx, $attr);
  }

  method insert_bandwidth (gint $idx, GstSDPBandwidth $bw)
    is also<insert-bandwidth>
  {
    my guint $i = $idx;

    gst_sdp_media_insert_bandwidth($!m, $idx, $bw);
  }

  method insert_connection (gint $idx, GstSDPConnection $conn)
    is also<insert-connection>
  {
    my guint $i = $idx;

    gst_sdp_media_insert_connection($!m, $idx, $conn);
  }

  method insert_format (gint $idx, Str $format) is also<insert-format> {
    my guint $i = $idx;

    gst_sdp_media_insert_format($!m, $idx, $format);
  }

  method parse_keymgmt (GstMIKEYMessage $mikey) is also<parse-keymgmt> {
    gst_sdp_media_parse_keymgmt($!m, $mikey);
  }

  method remove_attribute (Int() $idx) is also<remove-attribute> {
    my guint $i = $idx;

    gst_sdp_media_remove_attribute($!m, $i);
  }

  method remove_bandwidth (Int() $idx) is also<remove-bandwidth> {
    my guint $i = $idx;

    gst_sdp_media_remove_bandwidth($!m, $i);
  }

  method remove_connection (Int() $idx) is also<remove-connection> {
    my guint $i = $idx;

    gst_sdp_media_remove_connection($!m, $i);
  }

  method remove_format (Int() $idx) is also<remove-format> {
    my guint $i = $idx;

    gst_sdp_media_remove_format($!m, $i);
  }

  method replace_attribute (Int() $idx, GstSDPAttribute $attr)
    is also<replace-attribute>
  {
    my guint $i = $idx;

    gst_sdp_media_replace_attribute($!m, $i, $attr);
  }

  method replace_bandwidth (Int() $idx, GstSDPBandwidth $bw)
    is also<replace-bandwidth>
  {
    my guint $i = $idx;

    gst_sdp_media_replace_bandwidth($!m, $i, $bw);
  }

  method replace_connection (Int() $idx, GstSDPConnection $conn)
    is also<replace-connection>
  {
    my guint $i = $idx;

    gst_sdp_media_replace_connection($!m, $i, $conn);
  }

  method replace_format (Int() $idx, Str() $format) is also<replace-format> {
    my guint $i = $idx;

    gst_sdp_media_replace_format($!m, $i, $format);
  }

  method set_information (Str() $information) is also<set-information> {
    GstSDPResultEnum(
      gst_sdp_media_set_information($!m, $information)
    );
  }

  method set_key (Str() $type, Str() $data) is also<set-key> {
    GstSDPResultEnum(
      gst_sdp_media_set_key($!m, $type, $data)
    );
  }

  method set_media (Str() $med) is also<set-media> {
    GstSDPResultEnum(
      gst_sdp_media_set_media($!m, $med)
    )
  }

  method set_media_from_caps (
    GStreamer::SDP::Media:U:
    GstCaps() $caps,
    GstSDPMedia() $media
  )
    is also<set-media-from-caps>
  {
    GstSDPResultEnum( gst_sdp_media_set_media_from_caps($caps, $media) );
  }

  method set_port_info (Int() $port, Int() $num_ports) is also<set-port-info> {
    my guint ($p, $n) = ($port, $num_ports);

    GstSDPResultEnum( gst_sdp_media_set_port_info($!m, $p, $n) );
  }

  method set_proto (Str() $proto) is also<set-proto> {
    GstSDPResultEnum( gst_sdp_media_set_proto($!m, $proto) )
  }

  method uninit {
    unless $!init {
      warn 'Object not allocated with .init! Skipping!' if $DEBUG;
      return;
    }
    GstSDPResultEnum( gst_sdp_media_uninit($!m) );
  }

}
