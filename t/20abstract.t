use strict;
use Test::More tests => 33;
use Log::Procmail;

my $log = Log::Procmail->new("t/procmail.log");

# create a record by hand
my $rec = Log::Procmail::Abstract->new(
    from    => 'book@cpan.org',
    date    => 'Tue Feb  5 01:14:36 CET 2002',
    subject => 'Re: Log::Procmail',
    folder  => 'modules',
    size    => '2197',
);

isa_ok( $rec, "Log::Procmail::Abstract" );

# test the methods
is( $rec->from,    'book@cpan.org', "Correct from" );
is( $rec->date,    'Tue Feb  5 01:14:36 CET 2002', "Correct date");
is( $rec->subject, 'Re: Log::Procmail', "Correct subject");
is( $rec->folder,  'modules', "Correct folder" );
is( $rec->size,    '2197', "Correct size" );
is( $rec->ymd,     '20020205011436', "Correct ymd" );

# read a record from the first file
$rec = $log->next;
is( $rec->from, 'r21436@start.no',          "Correct from" );
is( $rec->date, 'Wed Feb  6 18:50:17 2002', "Correct date" );
is( $rec->subject,
    'I woke up from my obesity nightmare                         5765',
    "Correct subject" );
is( $rec->folder, '/var/spool/mail/book', "Correct folder" );
is( $rec->size, 5774, "Correct size" );

# read the remaining records
my $i = 1;
while ( $rec = $log->next ) { $i++ }
is( $i, 5, "Remaining logs" );

# push new files on the log stack
$log->push( 't/procmail.log', 't/procmail2.log' );
$rec = $log->next;

# did we get a new record?
isa_ok( $rec, "Log::Procmail::Abstract" );

# go to next file, automatically
$rec = $log->next for 1 .. 5;    # skip 5 records

is( $rec->from, 'p11542@24horas.com', "Correct from" );
is( $rec->date, 'Mon Feb  4 18:29:00 2002', "Correct date" );
is( $rec->subject,
    "I didn't want to struggle anymore                         5901",
    "Correct subject" );
is( $rec->folder, '/var/spool/mail/book', "Correct folder" );
is( $rec->size,   5745, "Correct size" );

# test modifying an abstract
$rec->from('book@cpan.org');
is( $rec->from, 'book@cpan.org', "Changed from" );

$rec->date('Mon Feb  4 18:29:00 2002');
is( $rec->ymd, '20020204182900', "date and ymd modified" );

1 while ( $log->next );
$log->push("t/log.tmp");

# test when a new mail is processed
open F, "> t/log.tmp" or die;
print F << 'EOT';
From e10299@firemail.de  Sat Feb  2 10:18:31 2002
 Subject: Boost Your Windows Reliability!!!!!!!                         14324
  Folder: /var/spool/mail/book						   3768
EOT
close F;

$rec = $log->next;
is( $rec->from,   'e10299@firemail.de', "Correct from" );
is( $rec->folder, '/var/spool/mail/book', "Correct folder" );
$rec = $log->next;
is( defined $rec, '', "No log left" );

# a new mail arrives
open F, ">> t/log.tmp" or die;
print F << 'EOT';
From Viagra9520@eudoramail.com  Sat Feb  2 11:58:00 2002
 Subject: Make This Valentine's Day Unforgettable.           QTTKE
  Folder: /var/spool/mail/book						   3981
EOT
close F;

$rec = $log->next;
is( $rec->from,    'Viagra9520@eudoramail.com', "Correct from" );
is( $rec->date,    'Sat Feb  2 11:58:00 2002', "Correct date" );
is( $rec->subject, "Make This Valentine's Day Unforgettable.           QTTKE",
    "Correct subject" );
is( $rec->folder,  '/var/spool/mail/book', "Correct folder" );
is( $rec->size,    3981, "Correct size" );

unlink "t/log.tmp";

# some folders with a space in their name
$log = Log::Procmail->new('t/procmail3.log');
$rec = $log->next;
is( $rec->folder, 'qmail-perms ./mail/inbox/', "Correct folder" );

# check that we correctly ignore errors
$rec = $log->next;
is( $rec->from, 'dailytip@bdcimail.com', "Correct from" );
$log->errors(1);

$rec = $log->next;
is( ref $rec, '', "Not a Log::Procmail::Abstract" );
like( $rec, qr/^Can't call method "print" on an undefined value/,
      "Got an error" );

