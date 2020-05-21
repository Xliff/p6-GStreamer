use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Plugins::Pango::Raw;

use GLib::Value;
use GStreamer::Element;
use GStreamer::Value;

# Skipping GstBaseTextOverlay, for now.

our subset GstTextOverlayAncestry is export of Mu
  where GstTextOverlay | GstElementAncestry;

class GStreamer::Plugins::Pango::TextOverlay is GStreamer::Element {
  has GstTextOverlay $!t;

  submethod BUILD (:$text-overlay) {
    self.setTextOverlay($text-overlay);
  }

  method setTextOverlay (GstTextOverlayAncestry $_) {
    my $to-parent;

    $!t = do {
      when GstTextOverlay {
        $to-parent = cast(GstElement, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstTextOverlay, $_);
      }
    }
    self.setGstElement($to-parent);
  }

  method GStreamer::Plugins::Pango::Raw::GstTextOverlay
    is also<GstTextOverlay>
  { $!t }

  method new (GstTextOverlayAncestry $text-overlay) {
    $text-overlay ?? self.bless( :$text-overlay ) !! Nil;
  }

  # Type: gboolean
  method auto-resize is rw  is also<auto_resize> {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('auto-resize', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('auto-resize', $gv);
      }
    );
  }

  # Type: guint
  method color is rw  {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('color', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('color', $gv);
      }
    );
  }

  # Type: gint
  method deltax is rw  {
    my $gv = GLib::Value.new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('deltax', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('deltax', $gv);
      }
    );
  }

  # Type: gint
  method deltay is rw  {
    my $gv = GLib::Value.new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('deltay', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('deltay', $gv);
      }
    );
  }

  # Type: gboolean
  method draw-outline is rw  is also<draw_outline> {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('draw-outline', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('draw-outline', $gv);
      }
    );
  }

  # Type: gboolean
  method draw-shadow is rw  is also<draw_shadow> {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('draw-shadow', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('draw-shadow', $gv);
      }
    );
  }

  # Type: gchararray
  method font-desc is rw  is also<font_desc> {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('font-desc', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('font-desc', $gv);
      }
    );
  }

  # Type: Base-text-overlay-halign
  method halignment is rw  {
    my $gv = GLib::Value.new(
      GLib::Value.typeFromEnum(GstBaseTextOverlayHAlign)
    );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('halignment', $gv)
        );
        GstBaseTextOverlayHAlignEnum($gv.enum)
      },
      STORE => -> $, Int() $val is copy {
        $gv.valueFromEnum(GstBaseTextOverlayHAlign) = $val;
        self.prop_set('halignment', $gv);
      }
    );
  }

  # Type: Base-text-overlay-line-align
  method line-alignment is rw  is also<line_alignment> {
    my $gv = GLib::Value.new(
      GLib::Value.typeFromEnum(GstBaseTextOverlayLineAlign)
    );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('line-alignment', $gv)
        );
        GstBaseTextOverlayLineAlignEnum($gv.enum);
      },
      STORE => -> $, Int() $val is copy {
        $gv.valueFromEnum(GstBaseTextOverlayLineAlign) = $val;
        self.prop_set('line-alignment', $gv);
      }
    );
  }

  # Type: gchararray
  method name is rw  {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('name', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('name', $gv);
      }
    );
  }

  # Type: guint
  method outline-color is rw  is also<outline_color> {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('outline-color', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('outline-color', $gv);
      }
    );
  }

  # Type: GstObject
  method parent (:$raw = False) is rw  {
    my $gv = GLib::Value.new( GStreamer::Object.get-type );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('parent', $gv)
        );

        my $o = $gv.object;
        return Nil unless $o;

        $o = cast(GstObject, $o);
        return $o if $raw;

        GStreamer::Object.new($o)
      },
      STORE => -> $, GstObject() $val is copy {
        $gv.object = $val;
        self.prop_set('parent', $gv);
      }
    );
  }

  # Type: Base-text-overlay-scale-mode
  method scale-mode is rw  is also<scale_mode> {
    my $gv = GLib::Value.new(
      GLib::Value.typeFromEnum(GstBaseTextOverlayScaleMode)
    );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('scale-mode', $gv)
        );
        GstBaseTextOverlayScaleModeEnum( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv.valueFromEnum(GstBaseTextOverlayScaleMode) = $val;
        self.prop_set('scale-mode', $gv);
      }
    );
  }

  # Type:
  method scale-pixel-aspect-ratio is rw  is also<scale_pixel_aspect_ratio> {
    Proxy.new(
      FETCH => sub ($) {
        my $gv = GStreamer::Value.new( GStreamer::Value.fraction-get-type );
        $gv = GStreamer::Value.new(
          self.prop_get('scale-pixel-aspect-ratio', $gv)
        );
      },
      STORE => -> $, GValue() $val is copy {
        self.prop_set('scale-pixel-aspect-ratio', $val);
      }
    );
  }

  # Type: gboolean
  method shaded-background is rw  is also<shaded_background> {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('shaded-background', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('shaded-background', $gv);
      }
    );
  }

  # Type: guint
  method shading-value is rw  is also<shading_value> {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('shading-value', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        $gv.uint = $val;
        self.prop_set('shading-value', $gv);
      }
    );
  }

  # Type: gboolean
  method silent is rw  {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('silent', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('silent', $gv);
      }
    );
  }

  # Type: gchararray
  method text is rw  {
    my $gv = GLib::Value.new( G_TYPE_STRING );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('text', $gv)
        );
        $gv.string;
      },
      STORE => -> $, Str() $val is copy {
        $gv.string = $val;
        self.prop_set('text', $gv);
      }
    );
  }

  # Type: guint
  method text-height is rw  is also<text_height> {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('text-height', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        warn 'text-height does not allow writing'
      }
    );
  }

  # Type: guint
  method text-width is rw  is also<text_width> {
    my $gv = GLib::Value.new( G_TYPE_UINT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('text-width', $gv)
        );
        $gv.uint;
      },
      STORE => -> $, Int() $val is copy {
        warn 'text-width does not allow writing'
      }
    );
  }

  # Type: gint
  method text-x is rw  is also<text_x> {
    my $gv = GLib::Value.new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('text-x', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        warn 'text-x does not allow writing'
      }
    );
  }

  # Type: gint
  method text-y is rw  is also<text_y> {
    my $gv = GLib::Value.new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('text-y', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        warn 'text-y does not allow writing'
      }
    );
  }

  # Type: Base-text-overlay-valign
  method valignment is rw  {
    my $gv = GLib::Value.new(
      GLib::Value.typeFromEnum(GstBaseTextOverlayVAlign)
    );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('valignment', $gv)
        );
        GstBaseTextOverlayVAlignEnum($gv.enum);
      },
      STORE => -> $, Int() $val is copy {
        $gv.valueFromEnum(GstBaseTextOverlayVAlign) = $val;
        self.prop_set('valignment', $gv);
      }
    );
  }

  # Type: gboolean
  method vertical-render is rw  is also<vertical_render> {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('vertical-render', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('vertical-render', $gv);
      }
    );
  }

  # Type: gboolean
  method wait-text is rw  is also<wait_text> {
    my $gv = GLib::Value.new( G_TYPE_BOOLEAN );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('wait-text', $gv)
        );
        $gv.boolean;
      },
      STORE => -> $, Int() $val is copy {
        $gv.boolean = $val;
        self.prop_set('wait-text', $gv);
      }
    );
  }

  # Type: Base-text-overlay-wrap-mode
  method wrap-mode is rw  is also<wrap_mode> {
    my $gv = GLib::Value.new(
      GLib::Value.typeFromEnum(GstBaseTextOverlayWrapMode)
    );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('wrap-mode', $gv)
        );
        GstBaseTextOverlayWrapModeEnum( $gv.enum );
      },
      STORE => -> $, Int() $val is copy {
        $gv.valueFromEnum(GstBaseTextOverlayWrapMode) = $val;
        self.prop_set('wrap-mode', $gv);
      }
    );
  }

  # Type: gdouble
  method x-absolute is rw  is also<x_absolute> {
    my $gv = GLib::Value.new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('x-absolute', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('x-absolute', $gv);
      }
    );
  }

  # Type: gint
  method xpad is rw  {
    my $gv = GLib::Value.new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('xpad', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('xpad', $gv);
      }
    );
  }

  # Type: gdouble
  method xpos is rw  {
    my $gv = GLib::Value.new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('xpos', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('xpos', $gv);
      }
    );
  }

  # Type: gdouble
  method y-absolute is rw  is also<y_absolute> {
    my $gv = GLib::Value.new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('y-absolute', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('y-absolute', $gv);
      }
    );
  }

  # Type: gint
  method ypad is rw  {
    my $gv = GLib::Value.new( G_TYPE_INT );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('ypad', $gv)
        );
        $gv.int;
      },
      STORE => -> $, Int() $val is copy {
        $gv.int = $val;
        self.prop_set('ypad', $gv);
      }
    );
  }

  # Type: gdouble
  method ypos is rw  {
    my $gv = GLib::Value.new( G_TYPE_DOUBLE );
    Proxy.new(
      FETCH => sub ($) {
        $gv = GLib::Value.new(
          self.prop_get('ypos', $gv)
        );
        $gv.double;
      },
      STORE => -> $, Num() $val is copy {
        $gv.double = $val;
        self.prop_set('ypos', $gv);
      }
    );
  }

}
