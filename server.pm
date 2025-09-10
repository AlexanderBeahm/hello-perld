package server;

use strict;
use warnings;
use HTTP::Daemon;
use HTTP::Status;
use XML::Hash;

use lib '.';

require database;
require plexclient;

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
                my $accountData = plexclient::get_account_info();
                $client_conn->send_response(HTTP::Response->new("200", undef, [ 'Content-Type' => 'application/json' ], $accountData));

            } 
            elsif ($request->method eq 'GET' && $request->uri->path eq '/refresh') {
                # Trigger the refresh operation
                plexclient::refresh_library(1);
                $client_conn->send_response(HTTP::Response->new("200", undef, [ 'Content-Type' => 'text/plain' ], "Refresh triggered successfully."));
            }
            elsif ($request->method eq 'GET' && $request->uri->path eq '/playlists') {
                # Fetch the playlists
                my $playlists = plexclient::list_playlists();


                # TODO: Gotta fix up this so that it works with the new JSON structure
                # Transform the playlists into the desired JSON structure
                my @processed_playlists;
                for my $playlist (%$playlists) {
                    # Assuming $playlist is a hash reference
                    push @processed_playlists, { id => $playlist->{'id'}, title => $playlist->{'title'} };
                }

                # Convert the processed playlists to JSON
                use JSON;
                my $json_response = encode_json(\@processed_playlists);

                # Send the JSON response
                $client_conn->send_response(HTTP::Response->new("200", undef, [ 'Content-Type' => 'application/json' ], $json_response));
            }
            elsif ($request->method eq 'GET' && $request->uri->path =~ m{^/playlists/(\d+)$}) {
                my $playlist_id = $1;
                my $playlist_contents = plexclient::get_playlist_contents($playlist_id);
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