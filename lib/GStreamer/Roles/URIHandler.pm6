use v6.c;

use NativeCall;
use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::URI;

role GStreamer::Roles::URIHandler {
  has GstURIHandler $!h;

  method roleInit-URIHandler is also<roleInit_URIHandler> {
    my \i = findProperImplementor(self.^attributes);

    $!h = cast( GstURIHandler, i.get_value(self) );
  }

  method GStreamer::Raw::Definitions::GstURIHandler
    is also<GstURIHandler>
  { $!h }

  method urihandler_get_type is also<urihandler-get-type> {
    state ($n, $t);

    unstable_get_type(self.^name, &gst_uri_handler_get_type, $n, $t)
  }

  method get_uri is also<get-uri> {
    gst_uri_handler_get_uri($!h);
  }

  method get_uri_type is also<get-uri-type> {
    GstURITypeEnum( gst_uri_handler_get_uri_type($!h) );
  }

  method set_uri (
    Str() $uri,
    CArray[Pointer[GError]] $error = gerror
  )
    is also<set-uri>
  {
    clear_error;
    my $rv = so gst_uri_handler_set_uri($!h, $uri, $error);
    set_error($error);
    $rv;
  }

}
