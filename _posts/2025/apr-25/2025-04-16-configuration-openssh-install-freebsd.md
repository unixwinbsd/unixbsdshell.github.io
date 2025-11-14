---
title: How to Configure OpenSSH Server on FreeBSD
date: "2025-04-16 08:21:11 +0100"
updated: "2025-04-16 08:21:11 +0100"
id: configuration-openssh-install-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: OpenSSH is a set of open source utilities that implements the SSH (Secure Shell) protocol. SSH is a secure version of telnet. SSH provides administrators and users with access to remote systems as if they were physically present at the console. SSH uses encryption to prevent eavesdropping on the connection made between the client and server
keywords: ssh, openssh, server, key, remote, freebsd, install, keygen
---

OpenSSH is a set of open source utilities that implements the SSH (Secure Shell) protocol. SSH is a secure version of telnet. SSH provides administrators and users with access to remote systems as if they were physically present at the console. SSH uses encryption to prevent eavesdropping on the connection made between the client and server. OpenSSH has 87 percent of the remote console market. OpenSSH is very practical and can be applied to all Linux and BSD distributions, as well as Apple Mac OS.

The SSH protocol was first developed in 1995 by Tatu Ylonen, a researcher at the Helsinki University of Technology. Ylonen founded SSH Communications Security in late 1995 to develop and market SSH. His company currently markets the SSH Server/Client Tectia. OpenSSH was originally created by the OpenBSD team as part of the OpenBSD 2.6 release in December 1999.

The team used code from Tatu Ylonen's SSH project, which was originally open source. Bug fixes and feature additions were made to the OpenSSH release. Soon after the release of OpenSSH, its developers decided to split into two teams.

One group concentrated on developing OpenSSH for OpenBSD while the other group developed a portable version of OpenSSH for use on other platforms. The portable edition has a P appended to it to indicate this. OpenSSH continues to be developed by the OpenBSD team led by its founder, Theo de Raadt.


In this article, we will explain about OpenSSH, specifically related to installing and configuring OpenSSH on FreeBSD system. OpenSSH is part of the standard FreeBSD distribution. In this article, we will replace the base version with a newer version of OpenSSH taken from the FreeBSD ports collection. To start the OpenSSH installation process, type the following command line.


```console
root@ns1:~ # cd /usr/ports/security/openssh-portable
root@ns1:/usr/ports/security/openssh-portable # make -D WITH_OVERWRITE_BASE install clean
```
Once the installation is complete, it's time to configure OpenSSH for use on your FreeBSD system. Add the `"NO_OPENSSH = YES"` script to the `/etc/make.conf` file in `/etc`. This script is useful for telling make not to build a base version of OpenSSH and preventing the system from downgrading to an older base version of OpenSSH.

```console
root@ns1:/usr/ports/security/openssh-portable # echo "NO_OPENSSH = YES" >> /etc/make.conf
```
The next step is to delete the FreeBSD system's default SSH folder, namely the `/etc/ssh` folder, then we replace it with a symlink from the folder in "/usr/local/etc/ssh".

```console
root@ns1:/usr/ports/security/openssh-portable # rm -rf /etc/ssh
root@ns1:/usr/ports/security/openssh-portable # ln -s /usr/local/etc/ssh /etc
```
After the symlink creation process is complete, we continue by creating the Startup rc.d script, which is used to start the OpenSSH Server automatically when the computer is turned on. To create the Startup rc.d, we edit the `/etc/rc.conf` file and add the following script to the `/etc/rc.conf` file.

```console
root@ns1:/usr/ports/security/openssh-portable # ee /etc/rc.conf
sshd_enable="NO"
openssh_enable="YES"
openssh_flags=""
openssh_pidfile="/var/run/sshd.pid"
```
Next we edit the SSH configuration file, namely the `/usr/local/etc/ssh/sshd_config` file.

```console
root@ns1:~ # cd /usr/local/etc/ssh
root@ns1:/usr/local/etc/ssh # ee sshd_config

#	$OpenBSD: sshd_config,v 1.104 2021/07/02 05:11:21 dtucker Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/bin:/bin:/usr/sbin:/sbin
# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.
# Note that some of FreeBSD's defaults differ from OpenBSD's, and
# FreeBSD has a few additional options.

Port 22
#AddressFamily any
ListenAddress 192.168.5.2
#ListenAddress ::
##AllowUsers udin@192.168.5.2

HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key
HostKey /etc/ssh/ssh_host_ed25519_key

# Ciphers and keying
#RekeyLimit default none

# Logging
#SyslogFacility AUTH
LogLevel VERBOSE
# Authentication:

#LoginGraceTime 2m
PermitRootLogin yes
StrictModes yes
MaxAuthTries 6
#MaxSessions 10

#PubkeyAuthentication yes
# The default is to check both .ssh/authorized_keys and .ssh/authorized_keys2
# but this is overridden so installations will only check .ssh/authorized_keys
AuthorizedKeysFile	.ssh/authorized_keys

#AuthorizedPrincipalsFile none

#AuthorizedKeysCommand none
#AuthorizedKeysCommandUser nobody

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
IgnoreRhosts yes

# Change to yes to enable built-in password authentication.
# Note that passwords may also be accepted via KbdInteractiveAuthentication.
PasswordAuthentication yes
PermitEmptyPasswords no

# Change to no to disable PAM authentication
#KbdInteractiveAuthentication yes

# Kerberos options
#KerberosAuthentication no
#KerberosOrLocalPasswd yes
#KerberosTicketCleanup yes
#KerberosGetAFSToken no

# GSSAPI options
#GSSAPIAuthentication no
#GSSAPICleanupCredentials yes

# Set this to 'no' to disable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the KbdInteractiveAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via KbdInteractiveAuthentication may bypass
# the setting of "PermitRootLogin prohibit-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and KbdInteractiveAuthentication to 'no'.
#UsePAM yes

AllowAgentForwarding yes
AllowTcpForwarding yes
#GatewayPorts no
#X11Forwarding yes
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
PrintMotd yes
#PrintLastLog yes
TCPKeepAlive yes
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#UseDNS yes
#PidFile /var/run/sshd.pid
#MaxStartups 10:30:100
#PermitTunnel no
#ChrootDirectory /usr/local/etc/ssh
#UseBlacklist no
#VersionAddendum FreeBSD-20230316

# no default banner path
#Banner none
Banner /usr/local/etc/ssh/banner
# override default of no subsystems
Subsystem	sftp	/usr/libexec/sftp-server

# Example of overriding settings on a per-user basis
#Match User anoncvs
#	X11Forwarding no
#	AllowTcpForwarding no
#	PermitTTY no
#	ForceCommand cvs server
```
In the above script OpenSSH runs on `port 22` and uses our FreeBSD server's internal/private IP address, which is `192.168.5.2`.


## 1. Creating OpenSSH Keys

SSH servers authenticate clients using a number of different techniques. The most commonly used authentication mechanisms are passwords and SSH keys. While passwords provide protection against unauthorized access, SSH keys are by far the most secure. The problem with passwords is that they are often created manually and are not long enough and complex enough.

Therefore, hacker attacks can compromise their security. SSH keys provide a consistently secure option. Each SSH key pair consists of a private key and a matching public key, and can be used in place of a password for authentication. Follow the steps below to create OpenSSH keys.


```console
root@ns1:~ # ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa):  tekan ENTER
Created directory '/root/.ssh'.
Enter passphrase (empty for no passphrase): masukkan password
Enter same passphrase again:  masukkan password
Your identification has been saved in /root/.ssh/id_rsa
Your public key has been saved in /root/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:0RflgIyj4gSxDsASSTM3UQsMgYLDO2GYm8lnejbNbXY root@router2
The key's randomart image is:
+---[RSA 3072]----+
|XX=*o.   o .o..  |
|@==oo . o.o  +   |
|*=+. . .... . .  |
|+* oo .  . .     |
|  *oo.. S        |
| . +.o + E       |
|  o . o .        |
|                 |
|                 |
+----[SHA256]-----+
```

The script command above will create a new folder `/root/.ssh`, which contains the `id_rsa` file (private key) and the `id_rsa.pub` file (public key). Once the key creation is complete, proceed to install the public SSH key used for the remote console.

```console
root@ns1:~ # cat ~/.ssh/id_rsa.pub | ssh root@ns1.unixexplore.com "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
The authenticity of host 'router2.unixexplore.com (192.168.9.3)' can't be established.
ED25519 key fingerprint is SHA256:cUadBvuFWb38iZ0cdUR8NtkOehQg8vZ3Vh7MWUTaXI0.
This host key is known by the following other names/addresses:
    ~/.ssh/known_hosts:1: router2
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'router2.unixexplore.com' (ED25519) to the list of known hosts.
                                                               #####
                                                                #######
                   #                                            ##O#O##
  ######          ###                                           #VVVVV#
    ##             #                                          ##  VVV  ##
    ##         ###    ### ####   ###    ###  ##### #####     #          ##
    ##        #  ##    ###    ##  ##     ##    ##   ##      #            ##
    ##       #   ##    ##     ##  ##     ##      ###        #            ###
    ##          ###    ##     ##  ##     ##      ###       QQ#           ##Q
    ##       # ###     ##     ##  ##     ##     ## ##    QQQQQQ#       #QQQQQQ
    ##      ## ### #   ##     ##  ###   ###    ##   ##   QQQQQQQ#     #QQQQQQQ
  ############  ###   ####   ####   #### ### ##### #####   QQQQQ#######QQQQQ
(root@ns1.unixexplore.com) Password for root@router2:  ketikkan password root
root@ns1:~ #
```
The next step is to connect the SSH server using the private key, here is a sample script.

```console
root@ns1:~ # ssh -i ~/.ssh/id_rsa -p 22 root@ns1.unixexplore.com
                                                               #####
                                                                #######
                   #                                            ##O#O##
  ######          ###                                           #VVVVV#
    ##             #                                          ##  VVV  ##
    ##         ###    ### ####   ###    ###  ##### #####     #          ##
    ##        #  ##    ###    ##  ##     ##    ##   ##      #            ##
    ##       #   ##    ##     ##  ##     ##      ###        #            ###
    ##          ###    ##     ##  ##     ##      ###       QQ#           ##Q
    ##       # ###     ##     ##  ##     ##     ## ##    QQQQQQ#       #QQQQQQ
    ##      ## ### #   ##     ##  ###   ###    ##   ##   QQQQQQQ#     #QQQQQQQ
  ############  ###   ####   ####   #### ### ##### #####   QQQQQ#######QQQQQ
Enter passphrase for key '/root/.ssh/id_rsa': masukkan password
```

If a passphrase is used, the user will be prompted every time a connection is made to the server. You can use ssh-agent and ssh-add to load SSH keys into memory and eliminate the need to enter the passphrase every time. ssh-agent handles authentication using the private key entered into it. ssh-agent can be used to run a shell or window manager, among other applications.

To use ssh-agent in a shell, pass it the shell as a command parameter. Add an identity by running ssh-add and passing it the private key passphrase. The user will then be able to ssh to any host with the public key attached.


```console
root@ns1:~ # ssh-agent csh
root@ns1:~ # ssh-add
Enter passphrase for /root/.ssh/id_rsa: masukkan kata sandi
Identity added: /root/.ssh/id_rsa (root@ns1)
```
After the OpenSSH key is created, continue by creating the OpenSSH Banner file. We name the Banner file `"banner"` and place it in the `/usr/local/etc/ssh` folder and in the `/usr/local/etc/ssh/banner` file we insert the script below.

```console
root@ns1:~ # touch /usr/local/etc/ssh/banner
root@ns1:~ # ee /usr/local/etc/ssh/banner
                                                               #####
                                                                #######
                   #                                            ##O#O##
  ######          ###                                           #VVVVV#
    ##             #                                          ##  VVV  ##
    ##         ###    ### ####   ###    ###  ##### #####     #          ##
    ##        #  ##    ###    ##  ##     ##    ##   ##      #            ##
    ##       #   ##    ##     ##  ##     ##      ###        #            ###
    ##          ###    ##     ##  ##     ##      ###       QQ#           ##Q
    ##       # ###     ##     ##  ##     ##     ## ##    QQQQQQ#       #QQQQQQ
    ##      ## ### #   ##     ##  ###   ###    ##   ##   QQQQQQQ#     #QQQQQQQ
  ############  ###   ####   ####   #### ### ##### #####   QQQQQ#######QQQQQ
```
Now enable the OpenSSH server, is it running or not?.

```console
root@ns1:~ # service openssh restart
Performing sanity check on openssh configuration.
Stopping openssh.
Waiting for PIDS: 2481.
Performing sanity check on openssh configuration.
Starting openssh.
root@ns1:~ #
```
If it looks like the one above, then the OpenSSH server is running properly.


## 2. Log In With Multi User

One of the advantages of the FreeBSD server is that it can create many users and groups. Each user can connect to the OpenSSH server and can access the FreeBSD system. We do not explain how to create users and groups in this article, you can read the previous article that discusses the technique of creating users and groups in FreeBSD.

In this article we assume the FreeBSD server has users and groups with the following names:


User Name                   User Password
udin                                routerudin
anto                                routeranto
jaka                                routerjaka
sari                                 routersari

Let's give an example, for example user Udin wants to access the OpenSSH server, use the following script.

```console
root@ns1:~ # ssh udin@ns1.unixexplore.com
                                                              #####
                                                                #######
                   #                                            ##O#O##
  ######          ###                                           #VVVVV#
    ##             #                                          ##  VVV  ##
    ##         ###    ### ####   ###    ###  ##### #####     #          ##
    ##        #  ##    ###    ##  ##     ##    ##   ##      #            ##
    ##       #   ##    ##     ##  ##     ##      ###        #            ###
    ##          ###    ##     ##  ##     ##      ###       QQ#           ##Q
    ##       # ###     ##     ##  ##     ##     ## ##    QQQQQQ#       #QQQQQQ
    ##      ## ### #   ##     ##  ###   ###    ##   ##   QQQQQQQ#     #QQQQQQQ
  ############  ###   ####   ####   #### ### ##### #####   QQQQQ#######QQQQQ
(udin@ns1.unixexplore.com) Password for udin@ns1: masukkan password user udin
Last login: Tue Oct 31 21:03:02 2023 from 192.168.5.2
FreeBSD 13.2-RELEASE releng/13.2-n254617-525ecfdad597 GENERIC

Welcome to FreeBSD!

Release Notes, Errata: https://www.FreeBSD.org/releases/
Security Advisories:   https://www.FreeBSD.org/security/
FreeBSD Handbook:      https://www.FreeBSD.org/handbook/
FreeBSD FAQ:           https://www.FreeBSD.org/faq/
Questions List:        https://www.FreeBSD.org/lists/questions/
FreeBSD Forums:        https://forums.FreeBSD.org/

Documents installed with the system are in the /usr/local/share/doc/freebsd/
directory, or can be installed later with:  pkg install en-freebsd-doc
For other languages, replace "en" with a language code like de or fr.

Show the version of FreeBSD installed:  freebsd-version ; uname -a
Please include that output and any error messages when posting questions.
Introduction to manual pages:  man man
FreeBSD directory layout:      man hier

To change this login announcement, see motd(5).
sh (the default Bourne shell in FreeBSD) supports command-line editing.  Just
``set -o emacs'' or ``set -o vi'' to enable it. Use "<TAB>" key to complete
paths.
udin@ns1:~ $
```
Now let's try again with the username anto. In this example, the username Anto wants to access the SSH server. Here is an example.

```console
udin@ns1:~ $ ssh anto@192.168.5.2
                                                              #####
                                                                #######
                   #                                            ##O#O##
  ######          ###                                           #VVVVV#
    ##             #                                          ##  VVV  ##
    ##         ###    ### ####   ###    ###  ##### #####     #          ##
    ##        #  ##    ###    ##  ##     ##    ##   ##      #            ##
    ##       #   ##    ##     ##  ##     ##      ###        #            ###
    ##          ###    ##     ##  ##     ##      ###       QQ#           ##Q
    ##       # ###     ##     ##  ##     ##     ## ##    QQQQQQ#       #QQQQQQ
    ##      ## ### #   ##     ##  ###   ###    ##   ##   QQQQQQQ#     #QQQQQQQ
  ############  ###   ####   ####   #### ### ##### #####   QQQQQ#######QQQQQ
(anto@192.168.5.2) Password for anto@ns1: masukkan password username anto
Last login: Tue Oct 31 21:01:35 2023 from 192.168.5.2
FreeBSD 13.2-RELEASE releng/13.2-n254617-525ecfdad597 GENERIC

Welcome to FreeBSD!

Release Notes, Errata: https://www.FreeBSD.org/releases/
Security Advisories:   https://www.FreeBSD.org/security/
FreeBSD Handbook:      https://www.FreeBSD.org/handbook/
FreeBSD FAQ:           https://www.FreeBSD.org/faq/
Questions List:        https://www.FreeBSD.org/lists/questions/
FreeBSD Forums:        https://forums.FreeBSD.org/

Documents installed with the system are in the /usr/local/share/doc/freebsd/
directory, or can be installed later with:  pkg install en-freebsd-doc
For other languages, replace "en" with a language code like de or fr.

Show the version of FreeBSD installed:  freebsd-version ; uname -a
Please include that output and any error messages when posting questions.
Introduction to manual pages:  man man
FreeBSD directory layout:      man hier

To change this login announcement, see motd(5).
Need to see the calendar for this month? Simply type "cal".  To see the
whole year, type "cal -y".
                -- Dru <genesis@istar.ca>
anto@ns1:~ $
```
Another example, we will use the root user to access the OpenSSH server.

```console
anto@ns1:~ $ ssh root@192.168.5.2
                                                              #####
                                                                #######
                   #                                            ##O#O##
  ######          ###                                           #VVVVV#
    ##             #                                          ##  VVV  ##
    ##         ###    ### ####   ###    ###  ##### #####     #          ##
    ##        #  ##    ###    ##  ##     ##    ##   ##      #            ##
    ##       #   ##    ##     ##  ##     ##      ###        #            ###
    ##          ###    ##     ##  ##     ##      ###       QQ#           ##Q
    ##       # ###     ##     ##  ##     ##     ## ##    QQQQQQ#       #QQQQQQ
    ##      ## ### #   ##     ##  ###   ###    ##   ##   QQQQQQQ#     #QQQQQQQ
  ############  ###   ####   ####   #### ### ##### #####   QQQQQ#######QQQQQ
(root@192.168.5.2) Password for root@ns1: masukkan password username root
Last login: Tue Oct 31 21:03:49 2023 from 192.168.5.2
FreeBSD 13.2-RELEASE releng/13.2-n254617-525ecfdad597 GENERIC

Welcome to FreeBSD!

Release Notes, Errata: https://www.FreeBSD.org/releases/
Security Advisories:   https://www.FreeBSD.org/security/
FreeBSD Handbook:      https://www.FreeBSD.org/handbook/
FreeBSD FAQ:           https://www.FreeBSD.org/faq/
Questions List:        https://www.FreeBSD.org/lists/questions/
FreeBSD Forums:        https://forums.FreeBSD.org/

Documents installed with the system are in the /usr/local/share/doc/freebsd/
directory, or can be installed later with:  pkg install en-freebsd-doc
For other languages, replace "en" with a language code like de or fr.

Show the version of FreeBSD installed:  freebsd-version ; uname -a
Please include that output and any error messages when posting questions.
Introduction to manual pages:  man man
FreeBSD directory layout:      man hier

To change this login announcement, see motd(5).
root@ns1:~ #
```
In the above Log In username script, you see that ns1 is the Host name of our FreeBSD server and unixexplore.com is the Domain name of our FreeBSD server. After reading this article, you can now connect using the ssh command and start a secure remote management session.