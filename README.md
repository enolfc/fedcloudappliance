# fedcloudappliance
EGI Federated Cloud Appliance

This is a set of docker containers to federate a OpenStack deployment into EGI
Federated Cloud. They are all packaged on a single VM that runs the services
and connects to the OpenStack using configured credentials.

These are the configured components:
* Information Discovery (BDII)
* Accounting (cASO + SSMsend)
* VMI replication (cloudkeeper)

Documentation is available at https://docs.egi.eu/providers/cloud-compute/openstack/
