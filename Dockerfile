FROM perl:5.42
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp
RUN ["cpanm", "HTTP::Daemon", "HTTP::Status", "DBD::Pg"]
CMD [ "perl", "./main.pl" ]
EXPOSE 8080