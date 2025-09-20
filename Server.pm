package Server;

use strict;
use warnings;

use lib '.';

require Database;

sub health_check {
    my ($logger) = @_;
    

    # Validate logger dependency
    unless ($logger && $logger->isa('Logger')) {
        die "Logger instance is required";
    }

    # Perform health check logic
    eval {
        Database::validate_connection($logger);
    };
    if ($@) {
        $logger->error("Health check failed: $@");
        return 0;
    }

    $logger->info("Health check passed");
    return 1;
}

1; #Ends with a true value to determine correct module loading.