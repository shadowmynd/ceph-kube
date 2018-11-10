#!/bin/zsh

parent_path=${0:a:h}
cd "$parent_path"

name="ssh_config"
master_name="$parent_path/$name"
master_host="files-shared-test.centralus.cloudapp.azure.com"
user="azureuser"
identity="~/dev/kube/ceph/rook-configs/acs/_output/$(echo $user)_rsa"

cat <<EOF > $master_name
Host master
  HostName $master_host
  Port 22
  User $user
  IdentityFile $identity

EOF

# Get all nodes and generate appropriately
cat <<EOF >> $master_name
Host node01
  HostName 10.240.0.35
  Port 22
  User $user
  ProxyCommand ssh -F $master_name -q master -W %h:%p
  IdentityFile $identity

EOF