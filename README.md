# fedcloudappliance
EGI Federated Cloud Appliance

This is a set of docker containers to federate a OpenStack deployment into EGI
Federated Cloud. They are all packaged on a single VM that runs the services
and connects to the OpenStack using configured credentials.

These are the configured components:
* Information Discovery (BDII)
* Accounting (cASO + SSMsend)
* VMI replication (atrope)

## Pre-requisites

The appliance works by querying the public APIs of an existing OpenStack
installation. It assumes [Keystone-VOMS](http://keystone-voms.readthedocs.org/)
is installed at that OpenStack and the [`voms.json`](http://keystone-voms.readthedocs.org/en/stable-liberty/configuration.html#vo-to-local-tenant-mapping)
file is properly configured.

The appliance uses the following OpenStack APIs:
* nova, for getting images and flavors available and to get usage information
* keystone, for authentication and for getting the available tenants
* glance, for querying, uploading and removing VM images.

Not all services need to be accessed with the same credentials. Each component
is individually configured.

A host certificate is to send the accounting information before sending
it to the accounting repository. DN of the host certificate must be registered
in GOCDB service type eu.egi.cloud.accounting.

VMI replication may require large disk space, by default the appliance uses
`/image_data` for that. You may use a volume for that.

## Information discovery

Information discovery provides a real-time view about the actual images and
flavors available at the OpenStack for the federation users. It has two
components:

* Resource-Level BDII: which queries the OpenStack deployment to get the
  informoation to publish

* Site-Level BDII: gathers information from several resource-level BDIIs
  (in this case only 1) and makes it publicly available for the EGI
  information system.

### Resource-level BDII

This is provided by container `egifedcloud/cloudbdii`. You need to configure:

* `/etc/cloud-info-provider/openstack.rc`, with the credentials to query your
   OpenStack. The user configured just needs to be able to access the lists
   of images and flavors.

* `/etc/cloud-info-provider/openstack.yaml`, this file includes the static
   information of your deployment. Make sure to set the `SITE-NAME` as defined
   in GOCDB.

### Site-level BDII

The `egifedcloud/sitebdii` container runs this process. Configuration files:
* `/etc/sitebdii/glite-info-site-defaults.conf`. Set here the name of your
   site (as defined in GOCDB) and the public hostname where the appliance will
   be available.

* `/etc/sitebdii/site.cfg`. Include here basic information on your site.

### Running the services

In order to run the information discovery containers, there is a docker-compose
file at `/etc/sitebdii/docker-compose.yml`. Run it with:
```
docker-compose -f /etc/sitebdii/docker-compose.yml up -d
```

Check the status with:
```
docker-compose -f /etc/sitebdii/docker-compose.yml ps
```

You should be able to get the BDII information with an LDAP client, e.g.:
```
ldapsearch -x -p 2170 -h <yourVM.domoin.com> -b o=glue
```

## Accounting

There are two different processes handling the accounting integration:
cASO, which connects to the OpenStack deployment to get the usage information,
and ssmsend, which sends that usage information to the central EGI accounting
repository. They are run by cron every hour (cASO) and every six hours
(ssmsend).

[cASO configuration](http://caso.readthedocs.org/en/latest/configuration.html)
is stored at `/etc/caso/caso.conf`. Most default values are ok, but you must set:

* `site_name` (line 100)
* `tenants` (line 104)
* credentials to access the accounting data (lines 122-128). Check the
  [cASO documentation](http://caso.readthedocs.org/en/latest/configuration.html#openstack-configuration)
  for the expected permissions of the user configured here.

Default location for the voms mapping file is at `/etc/voms.json`. This file
should be the same as in your Keystone-VOMS deployment.

cASO will write records to `/var/spool/apel` where ssmsend will take them.

SSM configuration is available at `/etc/apel`. Defaults should be ok for most
cases. The cron file mounts as volume /etc/grid-security so the ssmsend script
can find there the CAs and the certificate and key files for the host (in
`/etc/grid-security/hostcert.pem` and `/etc/grid-security/hostkey.pem`).

## VMI replication

The appliance provide VMI replication with [atrope](https://github.com/alvarolopez/atrope),
an alternative implementation to vmcatcher. Every 8 hours, the appliance will
perform the following actions:
* download the configured lists in `/etc/atrope/hepix.yaml` and verify its signature
* check any changes in the lists and download new images
* synchronise this information to the configured glance endpoint

Configure the glance credentials in the `/etc/atrope/atrope.conf` file and add
the lists you want to download at the `/etc/atrope/hepix.yaml`. See the
following example for fedcloud.egi.vo list:

```
vo.fedcloud.egi.eu:
    url: https://vmcaster.appdb.egi.eu/store/vo/fedcloud.egi.eu/image.list
    enabled: true
    endorser:
        dn: '/DC=EU/DC=EGI/C=NL/O=Hosts/O=EGI.eu/CN=appdb.egi.eu'
        ca: "/DC=ORG/DC=SEE-GRID/CN=SEE-GRID CA 2013"
    token: 17580f07-1e33-4a38-94e3-3386daced5be
    images: []
    prefix: "FEDCLOUD "
```

Check (How to subscribe to a private image list)[https://wiki.appdb.egi.eu/main:faq:how_to_subscribe_to_a_private_image_list_using_the_vmcatcher]
for instructions to get the URL and token. The `prefix` if specified will be
added in the image title in glance. You can define a subset of images to
download with the `images` field.

