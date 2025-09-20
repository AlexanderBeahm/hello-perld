FROM perl:5.42
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp

# Install necessary Perl modules using cpanm
RUN ["cpanm", "--installdeps", "--notest", "."]
CMD ["morbo", "./script/myapp"]
EXPOSE 3000
