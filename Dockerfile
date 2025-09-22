FROM perl:5.42
COPY . /usr/src/helloperld
WORKDIR /usr/src/helloperld

# Install necessary Perl modules using cpanm
RUN ["cpanm", "--installdeps", "--notest", "."]
CMD ["morbo", "./script/helloperld"]
EXPOSE 3000
