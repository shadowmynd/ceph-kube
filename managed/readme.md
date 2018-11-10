###Description
Responsible for creating azure infrastructure to support managed ceph cluster

###How to Use
* Copy `Pulumi.example.yaml` into a file named `Pulumi.<deployment-type>.md`
* Update following config values with the appropriate values:
    * `azure:tenantId` - The Azure Tenant Identifier to deploy to
    * `azure:subscriptionId` - The Azure Subscription Identifier to deploy to
    * `ceph:resourceGroup` - The Azure Resource Group to create Ceph infrastructure
    * `ceph:vm_password` - The admin VM password for Ceph VMs
* Update addition parameters as desired
