use v6.c;

use Method::Also;
use NativeCall;

use GTK::Compat::Types;
use GStreamer::Raw::Main;

class GStreamer::Main {

  method new (|) {
    warn 'GStreamer::Main is a static class and does not need instantiation'
      if $DEBUG;

    GStreamer::Main;
  }

  multi method init {
    my ($c, $v) = (0, CArray[Str].new);

    samewith($c, $v);
  }
  multi method init (Int $c, CArray[Str] $v) {
    my gint $ac = $c;

    # $ac is rw to pass the pointer. We do not need it back.
    gst_init($ac, $v);
  }

  proto method init_check (|)
    is also<init-check>
  { * }

  multi method init_check  {
    my ($c, $v) = (0, CArray[Str].new);

    samewith($c, $v);
  }
  multi method init_check(
    Int $c,
    CArray[Str] $v,
    CArray[Pointer[GError]] $error = gerror
  ) {
    my gint $ac = $c;

    clear_error;
    # $ac is rw to pass the pointer. We do not need it back.
    my $rc = gst_init_check ($ac, $v, $error);
    set_error($error);

    $rc;
  }

  method deinit {
    gst_deinit();
  }

  method get_main_executable_path is also<get-main-executable-path> {
    gst_get_main_executable_path();
  }

  method init_get_option_group (:$raw = False)
    is also<init-get-option-group>
  {
    # Waiting for the creation of GTK::Compat::OptionGroup.
    gst_init_get_option_group()
  }

  method is_initialized is also<is-initialized> {
    so gst_is_initialized();
  }

  method registry_fork_is_enabled is also<registry-fork-is-enabled> {
    so gst_registry_fork_is_enabled();
  }

  method registry_fork_set_enabled (Int() $enabled)
    is also<registry-fork-set-enabled>
  {
    gst_registry_fork_set_enabled($enabled);
  }

  method segtrap_is_enabled is also<segtrap-is-enabled> {
    so gst_segtrap_is_enabled();
  }

  method segtrap_set_enabled (Int() $enabled)
    is also<segtrap-set-enabled>
  {
    gst_segtrap_set_enabled($enabled);
  }

  method update_registry is also<update-registry> {
    gst_update_registry();
  }

  multi method version {
    my guint ($mj, $mn, $mc, $n) = 0 xx 4;

    samewith($mj, $mn, $mc, $n);
  }
  multi method version (
    Int $major is rw,
    Int $minor is rw,
    Int $micro is rw,
    Int $nano  is rw
  ) {
    my guint ($mj, $mn, $mc, $n) = 0 xx 4;

    gst_version($mj, $mn, $mc, $n);
    ($major, $minor, $micro, $nano) = ($mj, $mn, $mc, $n);
  }

  method version_string is also<version-string> {
    gst_version_string();
  }

}
