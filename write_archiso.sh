#!/bin/sh

MAKE_ARCHISO_CMD="$(pwd)/third_party/make-archiso-zfs/make_archiso_zfs.sh"

# write Archiso live USB image to device (i.e. USB stick)
# pass through "-w /dev/sdx" option
sudo "${MAKE_ARCHISO_CMD}" "${@}"

