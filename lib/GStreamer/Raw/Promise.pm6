use v6.c;

use GLib::Raw::Definitions;
use GStreamer::Raw::Definitions;
use GStreamer::Raw::Enums;
use GStreamer::Raw::Structs;

unit package GStreamer::Raw::Promise;

### /usr/include/gstreamer-1.0/gst/gstpromise.h

sub gst_promise_expire (GstPromise $promise)
  is native(gstreamer)
  is export
{ * }

sub gst_promise_get_reply (GstPromise $promise)
  returns GstStructure
  is native(gstreamer)
  is export
{ * }

sub gst_promise_interrupt (GstPromise $promise)
  is native(gstreamer)
  is export
{ * }

sub gst_promise_new ()
  returns GstPromise
  is native(gstreamer)
  is export
{ * }

sub gst_promise_new_with_change_func (
  &func (GstPromise, gpointer),
  gpointer $user_data,
  GDestroyNotify $notify
)
  returns GstPromise
  is native(gstreamer)
  is export
{ * }

sub gst_promise_reply (GstPromise $promise, GstStructure $s)
  is native(gstreamer)
  is export
{ * }

sub gst_promise_wait (GstPromise $promise)
  returns GstPromiseResult
  is native(gstreamer)
  is export
{ * }
