package server;

use strict;
use warnings;
use HTTP::Daemon;
use HTTP::Status;
use XML::Hash;

use lib '.';

require database;
require plextransform;

sub run{
    # Create a new HTTP::Daemon on port 8080
    my $d = HTTP::Daemon->new(
        LocalPort => 8080,
        ReuseAddr => 1,
    ) or die "Failed to start HTTP Daemon: $!";

    print "Server running at: <URL: ", $d->url, ">\n";
    my $xmlHandler = XML::Hash->new();

    # Loop to handle incoming requests
    while (my $client_conn = $d->accept) {
        while (my $request = $client_conn->get_request) {
            eval {
            # Serve only GET requests
            if ($request->method eq 'GET' && $request->uri->path eq '/health') {
                # Send an HTTP 200 OK response
                database::validate_connection();
                my $health_response = plextransform::handle_health();
                $client_conn->send_response(HTTP::Response->new("200", undef, [ 'Content-Type' => 'application/json' ], $health_response));

            } 
            elsif ($request->method eq 'GET' && $request->uri->path eq '/refresh') {
                my $result = plextransform::handle_refresh();
                $client_conn->send_response(HTTP::Response->new("200", undef, [ 'Content-Type' => 'text/plain' ], $result));
            }
            elsif ($request->method eq 'GET' && $request->uri->path eq '/playlists') {
                my $json_response = plextransform::handle_playlists();
                $client_conn->send_response(HTTP::Response->new("200", undef, [ 'Content-Type' => 'application/json' ], $json_response));
            }
            elsif ($request->method eq 'GET' && $request->uri->path =~ m{^/playlists/(\d+)$}) {
                my $playlist_id = $1;
                my $playlist_contents = plextransform::handle_playlist_contents($playlist_id);
                $client_conn->send_response(HTTP::Response->new("200", undef, [ 'Content-Type' => 'application/json' ], $playlist_contents));
            }
            else {
                # Respond with HTTP 404 Not Found for unsupported requests
                $client_conn->send_error(RC_NOT_FOUND);
            }
            };
            if ($@) {
                warn "Error processing request: $@";
                $client_conn->send_error(RC_INTERNAL_SERVER_ERROR, "Internal Server Error");
            }
        };
        $client_conn->close;
        undef($client_conn);
    }
}

1; #Ends with a true value to determine correct module loading.