#!/bin/zsh

parent_path=${0:a:h}
cd "$parent_path"

# teardown
./teardown.zsh

# redeploy images
./images/create.zsh

# redeploy
./setup.zsh