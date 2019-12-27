use v6.c;

use Method::Also;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::ElementFactory;

use GStreamer::Element;
use GStreamer::PluginFeature;
use GStreamer::PadTemplate;

use GLib::Roles::ListData;

our subset ElementFactoryAncestry is export of Mu
  where GstElementFactory | GstPluginFeature;

class GStreamer::ElementFactory is GStreamer::PluginFeature {
  has GstElementFactory $!ef;

  submethod BUILD (:$factory) {
    self.setElementFactory($factory);
  }

  method setElementFactory (ElementFactoryAncestry $_) {
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
    };
    self.setPluginFeature($to-parent);
  }

  method GStreamer::Raw::Types::GstElementFactory
  { $!ef }

  method new (GstElementFactory $factory) {
    self.bless( :$factory );
  }

  method create (Str() $name, :$raw = False) {
    my $e = gst_element_factory_create($!ef, $name);

    $e ??
      ( $raw ?? $e !! GStreamer::Element.new($e) )
      !!
      Nil
  }

  method find (Str() $name, :$raw = False) {
    my $ef = gst_element_factory_find($name);

    die "Could not find an ElementFactory with the name '$name'!"
      unless $ef.defined;

    $raw ?? $ef !! GStreamer::ElementFactory.new($ef);
  }

  method get_element_type
    is also<
      get-element-type
      element_type
      element-type
    >
  {
    gst_element_factory_get_element_type($!ef);
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

  method get_longname
    is also<
      get-longname
      longname
    >
  {
    self.get_metadata(GST_ELEMENT_METADATA_LONGNAME);
  }

  method get_metadata (Str() $key) is also<get-metadata> {
    gst_element_factory_get_metadata($!ef, $key);
  }

  method get_metadata_keys
    is also<
      get-metadata-keys
      metadata_keys
      metadata-keys
    >
  {
    my $mk = gst_element_factory_get_metadata_keys($!ef);

    my ($cnt, $k, @mk) = (0);
    @mk.push: $k while $k = $mk[$cnt++];
    @mk;
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

  method get_static_pad_templates (:$raw = False)
    is also<
      get-static-pad-templates
      static_pad_templates
      static-pad-templates
    >
  {
    my $pt = GLib::GList.new(
      gst_element_factory_get_static_pad_templates($!ef)
    );

    $pt = $pt but GLib::Roles::ListData[GstStaticPadTemplate] if $pt;

    # Check for object.
    $pt ??
      ( $raw ?? $pt.Array !!
                $pt.Array.map({ GStreamer::StaticPadTemplate.new($_) }) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);
    unstable_get_type( self.^name, &gst_element_factory_get_type, $n, $t );
  }

  method get_uri_type
    is also<
      get-uri-type
      uri_type
      uri-type
    >
  {
    gst_element_factory_get_uri_type($!ef);
  }

  method has_interface (Str() $interfacename) is also<has-interface> {
    so gst_element_factory_has_interface($!ef, $interfacename);
  }

  method list_filter (
    GList() $list,
    GstCaps $caps,
    GstPadDirection $direction,
    gboolean $subsetonly,
    :$raw = False
  )
    is also<list-filter>
  {
    my $ef = GLib::GList.new(
      gst_element_factory_list_filter($list, $caps, $direction, $subsetonly)
    );

    $ef = $ef but GLib::Roles::ListData[GstElementFactory] if $ef;

    $ef ??
      ( $raw ?? $ef.Array !!
                $ef.Array({ GStreamer::ElementFactory.new($_ ) }) )
      !!
      Nil
  }

  method list_get_elements (
    Int() $type,
    GstRank $minrank,
    :$raw = False;
  )
    is also<list-get-elements>
  {
    my $ef = GLib::GList.new(
      gst_element_factory_list_get_elements($type, $minrank)
    );

    $ef = $ef but GLib::Roles::ListData[GstElementFactory] if $ef;

    $ef ??
      ( $raw ??
        $ef.Array !! $ef.Array({ GStreamer::ElementFactory.new($_ ) })
      )
      !!
      Nil
  }

  method list_is_type (Int() $type) is also<list-is-type> {
    so gst_element_factory_list_is_type($!ef, $type);
  }

  method make (Str() $fname, Str() $name, :$raw = False) {
    my $e = gst_element_factory_make($fname, $name);

    $e ??
      ( $raw ?? $e !! GStreamer::Element.new($e) )
      !!
      Nil;
  }

  method register (
    GstPlugin() $plugin,
    Str() $name,
    guint $rank,
    GType $type
  ) {
    gst_element_register($plugin, $name, $rank, $type);
  }

  method get_uri_protocols is also<get-uri-protocols> {
    my $up = gst_element_factory_get_uri_protocols($!ef);

    my ($cnt, $s, @s) = (0);
    @s.push: $s while $s = $up[$cnt++];
    @s;
  }

  method can_sink_all_caps (GstCaps $caps) is also<can-sink-all-caps> {
    so gst_element_factory_can_sink_all_caps($!ef, $caps);
  }

  method can_sink_any_caps (GstCaps $caps) is also<can-sink-any-caps> {
    so gst_element_factory_can_sink_any_caps($!ef, $caps);
  }

  method can_src_all_caps (GstCaps $caps) is also<can-src-all-caps> {
    so gst_element_factory_can_src_all_caps($!ef, $caps);
  }

}
