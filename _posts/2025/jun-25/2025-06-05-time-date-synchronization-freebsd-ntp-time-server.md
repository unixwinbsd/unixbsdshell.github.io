---
title: Time and Date Synchronization For FreeBSD Server With NTP Time Server
date: "2025-06-05 10:10:25 +0100"
updated: "2025-06-05 10:10:25 +0100"
id: time-date-synchronization-freebsd-ntp-time-server
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: One of the popular programming languages ​​used in web development is PHP. PHP is a programming language that is widely used to create the most popular CMS platform in the world, namely WordPress. PHP is a back-end programming language or used for server-side development.
keywords: openntpd, ntp, time, date, synchronization, server, clock, windows, date anda time
---

The clock on the computer tends to be inaccurate, always changing from time to time, especially on Windows-based systems, if not synchronized properly will cause some applications to not run perfectly. In the WEB Browser program, if the clock on the computer is not accurate, then browsers such as Chrome, Mozilla and others will not be able to be opened.

The solution, Network Time Protocol (NTP) provides a way to maintain the accuracy of the computer's system clock. NTP is an internet protocol used to synchronize time across multiple servers. FreeBSD includes an NTP daemon program (ntpd) that manages and maintains system time by synchronizing with the NTP server.

To set up the NTP daemon we must first install it. In this discussion we will discuss how to install and synchronize the NTP daemon.

## 📓 To use the NTP daemon, in this discussion the servers used are:
- Processor: AMD Phenom(tm) II X4 955 Processor (K8-class CPU).
- OS: 14.1-STABLE.
- Server IP: 192.168.5.234.
- Hostname: router2.
- NTP version: 4.2.8p18.

FreeBSD uses Network Time Protocol (NTP) to synchronize the computer's system clock over a variable latency data network routed via UDP packets. NTP uses UDP port 123. If you have a single computer or a single server, you can easily synchronize the time with other NTP servers.

All you need is an ntp client called ntpdate. This client is used to set the date and time through an NTP server. Let's practice how to set NTP Clock Synchronization on FreeBSD with ntpd and ntpdate.

As a first step, we install the zoneinfo program.

```console
root@router2:~ # cd /usr/ports/misc/zoneinfo
root@router2:/usr/ports/misc/zoneinfo # make install clean
```

After the zoneinfo program is successfully installed, copy the Jakarta time zone or other time to local time.

```console
root@router2:~ # cp /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
```

The next step is to install the NTP daemon.

```console
root@router2:~ # cd /usr/ports/net/ntp
root@router2:/usr/ports/net/ntp # make install clean
```

If you want to use the `PKG package` to install `NTP`, run the following command.

```console
root@router2:~ # pkg install net/ntp
```

After that, continue by creating `log` and `drift` files.

```console
root@router2:~ # touch /var/db/ntpd.drift
root@router2:~ # touch /var/log/ntpd.log
```
In the `/boot/loader.conf` file, enter the following script.

```console
root@router2:~ # ee /boot/loader.conf
mac_ntpd_load="YES"
```
Also include the following script in the `/etc/sysctl.conf` file.

```console
root@router2:~ # ee /etc/sysctl.conf
security.mac.ntpd.enabled=1
security.mac.ntpd.uid=123
```

To allow the NTP daemon to directly connect to one of the time servers, create the following script in the `/etc/crontab` file.

```console
root@router2:~ # ee /etc/crontab
* */12 * * * /usr/local/sbin/ntpdate time.cloudflare.com
```

To keep the NTP daemon running, you need to add a script to the periodic.conf file in the `/etc/defaults` folder. Find the number 480 and add the following script.

```console
root@router2:~ # ee /etc/defaults/periodic.conf
daily_status_ntpd_enable="YES"
daily_ntpd_leapfile_enable="YES"
```

To play `log` files, you can add the following script to the `/etc/syslog.conf` file and the `/etc/newsyslog.conf` file.

```console
root@router2:~ # ee /etc/syslog.conf
!ntpdate
*.*                     /var/log/ntpd.log
!ntpdate
*.*                     /var/log/ntpd.log
```

<br/>

```console
root@router2:~ # ee /etc/newsyslog.conf
/var/log/ntp.log         600   10     300     *     J
```

To keep the NTP daemon running when the server is restarted/rebooted or shut down, add the following script to the `/etc/rc.conf` file.

```console
root@router2:~ # ee /etc/rc.conf
ntpd_enable="YES"
ntpdate_enable="YES"
ntpd_config="/etc/ntp.conf"
ntpd_program="/usr/local/sbin/ntpd"
ntpdate_program="/usr/local/sbin/ntpdate"
ntpdate_flags="time.cloudflare.com"
ntpd_sync_on_start="YES"
ntpd_oomprotect="YES"
ntpd_flags="-f /var/db/ntpd.drift -l /var/log/ntpd.log"
```

The final configuration of the NTP daemon is editing the `/etc/ntp.conf` file. Based on the original or default script from the `/etc/ntp.conf` file, there are several things that must be enabled and there are scripts that can be added. At the end of this article, a complete example of the `/etc/ntp.conf` script will be given. In the `/etc/ntp.conf` file, the time servers used are:

```html
server time.cloudflare.com iburst
server time.windows.com iburst
server time.nist.gov iburst
server time-a.nist.gov iburst
server time-b.nist.gov iburst
server clock.sjc.he.net iburst
server hydrogen.constant.com iburst
server t1.timegps.net iburst
```


If you want your server IP as the NTP server address, add the following script in the `/etc/conf` file.

```
interface ignore wildcard
interface listen 192.168.5.234
```

After we edit the `/etc/ntp.conf` file, RESTART the NTP daemon.

```console
root@router2:~ # service ntpd restart
```

Usually the NTP daemon is not immediately synchronized, wait for 2 or 4 hours, even up to 1 day, then the NTP daemon is SYNCRONIZED and ready to use.

To further ensure whether the NTP daemon is RUNNING or not, do a test.

```console
root@router2:~ # ps ax | grep ntpd
root@router2:~ # sockstat | grep ntp
root@router2:~ # date
root@router2:~ # ntpq -pn
root@router2:~ # ntpq -p 192.168.9.3
root@router2:~ # ntpdate -q 192.168.9.3
root@router2:~ # ntpdate -q time.cloudflare.com
root@router2:~ # ntpq -p
```

When testing using the `ntpq -p` script, the image that appears will be like this:

<br/>

![ntp -q command](https://gitea.com/UnixBSDShell/Web-Static-With-Ruby-Jekyll-Site-NetBSD/raw/branch/main/images/1NTP%20-p%20command.jpg)

<br/>

Below is an explanation of the script code above.
- "*" : The last peer to synchronize.
- "+" : "Good" The server is carrying out the update process.
- "-" : "Bad" The server does not update.
- "x" : Server is not responding

To set up synchronization on Windows XP/7/8, right-click on the date clock icon at the bottom right, then click Adjust `date/time`, select the Internet Time tab and then click Change settings.

<br/>

![Setup NTP Server on Windows](https://gitea.com/UnixBSDShell/Web-Static-With-Ruby-Jekyll-Site-NetBSD/raw/branch/main/images/2Setup%20NTP%20Server%20on%20Windows.jpg)

<br/>

The clock is successfully synchronized with `192.168.5.234` which means that the NTP daemon that we configured is **RUNNING**, the proof is that our Windows computer can already synchronize with the IP Time Server that we have configured on FreeBSD Server.


**The following is the complete script from the /etc/ntp.conf file.**

```
#
# $FreeBSD$
#
# Default NTP servers for the FreeBSD operating system.
#
# Don't forget to enable ntpd in /etc/rc.conf with:
# ntpd_enable="YES"
#
# The driftfile is by default /var/db/ntpd.drift, check
# /etc/defaults/rc.conf on how to change the location.
#
interface ignore wildcard
interface listen 192.168.9.3
#
# Set the target and limit for adding servers configured via pool statements
# or discovered dynamically via mechanisms such as broadcast and manycast.
# Ntpd automatically adds maxclock-1 servers from configured pools, and may
# add as many as maxclock*2 if necessary to ensure that at least minclock
# servers are providing good consistent time.
#
tos minclock 3 maxclock 6

#
# The following pool statement will give you a random set of NTP servers
# geographically close to you.  A single pool statement adds multiple
# servers from the pool, according to the tos minclock/maxclock targets.
# See http://www.pool.ntp.org/ for details.  Note, pool.ntp.org encourages
# users with a static IP and good upstream NTP servers to add a server
# to the pool. See http://www.pool.ntp.org/join.html if you are interested.
#
# The option `iburst' is used for faster initial synchronization.
#
#pool 0.freebsd.pool.ntp.org iburst

#
# If you want to pick yourself which country's public NTP server
# you want to sync against, comment out the above pool, uncomment
# the next one, and replace CC with the country's abbreviation.
# Make sure that the hostname resolves to a proper IP address!
#
#pool 0.nettime.pool.ntp.org iburst

#
# To configure a specific server, such as an organization-wide local
# server, add lines similar to the following.  One or more specific
# servers can be configured in addition to, or instead of, any server
# pools specified above.  When both are configured, ntpd first adds all
# the specific servers, then adds servers from the pool until the tos
# minclock/maxclock targets are met.
#
server time.cloudflare.com iburst
server time.windows.com iburst
server time.nist.gov iburst
server time-a.nist.gov iburst
server time-b.nist.gov iburst
server clock.sjc.he.net iburst
server hydrogen.constant.com iburst
server t1.timegps.net iburst


#
# Security:
#
# By default, only allow time queries and block all other requests
# from unauthenticated clients.
#
# The "restrict source" line allows peers to be mobilized when added by
# ntpd from a pool, but does not enable mobilizing a new peer association
# by other dynamic means (broadcast, manycast, ntpq commands, etc).
#
# See http://support.ntp.org/bin/view/Support/AccessRestrictions
# for more information.
#
#restrict default limited kod nomodify notrap noquery nopeer
#restrict source  limited kod nomodify notrap noquery

#
# Alternatively, the following rules would block all unauthorized access.
#
#restrict default ignore
#
# In this case, all remote NTP time servers also need to be explicitly
# allowed or they would not be able to exchange time information with
# this server.
#
# Please note that this example doesn't work for the servers in
# the pool.ntp.org domain since they return multiple A records.
#
#restrict 0.pool.ntp.org nomodify nopeer noquery notrap
#restrict 1.pool.ntp.org nomodify nopeer noquery notrap
#restrict 2.pool.ntp.org nomodify nopeer noquery notrap
#
# The following settings allow unrestricted access from the localhost
restrict 192.168.9.0 mask 255.255.255.0 nomodify notrap nopeer
restrict ::1
broadcast 192.168.9.255
#
# If a server loses sync with all upstream servers, NTP clients
# no longer follow that server. The local clock can be configured
# to provide a time source when this happens, but it should usually
# be configured on just one server on a network. For more details see
# http://support.ntp.org/bin/view/Support/UndisciplinedLocalClock
# The use of Orphan Mode may be preferable.
#
#server 127.127.1.0
#fudge 127.127.1.0 stratum 10

# See http://support.ntp.org/bin/view/Support/ConfiguringNTP#Section_6.14.
# for documentation regarding leapfile. Updates to the file can be obtained
# from ftp://time.nist.gov/pub/ or ftp://tycho.usno.navy.mil/pub/ntp/.
# Use either leapfile in /etc/ntp or periodically updated leapfile in /var/db.
#leapfile "/etc/ntp/leap-seconds"
leapfile "/var/db/ntpd.leap-seconds.list"
driftfile "/var/db/ntpd.drift"
logfile "/var/log/ntpd.log"


# Specify the number of megabytes of memory that should be allocated and
# locked. -1 (default) means "do not lock the process into memory".
# 0 means "lock whatever memory the process wants into memory". Any other
# number means to lock up to that number of megabytes into memory.
# 0 may result in a segfault when ASLR with stack gap randomization
# is enabled.
#rlimit memlock 32
```
**Congratulations!** You have successfully installed an NTP server on FreeBSD. Now your FreeBSD server is synchronized with international time.