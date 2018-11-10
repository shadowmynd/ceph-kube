import * as azure from "@pulumi/azure";
import * as helpers from "../helpers/index";
import { Output } from "@pulumi/pulumi";

type CreateDiskConfig = {
    count: number,
    sizeInGb: number
}

type CreateUserConfig = {
    username: string
    password: string
}

type CreateVMConfig = {
    region: Output<string>
    resourceGroupName: Output<string>
    subnetId: Output<string>
    dataDisks?: CreateDiskConfig
    user: CreateUserConfig
    category: string
    vmSize: string

    tags?: {
        [key: string]: any;
    }
}

const createDisk = (
    diskId: number, 
    diskSizeInGb: number, 
    vmName: string) => {
    const diskIndex = helpers.utilities.padNum(diskId, 3, "0");

    return {
        caching: 'None',
        diskSizeGb: diskSizeInGb,
        lun: diskId,
        managedDiskType: 'StandardSSD_LRS',
        createOption: 'Empty',
        name: `${vmName}-disk-${diskIndex}`
    };
}

// createVM
const createVM = (
    vmIndex: number, 
    config: CreateVMConfig) => {
    if(config.dataDisks == null) {
        config.dataDisks = {
            count: 0,
            sizeInGb: 0
        }
    }

    if(config.tags == null) {
        config.tags = {}
    }

    const vmResourceIndex = helpers.utilities.padNum(vmIndex, 4, "0")
    const nicName = `${config.category}-nic-${vmResourceIndex}`;
    const vmName = `${config.category}-vm-${vmResourceIndex}`;
    const osDiskName = `${vmName}-os`

    const networkInterface = new azure.network.NetworkInterface(nicName, {
        resourceGroupName: config.resourceGroupName,
        location: config.region,
        ipConfigurations: [{
            name: "ip-config-01",
            subnetId: config.subnetId,
            privateIpAddressAllocation: "Dynamic",
        }],
    });
    
    const storageDataDisks = helpers.utilities.mapMany(config.dataDisks.count, diskIndex => createDisk(diskIndex, config.dataDisks!.sizeInGb, vmName));

    const vm = new azure.compute.VirtualMachine(vmName, {
        resourceGroupName: config.resourceGroupName,
        location: config.region,
        networkInterfaceIds: [networkInterface.id],
        vmSize: config.vmSize,
        deleteDataDisksOnTermination: false,
        deleteOsDiskOnTermination: true,
        zones: undefined, // supports selecting availability zones
        osProfile: {
            computerName: vmName,
            adminUsername: config.user.username,
            adminPassword: config.user.password
        },
        osProfileLinuxConfig: {
            disablePasswordAuthentication: false,
            sshKeys: undefined // add sshKeys vs password auth
        },
        tags: config.tags,
        storageOsDisk: {
            createOption: "FromImage",
            name: osDiskName,
        },
        storageDataDisks,

        // update to use custom role based image
        storageImageReference: {
            publisher: "canonical",
            offer: "UbuntuServer",
            sku: "16.04-LTS",
            version: "latest",
        },
    });

    return vm.id;
}

export default createVM;