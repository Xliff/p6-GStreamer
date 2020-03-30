use v6.c;

use NativeCall;

use GStreamer::Raw::Definitions;

unit package GStreamer::Raw::Subs;

sub ppr(*@a) is export {
  @a.map({
    if $_ ~~ CArray {
      if .[0].defined { if   .[0] ~~ Str { .[0] }
                        else             { +.[0] != 0 ?? .[0].deref !! Nil }
      }
      else { Nil }
    }
    else { $_ }
  });
}

sub postfix:<sec> ($s) is export {
  $s * GST_SECOND;
}

# Method::Also does not work for subs.
sub time-args ($d) is export {
  time_args($d);
}
sub time_args ($d) is export {
  $d != GST_CLOCK_TIME_NONE ?? (
     $d / (GST_SECOND * 60²),
    ($d / (GST_SECOND * 60)) % 60,
    ($d / GST_SECOND) % 60,
     $d % GST_SECOND
  ) !! (99, 99, 99, 999999999)
}
