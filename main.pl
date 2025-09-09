#!/usr/bin/env perl
# Above line is to denote that this can be run from command line when set as executable.

# Set up simple barriers to messing yrself over.
use strict;
use warnings;

# Include the current directory in @INC for module searching.
use lib '.';

require server;

print "Hello, perld!\n";

print "\nNow running server...\n";

eval {
    server::run();
};
if ($@) {
    print "An error occurred while running the server: $@";
}

print "\nServer stopped.\n";
