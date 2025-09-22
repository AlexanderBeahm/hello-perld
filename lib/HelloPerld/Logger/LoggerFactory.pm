#!/usr/bin/perl
package HelloPerld::Logger::LoggerFactory;

use strict;
use warnings;

use lib '.';
require HelloPerld::Logger::Logger;
require HelloPerld::Logger::ConsoleLogger;
require HelloPerld::Logger::DatabaseLogger;
require HelloPerld::Logger::JsonFileLogger;

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