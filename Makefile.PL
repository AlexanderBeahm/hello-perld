# Makefile.PL

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'hello-perld',
    VERSION_FROM => 'main.pl', # Finds $VERSION
    PREREQ_PM    => {
        'HTTP::Status'        => 0,
        'HTTP::Daemon'        => 0,
        'DBD::Pg'             => 0,
        'DBI'                 => 0,  # Added for database logging
        'JSON'                => 0,  # Added for JSON file logging
        'Time::Local'         => 0,  # Added for timestamp handling
    },
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM => 'main.pl', # retrieve abstract from module
       AUTHOR        => 'Alex Beahm <alexanderbeahm@gmail.com>') : ()),
);