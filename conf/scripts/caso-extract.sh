#!/bin/sh

docker run -v /etc/voms.json:/etc/caso/voms.json \
           -v /etc/caso/caso.conf:/etc/caso/caso.conf \
           -v /var/spool/caso:/var/spool/caso \
           -v /var/spool/ssm:/var/spool/ssm \
           egifedcloud/caso
