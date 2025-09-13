# Logging Configuration Examples

This document demonstrates how to configure different logging backends for the hello-perld application.

## Console Logging (Default)

```bash
# No environment variables needed - this is the default
perl main.pl
```

## Database Logging

```bash
# Set environment variable to use database logging
export LOGGER_TYPE=database
perl main.pl
```

The database logger will:
- Create an `application_logs` table if it doesn't exist
- Log all messages to PostgreSQL
- Fall back to STDERR if database connection fails

## JSON File Logging (for ELK Stack integration)

```bash
# Set environment variable to use JSON file logging
export LOGGER_TYPE=jsonfile
export LOG_FILE=application.log  # Optional - defaults to application.log
perl main.pl
```

The JSON file logger creates structured logs suitable for:
- Elasticsearch/Logstash/Kibana (ELK) stack
- Grafana Loki
- Other log aggregation systems

Example JSON log entry:
```json
{"timestamp":"2024-01-15 10:30:45","level":"INFO","message":"Server running at: http://localhost:8080/","service":"hello-perld"}
```

## Custom Logger Implementation

To add a new logger type (e.g., for sending logs to Kafka, Grafana, etc.):

1. Create a new class that inherits from `Logger.pm`
2. Implement the required `log` method
3. Add the logger to `LoggerFactory.pm`
4. Update the factory's `create_logger` method

Example skeleton for a custom logger:

```perl
package CustomLogger;
use strict;
use warnings;
use parent 'Logger';

sub new {
    my ($class, %opts) = @_;
    my $self = bless { %opts }, $class;
    return $self;
}

sub log {
    my ($self, $level, $message) = @_;
    # Your custom logging implementation here
}

1;
```