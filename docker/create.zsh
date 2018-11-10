#!/bin/zsh

parent_path=${0:a:h}
cd "$parent_path"

for type in `ls -d */`
do
    name=$(<./$type/name)
    docker build -t $name ./$type/docker
done
