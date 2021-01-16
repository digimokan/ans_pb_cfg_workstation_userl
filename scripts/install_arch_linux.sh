#!/bin/sh

# SCRIPT PLACED ONTO ARCHISO USB STICK
# INSTALLS ARCH LINUX TO NEW MACHINE

ans_install_repo='ansible-install-arch-zfs' # name of ans-install repo

# clone the ansible playbook from github, if first installation attempt
if [ ! -d "${ans_install_repo}" ]; then
  git clone "https://github.com/digimokan/${ans_install_repo}.git" || exit 1
fi

# run the playbook, passing through args to ansible-playbook cmd
ansible-playbook \
  --inventory "${ans_install_repo}/hosts" \
  --extra-vars '@install_options.yml' \
  "${@}" \
  "${ans_install_repo}/playbook.yml"

