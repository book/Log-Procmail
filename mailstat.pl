#!/usr/bin/perl -w
use strict;
use Log::Procmail;
use Getopt::Std;
use POSIX qw( strftime );
use vars qw/ %opt /;

%opt = (
    oldsuffix => '.old',
);

=head1 NAME

mailstat.pl - shows mail-arrival statistics

=head1 SYNOPSIS

mailstat [-klmots] [logfile]

=head1 DESCRIPTION

B<mailstat.pl> example program using Log::Procmail to mimic mailstat(1)

mailstat parses a procmail-generated $LOGFILE and displays a summary about
the messages delivered to all folders (total size, average size,
nr of messages). The $LOGFILE is truncated to zero length, unless the
I<-k> option is used. Exit code 0 if mail arrived, 1 if no mail arrived.

=head1 OPTIONS

=over 4

=item I<-k>

keep logfile intact

=item I<-l>

long display format

=item I<-m>

merge any errors into one line

=item I<-o>

use the old logfile

=item I<-t>

terse display format

=item I<-s>

silent in case of no mail

=back

=cut

getopts( '?hklmots', \%opt ) or usage();

# -h or -?
usage(1) if $opt{h} or $opt{'?'};

# the filename
my $logfile = shift || '';
my $oldlogfile;

# if the file is the old file
if ( $logfile =~ /$opt{oldsuffix}$/o ) {
    $opt{k} = 1;
    $oldlogfile = $logfile;
}
else { $oldlogfile = $logfile . $opt{oldsuffix} }

# -o      use the old logfile
$logfile = $oldlogfile if $opt{o};

if ( $logfile ne '-' and $logfile ne '' ) {
    if ( -z $logfile ) {
        if ( !$opt{s} ) {
            if ( -f $logfile ) {
                print 'No mail arrived since ', strftime( "%b %d %H:%M\n",
                    localtime( ( stat($logfile) )[9] ) );
            }
            else { print "Can't find your LOGFILE=$logfile"; }
        }
        exit 1;
    }
}
else {
    if ( $logfile ne '-' and -t ) {
        print STDERR
          "Most people don't type their own logfiles;  but, what do I care?\n";
        $opt{t} = 1;
    }
    $opt{k} = 1;
    $logfile = '';
}

# -k      keep logfile intact
if ( !$opt{k} ) {
    rename $logfile, $oldlogfile;
    open F, ">> $logfile" or die "Unable to open $logfile: $!";
    print F '';
    close F;
}
else { $oldlogfile = $logfile }

# -l      long display format
# -m      merge any errors into one line
# -t      terse display format
# -s      silent in case of no mail

# the usage function
sub usage {
    print STDERR "Usage: mailstat [-klmots] [logfile]\n";
    if (shift) {
        print STDERR << 'USAGE';
     -k      keep logfile intact
     -l      long display format
     -m      merge any errors into one line
     -o      use the old logfile
     -t      terse display format
     -s      silent in case of no mail
USAGE
    }
    exit 64;
}

=head1 NOTES

Customise to your heart's content, this program is only provided
as a guideline.

=head1 AUTHOR

This program was written by Philippe 'BooK' Bruhat as an example of
use for Log::Procmail.

The original mailstat(1) was created by S.R. van den Berg,
The Netherlands.

The original manual page was written by Santiago Vila
<sanvila@debian.org> for the Debian GNU/Linux distribution
(but may be used by others).

=head1 COPYRIGHT

Copyright (c) 2002, Philippe Bruhat. All Rights Reserved.
This module is free software. It may be used, redistributed
and/or modified under the terms of the Perl Artistic License
(see http://www.perl.com/perl/misc/Artistic.html)

=head1 SEE ALSO

L<perl>, L<Log::Procmail>.

=cut

