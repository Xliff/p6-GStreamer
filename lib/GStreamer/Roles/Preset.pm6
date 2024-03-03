use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;
use GStreamer::Raw::Preset;

role GStreamer::Roles::Preset {
  has GstPreset $!ps;

  method roleInit-GstPreset is also<roleInit_GstPreset> {
    return if $!ps;
    
    my \i = findProperImplementor(self.^attributes);

    $!ps = cast( GstChildProxy, i.get_value(self) );
  }

  method GStreamer::Raw::Definitions::GstPreset
    is also<GstPreset>
  { $!ps }

  method delete_preset (Str() $name) is also<delete-preset> {
    so gst_preset_delete_preset($!ps, $name);
  }

  method get_app_dir ( ::?CLASS:U: )is also<get-app-dir> {
    gst_preset_get_app_dir();
  }

  proto method get_meta (|)
      is also<get-meta>
  { * }

  multi method get_meta (Str() $name, Str() $tag) {
    my $rv = samewith($name, $tag, $);

    $rv ?? $rv[1] !! Nil;
  }
  multi method get_meta (Str() $name, Str() $tag, $value is rw) {
    my $v = CArray[Str];
    my $rv = gst_preset_get_meta($!ps, $name, $tag, $v);

    $value = $v[0] ?? $v[0] !! Nil;

    ($rv, $value)
  }

  method get_preset_names is also<get-preset-names> {
    CStringArrayToArray( gst_preset_get_preset_names($!ps) );
  }

  method get_property_names is also<get-property-names> {
    CStringArrayToArray( gst_preset_get_property_names($!ps) );
  }

  method is_editable is also<is-editable> {
    so gst_preset_is_editable($!ps);
  }

  method load_preset (Str() $name) is also<load-preset> {
    so gst_preset_load_preset($!ps, $name);
  }

  method rename_preset (Str() $old_name, Str() $new_name)
    is also<rename-preset>
  {
    so gst_preset_rename_preset($!ps, $old_name, $new_name);
  }

  method save_preset (Str() $name) is also<save-preset> {
    so gst_preset_save_preset($!ps, $name);
  }

  method set_app_dir ( ::?CLASS:U: Str() $app_dir) is also<set-app-dir> {
    gst_preset_set_app_dir($app_dir);
  }

  method set_meta (Str() $name, Str() $tag, Str() $value)
    is also<set-meta>
  {
    gst_preset_set_meta($!ps, $name, $tag, $value);
  }

}

sub preset_get_type is export {
  state ($n, $t);
  unstable_get_type( 'GstPreset', &gst_preset_get_type, $n, $t );
}

sub preset-get-type is export {
  preset_get_type;
}
