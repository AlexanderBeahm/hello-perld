# Makefile.PL

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'MyApp',
    VERSION_FROM => 'main.pl', # Finds $VERSION
    PREREQ_PM    => {
        'HTTP::Daemon'        => 0,
        'HTTP::Status'        => 0,
        'DBD::Pg'             => 0,
    },
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'main.pl', # retrieve abstract from module
       AUTHOR        => 'Alex Beahm <alexanderbeahm@gmail.com>') : ()),
);