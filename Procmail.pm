package Log::Procmail;

require 5.6.0;
use strict;
use warnings;

our $VERSION = '0.01';

=head1 NAME

Log::Procmail - Perl extension for reading procmail logiles.

=head1 SYNOPSIS

 use Log::Procmail;

 my $log = new Log::Procmail 'procmail.log';

 # loop on every abstract
 while(my $rec = $log->next) {
     # do something with $rec->folder, $rec->size, etc.
 }

=head1 DESCRIPTION

Log::Procmail reads procmail(1) logfiles and return the abstracts one by one.

=cut

use IO::File;
use Carp;

=over 4

=item $log = Log::Procmail->new( @files );

Constructor for the procmail log reader.  Returns a reference to a
Log::Procmail object.

The constructor accepts a list of file as parameter. This allows you to
read records from several files in a row:

 $log = Log::Procmail->new( "$ENV{HOME}/.procmail/log.2",
                            "$ENV{HOME}/.procmail/log.1",
                            "$ENV{HOME}/.procmail/log", );

When $log reaches the end of the file "log", it doesn't close the file.
So, after B<procmail> processes some incoming mail, the next call to next()
will return the new records.

=cut

sub new {
    my $class = shift;
    return bless {
        fh    => new IO::File,
        files => [@_],
    }, $class;
}

=item $rec = $log->next

Return a Log::Procmail::Abstract object that represent an entry in the log
file. Return undef if there is no record left in the file.

When the Log::Procmail object reaches the end of a file, and this file is
not the last of the stack, it closes the current file and opens the next
one.

When it reaches the end of the last file, the file is not closed. Next
time the record method is called, it will check again in case new abstracts
were appended.

Procmail(1) log look like the following:

 From karen644552@btinternet.com  Fri Feb  8 20:37:24 2002
  Subject: Stock Market Volatility Beating You Up? (18@2)
   Folder: /var/spool/mail/book						   2840

=cut

sub next {
    my $log = shift;        # who needs $self?
    my $fh  = $log->{fh};

    # open the file if necessary
    unless ( $fh->opened ) {
        if ( @{ $log->{files} } ) {
            my $file = shift @{ $log->{files} };
            $fh->open($file) or carp "Can't open $file: $!";
        }
        else { return }
    }

    # try to read a record (3 lines)
    my $rec = Log::Procmail::Abstract->new;
    my $read;
    READ: {
        while (<$fh>) {
            /^procmail: / && next;           # ignore debug comments
            $read++;
            # should carp if doesn't get what's expected
            # (From, then Subject, then Folder)
            /^From\s+(\S+)\s+(.*)/     && do {
                # assert: $read == 1;
                $rec->from( $1 );
                $rec->date( $2 );
            };
            # assert: $read == 2;
            /^ Subject: (.*)/          && do { $rec->subject($1) };
            /^  Folder: (\S+)\s+(\d+)/ && do {
                # assert: $read == 3;
                $rec->folder($1);
                $rec->size($2);
                last;
            };
        }
        # in case we couldn't read a line
        if(!$read) {
            # go to next file
            if( @{ $log->{files} } ) {
                $fh->close;
                my $file = shift @{ $log->{files} };
                $fh->open( $file ) or carp "Can't open $file: $!";
                redo READ;
            }
            # unless it's the last one
            else { return }
        }
    }
    return $rec;
}

=item $log->push( $file [, $file2 ...] );

Push one or more files on top of the list of log files to examine.
When Log::Procmail runs out of abstracts to return (i.e. it reaches the
end of the file), it transparently opens the next file (if there is one)
and keeps returning abstracts.

=cut

sub push {
    my $log = shift;
    push @{ $log->{files} }, @_;
}

sub DESTROY {
    my $self = shift;
    if( $self->{fh}->opened ) { $self->{fh}->close }
}

=back

=head2 Log::Procmail::Abstract

Log::Procmail::Abstract is a class that hold the abstract information.
Since the abstract hold From, Date, Subject, Folder and Size information,
all this can be accessed and modified through the from(), date(), subject(),
folder() and size() methods.

Log::Procmail::next() returns a Log::Procmail::Abstract object.

=cut

package Log::Procmail::Abstract;

use vars '$AUTOLOAD';

sub new {
    my $class = shift;
    return bless {@_}, $class;
}

=over 4

=item Log::Procmail::Abstract accessors

The Log::Procmail::Abstract object accessors are named from(), date(),
subject(), folder() and size(). They return the relevant information
when called without argument, and set it to their first argument
otherwise.

 # count mail received per folder
 while( $rec = $log->next ) { $folder{ $rec->folder }++ }

=cut

sub AUTOLOAD {

    # don't DESTROY
    return if $AUTOLOAD =~ /::DESTROY/;

    # fetch the attribute name
    $AUTOLOAD =~ /.*::(\w+)/;
    my $attr = $1;
    if ( $attr eq lc $attr ) {    # accessors are lowercase
        no strict 'refs';
        # create the method
        *{$AUTOLOAD} = sub {
            my $self = shift;
            @_ ? $self->{$attr} = shift: $self->{$attr};
        };

        # now do it
        goto &{$AUTOLOAD};
    }
}

=back

=head1 BUGS

Please report all bugs through the rt.cpan.org interface:

http://rt.cpan.org/NoAuth/Bugs.html?Dist=Log-Procmail

=head1 AUTHOR

Philippe "BooK" Bruhat <book@cpan.org>.

Thanks to Briac "Oeufmayo" Pilpré and David "Sniper" Rigaudiere for early
comments on irc. Thanks to Michael Schwern for insisting so much on the
importance of tests and documentation.

=head1 COPYRIGHT 

Copyright (c) 2002, Philippe Bruhat. All Rights Reserved.
This module is free software. It may be used, redistributed
and/or modified under the terms of the Perl Artistic License
(see http://www.perl.com/perl/misc/Artistic.html)

=head1 SEE ALSO

perl(1), procmail(1).

=cut

1;
