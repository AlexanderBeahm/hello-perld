#!/usr/bin/env perl

# Keeping this file for backward compatibility running Perl scripts
# but the main application file is now in lib/MyApp.pm
# New file location is script/myapp

use strict;
use warnings;

use FindBin;
BEGIN { unshift @INC, "$FindBin::Bin/lib" }

use Mojolicious::Commands;

# Start command line interface for application  
Mojolicious::Commands->start_app('MyApp');


