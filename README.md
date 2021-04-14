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

### Using the initial setup script
On initial setup of a new server we need a way to do the minumum configuration possible to then let Ansible take over. Ideally this would be automated. This can be achieved with VM templates traditionally. I don't personally like how Proxmox templates work and I'd prefer to automate it with Ansible. 
```
// SCP setup file to new Ubuntu server (Host machine to remote machine)
$ scp remote-ansible-setup.sh {remote-username}@{remote-ip}:.

// As remote machine (or via SSH from host machine)
$ sudo ./remote-ansible-setup.sh

// Update inventory/hosts file with new server hostname for Ansible to know about it
``` 

## Host computer (local) needs the following setup before Ansible can automate remotes

```
# Host needs the following installed - MacOS setup
$ brew install ansible
$ ansible-galaxy collection install community.general
```

## Run the playbook

### setup-ssh-key-auth.yml
To setup ssh key based auth we need to pass in the ssh password flag to the command
```
ansible-playbook ./playbooks/setup-ssh-key-auth.yml --ask-pass --ask-become-pass
```

### All other playbooks (after ssh key auth setup)
```
# On Host
$ ansible-playbook ./playbooks/{selected-playbook}.yml --ask-become-pass
```