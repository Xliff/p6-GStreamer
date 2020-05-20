use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Controller::TimedValueControlSource;

use GStreamer::ControlSource;

use GLib::Roles::ListData;
use GStreamer::Roles::Signals::Controller::TimedValueControlSource;

our subset GstTimedValueControlSourceAncestry is export of Mu
  where GstTimedValueControlSource | GstControlSourceAncestry;

class GStreamer::Controller::TimedValueControlSource
  is GStreamer::ControlSource
{
  also does GStreamer::Roles::Signals::Controller::TimedValueControlSource;

  has GstTimedValueControlSource $!tvcs;

  submethod BUILD (:$timed-source) {
    self.setGstTimedValueControlSource($timed-source) if $timed-source;
  }

  method setGstTimedValueControlSource(GstTimedValueControlSourceAncestry $_) {
    my $to-parent;

    $!tvcs = do {
      when GstTimedValueControlSource {
        $to-parent = cast(GstControlSource, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstTimedValueControlSource, $_);
      }
    }
    self.setGstControlSource($to-parent);
  }

  method GStreamer::Raw::Structs::GstTimedValueControlSource
    is also<GstTimedValueControlSource>
  { $!tvcs }

  method new (GstTimedValueControlSourceAncestry $timed-source) {
    $timed-source ?? self.bless( :$timed-source ) !! Nil;
  }

  # Is originally:
  # GstTimedValueControlSource, GstControlPoint, gpointer
  method value-added is also<value_added> {
    self.connect-control-point($!tvcs, 'value-added');
  }

  # Is originally:
  # GstTimedValueControlSource, GstControlPoint, gpointer
  method value-changed is also<value_changed> {
    self.connect-control-point($!tvcs, 'value-changed');
  }

  # Is originally:
  # GstTimedValueControlSource, GstControlPoint, gpointer
  method value-removed is also<value_removed> {
    self.connect-control-point($!tvcs, 'value-removed');
  }


  method find_control_point_iter (Int() $timestamp)
    is also<find-control-point-iter>
  {
    my GstClockTime $t = $timestamp;

    gst_timed_value_control_source_find_control_point_iter($!tvcs, $t);
  }

  method get_all (:$glist = False, :$raw = False) is also<get-all> {
    my $tvl = gst_timed_value_control_source_get_all($!tvcs);

    return Nil unless $tvl;
    return $tvl if $glist && $raw;

    $tvl = GLib::GList.new($tvl) but GLib::Roles::ListData[GstTimedValue];

    return $tvl if $glist;
    $tvl.Array;
  }

  method get_count is also<get-count> {
    gst_timed_value_control_source_get_count($!tvcs);
  }

  method invalidate_cache is also<invalidate-cache> {
    gst_timed_value_control_invalidate_cache($!tvcs);
  }

  method set (Int() $timestamp, Num() $value) {
    my GstClockTime $t = $timestamp;
    my gdouble $v = $value;

    gst_timed_value_control_source_set($!tvcs, $t, $v);
  }

  method set_from_list (GSList() $timedvalues) is also<set-from-list> {
    gst_timed_value_control_source_set_from_list($!tvcs, $timedvalues);
  }

  method unset (Int() $timestamp) {
    my GstClockTime $t = $timestamp;

    gst_timed_value_control_source_unset($!tvcs, $t);
  }

  method unset_all is also<unset-all> {
    gst_timed_value_control_source_unset_all($!tvcs);
  }

}
