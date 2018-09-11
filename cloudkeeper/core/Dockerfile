FROM ruby:2
MAINTAINER Enol Fernandez <enol.fernandez@egi.eu>
#
# Basic stuff
RUN apt-get update \
    && apt-get -qy install --fix-missing curl qemu-utils\

# Get CAs and fetch-crls
RUN curl https://dist.eugridpma.info/distribution/igtf/current/GPG-KEY-EUGridPMA-RPM-3 | apt-key add - \
    && echo "deb http://repository.egi.eu/sw/production/cas/1/current egi-igtf core" >> /etc/apt/sources.list.d/egi-cas.list \
    && apt-get update \
    && apt-get -qy install --fix-missing ca-policy-egi-core fetch-crl \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

RUN fetch-crl -p 2 -T 30 || exit 0

RUN gem install cloudkeeper
RUN mkdir -p /var/log/cloudkeeper \
             /var/lock/cloudkeeper \
             /var/spool/cloudkeeper/images

COPY entrypoint.sh /entrypoint.sh
COPY image-lists.conf /etc/cloudkeeper/image-lists.conf
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["cloudkeeper", "sync"]
