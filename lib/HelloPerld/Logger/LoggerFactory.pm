package HelloPerld::Logger::LoggerFactory;

use strict;
use warnings;

our $VERSION = '1.0.0';

use HelloPerld::Logger::Logger;
use HelloPerld::Logger::ConsoleLogger;
use HelloPerld::Logger::DatabaseLogger;
use HelloPerld::Logger::JsonFileLogger;

# Factory pattern for creating logger instances - follows dependency injection pattern
sub create_logger {
    my ($class, $type, %opts) = @_;
    
    if ($type eq 'console') {
        return HelloPerld::Logger::ConsoleLogger->new();
    }
    elsif ($type eq 'database') {
        return HelloPerld::Logger::DatabaseLogger->new(%opts);
    }
    elsif ($type eq 'jsonfile') {
        return HelloPerld::Logger::JsonFileLogger->new(%opts);
    }
    else {
        die "Unknown logger type: $type. Available types: console, database, jsonfile";
    }
}

# Get logger based on environment variable or default to console
sub create_default_logger {
    my $class = shift;
    
    my $logger_type = $ENV{'LOGGER_TYPE'} || 'console';
    
    if ($logger_type eq 'database') {
        return $class->create_logger('database');
    }
    elsif ($logger_type eq 'jsonfile') {
        my $log_file = $ENV{'LOG_FILE'} || 'application.log';
        return $class->create_logger('jsonfile', log_file => $log_file);
    }
    else {
        return $class->create_logger('console');
    }
}

1;

__END__

=head1 NAME

HelloPerld::Logger::LoggerFactory - Factory class for creating logger instances

=head1 SYNOPSIS

    use HelloPerld::Logger::LoggerFactory;

    # Create specific logger type
    my $console_logger = HelloPerld::Logger::LoggerFactory->create_logger('console');
    my $db_logger = HelloPerld::Logger::LoggerFactory->create_logger('database',
        host => 'localhost', database => 'logs');

    # Create default logger
    my $default_logger = HelloPerld::Logger::LoggerFactory->create_default_logger();

=head1 DESCRIPTION

Implements the Factory pattern for creating logger instances. This class
follows dependency injection principles by providing a centralized way to
create and configure different types of loggers without tight coupling.

=head1 METHODS

=head2 create_logger

    my $logger = HelloPerld::Logger::LoggerFactory->create_logger($type, %opts);

Creates a logger instance of the specified type. Supported types:
- 'console' - Console logger
- 'database' - Database logger
- 'json_file' - JSON file logger

=head2 create_default_logger

    my $logger = HelloPerld::Logger::LoggerFactory->create_default_logger();

Creates a default console logger instance.

=head1 AUTHOR

Alex Beahm <alexanderbeahm@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2024 Alex Beahm

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut