#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WEB_DIR=$SCRIPT_DIR/..
GIT_DIR=$WEB_DIR/../..
LOG_DIR=/var/log/bitquant
cd $SCRIPT_DIR

mkdir -p $LOG_DIR
chmod a+w $LOG_DIR
chmod a+rx /home/user
mkdir -p /etc/jupyterhub
chown -R rhea:rhea /etc/jupyterhub

if [ -x /usr/bin/jupyterhub ] ; then
    echo "Start jupyterhub"
    pushd /etc/jupyterhub
    rm -f jupyterhub-proxy.pid
    sudo -u rhea /usr/bin/jupyterhub --JupyterHub.spawner_class=sudospawner.SudoSpawner --Spawner.default_url='/lab' --debug >> $LOG_DIR/jupyterhub.log 2>&1 &
    popd
fi

sleep infinity
