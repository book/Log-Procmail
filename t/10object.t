use strict;
use Log::Procmail;
use Test::More tests => 10;

my $log = Log::Procmail->new;
isa_ok( $log, "Log::Procmail" );

# read from a filename
$log = Log::Procmail->new( "t/procmail.log" );
my $rec = $log->next;
is( $rec->from, 'r21436@start.no', "Correct from" );
is( $rec->date, 'Wed Feb  6 18:50:17 2002', "Correct date" );

open F, "t/procmail.log" or die "t/procmail.log: $!";

# read from a filehandle (glob ref)
$log = Log::Procmail->new( \*F );
$rec = $log->next;
is( $rec->from , 'r21436@start.no', "Correct from" );
is( $rec->date, 'Wed Feb  6 18:50:17 2002', "Correct date" );

# read from a IO::Handle
my $file = new IO::File;
$file->open( "t/procmail.log" );
$log = new Log::Procmail $file;
$rec = $log->next;
is( $rec->from , 'r21436@start.no', "Correct from" );
is( $rec->date, 'Wed Feb  6 18:50:17 2002', "Correct date" );

# simply check the accessor
is( $log->errors, 0,  "errors() is 0" );
is( $log->errors( 1 ), 1, "set errors()" );
is( $log->errors, 1, "get errors()");

