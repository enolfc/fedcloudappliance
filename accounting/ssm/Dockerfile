FROM ubuntu:trusty
MAINTAINER Enol Fernandez <enol.fernandez@egi.eu>

RUN apt-get update \
    && apt-get -qy install --fix-missing \
        curl python-virtualenv python-pip python-dev \
        libldap2-dev libsasl2-dev \
    && apt-get clean autoclean \
    && apt-get autoremove -y

# Get CAs and fetch-crls
RUN curl https://dist.eugridpma.info/distribution/igtf/current/GPG-KEY-EUGridPMA-RPM-3 | apt-key add - \
    && echo "deb http://repository.egi.eu/sw/production/cas/1/current egi-igtf core" >> /etc/apt/sources.list.d/egi-cas.list \
    && apt-get update \
    && apt-get -qy install --fix-missing ca-policy-egi-core fetch-crl \
    && apt-get clean autoclean \
    && apt-get autoremove -y

ENV SSM_VERSION=2.2.0-1

# install apel
RUN curl -Ls https://github.com/apel/ssm/archive/$SSM_VERSION.tar.gz | tar -xzf - \
    && cd ssm-$SSM_VERSION \
    && pip install . \
    && mkdir -p /var/run/apel /var/spool/apel /var/log/apel /etc/apel \
    && cd .. \
    && rm -rf ssm-$SSM_VERSION

# Config
COPY sender.cfg /etc/apel/sender.cfg
COPY logging.cfg /etc/apel/logging.cfg

CMD ["/usr/local/bin/ssmsend"]
