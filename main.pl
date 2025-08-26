#!/usr/bin/env perl
# Above line is to denote that this can be run from command line when set as executable.

# Set up simple barriers to messing yrself over.
use strict;
use warnings;
use 5.042_000;

# Include the current directory in @INC for module searching.
use lib '.';

require server;

my $greeting = "Hello, perld!";

print "\nFirst printing scalars in all main variable types...\n";

print "$greeting";

my @list = ("Hello", ",", " ", "perld", "!");

print "\n...then printing an array in all main variable types...\n";

foreach (@list) {
    print "$_";
}

my %hash = (
    "greeting" => "Hello, ",
    "target" => "perld!"
);

print "\n...and then finally printing hash in all main variable types.\n";

print "$hash{greeting}$hash{target}";

print "\nNow running server...\n";

eval {
    server::run();
};
if ($@) {
    print "An error occurred while running the server: $@";
}

print "\nServer stopped.\n";
