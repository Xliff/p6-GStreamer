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

class GstSDPOrigin is repr<CStruct> does GLib::Roles::Pointers is export {
  has Str $!username;
  has Str $!sess_id;
  has Str $!sess_version;
  has Str $!nettype;
  has Str $!addrtype;
  has Str $!addr;

  method username is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[0].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[0].set_value(self, s) };
  }

  method sess_id is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[1].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[1].set_value(self, s) };
  }

  method sess_version is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[2].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[2].set_value(self, s) };
  }

  method nettype is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[3].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[3].set_value(self, s) };
  }

  method addrtype is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[4].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[4].set_value(self, s) };
  }

  method addr is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[5].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[5].set_value(self, s) };
  }

}

class GstSDPConnection is repr<CStruct> does GLib::Roles::Pointers is export {
  has Str   $!nettype;
  has Str   $!addrtype;
  has Str   $!address;
  has guint $.ttl         is rw;
  has guint $.addr_number is rw;

  method nettype is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[0].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[0].set_value(self, s) };
  }

  method addrtype is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[1].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[1].set_value(self, s) };
  }

  method address is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[2].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[2].set_value(self, s) };
  }
}

class GstSDPBandwidth is repr<CStruct> does GLib::Roles::Pointers is export {
  has Str   $!bwtype;
  has guint $.bandwidth is rw;

  method bwtype is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[0].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[0].set_value(self, s) };
  }
}

class GstSDPTime is repr<CStruct> does GLib::Roles::Pointers is export {
  has Str    $!start;
  has Str    $!stop;
  has GArray $!repeat;

  method start is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[0].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[0].set_value(self, s) };
  }

  method stop is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[1].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[1].set_value(self, s) };
  }

  method repeat is rw {
    Proxy.new:
      FETCH => -> $              { self.^attributes[0].get_value(self)    },
      STORE => -> $, GArray() \a { self.^attributes[0].set_value(self, a) };
  }

}

class GstSDPZone is repr<CStruct> does GLib::Roles::Pointers is export {
  has Str $!time;
  has Str $!typed_time;

  method time is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[0].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[0].set_value(self, s) };
  }

  method typed_time is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[1].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[1].set_value(self, s) };
  }
}

class GstSDPKey is repr<CStruct> does GLib::Roles::Pointers is export {
  has Str $!type;
  has Str $!data;

  method type is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[0].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[0].set_value(self, s) };
  }

  method data is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[1].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[1].set_value(self, s) };
  }
}

class GstSDPAttribute is repr<CStruct> does GLib::Roles::Pointers is export {
  has Str $!key;
  has Str $!value;

  method key is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[0].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[0].set_value(self, s) };
  }

  method value is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[1].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[1].set_value(self, s) };
  }
}

class GstSDPMedia is repr<CStruct> does GLib::Roles::Pointers is export {
  has Str              $!media;
  has guint            $.port is rw;
  has guint            $.num_ports is rw;
  has Str              $!proto;
  has GArray           $!fmts;
  has Str              $!information;
  has GArray           $!connections;
  has GArray           $!bandwidths;
  HAS GstSDPKey        $.key;
  has GArray           $!attributes;

  method media is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[0].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[0].set_value(self, s) };
  }

  method proto is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[3].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[3].set_value(self, s) };
  }

  method fmts is rw {
    Proxy.new:
      FETCH => -> $              { self.^attributes[4].get_value(self)    },
      STORE => -> $, GArray() \a { self.^attributes[4].set_value(self, a) };
  }

  method information is rw {
    Proxy.new:
      FETCH => -> $              { self.^attributes[5].get_value(self)    },
      STORE => -> $, GArray() \a { self.^attributes[5].set_value(self, a) };
  }

  method connections is rw {
      FETCH => -> $              { self.^attributes[6].get_value(self)    },
      STORE => -> $, GArray() \a { self.^attributes[6].set_value(self, a) };
  }

  method bandwidths is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[7].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[7].set_value(self, s) };
  }

  method attributes is rw {
    Proxy.new:
      FETCH => -> $              { self.^attributes[9].get_value(self)    },
      STORE => -> $, GArray() \a { self.^attributes[9].set_value(self, a) };
  }
}

class GstSDPMessage is repr<CStruct> does GLib::Roles::Pointers is export {
  has Str              $!version;
  HAS GstSDPOrigin     $.origin;
  has Str              $!session_name;
  has Str              $!information;
  has Str              $!uri;
  has GArray           $!emails;
  has GArray           $!phones;
  HAS GstSDPConnection $.connection;
  has GArray           $!bandwidths;
  has GArray           $!times;
  has GArray           $!zones;
  HAS GstSDPKey        $.key;
  has GArray           $!attributes;
  has GArray           $!medias;

  method version is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[9].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[9].set_value(self, s) };
  }

  method session_name is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[2].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[2].set_value(self, s) };
  }

  method information is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[3].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[3].set_value(self, s) };
  }

  method uri is rw {
    Proxy.new:
      FETCH => -> $           { self.^attributes[4].get_value(self)    },
      STORE => -> $, Str() \s { self.^attributes[4].set_value(self, s) };
  }

  method email is rw {
    Proxy.new:
      FETCH => -> $              { self.^attributes[5].get_value(self)    },
      STORE => -> $, GArray() \a { self.^attributes[5].set_value(self, a) };
  }

  method phones is rw {
    Proxy.new:
      FETCH => -> $              { self.^attributes[6].get_value(self)    },
      STORE => -> $, GArray() \a { self.^attributes[6].set_value(self, a) };
  }

  method bandwitdhs is rw {
    Proxy.new:
      FETCH => -> $              { self.^attributes[8].get_value(self)    },
      STORE => -> $, GArray() \a { self.^attributes[8].set_value(self, a) };
  }

  method times is rw {
    Proxy.new:
      FETCH => -> $              { self.^attributes[9].get_value(self)    },
      STORE => -> $, GArray() \a { self.^attributes[9].set_value(self, a) };
  }

  method zones is rw {
    Proxy.new:
      FETCH => -> $              { self.^attributes[10].get_value(self)    },
      STORE => -> $, GArray() \a { self.^attributes[10].set_value(self, a) };
  }

  method attributes is rw {
    Proxy.new:
      FETCH => -> $              { self.^attributes[12].get_value(self)    },
      STORE => -> $, GArray() \a { self.^attributes[12].set_value(self, a) };
  }

  method medias is rw {
    Proxy.new:
      FETCH => -> $              { self.^attributes[13].get_value(self)    },
      STORE => -> $, GArray() \a { self.^attributes[13].set_value(self, a) };
  }
}
