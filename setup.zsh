#!/bin/zsh
function usage() 
{
    echo "INFO:"
    echo "Usage: setup.zsh [-m] [-k] [Deployment specific options] "
    echo "-m - Deploy managed cluster "
    echo "-k - Deploy kubernetes cluster "
}

if [ $# -le 1 ]; then
    echo "ERROR:Wrong number of arguments specified. Parameters received $#. Terminating the script."
    usage
    exit 1
fi

parent_path=${0:a:h}
cd "$parent_path"

MANAGED=false
KUBE=false

while getopts ":mk" optname; do
    case $optname in
    m) # Managed
        MANAGED=true
        ;;
    k) # Kubernetes
        KUBE=true
        ;;
  esac
done

if [[ ("${MANAGED}" == "true" && "${KUBE}" == "true") || ("${MANAGED}" == "false" && "${KUBE}" == "false") ]]; then
    echo "ERROR:Must select Managed or Kubernetes but not both. Terminating Script."
    echo "INFO:Managed:$MANAGED"
    echo "INFO:Kubernetes:$KUBE"
    usage
    exit 1
fi

# create images
./docker/create.zsh

# deploy ceph cluster
if [[ KUBE ]]; then
    ./kuber/setup.zsh "${@:2}"
else
    echo "Automated managed support not available. The file found at ./managed/readme.md describes tearing down managed deployments."
    ./managed/setup.zsh "${@:2}"
fi