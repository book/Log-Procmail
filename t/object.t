use strict;
use Test;
use vars '$loaded';

# see end of file
$loaded = 1;
ok( $loaded, 1 );

my $log = new Log::Procmail;
ok( ref($log), "Log::Procmail" );

# read from a filename
$log = Log::Procmail->new( "t/procmail.log" );
my $rec = $log->next;
ok( $rec->from, 'r21436@start.no' );

open F, "t/procmail.log" and my $open = 1;
ok( $open, 1 );

# read from a filehandle (glob ref)
$log = Log::Procmail->new( \*F );
$rec = $log->next;
ok( $rec->from, 'r21436@start.no' );

# read from a IO::Handle
my $file = new IO::File;
$file->open( "t/procmail.log" );
$log = new Log::Procmail $file;
$rec = $log->next;
ok( $rec->from, 'r21436@start.no' );

# simply check the accessor
ok( 0, $log->errors );
ok( 1, $log->errors( 1 ) );
ok( 1, $log->errors );

# prepare the first test (could I load the object)
BEGIN {
    $| =1;
    plan tests => 9;
    use Log::Procmail;
}

END {print "not ok 1\n" unless $loaded;}

