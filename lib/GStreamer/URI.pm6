use v6.c;

use NativeCall;
use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::URI;

use GLib::GList;
use GLib::HashTable;

class GStreamer::URI {
  has GstUri $!u;

  submethod BUILD (:$uri) {
    $!u = $uri;
  }

  method GStreamer::Raw::Definitions::GstUri
    is also<GstUri>
  { $!u }

  multi method new (GstUri $uri) {
    $uri ?? self.bless(:$uri) !! Nil;
  }

  multi method new (
    Str() $scheme,
    Str() $userinfo,
    Str() $host,
    Int() $port,
    Str() $path,
    Str() $query,
    Str() $fragment
  ) {
    my guint $p = $port;
    my $uri = gst_uri_new(
      $scheme,
      $userinfo,
      $host,
      $p,
      $path,
      $query,
      $fragment
    );

    $uri ?? self.bless(:$uri) !! Nil;
  }

  method new_with_base (
    GstUri() $base,
    Str() $scheme,
    Str() $userinfo,
    Str() $host,
    Int() $port,
    Str() $path,
    Str() $query,
    Str() $fragment
  )
    is also<new-with-base>
  {
    my guint $p = $port;
    my $uri = gst_uri_new_with_base(
      $base,
      $scheme,
      $userinfo,
      $host,
      $p,
      $path,
      $query,
      $fragment
    );

    $uri ?? self.bless(:$uri) !! Nil;
  }

  method from_string (Str() $u)
    is also<
      from-string
      new_from_string
      new-from-string
    >
  {
    my $uri = gst_uri_from_string($u);

    $uri ?? self.bless(:$uri) !! Nil;
  }

  method from_string_with_base (GstUri() $base, Str() $u)
    is also<
      from-string-with-base
      new_from_string_with_base
      new-from-string-with-base
    >
  {
    my $uri = gst_uri_from_string_with_base($base, $u);

    $uri ?? self.bless(:$uri) !! Nil;
  }

  method fragment is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_uri_get_fragment($!u);
      },
      STORE => sub ($, Str() $fragment is copy) {
        gst_uri_set_fragment($!u, $fragment);
      }
    );
  }

  method host is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_uri_get_host($!u);
      },
      STORE => sub ($, Str() $host is copy) {
        gst_uri_set_host($!u, $host);
      }
    );
  }

  method path is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_uri_get_path($!u);
      },
      STORE => sub ($, Str() $path is copy) {
        gst_uri_set_path($!u, $path);
      }
    );
  }

  method path_segments is rw is also<path-segments> {
    Proxy.new(
      FETCH => sub ($) {
        gst_uri_get_path_segments($!u);
      },
      STORE => sub ($, Str() $path_segments is copy) {
        gst_uri_set_path_segments($!u, $path_segments);
      }
    );
  }

  method path_string is rw is also<path-string> {
    Proxy.new(
      FETCH => sub ($) {
        gst_uri_get_path_string($!u);
      },
      STORE => sub ($, Str() $path is copy) {
        gst_uri_set_path_string($!u, $path);
      }
    );
  }

  method port is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_uri_get_port($!u);
      },
      STORE => sub ($, Int() $port is copy) {
        my guint $p = $port;

        gst_uri_set_port($!u, $p);
      }
    );
  }

  method query_string is rw is also<query-string> {
    Proxy.new(
      FETCH => sub ($) {
        gst_uri_get_query_string($!u);
      },
      STORE => sub ($, Str() $query is copy) {
        gst_uri_set_query_string($!u, $query);
      }
    );
  }

  method query_table is rw is also<query-table> {
    Proxy.new(
      FETCH => sub ($) {
        gst_uri_get_query_table($!u);
      },
      STORE => sub ($, GHashTable() $query_table is copy) {
        gst_uri_set_query_table($!u, $query_table);
      }
    );
  }

  method scheme is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_uri_get_scheme($!u);
      },
      STORE => sub ($, Str() $scheme is copy) {
        gst_uri_set_scheme($!u, $scheme);
      }
    );
  }

  method userinfo is rw {
    Proxy.new(
      FETCH => sub ($) {
        gst_uri_get_userinfo($!u);
      },
      STORE => sub ($, Str() $userinfo is copy) {
        gst_uri_set_userinfo($!u, $userinfo);
      }
    );
  }

  method append_path (Str() $relative_path) is also<append-path> {
    gst_uri_append_path($!u, $relative_path);
  }

  method append_path_segment (Str() $path_segment)
    is also<append-path-segment>
  {
    gst_uri_append_path_segment($!u, $path_segment);
  }

  method equal (GstUri() $second) {
    so gst_uri_equal($!u, $second);
  }

  method error_quark (GStreamer::URI:U: ) is also<error-quark> {
    gst_uri_error_quark();
  }

  method get_location (GStreamer::URI:U: Str() $uri) is also<get-location> {
    gst_uri_get_location($uri);
  }

  method get_media_fragment_table (:$raw = False)
    is also<get-media-fragment-table>
  {
    my $ht = gst_uri_get_media_fragment_table($!u);

    $ht ??
      ( $raw ?? $ht !! GLib::HashTable.new($ht) )
      !!
      Nil;
  }

  method get_protocol (GStreamer::URI:U: Str() $uri) is also<get-protocol> {
    gst_uri_get_protocol($uri);
  }

  method get_query_keys (
    GStreamer::URI:U:
    Str() $uri,
    :$glist = False
  )
    is also<get-query-keys>
  {
    my $kl = gst_uri_get_query_keys($uri);

    return Nil unless $kl;
    return $kl if $glist;

    $kl = GLib::GList.new($kl) but GLib::Roles::ListData[Str];
    $kl.Array;
  }

  method get_query_value (Str() $query_key) is also<get-query-value> {
    gst_uri_get_query_value($!u, $query_key);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_uri_get_type, $n, $t );
  }

  method filename_to_uri (
    GStreamer::URI:U:
    Str() $filename,
    CArray[Pointer[GError]] $error
  )
    is also<gst-filename-to-uri>
  {
    clear_error;
    my $rv = gst_filename_to_uri($filename, $error);
    set_error($error);
    $rv;
  }

  method has_protocol (
    GStreamer::URI:U:
    Str() $uri,
    Str() $protocol
  )
    is also<has-protocol>
  {
    so gst_uri_has_protocol($uri, $protocol);
  }

  method is_normalized is also<is-normalized> {
    so gst_uri_is_normalized($!u);
  }

  method is_valid (GStreamer::URI:U: Str() $uri) is also<is-valid> {
    so gst_uri_is_valid($uri);
  }

  method is_writable is also<is-writable> {
    so gst_uri_is_writable($!u);
  }

  method join (GstUri() $ref_uri, :$raw = False) {
    my $u = gst_uri_join($!u, $ref_uri);

    $u ??
      ( $raw ?? $u !! GStreamer::URI.new($u) )
      !!
      Nil;
  }

  method join_strings (Str() $base, Str() $ref_uri) is also<join-strings> {
    gst_uri_join_strings($base, $ref_uri);
  }

  method make_writable (:$raw = False) is also<make-writable> {
    my $u = gst_uri_make_writable($!u);

    $u ??
      ( $raw ?? $u !! GStreamer::URI.new($u) )
      !!
      Nil
  }

  method normalize {
    so gst_uri_normalize($!u);
  }

  method protocol_is_supported (Str() $protocol)
    is also<protocol-is-supported>
  {
    so gst_uri_protocol_is_supported($!u, $protocol);
  }

  method protocol_is_valid (GStreamer::URI:U: Str() $protocol)
    is also<protocol-is-valid>
  {
    so gst_uri_protocol_is_valid($protocol);
  }

  method query_has_key (Str() $query_key) is also<query-has-key> {
    so gst_uri_query_has_key($!u, $query_key);
  }

  method remove_query_key (Str() $query_key) is also<remove-query-key> {
    so gst_uri_remove_query_key($!u, $query_key);
  }

  method set_query_value (
    Str() $query_key,
    Str() $query_value
  )
    is also<set-query-value>
  {
    gst_uri_set_query_value($!u, $query_key, $query_value);
  }

  method to_string
    is also<
      to-string
      Str
    >
  {
    gst_uri_to_string($!u);
  }

}
