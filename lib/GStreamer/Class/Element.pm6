use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;
use GStreamer::Class::Object;

use GLib::GList;

use GLib::Roles::Pointers;
use GLib::Roles::ListData;

class GstElementClass is repr<CStruct> does GLib::Roles::Pointers is export {
  HAS GstObjectClass        $.parent_class;
  # Public
  has gpointer              $.metadata;
  has GstElementFactory     $.elementfactory;
  has GList                 $.padtemplates;
  has gint                  $.numpadtemplates;
  has guint32               $.pad_templ_cookie;
  # Private
  has Pointer               $.pad_added;        #=  void (*pad_added)     (GstElement *element, GstPad *pad);
  has Pointer               $.pad_removed;      #=  void (*pad_removed)   (GstElement *element, GstPad *pad);
  has Pointer               $.no_more_pads;     #=  void (*no_more_pads)  (GstElement *element);
  # Public
  has Pointer               $.request_new_pad;  #= GstPad*               (*request_new_pad)      (GstElement *element, GstPadTemplate *templ,
                                                #=                                                const gchar* name, const GstCaps *caps);

  has Pointer               $.release_pad;      #=  void                  (*release_pad)          (GstElement *element, GstPad *pad);

  has Pointer               $.get_state;        #= GstStateChangeReturn (*get_state)             (GstElement * element, GstState * state,
                                                #=                                                GstState * pending, GstClockTime timeout);
  has Pointer               $.set_state;        #= GstStateChangeReturn (*set_state)             (GstElement *element, GstState state);
  has Pointer               $.change_state;     #= GstStateChangeReturn (*change_state)          (GstElement *element, GstStateChange transition);
  has Pointer               $.state_changed;    #= void                 (*state_changed)         (GstElement *element, GstState oldstate,
                                                #=                                                GstState newstate, GstState pending);
  has Pointer               $.set_bus;          #= void                  (*set_bus)              (GstElement * element, GstBus * bus);
  has Pointer               $.provide_clock;    #= GstClock*             (*provide_clock)        (GstElement *element);
  has Pointer               $.set_clock;        #= gboolean              (*set_clock)            (GstElement *element, GstClock *clock);
  has Pointer               $.send_event;       #= gboolean              (*send_event)           (GstElement *element, GstEvent *event);
  has Pointer               $.query;            #= gboolean              (*query)                (GstElement *element, GstQuery *query);
  has Pointer               $.post_message;     #= gboolean              (*post_message)         (GstElement *element, GstMessage *message);
  has Pointer               $.set_context;      #= void                  (*set_context)          (GstElement *element, GstContext *context);

  # Terminates with: Cannot invoke this object (REPR: Null; VMNull)
  # HAS Pointer               @!padding[GST_PADDING_LARGE - 2] is CArray;
  has Pointer               $!padding0;
  has Pointer               $!padding1;
  has Pointer               $!padding2;
  has Pointer               $!padding3;
  has Pointer               $!padding4;
  has Pointer               $!padding5;
  has Pointer               $!padding6;
  has Pointer               $!padding7;
  has Pointer               $!padding8;
  has Pointer               $!padding9;
  has Pointer               $!padding10;
  has Pointer               $!padding11;
  has Pointer               $!padding12;
  has Pointer               $!padding13;
  has Pointer               $!padding14;
  has Pointer               $!padding15;
  has Pointer               $!padding16;
  has Pointer               $!padding17;
}

use GLib::GList;
use GStreamer::PadTemplate;

use GLib::Roles::ListData;

class GStreamer::Element::Class {
  has GstElementClass $!ec;

  submethod BUILD (:$element-class) {
    $!ec = $element-class;
  }

  method new (GstElementClass $element-class) {
    $element-class ?? self.bless( :$element-class ) !! Nil;
  }

  method add_metadata (Str() $key, Str() $value)
    is also<add-metadata>
  {
    gst_element_class_add_metadata($!ec, $key, $value);
  }

  method add_pad_template (GstPadTemplate() $templ)
    is also<add-pad-template>
  {
    gst_element_class_add_pad_template($!ec, $templ);
  }

  method add_static_metadata (Str() $key, Str() $value)
    is also<add-static-metadata>
  {
    gst_element_class_add_static_metadata($!ec, $key, $value);
  }

  method add_static_pad_template (GstStaticPadTemplate() $static_templ)
    is also<add-static-pad-template>
  {
    gst_element_class_add_static_pad_template($!ec, $static_templ);
  }

  method add_static_pad_template_with_gtype (
    GstStaticPadTemplate() $static_templ,
    Int() $pad_type
  )
    is also<add-static-pad-template-with-gtype>
  {
    my GType $pt = $pad_type;

    gst_element_class_add_static_pad_template_with_gtype(
      $!ec,
      $static_templ,
      $pt
    );
  }

  method get_metadata (Str() $key) is also<get-metadata> {
    gst_element_class_get_metadata($!ec, $key);
  }

  method get_pad_template (Str() $name, :$raw = False)
    is also<get-pad-template>
  {
    my $pt = gst_element_class_get_pad_template($!ec, $name);

    $pt ??
      ( $raw ?? $pt !! GStreamer::PadTemplate.new($pt) )
      !!
      Nil;
  }

  method get_pad_template_list (:$glist = False, :$raw = False)
    is also<
      get-pad-template-list
      pad_template_list
      pad-template-list
      pad_templates
      pad-templates
    >
  {
    my $ptl = gst_element_class_get_pad_template_list($!ec);

    return Nil  unless $ptl;
    return $ptl if     $glist && $raw;

    $ptl = GLib::GList.new($ptl) but GLib::Roles::ListData[GstPadTemplate];

    $raw ?? $ptl.Array
         !! $ptl.Array.map({ GStreamer::PadTemplate.new($_) });
  }

  method set_metadata (
    Str() $longname,
    Str() $classification,
    Str() $description,
    Str() $author
  )
    is also<set-metadata>
  {
    gst_element_class_set_metadata(
      $!ec,
      $longname,
      $classification,
      $description,
      $author
    );
  }

  method set_static_metadata (
    Str() $longname,
    Str() $classification,
    Str() $description,
    Str() $author
  )
    is also<set-static-metadata>
  {
    gst_element_class_set_static_metadata(
      $!ec,
      $longname,
      $classification,
      $description,
      $author
    );
  }
}

sub gst_element_class_add_metadata (
  GstElementClass $klass,
  Str $key,
  Str $value
)
  is native(gstreamer)
  is export
{ * }

sub gst_element_class_add_pad_template (
  GstElementClass $klass,
  GstPadTemplate $templ
)
  is native(gstreamer)
  is export
{ * }

sub gst_element_class_add_static_metadata (
  GstElementClass $klass,
  Str $key,
  Str $value
)
  is native(gstreamer)
  is export
{ * }

sub gst_element_class_add_static_pad_template (
  GstElementClass $klass,
  GstStaticPadTemplate $static_templ
)
  is native(gstreamer)
  is export
{ * }

sub gst_element_class_add_static_pad_template_with_gtype (
  GstElementClass $klass,
  GstStaticPadTemplate $static_templ,
  GType $pad_type
)
  is native(gstreamer)
  is export
{ * }

sub gst_element_class_get_metadata (
  GstElementClass $klass,
  Str $key
)
  returns Str
  is native(gstreamer)
  is export
{ * }

sub gst_element_class_get_pad_template (
  GstElementClass $element_class,
  Str $name
)
  returns GstPadTemplate
  is native(gstreamer)
  is export
{ * }

sub gst_element_class_get_pad_template_list (
  GstElementClass $element_class
)
  returns GList
  is native(gstreamer)
  is export
{ * }

sub gst_element_class_set_metadata (
  GstElementClass $klass,
  Str $longname,
  Str $classification,
  Str $description,
  Str $author
)
  is native(gstreamer)
  is export
{ * }

sub gst_element_class_set_static_metadata (
  GstElementClass $klass,
  Str $longname,
  Str $classification,
  Str $description,
  Str $author
)
  is native(gstreamer)
  is export
{ * }
