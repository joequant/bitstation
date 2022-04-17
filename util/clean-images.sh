#!/bin/bash
for i in 'podman' 'buildah' 'docker'  ; do
    ./rm-stopped-containers.sh $i
    ./rm-untagged-images.sh $i
done
