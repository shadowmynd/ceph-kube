#!/bin/zsh

parent_path=${0:a:h}
cd "$parent_path"

for role in `tac deps`
do
    kubectl delete -f ./templates/$role.yaml
done