use strict;
use Test;
use vars '$loaded';

# see end of file
$loaded = 1;
ok( $loaded, 1 );

my $log = new Log::Procmail;
ok( ref($log), "Log::Procmail" );

open F, "t/procmail.log" and my $open = 1;
ok( $open, 1 );

# read from a filehandle (glob ref)
$log->push( \*F );
my $rec = $log->next;
ok( $rec->from, 'r21436@start.no' );

# read from a IO::Handle
my $file = new IO::File;
$file->open( "t/procmail.log" );
$log = new Log::Procmail $file;
$rec = $log->next;
ok( $rec->from, 'r21436@start.no' );

# prepare the first test (could I load the object)
BEGIN {
    $| =1;
    plan tests => 5;
    use Log::Procmail;
}

END {print "not ok 1\n" unless $loaded;}

