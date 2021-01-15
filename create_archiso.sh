#!/bin/sh

# change to third-party git subtree source dir
cd third_party/make-archiso-zfs || exit 1

# create Archiso live USB image
sudo ./make-archiso-zfs.sh \
  --build-iso \
  --enable-zfs-kernel-module \
  --extra-packages="git,ansible" \
  --user-files="../../scripts/install_arch_linux.sh,../../scripts/install_options.yml"

