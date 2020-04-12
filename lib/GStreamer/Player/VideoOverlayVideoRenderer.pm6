use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Player::Raw::VideoOverlayVideoRenderer;

use GLib::Roles::Object;

our subset GstPlayerVideoOverlayVideoRendererAncestry is export of Mu
  where GstPlayerVideoOverlayVideoRenderer | GstVideoRenderer | GObject;

class GStreamer::Player::VideoOverlayVideoRenderer {
  also does GLib::Roles::Object;
  
  has $!vovr;

  submethod BUILD (:$vovr) {
    self.setVideoOverlayVideoRenderer($vovr);
  }

  submethod TWEAK {
    # Role init?
  }

  method setVideoOverlayVideoRenderer (
    GstPlayerVideoOverlayVideoRendererAncestry $_
  ) {
    my $to-parent;

    $!vovr = do {
      when GstPlayerVideoOverlayVideoRenderer {
        $to-parent = cast(GObject, $_);
        $_;
      }

      when GstVideoRenderer {
        $to-parent = cast(GObject, $_);
        cast(GstPlayerVideoOverlayVideoRenderer, $_);
      }

      default {
        $to-parent = $_;
        cast(GstPlayerVideoOverlayVideoRenderer, $_);
      }
    }
    self.setObject($to-parent);
  }

  method GStreamer::Raw::Definitions::GstPlayerVideoOverlayVideoRenderer
    is also<GstPlayerVideoOverlayVideoRenderer>
  { $!vovr }

  # Should be in a compunit dedicated for the role, but not there yet.
  method GStreamer::Raw::Definitions::GstPlayerVideoRenderer
    is also<GstPlayerVideoRenderer>
  { cast(GstPlayerVideoRenderer, $!vovr) }

  method new (gpointer $win_handle = gpointer) {
    my $vovr = gst_player_video_overlay_video_renderer_new($win_handle);

    $vovr ?? self.bless( :$vovr ) !! Nil;
  }

  proto method new_with_sink (|)
      is also<new-with-sink>
  { * }

  multi method new_with_sink (GstElement() $video_sink) {
    samewith(gpointer, $video_sink);
  }
  multi method new_with_sink (gpointer $win_handle, GstElement() $video_sink) {
    my $vovr = gst_player_video_overlay_video_renderer_new_with_sink(
      $win_handle,
      $video_sink
    );

    $vovr ?? self.bless( :$vovr ) !! Nil;
  }

  # Type: GstElement
  method video-sink (:$raw = False) is rw {
    my GLib::Value $gv .= new(G_TYPE_OBJECT);
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('video-sink', $gv);

        my $v = $gv.object;

        return Nil unless $v;
        $v = cast(GstElement, $v);
        $raw ?? $v !! GStreamer::Element.new($v);
      },
      STORE => -> $, GstElement() $val is copy {
        $gv.object = $val;
        self.prop_get('video-sink', $gv);
      }
    );
  }

  # Type: gpointer
  method window-handle is rw {
    my GLib::Value $gv .= new(G_TYPE_POINTER);
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('window-handle', $gv);

        my $v = $gv.pointer;

        $v ?? $v !! Nil
      },
      STORE => -> $, gpointer $val is copy {
        $gv.pointer = $val;
        self.prop_get('window-handle', $gv);
      }
    );
  }

  method expose {
    gst_player_video_overlay_video_renderer_expose($!vovr);
  }

  proto method get_render_rectangle (|)
      is also<get-render-rectangle>
  { * }

  multi method get_render_rectangle {
    samewith($, $, $, $);
  }
  multi method get_render_rectangle (
    $x is rw,
    $y is rw,
    $width is rw,
    $height is rw
  ) {
    my gint ($xx, $yy, $w, $h) = 0 xx 4;
    my &grr := &gst_player_video_overlay_video_renderer_get_render_rectangle;

    &grr($!vovr, $xx, $yy, $w, $h);
    ($x, $y, $width, $height) = ($xx, $yy, $w, $h);
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &gst_player_video_overlay_video_renderer_get_type,
      $n,
      $t
    );
  }

  method get_window_handle is also<get-window-handle> {
    gst_player_video_overlay_video_renderer_get_window_handle($!vovr);
  }

  method set_render_rectangle (
    Int() $x,
    Int() $y,
    Int() $width,
    Int() $height
  )
    is also<set-render-rectangle>
  {
    my gint ($xx, $yy, $w, $h) = ($x, $y, $width, $height);
    my &srr := &gst_player_video_overlay_video_renderer_set_render_rectangle;

    &srr($!vovr, $xx, $yy, $w, $h);
  }

  method set_window_handle (gpointer $window_handle)
    is also<set-window-handle>
  {
    gst_player_video_overlay_video_renderer_set_window_handle(
      $!vovr,
      $window_handle
    );
  }

}
