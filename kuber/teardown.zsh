#!/bin/zsh

function usage() 
{
    echo "INFO:"
    echo "Usage: teardown.zsh [-r AZURE_REGION] "
    echo "The -r (Azure region) parameter specifies the Azure region to destroy"
}

if [ $# -ne 2 ]; then
    echo "ERROR:Wrong number of arguments specified. Parameters received $#. Terminating the script."
    usage
    exit 1
fi

while getopts :r:d: optname; do
    case $optname in
    r) #Region
        region=${OPTARG}
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

# connect kubectl to acs engine
KUBECONFIG=_output/kubeconfig/kubeconfig.$region.json

# kube
./kubectl/teardown.zsh

#acs
echo "WARN:ACS Engine does not support automated teardown. Use Azure Portal to remove resources."