#!/usr/bin/perl
package HelloPerld::Logger::ConsoleLogger;

use strict;
use warnings;
use lib '.';
use parent 'HelloPerld::Logger::Logger';


# Enable autoflush for immediate output in Docker
$| = 1;  # STDOUT autoflush
select STDERR; $| = 1; select STDOUT;  # STDERR autoflush

# Concrete implementation of Logger that outputs to STDOUT/STDERR
sub new {
    my $class = shift;
    my $self = bless {}, $class;
    return $self;
}

sub log {
    my ($self, $level, $message) = @_;
    
    my $timestamp = $self->_get_timestamp();
    my $formatted_message = "[$timestamp] [$level] $message\n";
    
    if ($level eq 'ERROR' || $level eq 'WARN') {
        print STDERR $formatted_message;
    } else {
        print STDOUT $formatted_message;
    }
}

1;