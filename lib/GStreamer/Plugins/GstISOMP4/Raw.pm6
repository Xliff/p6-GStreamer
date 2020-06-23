use v6.c;

use NativeCall;

use GStreamer::Raw::Types;

use GLib::Roles::Pointers;

use GStreamer::Class::Element;

unit package GStreamer::Plugins::GstISOMP4::Raw;

constant AtomsTreeFlavor is export := guint32;
our enum AtomsTreeFlavorEnum is export <
  ATOMS_TREE_FLAVOR_MOV
  ATOMS_TREE_FLAVOR_ISOM
  ATOMS_TREE_FLAVOR_3GP
  ATOMS_TREE_FLAVOR_ISML
>;

constant GstIsoffParserResult is export := guint32;
our enum GstIsoffParserResultEnum is export <
  GST_ISOFF_QT_PARSER_OK
  GST_ISOFF_QT_PARSER_DONE
  GST_ISOFF_QT_PARSER_UNEXPECTED
  GST_ISOFF_QT_PARSER_ERROR
>;

constant GstQTMuxFormat is export := guint32;
our enum GstQTMuxFormatEnum is export (
  GST_QT_MUX_FORMAT_NONE => 0,
  'GST_QT_MUX_FORMAT_QT',
  'GST_QT_MUX_FORMAT_MP4',
  'GST_QT_MUX_FORMAT_3GP',
  'GST_QT_MUX_FORMAT_MJ2',
  'GST_QT_MUX_FORMAT_ISML'
);

constant GstQTMuxState is export := guint32;
our enum GstQTMuxStateEnum is export <
  GST_QT_MUX_STATE_NONE
  GST_QT_MUX_STATE_STARTED
  GST_QT_MUX_STATE_DATA
  GST_QT_MUX_STATE_EOS
>;

constant GstQtMuxMode is export := guint32;
our enum GstQtMuxModeEnum is export <
  GST_QT_MUX_MODE_MOOV_AT_END
  GST_QT_MUX_MODE_FRAGMENTED
  GST_QT_MUX_MODE_FRAGMENTED_STREAMABLE
  GST_QT_MUX_MODE_FAST_START
  GST_QT_MUX_MODE_ROBUST_RECORDING
  GST_QT_MUX_MODE_ROBUST_RECORDING_PREFILL
>;

constant GstSidxParserStatus is export := guint32;
our enum GstSidxParserStatusEnum is export <
  GST_ISOFF_QT_SIDX_PARSER_INIT
  GST_ISOFF_QT_SIDX_PARSER_HEADER
  GST_ISOFF_QT_SIDX_PARSER_DATA
  GST_ISOFF_QT_SIDX_PARSER_FINISHED
>;

constant QtFlags is export := guint32;
our enum QtFlagsEnum is export (
  QT_FLAG_NONE      =>      (0),
  QT_FLAG_CONTAINER => (1 +< 0),
);

constant SampleEntryKind is export := guint32;
our enum SampleEntryKindEnum is export <
  UNKNOWN
  AUDIO
  VIDEO
  SUBTITLE
  TIMECODE
  CLOSEDCAPTION
>;

constant TrFlags is export := guint32;
our enum TrFlagsEnum is export (
  TR_DATA_OFFSET              => 0x01,               #= data-offset-present
  TR_FIRST_SAMPLE_FLAGS       => 0x04,               #= first-sample-flags-present
  TR_SAMPLE_DURATION          => 0x0100,             #= sample-duration-present
  TR_SAMPLE_SIZE              => 0x0200,             #= sample-size-present
  TR_SAMPLE_FLAGS             => 0x0400,             #= sample-flags-present
  TR_COMPOSITION_TIME_OFFSETS => 0x0800              #= sample-composition-time-offsets-presents
);

constant TfFlags is export := guint32;
our enum TfFlagsEnum is export (
  TF_BASE_DATA_OFFSET         => 0x01,               #= base-data-offset-present
  TF_SAMPLE_DESCRIPTION_INDEX => 0x02,               #= sample-description-index-present
  TF_DEFAULT_SAMPLE_DURATION  => 0x08,               #= default-sample-duration-present
  TF_DEFAULT_SAMPLE_SIZE      => 0x010,              #= default-sample-size-present
  TF_DEFAULT_SAMPLE_FLAGS     => 0x020,              #= default-sample-flags-present
  TF_DURATION_IS_EMPTY        => 0x010000,           #= sample-composition-time-offsets-presents
  TF_DEFAULT_BASE_IS_MOOF     => 0x020000            #= default-base-is-moof
);

constant TcFlags is export := guint32;
our enum TcFlagsEnum (
  TC_DROP_FRAME  => 0x0001,                          #= Drop-frame timecode */
  TC_24H_MAX     => 0x0002,                          #= Whether the timecode wraps after 24 hours */
  TC_NEGATIVE_OK => 0x0004,                          #= Whether negative time values are OK */
  TC_COUNTER     => 0x0008                           #= Whether the time value corresponds to a tape counter value */
);

class TimeInfo is repr<CStruct> does GLib::Roles::Pointers is export {
  has guint64          $.creation_time;
  has guint64          $.modification_time;
  has guint32          $.timescale;
  has guint64          $.duration;
}

class BaseDescriptor is repr<CStruct> does GLib::Roles::Pointers is export {
  has guint8           $.tag;
  HAS guint8           @.size[4] is CArray;          #= the first bit of each byte indicates if the next byte should be used
}

class SLConfigDescriptor is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS BaseDescriptor  $.base;
  has guint8          $.predefined;                  #= everything is supposed predefined
}

class DecoderSpecificInfoDescriptor is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS BaseDescriptor  $.base;
  has guint32         $.length;
  has CArray[guint8]  $.data;
}

class DecoderConfigDescriptor is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS BaseDescriptor                $.base;
  has guint8                        $.object_type;
  has guint8                        $.stream_type;   #= following are condensed into streamType:
                                                     #= bit(6) streamType;
                                                     #= bit(1) upStream;
                                                     #= const bit(1) reserved=1;
  has guint8                        @.buffer_size_DB[3] is CArray;
  has guint32                       $.max_bitrate;
  has guint32                       $.avg_bitrate;
  has DecoderSpecificInfoDescriptor $.dec_specific_info;
}

class ESDescriptor is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS BaseDescriptor          $.base;
  has guint16                 $.id;
  has guint8                  $.flags;               #= flags contains the following:
                                                     #= bit(1) streamDependenceFlag;
                                                     #= bit(1) URL_Flag;
                                                     #= bit(1) OCRstreamFlag;
                                                     #= bit(5) streamPriority;;

  has guint16                 $.depends_on_es_id;
  has guint8                  $.url_length;          #= only if URL_flag is set
  has CArray[guint8]          $.url_string;          #= size is url_length
  has guint16                 $.ocr_es_id;           #= only if OCRstreamFlag is set
  HAS DecoderConfigDescriptor $.dec_conf_desc;
  HAS SLConfigDescriptor      $.sl_conf_desc;
}

class Atom is repr<CStruct> does GLib::Roles::Pointers is export {
  has guint32          $.size;
  has guint32          $.type;
  has guint64          $.extended_size;
}

class AtomInfo is repr<CStruct> does GLib::Roles::Pointers is export {
  has Atom             $.atom;
  has Pointer          $.copy_data_func;             #= AtomCopyDataFunc
  has Pointer          $.free_func;                  #= AtomFreeFunc
}

class AtomFull is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS Atom             $.header;
  has guint8           $.version;
  HAS guint8           @.flags[3] is CArray;
}

class AtomData is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS Atom             $.header;
  has guint32          $.datalen;
  has CArray[uint8]    $.data;
}

class AtomUUID is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS Atom             $.header;
  HAS guint8           @.uuid[16] is CArray;
  has guint32          $.datalen;
  has CArray[guint8]   $.data;
}

class AtomFTYP is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS Atom             $.header;
  has guint32          $.major_brand;
  has guint32          $.version;
  has CArray[guint32]  $.compatible_brands;
  has guint32          $.compatible_brands_size;
}

class AtomMVHD is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  HAS TimeInfo         $.time_info;
  has guint32          $.prefered_rate;             #= ISO: 0x00010000
  has guint16          $.volume;                    #= ISO: 0x0100
  has guint16          $.reserved3;                 #= ISO: 0x0
  HAS guint32          @.reserved4[2] is CArray;    #= ISO: 0, 0
  HAS guint32          @.matrix[9]    is CArray;    #= ISO: identity matrix =
                                                    #= { 0x00010000, 0, 0, 0, 0x00010000, 0, 0, 0, 0x40000000 }
  has guint32          $.preview_time;
  has guint32          $.preview_duration;
  has guint32          $.poster_time;
  has guint32          $.selection_time;
  has guint32          $.selection_duration;
  has guint32          $.current_time;
  has guint32          $.next_track_id;
}

class AtomTKHD is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  has guint64          $.creation_time;
  has guint64          $.modification_time;
  has guint32          $.track_ID;
  has guint32          $.reserved;
  has guint64          $.duration;
  HAS guint32          @.reserved2[2] is CArray;
  has guint16          $.layer;
  has guint16          $.alternate_group;
  has guint16          $.volume;
  has guint16          $.reserved3;
  HAS guint32          @.matrix[9]    is CArray;     #=  ISO: identity matrix =
                                                     #=  { 0x00010000, 0, 0, 0, 0x00010000, 0, 0, 0, 0x40000000 } */
  has guint32          $.width;
  has guint32          $.height;
}

class AtomMDHD is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull        $.header;
  HAS TimeInfo        $.time_info;
  has guint16         $.language_code;
  has guint16         $.quality;
}

class AtomHDLR is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull        $.header;
  has guint32         $.component_type;
  has guint32         $.handler_type;
  has guint32         $.manufacturer;
  has guint32         $.flags;
  has guint32         $.flags_mask;
  has Str             $.name;
  has AtomsTreeFlavor $.flavor;
}

class AtomVMHD is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;          #= ISO: flags = 1
  has guint16          $.graphics_mode;
  HAS guint16          @.opcolor[3] is CArray;
}

class AtomSMHD is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  has guint16          $.balance;
  has guint16          $.reserved;
}

class AtomHMHD is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  has guint16          $.max_pdu_size;
  has guint16          $.avg_pdu_size;
  has guint32          $.max_bitrate;
  has guint32          $.avg_bitrate;
  has guint32          $.sliding_avg_bitrate;
}

class AtomTCMI is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  has guint16          $.text_font;
  has guint16          $.text_face;
  has guint16          $.text_size;
  HAS guint16          @.text_color[3] is CArray;
  HAS guint16          @.bg_color[3]   is CArray;
  has Str              $.font_name;
}

class AtomTMCD is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS Atom             $.header;
  HAS AtomTCMI         $.tcmi;
}

class AtomGMIN is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  has guint16          $.graphics_mode;
  HAS guint16          @.opcolor[3] is CArray;
  has guint8           $.balance;
  has guint8           $.reserved;
}

class AtomGMHD is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS Atom             $.header;
  HAS AtomGMIN         $.gmin;
  has AtomTMCD         $.tmcd;
}

class STTSEntry is repr<CStruct> does GLib::Roles::Pointers is export {
  has guint32          $.sample_count;
  has gint32           $.sample_delta;
}

class AtomSTTS is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  has Pointer          $.entries; #= ATOM_ARRAY (STTSEntry) entries;
}

class AtomSTSS is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  has Pointer          $.entries; #= ATOM_ARRAY (guint32) entries;
}

class AtomESDS is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  HAS ESDescriptor     $.es;
}

class AtomFRMA is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS Atom             $.header;
  has guint32          $.media_type;
}

class SampleTableEntry is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS Atom             $.header;
  HAS guint8           @.reserved[6] is CArray;
  has guint16          $.data_reference_index;
  has SampleEntryKind  $.kind;
}

class AtomHintSampleEntry is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS SampleTableEntry $.se;
  has guint32          $.size;
  has CArray[guint8]   $.data;
}

class SampleTableEntryMP4V is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS SampleTableEntry $.se;
  has guint16          $.version;
  has guint16          $.revision_level;
  has guint32          $.vendor;                     #= fourcc code
  has guint32          $.temporal_quality;
  has guint32          $.spatial_quality;
  has guint16          $.width;
  has guint16          $.height;
  has guint32          $.horizontal_resolution;
  has guint32          $.vertical_resolution;
  has guint32          $.datasize;
  has guint16          $.frame_count;                #= usually 1
  HAS guint8           @.compressor[32] is CArray;   #= pascal string, i.e. first byte = length
  has guint16          $.depth;
  has guint16          $.color_table_id;
  has GList            $.extension_atoms;            #= (optional) list of AtomInfo */
}

class SampleTableEntryMP4A is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS SampleTableEntry $.se;
  has guint16          $.version;
  has guint16          $.revision_level;
  has guint32          $.vendor;
  has guint16          $.channels;
  has guint16          $.sample_size;
  has guint16          $.compression_id;
  has guint16          $.packet_size;
  has guint32          $.sample_rate;                #= fixed point 16.16
  has guint32          $.samples_per_packet;
  has guint32          $.bytes_per_packet;
  has guint32          $.bytes_per_frame;
  has guint32          $.bytes_per_sample;
  has GList            $.extension_atoms;            #= (optional) list of AtomInfo
}

class AtomNAME is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS Atom             $.header;
  has guint8           $.language_code;
  has Str              $.name;
}

class SampleTableEntryTMCD is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS SampleTableEntry $.se;
  has guint32          $.tc_flags;
  has guint32          $.timescale;
  has guint32          $.frame_duration;
  has guint8           $.n_frames;
  HAS AtomNAME         $.name;
}

class SampleTableEntryTX3G is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS SampleTableEntry $.se;
  has guint32          $.display_flags;
  has guint64          $.default_text_box;
  has guint16          $.font_id;
  has guint8           $.font_face;                  #= bold=0x1, italic=0x2, underline=0x4
  has guint8           $.font_size;                  #= should always be 0.05 multiplied by the video track header height
  has guint32          $.foreground_color_rgba;
}

class AtomSTSD is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  has guint            $.n_entries;
  has GList            $.entries;                    #= list of subclasses of SampleTableEntry
}

class AtomSTSZ is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  has guint32          $.sample_size;
  has guint32          $.table_size;                 #= need the size here because when sample_size is constant,
                                                     #= the list is empty */
  has Pointer          $.entries;                    #= ATOM_ARRAY (guint32)
}

class STSCEntry is repr<CStruct> does GLib::Roles::Pointers is export {
  has guint32          $.first_chunk;
  has guint32          $.samples_per_chunk;
  has guint32          $.sample_description_index;
}

class AtomSTSC is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  has Pointer          $.entries;                    #= ATOM_ARRAY (STSCEntry)
}

class AtomTREF is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS Atom             $.header;
  has guint32          $.reftype;
  has Pointer          $.entries;                    #= ATOM_ARRAY (guint32)
}

class AtomSTCO64 is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  has guint32          $.chunk_offset;               #= Global offset to add to entries when serialising
  has Pointer          $.entries;                    #= ATOM_ARRAY (guint64)
}

class CTTSEntry is repr<CStruct> does GLib::Roles::Pointers is export {
  has guint32          $.samplecount;
  has guint32          $.sampleoffset;
}

class AtomCTTS is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  has Pointer          $.entries;                    #= also entry count here -- ATOM_ARRAY (CTTSEntry)
  has gboolean         $.do_pts;
}

class AtomSVMI is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  has guint8           $.stereoscopic_composition_type;
  has gboolean         $.is_left_first;
}

class AtomSTBL is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS Atom             $.header;
  HAS AtomSTSD         $.stsd;
  HAS AtomSTTS         $.stts;
  HAS AtomSTSS         $.stss;
  HAS AtomSTSC         $.stsc;
  HAS AtomSTSZ         $.stsz;
  has AtomCTTS         $.ctts;                       #= NULL if not present
  has AtomSVMI         $.svmi;                       #= NULL if not present
  HAS AtomSTCO64       $.stco64;
}

class AtomDREF is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  has GList            $.entries;
}

class AtomDINF is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS Atom             $.header;
  HAS AtomDREF         $.dref;
}

class AtomMINF is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS Atom             $.header;
  has AtomVMHD         $.vmhd;
  has AtomSMHD         $.smhd;
  has AtomHMHD         $.hmhd;
  has AtomGMHD         $.gmhd;
  has AtomHDLR         $.hdlr;
  HAS AtomDINF         $.dinf;
  HAS AtomSTBL         $.stbl;
}

class EditListEntry is repr<CStruct> does GLib::Roles::Pointers is export {
  has guint32          $.duration;                   #= duration in movie's timescale
  has guint32          $.media_time;                 #= start time in media's timescale, -1 for empty
  has guint32          $.media_rate;                 #= fixed point 32 bit
}

class AtomELST is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  has GSList           $.entries;                    #= number of entries is implicit
}

class AtomEDTS is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS Atom             $.header;
  HAS AtomELST         $.elst;
}

class AtomMDIA is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS Atom             $.header;
  HAS AtomMDHD         $.mdhd;
  HAS AtomHDLR         $.hdlr;
  HAS AtomMINF         $.minf;
}

class AtomILST is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS Atom             $.header;
  has GList            $.entries;                    #= list of AtomInfo
}

class AtomTagData is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  has guint32          $.reserved;
  has guint32          $.datalen;
  has CArray[guint8]   $.data;
}

class AtomTag is repr<CStruct> does GLib::Roles::Pointers is export {
  has Atom             $.header;
  has AtomTagData      $.data;
}

class AtomMETA is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  HAS AtomHDLR         $.hdlr;
  has AtomILST         $.ilst;
}

class AtomsContext is repr<CStruct> does GLib::Roles::Pointers is export {
  has AtomsTreeFlavor  $.flavor;
}

class AtomUDTA is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS Atom             $.header;
  has GList            $.entries;                    #= list of AtomInfo
  has AtomMETA         $.meta;                       #= or list is further down
  has AtomsContext     $.context;
}

class AtomTRAK is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS Atom             $.header;
  HAS AtomTKHD         $.tkhd;
  has AtomInfo         $.tapt;
  has AtomEDTS         $.edts;
  HAS AtomMDIA         $.mdia;
  HAS AtomUDTA         $.udta;
  has AtomTREF         $.tref;
  has gboolean         $.is_video;
  has gboolean         $.is_h264;
  has AtomsContext     $.context;
}

class AtomTREX is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  has guint32          $.track_ID;
  has guint32          $.default_sample_description_index;
  has guint32          $.default_sample_duration;
  has guint32          $.default_sample_size;
  has guint32          $.default_sample_flags;
}

class AtomMEHD is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  has guint64          $.fragment_duration;
}

class AtomMVEX is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS Atom             $.header;
  has AtomMEHD         $.mehd;
  has GList            $.trexs;                      #= list of AtomTREX
}

class AtomMFHD is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  has guint32          $.sequence_number;
}

class AtomTFHD is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  has guint32          $.track_ID;
  has guint64          $.base_data_offset;
  has guint32          $.sample_description_index;
  has guint32          $.default_sample_duration;
  has guint32          $.default_sample_size;
  has guint32          $.default_sample_flags;
}

class AtomTFDT is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  has guint64          $.base_media_decode_time;
}

class TRUNSampleEntry is repr<CStruct> does GLib::Roles::Pointers is export {
  has guint32          $.sample_duration;
  has guint32          $.sample_size;
  has guint32          $.sample_flags;
  has guint32          $.sample_composition_time_offset;
}

class AtomTRUN is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  has guint32          $.sample_count;
  has gint32           $.data_offset;
  has guint32          $.first_sample_flags;
  has Pointer          $.entries;                    #= array of fields -- ATOM_ARRAY (TRUNSampleEntry)
}

class AtomSDTP is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  has guint32          $.sample_count;               #= not serialized
  has Pointer          $.entries;                    #= array of fields -- ATOM_ARRAY (guint8)
}

class AtomTRAF is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS Atom             $.header;
  HAS AtomTFHD         $.tfd;
  HAS AtomTFDT         $.tfdt;
  has GList            $.truns;                      #= list of AtomTRUN
  has GList            $.sdtps;                      #= list of AtomSDTP
}

class AtomMOOF is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS Atom             $.header;
  HAS AtomMFHD         $.mfhd;
  has GList            $.trafs;                      #= list of AtomTRAF
}


class AtomMOOV is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomsContext     $.context;
  HAS Atom             $.header;
  HAS AtomMVHD         $.mvhd;
  HAS AtomMVEX         $.mvex;
  has GList            $.traks;                      #= list of AtomTRAK
  HAS AtomUDTA         $.udta;
  has gboolean         $.fragmented;
  has guint32          $.chunks_offset;
}

class AtomWAVE is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS Atom             $.header;
  has GList            $.extension_atoms;            #= list of AtomInfo
}

class TFRAEntry is repr<CStruct> does GLib::Roles::Pointers is export {
  has guint64          $.time;
  has guint64          $.moof_offset;
  has guint32          $.traf_number;
  has guint32          $.trun_number;
  has guint32          $.sample_number;
}

class AtomTFRA is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  has guint32          $.track_ID;
  has guint32          $.lengths;
  has Pointer          $.entries;                    #= ATOM_ARRAY (TFRAEntry)
}

class AtomMFRA is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS Atom             $.header;
  has GList            $.tfras;                      #= list of tfra (AtomTRFA or TRFAEntry?)
}

class AtomURL is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS AtomFull         $.header;
  has Str              $.location;
}

class GstQTPad is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS GstCollectData   $.collect;                       #= we extend the CollectData
  has guint32          $.fourcc;                        #= fourcc id of stream
  has gboolean         $.is_out_of_order;               #= whether using format that have out of order buffers
  has guint            $.sample_size;                   #= if not 0, track with constant sized samples, e.g. raw audio
  has gboolean         $.sync;                          #= make sync table entry
  has gboolean         $.sparse;                        #= if it is a sparse stream (meaning we can't use PTS differences to compute duration.
  has guint32          $.avg_bitrate;                   #= average bitrate
  has guint32          $.max_bitrate;                   #= max bitrate
  has guint            $.expected_sample_duration_n;
  has guint            $.expected_sample_duration_d;
  has guint64          $.total_bytes;
  has guint64          $.total_duration;
  has GstBuffer        $.last_buf;
  has GstClockTime     $.last_dts;                      #= dts of last_buf
  has guint64          $.sample_offset;
  has GstClockTime     $.dts_adjustment;                #= This is compensate for CTTS
  has GstClockTime     $.first_ts;
  has GstClockTime     $.first_dts;
  has AtomTRAK         $.trak;
  has AtomTRAK         $.tc_trak;
  has SampleTableEntry $.trak_ste;
  has AtomTRAF         $.traf;
  has Pointer          $.fragment_buffers;              #= fragment buffers -- ATOM_ARRAY (GstBuffer *)
  has gint64           $.fragment_duration;             #= running fragment duration
  has AtomTFRA         $.tfra;                          #= optional fragment index book-keeping
  has gboolean         $.tags_changed;                  #= Set when tags are received, cleared when written to moov
  has GstTagList       $.tags;
  has Pointer          $.prepare_buf_func;              #= GstQTPadPrepareBufferFunc
  has Pointer          $.set_caps;                      #= GstQTPadSetCapsFunc
  has Pointer          $.create_empty_buffer;           #= GstQTPadCreateEmptyBufferFunc
  has GstVideoTimeCode $.first_tc;
  has GstClockTime     $.first_pts;
  has guint64          $.tc_pos;
  has GArray           $.samples;                       #= for keeping track in pre-fill mode
  has GstAdapter       $.raw_audio_adapter;
  has guint64          $.raw_audio_adapter_offset;
  has GstClockTime     $.raw_audio_adapter_pts;
}

class GstQTMux is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS GstElement       $.element;
  has GstPad           $.srcpad;
  has GstCollectPads   $.collect;
  has GSList           $.sinkpads;
  has GstQTMuxState    $.state;                         #= state
  has GstQtMuxMode     $.mux_mode;                      #= Mux mode, inferred from property set in gst_qt_mux_start_file()
  has guint64          $.header_size;                   #= size of header (prefix, atoms (ftyp, possibly moov, mdat header))
  has guint64          $.mdat_size;                     #= accumulated size of raw media data (not including mdat header)
  has guint64          $.moov_pos;                      #= position of the moov (for fragmented mode) or reserved moov atom area (for robust-muxing mode)
  has guint64          $.mdat_pos;                      #= position of mdat atom header (for later updating of size) in moov-at-end, fragmented and robust-muxing modes
  has GstClockTime     $.longest_chunk;                 #= keep track of the largest chunk to fine-tune brands
  has GstClockTime     $.first_ts;                      #= Earliest timestamp across all pads/traks (unadjusted incoming PTS)
  has GstClockTime     $.last_dts;                      #= Last DTS across all pads (= duration)
  has GstQTPad         $.current_pad;
  has guint64          $.current_chunk_size;
  has GstClockTime     $.current_chunk_duration;
  has guint64          $.current_chunk_offset;
  has AtomsContext     $.context;
  has AtomFTYP         $.ftyp;
  has AtomMOOV         $.moov;
  has GSList           $.extra_atoms;                   #= List of extra top-level atoms (e.g. UUID for xmp) Stored as AtomInfo structs
  has gboolean         $.tags_changed;                  #= Set when tags are received, cleared when written to moov
  has AtomMFRA         $.mfra;                          #= fragmented file index
  has Pointer          $.fast_start_file;               #= FILE - fast start
  has Pointer          $.moov_recov_file;               #= FILE - Moov recovery
  has guint32          $.fragment_sequence;
  has guint32          $.timescale;
  has guint32          $.trak_timescale;
  has AtomsTreeFlavor  $.flavor;
  has gboolean         $.fast_start;
  has gboolean         $.guess_pts;

# #ifndef GST_REMOVE_DEPRECATED
#   gint dts_method;
# #endif

  has Str              $.fast_start_file_path;
  has Str              $.moov_recov_file_path;
  has guint32          $.fragment_duration;
  has gboolean         $.streamable;
  has GstClockTime     $.reserved_max_duration;
  has GstClockTime     $.reserved_duration_remaining;
  has guint            $.reserved_bytes_per_sec_per_trak;
  has guint64          $.interleave_bytes;
  has GstClockTime     $.interleave_time;
  has gboolean         $.interleave_bytes_set;
  has gboolean         $.interleave_time_set;
  has GstClockTime     $.max_raw_audio_drift;
  has guint32          $.reserved_moov_size;
  has guint32          $.base_moov_size;
  has guint32          $.last_moov_size;
  has gboolean         $.reserved_moov_first_active;
  has GstClockTime     $.last_moov_update;
  has GstClockTime     $.reserved_moov_update_period;
  has GstClockTime     $.muxed_since_last_update;
  has gboolean         $.reserved_prefill;
  has GstClockTime     $.start_gap_threshold;
  has guint            $.video_pads;
  has guint            $.audio_pads;
  has guint            $.subtitle_pads;
  has guint            $.caption_pads;
}

class GstQTMuxClass is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS GstElementClass  $.parent_class;
  has GstQTMuxFormat   $.format;
}

class GstQTMuxFormatProp is repr<CStruct> does GLib::Roles::Pointers is export {
  has GstQTMuxFormat   $.format;
  has GstRank          $.rank;
  has Str              $.name;
  has Str              $.long_name;
  has Str              $.type_name;
  HAS GstStaticCaps    $.src_caps;
  HAS GstStaticCaps    $.video_sink_caps;
  HAS GstStaticCaps    $.audio_sink_caps;
  HAS GstStaticCaps    $.subtitle_sink_caps;
  HAS GstStaticCaps    $.caption_sink_caps;
}

#| type register helper struct
class GstQTMuxClassParams is repr<CStruct> does GLib::Roles::Pointers is export {
  has GstQTMuxFormatProp $.prop;
  has GstCaps            $.src_caps;
  has GstCaps            $.video_sink_caps;
  has GstCaps            $.audio_sink_caps;
  has GstCaps            $.subtitle_sink_caps;
  has GstCaps            $.caption_sink_caps;
}

class VisualSampleEntry is repr<CStruct> does GLib::Roles::Pointers is export {
  has guint16            $.version;
  has guint32            $.fourcc;
  has guint              $.width;
  has guint              $.height;
  has guint              $.depth;
  has guint              $.frame_count;
  has gint               $.color_table_id;
  has guint              $.par_n;
  has guint              $.par_d;
  has GstBuffer          $.codec_data;
}

class AudioSampleEntry is repr<CStruct> does GLib::Roles::Pointers is export {
  has guint32            $.fourcc;
  has guint              $.version;
  has gint               $.compression_id;
  has guint              $.sample_rate;
  has guint              $.channels;
  has guint              $.sample_size;
  has guint              $.bytes_per_packet;
  has guint              $.samples_per_packet;
  has guint              $.bytes_per_sample;
  has guint              $.bytes_per_frame;
  has GstBuffer          $.codec_data;
}

class SubtitleSampleEntry is repr<CStruct> does GLib::Roles::Pointers is export {
  has guint32            $.fourcc;
  has guint8             $.font_face;                  #= bold=0x1, italic=0x2, underline=0x4 */
  has guint8             $.font_size;
  has guint32            $.foreground_color_rgba;
}
