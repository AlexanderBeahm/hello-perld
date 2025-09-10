package plextransform;

use strict;
use warnings;
use JSON;

use lib '.';
require plexclient;

# Handle health check
sub handle_health {
    # Get account data from plexclient
    my $accountData = plexclient::get_account_info();
    
    # Return account data (already in JSON format)
    return $accountData;
}

# Handle refresh operation
sub handle_refresh {
    # Trigger the refresh operation
    plexclient::refresh_library(1);
    
    # Return success message
    return "Refresh triggered successfully.";
}

# Handle playlists listing
sub handle_playlists {
    # Fetch the playlists
    my $playlists = plexclient::list_playlists();
    
    # Transform the playlists into the desired JSON structure
    my @processed_playlists;
    for my $playlist (%$playlists) {
        # Assuming $playlist is a hash reference
        push @processed_playlists, { 
            id => $playlist->{'id'}, 
            title => $playlist->{'title'} 
        };
    }
    
    # Convert the processed playlists to JSON and return
    return encode_json(\@processed_playlists);
}

# Handle individual playlist contents
sub handle_playlist_contents {
    my ($playlist_id) = @_;
    
    # Fetch the playlist contents
    my $playlist_contents = plexclient::get_playlist_contents($playlist_id);
    
    # Return the contents (already in JSON format from plexclient)
    return $playlist_contents;
}

1; # End with a true value to determine correct module loading