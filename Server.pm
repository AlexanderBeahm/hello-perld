package Server;

use strict;
use warnings;
use HTTP::Daemon;
use HTTP::Status;

use lib '.';

require Database;

sub run {
    my ($logger) = @_;
    
    # Validate logger dependency
    unless ($logger && $logger->isa('Logger')) {
        die "Logger instance is required";
    }
    
    # Create a new HTTP::Daemon on port 8080
    my $d = HTTP::Daemon->new(
        LocalPort => 8080,
        ReuseAddr => 1,
    ) or do {
        $logger->error("Failed to start HTTP Daemon: $!");
        die "Failed to start HTTP Daemon: $!";
    };

    $logger->info("Server running at: " . $d->url);

    # Loop to handle incoming requests
    while (my $client_conn = $d->accept) {
        my $client_addr = $client_conn->peerhost();
        
        while (my $request = $client_conn->get_request) {
            eval {
                # Log incoming HTTP request
                $logger->log_http_request($request->method, $request->uri->path, $client_addr);
                
                # Serve only GET requests
                if ($request->method eq 'GET' && $request->uri->path eq '/health') {
                    # Send an HTTP 200 OK response
                    my $response = HTTP::Response->new("200", undef, [ 'Content-Type' => 'text/plain' ], 'OK');
                    $client_conn->send_response($response);
                    
                    # Log HTTP response
                    $logger->log_http_response(200, $request->method, $request->uri->path);
                    
                    # Validate database connection with logging
                    eval {
                        Database::validate_connection($logger);
                    };
                    if ($@) {
                        $logger->error("Database validation failed: $@");
                    }
                } else {
                    # Respond with HTTP 404 Not Found for unsupported requests
                    $client_conn->send_error(RC_NOT_FOUND);
                    $logger->log_http_response(404, $request->method, $request->uri->path);
                }
            };
            if ($@) {
                $logger->error("Error processing request: $@");
                eval {
                    $client_conn->send_error(RC_INTERNAL_SERVER_ERROR, "Internal Server Error");
                    $logger->log_http_response(500, $request->method || 'UNKNOWN', $request->uri->path || 'UNKNOWN');
                };
                if ($@) {
                    $logger->error("Error sending error response: $@");
                }
            }
        }
        $client_conn->close;
        undef($client_conn);
    }
}

1; #Ends with a true value to determine correct module loading.