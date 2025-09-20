package MyApp::Controller::Health;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use lib '.';
require Server;

sub getHealthStatus ($self) {
    if (Server::health_check($self->app->logger_instance)) {
        $self->render(openapi => { status => 'healthy' });
    } else {
        $self->render(openapi => { status => 'unhealthy' }, status => 503);
    }
}

1;