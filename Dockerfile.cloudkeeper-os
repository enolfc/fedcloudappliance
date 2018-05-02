FROM python:2.7
MAINTAINER Enol Fernandez <enol.fernandez@egi.eu>

# Dependencies
RUN pip install grpcio \
                pbr \
                python-glanceclient \
                keystoneauth1 \
                oslo-config \
                oslo-log  \
                webob

# cloudkeeper-OS
RUN mkdir /cloudkeeper \
    && git clone --branch 0.9.4 https://github.com/the-cloudkeeper-project/cloudkeeper-os.git /cloudkeeper \
    && cd /cloudkeeper \
    && pip install .


RUN mkdir -p /etc/cloudkeeper-os/ \
             /var/spool/cloudkeeper/images

COPY /conf/cloudkeeper/cloudkeeper-os.conf /etc/cloudkeeper-os/cloudkeeper-os.conf
COPY /conf/cloudkeeper/voms.json /etc/cloudkeeper-os/voms.json

EXPOSE 50051

CMD ["cloudkeeper-os"]
