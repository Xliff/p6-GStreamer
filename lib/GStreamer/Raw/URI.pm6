use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

unit package GStreamer::Raw::URI;

### /usr/include/gstreamer-1.0/gst/gsturi.h

sub gst_uri_append_path (GstUri $uri, Str $relative_path)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_uri_append_path_segment (GstUri $uri, Str $path_segment)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_uri_equal (GstUri $first, GstUri $second)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_uri_error_quark ()
  returns GQuark
  is native(gstreamer)
  is export
{ * }

sub gst_uri_from_string (Str $uri)
  returns GstUri
  is native(gstreamer)
  is export
{ * }

sub gst_uri_from_string_with_base (GstUri $base, Str $uri)
  returns GstUri
  is native(gstreamer)
  is export
{ * }

sub gst_uri_get_location (Str $uri)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_uri_get_media_fragment_table (GstUri $uri)
  returns GHashTable
  is native(gstreamer)
  is export
{ * }

sub gst_uri_get_protocol (Str $uri)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_uri_get_query_keys (GstUri $uri)
  returns GList
  is native(gstreamer)
  is export
{ * }

sub gst_uri_get_query_value (GstUri $uri, Str $query_key)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_uri_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_filename_to_uri (Str $filename, CArray[Pointer[GError]] $error)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_uri_handler_get_type ()
  returns GType
  is native(gstreamer)
  is export
{ * }

sub gst_uri_handler_get_uri (GstURIHandler $handler)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_uri_handler_get_uri_type (GstURIHandler $handler)
  returns GstURIType
  is native(gstreamer)
  is export
{ * }

sub gst_uri_handler_set_uri (GstURIHandler $handler, Str $uri, CArray[Pointer[GError]] $error)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_uri_has_protocol (Str $uri, Str $protocol)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_uri_is_normalized (GstUri $uri)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_uri_is_valid (Str $uri)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_uri_is_writable (GstUri $uri)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_uri_join (GstUri $base_uri, GstUri $ref_uri)
  returns GstUri
  is native(gstreamer)
  is export
{ * }

sub gst_uri_join_strings (Str $base_uri, Str $ref_uri)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_uri_make_writable (GstUri $uri)
  returns GstUri
  is native(gstreamer)
  is export
{ * }

sub gst_uri_new (Str $scheme, Str $userinfo, Str $host, guint $port, Str $path, Str $query, Str $fragment)
  returns GstUri
  is native(gstreamer)
  is export
{ * }

sub gst_uri_new_with_base (GstUri $base, Str $scheme, Str $userinfo, Str $host, guint $port, Str $path, Str $query, Str $fragment)
  returns GstUri
  is native(gstreamer)
  is export
{ * }

sub gst_uri_normalize (GstUri $uri)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_uri_protocol_is_supported (GstURIType $type, Str $protocol)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_uri_protocol_is_valid (Str $protocol)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_uri_query_has_key (GstUri $uri, Str $query_key)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_uri_remove_query_key (GstUri $uri, Str $query_key)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_uri_set_query_value (GstUri $uri, Str $query_key, Str $query_value)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_uri_to_string (GstUri $uri)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_uri_get_fragment (GstUri $uri)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_uri_get_host (GstUri $uri)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_uri_get_path (GstUri $uri)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_uri_get_path_segments (GstUri $uri)
  returns GList
  is native(gstreamer)
  is export
{ * }

sub gst_uri_get_path_string (GstUri $uri)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_uri_get_port (GstUri $uri)
  returns guint
  is native(gstreamer)
  is export
{ * }

sub gst_uri_get_query_string (GstUri $uri)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_uri_get_query_table (GstUri $uri)
  returns GHashTable
  is native(gstreamer)
  is export
{ * }

sub gst_uri_get_scheme (GstUri $uri)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_uri_get_userinfo (GstUri $uri)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_uri_set_fragment (GstUri $uri, Str $fragment)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_uri_set_host (GstUri $uri, Str $host)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_uri_set_path (GstUri $uri, Str $path)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_uri_set_path_segments (GstUri $uri, GList $path_segments)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_uri_set_path_string (GstUri $uri, Str $path)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_uri_set_port (GstUri $uri, guint $port)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_uri_set_query_string (GstUri $uri, Str $query)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_uri_set_query_table (GstUri $uri, GHashTable $query_table)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_uri_set_scheme (GstUri $uri, Str $scheme)
  returns uint32
  is native(gstreamer)
  is export
{ * }

sub gst_uri_set_userinfo (GstUri $uri, Str $userinfo)
  returns uint32
  is native(gstreamer)
  is export
{ * }
