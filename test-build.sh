#!/bin/bash
image="j0nnylester/debian-dotfiles:test"
dir=$(cd "$(dirname "$0")"; pwd)
docker build -t $image -f $dir/.devcontainer/Dockerfile $dir
docker image rm $image