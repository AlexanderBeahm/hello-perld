package HelloPerld::Controller::Health;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use lib '.';
require HelloPerld::Server;

sub getHealthStatus ($self) {
    if (HelloPerld::Server::health_check($self->app->logger_instance)) {
        $self->render(openapi => { status => 'healthy' });
    } else {
        $self->render(openapi => { status => 'unhealthy' }, status => 503);
    }
}

1;