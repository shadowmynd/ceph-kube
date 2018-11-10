#!/bin/zsh

function usage() 
{
    echo "INFO:"
    echo "Usage: setup.zsh [-r AZURE_REGION] [-d DNS_PREFIX] "
    echo "The -r (Azure region) parameter specifies the Azure region to provision in"
    echo "The -d (DNS prefix) parameter specifies the DNS name to create acs engine against"
}

if [ $# -ne 4 ]; then
    echo "ERROR:Wrong number of arguments specified. Parameters received $#. Terminating the script."
    usage
    exit 1
fi

while getopts :r:d: optname; do
    case $optname in
    r) #Region
        region=${OPTARG}
        ;;
    d) #DNS Prefix
        dns_prefix=${OPTARG}
        ;;
    \?) #Invalid option - show help
        echo "ERROR:Option -${BOLD}$OPTARG${NORM} not allowed."
        usage
        exit 1
        ;;
    esac
done

parent_path=${0:a:h}
cd "$parent_path"

# deploy ACS engine
acs-engine deploy --location $region --api-model ./acs/storage.json --dns-prefix $dns_prefix -f

# connect kubectl to acs engine
KUBECONFIG=_output/kubeconfig/kubeconfig.$region.json

# deploy kube cluster
./kubectl/setup.zsh