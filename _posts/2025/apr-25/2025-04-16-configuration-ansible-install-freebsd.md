---
title: How to Configure Ansible on FreeBSD 14
date: "2025-04-16 10:31:21 +0100"
updated: "2025-04-16 10:31:21 +0100"
id: configuration-ansible-install-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: Ansible is a software that provides simple yet powerful automation for computer support with a wide range of operating systems. This software is primarily aimed at IT professionals, who use it for application deployment, updates to workstations and servers, cloud provisioning, configuration management, intra-service orchestration, and almost any activity that system administrators do every hour, every day, or every week
keywords: ansible, python, ssh, openssh, server, key, remote, freebsd, install, keygen
---

Ansible is a software that provides simple yet powerful automation for computer support with a wide range of operating systems. This software is primarily aimed at IT professionals, who use it for application deployment, updates to workstations and servers, cloud provisioning, configuration management, intra-service orchestration, and almost any activity that system administrators do every hour, every day, or every week. Ansible does not rely on agent software and does not have additional security infrastructure, making it easy to deploy.

For example, you have 100 servers and you need to install the same configuration (Apache, postgres, redis, mongodb). With this tool, it takes very little time. No need to connect to each server, install and configure the configuration for each program. Just write a script and it will do it all for you, on all servers.

There are many actions in the work of a system administrator that can be automated using special configuration management system software. One of them is Ansible, with which you can automate the installation and configuration of software on any number of machines.

In this article I will show you how to use Ansible to launch infrastructure components, as well as for some everyday tasks.


## 1. System Specification
- OS: FreeBSD 13.2
- Hostname: ns6
- IP Address: 192.168.5.2
- Ansible version: py39-ansible-8.2.0
- Username: ansible

## 2. Why use Ansible

Ansible is a cross-platform software, so it can be installed on almost all operating systems such as FreeBSD, Windows, Linux, and MacOS. This software has many advantages:
- Ease of use. Just one master node, from which the configuration will be launched in the YAML markup language. No need to install third-party agents or software, the SSH protocol is used to connect to remote hosts.
- Many available modules. Ansible is equipped with various modules that allow you to perform certain actions on the server, interact with the operating system, configure the network, work with files, users, and special access rights.
- Security, can use the SSH protocol, so no additional steps are required.

## 3. Ansible Ports and PKG
On FreeBSD, Ansible installation can be done with `PKG packages and system ports`. We will combine both, to install Ansible dependencies use PKG and to install Ansible use system ports. Here is a script to install Ansible dependencies.
```console
root@ns6:~ # pkg install python39 ansible-sshjail py39-setuptools py39-ansible-compat py39-ansible-core py39-ansible-iocage py39-ansible-runner
```
Use the FreeBSD system ports to install Ansible.
```console
root@ns6:~ # cd /usr/ports/sysutils/ansible
root@ns6:/usr/ports/sysutils/ansible # make config
root@ns6:/usr/ports/sysutils/ansible # make install clean
```
Installing Ansible with the ports system is highly recommended, as all library files will be included during the installation process.

Once Ansible is installed on your FreeBSD system, we can proceed by creating a folder `/usr/local/etc/ansible`, and creating files named `ansible.cfg` and `"hosts"` in that folder.
```console
root@ns6:~ # mkdir -p /usr/local/etc/ansible
root@ns6:~ # touch /usr/local/etc/ansible/ansible.cfg
root@ns6:~ # touch /usr/local/etc/ansible/hosts
root@ns6:~ # chmod +x /usr/local/etc/ansible/
```
Type the script below in the file `/usr/local/etc/ansible/ansible.cfg`.
```console
root@ns6:~ # ee /usr/local/etc/ansible/ansible.cfg
[defaults]
inventory = hosts
remote_user=ansible
```
and the file `/usr/local/etc/ansible/hosts`.
```console
root@ns6:~ # ee /usr/local/etc/ansible/hosts
[mybsdhosts]
ns6 ansible_python_interpreter=/usr/local/bin/python
#mediatama ansible_python_interpreter=/usr/local/bin/python
```


## 4. Create SSH User and authorized_keys

In point 3 we will create a user that can access Ansible. In this example our user is named "ansible", but you can choose whatever you want. I will show you how to add a user in FreeBSD. To learn more about point 3, you can read the previous article.

<br/>

<div align="center">

💻[How to Configure OpenSSH Server on FreeBSD How to Create User and Group on FreeBSD](https://unixwinbsd.site/en/freebsd/2025/04/16/configuration-openssh-install-freebsd/)💻

</div>
<br/>


```console
root@ns6:~ # adduser
Username: ansible
Full name: ansible python
Uid (Leave empty for default):
Login group [ansible]:
Login group is ansible. Invite ansible into other groups? []:
Login class [default]:
Shell (sh csh tcsh git-shell bash rbash nologin) [sh]:
Home directory [/home/ansible]:
Home directory permissions (Leave empty for default):
Use password-based authentication? [yes]:
Use an empty password? (yes/no) [no]:
Use a random password? (yes/no) [no]:
Enter password: router2
Enter password again: router2
Lock out the account after creation? [no]:
Username   : ansible
Password   : *****
Full Name  : ansible python
Uid        : 1002
Class      :
Groups     : ansible
Home       : /home/ansible
Home Mode  :
Shell      : /bin/sh
Locked     : no
OK? (yes/no): yes
adduser: INFO: Successfully added (ansible) to the user database.
Add another user? (yes/no): no
Goodbye!
```
Now, perform a SSH connection test on the ansible user.
```console
root@ns6:~ # ssh ansible@192.168.5.2
(ansible@192.168.5.2) Password: router2
ansible@ns6:~ $
```
**Success!**
We were able to log in to the system without having to enter a passphrase.

Ansible can issue ad-hoc commands from the command line to remote systems. A simple example to demonstrate Ansible’s functionality is to use the ping module to verify that the target system is responding:

Next, create a public SSH key `authorized_keys` for the **"ansible"** user.
```console
ansible@ns6:~ $ mkdir .ssh
ansible@ns6:~ $ cd .ssh
ansible@ns6:~/.ssh $ ssh-keygen -t rsa
Generating public/private ed25519 key pair.
Enter passphrase (empty for no passphrase): router1
Enter same passphrase again: router1
Your identification has been saved in ansible
Your public key has been saved in ansible.pub
The key fingerprint is:
SHA256:Pa5Geb77fWsdOW8ss8D5UIDcPaXntG++q0kimfchlTk ansible@ns6
The key's randomart image is:
+--[ED25519 256]--+
|                .|
|         . o . o |
|          o o + o|
|         .   .o=.|
|        S.o  E..o|
|        o.+o.o.+.|
|       . *.+=o .B|
|        ..+ ===+*|
|       .. o+.+*X=|
+----[SHA256]-----+
ansible@ns6:~/.ssh $
```
```console
ansible@ns6:~/.ssh $ cat ~/.ssh/id_rsa.pub | ssh ansible@192.168.5.2 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
The authenticity of host '192.168.5.2 (192.168.5.2)' can't be established.
ED25519 key fingerprint is SHA256:WpdCFPbgIgcvkDmCr8Cw1XWvU9Yej73honnnS34YsP8.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.5.2' (ED25519) to the list of known hosts.
(ansible@192.168.5.2) Password: router2
ansible@ns6:~/.ssh $
```
Then, we use `ssh-add` to add the private key identity to the authentication agent.
```console
ansible@ns6:~/.ssh $ ssh-agent sh -c 'ssh-add /usr/home/ansible/.ssh/id_rsa'
Enter passphrase for /usr/home/ansible/.ssh/id_rsa: router1
Identity added: /usr/home/ansible/.ssh/id_rsa (ansible@ns6)
ansible@ns6:~/.ssh $
```
Next I made a permit.
```console
ansible@ns6:~ $ chown -R ansible:ansible /usr/home/ansible/.ssh
ansible@ns6:~ $ chmod 0700 /usr/home/ansible/.ssh
ansible@ns6:~ $ chmod 0600 /usr/home/ansible/.ssh/authorized_keys
```

## 5. Ansible Bootstrap Python

As we know, the only requirement on the target machine is a modern version of python installed on the FreeBSD system. However, what if that version of python is not installed on the target machine? You can do it manually on some machines, but what if you have many target servers that do not have python installed on each machine?.

To solve this chicken and egg problem, we can use a different method to run the command. This is called raw mode and does not have any abstraction, instead using literal commands:
```console
ansible@ns6:~/.ssh $ ansible all -m ping
The authenticity of host 'ns6 (192.168.5.2)' can't be established.
ED25519 key fingerprint is SHA256:WpdCFPbgIgcvkDmCr8Cw1XWvU9Yej73honnnS34YsP8.
This host key is known by the following other names/addresses:
    ~/.ssh/known_hosts:1: 192.168.5.2
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Enter passphrase for key '/home/ansible/.ssh/id_rsa': router1
ns6 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
ansible@ns6:~/.ssh $
```
Once the command is successfully executed, Ansible is fully ready and can use other modes, modules, and playbooks. To ensure communication between the control and target machines is encrypted, we set up SSH and exchange public keys for passwordless login.

A common task is to transfer files from a local system to a remote system. This includes configuration files, templates, or other data of any kind. Ansible can perform SCP (secure copy) of files in parallel to multiple machines. The copy module requires a source and a destination as parameters.
```console
ansible@ns6:~ $ ansible ns6 -m copy -a "src=/usr/local/etc/ansible/hosts dest=/usr/home/ansible"
BECOME password: router1
ns6 | CHANGED => {
    "changed": true,
    "checksum": "9186f375eff9eb4b884c50f157e5d9973db8002b",
    "dest": "/usr/home/ansible/hosts",
    "gid": 1002,
    "group": "ansible",
    "md5sum": "aff4eaca42fb7821d748b4b2b98f8d75",
    "mode": "0644",
    "owner": "ansible",
    "size": 529,
    "src": "/home/ansible/.ansible/tmp/ansible-tmp-1701429314.8753471-2935-107761807460326/source",
    "state": "file",
    "uid": 1002
}
ansible@ns6:~ $
```
There are many other useful things related to Ansible that are not even considered in this post. I encourage you to check out the Ansible documentation as it is quite comprehensive and easy to understand, and details the true capabilities of the Ansible automation framework.

Additionally, having patterns and standards related to how to structure Ansible playbooks, share code, audit actions, etc. is critical to ensuring the integrity of your Ansible resources and the cleanliness of your code. Code organization, host grouping, and least privilege access are just a few components that will be critical to mass adoption of the Ansible framework while also being able to maintain the integrity of your environment.

