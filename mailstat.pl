#!/usr/bin/perl -w
use strict;
use Log::Procmail;
use Getopt::Std;
use vars qw/ %opt /;

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

getopts( 'hklmots', \%opt );


# usage
if( $opt{h} ) {
    ( my $usage =<< '    USAGE' ) =~ s/^    //gm;
    Usage: mailstat [-klmots] [logfile]
         -k      keep logfile intact
         -l      long display format
         -m      merge any errors into one line
         -o      use the old logfile
         -t      terse display format
         -s      silent in case of no mail
    USAGE
    print STDERR $usage;
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
