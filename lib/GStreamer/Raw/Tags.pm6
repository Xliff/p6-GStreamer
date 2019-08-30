use v6.c;

unit package GStreamer::Raw::Tags;

# Double
constant GST_TAG_ALBUM_GAIN                      is export = 'replaygain-album-gain';
constant GST_TAG_ALBUM_PEAK                      is export = 'replaygain-album-peak';
constant GST_TAG_BEATS_PER_MINUTE                is export = 'beats-per-minute';
constant GST_TAG_GEO_LOCATION_CAPTURE_DIRECTION  is export = 'geo-location-capture-direction';
constant GST_TAG_GEO_LOCATION_ELEVATION          is export = 'geo-location-elevation';
constant GST_TAG_GEO_LOCATION_HORIZONTAL_ERROR   is export = 'geo-location-horizontal-error';
constant GST_TAG_GEO_LOCATION_LATITUDE           is export = 'geo-location-latitude';
constant GST_TAG_GEO_LOCATION_LONGITUDE          is export = 'geo-location-longitude';
constant GST_TAG_GEO_LOCATION_MOVEMENT_DIRECTION is export = 'geo-location-movement-direction';
constant GST_TAG_GEO_LOCATION_MOVEMENT_SPEED     is export = 'geo-location-movement-speed';
constant GST_TAG_REFERENCE_LEVEL                 is export = 'replaygain-reference-level';
constant GST_TAG_TRACK_GAIN                      is export = 'replaygain-track-gain';
constant GST_TAG_TRACK_PEAK                      is export = 'replaygain-track-peak';

# GDate
constant GST_TAG_DATE                            is export = 'date';

# GstDateTime
constant GST_TAG_DATE_TIME                       is export = 'datetime';

# Uint
constant GST_TAG_ALBUM_VOLUME_COUNT              is export = 'album-disc-count';
constant GST_TAG_ALBUM_VOLUME_NUMBER             is export = 'album-disc-number';
constant GST_TAG_BITRATE                         is export = 'bitrate';
constant GST_TAG_ENCODER_VERSION                 is export = 'encoder-version';
constant GST_TAG_MAXIMUM_BITRATE                 is export = 'maximum-bitrate';
constant GST_TAG_MIDI_BASE_NOTE                  is export = 'midi-base-note';
constant GST_TAG_MINIMUM_BITRATE                 is export = 'minimum-bitrate';
constant GST_TAG_NOMINAL_BITRATE                 is export = 'nominal-bitrate';
constant GST_TAG_SERIAL                          is export = 'serial';
constant GST_TAG_SHOW_EPISODE_NUMBER             is export = 'show-episode-number';
constant GST_TAG_SHOW_SEASON_NUMBER              is export = 'show-season-number';
constant GST_TAG_TRACK_NUMBER                    is export = 'track-number';
constant GST_TAG_USER_RATING                     is export = 'user-rating';

# Uint64
constant GST_TAG_DURATION                        is export = 'duration';

# Sample
constant GST_TAG_APPLICATION_DATA                is export = 'application-data';
constant GST_TAG_ATTACHMENT                      is export = 'attachment';
constant GST_TAG_IMAGE                           is export = 'image';
constant GST_TAG_PREVIEW_IMAGE                   is export = 'preview-image';
constant GST_TAG_PRIVATE_DATA                    is export = 'private-data';

# String
constant GST_TAG_ALBUM                           is export = 'album';
constant GST_TAG_ALBUM_ARTIST                    is export = 'album-artist';
constant GST_TAG_ALBUM_ARTIST_SORTNAME           is export = 'album-artist-sortname';
constant GST_TAG_ALBUM_SORTNAME                  is export = 'album-sortname';
constant GST_TAG_APPLICATION_NAME                is export = 'application-name';
constant GST_TAG_ARTIST                          is export = 'artist';
constant GST_TAG_ARTIST_SORTNAME                 is export = 'artist-sortname';
constant GST_TAG_AUDIO_CODEC                     is export = 'audio-codec';
constant GST_TAG_CODEC                           is export = 'codec';
constant GST_TAG_COMMENT                         is export = 'comment';
constant GST_TAG_COMPOSER                        is export = 'composer';
constant GST_TAG_COMPOSER_SORTNAME               is export = 'composer-sortname';
constant GST_TAG_CONDUCTOR                       is export = 'conductor';
constant GST_TAG_CONTACT                         is export = 'contact';
constant GST_TAG_CONTAINER_FORMAT                is export = 'container-format';
constant GST_TAG_COPYRIGHT                       is export = 'copyright';
constant GST_TAG_COPYRIGHT_URI                   is export = 'copyright-uri';
constant GST_TAG_DESCRIPTION                     is export = 'description';
constant GST_TAG_DEVICE_MANUFACTURER             is export = 'device-manufacturer';
constant GST_TAG_DEVICE_MODEL                    is export = 'device-model';
constant GST_TAG_ENCODED_BY                      is export = 'encoded-by';
constant GST_TAG_ENCODER                         is export = 'encoder';
constant GST_TAG_EXTENDED_COMMENT                is export = 'extended-comment';
constant GST_TAG_GENRE                           is export = 'genre';
constant GST_TAG_GEO_LOCATION_CITY               is export = 'geo-location-city';
constant GST_TAG_GEO_LOCATION_COUNTRY            is export = 'geo-location-country';
constant GST_TAG_GEO_LOCATION_NAME               is export = 'geo-location-name';
constant GST_TAG_GEO_LOCATION_SUBLOCATION        is export = 'geo-location-sublocation';
constant GST_TAG_GROUPING                        is export = 'grouping';
constant GST_TAG_HOMEPAGE                        is export = 'homepage';
constant GST_TAG_IMAGE_ORIENTATION               is export = 'image-orientation';
constant GST_TAG_INTERPRETED_BY                  is export = 'interpreted-by';
constant GST_TAG_ISRC                            is export = 'isrc';
constant GST_TAG_KEYWORDS                        is export = 'keywords';
constant GST_TAG_LANGUAGE_CODE                   is export = 'language-code';
constant GST_TAG_LANGUAGE_NAME                   is export = 'language-name';
constant GST_TAG_LICENSE                         is export = 'license';
constant GST_TAG_LICENSE_URI                     is export = 'license-uri';
constant GST_TAG_LOCATION                        is export = 'location';
constant GST_TAG_LYRICS                          is export = 'lyrics';
constant GST_TAG_ORGANIZATION                    is export = 'organization';
constant GST_TAG_PERFORMER                       is export = 'performer';
constant GST_TAG_PUBLISHER                       is export = 'publisher';
constant GST_TAG_SHOW_NAME                       is export = 'show-name';
constant GST_TAG_SHOW_SORTNAME                   is export = 'show-sortname';
constant GST_TAG_SUBTITLE_CODEC                  is export = 'subtitle-codec';
constant GST_TAG_TITLE                           is export = 'title';
constant GST_TAG_TITLE_SORTNAME                  is export = 'title-sortname';
constant GST_TAG_TRACK_COUNT                     is export = 'track-count';
constant GST_TAG_VERSION                         is export = 'version';
constant GST_TAG_VIDEO_CODEC                     is export = 'video-codec';

# This will not cover custom tags, so we will need to hijack tag registration
# so as to keep this up to date.
our %tagType is export = (
  replaygain-album-gain           => 'double',
  replaygain-album-peak           => 'double',
  beats-per-minute                => 'double',
  geo-location-capture-direction  => 'double',
  geo-location-elevation          => 'double',
  geo-location-horizontal-error   => 'double',
  geo-location-latitude           => 'double',
  geo-location-longitude          => 'double',
  geo-location-movement-direction => 'double',
  geo-location-movement-speed     => 'double',
  replaygain-reference-level      => 'double',
  replaygain-track-gain           => 'double',
  replaygain-track-peak           => 'double',

  date                            => 'GDate',
  datetime                        => 'GstDateTime',

  album-disc-count                => 'uint32',
  album-disc-number               => 'uint32',
  bitrate                         => 'uint32',
  encoder-version                 => 'uint32',
  maximum-bitrate                 => 'uint32',
  midi-base-note                  => 'uint32',
  minimum-bitrate                 => 'uint32',
  nominal-bitrate                 => 'uint32',
  serial                          => 'uint32',
  show-episode-number             => 'uint32',
  show-season-number              => 'uint32',
  track-number                    => 'uint32',
  user-rating                     => 'uint32',

  'duration'                      => 'uint64',

  application-data                => 'sample',
  attachment                      => 'sample',
  image                           => 'sample',
  preview-image                   => 'sample',
  private-data                    => 'sample',

  album                           => 'string',
  album-artist                    => 'string',
  album-artist-sortname           => 'string',
  album-sortname                  => 'string',
  application-name                => 'string',
  artist                          => 'string',
  artist-sortname                 => 'string',
  audio-codec                     => 'string',
  codec                           => 'string',
  comment                         => 'string',
  composer                        => 'string',
  composer-sortname               => 'string',
  conductor                       => 'string',
  contact                         => 'string',
  container-format                => 'string',
  copyright                       => 'string',
  copyright-uri                   => 'string',
  description                     => 'string',
  device-manufacturer             => 'string',
  device-model                    => 'string',
  encoded-by                      => 'string',
  encoder                         => 'string',
  extended-comment                => 'string',
  genre                           => 'string',
  geo-location-city               => 'string',
  geo-location-country            => 'string',
  geo-location-name               => 'string',
  geo-location-sublocation        => 'string',
  grouping                        => 'string',
  homepage                        => 'string',
  image-orientation               => 'string',
  interpreted-by                  => 'string',
  isrc                            => 'string',
  keywords                        => 'string',
  language-code                   => 'string',
  language-name                   => 'string',
  license                         => 'string',
  license-uri                     => 'string',
  location                        => 'string',
  lyrics                          => 'string',
  organization                    => 'string',
  performer                       => 'string',
  publisher                       => 'string',
  show-name                       => 'string',
  show-sortname                   => 'string',
  subtitle-codec                  => 'string',
  title                           => 'string',
  title-sortname                  => 'string',
  track-count                     => 'string',
  version                         => 'string',
  video-codec                     => 'string'
);
