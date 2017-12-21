FROM ubuntu
LABEL Carlos Perez

# Install git & ruby
RUN apt-get update && \
  apt-get -y install vim && \
  apt-get -y install git && \
  apt-get -y install ruby-full && \
  apt-get -y install iputils-ping telnet wget git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev \
  libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev \
  python-software-properties libffi-dev

# Install redis
RUN wget http://download.redis.io/redis-stable.tar.gz &&\
    tar xvzf redis-stable.tar.gz &&\
    cd redis-stable &&\
    make &&\
    make install

# Git folder
ENV GIT_FOLDER '/git_sources'
RUN mkdir $GIT_FOLDER

# Copy local repository
COPY . /slack-qbot

# Install bundler & bundle
RUN cd slack-qbot && gem install bundler && bundle

CMD cd slack-qbot && foreman start
