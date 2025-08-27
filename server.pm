package server;

use strict;
use warnings;
use HTTP::Daemon;
use HTTP::Status;

use lib '.';

require database;

sub run{
    # Create a new HTTP::Daemon on port 8080
    my $d = HTTP::Daemon->new(
        LocalPort => 8080,
        ReuseAddr => 1,
    ) or die "Failed to start HTTP Daemon: $!";

    print "Server running at: <URL: ", $d->url, ">\n";

    # Loop to handle incoming requests
    while (my $client_conn = $d->accept) {
        while (my $request = $client_conn->get_request) {
            # Serve only GET requests
            if ($request->method eq 'GET' && $request->uri->path eq '/health') {
                # Send an HTTP 200 OK response
                $client_conn->send_response(HTTP::Response->new("200", undef, [ 'Content-Type' => 'text/plain' ], 'OK'));
                database::validate_connection();
            } else {
                # Respond with HTTP 404 Not Found for unsupported requests
                $client_conn->send_error(RC_NOT_FOUND);
            }
        }
        $client_conn->close;
        undef($client_conn);
    }
}

1; #Ends with a true value to determine correct module loading.