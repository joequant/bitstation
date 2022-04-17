#!/bin/bash
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
for i in 'podman' 'buildah' 'docker'  ; do
    $script_dir/rm-stopped-containers.sh $i
    $script_dir/rm-untagged-images.sh $i
done
