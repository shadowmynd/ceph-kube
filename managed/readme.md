# Managed Ceph Cluster
## Description
Responsible for creating azure infrastructure to support managed ceph cluster

###How to Use
* Copy `Pulumi.example.yaml` into a file named `Pulumi.<deployment-type>.md`
* Update following config values with the appropriate values:
    * `azure:tenantId` - The Azure Directory tenant identifier to deploy intof
    * `azure:subscriptionId` - The Azure Subscription identifier to deploy into
    * `ceph:resourceGroup` - The Azure Resource Group to create Ceph infrastructure
    * `ceph:vm_password` - The admin VM password for Ceph VMs
    * `ceph:region` - The Azure Region identifier. E.g. `CentralUS`
* Update addition parameters as desired
* 