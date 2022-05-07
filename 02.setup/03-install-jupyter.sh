#!/bin/bash
# sudo portion of r package installations
set -v
set +o errexit

source $rootfsDir/tmp/env.sh
source $rootfsDir/tmp/proxy.sh

echo "Running r installation"
if [ `uname -m` = "x86_64" -o `uname -m` = " x86-64" ]; then
LIBDIR="lib64"
else
LIBDIR="lib"
fi

# Without this the installation will try to put the R library in the
# system directories where it does not have permissions

R_VERSION=$(R --version | head -1 | cut -d \  -f 3 | awk -F \. {'print $1"."$2'})

/usr/bin/R -e 'IRkernel::installspec(prefix="/usr", user=FALSE)'

#npm
if [ -x /usr/bin/npm ] ; then
    ijsinstall --install=global
    its --install=global
    jp-coffee-install --install=global
    jp-babel-install --install=global
    jp-livescript-install --install=global
fi

mkdir -p /usr/share/jupyter/kernels
mv /usr/local/share/jupyter/kernels/* /usr/share/jupyter/kernels
# ruby
if [ -x /usr/bin/iruby ] ; then
    iruby register --force
fi
pump --shutdown

if [[ ! -z "$http_proxy" ]] ; then
    git config --global http.proxy $http_proxy
    if [[ ! -z "$GIT_PROXY" ]] ; then
	git config --global url."$GIT_PROXY".insteadOf https://
    fi
    git config --global http.sslVerify false
fi
