# Ansible Homelab Automation

## Servers (remotes) to automate need the following setup before Ansible can automate them

```
# Install necessary dependencies for Ansible to perform its tasks
$ sudo apt install python3.9
$ sudo apt install openssh-server

# Have server advertise hostname (ex. my-server.local)
$ sudo apt install avahi-daemon

# If going to use SSH pass rather than key based auth
$ sudo apt install sshpass
```

## Host computer (local) needs the following setup before Ansible can automate remotes

```
# Host needs the following installed - MacOS setup
$ brew install ansible
$ ansible-galaxy collection install community.general
```

## Run the playbook

```
# On Host
$ ansible-playbook ./playbooks/{selected-playbook}.yml --ask-become-pass
```