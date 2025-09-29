package HelloPerld::Database::Postgres;

use strict;
use warnings;

our $VERSION = '1.0.0';

use DBI;

sub validate_connection {
    my ($logger) = @_;

    my $dbname = $ENV{'POSTGRES_DB'};
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

__END__

=head1 NAME

HelloPerld::Database::Postgres - PostgreSQL database utilities

=head1 SYNOPSIS

    use HelloPerld::Database::Postgres;

    my $logger = HelloPerld::Logger::ConsoleLogger->new();
    HelloPerld::Database::Postgres::validate_connection($logger);

=head1 DESCRIPTION

Provides PostgreSQL database connectivity validation and utility functions.
Handles database connection testing and error reporting through the logging
system.

=head1 FUNCTIONS

=head2 validate_connection

    HelloPerld::Database::Postgres::validate_connection($logger);

Validates that a connection can be established to the PostgreSQL database
using environment variables for configuration. Dies on connection failure.
Logs connection status information.

=head1 AUTHOR

Alex Beahm <alexanderbeahm@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2024 Alex Beahm

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut