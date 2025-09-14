#!/usr/bin/env perl
# Above line is to denote that this can be run from command line when set as executable.

# Set up simple barriers to messing yrself over.
use strict;
use warnings;

# Include the current directory in @INC for module searching.
use lib '.';

require Server;
require LoggerFactory;

use Mojolicious::Lite;

my $logger = LoggerFactory->create_default_logger();

# Mojolicious Lite
plugin 'SwaggerUI' => {
    route => app()->routes()->any('/swagger'),
    url => '/swagger.json'
};

# Serve the swagger.json file from the swagger directory
get '/swagger.json' => sub {
    my $c = shift;
    $c->reply->file('swagger/swagger.json');
};

get '/health' => sub {
    my $c = shift;

    # Call the health check method from the Server module
    if (Server::health_check($logger)) {
        $c->render(json => {status => 'ok'});
    } else {
        $c->render(json => {status => 'error'}, status => 500);
    }
};

app->start;