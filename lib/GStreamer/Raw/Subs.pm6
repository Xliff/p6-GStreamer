use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GStreamer::Raw::Definitions;

use GLib::Roles::Pointers;

unit package GStreamer::Raw::Subs;

subset PassThru of Mu where Str | CArray;

sub ppr (*@a) is export {
  @a .= map({
    if $_ ~~ CArray {
      if .[0].defined {
        if .[0].REPR ne 'CPointer' {
          .[0]
        } else {
          +.[0] != 0 ?? ( .[0].of.REPR eq 'CStruct' ?? .[0].deref !! .[0] )
                     !! Nil;
        }
      } else {
        Nil;
      }
    }
    else { $_ }
  });
  @a.elems == 1 ?? @a[0] !! @a;
}

sub postfix:<sec> ($s) is export {
  $s * GST_SECOND;
}

sub postfix:<μsec> ($us) is export {
  $us * GST_USECOND;
}
sub postfix:<usec> ($us) is export {
  $us * GST_USECOND;
}

# Method::Also does not work for subs.
sub time-args ($d) is export {
  time_args($d);
}
sub time_args ($d) is export {
  $d != GST_CLOCK_TIME_NONE ?? (
     $d / (GST_SECOND * 60²),
    ($d / (GST_SECOND * 60)) % 60,
    ($d / GST_SECOND) % 60,
     $d % GST_SECOND
  ) !! (99, 99, 99, 999999999)
}

sub timeval-to-time (GTimeVal $tv) {
  $tv.tv_sec * GST_SECOND + $tv.tv_usec * GST_USECOND
}

sub gst_error_get_message (GQuark $domain, gint $code)
  returns Str
  is export
  is native(gstreamer)
{ * }

sub gst_stream_error_quark ()
  returns GQuark
  is export
  is native(gstreamer)
{ * }

sub gst_core_error_quark ()
  returns GQuark
  is export
  is native(gstreamer)
{ * }

sub gst_resource_error_quark ()
  returns GQuark
  is export
  is native(gstreamer)
{ * }

sub gst_library_error_quark ()
  returns GQuark
  is export
  is native(gstreamer)
{ * }

constant GST_CORE_ERROR     is export = gst_core_error_quark();
constant GST_LIBRARY_ERROR  is export = gst_library_error_quark();
constant GST_RESOURCE_ERROR is export = gst_resource_error_quark();
constant GST_STREAM_ERROR   is export = gst_stream_error_quark();
