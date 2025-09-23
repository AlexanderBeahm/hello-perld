package HelloPerld::Server;

use strict;
use warnings;

our $VERSION = '1.0.0';

use HelloPerld::Database::Postgres;
use HelloPerld::Logger::Logger;

sub health_check {
    my ($logger) = @_;
    

    # Validate logger dependency
    unless ($logger && $logger->isa('HelloPerld::Logger::Logger')) {
        die "Logger instance is required";
    }

    # Perform health check logic
    eval {
        HelloPerld::Database::Postgres::validate_connection($logger);
    };
    if ($@) {
        $logger->error("Health check failed: $@");
        return 0;
    }

    $logger->info("Health check passed");
    return 1;
}

1;

__END__

=head1 NAME

HelloPerld::Server - Server utilities and health check functionality

=head1 SYNOPSIS

    use HelloPerld::Server;

    my $logger = HelloPerld::Logger::ConsoleLogger->new();
    my $is_healthy = HelloPerld::Server::health_check($logger);

=head1 DESCRIPTION

Provides server-related utility functions including health check capabilities
that validate database connectivity and other system dependencies.

=head1 FUNCTIONS

=head2 health_check

    my $is_healthy = HelloPerld::Server::health_check($logger);

Performs a comprehensive health check of the system including database
connectivity. Returns true if all checks pass, false otherwise.
Logs detailed information about the health check process.

=head1 AUTHOR

Alex Beahm <alexanderbeahm@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2024 Alex Beahm

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut