# Automated development environment

This repo is heavily influenced by [TechDufus](https://github.com/TechDufus/dotfiles)'s repo. Go check it out!

**IMPORTANT:** Do not install this without studying the code. The repo is primarily for my own use and secondarily to share bits that may be useful to others.

## Goals

Provide fully automated multiple-OS development environment that is easy to set up and maintain.

### Why Ansible?

Ansible replicates what we would do to set up a development environment pretty well. There are many automation solutions out there - I happen to enjoy using Ansible.

## Requirements

### Operating System

This Ansible playbook only supports multiple OS's on a per-role basis. This gives a high level of flexibility to each role.

This means that you can run a role, and it will only run if your current OS is configured for that role.

This is accomplished with this `template` `main.yml` task in each role:
```yaml
---
- name: "{{ role_name }} | Checking for Distribution Config: {{ ansible_facts.distribution }}"
  ansible.builtin.stat:
    path: "{{ role_path }}/tasks/{{ ansible_facts.distribution }}.yml"
  register: distribution_config

- name: "{{ role_name }} | Run Tasks: {{ ansible_facts.distribution }}"
  ansible.builtin.include_tasks: "{{ ansible_facts.distribution }}.yml"
  when: distribution_config.stat.exists
```
The first task checks for the existence of a `roles/<target role>/tasks/<current_distro>.yml` file. If that file exists (example `current_distro:MacOSX` and a `MacOSX.yml` file exists) it will be run automatically. This keeps roles from breaking if you run a role that isn't yet supported or configured for the system you are running `dotfiles` on.

Currently configured 'bootstrap-able' OS's:
- Ubuntu
- Archlinux (btw)
- MacOSX (darwin)

`bootstrap-able` means the pre-dotfiles setup is configured and performed automatically by this project. For example, before we can run this ansible project, we must first install ansible on each OS type.

To see details, see the `__task "Loading Setup for detected OS: $ID"` section of the `bin/dotfiles` script to see how each OS type is being handled.

### System Upgrade

Verify your `supported OS` installation has all latest packages installed before running the playbook.

```
# Ubuntu
sudo apt-get update && sudo apt-get upgrade -y
# Arch
sudo pacman -Syu
# MacOSX (brew)
brew update && brew upgrade
```

> [!NOTE]
> This may take some time...

## Setup

### all.yml values file

The `all.yml` file allows you to personalize your setup to your needs. This file will be created in the file located at `~/.dotfiles/group_vars/all.yml` after you [Install this dotfiles](#install) and include your desired settings.

### 1Password Integration

This project depends on a 1Password vault. This means you must have installed and authenticated `op` for CLI access to your vault. This can be done by installing the 1Password desktop application **OR** can be setup with the `op` CLI only, but it is a bit more annoying that way since the CLI tool can directly integrate with the Desktop application.

The initial run of `dotfiles` on a new system **should** error without 1Password being setup and having access to a vault (currently defaults to `my.1password.com`)

1Password is more flexible than Ansible Vault in the sense that rotating secrets is just updating the 1Password item, instead of needing to re-encrypt a string and commit it to GitHub. The more you mess with encrypting / decrypting / commiting to Github, the higher the risk of a real secret being exposed.

## Usage

### Install

This playbook includes a custom shell script located at `bin/dotfiles`. This script is added to your $PATH after installation and can be run multiple times while making sure any Ansible dependencies are installed and updated.

This shell script is also used to initialize your environment after bootstrapping your `supported-OS` and performing a full system upgrade as mentioned above.

1. Install the OS
1. Log in as a regular user with sudo privileges
1. Update all packages
1. Install curl
1. Run:
	```shell
	curl -fsSL https://raw.githubusercontent.com/cconrad/dotfiles/main/bin/dotfiles | bash -s -- 
	```

If you want to run only a specific role, you can specify the following bash command:
```bash
curl -fsSL https://raw.githubusercontent.com/cconrad/dotfiles/main/bin/dotfiles | bash -s -- --tags comma,separated,roles
```

### Update

This repository is continuously updated with new features and settings which become available to you when updating.

To update your environment run the `dotfiles` command in your shell:

```bash
dotfiles
```

This will handle the following tasks:

- Verify Ansible is up-to-date
- Clone this repository locally to `~/.dotfiles`
- Verify any `ansible-galaxy` plugins are updated
- Run this playbook with the values in `~/.config/dotfiles/group_vars/all.yaml`

This `dotfiles` command is available to you after the first use of this repo, as it adds this repo's `bin` directory to your path, allowing you to call `dotfiles` from anywhere.

Any flags or arguments you pass to the `dotfiles` command are passed as-is to the `ansible-playbook` command.

For Example: Running the tmux tag with verbosity
```bash
dotfiles -t tmux -vvv
```

As an added bonus, the tags have tab completion!
```bash
dotfiles -t <tab><tab>
dotfiles -t t<tab>
dotfiles -t ne<tab>
```
