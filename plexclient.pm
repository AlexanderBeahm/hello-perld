use strict;
use warnings;
package plexclient;

use LWP::UserAgent;
use HTTP::Request;
use XML::Simple;
use JSON;
use Data::Dumper;
use XML::Hash::XS;

my $plex_token = $ENV{'PLEX_CLAIM'};
my $ua = LWP::UserAgent->new;
my $timeout = 30;
$ua->timeout($timeout);
my $base_url = $ENV{'PLEX_URL'};

sub get_account_info {
    my $url = "$base_url/myplex/account";
    my $req = HTTP::Request->new(GET => $url);
    $req->header('X-Plex-Token' => $plex_token);

    my $resp = $ua->request($req);
    if ($resp->is_success) {
        my $content = $resp->decoded_content;
        return $content;
    } else {
        die "HTTP GET error code: ", $resp->code, "\n",
            "HTTP GET error message: ", $resp->message, "\n";
    }
}

sub get_playlist_contents {
    my ($playlist_id) = @_;
    my $url = "$base_url/playlists/$playlist_id/items";
    my $req = HTTP::Request->new(GET => $url);
    $req->header('X-Plex-Token' => $plex_token);

    my $resp = $ua->request($req);
    if ($resp->is_success) {
        my $content = $resp->decoded_content;
        return $content;
    } else {
        die "HTTP GET error code: ", $resp->code, "\n",
            "HTTP GET error message: ", $resp->message, "\n";
    }
}

sub refresh_library {
    my ($section_key) = @_;
    my $url = "$base_url/library/sections/$section_key/refresh?force=1";
    my $req = HTTP::Request->new(GET => $url);
    $req->header('X-Plex-Token' => $plex_token);

    my $resp = $ua->request($req);
    if ($resp->is_success) {
        return "Library section $section_key refreshed successfully.";
    } else {
        die "HTTP POST error code: ", $resp->code, "\n",
            "HTTP POST error message: ", $resp->message, "\n";
    }
}

sub list_playlists {
    my $url = "$base_url/playlists";
    my $req = HTTP::Request->new(GET => $url);
    $req->header('X-Plex-Token' => $plex_token);

    my $resp = $ua->request($req);
    if ($resp->is_success) {
        my $content = $resp->decoded_content;
        my $converted = XML::Hash::XS::xml2hash($content);
        return $converted;
    } else {
        die "HTTP GET error code: ", $resp->code, "\n",
            "HTTP GET error message: ", $resp->message, "\n";
    }
}

1;
