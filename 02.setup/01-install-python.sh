#!/bin/bash

set -v
set -o errexit
source $rootfsDir/tmp/proxy.sh
echo "Running python installation"


useradd -r rhea -s /bin/false -M -G shadow

parallel --halt 2 -j1 -n1 --linebuffer --tagstring '{}' "pip3 install --upgrade $PYTHON_ARGS --prefix /usr --no-cache-dir '{}'" ::: <<EOF
jupyterlab
jupyterhub
sudospawner
jupyter-fs
jhub_remote_user_authenticator
ipywidgets
ipycanvas
seaborn
EOF
