#!/usr/bin/perl
package MyApp::Logger::Logger;

use strict;
use warnings;

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