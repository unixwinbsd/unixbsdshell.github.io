---
title: How to Connect FreeBSD to Windows with Samba
date: "2025-05-04 10:11:15 +0100"
updated: "2025-05-04 10:11:15 +0100"
id: connect-freebsd-windows-with-samba
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: https://www.opencode.net/unixbsdshell/web-static-ruby-rails-on-freebsd/-/raw/main/img/FreeBSD_Samba_Windows_diagram.jpg
toc: true
comments: true
published: true
excerpt: If you usually work with Windows and want to share files or documents over a local network, or you just want files or documents to be accessible by all computers, FreeBSD and Samba are a good choice.
keywords: samba, server, client, freebsd, windows, connect, ip firewall, packet filter, firewall, ip address
---

Do you have multiple devices in your office, company, home, school, or elsewhere? How do you transfer data between computers? How do you transfer data between computers? Do you use flash drives or SD cards to transfer data between computers? This question arises when you work with multiple computers in one place.

Samba is the answer, with Samba all your work can be completed easily in one network. You don't need to waste valuable time when transferring files, documents, and other large items quickly and easily, over a local network. This is a one-time setup, and then with a few clicks of the mouse you can share files between computers.

If you usually work with Windows and want to share files or documents over a local network, or you just want files or documents to be accessible to all computers, FreeBSD and Samba are the right choices. You can use the FreeBSD server as a gateway so that files or documents can be accessed by multiple computers.

The image below explains the process of connecting files or documents between FreeBSD (samba) and Windows.<br/>


![FreeBSD Samba Windows diagram](https://www.opencode.net/unixbsdshell/web-static-ruby-rails-on-freebsd/-/raw/main/img/FreeBSD_Samba_Windows_diagram.jpg)

Every user who wants to access a file or document must log in and depend on the access rights they have. Users who successfully log in can read, create, or change files from the computer they are working on.

Access to the Samba server can also be done without a password, so everyone can access it. Although not recommended, some people really need it. For example, if you need to open access very quickly and do not have time to set up limited access. It is highly recommended that every user use a password to log in, this is to protect data or documents from being opened by anyone.

## ⭐ 1. Samba Server Specifications

👉🏻 OS: FreeBSD 13.2

👉🏻 Hostname: ns3

👉🏻 IP Address: 192.168.5.2

👉🏻 interfaces = nfe0

👉🏻 Samba Version: samba416

👉🏻 Python Version: python39

👉🏻 Dependencies: p5-Parse-Yapp, libiconv, curl, py-wsdd

## ⭐ 2. Installation Preparation
Before we start installing Samba, we must first install the dependencies required by Samba. The goal is for the Samba server to run normally. There are several dependencies that you must install, but the most important are Python39, p5-Parse-Yapp, libiconv, py-wsdd. Other dependencies are usually installed automatically.

```console
root@ns3:~ # pkg install python39 p5-Parse-Yapp libiconv net/py-wsdd
```

Once the above dependencies are installed, proceed with installing Samba. In this article we will use the ports system to install Samba.

```console
root@ns3:~ # cd /usr/ports/net/samba416
root@ns3:/usr/ports/net/samba416 # make config
```

When you run the "make config" command, the Samba options menu will appear. You must check the "PYTHON3" option. See the image below.


![menuoptionsamba](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/1Menu%20options%20at%20Samba.jpg&commit=4981d708c82ac7e89ba720be8c41d62d320e60a4)

After that, you continue with the command "make install clean".

```
root@ns3:/usr/ports/net/samba416 # make install clean
```

Create a Start Up script rc.d, so that the Samba server can run automatically. Open the "/etc/rc.conf" file and type the script below into the `"/etc/rc.conf"` file.

```
samba_server_enable="YES"
nmbd_enable="YES"
smbd_enable="YES"
winbindd_enable="YES"
samba_server_config="/usr/local/etc/smb4.conf"
wsdd_enable="YES"
```

At the end of the installation, the net/samba416 port does not include the "smb4.conf" configuration file required to run Samba, so we will create the "smb4.conf" file. To make it easier to write the /m file script, we will create a two-part script.
- Global Settings.
- Share Definitions.

The following is an example of a complete "/usr/local/etc/smb4.conf" script. Adjust it according to the specifications of your Samba server computer.

```console
#======================= Global Settings =====================================
[global]

workgroup = WORKGROUP
server string = FreeBSD %v (%h)
server role = standalone server
hosts allow = 192.168.5. 127.
;  guest account = pcguest
log file = /usr/local/samba/var/log.%m
log level = 1
max log size = 50
;  realm = MY_REALM
passdb backend = tdbsam
bind interfaces only = yes
#interfaces = nfe0 lo0
interfaces = 192.168.5.0/24 127.0.0.1
wins support = no
wins server = 192.168.5.2
local master = yes
preferred master = yes

#============================ Share Definitions ==============================
[Personal]
   comment = Home Folder
   browseable = yes
   writeable = yes
   valid users = %U
   create mode = 0644
   directory mode = 0755
   path = /usr/local/etc/sambashare/personal
   guest ok = no

[Public]
   comment = Public Folder
   path = /usr/local/etc/sambashare/public
   browseable = yes
   writeable = yes
   guest ok = no
   create mode = 0664
   directory mode = 0775
   valid users = %U

[Shared] 
   comment = Shared Folder
   path = /usr/local/etc/sambashare/shared
   browseable = yes
   writeable = yes
   guest ok = no
   create mode = 0666
   directory mode = 0777
   valid users = %U

[Guest] 
   comment = Guest Folder
   path = /usr/local/etc/sambashare/guest
   browseable = yes
   writeable = yes
   guest ok = no
   create mode = 0666
   directory mode = 0777
   valid users = %U
```

## ⭐ 3. Configuration Preparation
This process is an integral part of the installation process. The first step we must do after having the "smb4.conf" configuration file is to create a directory.

```console
root@ns3:~ # mkdir -p /usr/local/etc/sambashare/personal
root@ns3:~ # mkdir -p /usr/local/etc/sambashare/public
root@ns3:~ # mkdir -p /usr/local/etc/sambashare/shared
root@ns3:~ # mkdir -p /usr/local/etc/sambashare/guest
```

After that, run the `"chmod"` command, this command is used to give access rights/permissions to the owner, regular users, and non-users. We follow the script from the `"smb4.conf"` file.

```console
root@ns3:~ # chmod 775 /usr/local/etc/sambashare/personal
root@ns3:~ # chmod 775 /usr/local/etc/sambashare/public
root@ns3:~ # chmod 777 /usr/local/etc/sambashare/shared
root@ns3:~ # chmod 777 /usr/local/etc/sambashare/guest
```

The next step is to edit the file "/boot/loader.conf", and enter the script below.

```
smbfs_load="YES"
```

To secure the shared data or documents, we create a user and password. With a user and password, not everyone can access the file or document.

```console
root@ns3:~ # pw add group samba
root@ns3:~ # pw add group freebsd
```

The above script is used to create a group named "samba". Once you have created the group, proceed to create users. In this example, we will create 3 users, John, Mary, and Peter who are in the Samba group.

```console
root@ns3:~ # pw add user -n john -g samba -s /sbin/nologin -c "samba john"
root@ns3:~ # pw add user -n mary -g samba -s /sbin/nologin -c "samba mary"
root@ns3:~ # pw add user -n peter -g samba -s /sbin/nologin -c "samba peter"
root@ns3:~ # pw add user -n jackson -g freebsd -s /sbin/nologin -c "samba guest"
```

Provide a password for each user.

```console
root@ns3:~ # pdbedit -a -u john -f "john chaplin"
root@ns3:~ # pdbedit -a -u mary -f "mary rose"
root@ns3:~ # pdbedit -a -u peter -f "peter joe"
root@ns3:~ # pdbedit -a -u jackson -f "jackson samba"
```

To make it easier for you, look at the image below.
<br/><br/>
![create samba user and group in freebsd](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/2create%20samba%20user%20and%20group%20in%20freebsd.jpg&commit=25cf1420a6974d84480df842bcd5bc233ce5c64a)

Confused? Now, let's continue with the chown command. This command is used to change the ownership of a file or directory.

```console
root@ns3:~ # chown -R john:samba /usr/local/etc/sambashare/shared
root@ns3:~ # chown -R mary:samba /usr/local/etc/sambashare/public
root@ns3:~ # chown -R peter:samba /usr/local/etc/sambashare/personal
root@ns3:~ # chown -R jackson:freebsd /usr/local/etc/sambashare/guest
```

Next step, Run the Samba server.

```console
root@ns3:~ # service samba_server restart
```

## ⭐ 4. Windows Configuration
In this step we will start the configuration in the Windows system environment. Open "C:\Windows\System32\drivers\etc", after that you enter the script below.

```
192.168.5.2    ns3
```

In the Samba application that we are studying, FreeBSD is the Samba server and Windows is the Samba client. So all files or documents that you want to share must be placed on the FreeBSD server. Every user who wants to use the file or document can only access it through Windows. In large environments such as schools, hospitals, or companies, a network administrator is needed to manage access rights to files or documents that are shared or can be accessed by users.

You copy all files or documents to the FreeBSD server according to the user's access rights. After that run `"chmod"`, as in the example below.

```console
root@ns3:~ # chmod 644 /usr/local/etc/sambashare/shared/*
root@ns3:~ # chmod 644 /usr/local/etc/sambashare/public/*
root@ns3:~ # chmod 666 /usr/local/etc/sambashare/personal/*
root@ns3:~ # chmod 666 /usr/local/etc/sambashare/guest/*
```

Run the above command, every time a file or document is added to the FreeBSD server.

Any user who wants to access the file or document can run it through Windows Explorer. Okay, let's start trying the Samba application on a Windows client. Open Windows Explorer and type `"\\192.168.5.2\personal"` or `"\\ns3\personal"`.

![samba server test](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/3Samba%20Test%20Windows.jpg&commit=8ce6e31f726c54a470f093a93a8cc8d9bef3a005)
<br/> <br/>

![sama test on windows](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/4%20Samba%20Test%20on%20Windows.jpg&commit=2772e127db4be183546b023aefb63215a7faac94)
<br/> <br/>

To delete a connection to a Samba server on Windows, run `"cmd"`, and type the command `"net use * /delete"`.

![samba delete connection](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/5Delete%20connection.jpg&commit=745cfe26a72e96c49cf8d90726ad5f86903c3203)

You can also try the below command in `"cmd"` shell.

```yaml
C:\Users\blogspot>net use \delete \\192.168.5.2\personal
C:\Users\blogspot>net use \delete \\192.168.5.2\public
C:\Users\blogspot>net use \delete \\ns3
```

Samba has many functions and uses. So, you have to try a lot on your FreeBSD server and also read many Samba tutorial articles on the Google search engine. The discussion in this article is only part of learning Samba. However, the installation and configuration process is almost the same if you want to combine it with a DHCP server or DNS Bind.
