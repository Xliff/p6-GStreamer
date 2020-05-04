use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Promise;

use GStreamer::MiniObject;

our subset GstPromiseAncestry is export of Mu
  where GstPromise | GstMiniObject;

class GStreamer::Promise is GStreamer::MiniObject {
  has GstPromise $!p;

  submethod BUILD (:$promise) {
    self.setGstPromise($promise);
  }

  method setGstPromise (GstPromiseAncestry $_) {
    my $to-parent;

    $!p = do {
      when GstPromise {
        $to-parent = cast(GstMiniObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstPromise, $_);
      }
    }
    self.setMiniObject($to-parent);
  }

  method GStreamer::Raw::Structs::GstPromise
    is also<GstPromise>
  { $!p }

  multi method new (GstPromiseAncestry $promise) {
    $promise ?? self.bless( :$promise ) !! Nil;
  }
  multi method new {
    my $promise = gst_promise_new();

    $promise ?? self.bless( :$promise ) !! Nil;
  }

  method new_with_change_func (
    &func,
    gpointer $user_data    = gpointer,
    GDestroyNotify $notify = gpointer
  )
    is also<new-with-change-func>
  {
    my $promise = gst_promise_new_with_change_func(
      &func,
      $user_data,
      $notify
    );

    $promise ?? self.bless( :$promise ) !! Nil;
  }

  method expire {
    gst_promise_expire($!p);
  }

  method get_reply (:$raw = False) is also<get-reply> {
    my $s = gst_promise_get_reply($!p);

    $s ??
      ( $raw ?? $s !! GStreamer::Structure.new($s) )
      !!
      Nil;
  }

  method interrupt {
    gst_promise_interrupt($!p);
  }

  method reply (GstStructure() $s) {
    gst_promise_reply($!p, $s);
  }

  method wait {
    GstPromiseResultEnum( gst_promise_wait($!p) );
  }

}
