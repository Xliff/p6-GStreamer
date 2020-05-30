use v6.c;

use Test;
use NativeCall;

use GStreamer::Raw::Structs;

require ::($_ = "GStreamer::Raw::Structs");
for ::($_ ~ "::EXPORT::DEFAULT").WHO
                                .keys
                                .grep( *.defined && *.starts-with("Gst") )
                                .sort
{
  sub sizeof () returns int64 { ... }
  trait_mod:<is>( &sizeof, :native('t/00-struct-sizes.so') );
  trait_mod:<is>( &sizeof, :symbol('sizeof_' ~ $_) );

  my $c = ::("$_");

  diag $_;
  if ($c.WHY.leading // '') eq 'Opaque' {
    pass "Structure '{ $_ }' is marked as opaque";
    next;
  }
  is nativesizeof($c), sizeof(), "Structure sizes for { $_ } match";
}
