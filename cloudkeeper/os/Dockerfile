FROM ubuntu:xenial
MAINTAINER Enol Fernandez <enol.fernandez@egi.eu>

RUN apt-get update \
    && apt-get -qy install --fix-missing curl

# CMD
RUN curl http://repository.egi.eu/sw/production/cmd-os/1/ubuntu/dists/xenial-updates/main/binary-amd64/cmd-os-release_1.0.0-1_all.deb > /tmp/cmd-os-release-1.0.0_all.deb \
    && dpkg -i /tmp/cmd-os-release-1.0.0_all.deb

RUN apt-get update \
    && apt-get -qy install --fix-missing cloudkeeper-os=0.9.9-1 \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*


RUN mkdir -p /etc/cloudkeeper-os/ \
             /var/spool/cloudkeeper/images

COPY cloudkeeper-os.conf /etc/cloudkeeper-os/cloudkeeper-os.conf
COPY voms.json /etc/cloudkeeper-os/voms.json

EXPOSE 50051

CMD ["cloudkeeper-os"]
