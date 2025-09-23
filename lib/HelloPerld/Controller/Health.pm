package HelloPerld::Controller::Health;

use strict;
use warnings;

our $VERSION = '1.0.0';

use Mojo::Base 'Mojolicious::Controller', -signatures;
use HelloPerld::Server;

sub getHealthStatus ($self) {
    if (HelloPerld::Server::health_check($self->app->logger_instance)) {
        $self->render(openapi => { status => 'healthy' });
    } else {
        $self->render(openapi => { status => 'unhealthy' }, status => 503);
    }
}

1;

__END__

=head1 NAME

HelloPerld::Controller::Health - Health check endpoint controller

=head1 SYNOPSIS

    # Used automatically by Mojolicious routing
    # GET /health endpoint

=head1 DESCRIPTION

Mojolicious controller that provides health check endpoints for monitoring
the application status. Integrates with the server health check functionality
to provide detailed system status information.

=head1 METHODS

=head2 getHealthStatus

    $self->getHealthStatus();

Endpoint handler for GET /health requests. Performs comprehensive health
checks including database connectivity and returns appropriate HTTP status
and JSON response indicating system health.

=head1 AUTHOR

Alex Beahm <alexanderbeahm@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2024 Alex Beahm

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut