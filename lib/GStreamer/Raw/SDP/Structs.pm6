use v6.c;

use NativeCall;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Enums;
use GStreamer::Raw::Structs;

use GLib::Roles::Pointers;

unit package GStreamer::Raw::SDP::Structs;

class GstMIKEYMapSRTP is repr<CStruct> does GLib::Roles::Pointers is export {
  has guint8  $.policy is rw;
  has guint32 $.ssrc   is rw;
  has guint32 $.roc    is rw;
}

class GstMIKEYPayload is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS GstMiniObject       $!mini_object;

  has GstMIKEYPayloadType $.type is rw;
  has guint               $.len is rw;
}

class GstMIKEYPayloadKEMAC is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS GstMIKEYPayload $.pt;

  has GstMIKEYEncAlg  $.enc_alg;
  has GstMIKEYMacAlg  $.mac_alg;
  has GArray          $!subpayloads;

  method subpayloads is rw {
    Proxy.new:
      FETCH => -> $              { self.^attributes[3].get_value(self)    },
      STORE => -> $, GArray() \a { self.^attributes[3].set_value(self, a) };
  }
}

class GstMIKEYPayloadPKE is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS GstMIKEYPayload   $.pt;

  has GstMIKEYCacheType $.C;
  has guint16           $.data_len is rw;
  has CArray[guint8]    $.data;
}

class GstMIKEYPayloadT is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS GstMIKEYPayload $.pt;

  has GstMIKEYTSType  $.type     is rw;
  has CArray[guint8]  $.ts_value;
}

class GstMIKEYPayloadSPParam is repr<CStruct> does GLib::Roles::Pointers is export {
  has guint8         $.type is rw;
  has guint8         $.len  is rw;
  has CArray[guint8] $!val;

  method val is rw {
    Proxy.new:
      FETCH => -> $                    { self.^attributes[2].get_value(self)    },
      STORE => -> $, CArray[guint8] \a { self.^attributes[2].set_value(self, a) };
  }
}

class GstMIKEYPayloadSP is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS GstMIKEYPayload  $.pt;

  has guint            $.policy is rw;
  has GstMIKEYSecProto $.proto is rw;
  has GArray           $!params;

  method params is rw {
    Proxy.new:
      FETCH => -> $              { self.^attributes[3].get_value(self)    },
      STORE => -> $, GArray() \a { self.^attributes[3].set_value(self, a) };
  }
}

class GstMIKEYPayloadRAND is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS GstMIKEYPayload $.pt;

  has guint8          $.len   is rw;
  has CArray[guint8]  $.rand;
}

class GstMIKEYPayloadKeyData is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS GstMIKEYPayload      $.pt;

  has GstMIKEYKeyDataType  $.key_type   is rw;
  has guint16              $.key_len    is rw;
  has CArray[guint8]       $.key_data;
  has guint16              $.salt_len   is rw;
  has CArray[guint8]       $.salt_data;
  has GstMIKEYKVType       $.kv_type    is rw;
  HAS guint8               @.kv_len[2]  is CArray;
  HAS Pointer[guint8]      @.kv_data[2] is CArray;
}

class GstMIKEYMessage is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS GstMiniObject   $!mini_object;

  has guint8          $.version  is rw;
  has GstMIKEYType    $.type     is rw;
  has gboolean        $.V        is rw;
  has GstMIKEYPRFFunc $.prf_func is rw;
  has guint32         $.CSB_id   is rw;
  has GstMIKEYMapType $.map_type is rw;
  has GArray          $!map_info;
  has GArray          $!payloads;

  method map_info is rw {
    Proxy.new:
      FETCH => -> $              { self.^attributes[7].get_value(self)    },
      STORE => -> $, GArray() \a { self.^attributes[7].set_value(self, a) };
  }

  method params is rw {
    Proxy.new:
      FETCH => -> $              { self.^attributes[8].get_value(self)    },
      STORE => -> $, GArray() \a { self.^attributes[8].set_value(self, a) };
  }
}
