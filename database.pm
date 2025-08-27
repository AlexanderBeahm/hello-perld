#!/usr/bin/perl
use strict;
use warnings;

package database;

use DBI;

sub validate_connection {
    my $dbname = 'postgres'; # default postgres database
    my $host = 'db'; # use the service name defined in docker-compose.yml
    my $port = 5432;
    my $user = $ENV{'POSTGRES_USER'}; # fetch from env variables
    my $password = $ENV{'POSTGRES_PASSWORD'}; # fetch from env variables
    my $dbh = DBI->connect("dbi:Pg:dbname=$dbname;host=$host;port=$port", $user, $password, { RaiseError => 1, AutoCommit => 1 });

    if ($dbh) {
        print "Connected to PostgreSQL database successfully!\n";
        $dbh->disconnect;
        return 1;
    } else {
        warn "Could not connect to PostgreSQL database: " . $DBI::errstr;
        return 0;
    }
}

1;