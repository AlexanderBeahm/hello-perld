FROM perl:5.42
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp

# Install necessary Perl modules using cpanm
RUN ["cpanm", "LWP::UserAgent", "LWP::Protocol::https", "HTTP::Request", "XML::Simple", "JSON", "Data::Dumper", \
     "HTTP::Daemon", "HTTP::Status", "DBD::Pg"]

CMD ["perl", "./main.pl"]
EXPOSE 8080