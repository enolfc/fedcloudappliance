FROM ubuntu:xenial
MAINTAINER Enol Fernandez <enol.fernandez@egi.eu>

RUN apt-get update \
    && apt-get -qy install --fix-missing curl

# CMD
RUN curl http://repository.egi.eu/sw/production/cmd-os/1/ubuntu/dists/xenial-updates/main/binary-amd64/cmd-os-release_1.0.0-1_all.deb > /tmp/cmd-os-release-1.0.0_all.deb \
    && dpkg -i /tmp/cmd-os-release-1.0.0_all.deb \
    && apt-get update \
    && apt-get -qy install --fix-missing \
       git \
       python-pip \
       ca-policy-egi-core \
       fetch-crl \
       caso=1.2.0-1ubuntu1 \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

RUN fetch-crl -p 2 -T 30 || exit 0

RUN cd /usr/local/share/ca-certificates \
    && for f in /etc/grid-security/certificates/*.pem ; do ln -s $f $(basename $f .pem).crt; done \
    && update-ca-certificates

RUN mkdir -p /var/spool/caso
COPY caso.conf /etc/caso/caso.conf
COPY voms.json /etc/caso/voms.json

# override caso :(
RUN pip install --upgrade git+https://github.com/enolfc/caso.git@public_iface

CMD ["/usr/local/bin/caso-extract"]
