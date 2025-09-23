package HelloPerld::Logger::Logger;

use strict;
use warnings;

our $VERSION = '1.0.0';

# Abstract interface for logging - implements dependency inversion principle
sub new {
    my $class = shift;
    die "Cannot instantiate abstract Logger class";
}

sub log {
    my ($self, $level, $message) = @_;
    die "log method must be implemented by concrete logger class";
}

sub debug {
    my ($self, $message) = @_;
    $self->log('DEBUG', $message);
}

sub info {
    my ($self, $message) = @_;
    $self->log('INFO', $message);
}

sub warn {
    my ($self, $message) = @_;
    $self->log('WARN', $message);
}

sub error {
    my ($self, $message) = @_;
    $self->log('ERROR', $message);
}

sub log_http_request {
    my ($self, $method, $uri, $client_addr) = @_;
    my $timestamp = $self->_get_timestamp();
    $self->info("[$timestamp] HTTP Request: $method $uri from $client_addr");
}

sub log_http_response {
    my ($self, $status_code, $method, $uri) = @_;
    my $timestamp = $self->_get_timestamp();
    $self->info("[$timestamp] HTTP Response: $status_code for $method $uri");
}

sub _get_timestamp {
    my ($sec, $min, $hour, $mday, $mon, $year) = localtime(time);
    return sprintf("%04d-%02d-%02d %02d:%02d:%02d", 
                   $year + 1900, $mon + 1, $mday, $hour, $min, $sec);
}

1;

__END__

=head1 NAME

HelloPerld::Logger::Logger - Abstract base class for logging implementations

=head1 SYNOPSIS

    package HelloPerld::Logger::MyLogger;
    use parent 'HelloPerld::Logger::Logger';

    sub new {
        my ($class, %opts) = @_;
        return bless \%opts, $class;
    }

    sub log {
        my ($self, $level, $message) = @_;
        # Implement logging logic here
    }

=head1 DESCRIPTION

This abstract base class defines the interface for all logger implementations
in the HelloPerld application. It implements the dependency inversion principle
by providing a common interface that concrete logger classes must implement.

=head1 METHODS

=head2 new

    my $logger = HelloPerld::Logger::Logger->new();

Constructor. Dies when called directly on the abstract class.

=head2 log

    $logger->log($level, $message);

Abstract method that must be implemented by concrete logger classes.

=head2 debug

    $logger->debug($message);

Logs a debug-level message.

=head2 info

    $logger->info($message);

Logs an info-level message.

=head2 warn

    $logger->warn($message);

Logs a warning-level message.

=head2 error

    $logger->error($message);

Logs an error-level message.

=head2 log_http_request

    $logger->log_http_request($method, $uri, $client_addr);

Logs HTTP request information.

=head2 log_http_response

    $logger->log_http_response($status_code, $method, $uri);

Logs HTTP response information.

=head1 AUTHOR

Alex Beahm <alexanderbeahm@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2024 Alex Beahm

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut