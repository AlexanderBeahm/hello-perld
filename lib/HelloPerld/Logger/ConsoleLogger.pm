package HelloPerld::Logger::ConsoleLogger;

use strict;
use warnings;

our $VERSION = '1.0.0';

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

__END__

=head1 NAME

HelloPerld::Logger::ConsoleLogger - Console-based logging implementation

=head1 SYNOPSIS

    use HelloPerld::Logger::ConsoleLogger;

    my $logger = HelloPerld::Logger::ConsoleLogger->new();
    $logger->info("This is an info message");
    $logger->error("This is an error message");

=head1 DESCRIPTION

A concrete implementation of HelloPerld::Logger::Logger that outputs log
messages to the console (STDOUT/STDERR). This logger is particularly useful
for development environments and containers where log output needs to be
captured by the container runtime.

The logger automatically enables autoflush for immediate output, which is
essential for proper logging in Docker containers.

=head1 METHODS

=head2 new

    my $logger = HelloPerld::Logger::ConsoleLogger->new();

Creates a new console logger instance.

=head2 log

    $logger->log($level, $message);

Outputs the log message to console with timestamp and level information.
Error-level messages are sent to STDERR, while all other levels go to STDOUT.

=head1 AUTHOR

Alex Beahm <alexanderbeahm@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2024 Alex Beahm

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut