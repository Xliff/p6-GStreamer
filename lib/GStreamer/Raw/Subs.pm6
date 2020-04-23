use v6.c;

use NativeCall;

use GLib::Raw::Structs;
use GStreamer::Raw::Definitions;

use GLib::Roles::Pointers;

unit package GStreamer::Raw::Subs;

subset PassThru of Mu where Str | CArray;

sub ppr (*@a) is export {
  @a .= map({
    if $_ ~~ CArray {
      if .[0].defined {
        if .[0].REPR ne 'CPointer' {
          .[0]
        } else {
          +.[0] != 0 ?? ( .[0].of.REPR eq 'CStruct' ?? .[0].deref !! .[0] )
                     !! Nil;
        }
      } else {
        Nil;
      }
    }
    else { $_ }
  });
  @a.elems == 1 ?? @a[0] !! @a;
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

sub timeval-to-time (GTimeVal $tv) {
  $tv.tv_sec * GST_SECOND + $tv.tv_usec * GST_USECOND;
}

# Consider moving to GLibs!
sub getEndian is export {
  ( $*KERNEL.endian == BigEndian, $*KERNEL.endian == LittleEndian );
}
