#!/bin/bash

echo "Creation script running..."

apt-get update

# Add GitHub to known_hosts so first Git call is non-interactive:
mkdir -p ~/.ssh
ssh-keyscan -t rsa,ecdsa,ed25519 github.com >> ~/.ssh/known_hosts

apt-get install -y --no-install-recommends libdbd-pg-perl libpq-dev
apt-get install -y perl
curl -L https://cpanmin.us | perl - --sudo App::cpanminus

# Install cpan deps from cpanfile
cpanm --installdeps --notest .