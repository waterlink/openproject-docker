FROM prepared_ubuntu

MAINTAINER OpenProject Foundation (opf), info@openproject.org
#USER openproject

# expose rails server port
EXPOSE 8080
EXPOSE 22

ENV DEBIAN_FRONTEND noninteractive

#
# Setup OpenProject
#
ADD ./setup_system.sh /setup_system.sh
RUN /bin/bash /setup_system.sh
RUN rm /setup_system.sh
ADD ./passenger-standalone.json /home/openproject/openproject/passenger-standalone.json

#
# And, finally, launch supervisord in foreground mode.
#
ADD ./supervisord.conf /etc/supervisord.conf
ENTRYPOINT ["supervisord", "-n"]
