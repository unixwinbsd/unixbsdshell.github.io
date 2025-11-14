---
title: SSHLOCKOUT Tutorial for OpenBSD
date: "2025-06-09 07:01:13 +0100"
updated: "2025-06-09 07:01:13 +0100"
id: tutorials-ssh-sshlockout-openbsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: Anonymous
background: https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/31tutorials%20sshlockout%20on%20openbsd.jpg&commit=2cf530bd95d4246b8958252f9e69db9defe7703e
toc: true
comments: true
published: true
excerpt: This feature provides user-level control to deny SSH logons in general while allowing SSH logons from specific user accounts. This level of control is available based on how you configure the lockout control. The following figure shows the fields available on the Lockout Whitelist tab.
keywords: ssh, openssh, sshlockout, openbsd, tutorials, key, keygen
---

The SSH Lockout module allows administrators to restrict SSH login access to the environment. This feature provides a mechanism to ensure that processing resources are available for high-priority tasks and helps manage scheduled maintenance. Note that existing SSH logons are not affected by the lockout. The lockout only prevents new SSH logons. Access to software that does not rely on SSH is not affected.

This feature provides user-level control to deny SSH logons in general while allowing SSH logons from specific user accounts. This level of control is available based on how you configure the lockout control. The following figure shows the fields available on the Lockout Whitelist tab.

The sshlockout program is an additional layer of security that bans IP addresses that have reached a maximum threshold of failed password attempts. The sshlockout program originates from DragonFlyBSD and has been ported to OpenBSD. If you are coming from the Linux world, it is similar to Fail2Ban and is a very simple program.

When sshlockout is set using the settings in the man page, then any IP address that exceeds 5 incorrect password attempts will be blocked for an hour. The IP block will then expire after 1 day and it is allowed to try to login again.


<br/>
![tutorials sshlockout on openbsd](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/31tutorials%20sshlockout%20on%20openbsd.jpg&commit=2cf530bd95d4246b8958252f9e69db9defe7703e)
<br/>


## 1. What is sshlockout
Here is a brief overview of sshlockout and how to use it effectively to block attackers on an OpenBSD machine.

The sshlockout program is an additional layer of security that blocks IP addresses that have reached a maximum threshold of failed password attempts. The sshlockout program originated in DragonFlyBSD and has been ported to OpenBSD. If you are coming from the Linux world, it is similar to Fail2Ban and is a very easy program. ​

When sshlockout is configured using the settings in the man page, the program will block any IP address that exceeds 5 incorrect password attempts in an hour. Blocked IP addresses are blocked by default for one day and are then allowed to try again.

Before you configure sshlockout, I HIGHLY recommend the following:
- Create RSA key for ssh authentication.
- Disable ssh password authentication.
- Disable ssh root authentication.
- Change default ssh port.
- Once all these tasks are done, it's time for installation!

## 2. SSHLockout Installation & Configuration
The initial installation is done with the OpenBSD package manager as the root user or with root privileges using the command:

```console
hostname1# pkg_add sshlockout
```
To set the correct permissions, edit `/etc/doas.conf` and add the following:

```console
hostname1# permit nopass _syslogd as root cmd /usr/sbin/sshlockout
```
Now that sshlockout is installed, some configuration is required. You need to add a PF table and a rule to block that table. Edit the following at the bottom of `/etc/pf.conf`:

```console
hostname1# table <lockout> persist
hostname1# block in quick on egress proto tcp from <lockout> to port 22
```
To test and then apply the new PF tables and rules, run the following commands:

```console
hostname1# pf -n -f /etc/pf.conf && pfctl -f /etc/pf.conf
```
Then you Edit `/etc/syslog.conf` and for logging purposes add the following:

```console
auth.info;authpriv.info | exec /usr/bin/doas -n /usr/local/sbin/sshlockout -pf "lockout"
```
The final part of sshlockout is to add a line to root's crontab to remove the blocked IP addresses. Run the following command:

```console
hostname1# doas crontab -e
```
After that you add the following lines to the `/etc/crontab` file.

```console
3 3 * * * pfctl -tlockout -T expire 4294967295
```
The number set for expiration is in seconds. Change it to the desired amount of time to block malicious public IPs.

## 3. Test SSHLockout
One way to test if sshlockout is working is to try logging in from a different IP address. You can use a VPN to your server and move your ssh keys to a different directory so that the ssh command won't use them. Then you can try sshing to your server and using random credentials.

After 5 failed attempts when you try to ssh, the server will hang instead of asking for credentials. To fix this, you need user intervention by pressing Ctrl+C.

Once blocked, you should check your public IP while your VPN connection is active. Then disconnect from your VPN and move your RSA keys back to ~/.ssh. You should now be able to ssh to your remote web server and run commands.

```console
hostname1# pfctl -t lockout -T show | grep your.vpn.ip.address
```
It will now return the VPN IP address confirming that the VPN has been added to the blocklist.