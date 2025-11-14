---
title: Guide to Updating pfSense Using Shell Commands and Google Browser
date: "2025-07-31 08:21:11 +0100"
updated: "2025-10-11 17:05:32 +0100"
id: updating-pfsense-using-shell-command-google-browser
lang: en
author: Iwan Setiawan
categories: Networking
tags: Router
background: https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/image/DashboardPFSenseView.jpg
toc: true
comments: true
published: true
excerpt: Every update process performed by PFSense includes the version it releases. This aims to update the application and its dependencies to the latest version, ensuring that the system's benefits are maximized
keywords: pfsense, router, firewall, shell, command, google, browser, networking
---

Every application created undergoes updates. This indicates that the application is widely used and beneficial to many people. Similarly, PFSense, one of the router firewall applications with the largest community, experiences updates almost every year, sometimes even releasing new versions. The developers are constantly innovating, making PFSense a stable and reliable router.

Every update process performed by PFSense includes the version it releases. This aims to update the application and its dependencies to the latest version, ensuring that the system's benefits are maximized. This update process assures us that the developers are actively monitoring PFSense usage.

PFSense, part of the Netgate product family, regularly releases updated versions containing new features, updates, bug fixes, and various other changes. In some cases, the PFSense update process is crucial, as it completely addresses feature deficiencies in the latest Netgate releases. PFSense always updates using the same software edition as the firewall router you're using.

The PFSense update process also keeps pace with its older sibling, FreeBSD, which continues to release new versions. At the time of writing, FreeBSD has reached version 14.

Given the importance of the PFSense update process, in this post, we'll explain how to update PFSense from version `2.5.2-RELEASE (amd64)` to version `2.7.0-RELEASE (amd64)`. This article is based on the author's experience using PFSense for a Wi-Fi hotspot business.

**By default, PFSense routers recognize two update methods, namely:**
- Updates via GUI (web browser), and,
- Updates via command line (shell).


## 1. Update With GUI

The update process using the GUI (web browser) is very easy, as you simply run the command by clicking the update menu. To perform the first update, you can do so from the PFSense dashboard, as shown in the image below.

<br/>
<img alt="Dashboard PFSense" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/image/DashboardPFSenseView.jpg' | relative_url }}">
<br/>

In the image above, notice the green text. Simply click the circular arrow, and the update process will start automatically.

The GUI update process is very fast; in just a few minutes, you'll have successfully updated PFSense. Another way to do this is by clicking the `System -> Update menu`. See the example image below.

<br/>
<img alt="System Update PFSense" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/image/SystemUpdatePFSense.jpg' | relative_url }}">
<br/>

## 2. Updating With Shell Commands / Command line

The command-line update process requires specialized skills, such as mastering FreeBSD shell commands and understanding the concept of PKG packages and the ports system. For those unfamiliar with shell commands, updating PFSense using the GUI is recommended.

During the command-line update process, you must enable SSH to log in to the PFSense system. Once you've successfully enabled SSH, if you're using a Windows computer, you can run PuTTY.

In the PuTTY menu, type your IP address, PFSense user, and password. Once logged in, type 13 to start updating PFSense using the command line (see the example image below).


<br/>
<img alt="Update from Console" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitea.com/UnixBSDShell/OpenBSD-Web-APP/raw/branch/main/image/UpdatefromConsole.jpg' | relative_url }}">
<br/>

Besides updating PFSense using the method above, there's another way to update PFSense: using shell commands. This method is the best and we highly recommend it. The update process uses `PKG packages`, just like FreeBSD's.

In the Putty or Remmina menu if you're using Ubuntu Desktop, select 8, and you'll be immediately presented with the PFSense shell commands. Because the update process uses PKG packages, the update process is almost identical to FreeBSD's. Run the following command to start the update process.

```yml
[2.7.0-RELEASE][root@ns5.kursor.my.id]/root: pkg update -f
```

After that, proceed with the update process. Run the command below to start the PFSense update process.

```yml
[2.7.0-RELEASE][root@ns5.kursor.my.id]/root: pkg upgrade -f
```

The method above shows how to update PFSense by updating the FreeBSD PKG package. There's another way to update, using the `"pfSense-upgrade"` command. See the example below for a usage example.

```yml
[2.7.0-RELEASE][root@ns5.kursor.my.id]/root: pfSense-upgrade -d -f -u -c
```

## 3. Updating PFSense Packages

Like FreeBSD, PFSense also has application packages that can be installed on the PFSense system. Each PFSense package has been modified by the developer to run only on the PFSense system.

To update a PFSense package, you can use the `"pfSense-upgrade"` command. In the example below, we'll show you how to install the Squid Proxy package.

```yml
[2.7.0-RELEASE][root@ns5.kursor.my.id]/root: pfSense-upgrade -i squid
```

If you want to remove the `Squid Proxy package from PFSense`, run the command below.

```yml
[2.7.0-RELEASE][root@ns5.kursor.my.id]/root: pfSense-upgrade -r squid
```

Before installing the PFSense package, always run the update command first. This ensures you're getting the latest version of the PFSense package you're installing.

If you use PFSense regularly, you should update the PFSense system regularly. This ensures the system and application packages are up-to-date.