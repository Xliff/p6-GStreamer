use v6.c;

use GLib::Raw::Definitions;
use GLib::Raw::Structs;
use Pango::Raw::Definitions;
use Pango::Raw::Enums;
use Pango::Raw::Structs;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Enums;
use GStreamer::Raw::Structs;

use GLib::Roles::Pointers;

unit package GStreamer::Plugins::Pango::Raw;

constant GstBaseTextOverlayHAlign is export := guint32;
our enum GstBaseTextOverlayHAlignEnum is export <
  GST_BASE_TEXT_OVERLAY_HALIGN_LEFT
  GST_BASE_TEXT_OVERLAY_HALIGN_CENTER
  GST_BASE_TEXT_OVERLAY_HALIGN_RIGHT
  GST_BASE_TEXT_OVERLAY_HALIGN_UNUSED
  GST_BASE_TEXT_OVERLAY_HALIGN_POS
  GST_BASE_TEXT_OVERLAY_HALIGN_ABSOLUTE
>;

constant GstBaseTextOverlayLineAlign is export := guint32;
our enum GstBaseTextOverlayLineAlignEnum is export (
  GST_BASE_TEXT_OVERLAY_LINE_ALIGN_LEFT   => PANGO_ALIGN_LEFT,
  GST_BASE_TEXT_OVERLAY_LINE_ALIGN_CENTER => PANGO_ALIGN_CENTER,
  GST_BASE_TEXT_OVERLAY_LINE_ALIGN_RIGHT  => PANGO_ALIGN_RIGHT,
);

constant GstBaseTextOverlayScaleMode is export := guint32;
our enum GstBaseTextOverlayScaleModeEnum is export <
  GST_BASE_TEXT_OVERLAY_SCALE_MODE_NONE
  GST_BASE_TEXT_OVERLAY_SCALE_MODE_PAR
  GST_BASE_TEXT_OVERLAY_SCALE_MODE_DISPLAY
  GST_BASE_TEXT_OVERLAY_SCALE_MODE_USER
>;

constant GstBaseTextOverlayVAlign is export := guint32;
our enum GstBaseTextOverlayVAlignEnum is export <
  GST_BASE_TEXT_OVERLAY_VALIGN_BASELINE
  GST_BASE_TEXT_OVERLAY_VALIGN_BOTTOM
  GST_BASE_TEXT_OVERLAY_VALIGN_TOP
  GST_BASE_TEXT_OVERLAY_VALIGN_POS
  GST_BASE_TEXT_OVERLAY_VALIGN_CENTER
  GST_BASE_TEXT_OVERLAY_VALIGN_ABSOLUTE
>;

constant GstBaseTextOverlayWrapMode is export := gint32;
our enum GstBaseTextOverlayWrapModeEnum is export (
  GST_BASE_TEXT_OVERLAY_WRAP_MODE_NONE      => -1,
  GST_BASE_TEXT_OVERLAY_WRAP_MODE_WORD      => PANGO_WRAP_WORD.Int,
  GST_BASE_TEXT_OVERLAY_WRAP_MODE_CHAR      => PANGO_WRAP_CHAR.Int,
  GST_BASE_TEXT_OVERLAY_WRAP_MODE_WORD_CHAR => PANGO_WRAP_WORD_CHAR.Int
);

constant GstTextRenderHAlign is export := guint32;
our enum GstTextRenderHAlignEnum is export <
  GST_TEXT_RENDER_HALIGN_LEFT
  GST_TEXT_RENDER_HALIGN_CENTER
  GST_TEXT_RENDER_HALIGN_RIGHT
>;

constant GstTextRenderLineAlign is export := guint32;
our enum GstTextRenderLineAlignEnum is export (
  GST_TEXT_RENDER_LINE_ALIGN_LEFT   => PANGO_ALIGN_LEFT,
  GST_TEXT_RENDER_LINE_ALIGN_CENTER => PANGO_ALIGN_CENTER,
  GST_TEXT_RENDER_LINE_ALIGN_RIGHT  => PANGO_ALIGN_RIGHT,
);

constant GstTextRenderVAlign is export := guint32;
our enum GstTextRenderVAlignEnum is export <
  GST_TEXT_RENDER_VALIGN_BASELINE
  GST_TEXT_RENDER_VALIGN_BOTTOM
  GST_TEXT_RENDER_VALIGN_TOP
>;

constant GstTimeOverlayTimeLine is export := guint32;
our enum GstTimeOverlayTimeLineEnum is export <
  GST_TIME_OVERLAY_TIME_LINE_BUFFER_TIME
  GST_TIME_OVERLAY_TIME_LINE_STREAM_TIME
  GST_TIME_OVERLAY_TIME_LINE_RUNNING_TIME
  GST_TIME_OVERLAY_TIME_LINE_TIME_CODE
>;

class GstBaseTextOverlay is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS GstElement                  $.element;
  # Private
  has GstPad                      $!video_sinkpad;
  has GstPad                      $!text_sinkpad;
  has GstPad                      $!srcpad;
  has PangoContext                $!pango_context;
  HAS GstSegment                  $!segment;
  HAS GstSegment                  $!text_segment;
  has GstBuffer                   $!text_buffer;
  has gboolean                    $!text_linked;
  has gboolean                    $!video_flushing;
  has gboolean                    $!video_eos;
  has gboolean                    $!text_flushing;
  has gboolean                    $!text_eos;
  HAS GMutex                      $!lock;
  HAS GCond                       $!cond;
  # stream metrics
  HAS GstVideoInfo                $!info;
  has GstVideoFormat              $!format;
  has gint                        $!width;
  has gint                        $!height;
  # properties
  has gint                        $!xpad;
  has gint                        $!ypad;
  has gint                        $!deltax;
  has gint                        $!deltay;
  has gdouble                     $!xpos;
  has gdouble                     $!ypos;
  has Str                         $!default_text;
  has gboolean                    $!want_shading;
  has gboolean                    $!silent;
  has gboolean                    $!wait_text;
  has guint                       $!color;
  has gint                        $!outline_color;
  has PangoLayout                 $!layout;
  has gboolean                    $!auto_adjust_size;
  has gboolean                    $!draw_shadow;
  has gboolean                    $!draw_outline;
  has gint                        $!shading_value; #= timeoverlay subclass
  has gboolean                    $!use_vertical_render;
  has GstBaseTextOverlayVAlign    $!valign;
  has GstBaseTextOverlayHAlign    $!halign;
  has GstBaseTextOverlayWrapMode  $!wrap_mode;
  has GstBaseTextOverlayLineAlign $!line_align;
  has GstBaseTextOverlayScaleMode $!scale_mode;
  has gint                        $!scale_par_n;
  has gint                        $!scale_par_d;
  # text pad format
  has gboolean                    $!have_pango_markup;
  # rendering state
  has gboolean                    $!need_render;
  has GstBuffer                   $!text_image;
  has gint                        $!render_width;
  has gint                        $!render_height;
  has gdouble                     $!render_scale;  #= This is (render_width / width) uses to convert to stream scale
  # dimension of text_image, the physical dimension
  has guint                       $!text_width;
  has guint                       $!text_height;
  # position of rendering in image coordinates
  has gint                        $!text_x;
  has gint                        $!text_y;
  has gint                        $!window_width;
  has gint                        $!window_height;
  has gdouble                     $!shadow_offset;
  has gdouble                     $!outline_offset;
  HAS PangoRectangle              $!ink_rect;
  HAS PangoRectangle              $!logical_rect;
  has gboolean                    $!attach_compo_to_buffer;
  has GstVideoOverlayComposition  $!composition;
  has GstVideoOverlayComposition  $!upstream_composition;
}

class GstTextOverlay is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS GstBaseTextOverlay          $.parent;
}
