import * as pulumi from "@pulumi/pulumi";
import * as azure from "@pulumi/azure";
import * as managedceph from "./src/index";

const cephConfig = new pulumi.Config("ceph");

// Extract config
const region = cephConfig.require("region");
const resourceGroupName = cephConfig.require("resourceGroup");
const networkCidr = cephConfig.require("network");
const dataNetwork = cephConfig.require("dataNetwork");
const vmUsername = cephConfig.require("vm_username");
const vmPassword = cephConfig.require("vm_password");

// Create an Azure Resource Group
const resourceGroup = new azure.core.ResourceGroup(resourceGroupName, {
    location: region,
});

// Create network
const network = new azure.network.VirtualNetwork(`file-${region}-network`, {
    resourceGroupName: resourceGroup.name,
    location: resourceGroup.location,
    addressSpaces: [`${networkCidr}.${dataNetwork}.0/18`],
});

// data subnet
const dataSubnet = new azure.network.Subnet(`file-${region}-data-subnet`, {
    resourceGroupName: resourceGroup.name,
    virtualNetworkName: network.name,
    addressPrefix: `${networkCidr}.${dataNetwork}.0/19`,
});

// samba subnet
const smbSubnet = new azure.network.Subnet(`file-${region}-smb-subnet`, {
    resourceGroupName: resourceGroup.name,
    virtualNetworkName: network.name,
    addressPrefix: `${networkCidr}.${dataNetwork+32}.0/19`,
});

// Create Cluster VMs
const createVms = (
    count: number, 
    vmSize: string, 
    category: string, 
    user: {username: string, password: string},
    extraConfig?: object) => {
    return managedceph.helpers.utilities.mapMany(
        count, 
        vmIndex => managedceph.resources.createVM(vmIndex, {
        region: resourceGroup.location,
        resourceGroupName: resourceGroup.name,
        subnetId: dataSubnet.id,
        category,
        vmSize: vmSize,
        user: user,
        ...extraConfig
    }));
}

type VMConfig = {
    count: number
    vmSize: string
    config?: object
}

type VMConfigs = {
    [key: string]: VMConfig;
}

const vmConfigs: VMConfigs = {
    data: {
        count: 3,
        vmSize: "Standard_DS5_v2",
        config: {
            dataDisks: {
                count: 16,
                sizeInGb: 4095
            },
            tags: {
                role: "data"
            }
        }
    },
    mon: {
        count: 3,
        vmSize: "Standard_DS2_v2",
        config: {
            tags: {
                role: "monitor"
            }
        }
    },
    meta: {
        count: 1,
        vmSize: "Standard_DS2_v2",
        config: {
            tags: {
                role: "metadata"
            }
        }
    },
    mgr: {
        count: 1,
        vmSize: "Standard_DS2_v2",
        config: {
            tags: {
                role: "manager"
            }
        }
    }
}

const vmIds = Object.keys(vmConfigs).map(key => {
    const vmConfig = vmConfigs[key];
    return createVms(vmConfig.count, vmConfig.vmSize, key, {username: vmUsername, password: vmPassword}, vmConfig.config || {})
});

pulumi.all([
    vmIds
]).apply(([
    vmIdentifiers
]) => {
    return {
        vms: vmIdentifiers
    }
})