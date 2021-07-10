# ans_pb_cfg_workstation_userl

Ansible and shell scripts to install and configure Arch Linux with MATE DE.

[![Release](https://img.shields.io/github/release/digimokan/ans_pb_cfg_workstation_userl.svg?label=release)](https://github.com/digimokan/ans_pb_cfg_workstation_userl/releases/latest "Latest Release Notes")
[![License](https://img.shields.io/badge/license-MIT-blue.svg?label=license)](LICENSE.txt "Project License")

## Table Of Contents

* [Purpose](#purpose)
* [Hardware Requirements](#hardware-requirements)
* [Quick Start](#quick-start)
    * [Create Archiso](#create-archiso)
    * [Write Archiso To USB Stick](#write-archiso-to-usb-stick)
    * [Install Arch Linux](#install-arch-linux)
    * [Configure Workstation](#configure-workstation)
    * [Update Workstation](#update-workstation)
* [Vault Variables](#vault-variables)
* [Source Code Layout](#source-code-layout)
* [Contributing](#contributing)

## Purpose

Set up a workstation/desktop-PC for normal daily use:

* Install the Arch Linux OS.
* Configure the MATE desktop environment.
* Configure a basic set of applications.

## Hardware Requirements

* A "bootstrap machine" running Arch Linux OS (to create the Archiso live USB).
* An empty/formattable USB stick (to write Archiso to).
* A workstation PC with with an empty/formattable hard drive (or two empty hard
  drives, for a mirrored installation).

## Quick Start

### Create Archiso

On the "bootstrap machine," create a new Arch Linux
[Archiso](https://wiki.archlinux.org/index.php/Archiso) live ISO image.

1. As required: use `pacman` to install `git` and `ansible` packages:

   ```shell
   $ pacman -S git ansible
   ```

2. Clone project into a local project directory:

   ```shell
   $ git clone https://github.com/digimokan/ans_pb_cfg_workstation_userl.git
   ```

3. Change to the local project directory:

   ```shell
   $ cd ans_pb_cfg_workstation_userl
   ```

4. Run the [`create_archiso.sh`](create_archiso.sh) script to create the ISO
   image:

   ```shell
   $ ./create_archiso.sh
   ```

### Write Archiso To USB Stick

On the "bootstrap machine," write the newly-created Live ISO to a USB stick.

1. Insert an empty/formattable USB stick.

2. Run the [`write_archiso.sh`](write_archiso.sh) script to write the ISO image
   to the USB stick, specifying the USB stick device path:

   ```shell
   $ ./write_archiso.sh -w /dev/sdx
   ```

### Install Arch Linux

On the workstation PC, use the live ISO to install Arch Linux to the workstation
disk(s).

1. Power down the workstation PC.

2. Insert the USB stick into the workstation PC.

3. Power up the workstation PC. You will see a root prompt, at the `/root`
   directory.

4. Edit [`/root/install_options.yml`](scripts/install_options.yml) to specify the
   installation disks and other options. You can specify one disk, or two disks
   for a mirrored installation.

5. Run the [`/root/install_arch_linux.sh`](scripts/install_arch_linux.sh) script
   to install Arch Linux to the workstation.

   ```shell
   $ ./install_arch_linux.sh
   ```

6. When the script and Ansible complete successfully, power down the workstation
   PC and remove the USB stick.

### Configure Workstation

On the workstation PC, run the post-install configuration script.

1. Power up the workstation PC. Log in with your root password, which was set
   during installation.

2. Change to the pre-provisioned project directory:

   ```shell
   $ cd ans_pb_cfg_workstation_userl
   ```

3. Ensure `vault_password.txt` has been created, as desribed in
   [Vault Variables](#vault-variables).

4. Run the `configure.sh` script to configure the workstation.

   ```shell
   $ ./configure.sh
   ```

### Update Workstation

To update the workstation PC at a later time, use the `admin` user account, which
was set up during configuration.

1. Log in to the `admin` user account.

2. Change to the pre-provisioned project directory:

   ```shell
   $ cd ans_pb_cfg_workstation_userl
   ```

3. Run the `configure.sh` script to update the workstation.

   ```shell
   $ ./configure.sh
   ```

## Vault Variables

* The encrypted vault variables are stored in [`vault.yml`](host_vars/vault.yml).

* Prior to encrypting or decrypting vault variables, the vault password string
  needs to be put into the `vault_password.txt` file
  ([at the root of this repo directory](#source-code-layout)).

* [`playbook.yml`](playbook.yml) automatically uses the vault password file to
  decrypt vars in [`vault.yml`](host_vars/vault.yml), via a setting in
  [`ansible.cfg`](ansible.cfg).

* To create or replace an encrypted vault variable, use the string provided by:

   ```shell
   $ ansible-vault encrypt_string 'secret_var_value' --name 'secret_var_name'
   ```

* To decrypt and view a var from [vault.yml](host_vars/vault.yml):

   ```shell
   $ ansible -i hosts localhost -m ansible.builtin.debug -a var="secret_var_name" -e "@host_vars/vault.yml"
   ```

## Source Code Layout

```
├─┬ ans_pb_cfg_workstation_userl/
│ │
│ ├─┬ host_vars/
│ │ │
│ │ └── vault.yml         # encrypted vault variables used by playbook.yml
│ │
│ ├─┬ roles/
│ │ │
│ │ └─┬ ext/              # external (third-party, downloaded) roles
│ │   │
│ │   ├── add-group/      # create an group on the system
│ │   ├── add-user/       # create and configure a user on the system
│ │   ├── config-sudo/    # config the system sudo utility
│ │   ├── config-time/    # configure system clock, time, and time zone
│ │   ├── cpu-ucode/      # configure intel/amd cpu microcode to load at boot
│ │   └── mirrors-update/ # update pacman mirrorlist file, if it's too old
│ │
│ ├─┬ scripts/            # to place onto Archiso USB stick
│ │ │
│ │ ├── install_arch_linux.sh  # shell script to install Arch Linux
│ │ └── install_options.yml    # config file to specify install disks, etc
│ │
│ ├─┬ third_party/
│ │ │
│ │ └── make-archiso-zfs/ # shell script to create Archiso (git subtree)
│ │
│ ├── ansible.cfg         # play-wide Ansible meta-config
│ ├── configure.sh        # configures the workstation, post-installation
│ ├── create_archiso.sh   # creates Archiso live USB image
│ ├── hosts               # Ansible inventory (configured for local host)
│ ├── playbook.yml        # main Ansible playbook
│ ├── requirements.yml    # list of roles (on github/galaxy) to download
│ ├── vault_password.txt  # password-string to encrypt and decrypt vault vars
│ └── write_archiso.sh    # writes Archiso to USB stick
│
```

## Contributing

* Feel free to report a bug or propose a feature by opening a new
  [Issue](https://github.com/digimokan/ans_pb_cfg_workstation_userl/issues).
* Follow the project's [Contributing](CONTRIBUTING.md) guidelines.
* Respect the project's [Code Of Conduct](CODE_OF_CONDUCT.md).

