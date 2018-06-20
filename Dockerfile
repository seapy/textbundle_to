FROM ruby:2.5.1

# install node
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs
RUN apt-get install -y libssl-dev

# https://github.com/oleganza/btcruby/issues/29
RUN ln -nfs /usr/lib/x86_64-linux-gnu/libssl.so.1.0.2 /usr/lib/x86_64-linux-gnu/libssl.so

WORKDIR /app

COPY . .
RUN bin/setup

ENV LANG C.UTF-8
ENTRYPOINT ["bin/runner"]
