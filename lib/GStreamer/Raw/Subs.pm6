use v6.c;

use NativeCall;

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
