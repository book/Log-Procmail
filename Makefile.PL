use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'         => 'Log::Procmail',
    'VERSION_FROM' => 'Procmail.pm', # finds $VERSION
    'PREREQ_PM'    => { Test::More => 0 },
    'EXE_FILES'    => [ 'mailstat.pl' ],
    'AUTHOR'       => 'Philippe "BooK" Bruhat <book@cpan.org>',
);
