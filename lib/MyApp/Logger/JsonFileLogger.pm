#!/usr/bin/perl
package MyApp::Logger::JsonFileLogger;

use strict;
use warnings;
use lib '.';
use parent 'MyApp::Logger::Logger';
use JSON;

# Concrete implementation of Logger that outputs to JSON file (for ELK stack integration)
sub new {
    my ($class, %opts) = @_;
    
    my $self = bless {
        log_file => $opts{log_file} || 'application.log',
    }, $class;
    
    return $self;
}

sub log {
    my ($self, $level, $message) = @_;
    
    eval {
        my $log_entry = {
            timestamp => $self->_get_timestamp(),
            level => $level,
            message => $message,
            service => 'hello-perld'
        };
        
        my $json_line = encode_json($log_entry) . "\n";
        
        open my $fh, '>>', $self->{log_file} or die "Cannot open log file: $!";
        print $fh $json_line;
        close $fh;
    };
    
    if ($@) {
        # Fallback to STDERR if file logging fails
        print STDERR "File logging failed: $@\n";
        my $timestamp = $self->_get_timestamp();
        print STDERR "[$timestamp] [$level] $message\n";
    }
}

1;