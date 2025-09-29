FROM perl:5.42
COPY . /usr/src/hello-perld
WORKDIR /usr/src/hello-perld

# Install necessary Perl modules using cpanm
RUN ["cpanm", "--installdeps", "--notest", "."]
CMD ["morbo", "./script/hello-perld"]
EXPOSE 3000
