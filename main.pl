#!/usr/bin/env perl
# Above line is to denote that this can be run from command line when set as executable.

# Set up simple barriers to messing yrself over.
use strict;
use warnings;

# Include the current directory in @INC for module searching.
use lib '.';

require Server;
require LoggerFactory;

# Initialize logger with dependency injection using factory pattern
# This allows for easy switching between logger types via environment variables
# Set LOGGER_TYPE=database for database logging
# Set LOGGER_TYPE=jsonfile for JSON file logging (default: console)
my $logger = LoggerFactory->create_default_logger();

$logger->info("Hello, perld!");

$logger->info("Now running server...");

eval {
    Server::run($logger);
};
if ($@) {
    $logger->error("An error occurred while running the server: $@");
}

$logger->info("Server stopped.");
