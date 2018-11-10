#!/bin/zsh
function usage() 
{
    echo "INFO:"
    echo "Usage: setup.zsh [-m] [-k] [Deployment specific options] "
    echo "-m - Deploy managed cluster "
    echo "-k - Deploy kubernetes cluster "
}

if [ $# -lt 1 ]; then
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
    m) # IP address space
        MANAGED=true
        ;;
    k) # IP address space
        KUBE=true
        ;;
  esac
done

if [[ ("${MANAGED}" == "true" && "${KUBE}" == "true") || ("${MANAGED}" == "false" && "${KUBE}" == "false") ]]; then
    echo "ERROR:Must select Managed or Kubernetes but not both. Terminating Script."
    usage
    exit 1
fi

# deploy ceph cluster
if [[ "${KUBE}" == "true" ]]; then
    ./kuber/teardown.zsh "${@:2}"
else
    echo "Automated managed support not available. The file found at ./managed/readme.md describes tearing down managed deployments."
    ./managed/teardown.zsh "${@:2}"
fi