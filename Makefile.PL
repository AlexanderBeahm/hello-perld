# Makefile.PL

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'hello-perld',
    VERSION_FROM => 'main.pl', # Finds $VERSION
    PREREQ_PM    => {
        'HTTP::Status'        => 0,
        'HTTP::Daemon'        => 0,
        'DBD::Pg'             => 0,
    },
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'main.pl', # retrieve abstract from module
       AUTHOR        => 'Alex Beahm <alexanderbeahm@gmail.com>') : ()),
);