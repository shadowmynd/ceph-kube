#!/bin/zsh
function usage() 
{
    echo "INFO:"
    echo "Usage: publish.zsh DOCKER_HOST "
    echo "DOCKER_HOST - The URL of the Docker host "
}

if [ $# -ne 1 ]; then
    echo "ERROR:Wrong number of arguments specified. Parameters received $#. Terminating the script."
    usage
    exit 1
fi

parent_path=${0:a:h}
cd "$parent_path"
parent_tag=$(<./tag) 
for type in `ls -d */ | awk '{print substr($1, 1, length($1)-1)}'`
do
    name=$(<./$type/name)
    if [[ (-v $name) || (-z $name) ]]; then
        echo "ERROR:Image name not defined for $type. Ensure file at ./$type/name is populated. Terminating the script."
        exit 1
    fi

    image_tag=$(<./$type/tag)
    if [[ (-v $image_tag) || (-z $image_tag) ]]; then
        tag=$parent_tag
    else
        tag=$image_tag
    fi

    publish=$1/$name:$tag

    echo "Publishing [$name] to [$1] with tag [$tag]"
    docker tag $name $publish
    docker push $publish
    echo "Finished publishing [$name] to [$1] with tag [$tag]"
done
