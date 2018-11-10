#!/bin/zsh

parent_path=${0:a:h}
cd "$parent_path"

for role in `tac deps`
do
    ./$role/teardown.zsh
done