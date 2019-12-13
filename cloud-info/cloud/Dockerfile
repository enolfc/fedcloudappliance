FROM egifedcloud/bdii
MAINTAINER Enol Fernandez <enol.fernandez@egi.eu>

RUN yum install -y centos-release-openstack-queens \
    && yum update -y \
    && yum install -y python-pip python-novaclient python-glanceclient python-openstackclient

RUN curl -L http://repository.egi.eu/sw/production/cas/1/current/repo-files/EGI-trustanchors.repo > /etc/yum.repos.d/EGI-trustanchors.repo \
    && yum -y install ca-policy-egi-core \
    && cd /etc/pki/ca-trust/source/anchors \
    && ln -s /etc/grid-security/certificates/*.pem . \
    && update-ca-trust extract

ARG CIP_VERSION=0.12.0

RUN yum localinstall -y \
        https://github.com/EGI-Foundation/cloud-info-provider/releases/download/$CIP_VERSION/cloud-info-provider-openstack-$CIP_VERSION-1.el7.noarch.rpm \
        https://github.com/EGI-Foundation/cloud-info-provider/releases/download/$CIP_VERSION/cloud-info-provider-$CIP_VERSION-1.el7.noarch.rpm

COPY cloud-bdii-provider /var/lib/bdii/gip/provider/cloud-info-provider
COPY openstack.rc /etc/cloud-info-provider/openstack.rc
COPY openstack.yaml /etc/cloud-info-provider/openstack.yaml
RUN chmod +x /var/lib/bdii/gip/provider/cloud-info-provider
