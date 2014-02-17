FROM stackbrew/ubuntu:13.10

MAINTAINER OpenProject Foundation (opf), info@openproject.org
ENV DEBIAN_FRONTEND noninteractive

# expose rails server port
EXPOSE 8080
# export ssh port; user is openproject; password will be generated and is dumped to stdout during the build
EXPOSE 22

#
# Install ruby and its dependencies
#
# RUN echo "deb http://archive.ubuntu.com/ubuntu saucy main universe" > /etc/apt/sources.list
RUN apt-get update -q
RUN locale-gen en_US en_US.UTF-8
RUN apt-get install -y --force-yes build-essential curl git
RUN apt-get install -y --force-yes zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev

#
# Install openproject dependencies
#
RUN apt-get install -q -y --force-yes libxslt1-dev libxml2-dev libmysqlclient-dev libpq-dev libsqlite3-dev libyaml-0-2 libmagickwand-dev libmagickcore-dev libmagickcore5-extra libgraphviz-dev libgvc5 ruby-dev

# Install utilities
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
# Add HTTPS support for APT. Passengers APT repository is stored on an HTTPS server.
RUN apt-get install -q -y --force-yes apt-transport-https ca-certificates
RUN echo 'deb https://oss-binaries.phusionpassenger.com/apt/passenger saucy main' > /etc/apt/sources.list.d/passenger.list
RUN chown root: /etc/apt/sources.list.d/passenger.list
RUN chmod 600 /etc/apt/sources.list.d/passenger.list
RUN apt-get update -q
RUN apt-get install -q -y --force-yes memcached git subversion vim wget python-setuptools openssh-server sudo pwgen libcurl4-openssl-dev passenger
RUN easy_install supervisor
RUN mkdir /var/log/supervisor/

# see: http://flnkr.com/2013/12/creating-a-docker-ubuntu-13-10-image-with-openssh/
RUN mkdir /var/run/sshd
RUN /usr/sbin/sshd
RUN sed -i 's/.*session.*required.*pam_loginuid.so.*/session optional pam_loginuid.so/g' /etc/pam.d/sshd
RUN /bin/echo -e "LANG=\"en_US.UTF-8\"" > /etc/default/local

#
# Install MySQL
#
# RUN apt-get -y --force-yes -q install postgresql postgresql-client postgresql-contrib
RUN apt-get install -y --force-yes -q mysql-client mysql-server

RUN apt-get clean

#
# Setup OpenProject
#
ADD ./setup_system.sh /setup_system.sh
RUN /bin/bash /setup_system.sh
ENV CONFIGURE_OPTS --disable-install-doc
RUN rm /setup_system.sh
ENV PATH /home/openproject/.rbenv/bin:$PATH
ADD ./passenger-standalone.json /home/openproject/openproject/passenger-standalone.json
ADD ./start_openproject.sh /home/openproject/start_openproject.sh

#
# And, finally, launch supervisord in foreground mode.
#
ADD ./supervisord.conf /etc/supervisord.conf
ENTRYPOINT ["supervisord", "-n"]
