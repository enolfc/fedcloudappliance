# fedcloudappliance
EGI Federated Cloud Appliance

This is a set of docker containers to federate a OpenStack deployment into EGI's Federated Cloud. They are all packaged on a single VM that runs the services and connects to the OpenStack using configured credentials.

These are the configured components:
* Information Discovery (BDII)
* Accounting (cASO + SSMsend)
* VMI replication (atrope)

## Information discovery

Information discovery provides a real-time view about the actual images and flavors available at the OpenStack for the federation users. It has two components:
* Resource-Level BDII: which queries the OpenStack deployment to get the informoation to publish
* Site-Level BDII: gathers information from several resource-level BDIIs (in this case only 1) and makes it publicly available for the EGI information system.

### Resource-level BDII

This is provided by container `egifedcloud/cloudbdii`. The configuration is in two files:
- `/etc/cloud-info-provider/openstack.rc`, with the credentials to query your OpenStack service
- `/etc/cloud-info-provider/openstack.yaml`, this file includes the static information of your deployment. Make sure to set the `SITE-NAME` as defined in GOCDB.

### Site-level BDII

The `egifedcloud/sitebdii` container runs this process. The configuration is in two files:
- `/etc/sitebdii/glite-info-site-defaults.conf`. Set here the name of your site (as defined in GOCDB) and the public URL where the appliance will be available.
- `/etc/sitebdii/site.cfg`. Include here basic information on your site.

### Running the services

In order to run the information discovery containers, there is a docker-compose file at `/etc/sitebdii/docker-compose.yml`. Run it with:
 docker-compose -f /etc/sitebdii/docker-compose.yml stop up -d


