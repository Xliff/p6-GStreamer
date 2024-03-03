use v6.c;

use GLib::Raw::Definitions;
use GLib::Raw::Subs;

unit package GStreamer::Raw::Audio::Enums;

constant GstAudioBaseSinkDiscontReason is export := guint32;
our enum GstAudioBaseSinkDiscontReasonEnum is export <
  GST_AUDIO_BASE_SINK_DISCONT_REASON_NO_DISCONT
  GST_AUDIO_BASE_SINK_DISCONT_REASON_NEW_CAPS
  GST_AUDIO_BASE_SINK_DISCONT_REASON_FLUSH
  GST_AUDIO_BASE_SINK_DISCONT_REASON_SYNC_LATENCY
  GST_AUDIO_BASE_SINK_DISCONT_REASON_ALIGNMENT
  GST_AUDIO_BASE_SINK_DISCONT_REASON_DEVICE_FAILURE
>;

constant GstAudioBaseSinkSlaveMethod is export := guint32;
our enum GstAudioBaseSinkSlaveMethodEnum is export <
  GST_AUDIO_BASE_SINK_SLAVE_RESAMPLE
  GST_AUDIO_BASE_SINK_SLAVE_SKEW
  GST_AUDIO_BASE_SINK_SLAVE_NONE
  GST_AUDIO_BASE_SINK_SLAVE_CUSTOM
>;

constant GstAudioBaseSrcSlaveMethod is export := guint32;
our enum GstAudioBaseSrcSlaveMethodEnum is export <
  GST_AUDIO_BASE_SRC_SLAVE_RESAMPLE
  GST_AUDIO_BASE_SRC_SLAVE_RE_TIMESTAMP
  GST_AUDIO_BASE_SRC_SLAVE_SKEW
  GST_AUDIO_BASE_SRC_SLAVE_NONE
>;

constant GstAudioCdSrcMode is export := guint32;
our enum GstAudioCdSrcModeEnum is export <
  GST_AUDIO_CD_SRC_MODE_NORMAL
  GST_AUDIO_CD_SRC_MODE_CONTINUOUS
>;

constant GstAudioChannelMixerFlags is export := guint32;
our enum GstAudioChannelMixerFlagsEnum is export (
  GST_AUDIO_CHANNEL_MIXER_FLAGS_NONE                =>        0,
  GST_AUDIO_CHANNEL_MIXER_FLAGS_NON_INTERLEAVED_IN  => (1 +< 0),
  GST_AUDIO_CHANNEL_MIXER_FLAGS_NON_INTERLEAVED_OUT => (1 +< 1),
  GST_AUDIO_CHANNEL_MIXER_FLAGS_UNPOSITIONED_IN     => (1 +< 2),
  GST_AUDIO_CHANNEL_MIXER_FLAGS_UNPOSITIONED_OUT    => (1 +< 3),
);

constant GstAudioConverterFlags is export := guint32;
our enum GstAudioConverterFlagsEnum is export (
  GST_AUDIO_CONVERTER_FLAG_NONE          =>        0,
  GST_AUDIO_CONVERTER_FLAG_IN_WRITABLE   => (1 +< 0),
  GST_AUDIO_CONVERTER_FLAG_VARIABLE_RATE => (1 +< 1),
);

constant GstAudioFlags is export := guint32;
our enum GstAudioFlagsEnum is export (
  GST_AUDIO_FLAG_NONE         =>        0,
  GST_AUDIO_FLAG_UNPOSITIONED => (1 +< 0),
);

constant GstAudioFormatFlags is export := guint32;
our enum GstAudioFormatFlagsEnum is export (
  GST_AUDIO_FORMAT_FLAG_INTEGER => (1 +< 0),
  GST_AUDIO_FORMAT_FLAG_FLOAT   => (1 +< 1),
  GST_AUDIO_FORMAT_FLAG_SIGNED  => (1 +< 2),
  GST_AUDIO_FORMAT_FLAG_COMPLEX => (1 +< 4),
  GST_AUDIO_FORMAT_FLAG_UNPACK  => (1 +< 5),
);

constant GstAudioRingBufferFormatType is export := guint32;
our enum GstAudioRingBufferFormatTypeEnum is export <
  GST_AUDIO_RING_BUFFER_FORMAT_TYPE_RAW
  GST_AUDIO_RING_BUFFER_FORMAT_TYPE_MU_LAW
  GST_AUDIO_RING_BUFFER_FORMAT_TYPE_A_LAW
  GST_AUDIO_RING_BUFFER_FORMAT_TYPE_IMA_ADPCM
  GST_AUDIO_RING_BUFFER_FORMAT_TYPE_MPEG
  GST_AUDIO_RING_BUFFER_FORMAT_TYPE_GSM
  GST_AUDIO_RING_BUFFER_FORMAT_TYPE_IEC958
  GST_AUDIO_RING_BUFFER_FORMAT_TYPE_AC3
  GST_AUDIO_RING_BUFFER_FORMAT_TYPE_EAC3
  GST_AUDIO_RING_BUFFER_FORMAT_TYPE_DTS
  GST_AUDIO_RING_BUFFER_FORMAT_TYPE_MPEG2_AAC
  GST_AUDIO_RING_BUFFER_FORMAT_TYPE_MPEG4_AAC
  GST_AUDIO_RING_BUFFER_FORMAT_TYPE_MPEG2_AAC_RAW
  GST_AUDIO_RING_BUFFER_FORMAT_TYPE_MPEG4_AAC_RAW
  GST_AUDIO_RING_BUFFER_FORMAT_TYPE_FLAC
>;

constant GstAudioLayout is export := guint32;
our enum GstAudioLayoutEnum is export (
  GST_AUDIO_LAYOUT_INTERLEAVED     => 0,
  'GST_AUDIO_LAYOUT_NON_INTERLEAVED'
);

constant GstAudioPackFlags is export := guint32;
our enum GstAudioPackFlagsEnum is export (
  GST_AUDIO_PACK_FLAG_NONE           =>        0,
  GST_AUDIO_PACK_FLAG_TRUNCATE_RANGE => (1 +< 0),
);

constant GstAudioQuantizeFlags is export := guint32;
our enum GstAudioQuantizeFlagsEnum is export (
  GST_AUDIO_QUANTIZE_FLAG_NONE            =>        0,
  GST_AUDIO_QUANTIZE_FLAG_NON_INTERLEAVED => (1 +< 0),
);

constant GstAudioRingBufferState is export := guint32;
our enum GstAudioRingBufferStateEnum is export <
  GST_AUDIO_RING_BUFFER_STATE_STOPPED
  GST_AUDIO_RING_BUFFER_STATE_PAUSED
  GST_AUDIO_RING_BUFFER_STATE_STARTED
  GST_AUDIO_RING_BUFFER_STATE_ERROR
>;

constant GstAudioFormat is export := guint32;
enum GstAudioFormatNonEndianEnum is export (
  'GST_AUDIO_FORMAT_UNKNOWN',
  'GST_AUDIO_FORMAT_ENCODED',
  # 8 bit
  'GST_AUDIO_FORMAT_S8',
  'GST_AUDIO_FORMAT_U8',
  # 16 bit
  'GST_AUDIO_FORMAT_S16LE',
  'GST_AUDIO_FORMAT_S16BE',
  'GST_AUDIO_FORMAT_U16LE',
  'GST_AUDIO_FORMAT_U16BE',
  # 24 bit in low 3 bytes of 32 bits
  'GST_AUDIO_FORMAT_S24_32LE',
  'GST_AUDIO_FORMAT_S24_32BE',
  'GST_AUDIO_FORMAT_U24_32LE',
  'GST_AUDIO_FORMAT_U24_32BE',
  # 32 bit
  'GST_AUDIO_FORMAT_S32LE',
  'GST_AUDIO_FORMAT_S32BE',
  'GST_AUDIO_FORMAT_U32LE',
  'GST_AUDIO_FORMAT_U32BE',
  # 24 bit in 3 bytes
  'GST_AUDIO_FORMAT_S24LE',
  'GST_AUDIO_FORMAT_S24BE',
  'GST_AUDIO_FORMAT_U24LE',
  'GST_AUDIO_FORMAT_U24BE',
  # 20 bit in 3 bytes
  'GST_AUDIO_FORMAT_S20LE',
  'GST_AUDIO_FORMAT_S20BE',
  'GST_AUDIO_FORMAT_U20LE',
  'GST_AUDIO_FORMAT_U20BE',
  # 18 bit in 3 bytes
  'GST_AUDIO_FORMAT_S18LE',
  'GST_AUDIO_FORMAT_S18BE',
  'GST_AUDIO_FORMAT_U18LE',
  'GST_AUDIO_FORMAT_U18BE',
  # float
  'GST_AUDIO_FORMAT_F32LE',
  'GST_AUDIO_FORMAT_F32BE',
  'GST_AUDIO_FORMAT_F64LE',
  'GST_AUDIO_FORMAT_F64BE'
);

our enum GstAudioFormatEndianEnum is export (
  # native endianness equivalents
  GST_AUDIO_FORMAT_S16    => getEndian[0] ?? GST_AUDIO_FORMAT_S16BE
                                          !! GST_AUDIO_FORMAT_S16LE,
  GST_AUDIO_FORMAT_U16    => getEndian[0] ?? GST_AUDIO_FORMAT_U16BE
                                          !! GST_AUDIO_FORMAT_U16LE,
  GST_AUDIO_FORMAT_S24_32 => getEndian[0] ?? GST_AUDIO_FORMAT_S24_32BE
                                          !! GST_AUDIO_FORMAT_S24_32LE,
  GST_AUDIO_FORMAT_U24_32 => getEndian[0] ?? GST_AUDIO_FORMAT_U24_32BE
                                          !! GST_AUDIO_FORMAT_U24_32LE,
  GST_AUDIO_FORMAT_S32    => getEndian[0] ?? GST_AUDIO_FORMAT_S32BE
                                          !! GST_AUDIO_FORMAT_S32LE,
  GST_AUDIO_FORMAT_U32    => getEndian[0] ?? GST_AUDIO_FORMAT_U32BE
                                          !! GST_AUDIO_FORMAT_U32LE,
  GST_AUDIO_FORMAT_S24    => getEndian[0] ?? GST_AUDIO_FORMAT_S24BE
                                          !! GST_AUDIO_FORMAT_S24LE,
  GST_AUDIO_FORMAT_U24    => getEndian[0] ?? GST_AUDIO_FORMAT_U24BE
                                          !! GST_AUDIO_FORMAT_U24LE,
  GST_AUDIO_FORMAT_S20    => getEndian[0] ?? GST_AUDIO_FORMAT_S20BE
                                          !! GST_AUDIO_FORMAT_S20LE,
  GST_AUDIO_FORMAT_U20    => getEndian[0] ?? GST_AUDIO_FORMAT_U20BE
                                          !! GST_AUDIO_FORMAT_U20LE,
  GST_AUDIO_FORMAT_S18    => getEndian[0] ?? GST_AUDIO_FORMAT_S18BE
                                          !! GST_AUDIO_FORMAT_S18LE,
  GST_AUDIO_FORMAT_U18    => getEndian[0] ?? GST_AUDIO_FORMAT_U18BE
                                          !! GST_AUDIO_FORMAT_U18LE,
  GST_AUDIO_FORMAT_F32    => getEndian[0] ?? GST_AUDIO_FORMAT_F32BE
                                          !! GST_AUDIO_FORMAT_F32LE,
  GST_AUDIO_FORMAT_F64    => getEndian[0] ?? GST_AUDIO_FORMAT_F64BE
                                          !! GST_AUDIO_FORMAT_F64LE,
);

sub GstAudioFormatEnum (Int() $e) {
  ( GstAudioFormatNonEndianEnum($e) // 0) +
  ( GstAudioFormatEndianEnum($e)    // 0)
}

constant GstAudioChannelPosition is export := guint32;
our enum GstAudioChannelPositionEnum is export (
   # These get negative indices to allow to use
   # the enum values of the normal cases for the
   # bit-mask position
   GST_AUDIO_CHANNEL_POSITION_NONE       => -3,
   GST_AUDIO_CHANNEL_POSITION_MONO       => -2,
   GST_AUDIO_CHANNEL_POSITION_INVALID    => -1,

   # Normal cases
   GST_AUDIO_CHANNEL_POSITION_FRONT_LEFT => 0,
  'GST_AUDIO_CHANNEL_POSITION_FRONT_RIGHT',
  'GST_AUDIO_CHANNEL_POSITION_FRONT_CENTER',
  'GST_AUDIO_CHANNEL_POSITION_LFE1',
  'GST_AUDIO_CHANNEL_POSITION_REAR_LEFT',
  'GST_AUDIO_CHANNEL_POSITION_REAR_RIGHT',
  'GST_AUDIO_CHANNEL_POSITION_FRONT_LEFT_OF_CENTER',
  'GST_AUDIO_CHANNEL_POSITION_FRONT_RIGHT_OF_CENTER',
  'GST_AUDIO_CHANNEL_POSITION_REAR_CENTER',
  'GST_AUDIO_CHANNEL_POSITION_LFE2',
  'GST_AUDIO_CHANNEL_POSITION_SIDE_LEFT',
  'GST_AUDIO_CHANNEL_POSITION_SIDE_RIGHT',
  'GST_AUDIO_CHANNEL_POSITION_TOP_FRONT_LEFT',
  'GST_AUDIO_CHANNEL_POSITION_TOP_FRONT_RIGHT',
  'GST_AUDIO_CHANNEL_POSITION_TOP_FRONT_CENTER',
  'GST_AUDIO_CHANNEL_POSITION_TOP_CENTER',
  'GST_AUDIO_CHANNEL_POSITION_TOP_REAR_LEFT',
  'GST_AUDIO_CHANNEL_POSITION_TOP_REAR_RIGHT',
  'GST_AUDIO_CHANNEL_POSITION_TOP_SIDE_LEFT',
  'GST_AUDIO_CHANNEL_POSITION_TOP_SIDE_RIGHT',
  'GST_AUDIO_CHANNEL_POSITION_TOP_REAR_CENTER',
  'GST_AUDIO_CHANNEL_POSITION_BOTTOM_FRONT_CENTER',
  'GST_AUDIO_CHANNEL_POSITION_BOTTOM_FRONT_LEFT',
  'GST_AUDIO_CHANNEL_POSITION_BOTTOM_FRONT_RIGHT',
  'GST_AUDIO_CHANNEL_POSITION_WIDE_LEFT',
  'GST_AUDIO_CHANNEL_POSITION_WIDE_RIGHT',
  'GST_AUDIO_CHANNEL_POSITION_SURROUND_LEFT',
  'GST_AUDIO_CHANNEL_POSITION_SURROUND_RIGHT'
);
