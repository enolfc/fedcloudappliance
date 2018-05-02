#!/bin/sh

docker run -v /etc/grid-security:/etc/grid-security \
           -v /etc/cloudkeeper:/etc/cloudkeeper \
           -v /image_data:/var/spool/cloudkeeper/images \
           --link cloudkeeper-os:backend \
           --rm egifedcloud/cloudkeeper cloudkeeper sync --debug 
