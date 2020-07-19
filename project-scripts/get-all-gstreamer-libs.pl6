#!/usr/bin/env raku

my ($total-libs, $total-flags);
my @packages = <
    gstreamer-allocators-1.0    gstreamer-check-1.0         gstreamer-net-1.0
    gstreamer-app-1.0           gstreamer-controller-1.0    gstreamer-pbutils-1.0
    gstreamer-audio-1.0         gstreamer-fft-1.0           gstreamer-video-1.0
    gstreamer-1.0               gstreamer-base-1.0          gstreamer-gl-1.0
    gstreamer-riff-1.0          gstreamer-tag-1.0           gstreamer-rtp-1.0
    gstreamer-rtsp-1.0          gstreamer-plugins-good-1.0  gstreamer-sdp-1.0
    gstreamer-plugins-base-1.0
>;

$total-libs  ~= qqx{/usr/bin/pkg-config --libs $_} for @packages;
$total-flags ~= qqx{/usr/bin/pkg-config --cflags $_} for @packages;

$total-flags.lines.join(' ').say;
$total-libs.lines.join(' ').say;
