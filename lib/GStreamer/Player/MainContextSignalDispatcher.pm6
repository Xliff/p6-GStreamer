use v6.c;

use Method::Also;

use NativeCall;

use GStreamer::Raw::Types;

use GLib::Roles::Object;

our subset GstMainContextSignalDispatcherAncestry is export of Mu
  where GstPlayerMainContextSignalDispatcher | GstPlayerSignalDispatcher | GObject;

class GStreamer::Player::MainContextSignalDispatcher {
  also does GLib::Roles::Object;

  has GstPlayerMainContextSignalDispatcher $!mcsd;

  submethod BUILD (:$csd) {
    self.setMainContextSignalDispatcher($csd);
  }

  submethod TWEAK {
    # Role inits?
  }

  method setMainContextSignalDispatcher (
    GstMainContextSignalDispatcherAncestry $_
  ) {
    my $to-parent;

    $!mcsd = do {
      when GstPlayerMainContextSignalDispatcher {
        $to-parent = cast(GObject, $_);
        $_;
      }

      when GstPlayerSignalDispatcher {
        $to-parent = cast(GObject, $_);
        cast(GstPlayerMainContextSignalDispatcher, $_);
      }

      default {
        $to-parent = $_;
        cast(GstPlayerMainContextSignalDispatcher, $_);
      }
    }
    self!setObject($to-parent);
  }

  method GStreamer::Raw::Definitions::GstPlayerMainContextSignalDispatcher
    is also<GstPlayerMainContextSignalDispatcher>
  { $!mcsd }

  # Should be in a compunit dedicated for the role, but not there yet.
  method GStreamer::Raw::Definitions::GstPlayerSignalDispatcher
    is also<GstPlayerSignalDispatcher>
  { cast(GstPlayerSignalDispatcher, $!mcsd)  }

  multi method new {
    samewith(GMainContext);
  }
  multi method new (GMainContext() $app-context) {
    my $csd = gst_player_g_main_context_signal_dispatcher_new($app-context);

    $csd ?? self.bless( :$csd ) !! Nil;
  }

  # Type: GMainContext
  method application-context (:$raw = False) is rw {
    my GLib::Value $gv .= new(G_TYPE_POINTER);
    Proxy.new(
      FETCH => sub ($) {
        self.prop_get('application-context', $gv);

        my $v = $gv.pointer;

        return Nil unless $v;
        $v = cast(GMainContext, $v);
        $raw ?? $v !! GLib::MainContext.new($v);
      },
      STORE => -> $, GMainContext() $val is copy {
        warn 'application-context can only be set at construct-time!'
          if $DEBUG;
      }
    );
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type(
      self.^name,
      &gst_player_g_main_context_signal_dispatcher_get_type,
      $n,
      $t
    );
  }

}


### /usr/include/gstreamer-1.0/gst/player/gstplayer-g-main-context-signal-dispatcher.h

sub gst_player_g_main_context_signal_dispatcher_get_type ()
  returns GType
  is native(gstreamer-player)
  is export
{ * }

sub gst_player_g_main_context_signal_dispatcher_new (
  GMainContext $application_context
)
  returns GstPlayerMainContextSignalDispatcher
  is native(gstreamer-player)
  is export
{ * }
