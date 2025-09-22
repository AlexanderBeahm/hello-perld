#!/usr/bin/perl
use strict;
use warnings;

package HelloPerld::Database::Postgres;

use DBI;

sub validate_connection {
    my ($logger) = @_;
    
    my $dbname = 'postgres'; # default postgres database
    my $host = 'db'; # use the service name defined in docker-compose.yml
    my $port = 5432;
    my $user = $ENV{'POSTGRES_USER'}; # fetch from env variables
    my $password = $ENV{'POSTGRES_PASSWORD'}; # fetch from env variables
    
    eval {
        my $dbh = DBI->connect("dbi:Pg:dbname=$dbname;host=$host;port=$port", $user, $password, { RaiseError => 1, AutoCommit => 1 });
        
        if ($dbh) {
            if ($logger) {
                $logger->info("Connected to PostgreSQL database successfully!");
            } else {
                print "Connected to PostgreSQL database successfully!\n";
            }
            $dbh->disconnect;
            return 1;
        }
    };
    
    if ($@) {
        my $error_msg = "Could not connect to PostgreSQL database: $@";
        if ($logger) {
            $logger->error($error_msg);
        } else {
            warn $error_msg;
        }
        return 0;
    }
}

1;