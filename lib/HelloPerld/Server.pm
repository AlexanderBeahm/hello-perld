package HelloPerld::Server;

use strict;
use warnings;

use lib '.';

require HelloPerld::Database::Postgres;
require HelloPerld::Logger::Logger;

sub health_check {
    my ($logger) = @_;
    

    # Validate logger dependency
    unless ($logger && $logger->isa('HelloPerld::Logger::Logger')) {
        die "Logger instance is required";
    }

    # Perform health check logic
    eval {
        HelloPerld::Database::Postgres::validate_connection($logger);
    };
    if ($@) {
        $logger->error("Health check failed: $@");
        return 0;
    }

    $logger->info("Health check passed");
    return 1;
}

1; #Ends with a true value to determine correct module loading.