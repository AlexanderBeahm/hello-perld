#!/bin/bash

echo "Creation script running..."

apt-get update

# Add GitHub to known_hosts so first Git call is non-interactive:
mkdir -p ~/.ssh
ssh-keyscan -t rsa,ecdsa,ed25519 github.com >> ~/.ssh/known_hosts

apt-get install -y --no-install-recommends libdbd-pg-perl libpq-dev

# Install perlbrew and set up Perl 5.42.0, install cpanm
# (https://perlbrew.pl/)
curl -L https://install.perlbrew.pl | bash
echo 'source ~/perl5/perlbrew/etc/bashrc' >> ~/.profile
source ~/perl5/perlbrew/etc/bashrc
perlbrew install -n -j 5 perl-5.42.0
perlbrew switch perl-5.42.0
curl -L https://cpanmin.us | perl - --sudo App::cpanminus

# Install cpan deps from cpanfile
cpanm --installdeps --notest .