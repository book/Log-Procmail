use Test::More tests => 30;
use Log::Procmail;

# a file with actual bad logs
my $log = Log::Procmail->new('t/procmail4.log');
my $rec = $log->next;

# first log is okay
is( $rec->from,    'chandra_mcCarty_af@chingrafix.de', 'Correct from' );
is( $rec->date,    'Tue Apr  6 02:48:11 2004',         'Correct date' );
is( $rec->subject, 'Viagra that last all weekend',     'Correct subject' );
is( $rec->folder,  'spam',                             'Correct folder' );
is( $rec->size,    2726,                               'Correct size' );

# next two logs are mixed up
# but the first log does not have a Folder line
$rec = $log->next;
#is( $rec->from,    'root@home.bruhat.net',     'Correct from' );
#is( $rec->date,    'Tue Apr  6 02:53:47 2004', 'Correct date' );
#is( $rec->subject, undef,                      'Could not get the subject' );
#is( $rec->folder,  undef,                      'Could not get the folder' );
#is( $rec->size,    undef,                      'Could not get the size' );
#$rec = $log->next;
is( $rec->from,   'anxiety@schooloftheair.com', 'Correct from' );
is( $rec->date,   'Tue Apr  6 02:53:43 2004',   'Correct date' );
is( $rec->subject,
    'Cron <root@rose> test -e /usr/sbin/anacron || run-parts --report /etc',
    'Got the wrong subject');
is( $rec->folder, 'root',                       'Got the wrong folder' );
is( $rec->size, 5212, 'Got the wrong size' );

# should we ignore the next two lines ?
$rec = $log->next;
is( $rec->from,    undef,           'Correct from' );
is( $rec->date,    undef,           'Correct date' );
is( $rec->subject, 'Up to 80 percent off on medication, Sponsors.',
                                    'Correct subject' );
is( $rec->folder,  'conf-sponsors', 'Correct folder' );
is( $rec->size,    4453,            'Correct size' );

# next log is ok
$rec = $log->next;
is( $rec->from,    'bridgeheads@get-off-the-grass.com', 'Correct from' );
is( $rec->date,    'Tue Apr  6 02:53:43 2004',          'Correct date' );
is( $rec->subject, 'Jobs, need drugs?',                 'Correct subject' );
is( $rec->folder,  'mongueurs-jobs',                    'Correct folder' );
is( $rec->size,    4492,                                'Correct size' );

# no subject
$rec = $log->next;
is( $rec->from,    'qlogbffxuwl@freemail.com.au', 'Correct from' );
is( $rec->date,    'Tue Apr  6 06:40:05 2004',    'Correct date' );
is( $rec->subject, undef,                         'Correct subject' );
is( $rec->folder,  '/var/mail/book',              'Correct folder' );
is( $rec->size,    1205,                          'Correct size' );

# this one is correct
$rec = $log->next;
is( $rec->from,   'l_crockerqu@xcelco.on.ca', 'Correct from' );
is( $rec->date,   'Tue Apr  6 06:57:02 2004', 'Correct date' );
is( $rec->subject,
    '=?iso-8859-1?b?RXh0cmVtZWx5IEFmZm9yZGFibGUgUHJlcyVjcmlwdGlvbiBEcnVbZ3',
    'Correct subject');
is( $rec->folder, 'isspam',                   'Correct folder' );
is( $rec->size, 1857, 'Correct size' );

