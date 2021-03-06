#!/usr/bin/env bash

set -e -v

mkimg="$(basename "$0")"
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
container=$(buildah from joequant/cauldron)
cache_server=${cache_server:-172.17.0.1}
echo "cache server: ${cache_server}"


buildah config --label maintainer="Joseph C Wang <joequant@gmail.com>" $container
buildah config --user root $container
mountpoint=$(buildah mount $container)

export rootfsDir=$mountpoint
export rootfsArg="--installroot=$mountpoint"
export rootfsRpmArg="--root $mountpoint"
export rootfsLdconfigArg="-r $mountpoint"
export LC_ALL=C
export LANGUAGE=C
export LANG=C
name="joequant/bitstation"
cp $script_dir/*.sh $rootfsDir/tmp
chmod a+x $rootfsDir/tmp/*.sh

cat <<EOF > $rootfsDir/tmp/env.sh
export cache_server=${cache_server:-172.17.0.1}
EOF

mkdir $rootfsDir/usr/share/bitquant
source $script_dir/00-install-pkgs.sh
cp $script_dir/00_bitquant_sudo $rootfsDir/etc/sudoers.d/
sed -i -e 's/USER_TIME_QUOTA = 3.8/USER_TIME_QUOTA = 20.0/' $rootfsDir/usr/li*/python*/site-packages/include_server/basics.py
buildah run $container parallel --halt 2 --tagstring '{}' --linebuffer source '/tmp/{}' :::  01-install-r-pkgs.sh 01-install-python.sh 01-install-npm.sh 01-install-ruby.sh
buildah run $container /tmp/02-set-password.sh
buildah run $container /tmp/03-install-jupyter.sh
source $script_dir/04-remove-build-deps.sh

cat > $rootfsDir/usr/share/bitquant/bitquant.sh <<EOF
build_date='$(date)'
commit_id=$(git rev-parse --verify HEAD)
EOF

cp $script_dir/startup-all.sh $rootfsDir/usr/share/bitquant/startup-all.sh
chmod a+x $rootfsDir/usr/share/bitquant/startup-all.sh
buildah config --cmd  "/usr/share/bitquant/startup-all.sh" $container
buildah commit --format docker --squash --rm $container $name
