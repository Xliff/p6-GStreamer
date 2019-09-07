use v6.c;

use GTK::Compat::Types;
use GStreamer::Raw::Types;
use GStreamer::Raw::Toc;

use GStreamer::MiniObject;
use GStreamer::TagList;

use GTK::Compat::Roles::ListData;

our subset TocEntryAncestry is export of Mu
  where GstTocEntry | GstMiniObject;

class GStreamer::TocEntry is GStreamer::MiniObject {
  has GstTocEntry $!te;

  submethod BUILD (:$entry) {
    self.setTocEntry($entry);
  }

  method setTocEntry (TocEntryAncestry $_) {
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
    };
    self.setMiniObject($to-parent);
  }

  method new (Int() $toc_entry_type, Str $uid) {
    my GstTocEntryType $et = $toc_entry_type;

    self.bless( entry => gst_toc_entry_new($et, $uid) );
  }

  method GStreamer::Raw::Types::GstTocEntry
  { $!te }

  method append_sub_entry (GstTocEntry() $subentry) {
    gst_toc_entry_append_sub_entry($!te, $subentry);
  }

  method get_entry_type {
    GstTocEntryTypeEnum( gst_toc_entry_get_entry_type($!te) );
  }

  proto method get_loop (|)
  { * }

  multi method get_loop {
    samewith($, $);
  }
  multi method get_loop ($loop_type is rw, $repeat_count is rw) {
    my GstTocLoopType $lt = 0;
    my gint $rpc = 0;

    my $rc = so gst_toc_entry_get_loop($!te, $lt, $rpc);
    ($loop_type, $repeat_count) = ($lt, $rc);
    ($loop_type, $repeat_count, $rc);
  }

  method get_parent (:$raw = False) {
    my $p = gst_toc_entry_get_parent($!te);

    $p ??
      ( $raw ?? $p !! GStreamer::TocEntry.new($p) )
      !!
      Nil;
  }

  proto method get_start_stop_times (|)
  { * }

  multi method get_start_stop_times {
    samewith($, $);
  }
  multi method get_start_stop_times ($start is rw, $stop is rw) {
    my gint64 ($st, $sp) = 0 xx 2;
    my $rc = so gst_toc_entry_get_start_stop_times($!te, $st, $sp);

    ($start, $stop) = ($st, $sp);
    ($start, $stop, $rc);
  }

  method get_sub_entries (:$raw = False) {
    my $sel = gst_toc_entry_get_sub_entries($!te);

    do if $sel {
      my $se = GTK::Compat::GList.new($sel)
        but GTK::Compat::Roles::ListData[GstTocEntry];

      $se ??
        ( $raw ?? $se.Array !! $se.Array.map({ GStreamer::TocEntry.new($_) }) )
        !!
        Nil;
    } else {
      Nil
    };
  }

  method get_tags (:$raw = False) {
    my $tl = gst_toc_entry_get_tags($!te);

    $tl ??
      ( $raw ?? $tl !! GStreamer::TagList.new($tl) )
      !!
      Nil;
  }

  method get_toc (:$raw = False) {
    my $toc = gst_toc_entry_get_toc($!te);

    $toc ??
      ( $raw ?? $toc !! GStreamer::Toc.new($toc) )
      !!
      Nil;
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_toc_entry_get_type, $n, $t );
  }

  method get_uid {
    gst_toc_entry_get_uid($!te);
  }

  method is_alternative {
    so gst_toc_entry_is_alternative($!te);
  }

  method is_sequence {
    so gst_toc_entry_is_sequence($!te);
  }

  method merge_tags (GstTagList() $tags, GstTagMergeMode $mode) {
    my GstTagMergeMode $m = $mode;

    gst_toc_entry_merge_tags($!te, $tags, $m);
  }

  method set_loop (Int() $loop_type, Int() $repeat_count) {
    my GstTocLoopType $lt = $loop_type;
    my gint $rc = $repeat_count;

    gst_toc_entry_set_loop($!te, $lt, $rc);
  }

  method set_start_stop_times (Int() $start, Int() $stop) {
    my gint64 ($st, $sp) = ($start, $stop);

    gst_toc_entry_set_start_stop_times($!te, $start, $stop);
  }

  method set_tags (GstTagList() $tags) {
    gst_toc_entry_set_tags($!te, $tags);
  }

  method type_get_nick (
    GStreamer::TocEntry:U:
    Int() $type
  ) {
    my GstTocEntryType $t = $type;

    gst_toc_entry_type_get_nick($t);
  }

}

our subset TocAncestry is export of Mu
  where GstToc | GstMiniObject;

class GStreamer::Toc is GStreamer::MiniObject {
  has GstToc $!t;

  submethod BUILD (:$toc) {
    self.setToc($toc);
  }

  method setToc (TocAncestry $_) {
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

  method GStreamer::Raw::Types::GstToc
  { $!t }

  method new (Int() $scope) {
    my GstTocScope $s = $scope;

    self.bless( toc => gst_toc_new($s) );
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

  method append_entry (GstTocEntry() $entry) {
    gst_toc_append_entry($!t, $entry);
  }

  method dump {
    gst_toc_dump($!t);
  }

  method find_entry (Str() $uid) {
    gst_toc_find_entry($!t, $uid);
  }

  method get_entries (:$raw = False) {
    my $ell = gst_toc_get_entries($!t);

    do if $ell {
      my $el = GTK::Compat::GList($ell)
        but GTK::Compat::Roles::ListData[GstTocEntry];

      $el ??
        ( $raw ?? $el.Array !! $el.Array.map({ GStreamer::TocEntry.new($_) }) )
        !!
        Nil
    } else {
      Nil;
    }
  }

  method get_scope {
    GstTocScopeEnum( gst_toc_get_scope($!t) );
  }

  method get_type {
    state ($n, $t);

    unstable_get_type( self.^name, &gst_toc_get_type, $n, $t );
  }

  method merge_tags (GstTagList $tags, Int() $mode) {
    my GstTagMergeMode $m = $mode;

    gst_toc_merge_tags($!t, $tags, $m);
  }

}
