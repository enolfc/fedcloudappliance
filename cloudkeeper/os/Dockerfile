FROM centos:7
MAINTAINER Enol Fernandez <enol.fernandez@egi.eu>

RUN yum install -y centos-release-openstack-stein vim
RUN curl http://repository.egi.eu/community/software/cloudkeeper.os/0.9.x/releases/repofiles/centos-7-x86_64.repo > \
         /etc/yum.repos.d/cloudkeeper.repo
RUN yum install -y cloudkeeper-os

RUN mkdir -p /etc/cloudkeeper-os/ \
             /var/spool/cloudkeeper/images

COPY cloudkeeper-os.conf /etc/cloudkeeper-os/cloudkeeper-os.conf
COPY mapping.json /etc/cloudkeeper-os/mapping.json

# Patch the cloudkeeper-os
COPY openstack_client.py /usr/lib/python2.7/site-packages/cloudkeeper_os/openstack_client.py
RUN python -m compileall  /usr/lib/python2.7/site-packages/cloudkeeper_os/openstack_client.py

EXPOSE 50051

CMD ["cloudkeeper-os"]
