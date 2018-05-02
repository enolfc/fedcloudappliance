FROM ubuntu:trusty
MAINTAINER Enol Fernandez <enol.fernandez@egi.eu>

RUN apt-get update \
    && apt-get -qy install --fix-missing \
        curl python-virtualenv python-pip python-dev \
        libldap2-dev libsasl2-dev libffi-dev libssl-dev \
    && apt-get clean autoclean \
    && apt-get autoremove -y 

# Get CAs and fetch-crls
RUN curl https://dist.eugridpma.info/distribution/igtf/current/GPG-KEY-EUGridPMA-RPM-3 | apt-key add - \
    && echo "deb http://repository.egi.eu/sw/production/cas/1/current egi-igtf core" >> /etc/apt/sources.list.d/egi-cas.list \
    && apt-get update \
    && apt-get -qy install --fix-missing ca-policy-egi-core fetch-crl \
    && apt-get clean autoclean \
    && apt-get autoremove -y

# install cASO on its own virtualenv
RUN virtualenv /usr/local/caso \
    && /usr/local/caso/bin/pip install --upgrade setuptools \
    && /usr/local/caso/bin/pip install caso==1.1.1

RUN fetch-crl || exit 0

RUN . /usr/local/caso/bin/activate \
    && cat /etc/grid-security/certificates/*.pem >> $(python -m requests.certs)

RUN mkdir /var/spool/caso
COPY caso.conf /etc/caso/caso.conf
COPY voms.json /etc/caso/voms.json

CMD ["/usr/local/caso/bin/caso-extract"]
