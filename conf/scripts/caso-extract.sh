#!/bin/sh

docker run -v /etc/voms.json:/etc/caso/voms.json \
           -v /etc/caso:/etc/caso \
           -v /var/spool/caso:/var/spool/caso \
           -v /var/spool/ssm:/var/spool/ssm \
           egifedcloud/caso
