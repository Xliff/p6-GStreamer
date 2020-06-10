use v6.c;

use GStreamer::Raw::Types;

use GLib::Class::Object;
use GLib::Object::Type;
use GLib::Array;
use GLib::GList;
use GLib::MainLoop;
use GLib::Quark;
use GLib::Signal;
use GLib::Spawn;
use GLib::Value;
use GStreamer::Bin;
use GStreamer::Class::Element;
use GStreamer::DeviceProviderFactory;
use GStreamer::Element;
use GStreamer::ElementFactory;
use GStreamer::Main;
use GStreamer::Plugin;
use GStreamer::Registry;
use GStreamer::TracerFactory;
use GStreamer::TypeFindFactory;
use GStreamer::Value;

use GStreamer::Roles::Preset;
use GStreamer::Roles::URIHandler;

constant BLUE       = "\e[34m";
constant BRBLUE     = "\e[94m";
constant BRCYAN     = "\e[96m";
constant BRMAGENTA  = "\e[95m";
constant BRYELLOW   = "\e[33m";
constant CYAN       = "\e[36m";
constant GREEN      = "\e[32m";
constant MAGENTA    = "\e[35m";
constant YELLOW     = "\e[33m";

constant DEFAULT_PAGER      = 'less';
constant DEFAULT_PAGER_OPTS = 'RXF';

constant ELEMENT_FACTORY_TYPE   = GStreamer::ElementFactory.get-type;
constant PAD_TYPE               = GStreamer::Pad.get-type;
constant TYPE_FIND_FACTORY_TYPE = GStreamer::TypeFindFactory.get-type;
constant TRACER_FACTORY_TYPE    = GStreamer::TracerFactory.get-type;
constant ELEMENT_TYPE           = GStreamer::Element.get-type;
constant GST_OBJECT_TYPE        = GStreamer::Object.get-type;
constant BIN_TYPE               = GStreamer::Bin.get-type;
constant VALUE_ARRAY_TYPE       = value-array-get-type;

sub HEADING_COLOR         { $*co ?? BRYELLOW       !! ''  }
sub RESET_COLOR           { $*co ?? "\e[0m"        !! ''  }
sub PROP_NAME_COLOR       { $*co ?? BRBLUE         !! ''  }
sub PROP_VALUE_COLOR      { $*co ?? RESET_COLOR()  !! ''  }
sub PROP_ATTR_NAME_COLOR  { $*co ?? BRYELLOW       !! ''  }
sub PROP_ATTR_VALUE_COLOR { $*co ?? CYAN           !! ''  }
sub DESC_COLOR            { $*co ?? RESET_COLOR()  !! ''  }
sub DATATYPE_COLOR        { $*co ?? GREEN          !! ''  }
sub CHILD_LINK_COLOR      { $*co ?? BRMAGENTA      !! ''  }
sub FIELD_NAME_COLOR      { $*co ?? CYAN           !! ''  }
sub FIELD_VALUE_COLOR     { $*co ?? BRBLUE         !! ''  }
sub CAPS_TYPE_COLOR       { $*co ?? YELLOW         !! ''  }
sub STRUCT_NAME_COLOR     { $*co ?? YELLOW         !! ''  }
sub CAPS_FEATURE_COLOR    { $*co ?? GREEN          !! ''  }
sub PLUGIN_NAME_COLOR     { $*co ?? BRBLUE         !! ''  }
sub ELEMENT_NAME_COLOR    { $*co ?? GREEN          !! ''  }
sub ELEMENT_DETAIL_COLOR  { $*co ?? RESET_COLOR()  !! ''  }
sub PLUGIN_FEATURE_COLOR  { $*co ?? BRBLUE         !! ''  }
sub FEATURE_NAME_COLOR    { $*co ?? GREEN          !! ''  }
sub FEATURE_DIR_COLOR     { $*co ?? BRMAGENTA      !! ''  }
sub FEATURE_RANK_COLOR    { $*co ?? CYAN           !! ''  }
sub FEATURE_PROTO_COLOR   { $*co ?? BRYELLOW       !! ''  }

my $pager      = %*ENV<DEFAULT_PAGER>       // DEFAULT_PAGER;
my $pager-opts = %*ENV<DEFAULT_PAGER_OPTS>  // DEFAULT_PAGER_OPTS;

my ($reg, $indent, $name) = (GStreamer::Registry.get, 0);
my (%rank-name-lookup, @rank-names, @ranks);
for GstRankEnum.enums.pairs.sort( *.value ) {
  %rank-name-lookup{.value} = .key.subst('GST_RANK_').lc;
  @ranks.push: .value;
  @rank-names.push: .key;
}

sub push-indent-n ($n) {
  die '$n or current indent must be > 0!' unless $n > 0 || $indent > 0;
  $indent += $n;
}
sub push-indent       { push-indent-n(1)   }
sub pop-indent        { push-indent-n(-1)  }
sub pop-indent-n ($n) { push-indent-n(-$n) }

sub get-uriType-name ($t, :$rw = False) {
  do given $t {
    when    GST_URI_SRC  { $rw ?? 'read'  !! 'src'  }
    when    GST_URI_SINK { $rw ?? 'write' !! 'sink' }
    default              { 'unknown'                }
  }
}
sub get-direction-name ($t, :$rw = False) {
  do given $t {
    when    GST_PAD_SRC  { 'src'       }
    when    GST_PAD_SINK { 'sink'      }
    default              { 'unknown'   }
  }
}

# From #raku: -- Get longest common substring from a list.
sub max (:&by = {$_}, :$all!, *@list) {
  # Find the maximal value...
  my $max = max my @values = @list.map: &by;

  # Extract and return all values matching the maximal...
  @list[ @values.kv.map: {$^index unless $^value cmp $max} ];
}

sub n-print ($format?) {
  unless $format {
    print "\n";
    return;
  }
  print "{ $indent }{ $name ?? $name !! '' }{ '  ' x $indent }{ $format // '' }";
}

sub print-field ($f, $v, $pfx) {
  CATCH { default { .message.say } }

  my $val   = GStreamer::Value.new($v);
  my $field = GLib::Quark.to-string($f);

  n-print "{ $pfx }  { FIELD_NAME_COLOR }{ $field.fmt('%15s') }{ RESET_COLOR
           }: {FIELD_VALUE_COLOR}{ $val.serialize }{ RESET_COLOR }\n";
  1
}

sub print-caps ($c, $pfx = '') {
  die '$c (a GStreamer::Cap object) is undefined!' unless $c;

  n-print "{ CAPS_TYPE_COLOR }{ $pfx }ANY{ RESET_COLOR }\n"   if $c.is-any;
  n-print "{ CAPS_TYPE_COLOR }{ $pfx }EMPTY{ RESET_COLOR }\n" if $c.is-empty;
  return if $c.is-any || $c.is-empty;

  for ^$c.get-size {
    my $s = $c.get-structure($_);
    my $f = $c.get-features($_);

    if $f && $f.is-any ||
             $f.is_equal($gst-caps-features-memory-system-memory).not
    {
      n-print "{ $pfx }{ STRUCT_NAME_COLOR }{ $s.name }{
                 RESET_COLOR }({ CAPS_FEATURE_COLOR }{ ~$f }{
                 RESET_COLOR })\n";
    } else {
      n-print "{ $pfx }{ STRUCT_NAME_COLOR }{ $s.name }{ RESET_COLOR }\n";
    }
    $s.foreach(-> *@a --> gboolean { print-field( |@a[0, 1], $pfx ) });
  }
}

sub get-rank-name ($r) {
  return %rank-name-lookup{$r} if %rank-name-lookup{$r}:exists;

  my $best-i = 0;
  for ^GstRankEnum.enums.elems {
    $best-i = $_ if ($r - @ranks[$_]).abs < ($r - @ranks[$best-i]).abs;
  }

  "{ @rank-names[$best-i] }{ $r > @ranks[$best-i] } ?? '+' !! '-' }{
     ($r - @ranks[$best-i]).abs }";
}

sub print-factory-details-info ($f) {
  my $rank = $f.rank;

  $indent = 0;
  n-print "{ HEADING_COLOR } Factory Details{ RESET_COLOR }:\n";
  push-indent;
  n-print "  { PROP_NAME_COLOR }{ "Rank".fmt('%-25s') }{ PROP_VALUE_COLOR }{
            get-rank-name($rank) } ({ $rank }){ RESET_COLOR }\n";
  if $f.get-metadata-keys -> $keys {
    for $keys[] {
      my $val = $f.get_metadata($_);
      n-print "  { PROP_NAME_COLOR }{ .tc.fmt('%-25s') }{ PROP_VALUE_COLOR }{ $val
    }{  RESET_COLOR }\n";
    }
  }
  pop-indent;
  n-print;
}

sub print-hierarchy ($t, $l is copy, $ml is rw) {
  my $parent = $t.parent;
  $ml++ && $l++;

  print-hierarchy($parent, $l, $ml) if $parent;
  print "{ DATATYPE_COLOR }{ $name }{ RESET_COLOR }" if $name;
  if $ml - $l -> $i {
    print "      " x ($i - 1);
    print "{ CHILD_LINK_COLOR }+----{ RESET_COLOR }";
  }
  say "{ DATATYPE_COLOR }{ $t.name }{ RESET_COLOR }";
  n-print unless $l;
}

sub print-interfaces ($t) {
  my $ifaces = $t.interfaces;

  if $ifaces && $ifaces.elems {
    n-print " { HEADING_COLOR }Implemented Interfaces{ RESET_COLOR }:\n";
    push-indent;
    n-print "  { DATATYPE_COLOR }{ .name }{ RESET_COLOR }\n" for $ifaces[];
    pop-indent;
    n-print;
  }
}

sub flags-to-string (\E, Int() $flags) {
  my %name-lookup;
  %name-lookup{.value} = .key for E.enums.pairs.sort( *.value );
  return %name-lookup{$flags} if %name-lookup{$flags}:exists;

  get_flags(E, $flags, '+');
}

sub PAV-COLOR ($s)
  { "{ PROP_ATTR_VALUE_COLOR }{ $s }{ RESET_COLOR }" }

multi sub print-object-properties-info (gpointer $k, $d) {
  my $klass = GLib::Class::Object.new( cast(GObjectClass, $k) );

  print-object-properties-info(Nil, $d, $klass);
}
multi sub print-object-properties-info ($o, $d, $k? is copy) {
  $k //= $o.getClass;

  my @specs    = $k ?? $k.list-properties.Array.sort( *.name )
                    !! die 'ObjectClass is not defined!';
  my $long     = (  G_TYPE_LONG,  G_TYPE_ULONG ).any;
  my $unsigned = (  G_TYPE_UINT, G_TYPE_UINT64, G_TYPE_ULONG ).any;
  my $integer  = (  G_TYPE_UINT,    G_TYPE_INT, G_TYPE_UINT64, G_TYPE_INT64,
                    G_TYPE_LONG,  G_TYPE_ULONG ).any;
  my $fp       = ( G_TYPE_FLOAT, G_TYPE_DOUBLE ).any;

  n-print "{ HEADING_COLOR }{ $d }{ RESET_COLOR }\n";
  push-indent;

  for @specs -> $s {
    my $ot = $s.owner_type;

    next unless $o || $ot == none(
                         G_TYPE_OBJECT,
                         GST_OBJECT_TYPE,
                         PAD_TYPE
                       );

    my $v = GStreamer::Value.new( $s.value_type );

    n-print "{ PROP_NAME_COLOR }{ $s.get_name.fmt('%-20s') }{ RESET_COLOR
              }: { PROP_VALUE_COLOR }{ $s.get-blurb }{ RESET_COLOR }\n";
    push-indent-n(11);
    n-print "{ PROP_ATTR_NAME_COLOR }flags{ RESET_COLOR }: ";

    if $s.flag-set(G_PARAM_READABLE) && $o {
      $o.get_property($s.name, $v);
    } else {
      # if we can't read the property value, assume it's set to the default
      # (which might not be entirely true for sub-classes, but that's an
      # unlikely corner-case anyway)
      $s.value-set-default($v);
    }

    my $known-param-flags = [+|](
      G_PARAM_READWRITE,       G_PARAM_DEPRECATED,      G_PARAM_CONSTRUCT,
      G_PARAM_CONSTRUCT_ONLY,  G_PARAM_LAX_VALIDATION,  GST_PARAM_CONTROLLABLE,
      GST_PARAM_MUTABLE_READY, GST_PARAM_MUTABLE_PAUSED,GST_PARAM_MUTABLE_PLAYING
    );

    my ($readable, @f) = ( $s.flag-set(G_PARAM_READABLE) );
    @f.push( PAV-COLOR('readable')     ) if $readable;
    @f.push( PAV-COLOR('writeable')    ) if $s.flag-set(G_PARAM_WRITABLE);
    @f.push( PAV-COLOR('deprecated')   ) if $s.flag-set(G_PARAM_DEPRECATED);
    @f.push( PAV-COLOR('controllable') ) if $s.flag-set(GST_PARAM_CONTROLLABLE);

    @f.push( PAV-COLOR('changeable in NULL, READ, PAUSED or PLAYING state') )
      if $s.flag-set(GST_PARAM_MUTABLE_PLAYING);
    @f.push( PAV-COLOR('changeable only in NULL, READY or PAUSED state') )
      if $s.flag-set(GST_PARAM_MUTABLE_PAUSED);
    @f.push( PAV-COLOR('changeable only in NULL or READY state') )
      if $s.flag-set(GST_PARAM_MUTABLE_READY);
    @f.push( PAV-COLOR("0x{ $s.flags +& +^$known-param-flags }") )
      if $s.flag-set(+^$known-param-flags);
    print "{ @f.join(', ') }\n";

    my ($us, $tn, $f) = '' xx 2;
    given $v.type {
      when $unsigned       { $us = 'Unsigned '; $f = '%u'; proceed } # should be '%u' but raku still has signage problems.
      when $long           { $tn = 'Long';                 proceed }

      when G_TYPE_UINT64 |
            G_TYPE_INT64   { $tn = 'Integer64';            proceed }

      when G_TYPE_STRING {
        n-print "{ DATATYPE_COLOR }String{ RESET_COLOR }. ";
          print "{ PROP_ATTR_NAME_COLOR }Default{ RESET_COLOR }: ";
          print PAV-COLOR(
            $v.value.defined ?? '"' ~ { $v.value } ~ '"' !! 'null'
          );
      }

      when G_TYPE_BOOLEAN {
        n-print "{ DATATYPE_COLOR }Boolean{ RESET_COLOR }. ";
          print "{ PROP_ATTR_NAME_COLOR }Default{ RESET_COLOR }";
          print PAV-COLOR( $v.value.lc );
      }

      when $integer { $tn = 'Integer' unless $tn;
                       $f = '%d' unless $f;
                       proceed                                          }
      when $fp      { $f  = '%15.7f';
                      $tn = $_ == G_TYPE_FLOAT ?? 'Float' !! 'Double';
                      proceed                                           }

      when $tn.so {
        my $pspec = $s.value-spec;
        my $max   = $pspec.maximum;
        # Raku still has issues with unsigned ints in structs, so we have
        # to adjust!
        my $is    = ($tn eq 'Long' ?? 64 !! 32);

        $max += 2 ** $is if $us && ($max +& 2 ** ($is - 1));
        n-print "{ DATATYPE_COLOR }{ $us }{ $tn }{ RESET_COLOR }. ";
          print "{ PROP_ATTR_NAME_COLOR }Range{ RESET_COLOR }: ";
          print "{ PROP_ATTR_VALUE_COLOR }{ $pspec.minimum.fmt($f) } - {
                   $max.fmt($f)  }{ RESET_COLOR } ";
          print "{ PROP_ATTR_NAME_COLOR }Default{ RESET_COLOR }: ";
          print "{ PROP_ATTR_VALUE_COLOR }{ $v.value }{ RESET_COLOR }";
        proceed if $_ ~~ $long;
      }

      when $long {
        my $t-o = $f eq '%u' ?? 'uint/uint64' !! 'int/int64';
        my $lt  = ($f ~ 'long').substr(1, *);
        say "Property '{ $s.name }' of type { $lt }: consider changing to {
             $t-o }";
      }

      when G_TYPE_CHAR | G_TYPE_UCHAR {
        say "Property '{ $s.name }' of type char: consider changing to {''
             }int/string";
        proceed;
      }

      default {
        my ($t, $pt, $pre, $vv, $vt) = (GLib::Object::Type.new($v.type), False);

        when $s.value_type == GStreamer::Caps.get-type {

          if $v.caps -> $c {
            print-caps($c, '                           ');
          } else {
            n-print "{ DATATYPE_COLOR }Caps{ RESET_COLOR } (NULL)";
          }
        }

        when $s.value_type == $g-param-spec-types[G_TYPE_PARAM_ENUM_IDX] {
          use MONKEY-SEE-NO-EVAL;

          ($pre, $f) = ('', '%d');
          ($vt, $vv) = EVAL "( { $t.name }, { $t.name }({ $v.get-enum }) )";
          n-print "{ DATATYPE_COLOR }Enum \"{ $t.name }\"{ RESET_COLOR } ";
            print "{ PROP_ATTR_NAME_COLOR }Default{ RESET_COLOR }: ";
            print "{ PROP_ATTR_VALUE_COLOR }{ $vv.Int }, \"{ $vv.Str }\"{
                      RESET_COLOR }";
        }

        when $s.value_type == $g-param-spec-types[G_TYPE_PARAM_FLAGS_IDX] {
          use MONKEY-SEE-NO-EVAL;

          ($pre, $f, $vt) = ('0x', '%08x', EVAL $t.name);
          n-print "{ DATATYPE_COLOR }Flags \"{ $t.name }\"{ RESET_COLOR } ";
            print "{ PROP_ATTR_NAME_COLOR }Default{ RESET_COLOR }: ";
            print "{ PROP_ATTR_VALUE_COLOR }0x{ $v.flags.fmt('%08x') }{
                      flags-to-string($v.flags) }{ RESET_COLOR }";
        }

        when $pt.so {
          my @nicks = $vt.enums.pairs.sort( *.value );
          my @names = max :all,
                          :by{.chars},
                          keys [∩] @nicks».match(/.+/, :ex)».Str;
          for @nicks {
            my $ename = .key.subst(@names[0], '').subst('_', '-').lc;
            n-print "   { PROP_ATTR_NAME_COLOR }({ $pre }{
                           .value.fmt($f) }){ RESET_COLOR }: {
                           $ename.fmt('%-16s') } - { PAV-COLOR( .key ) }";
          }
          $pt = False;
        }

        when $s.value_type == $g-param-spec-types[G_TYPE_PARAM_OBJECT_IDX] {
          n-print "{ PROP_VALUE_COLOR }Object of type{ RESET_COLOR } {
                      DATATYPE_COLOR }\"{ $t.name }\"{ RESET_COLOR }";
        }

        when $s.value_type == $g-param-spec-types[G_TYPE_PARAM_BOXED_IDX] {
          n-print "{ PROP_VALUE_COLOR }Boxed pointer of type{
                      RESET_COLOR }{ DATATYPE_COLOR }\"{ $t.name }\"{
                      RESET_COLOR }";
          if $s.value_type == GStreamer:: {
            if $v.structure -> $struct {
              print "\n";
              $struct.foreach(-> *@a { print-field( |@a[0, 1], ' ' x 28 ) });
            }
          }
        }

        when $s.value_type == $g-param-spec-types[G_TYPE_PARAM_POINTER_IDX] {
          if $s.value_type !=  G_TYPE_POINTER {
            n-print "{ PROP_VALUE_COLOR }Pointer of type{ RESET_COLOR } {
                        DATATYPE_COLOR }\"{ $t.name }\"{ RESET_COLOR }"
          } else {
            n-print "{ PROP_VALUE_COLOR }Pointer{ RESET_COLOR }";
          }
        }

        when $s.value_type == VALUE_ARRAY_TYPE { $pre = 'Array'; proceed; }

        when $s.value_type == VALUE_ARRAY_TYPE ||
             $s.value_type == GStreamer::Value::Array.get-type

        {
          my $pspec = cast(GParamSpecValueArray, $s.GParamSpec);
          $pre = 'GstValueArray' unless $pre;

          if $pspec.element_spec -> $es {
            my $pt = GLib::Object::Type.new($es.value_type);
            n-print "{ PROP_VALUE_COLOR }{ $pre } of GValues of Type{
                       RESET_COLOR } { DATATYPE_COLOR }\"{ $pt.name }\"{
                       RESET_COLOR }";
          } else {
            n-print "{ PROP_VALUE_COLOR }{ $pre } of GValues{ RESET_COLOR }";
          }
        }

        when $s.value_type == GStreamer::Value.fraction-get-type {
          my $pspec = cast(GstParamSpecFraction, $s.GParamSpec);

          n-print "{ DATATYPE_COLOR }Fraction{ RESET_COLOR }. {
                      PROP_ATTR_NAME_COLOR }Range{ RESET_COLOR }: {
                      PROP_ATTR_VALUE_COLOR }{ $pspec.min_num }/{
                      $pspec.min_den } - { $pspec.max_num }/{
                      $pspec.max_den }{ RESET_COLOR } {
                      PROP_ATTR_NAME_COLOR }Default{ RESET_COLOR }: {
                      PROP_ATTR_VALUE_COLOR }{ $v.get_fraction_numerator }/{
                      $v.get_fraction_denominator }{ RESET_COLOR }"
        }

        when $s.value_type == GStreamer::Value::Array.get-type {
          my $parray = $s.value-spec;

          if $parray.element_spec {
            my $at = GLib::Object::Type.new($parray.element_spec.value_type);
            n-print "{ PROP_VALUE_COLOR }GstValueArray of GValues of type{
                       RESET_COLOR }{ DATATYPE_COLOR }\"{ $at.name }\"{
                       RESET_COLOR }";
          } else {
            n-print "{ PROP_VALUE_COLOR }GstValueArray of GValues{
                       RESET_COLOR }";
          }
        }

        default {
          my $ut = GLib::Object::Type.new($s.value_type);

          n-print "{ PROP_VALUE_COLOR }Unknown type { $ut.Int }{
                    RESET_COLOR }{ DATATYPE_COLOR }\"{ $ut.name }\"{
                    RESET_COLOR }";
        }
      }
    }
    if $readable.not {
      print " { PROP_VALUE_COLOR }Write only{ RESET_COLOR }\n"
    } else {
      n-print;
    }
    pop-indent-n(11);
  }
  n-print "{ PROP_VALUE_COLOR }none{ RESET_COLOR }\n" unless @specs.elems;
  pop-indent;
}

sub print-element-properties-info ($e) {
  n-print;
  print-object-properties-info($e, "Element Properties");
}

sub print-pad-templates-info ($e, $ef) {
  n-print "{ HEADING_COLOR }Pad Templates{ RESET_COLOR }:\n";
  push-indent;

  LEAVE { pop-indent }
  unless $ef.get-num-pad-templates {
    n-print "{ PROP_VALUE_COLOR }none{ RESET_COLOR }\n";
    return;
  }

  my @spts = $ef.get-static-pad-templates;
  for @spts -> $pt {
    my $dir = get-direction-name($pt.direction).uc;
    n-print "{ PROP_NAME_COLOR }{ $dir } template{ RESET_COLOR }: {
                PROP_VALUE_COLOR }{ $pt.name_template }{ RESET_COLOR }\n";

    push-indent;

    my $p = do given $pt.presence {
      when    GST_PAD_ALWAYS    { 'Always'     }
      when    GST_PAD_SOMETIMES { 'Sometimes'  }
      when    GST_PAD_REQUEST   { 'On request' }
      default                   { 'UNKNOWN'    }
    }
    n-print "{ PROP_NAME_COLOR }Availability{ RESET_COLOR }: {
               PROP_VALUE_COLOR }{ $p }{ RESET_COLOR }\n";

    if $pt.static-caps -> $sc {
      if $sc.string {
        n-print "{ PROP_NAME_COLOR }Capabilities{ RESET_COLOR }:\n";
        my $caps = $sc.get;

        push-indent;
        print-caps($sc.get);
        pop-indent;
      }
    }

    my $klass = $e.getClass;
    if $klass.get-pad-template($pt.name-template) -> $tmpl {
      my $gt = $tmpl.objectType;

      unless $tmpl.abi-type == (G_TYPE_NONE, PAD_TYPE).any {
        my $pk = $gt.class-ref;

        n-print "{ PROP_NAME_COLOR }Type{ RESET_COLOR }: { DATATYPE_COLOR }{
                   $gt.name }{ RESET_COLOR }\n";
        print-object-properties-info($pk, "Pad Properties");
        GLib::Object::Type.class-unref($pk);
      }
    }

    pop-indent;
    n-print if ++$ < @spts.elems;
  }
}

sub print-clocking-info ($e) {
  my ($req-clock, $prov-clock) = $e.flags «+&«
    (GST_ELEMENT_FLAG_REQUIRE_CLOCK, GST_ELEMENT_FLAG_PROVIDE_CLOCK);

  unless $req-clock || $prov-clock {
    n-print;
    n-print " { DESC_COLOR }Element has no clocking capabilities.{
                RESET_COLOR }\n";
    return;
  }

  n-print;
  n-print "{ PROP_NAME_COLOR }Clocking Interaction{ RESET_COLOR }:\n";
  push-indent;

  n-print "{ PROP_VALUE_COLOR }element requires a clock{ RESET_COLOR }\n"
    if $req-clock;

  if $prov-clock {
    my $c = $e.clock;

    if $c {
      n-print "{ PROP_VALUE_COLOR }element provides a clock{ RESET_COLOR }: {
                  DATATYPE_COLOR }{ $c.name }{ RESET_COLOR }\n";
    } else {
      n-print "{ PROP_VALUE_COLOR }element is supposed to provide a clock {
                  '' }returned NULL{ RESET_COLOR }";
    }
  }
  pop-indent;
}

sub print-uri-handler-info ($e is copy) {
  unless $e.isType( urihandler-get-type ) {
    n-print " { DESC_COLOR }Element has no URI handling capabilities.{
                RESET_COLOR }\n";
    return;
  }

  $e = $e but GStreamer::Roles::URIHandler;
  # This NEVER should appear in client code, but here we are...
  $e.roleInit-URIHandler;
  my $uri-type = get-uriType-name($e.get_uri_type);

  n-print;
  n-print " { HEADING_COLOR }URI handling capabilities{ RESET_COLOR }:\n";
  push-indent;
  n-print "{ DESC_COLOR }Element can act as { $uri-type }.{ RESET_COLOR }\n";

  my $noproto = True;
  if $e.get_protocols -> $p {
    if $p.elems {
      n-print "{ DESC_COLOR }Supported URI protocols{ RESET_COLOR }:\n";
      push-indent;
      n-print "{ PAV-COLOR($_) }\n" for $p[];
      pop-indent;
      $noproto = False;
    }
  }
  n-print("{ PROP_VALUE_COLOR }No supported URI protocols{ RESET_COLOR }\n")
    if $noproto;
  pop-indent;
}

sub print-pad-info ($e) {
  n-print;
  n-print " { HEADING_COLOR }Pads{ RESET_COLOR }:\n";

  push-indent;
  LAST { pop-indent }

  unless $e.numpads {
    n-print "{ PROP_VALUE_COLOR }none{ RESET_COLOR }\n";
    return;
  }

  for $e.pads[] -> $pad {
    my $n   = $pad.name;
    my $dir = get-direction-name($pad.direction).uc;

    n-print "{ PROP_NAME_COLOR }{ $dir }{ RESET_COLOR }: {
                PROP_VALUE_COLOR }'{ $n }'{ RESET_COLOR }\n";

    if $pad.padtemplate -> $pt {
      push-indent;
      n-print "{ PROP_NAME_COLOR }Pad Template{ RESET_COLOR }: {
                 PROP_VALUE_COLOR }'{ $pt.name-template }'{ RESET_COLOR }\n";
      pop-indent;
    }

    if $pad.get-current-caps -> $caps {
      n-print "{ PROP_NAME_COLOR }Capabilities{ RESET_COLOR }:";
      push-indent;
      print-caps($caps);
      pop-indent;
    }
  }
}

sub has-sometimes-template ($e) {
  for $e.getClass.pad-templates[] -> $l {
    return True if ($l.presence // 0) == GST_PAD_SOMETIMES;
  }
  False;
}

sub gtype-needs-ptr-marker ($t) {
  return False if $t.is_a(G_TYPE_POINTER);
  return True  if $t.is-fundamentally(G_TYPE_POINTER) || $t.is-boxed ||
                  $t.is-object;
  False;
}

sub print-signal-info ($e) {
  for 0, 1 -> $k {
    my @found-signals;

    if $k.not && has-sometimes-template($e) {
      my $q;

      sub lookup-signal-query ($s) {
        GLib::Signal.query( GLib::Signal.lookup($s, ELEMENT_TYPE) );
      }

      for <pad-added pad-removed no-more-pads> {
        @found-signals.push($q) if $q = lookup-signal-query($_)
      }
    }

    my $type;
    loop ($type = $e.getType; $type; $type .= parent) {
      last if $type == ELEMENT_TYPE || $type == GST_OBJECT_TYPE;
      next if $type == BIN_TYPE && $e.getType != BIN_TYPE;

      for GLib::Signals.list-ids($type)[] {
        my $query = GLib::Signals.query($_);

        @found-signals.push: $query
          if ($k == 0 && ($query.signal_flags +& G_SIGNAL_ACTION).not) ||
             ($k == 1 && ($query.signal_flags +& G_SIGNAL_ACTION)    );

      }
    }

    next unless @found-signals;
    n-print " { HEADING_COLOR }Element { $k ?? 'Signals' !! 'Actions' }{
                RESET_COLOR }:\n";

    for @found-signals -> $q {
      my $rt = GLib::Object::Type.new($q.return_type);
      my $il = $q.signal_name.chars + $rt.name.chars + 24;
      my $pmark = do if gtype-needs-ptr-marker($rt) {
        $il += 2;
        '* '
      } else {
        '  ';
      }
      my $indent = ' ' x ($il + 1);

      n-print "  { PROP_NAME_COLOR }\"{ $q.signal_name }\" :  { RESET_COLOR }{
                    DATATYPE_COLOR }{ $rt.name }{ PROP_VALUE_COLOR }{ $pmark }{
                    RESET_COLOR }user_function{ DATATYPE_COLOR } ({
                    $type // 'GObject' }{ PROP_VALUE_COLOR }* object{
                    RESET_COLOR }";
      for ^$q.n_params {
        my $t  = GLib::Object::Type.new($q.param_types[$_]);
        my $tn = $t.name;
        my $a  = gtype-needs-ptr-marker($t) ?? '*' !! '';

        print ",\n";
        n-print "{ $indent }{ DATATYPE_COLOR }{ $tn }{ PROP_VALUE_COLOR }{
                    $a } arg{$_}{ RESET_COLOR }";

      }

      if $k.not {
        print ",\n";
        n-print "{ $indent }{ DATATYPE_COLOR }gpointer {
                    PROP_VALUE_COLOR }user_data{ RESET_COLOR });\n";
      } else {
        print ");\n";
      }
    }
  }
}

sub print-children-info ($e) {
  return unless $e.isType( BIN_TYPE );

  my $bin = GStreamer::Bin.new($e.GstElement);
  if $bin.children -> $kids {
    n-print;
    n-print " { HEADING_COLOR }Children{ RESET_COLOR }:";
    n-print "  { DATATYPE_COLOR }{ .name }{ RESET_COLOR }\n" for $kids[]
  }
}

sub print-preset-list ($e is copy) {
  return unless $e.isType( preset-get-type );

  $e = $e but GStreamer::Roles::Preset;
  $e.roleInit-GstPreset;

  if $e.get_preset_names -> $presets {
    n-print;
    n-print " { HEADING_COLOR }Presets{ RESET_COLOR }:\n";
    n-print '  "' ~ $_  ~ '"' ~ "\n" for $presets[];
  }
}

sub singular-or-plural ($c, $s, $p = $s ~ 's') {
  $c ~ ' ' ~ ($c == 1 ?? $s !! $p)
}

sub print-blacklist {
  print " { HEADING_COLOR }Blacklisted files{ RESET_COLOR }:";

  my ($repo, $count) = (GStreamer::Registry.get, 0);
  for $repo.get-plugin-list[] -> $p {
    if $p.flag.set(GST_PLUGIN_FLAG_BLACKLISTED) {
      print "  { $p.name }" && $count++;
    }
  }

  n-print;
  print "{ PROP_NAME_COLOR }Total count{ RESET_COLOR }: { PROP_VALUE_COLOR }";
  print "{ $count } blacklisted { singular-or-plural($count, 'file') }{
            RESET_COLOR }\n";
}

sub print-typefind-extensions (@exts, $color) {
  for @exts.kv -> $k, $v {
    print "{ $k ?? ', ' !! ' : ' }{ $color }{ $v }{ RESET_COLOR }";
  }
}

sub print-element-list ($pa, $ft) {
  my @types;
  @types = $ft.split('/').map( *.uc ) if $ft;

  my %counts;
  for $reg.get-plugin-list -> $plugin {
    %counts<plugin>++;
    if $plugin.flag-set(GST_PLUGIN_FLAG_BLACKLISTED) {
      %counts<blacklist>++;
      next;
    }

    for $reg.get-feature-list-by-plugin($plugin.name)[] -> $feature {
      next unless $feature;
      %counts<feature>++;

      if $feature.isType( ELEMENT_FACTORY_TYPE ) {
        my $factory = GStreamer::ElementFactory.new($feature.GstPluginFeature);

        if @types {
          my $all-found = True;
          my $klass = $factory.get-metadata(GST_ELEMENT_METADATA_KLASS);

          for @types {
            unless $klass.contains($_) {
              $all-found = False;
              last;
            }
          }
          next unless $all-found;
        }

        if $pa {
          print-element-info($feature, True);
        } else {
          my $ln = $factory.get-metadata(GST_ELEMENT_METADATA_LONGNAME);
          print "{ PLUGIN_NAME_COLOR }{ $plugin.name }{ RESET_COLOR }: {
                   ELEMENT_NAME_COLOR }{ $feature.name }{ RESET_COLOR }: {
                   ELEMENT_DETAIL_COLOR }{ $ln }{ RESET_COLOR }\n";
        }
      } elsif $feature.isType( TYPE_FIND_FACTORY_TYPE ) {
        next if @types.elems;
        my $factory = GStreamer::TypeFindFactory.new($feature.GstPluginFeature);

        print "{ PLUGIN_NAME_COLOR }{ $plugin.name }{ RESET_COLOR }: {
                  ELEMENT_NAME_COLOR }{ $feature.name }{ RESET_COLOR }: ";

        if $factory.get-extensions[] -> $ext {
          unless $pa {
            print-typefind-extensions($ext, ELEMENT_DETAIL_COLOR);
            n-print;
          }
        } else {
          print "{ ELEMENT_DETAIL_COLOR }no extensions{ RESET_COLOR }\n";
        }
      } else {
        next if @types.elems || $pa.not;
        n-print "{ PLUGIN_NAME_COLOR }{ $plugin.name }{ RESET_COLOR }:  {
                    ELEMENT_NAME_COLOR }{ $feature.name }{ RESET_COLOR } ({
                    ELEMENT_DETAIL_COLOR }{ $feature.objectType.name }{
                    RESET_COLOR })\n";
      }
    }
  }

  n-print;
  print "{ PROP_NAME_COLOR }Total count{ RESET_COLOR }: { PROP_VALUE_COLOR }";
  print "{ singular-or-plural(%counts<plugin>, 'plugin') }";
  if %counts<blacklist> -> $bc {
    print ' (' ~ singular-or-plural(
      $bc,
      'blacklist entry',
      'blacklist entries'
    ) ~ ' not shown)';
  }
  print "{ RESET_COLOR }, { PROP_VALUE_COLOR }{
            singular-or-plural(%counts<feature>, 'feature') }{ RESET_COLOR }\n";
}

sub print-all-uri-handlers {
  for $reg.get-plugin-list[] -> $plugin {
    for $reg.get-feature-list-by-plugin($plugin.name)[] -> $feature {
      if $feature.isType( ELEMENT_FACTORY_TYPE ) {
        my $factory = GStreamer::ElementFactory.new($feature.GstPluginFeature);

        unless $factory {
          print "element plugin { $plugin.name } could't be loaded\n";
          next;
        }

        my $element = $factory.create;
        unless $element {
          print "couldn't construct element for {
                  $factory.name } for some reason\n";
          next;
        }

        if $element.is_a( urihandler-get-type ) {
          $element = $element but GStreamer::Roles::URIHandler;
          $element.roleInit-URIHandler;
          my $dir = get-uriType-name($element.uri-type, :rw);

          print "{ FEATURE_NAME_COLOR }{ $factory.name }{ RESET_COLOR } ){
                    FEATURE_DIR_COLOR }{ $dir }{ RESET_COLOR }, {
                    FEATURE_RANK_COLOR }rank { $factory.rank }{
                    RESET_COLOR }): ";

          my $first = True;
          for $element.get-protocols[] {
            print ', ' unless $first;
            print "{ FEATURE_PROTO_COLOR }{ $_ }{ RESET_COLOR }";
          }
          n-print;
        }
      }
    }
  }
}

sub print-plugin-info ($p) {
  n-print " { HEADING_COLOR }Plugin Details{ RESET_COLOR }:\n";
  push-indent;
  n-print "  { PROP_NAME_COLOR }{ 'Name'.fmt('%-25s') }{ RESET_COLOR }{
             PROP_VALUE_COLOR }{ $p.name }{ RESET_COLOR }\n";
  n-print "  { PROP_NAME_COLOR }{ 'Description'.fmt('%-25s') }{ RESET_COLOR }{
             PROP_VALUE_COLOR }{ $p.description }{ RESET_COLOR }\n";
  n-print "  { PROP_NAME_COLOR }{ 'Filename'.fmt('%-25s') }{ RESET_COLOR }{
             PROP_VALUE_COLOR }{ ($p.filename // '(null)') }{ RESET_COLOR }\n";
  n-print "  { PROP_NAME_COLOR }{ 'Version'.fmt('%-25s') }{ RESET_COLOR }{
             PROP_VALUE_COLOR }{ $p.version }{ RESET_COLOR }\n";
  n-print "  { PROP_NAME_COLOR }{ 'License'.fmt('%-25s') }{ RESET_COLOR }{
             PROP_VALUE_COLOR }{ $p.license }{ RESET_COLOR }\n";
  n-print "  { PROP_NAME_COLOR }{ 'Source module'.fmt('%-25s') }{ RESET_COLOR }{
             PROP_VALUE_COLOR }{ $p.source }{ RESET_COLOR }\n";

  # may be: YYYY-MM-DD or YYYY-MM-DDTHH:MMZ
  # YYYY-MM-DDTHH:MMZ => YYYY-MM-DD HH:MM (UTC)
  if $p.release-date-string -> $rd {
    my $tz = '(UTC)';
    if $rd.contains('T') {
      $rd ~~ tr/TZ/ /;
    } else {
      $tz = '';
    }
    n-print "  { PROP_NAME_COLOR }{ 'Source release date'.fmt('%-25s') }{
               RESET_COLOR }{ PROP_VALUE_COLOR }{ $rd }{ $tz }{
               RESET_COLOR }\n";
  }
  n-print "  { PROP_NAME_COLOR }{ 'Binary package'.fmt('%-25s') }{ RESET_COLOR }{
             PROP_VALUE_COLOR }{ $p.package }{ RESET_COLOR }\n";
  n-print "  { PROP_NAME_COLOR }{ 'Origin URL'.fmt('%-25s') }{ RESET_COLOR }{
             PROP_VALUE_COLOR }{ $p.origin }{ RESET_COLOR }\n";
  pop-indent;
  n-print;
}

sub print-plugin-features ($p) {
  my %counts;
  constant ln = GST_ELEMENT_METADATA_LONGNAME;

  for $reg.get-feature-list-by-plugin($p.name)[] -> $feature {
    %counts<features>++;

    when $feature.isType( ELEMENT_FACTORY_TYPE ) {
      my $f = GStreamer::ElementFactory.new($feature.GstPluginFeature);

      %counts<elements>++;
      n-print "{ ELEMENT_NAME_COLOR }{ $f.name }{ RESET_COLOR }: {
                  ELEMENT_DETAIL_COLOR }{ $f.get-metadata(ln) }{
                  RESET_COLOR }\n";
    }

    when $feature.isType( TYPE_FIND_FACTORY_TYPE ) {
      my $f = GStreamer::TypeFindFactory.new($feature.GstPluginFeature);

      %counts<typefinders>++;
      if $f.get-extensions -> $e {
        print "  { ELEMENT_NAME_COLOR }{ $feature.name }{ RESET_COLOR }: ";
        print-typefind-extensions($e, ELEMENT_DETAIL_COLOR);
        n-print;
      } else {
        print "  { ELEMENT_NAME_COLOR }{ $feature.name }{ RESET_COLOR }: {
                    ELEMENT_DETAIL_COLOR }no extensions{ RESET_COLOR }\n";
      }
    }

    when $feature.isType( GStreamer::DeviceProviderFactory.get-type ) {
      my $f = GStreamer::DeviceProviderFactory.new($feature.GstPluginFeature);

      %counts<device providers>++;
      n-print "  { ELEMENT_NAME_COLOR }{ $f.name }{ RESET_COLOR }: {
                    ELEMENT_DETAIL_COLOR }{ $f.get-metadata(ln) }{
                    RESET_COLOR }\n";
    }

    when $feature.isType( TRACER_FACTORY_TYPE ) {
      %counts<tracers>++;
      n-print "  { ELEMENT_NAME_COLOR }{ $feature.name }{ RESET_COLOR }: {
                    DATATYPE_COLOR } ({ $feature.objectType.name }){
                    RESET_COLOR })\n";
    }

    when $feature.defined {
      %counts<other objects>++;
      n-print "  { ELEMENT_NAME_COLOR }{ $feature.name }{ RESET_COLOR }: ({
                   DATATYPE_COLOR }{ $feature.objectType.name }{
                   RESET_COLOR })\n";
    }
  }

  n-print;
  n-print "  { HEADING_COLOR }{
               singular-or-plural(%counts<features> // 0, 'feature') }{
               RESET_COLOR }:\n";
  n-print(
    "  { CHILD_LINK_COLOR }+--{ RESET_COLOR }{ PLUGIN_FEATURE_COLOR }{
         .value } { .key }{ RESET_COLOR }\n"
  ) for %counts.pairs.grep(*.key ne 'features');
  n-print;
}

sub print-feature-info ($fn, $pa) {
  if $reg.find-feature($fn, ELEMENT_FACTORY_TYPE ) -> $feature {
    return print-element-info($feature, $pa);
  }
  if $reg.find-feature($fn, TYPE_FIND_FACTORY_TYPE ) -> $feature {
    return print-typefind-info($feature, $pa);
  }
  if $reg.find-feature($fn, TRACER_FACTORY_TYPE ) -> $feature {
    return print-tracer-info($feature, $pa);
  }
  return -1;
}

sub print-element-info ($f, $pn) {
  unless ( my $pf = $f.load ) {
    die "Could not load plugin feature '{ $f }'!";
  }

  unless ( my $factory = GStreamer::ElementFactory.new($pf.GstPluginFeature) ) {
    print "{ DESC_COLOR }element plugin couldn't be loaded{ RESET_COLOR }\n";
    return -1;
  }

  unless ( my $element = $factory.create ) {
    print "{ DESC_COLOR }couldn't construct element for some reason{
              RESET_COLOR }\n";
    return -1;
  }

  $name = $pn ?? "{ DATATYPE_COLOR }{ $factory.name }{ RESET_COLOR }" !! Str;
  print-factory-details-info($factory);

  my $maxlevel;
  print-plugin-info($factory.plugin) if $factory.plugin;

  print-hierarchy($element.objectType, 0, $maxlevel);
  print-interfaces($element.objectType);
  with $element {
    .&print-pad-templates-info($factory);
    .&print-clocking-info;
    .&print-uri-handler-info;
    .&print-pad-info;
    .&print-element-properties-info;
    .&print-signal-info;
    .&print-children-info;
    .&print-preset-list;
    return 0;
  }
}

sub print-typefind-info ($f, $pn) {
  unless (my $factory = GStreamer::TypeFindFactory.new($f.GstPluginFeature) ) {
    print "{ DESC_COLOR }typefind plugin couldn't be loaded{ RESET_COLOR }\n";
    return -1;
  }

  $name = $pn ?? "{ DATATYPE_COLOR }$factory.name{ RESET_COLOR }" !! Str;

  n-print " { HEADING_COLOR }Factory Details{ RESET_COLOR }:\n";
  n-print "  { PROP_NAME_COLOR }{ 'Rank'.fmt('%-25s') }{ PROP_VALUE_COLOR }{
                get-rank-name($f.rank) } ({ $f.rank }){ RESET_COLOR }\n";
  n-print "  { PROP_NAME_COLOR }{ 'Name'.fmt('%-25s') }{ PROP_VALUE_COLOR }{
                $f.name }{ RESET_COLOR }\n";
  if $factory.get-caps -> $caps {
    n-print "  { PROP_NAME_COLOR }{ 'Caps'.fmt('%-25s') }{ PROP_VALUE_COLOR }{
                  ~$caps }{ RESET_COLOR }\n";
  }
  if $factory.get-extensions -> $exts {
    n-print "  { PROP_NAME_COLOR }{ 'Extensions'.fmt('%-25s') }{
                  RESET_COLOR }";
    print-typefind-extensions($exts, PROP_VALUE_COLOR);
    n-print;
  }
  n-print;

  if $factory.plugin -> $plug {
    print-plugin-info($plug);
  }
  0;
}

sub print-tracer-info ($f, $pn) {
  unless (my $factory = GStreamer::TracerFactory.new($f.GstPluginFeature) ) {
    print "{ DESC_COLOR }tracer plugin couldn't be loaded{ RESET_COLOR }\n";
    return -1;
  }

  if ( my $tracer = GStreamer::Tracer.new ) {
    print "{ DESC_COLOR }couldn't construct tracer for some reason{
              RESET_COLOR }\n";
    return -1;
  }

  $name = $pn ?? "{ DATATYPE_COLOR }$factory.name{ RESET_COLOR }" !! Str;
  n-print " { HEADING_COLOR }Factory Details{ RESET_COLOR }:\n";
  n-print "  { PROP_NAME_COLOR }{ 'Name'.fmt('%-25s') }{ PROP_VALUE_COLOR }{
              $f.name }{ RESET_COLOR }\n";
  n-print;

  if $factory.plugin -> $p {
    print-plugin-info($p)
  }
  print-hierarchy($tracer, 0, $);
  print-interfaces($tracer);
  0;
}

sub print-plugin-automatic-install-info-codecs ($f) {
  return unless ( my $k = $f.get_metadata(GST_ELEMENT_METADATA_KLASS) );

  my ($typename, $dir) = do if $k.contains(<Demuxer Decoder Depay Parser>.any) {
    ('decoder', GST_PAD_SINK);
  } elsif $k.contains('Muxer') {
    ('encoder', GST_PAD_SRC);
  } else {
    return;
  }

  my $caps;
  for $f.get-static-pad-templates[] -> $tmpl {
    if $tmpl.direction == $dir {
      $caps = $tmpl.get-caps;
      last;
    }
  }

  unless $caps {
    say "Couldn't find static pad template for { $typename } '{ $f.name }'\n";
    return;
  }

  $caps .= make-writeable;
  for ^($caps.get_size) {
    my $s = $caps.get-structure($_);

    $s.remove-field($_) for <framerate   channels  rate  depth  height
                             clock-rate  width     pixel-aspect-ratio>;
    print "{ $typename }-{ ~$s }";
  }
}

sub print-plugin-automatic-install-info-protocols ($f) {
  if ( my $protocols = $f.get-uri-protocols ) && $protocols.elems {
    my $ut = 'uri' ~ get-uriType-name($f.get-uri-type);
    return if $ut eq 'uriunknown';
    print "{ $ut }-{ $_ }" for $protocols[];
  }
}

sub print-plugin-automatic-install-info ($p) {
  say '»»» AII »»»';

  if $reg.get-feature-list(ELEMENT_FACTORY_TYPE) -> $features {
    for $features[] -> $pf {
      my $fp = $pf.plugin;

      # if +$fp.GstPlugin == +$p.GstPlugin {\
      if $fp.name eq $p.name {
        print "element-{ $pf.name }\n";
        print-plugin-automatic-install-info-protocols($pf);
        print-plugin-automatic-install-info-codecs($pf);
      }
    }
  }
}

sub redirect-stdout {
  my $pager = %*ENV<PAGER> // DEFAULT_PAGER;
  my @argv = $pager.split(' ');
  %*ENV<LESS> = DEFAULT_PAGER_OPTS;

  my @envp = do gather for %*ENV.pairs {
    take "{ .key }={ .value }";
  }

  my $stdin;
  my $argv = resolve-gstrv(@argv);
  my $envp = resolve-gstrv(@envp);
  unless ( ($*child-pid, $stdin) = GLib::Spawn.async-with-pipes(
    Str,
    $argv,
    $envp,
    G_SPAWN_DO_NOT_REAP_CHILD +| G_SPAWN_SEARCH_PATH
  ) ) {
    warn "GLib::Spawn failed: { $ERROR.message }" if $pager != DEFAULT_PAGER;
    return False;
  }

  dup2($stdin, $*OUT.native-descriptor);
  native-close($stdin);
  True;
}

sub print-all-plugin-automatic-install-info {
  print-plugin-automatic-install-info($_) for $reg.get-plugin-list[];
}

sub MAIN (
  Bool :a(:$print-all),                    #= Print all elements
  Bool :b(:$print-blacklist),              #= Print lis tof blacklisted files
  Bool :$print-plugin-auto-install-info,   #= Print a machine-parsable list of features the specified plgiuin or all plugins provide.
                                           #= Useful in connection with external automatic plugin installation mechanisms
  Str  :plugin(:$plugin-name),             #= List the plugin contents
  Str  :t(:$types),                        #= A '/' separated list of types of elements (also known as klass) to list. (unordered)
  Bool :exists(:$check-exists) is copy,    #= Check if the specified element or plugin exists
  Str  :atleast-version(:$min-version),    #= When checking if an element or plugin exists, also check that its version is at least the version specified
  Bool :$uri-handlers,                     #= Print supported URI schemes, with the elements that implement them
  Bool :$no-colors is copy,                #= Disable colors in output. You can also achieve the same by setting 'GST_INSPECT_NO_COLORS' environment variable to any value
  # GST_TOOLS_GOPTION_VERSION not implemented since it is not used
  *@args
) {
  my $*child-pid;
  my $print-aii = $print-plugin-auto-install-info;

  GStreamer::Main.init;

  %*ENV<G_ENABLE_DIAGNOSTIC> = 0 unless %*ENV<G_ENABLE_DIAGNOSTIC>:exists;

  # GStreamer::Tools.print-version;
  if $print-all && @args {
    $*ERR.say: "-a requires no extra arguments";
    exit -1;
  }

  if $uri-handlers && @args {
    $*ERR.say: "-u requires no extra arguments";
    exit -1;
  }

  my ($min-maj, $min-min, $min-mic);
  if $min-version {
    unless $min-version ~~ /(\d+)**3 %% '.'/ {
      $*ERR.say: "Can't parse version '{
                  $min-version }' passed to --atleast-version";
      exit -1;
    }
    ($min-maj, $min-min, $min-mic) = $/[0]».Int;
    $check-exists = True;
  }

  my $exit-code;
  if $check-exists {
    unless @args {
      $*ERR.say: '--exists requires an extra command line argument';
      exit -1;
    }
    if $plugin-name.not {
      if $reg.lookup-feature(@args[0]) -> $f {
        $exit-code = $f.check-version($min-maj, $min-min, $min-mic) ?? 0 !! 1;
      }
    } else {
      $*ERR.say: 'Checking for plugins is not supported yet';
      exit -1;
    }
    exit $exit-code;
  }

  my $loop;
  $no-colors //= %*ENV<GST_INSPECT_NO_COLORS>.so;
  # if isatty($*OUT.native-descriptor) {
  #   $loop = GLib::MainLoop.new if redirect-stdout;
  # } else {
  #   $no-colors = True;
  # }
  $loop = GLib::MainLoop.new;
  my $*co = $no-colors.not;

  if $uri-handlers {
    print-all-uri-handlers;
  } elsif @args.elems == 0 || $print-all {
    if $print-blacklist {
      print-blacklist;
    } else {
      $print-aii ?? print-all-plugin-automatic-install-info()
                 !! print-element-list($print-all, $types);
    }
  } else {
    my $retval = -1;
    my $arg = @args ?? @args[* - 1] !! '';

    sub print-plugin-details ($p) {
      if $print-aii {
        print-plugin-automatic-install-info($p);
      } else {
        print-plugin-info($p);
        print-plugin-features($p);
      }
    }

    $retval = print-feature-info($arg, $print-all) unless $plugin-name;
    unless $retval {
      if $reg.find-plugin($arg) -> $plugin {
        print-plugin-details($plugin)
      } else {
        if $arg.IO.e {
          if GStreamer::Plugin.load-file($arg) -> $plugin {
            print-plugin-details($plugin);
          } else {
            $*ERR.say: "Could not load plyhgin file: { $ERROR.message }";
            $exit-code = -1;
            return;
          }
        } else {
          $*ERR.say: "No such element or plugin '{ $arg }'";
          $exit-code = -1;
        }
      }
    }
  }

  LAST {
    if $loop {
      # for $*OUT, $*ERR { .flush; .close }
      GLib::MainLoop.child-watch-add($*child_pid, -> *@a {
        GLib::Spawn.close($*child-pid);
        $loop.quit
      });
      $loop.run;
      $loop.unref;
    }
    exit $exit-code;
  }

}
