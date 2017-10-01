FROM ubuntu
MAINTAINER Carlos Perez

RUN apt-get update
RUN apt-get -y install git
COPY ./id_rsa /root/.ssh/id_rsa
COPY ./id_rsa.pub /root/.ssh/id_rsa.pub
CMD /bin/bash
