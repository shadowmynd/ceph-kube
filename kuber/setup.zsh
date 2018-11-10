#!/bin/zsh

function usage() 
{
    echo "INFO:"
    echo "Usage: setup.zsh [[-r AZURE_REGION] [-d DNS_PREFIX]] [-t] "
    echo "The -r (Azure region) parameter specifies the Azure region to provision in"
    echo "The -d (DNS prefix) parameter specifies the DNS name to create acs engine against"
    echo "The -t (Test Deployment) parameter specifies no ACS will be deployed and instead local minikube will be instead"
}

test=false
while getopts :tr:d: optname; do
    case $optname in
    t) #Test deployment
        test=true
        ;;
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

if [[ "${test}" == "false" && ((-v $region) || (-v $dns_prefix)) ]]; then
    echo "ERROR:Invalid Parameters REGION and DNS_PREFIX are required. "
    usage
    exit 1
fi

parent_path=${0:a:h}
cd "$parent_path"

if [[ "${test}" == "false" ]]; then
    # deploy ACS engine
    acs-engine deploy --location $region --api-model ./acs/storage.json --dns-prefix $dns_prefix -f

    # connect kubectl to acs engine
    KUBECONFIG=_output/kubeconfig/kubeconfig.$region.json
fi

# deploy kube cluster
./kubectl/setup.zsh