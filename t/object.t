use strict;
use Test;
use vars '$loaded';

BEGIN {
   $| =1;
    plan tests => 2;
    use Log::Procmail;
}
   
$loaded = 1;
ok( $loaded, 1 );

END {print "not ok 1\n" unless $loaded;}

my $log = new Log::Procmail;
ok( ref($log), "Log::Procmail" );

