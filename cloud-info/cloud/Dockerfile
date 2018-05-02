FROM egifedcloud/bdii
MAINTAINER Enol Fernandez <enol.fernandez@egi.eu>

RUN yum install -y centos-release-openstack-queens \
    && yum update -y \
    && yum install -y git python-pip python-novaclient python-glanceclient python-openstackclient

RUN curl -L http://repository.egi.eu/sw/production/cas/1/current/repo-files/EGI-trustanchors.repo > /etc/yum.repos.d/EGI-trustanchors.repo \
    && yum -y install ca-policy-egi-core \
    && cd /etc/pki/ca-trust/source/anchors \
    && ln -s /etc/grid-security/certificates/*.pem . \
    && update-ca-trust extract

RUN curl -L http://repository.egi.eu/community/software/cloud.info.provider/0.x/releases/repofiles/centos-7-x86_64.repo > /etc/yum.repos.d/cloud-info-provider.repo \
     && yum -y install cloud-info-provider

COPY cloud-bdii-provider /var/lib/bdii/gip/provider/cloud-info-provider
COPY openstack.rc /etc/cloud-info-provider/openstack.rc
COPY openstack.yaml /etc/cloud-info-provider/openstack.yaml
RUN chmod +x /var/lib/bdii/gip/provider/cloud-info-provider
