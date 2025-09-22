package HelloPerld;
use Mojo::Base 'Mojolicious';

use lib '.';
require HelloPerld::Logger::LoggerFactory;

sub startup {
    my $self = shift;

    # Initialize logger
    $self->helper(logger_instance => sub {
        state $logger = HelloPerld::Logger::LoggerFactory->create_default_logger();
        return $logger;
    });

    # Configure template path
    $self->renderer->paths->[0] = '/usr/src/helloperld/lib/HelloPerld/Templates';

    # Define custom routes BEFORE OpenAPI plugin
    $self->routes->get('/')->to(cb => sub {
        my $c = shift;
        $c->render(template => 'index');
    });

    # Configure OpenAPI plugin
    $self->plugin('OpenAPI' => {
        url => '/usr/src/helloperld/swagger/swagger.json'
    });

    # Configure SwaggerUI plugin
    $self->plugin('SwaggerUI' => {
        route => $self->routes->any('/swagger'),
        url => '/swagger.json'
    });

    # Serve the swagger.json file
    $self->routes->get('/swagger.json')->to(cb => sub {
        my $c = shift;
        $c->reply->file('/usr/src/helloperld/swagger/swagger.json');
    });

    # Log startup
    $self->logger_instance->info("HelloPerld web application started! Hello, perld!");
}

1;