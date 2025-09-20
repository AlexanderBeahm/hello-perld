package MyApp;
use Mojo::Base 'Mojolicious';

use lib '.';
require LoggerFactory;

sub startup {
    my $self = shift;

    # Initialize logger
    $self->helper(logger_instance => sub {
        state $logger = LoggerFactory->create_default_logger();
        return $logger;
    });

    # Configure OpenAPI plugin
    $self->plugin('OpenAPI' => {
        url => '/usr/src/myapp/swagger/swagger.json'
    });

    # Configure SwaggerUI plugin
    $self->plugin('SwaggerUI' => {
        route => $self->routes->any('/swagger'),
        url => '/swagger.json'
    });

    # Serve the swagger.json file
    $self->routes->get('/swagger.json')->to(cb => sub {
        my $c = shift;
        $c->reply->file('/usr/src/myapp/swagger/swagger.json');
    });



    # Log startup
    $self->logger_instance->info("MyApp web application started!");
}

1;