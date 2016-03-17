FROM centos:7 
MAINTAINER Enol Fernandez <enol.fernandez@egi.eu>

RUN yum install -y epel-release \
    && yum install -y bdii supervisor

RUN mkdir -p /var/lib/bdii/db/stats \
    && mkdir -p /var/lib/bdii/db/glue \
    && mkdir -p /var/lib/bdii/db/grid \
    && mkdir -p /var/lib/bdii/archive \
    && mkdir -p /var/run/lock/bdii \
    && chown -R ldap:ldap /var/lib/bdii \
    && chown -R ldap:ldap /var/lib/bdii/db \
    && chown -R ldap:ldap /var/run/lock/bdii \
    && mkdir -p /var/run/bdii/db \
    && chown -R ldap:ldap /var/run/bdii

RUN echo "UPDATE_LOCK_FILE=/var/lock/bdii/bdii-update" >> /etc/sysconfig/bdii \
    && echo "SLAPD_LOCK_FILE=/var/lock/bdii/bdii-slapd" >> /etc/sysconfig/bdii

COPY /conf/bdii/bdii.ini /etc/supervisord.d/bdii.ini
COPY /conf/bdii/bdii-update /usr/local/bin/bdii-update
COPY /conf/bdii/bdii-passwd /usr/local/bin/bdii-passwd

RUN chmod +x /usr/local/bin/bdii-*

EXPOSE 2170

# be sure that we set a new password for the bdii for every execution
ENTRYPOINT ["/usr/local/bin/bdii-passwd"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.d/bdii.ini"]
