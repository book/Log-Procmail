use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Log::Procmail',
    license             => 'perl',
    dist_author         => 'Philippe "BooK" Bruhat <book@cpan.org>',
    dist_version_from   => 'lib/Log/Procmail.pm',
    requires => {
        'Test::More' => 0,
    },
    add_to_cleanup      => [ 'Log-Procmail-*' ],
    script_files        => [ 'scripts/mailstat.pl' ],
);

$builder->create_build_script();
