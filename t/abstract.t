use strict;
use Test;

use Log::Procmail;

$| = 1;

my $log = Log::Procmail->new("t/procmail.log");

# create a record by hand
my $rec = Log::Procmail::Abstract->new(
    from    => 'book@cpan.org',
    date    => 'Tue Feb  5 01:14:36 CET 2002',
    subject => 'Re: Log::Procmail',
    folder  => 'modules',
    size    => '2197',
);

ok( ref $rec, "Log::Procmail::Abstract" );

# check that the methods don't exist yet
ok( ref $rec->can('from'),    '' );
ok( ref $rec->can('date'),    '' );
ok( ref $rec->can('subject'), '' );
ok( ref $rec->can('folder'),  '' );
ok( ref $rec->can('size'),    '' );

# autoload the methods
ok( $rec->from,    'book@cpan.org' );
ok( $rec->date,    'Tue Feb  5 01:14:36 CET 2002' );
ok( $rec->subject, 'Re: Log::Procmail' );
ok( $rec->folder,  'modules' );
ok( $rec->size,    '2197' );
ok( $rec->ymd,     '20020205011436' );

# check they exist now
ok( ref $rec->can('from'),    'CODE' );
ok( ref $rec->can('date'),    'CODE' );
ok( ref $rec->can('subject'), 'CODE' );
ok( ref $rec->can('folder'),  'CODE' );
ok( ref $rec->can('size'),    'CODE' );

# read a record from the first file
$rec = $log->next;
ok( $rec->from, 'r21436@start.no' );
ok( $rec->date, 'Wed Feb  6 18:50:17 2002' );
ok( $rec->subject,
    'I woke up from my obesity nightmare                         5765' );
ok( $rec->folder, '/var/spool/mail/book' );
ok( $rec->size,   5774 );

# read the remaining records
my $i = 1;
while ( $rec = $log->next ) { $i++ }
ok( $i, 5 );

# push new files on the log stack
$log->push( 't/procmail.log', 't/procmail2.log' );
$rec = $log->next;

# did we get a new record?
ok( ref $rec, "Log::Procmail::Abstract" );

# go to next file, automatically
$rec = $log->next for 1 .. 5;    # skip 5 records

ok( $rec->from, 'p11542@24horas.com' );
ok( $rec->date, 'Mon Feb  4 18:29:00 2002' );
ok( $rec->subject,
    "I didn't want to struggle anymore                         5901" );
ok( $rec->folder, '/var/spool/mail/book' );
ok( $rec->size,   5745 );

# test modifying an abstract
$rec->from('book@cpan.org');
ok( $rec->from, 'book@cpan.org' );

$rec->date('Mon Feb  4 18:29:00 2002');
ok( $rec->ymd, '20020204182900' );

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
ok( $rec->from,   'e10299@firemail.de' );
ok( $rec->folder, '/var/spool/mail/book' );
$rec = $log->next;
ok( defined $rec, '' );

# a new mail arrives
open F, ">> t/log.tmp" or die;
print F << 'EOT';
From Viagra9520@eudoramail.com  Sat Feb  2 11:58:00 2002
 Subject: Make This Valentine's Day Unforgettable.           QTTKE
  Folder: /var/spool/mail/book						   3981
EOT
close F;

$rec = $log->next;
ok( $rec->from,    'Viagra9520@eudoramail.com' );
ok( $rec->date,    'Sat Feb  2 11:58:00 2002' );
ok( $rec->subject, "Make This Valentine's Day Unforgettable.           QTTKE" );
ok( $rec->folder,  '/var/spool/mail/book' );
ok( $rec->size,    3981 );

unlink "t/log.tmp";

# some folders with a space in their name
$log = Log::Procmail->new('t/procmail3.log');
$rec = $log->next;
ok( $rec->folder, 'qmail-perms ./mail/inbox/' );

# check that we correctly ignore errors
$rec = $log->next;
ok( $rec->from, 'dailytip@bdcimail.com' );
$log->errors(1);

$rec = $log->next;
ok( ref $rec, '' );
ok( $rec, qr/^Can't call method "print" on an undefined value/ );

BEGIN { plan tests => 43 }

