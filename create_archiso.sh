#!/bin/sh

MAKE_ARCHISO_CMD="$(pwd)/third_party/make-archiso-zfs/make_archiso_zfs.sh"

# create Archiso live USB image
sudo "${MAKE_ARCHISO_CMD}" \
  --build-iso \
  --enable-zfs-kernel-module \
  --extra-packages="git,ansible" \
  --user-files="scripts/install_arch_linux.sh,scripts/install_options.yml"

