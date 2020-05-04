use v6.c;

use MONKEY-TYPING;

use NativeCall;

use GStreamer::Raw::Types;

use GStreamer::Buffer;

use GLib::Roles::StaticClass;

augment class GStreamer::Buffer {

  method add_protection_meta (GstStructure() $info) {
    gst_buffer_add_protection_meta($!b, $info);
  }

}

class GStreamer::Protection {
  also does GLib::Roles::StaticClass;

  proto method filter_systems_by_available_decryptors (|)
  { * }

  multi method filter_systems_by_available_decryptors (@system_identifiers) {
    samewith( ArrayToCArray(Str, @system_identifiers) );
  }
  multi method filter_systems_by_available_decryptors (
    CArray[Str] $system_identifiers
  ) {
    CStringArrayToArray(
      gst_protection_filter_systems_by_available_decryptors(
        $system_identifiers
      )
    );
  }

  proto method select_system (|)
  { * }

  multi method select_system (@system_identifiers) {
    samewith( ArrayToCArray(Str, @system_identifiers) )
  }
  multi method select_system (CArray[Str] $system_identifiers) {
    gst_protection_select_system($system_identifiers);
  }

}

### /usr/include/gstreamer-1.0/gst/gstprotection.h

sub gst_protection_filter_systems_by_available_decryptors (
  CArray[Str] $system_identifiers
)
  returns CArray[Str]
  is native(gstreamer)
  is export
{ * }

sub gst_buffer_add_protection_meta (GstBuffer $buffer, GstStructure $info)
  returns GstProtectionMeta
  is native(gstreamer)
  is export
{ * }

sub gst_protection_select_system (CArray[Str] $system_identifiers)
  returns Str
  is native(gstreamer)
  is export
{ * }
