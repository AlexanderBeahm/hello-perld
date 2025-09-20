#!/usr/bin/perl
package MyApp::Logger::DatabaseLogger;

use strict;
use warnings;
use lib '.';
use parent 'MyApp::Logger::Logger';
use DBI;

# Concrete implementation of Logger that outputs to PostgreSQL database
sub new {
    my ($class, %opts) = @_;
    
    my $dbname = $opts{dbname} || 'postgres';
    my $host = $opts{host} || 'db';
    my $port = $opts{port} || 5432;
    my $user = $opts{user} || $ENV{'POSTGRES_USER'};
    my $password = $opts{password} || $ENV{'POSTGRES_PASSWORD'};
    
    my $self = bless {
        dbname => $dbname,
        host => $host,
        port => $port,
        user => $user,
        password => $password,
    }, $class;
    
    $self->_init_database();
    
    return $self;
}

sub log {
    my ($self, $level, $message) = @_;
    
    eval {
        my $dbh = $self->_get_connection();
        my $timestamp = $self->_get_timestamp();
        
        my $sth = $dbh->prepare("INSERT INTO application_logs (timestamp, level, message) VALUES (?, ?, ?)");
        $sth->execute($timestamp, $level, $message);
        
        $dbh->disconnect();
    };
    
    if ($@) {
        # Fallback to STDERR if database logging fails
        print STDERR "Database logging failed: $@\n";
        my $timestamp = $self->_get_timestamp();
        print STDERR "[$timestamp] [$level] $message\n";
    }
}

sub _get_connection {
    my $self = shift;
    
    return DBI->connect(
        "dbi:Pg:dbname=$self->{dbname};host=$self->{host};port=$self->{port}",
        $self->{user},
        $self->{password},
        { RaiseError => 1, AutoCommit => 1 }
    );
}

sub _init_database {
    my $self = shift;
    
    eval {
        my $dbh = $self->_get_connection();
        
        # Create logs table if it doesn't exist
        $dbh->do(q{
            CREATE TABLE IF NOT EXISTS application_logs (
                id SERIAL PRIMARY KEY,
                timestamp VARCHAR(19) NOT NULL,
                level VARCHAR(10) NOT NULL,
                message TEXT NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        });
        
        $dbh->disconnect();
    };
    
    if ($@) {
        warn "Failed to initialize database logging: $@";
    }
}

1;