FROM egifedcloud/bdii
MAINTAINER Enol Fernandez <enol.fernandez@egi.eu>

# Install emi-bdii-site
RUN yum install -y http://repository.egi.eu/sw/production/umd/4/centos7/x86_64/updates/umd-release-4.1.3-1.el7.centos.noarch.rpm \
    && yum install -y emi-bdii-site

COPY conf/bdii/glite-info-site-defaults.conf /etc/bdii/gip/glite-info-site-defaults.conf
COPY conf/bdii/site-urls.conf /etc/bdii/gip/site-urls.conf
COPY conf/bdii/site.cfg /etc/glite-info-static/site/site.cfg
