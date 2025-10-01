package HelloPerld;
use Mojo::Base 'Mojolicious';

our $VERSION = '1.0.0';

use HelloPerld::Logger::LoggerFactory;

sub startup {
    my $self = shift;

    # Initialize logger
    $self->helper(logger_instance => sub {
        state $logger = HelloPerld::Logger::LoggerFactory->create_default_logger();
        return $logger;
    });

    # Configure template path
    $self->renderer->paths->[0] = 'lib/HelloPerld/Templates';

    # Configure static file serving
    push @{$self->static->paths}, 'lib/HelloPerld/Public';

    # Use a hook to handle static files before any routing/plugin processing
    $self->hook(before_dispatch => sub {
        my $c = shift;
        my $path = $c->req->url->path->to_string;

        # Check if this is a static file request
        if ($path =~ /\.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot|pdf)$/i) {
            my $file = substr($path, 1); # Remove leading slash

            # Prevent directory traversal attacks
            if ($file =~ /\.\./ || $file =~ /^\//) {
                return;
            }

            if ($c->reply->static($file)) {
                $c->rendered; # Mark as rendered to prevent further processing
            }
        }
    });

    # Define custom routes BEFORE OpenAPI plugin
    $self->routes->get('/')->to(cb => sub {
        my $c = shift;
        $c->render(template => 'index');
    });

    # Configure OpenAPI plugin
    $self->plugin('OpenAPI' => {
        url => $self->home->rel_file('swagger/swagger.json')
    });

    # Configure SwaggerUI plugin
    $self->plugin('SwaggerUI' => {
        route => $self->routes->any('/swagger'),
        url => '/swagger.json',
        favicon => '/helloperld.ico'
    });

    # Serve the swagger.json file
    $self->routes->get('/swagger.json')->to(cb => sub {
        my $c = shift;
        $c->reply->file($c->app->home->rel_file('swagger/swagger.json'));
    });

    # Log startup
    $self->logger_instance->info("HelloPerld web application started! Hello, perld!");
}

1;

__END__

=head1 NAME

HelloPerld - A Mojolicious web application with structured logging

=head1 SYNOPSIS

    use HelloPerld;

    # Start the application
    my $app = HelloPerld->new;
    $app->start;

=head1 DESCRIPTION

HelloPerld is a Mojolicious-based web application that demonstrates best practices
for Perl web development including structured logging, database connectivity,
and OpenAPI/Swagger documentation.

The application provides:
- RESTful API endpoints with OpenAPI specification
- Multiple logging backends (Console, Database, JSON file)
- Health check endpoints for monitoring
- Swagger UI for API documentation

=head1 METHODS

=head2 startup

Initializes the application, configures routes, plugins, and logging.

=head1 AUTHOR

Alex Beahm <alexanderbeahm@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2024 Alex Beahm

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut