use v6.c;

use Method::Also;

use GLib::Raw::Traits;
use GStreamer::Raw::Types;
use GStreamer::Raw::ElementFactory;

use GLib::GList;
use GStreamer::Element;
use GStreamer::PluginFeature;
use GStreamer::PadTemplate;

use GLib::Roles::ListData;

our subset GstElementFactoryAncestry is export of Mu
  where GstElementFactory | GstPluginFeature;

class GStreamer::ElementFactory is GStreamer::PluginFeature {
  has GstElementFactory $!ef;

  submethod BUILD (:$factory) {
    self.setElementFactory($factory);
  }

  method setElementFactory (GstElementFactoryAncestry $_) {
    my $to-parent;

    $!ef = do {
      when GstElementFactory {
        $to-parent = cast(GstPluginFeature, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstElementFactory, $_);
      }
    }
    self.setGstPluginFeature($to-parent);
  }

  method GStreamer::Raw::Definitions::GstElementFactory
    is also<GstElementFactory>
  { $!ef }

  method new (GstElementFactoryAncestry $factory) {
    $factory ?? self.bless( :$factory ) !! Nil;
  }

  method create (Str() $name = Str, :$raw = False) {
    my $e = gst_element_factory_create($!ef, $name);

    $e ??
      ( $raw ?? $e !! GStreamer::Element.new($e) )
      !!
      Nil;
  }

  method find (Str() $name, :$raw = False) {
    my $ef = gst_element_factory_find($name);

    die "Could not find an ElementFactory with the name '$name'!"
      unless $ef;

    $raw ?? $ef !! GStreamer::ElementFactory.new($ef);
  }

  method get_element_type
    is also<
      get-element-type
      element_type
      element-type
    >
  {
    state ($n, $t);

    GTypeEnum( gst_element_factory_get_element_type($!ef) );
  }

  method get_author
    is also<
      get-author
      author
    >
  {
    self.get_metadata(GST_ELEMENT_METADATA_AUTHOR);
  }

  method get_documentation
    is also<
      get-documentation
      documentation
    >
  {
    self.get_metadata(GST_ELEMENT_METADATA_DOC_URI);
  }

  method get_icon_name
    is also<
      get-icon-name
      icon-name
    >
  {
    self.get_metadata(GST_ELEMENT_METADATA_ICON_NAME);
  }

  method get_description
    is also<
      get-description
      description
    >
  {
    self.get_metadata(GST_ELEMENT_METADATA_DESCRIPTION);
  }

  multi method get_klass is also<get-klass> {
    self.get_metadata(GST_ELEMENT_METADATA_KLASS);
  }

  method get_longname
    is also<
      get-longname
      longname
    >
  {
    self.get_metadata(GST_ELEMENT_METADATA_LONGNAME);
  }

  multi method get_metadata (Str() $key) is also<get-metadata> {
    gst_element_factory_get_metadata($!ef, $key);
  }

  method get_metadata_keys
    is also<
      get-metadata-keys
      metadata_keys
      metadata-keys
    >
  {
    CStringArrayToArray( gst_element_factory_get_metadata_keys($!ef) );
  }

  method get_num_pad_templates
    is also<
      get-num-pad-templates
      num_pad_templates
      num-pad-templates
    >
  {
    gst_element_factory_get_num_pad_templates($!ef);
  }

  method get_static_pad_templates (:$glist = False, :$raw = False)
    is also<
      get-static-pad-templates
      static_pad_templates
      static-pad-templates
    >
  {
    my $ptl = gst_element_factory_get_static_pad_templates($!ef);

    return Nil unless $ptl;
    return $ptl if $glist && $raw;

    $ptl = GLib::GList.new($ptl) but GLib::Roles::ListData[GstStaticPadTemplate];
    return $ptl if $glist;

    $raw ?? $ptl.Array
         !! $ptl.Array.map({ GStreamer::StaticPadTemplate.new($_) })
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_element_factory_get_type, $n, $t );
  }

  method get_uri_type ( :$raw = False )
    is also<
      get-uri-type
      uri_type
      uri-type
    >
  {
    GLib::Object::Type.new( gst_element_factory_get_uri_type($!ef) );
  }

  method has_interface (Str() $interfacename) is also<has-interface> {
    so gst_element_factory_has_interface($!ef, $interfacename);
  }

  method list_filter (
    GList()    $list,
    GstCaps()  $caps,
    Int()      $direction,
    Int()      $subsetonly,
              :$glist = False,
              :$raw = False
  )
    is static
    is also<list-filter>
  {
    my GstPadDirection $d = $direction;
    my gboolean        $s = $subsetonly.so.Int;

    returnGList(
      gst_element_factory_list_filter($list, $caps, $d, $s),
      $raw,
      $glist,
      |GStreamer::ElementFactory.getTypePair
    )
  }

  method list_get_elements (
    Int()    $type,
    GstRank  $minrank,
            :$glist = False,
            :$raw = False;
  )
    is static
    is also<list-get-elements>
  {
    returnGList(
      gst_element_factory_list_get_elements($type, $minrank),
      $raw,
      $glist,
      |GStreamer::ElementFactory.getTypePair
    );
  }

  method list_is_type (Int() $type) is also<list-is-type> {
    so gst_element_factory_list_is_type($!ef, $type);
  }

  method make (Str() $fname, Str() $name = $fname, :$raw = False) {
    my $e = gst_element_factory_make($fname, $name);

    $e ??
      ( $raw ?? $e !! GStreamer::Element.new($e) )
      !!
      Nil;
  }

  method register (
    GstPlugin() $plugin,
    Str()       $name,
    Int()       $rank,
    Int()       $type
  ) {
    my guint $r = $rank;
    my GType $t = $type;

    gst_element_register($plugin, $name, $r, $t);
  }

  method get_uri_protocols is also<get-uri-protocols> {
    my $up = gst_element_factory_get_uri_protocols($!ef);

    return Nil unless $up[0];

    CStringArrayToArray($up[0]);
  }

  method can_sink_all_caps (GstCaps() $caps) is also<can-sink-all-caps> {
    so gst_element_factory_can_sink_all_caps($!ef, $caps);
  }

  method can_sink_any_caps (GstCaps() $caps) is also<can-sink-any-caps> {
    so gst_element_factory_can_sink_any_caps($!ef, $caps);
  }

  method can_src_all_caps (GstCaps() $caps) is also<can-src-all-caps> {
    so gst_element_factory_can_src_all_caps($!ef, $caps);
  }

}
