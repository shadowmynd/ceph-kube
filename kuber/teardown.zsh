#!/bin/zsh

function usage() 
{
    echo "INFO:"
    echo "Usage: teardown.zsh [[-r AZURE_REGION]] [-t] "
    echo "The -r (Azure region) parameter specifies the Azure region to destroy"
    echo "The -t (Test Deployment) parameter specifies no ACS will be destroyed and instead local minikube will be instead"
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
    \?) #Invalid option - show help
        echo "ERROR:Option -${BOLD}$OPTARG${NORM} not allowed."
        usage
        exit 1
        ;;
    esac
done

parent_path=${0:a:h}
cd "$parent_path"

if [[ "${test}" == "false" && (-v $region) ]]; then
    echo "ERROR:Invalid Parameters REGION are required. "
    usage
    exit 1
fi


if [[ "${test}" == "false" ]]; then
    # connect kubectl to acs engine
    KUBECONFIG=_output/kubeconfig/kubeconfig.$region.json
fi

# kube
./kubectl/teardown.zsh

if [[ "${test}" == "false" ]]; then
    #acs
    echo "WARN:ACS Engine does not support automated teardown. Use Azure Portal to remove resources."
fi