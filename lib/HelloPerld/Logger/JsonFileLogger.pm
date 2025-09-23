package HelloPerld::Logger::JsonFileLogger;

use strict;
use warnings;

our $VERSION = '1.0.0';

use JSON;
use parent 'HelloPerld::Logger::Logger';

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

__END__

=head1 NAME

HelloPerld::Logger::JsonFileLogger - JSON file-based logging implementation

=head1 SYNOPSIS

    use HelloPerld::Logger::JsonFileLogger;

    my $logger = HelloPerld::Logger::JsonFileLogger->new(
        filename => '/var/log/app.json'
    );
    $logger->info("JSON log entry created");

=head1 DESCRIPTION

A concrete implementation of HelloPerld::Logger::Logger that outputs log
messages to a JSON file. This logger is designed for integration with
log processing systems like the ELK stack (Elasticsearch, Logstash, Kibana)
that can parse structured JSON log data.

=head1 METHODS

=head2 new

    my $logger = HelloPerld::Logger::JsonFileLogger->new(%opts);

Creates a new JSON file logger instance. Accepts filename parameter.

=head2 log

    $logger->log($level, $message);

Appends a JSON-formatted log entry to the specified file with timestamp,
level, and message information.

=head1 AUTHOR

Alex Beahm <alexanderbeahm@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2024 Alex Beahm

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut