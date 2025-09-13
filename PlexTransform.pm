package PlexTransform;

use strict;
use warnings;
use JSON;

use lib '.';
require PlexClient;

# Handle health check
sub handle_health {
    # Get account data from PlexClient
    my $accountData = PlexClient::get_account_info();
    
    # Return account data (already in JSON format)
    return $accountData;
}

# Handle refresh operation
sub handle_refresh {
    # Trigger the refresh operation
    PlexClient::refresh_library(1);
    
    # Return success message
    return "Refresh triggered successfully.";
}

# Handle playlists listing
sub handle_playlists {
    # Fetch the playlists
    my $playlists = PlexClient::list_playlists();
    
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
    my $decoded_contents = PlexClient::get_playlist_contents($playlist_id);

    # Decode the JSON string
    #my $decoded_contents = decode_json($playlist_contents);

    # Transform the contents into the desired structure
    my @processed_contents;
    if ($decoded_contents && $decoded_contents->{'MediaContainer'} && $decoded_contents->{'MediaContainer'}->{'Metadata'}) {
        for my $item (@{$decoded_contents->{'MediaContainer'}->{'Metadata'}}) {
            push @processed_contents, {
                id => $item->{'ratingKey'},
                title => $item->{'title'}
            };
        }
    }

    # Convert back to JSON
    my $playlist_contents = encode_json(\@processed_contents);
    
    # Return the contents (already in JSON format from PlexClient)
    return $playlist_contents;
}

1; # End with a true value to determine correct module loading