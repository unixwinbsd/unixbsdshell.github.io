---
title: Guide to Installing the Anonymous I2P Network on FreeBSD
date: "2025-11-18 09:02:18 +0000"
updated: "2025-11-18 09:02:18 +0000"
id: guide-installing-anonymous-i2p-network-on-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: Anonymous
background: 
toc: true
comments: true
published: true
excerpt: This article attempts to discuss installing and configuring I2P on a FreeBSD machine. The specifications used in this article are as follows.
keywords: i2p, freebsd, openbsd, netbsd, bsd, unix, Anonymous, i2pd, tor, onion, network, installing
---

I2P is the Tor network's twin, but its creators often use the opposite approach to solve the same engineering problems. For greater anonymity, users can choose longer chains and higher traffic delays, as each I2P node is both a client and a server.

I2P is encrypted from everyone on the I2P network, so website owners don't know who is visiting them, and clients don't know who they are actually targeting for internet content.

I2P, also often referred to as the Invisible Internet Project, its scalable, self-organizing network distributes packets among layers of an anonymous network that can run any number of applications while maintaining a high level of security and anonymity.

This article discusses installing and configuring I2P on a FreeBSD machine. The specifications used in this article are as follows.

## A. System Specifications

- Processor: AMD Phenom(tm) II X4 955 Processor (K8-class CPU)
- OS: FreeBSD 13.2 Stable
- IP Server: 192.168.9.3
- Hostname: router2
- Versi I2P: i2p-0.9.48

On FreeBSD, I2P can be installed in two ways: via `FreeBSD Ports and via the PKG package`. We tried both methods:

### a.1. Install melalui FreeBSD Ports

```yml
root@router2:~ # cd /usr/ports/java/openjdk8
root@router2:/usr/ports/java/openjdk8 # make install clean

root@router2:~ # cd /usr/ports/security/i2p
root@router2:/usr/ports/security/i2p # make install clean
```

### a.2. Install melalui Paket PKG

```yml
root@router2:~ # pkg install openjdk8
root@router2:~ # pkg install i2p
```

After the I2P installation is complete, create an `I2P user and group`. The I2P user and group will be located in the `/home/i2p` folder.

```console
root@router2:~ # adduser
Username: i2p
Full name: i2p router
Uid (Leave empty for default): enter
Login group [i2p]: enter
Login group is i2p. Invite i2p into other groups? []: enter
Login class [default]: enter
Shell (sh csh tcsh bash rbash git-shell nologin) [sh]: enter
Home directory [/home/i2p]: enter
Home directory permissions (Leave empty for default): enter
Use password-based authentication? [yes]: no enter
Lock out the account after creation? [no]: enter
Username   : i2p
Password   : <disabled>
Full Name  : i2p router
Uid        : 1002
Class      :
Groups     : i2p
Home       : /home/i2p
Home Mode  :
Shell      : /bin/sh
Locked     : no
OK? (yes/no): yes enter
adduser: INFO: Successfully added (i2p) to the user database.
Add another user? (yes/no): no enter
Goodbye!
root@router2:~ #
```

Now that we have an I2P user/group, next create a startup in the `rc.conf` file, and put the following script into that file.

```console
root@router2:~ # ee /etc/rc.conf
i2p_enable="YES"
i2p_user="i2p"
```

Open the `/usr/local/etc/rc.d` folder and look for the i2p file. Once you find it, open it. Delete the command="/usr/local/sbin/i2prouter" script and replace it with the command="/usr/home/i2p/i2p/runplain.sh" script.

Next, use Putty to open the `/usr/local/sbin` folder. Don't forget to use the su i2p syntax, as otherwise, the i2p program will be installed as root. Keep in mind that the i2p program will not run as root; it can only run under the i2p user and group. Therefore, the i2p syntax is to enter the i2p user and group. Ending with exit will leave the i2p user and group.

```yml
root@router2:~ # su i2p
# cd /usr/local/sbin
# i2prouter install 
# exit
```

The next step is to edit the runplain.sh file in the /usr/home/i2p/i2p folder. Remove or add the "#" at the beginning of the script and add the script I2PTEMP="/usr/home/i2p/i2p". The following is an example of the contents of the runplain.sh script file.

```console
#!/bin/sh

# This runs the router by itself, WITHOUT the wrapper.
# This means the router will not restart if it crashes.
# Also, you will be using the default memory size, which is
# probably not enough for i2p, unless you set it below.
# You should really use the i2prouter script instead.
#

# Paths
# Note that (percent)INSTALL_PATH and (percent)SYSTEM_java_io_tmpdir
# should have been replaced by the izpack installer.
# If you did not run the installer, replace them with the appropriate path.
I2P="${HOME}/i2p"
#2PTEMP="%SYSTEM_java_io_tmpdir"
I2PTEMP="${HOME}/i2p"
```

Run the I2P program or restart your server computer.

```yml
root@router2:~ # service i2p restart
```

My suggestion, it's better to just reboot/restart your server computer.

```yml
root@router2:~ # reboot
```

After the I2P program is restarted or the server is rebooted, all I2P settings will be moved to the hidden folder /usr/home/i2p/.i2p. Notice the dot in front of "i2p"; it indicates the folder is hidden.

Now, open the hidden folder `/usr/home/i2p/.i2p.` In this article, I will provide the I2P console address as the same as the FreeBSD Server IP address, which is 192.168.9.3. To open the I2P browser console with the IP address 192.168.9.3:7657, edit the following file:

In the clients.config.bak file, in the clientApp.0.args=7657::1,127.0.0.1 ./webapps/ and clientApp.4.args=http://127.0.0.1:7657/ scripts, replace .

```console
clientApp.0.args=7657 ::1,192.168.9.3 ./webapps/
clientApp.4.args=http://192.168.9.3:7657/
```

Next, open the /usr/home/i2p/.i2p/clients.config.d folder, edit the 00-net.i2p.router.web.RouterConsoleRunner-clients.config file.

```console
clientApp.0.args=7657 ::1,192.168.9.3 ./webapps/
```

You also edit the 04-net.i2p.apps.systray.UrlLauncher-clients.config file.

```console
clientApp.0.args=http://192.168.9.3:7657/
```

Once we have finished configuring everything, restart the server computer.

```yml
root@router2:~ # reboot
```

B. Perform I2P Testing

Once the reboot process is complete and your computer returns to normal, you can remotely connect with Putty. Open your Yandex, Firefox, or Chrome web browser. Simply open Yandex to perform a TEST. If the I2P router configuration menu opens, you have successfully installed the I2P program on your FreeBSD server.

Open your Google Chrome web browser, type "Server IP http://192.168.9.3:7657" in the address bar, and view the results on your monitor.

If the display looks like the image above, you have successfully installed the I2P program on your FreeBSD server. Installing I2P isn't difficult, I had some initial difficulties, but I eventually succeeded. It's certainly easier to install TOR than I2P, but if you follow the steps outlined above, you should be able to install I2P successfully.


