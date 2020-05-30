use v6.c;

use Method::Also;

use GStreamer::Raw::Types;
use GStreamer::Raw::Toc;

use GLib::GList;
use GStreamer::MiniObject;
use GStreamer::TagList;

use GLib::Roles::ListData;

our subset GstTocEntryAncestry is export of Mu
  where GstTocEntry | GstMiniObject;

class GStreamer::TocEntry is GStreamer::MiniObject {
  has GstTocEntry $!te;

  submethod BUILD (:$entry) {
    self.setTocEntry($entry);
  }

  method setTocEntry (GstTocEntryAncestry $_) {
    my $to-parent;

    $!te = do {
      when GstTocEntry {
        $to-parent = cast(GstMiniObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstTocEntry, $_);
      }
    }
    self.setMiniObject($to-parent);
  }

  multi method new (GstTocEntryAncestry $entry) {
    $entry ?? self.bless(:$entry) !! Nil;
  }
  multi method new (Int() $toc_entry_type, Str $uid) {
    my GstTocEntryType $et = $toc_entry_type;
    my $entry = gst_toc_entry_new($et, $uid);

    $entry ?? self.bless(:$entry) !! Nil;
  }

  method GStreamer::Raw::Structs::GstTocEntry
    is also<GstTocEntry>
  { $!te }

  method append_sub_entry (GstTocEntry() $subentry) is also<append-sub-entry> {
    gst_toc_entry_append_sub_entry($!te, $subentry);
  }

  method get_entry_type is also<get-entry-type> {
    GstTocEntryTypeEnum( gst_toc_entry_get_entry_type($!te) );
  }

  proto method get_loop (|)
      is also<get-loop>
  { * }

  multi method get_loop {
    my $rv = callwith($, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method get_loop (
    $loop_type is rw,
    $repeat_count is rw,
    :$all = False
  ) {
    my GstTocLoopType $lt = 0;
    my gint $rpc = 0;

    my $rv = so gst_toc_entry_get_loop($!te, $lt, $rpc);
    ($loop_type, $repeat_count) = ($lt, $rpc);
    $all.not ?? $rv !! ($rv, $loop_type, $repeat_count);
  }

  method get_parent (:$raw = False) is also<get-parent> {
    my $p = gst_toc_entry_get_parent($!te);

    $p ??
      ( $raw ?? $p !! GStreamer::TocEntry.new($p) )
      !!
      Nil;
  }

  proto method get_start_stop_times (|)
      is also<get-start-stop-times>
  { * }

  multi method get_start_stop_times {
    my $rv = samewith($, $, :all);

    $rv[0] ?? $rv.skip(1) !! Nil;
  }
  multi method get_start_stop_times (
    $start is rw,
    $stop is rw,
    :$all = False
  ) {
    my gint64 ($st, $sp) = 0 xx 2;
    my $rv = so gst_toc_entry_get_start_stop_times($!te, $st, $sp);

    ($start, $stop) = ($st, $sp);
    $all.not ?? $rv !! ($rv, $start, $stop);
  }

  method get_sub_entries (:$glist = False, :$raw = False)
    is also<get-sub-entries>
  {
    my $sel = gst_toc_entry_get_sub_entries($!te);

    return Nil unless $sel;
    return $sel if $glist;

    $sel = GLib::GList.new($sel) but GLib::Roles::ListData[GstTocEntry];
    $raw ?? $sel.Array !! $sel.Array.map({ GStreamer::TocEntry.new($_) });
  }

  method get_tags (:$raw = False) is also<get-tags> {
    my $tl = gst_toc_entry_get_tags($!te);

    $tl ??
      ( $raw ?? $tl !! GStreamer::TagList.new($tl) )
      !!
      Nil;
  }

  method get_toc (:$raw = False) is also<get-toc> {
    my $toc = gst_toc_entry_get_toc($!te);

    $toc ??
      ( $raw ?? $toc !! GStreamer::Toc.new($toc) )
      !!
      Nil;
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_toc_entry_get_type, $n, $t );
  }

  method get_uid is also<get-uid> {
    gst_toc_entry_get_uid($!te);
  }

  method is_alternative is also<is-alternative> {
    so gst_toc_entry_is_alternative($!te);
  }

  method is_sequence is also<is-sequence> {
    so gst_toc_entry_is_sequence($!te);
  }

  method merge_tags (GstTagList() $tags, GstTagMergeMode $mode)
    is also<merge-tags>
  {
    my GstTagMergeMode $m = $mode;

    gst_toc_entry_merge_tags($!te, $tags, $m);
  }

  method set_loop (Int() $loop_type, Int() $repeat_count) is also<set-loop> {
    my GstTocLoopType $lt = $loop_type;
    my gint $rc = $repeat_count;

    gst_toc_entry_set_loop($!te, $lt, $rc);
  }

  method set_start_stop_times (Int() $start, Int() $stop)
    is also<set-start-stop-times>
  {
    my gint64 ($st, $sp) = ($start, $stop);

    gst_toc_entry_set_start_stop_times($!te, $start, $stop);
  }

  method set_tags (GstTagList() $tags) is also<set-tags> {
    gst_toc_entry_set_tags($!te, $tags);
  }

  method type_get_nick (
    GStreamer::TocEntry:U:
    Int() $type
  )
    is also<type-get-nick>
  {
    my GstTocEntryType $t = $type;

    gst_toc_entry_type_get_nick($t);
  }

}

our subset GstTocAncestry is export of Mu
  where GstToc | GstMiniObject;

class GStreamer::Toc is GStreamer::MiniObject {
  has GstToc $!t;

  submethod BUILD (:$toc) {
    self.setToc($toc);
  }

  method setToc (GstTocAncestry $_) {
    my $to-parent;

    $!t = do {
      when GstToc {
        $to-parent = cast(GstMiniObject, $_);
        $_;
      }

      default {
        $to-parent = $_;
        cast(GstToc, $_);
      }
    };
    self.setMiniObject($to-parent);
  }

  method GStreamer::Raw::Structs::GstToc
    is also<GstToc>
  { $!t }

  multi method new (GstTocAncestry $toc) {
    $toc ?? self.bless( :$toc ) !! Nil;
  }
  multi method new (Int() $scope) {
    my GstTocScope $s = $scope;
    my $toc = gst_toc_new($s);

    $toc ?? self.bless( :$toc ) !! Nil;
  }

  method tags (:$raw = False) is rw {
    Proxy.new(
      FETCH => sub ($) {
        my $tl = gst_toc_get_tags($!t);

        $tl ??
          ( $raw ?? $tl !! GStreamer::TagList.new($tl) )
          !!
          Nil;
      },
      STORE => sub ($, GstTagList() $tags is copy) {
        gst_toc_set_tags($!t, $tags);
      }
    );
  }

  method append_entry (GstTocEntry() $entry) is also<append-entry> {
    gst_toc_append_entry($!t, $entry);
  }

  method dump {
    gst_toc_dump($!t);
  }

  method find_entry (Str() $uid) is also<find-entry> {
    gst_toc_find_entry($!t, $uid);
  }

  method get_entries (:$glist = False, :$raw = False) is also<get-entries> {
    my $ell = gst_toc_get_entries($!t);

    return Nil unless $ell;
    return $ell if $glist;

    $ell = GLib::GList($ell) but GLib::Roles::ListData[GstTocEntry];
    $raw ?? $ell.Array !! $ell.Array.map({ GStreamer::TocEntry.new($_) });
  }

  method get_scope is also<get-scope> {
    GstTocScopeEnum( gst_toc_get_scope($!t) );
  }

  method get_type is also<get-type> {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_toc_get_type, $n, $t );
  }

  method merge_tags (GstTagList $tags, Int() $mode) is also<merge-tags> {
    my GstTagMergeMode $m = $mode;

    gst_toc_merge_tags($!t, $tags, $m);
  }

}
