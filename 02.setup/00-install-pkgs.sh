#!/bin/bash
# These are all of the packages that need to be installed before bootstrap
# is run
# 
# Note that all apache modules should have already been installed
# in the bootstrap image.  Otherwise you will have the system attempt
# to reload httpd which causes the httpd connection to go down
#
# dokuwiki also needs to be in bootstrap for the same reasons
set -e -v

cat <<EOF >> $rootfsDir/etc/dnf/dnf.conf
fastestmirror=true
max_parallel_downloads=15
EOF
if [ -e $rootfsDir/tmp/proxy.sh ]; then
    source $rootfsDir/tmp/proxy.sh
fi

dnf upgrade --best --nodocs --allowerasing --refresh -y \
    --setopt=install_weak_deps=False $rootfsArg

# workaround bug RHEL #1765718
dnf autoremove python3-dnf-plugins-core -y $rootfsArg

# Refresh locale and glibc for missing latin items
# needed for R to build packages
dnf reinstall -v -y --setopt=install_weak_deps=False --best --nodocs --allowerasing \
    locales locales-en glibc $rootfsArg

#texlive needs to be run because it is not relocatable
if [ ! -z $container ] ; then
    if [ -z $releasever ]; then
	releasever="cauldron"
    fi
buildah run $container -- dnf --setopt=install_weak_deps=False --best \
	--allowerasing install -v -y --nodocs --releasever="$releasever" texlive 
fi
#repeat packages in setup
dnf --setopt=install_weak_deps=False --best --allowerasing install -v -y --nodocs $rootfsArg \
      php-json \
      python3-flask \
      python3-pexpect \
      python3-matplotlib \
      sudo \
      git \
      R-base \
      nodejs \
      npm \
      octave \
      redis \
      unzip \
      texlive \
      vim-minimal \
      ruby-sass \
      zeromq-utils \
      python3-pip \
      python3-cffi \
      python3-cython \
      python3-pexpect \
      R-Rcpp-devel \
      libglu-devel \
      rclone \
      fuse \
      parallel \
      gcc-c++ \
      make \
      r-quantlib \
      pkgconfig\(libczmq\) \
      zeromq-devel \
      giflib-devel \
      cmake \
      python3-tornado \
      python3-mglob \
      python3-pytz \
      python3-devel \
      readline-devel \
      lapack-devel \
      python3-pandas \
      python3-pandas-datareader \
      python3-numpy \
      python3-numpy-devel \
      python3-fs \
      python3-scipy \
      python3-qstk \
      python3-scikits-learn \
      python3-rpy2 \
      python3-xlwt \
      python3-xlrd \
      python3-gevent \
      python3-sqlalchemy \
      python3-sympy \
      python3-pillow \
      python3-lxml \
      python3-mistune \
      python3-cryptography \
      python3-pyasn1 \
      python3-pyglet \
      python3-mysql \
      python3-wheel \
      python3-quantlib \
      python3-vispy \
      curl-devel \
      icu-devel \
      libpcre-devel \
      liblzma-devel \
      libbzip2-devel \
      zeromq-devel \
      ta-lib-devel \
      libxml2-devel \
      make \
      python3-cairo-devel \
      jpeg-devel \
      java-devel \
      openmpi-devel \
      libssh2-devel \
      ruby-devel \
      libtool \
      automake \
      autoconf \
      swig \
      protobuf-devel \
      unwind-devel \
      graphviz-devel \
      glpk-devel \
      glpk \
      llvm-devel \
      llvm \
      librdkafka-devel \
      libumfpack-devel \
      hdf5-devel \
      libxt-devel \
      libmagick-devel \
      cargo \
      lib64git2-devel \
      pybind11-devel \
      gzip \
      ncurses \
      nss \
      nspr \
      passwd \
      tar \
      xeus-devel \
      xtl-devel \
      'pkgconfig(Magick++)' \
      distcc \
      curl \
      conda \
      which \
      jupyter-core \
      python3-qtpy \
      boost-devel \
      tbb-devel \
      pybind11-devel \
      python3-metakernel-python \
      python3-metakernel \
      flatbuffers-devel \
      eigen3-devel \
      texlive-dist \
      dmd \
      dub \
      phobos-devel

chmod a+x $rootfsDir/usr/lib64/R/bin/*
dnf clean all $rootfsArg
rm -rf $rootfsDir/var/log/*.log
rm -rf $rootfsDir/usr/share/gems/doc/*
rm -rf $rootfsDir/usr/lib/python3.5
rm -rf $rootfsDir/usr/lib64/python3.5
/sbin/ldconfig -r $rootfsDir
pump --shutdown

# julia
# xeus-sqlite
# python3-py4j
