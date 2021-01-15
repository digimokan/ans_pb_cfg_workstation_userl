#!/bin/sh

# INSTALL SCRIPT, PLACED ONTO ARCHISO USB STICK

ans_install_repo='ansible-install-arch-zfs' # name of ans-install repo

# clone the ansible playbook from github, if first installation attempt
if [ ! -d "${ans_install_repo}" ]; then
  git clone "https://github.com/digimokan/${ans_install_repo}.git" || exit 1
fi

# change to the ansible-playbook directory
cd "${ans_install_repo}" || exit 1

# use ansible-galaxy cmd to download roles from github/galaxy/etc
ansible-galaxy role install \
  --role-file requirements.yml \
  --roles-path ./roles/ext \
  --force-with-deps \
  || exit 1

# run the playbook, passing through args to ansible-playbook cmd
ansible-playbook \
  --inventory hosts \
  --ask-become-pass \
  --extra-vars '@../install_options.yml' \
  "${@}" playbook.yml

