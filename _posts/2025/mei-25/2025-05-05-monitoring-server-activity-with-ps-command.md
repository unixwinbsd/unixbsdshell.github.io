---
title: Monitoring FreeBSD Server Activity With the ps Command
date: "2025-05-05 11:05:13 +0100"
updated: "2025-05-05 11:05:13 +0100"
id: monitoring-server-activity-with-ps-command
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: The ps command displays detailed options of running processes. If a network administrator wants recurring updates of the options and information displayed, then he can use the ps command for the job.
keywords: monitoring, disk, flashdisk, cdrom, freebsd, server, activity, tools, ps, command, shell
---

For someone who is involved in the field of network and system administration, mastering the ps utility command is very important. Because, with its help, users can find out a lot of useful information about processes running on an operating system such as FreeBSD.

The ps command is used to see the processes running on the operating system. This command is very helpful for a system administrator to find out what processes are running and what is being done on the operating system, how much memory is used, how much CPU space is occupied, user ID, command name, and so on.

## 1. What is ps Command

The ps command displays detailed options of the running processes. If a network administrator wants a recurring update of the options and information displayed, then he can use the ps command for the job.

The ps command is one of the most widely used utilities in FreeBSD. The ps utility provides a snapshot of the running processes and their status. It is useful in monitoring the running processes, identifying their process ID (PID), terminal type (TTY), CPU time usage, command name, user ID, and other information. This article provides a comprehensive overview of the various real-world use cases of the ps command.

The ps command supports three different syntactic styles. The following are the ps command versions of these three options:
- UNIX options can be combined and must be followed by a hyphen.
- GNU long options are followed by two hyphens.
- BSD options can be combined and must not be used with a hyphen.

Options of different types can be mixed freely, but conflicts can occur. There are some options that are synonymous and functionally identical, because some ps implementations and standards are compatible with the ps command.

## 2. Implementing the ps Command

The "ps" command in FreeBSD stands for "process status", an abbreviation of its full name. You can use it to learn more about what is happening in the background processes of your system. Depending on the input parameters, this command can produce different results. However, this tutorial will use an illustrative example to teach you how to use the "ps" command in FreeBSD.

The "ps" command has certain parameters that can be found in the "help" documentation. However, this command can be run independently without error.

The following is the Header line of the ps command:
- %CPU: Shows how much CPU a process is using.
- %MEM: Shows how much memory a process is using.
- ADDR: Shows the memory address of a process.
- CP or C: Shows scheduling information and CPU usage.
- COMMAND*: Shows the process name, including arguments if available.
- NI: Shows the good value.
- F: Shows the option selection.
- PID: Shows the Process ID number.
- PPID: Shows the parent process number of the process.
- PRI: Shows the priority of the process.
- RSS: Abbreviation for Resident Set Size.
- STAT or S: Shows the status code of the current process.
- STIME or START: Shows the start time of the process.
- TIME: Shows the amount of CPU time used by a process.
- VSZ: Shows the virtual memory used.
- TTY or TT: Shows the terminal corresponding to the process.
- USER or UID: Shows the username and owner of the current process.
- WCHAN: Shows the memory address where processing is pending.

## 3. Example of Using the ps Command

### a. Shows all processes

```console
root@ns1:~ # ps
 PID TT  STAT    TIME COMMAND
 816 v0- I    0:00.20 /usr/local/bin/GoBlog
2085 v0- S    0:00.40 tor --DataDirectory /tmp/data-dir-1382725963 --Co
2134 v0  Is+  0:00.00 /usr/libexec/getty Pc ttyv0
2135 v1  Is+  0:00.01 /usr/libexec/getty Pc ttyv1
2136 v2  Is+  0:00.00 /usr/libexec/getty Pc ttyv2
2137 v3  Is+  0:00.00 /usr/libexec/getty Pc ttyv3
2138 v4  Is+  0:00.00 /usr/libexec/getty Pc ttyv4
2139 v5  Is+  0:00.00 /usr/libexec/getty Pc ttyv5
2140 v6  Is+  0:00.00 /usr/libexec/getty Pc ttyv6
2141 v7  Is+  0:00.00 /usr/libexec/getty Pc ttyv7
2159  0  Ss   0:00.02 -csh (csh)
2162  0  R+   0:00.00 ps
```

### b. Displays currently running processes

```console
root@ns1:~ # ps -e
 PID TT  STAT    TIME COMMAND
 816 v0- I    0:00.21 LANG=C.UTF-8 PATH=/sbin:/bin:/usr/sbin:/usr/bin:/
2085 v0- S    0:00.40 LANG=C.UTF-8 PATH=/sbin:/bin:/usr/sbin:/usr/bin:/
2134 v0  Is+  0:00.00 TERM=xterm /usr/libexec/getty Pc ttyv0
2135 v1  Is+  0:00.01 TERM=xterm /usr/libexec/getty Pc ttyv1
2136 v2  Is+  0:00.00 TERM=xterm /usr/libexec/getty Pc ttyv2
2137 v3  Is+  0:00.00 TERM=xterm /usr/libexec/getty Pc ttyv3
2138 v4  Is+  0:00.00 TERM=xterm /usr/libexec/getty Pc ttyv4
2139 v5  Is+  0:00.00 TERM=xterm /usr/libexec/getty Pc ttyv5
2140 v6  Is+  0:00.00 TERM=xterm /usr/libexec/getty Pc ttyv6
2141 v7  Is+  0:00.00 TERM=xterm /usr/libexec/getty Pc ttyv7
2159  0  Ss   0:00.02 USER=root LOGNAME=root HOME=/root PATH=/sbin:/bin
2163  0  R+   0:00.00 USER=root LOGNAME=root HOME=/root PATH=/sbin:/bin
```

### c. View processes that do not have a controlling terminal

```console
root@ns1:~ # ps -ax
 PID TT  STAT     TIME COMMAND
   0  -  DLs   0:01.26 [kernel]
   1  -  ILs   0:00.04 /sbin/init
   2  -  DL    0:00.00 [KTLS]
   3  -  DL    0:00.00 [crypto]
   4  -  DL    0:00.05 [cam]
   5  -  DL    0:00.14 [zfskern]
   6  -  DL    0:00.01 [rand_harvestq]
   7  -  DL    0:00.05 [pagedaemon]
   8  -  DL    0:00.00 [vmdaemon]
   9  -  DL    0:00.00 [bufdaemon]
  10  -  DL    0:00.00 [audit]
  11  -  RNL  22:06.59 [idle]
  12  -  WL    0:00.76 [intr]
  13  -  DL    0:00.00 [geom]
  14  -  DL    0:00.00 [sequencer 00]
  15  -  DL    0:00.01 [usb]
  16  -  DL    0:00.01 [acpi_thermal]
  17  -  DL    0:00.00 [vnlru]
  18  -  DL    0:00.00 [syncer]
 536  -  Is    0:00.00 /sbin/devd
 732  -  Is    0:00.01 /usr/sbin/syslogd -s
 814  -  Is    0:00.00 sshd: /usr/local/sbin/sshd [listener] 0 of 10-10
 832  -  Ss    0:00.03 /usr/sbin/ntpd -p /var/db/ntp/ntpd.pid -c /etc/n
 866  -  Ss    0:00.00 /usr/sbin/cron -s
 878  -  Is    0:00.05 /bin/sh /usr/local/bin/mysqld_safe --defaults-ex
2082  -  I     0:03.43 /usr/local/libexec/mysqld --defaults-extra-file=
2103  -  Ss    0:00.11 redis-server: /usr/local/bin/redis-server 127.0.
2122  -  Ss    0:00.02 /usr/local/sbin/httpd
2142  -  I     0:00.00 /usr/local/sbin/httpd
2143  -  S     0:00.00 /usr/local/sbin/httpd
2144  -  I     0:00.00 /usr/local/sbin/httpd
2145  -  I     0:00.00 /usr/local/sbin/httpd
2146  -  I     0:00.00 /usr/local/sbin/httpd
2156  -  Ss    0:00.03 sshd: root@pts/0 (sshd)
 816 v0- I     0:00.25 /usr/local/bin/GoBlog
2134 v0  Is+   0:00.00 /usr/libexec/getty Pc ttyv0
2135 v1  Is+   0:00.01 /usr/libexec/getty Pc ttyv1
2136 v2  Is+   0:00.00 /usr/libexec/getty Pc ttyv2
2137 v3  Is+   0:00.00 /usr/libexec/getty Pc ttyv3
2138 v4  Is+   0:00.00 /usr/libexec/getty Pc ttyv4
2139 v5  Is+   0:00.00 /usr/libexec/getty Pc ttyv5
2140 v6  Is+   0:00.00 /usr/libexec/getty Pc ttyv6
2141 v7  Is+   0:00.00 /usr/libexec/getty Pc ttyv7
2159  0  Ss    0:00.03 -csh (csh)
2175  0  R+    0:00.00 ps -ax
```

### d. Displays all detailed info of running processes

```console
root@ns1:~ # ps auwwx
```

### e. Shows the most active processes

```console
root@ns1:~ # ps -aux | head -5
USER   PID  %CPU %MEM     VSZ    RSS TT  STAT STARTED     TIME COMMAND
root    11 200.0  0.0       0     32  -  RNL  17:21   35:09.10 [idle]
root     0   0.0  0.1       0   1104  -  DLs  17:21    0:01.31 [kernel]
root     1   0.0  0.1   11768   1164  -  ILs  17:21    0:00.04 /sbin/init
root     2   0.0  0.0       0     32  -  DL   17:21    0:00.00 [KTLS]
```

### f. Displays root user processes

```console
root@ns1:~ # ps -aux | grep root
root    11 200.0  0.0       0     32  -  RNL  17:21   39:52.35 [idle]
root     0   0.0  0.1       0   1104  -  DLs  17:21    0:01.33 [kernel]
root     1   0.0  0.1   11768   1164  -  ILs  17:21    0:00.04 /sbin/init
root     2   0.0  0.0       0     32  -  DL   17:21    0:00.00 [KTLS]
root     3   0.0  0.0       0     48  -  DL   17:21    0:00.00 [crypto]
root     4   0.0  0.0       0     32  -  DL   17:21    0:00.06 [cam]
root     5   0.0  0.0       0    704  -  DL   17:21    0:00.15 [zfskern]
root     6   0.0  0.0       0     16  -  DL   17:21    0:00.02 [rand_harvestq]
root     7   0.0  0.0       0     48  -  DL   17:21    0:00.10 [pagedaemon]
root     8   0.0  0.0       0     16  -  DL   17:21    0:00.00 [vmdaemon]
root     9   0.0  0.0       0     32  -  DL   17:21    0:00.00 [bufdaemon]
root    10   0.0  0.0       0     16  -  DL   17:21    0:00.00 [audit]
root    12   0.0  0.0       0    352  -  WL   17:21    0:01.19 [intr]
root    13   0.0  0.0       0     48  -  DL   17:21    0:00.00 [geom]
root    14   0.0  0.0       0     16  -  DL   17:21    0:00.00 [sequencer 00]
root    15   0.0  0.0       0    160  -  DL   17:21    0:00.01 [usb]
root    16   0.0  0.0       0     16  -  DL   17:21    0:00.01 [acpi_thermal]
root    17   0.0  0.0       0     16  -  DL   17:21    0:00.00 [vnlru]
root    18   0.0  0.0       0     16  -  DL   17:21    0:00.00 [syncer]
root   536   0.0  0.1   11568   1572  -  Is   17:21    0:00.00 /sbin/devd
root   732   0.0  0.2   12868   2764  -  Ss   17:21    0:00.01 /usr/sbin/syslogd -s
root   814   0.0  0.4   21072   7584  -  Is   17:21    0:00.00 sshd: /usr/local/sbin/sshd [listener] 0 of 10-100 startups (sshd)
root   866   0.0  0.1   12908   2544  -  Ss   17:21    0:00.00 /usr/sbin/cron -s
root  2122   0.0  0.9   37592  15768  -  Ss   17:21    0:00.03 /usr/local/sbin/httpd
root  2156   0.0  0.5   21440   8792  -  Ss   17:23    0:00.04 sshd: root@pts/0 (sshd)
root   816   0.0  2.5  803336  44164 v0- I    17:21    0:00.30 /usr/local/bin/GoBlog
root  2134   0.0  0.1   12836   2348 v0  Is+  17:21    0:00.00 /usr/libexec/getty Pc ttyv0
root  2135   0.0  0.1   12836   2356 v1  Is+  17:21    0:00.01 /usr/libexec/getty Pc ttyv1
root  2136   0.0  0.1   12836   2348 v2  Is+  17:21    0:00.00 /usr/libexec/getty Pc ttyv2
root  2137   0.0  0.1   12836   2348 v3  Is+  17:21    0:00.00 /usr/libexec/getty Pc ttyv3
root  2138   0.0  0.1   12836   2344 v4  Is+  17:21    0:00.00 /usr/libexec/getty Pc ttyv4
root  2139   0.0  0.1   12836   2340 v5  Is+  17:21    0:00.00 /usr/libexec/getty Pc ttyv5
root  2140   0.0  0.1   12836   2348 v6  Is+  17:21    0:00.00 /usr/libexec/getty Pc ttyv6
root  2141   0.0  0.1   12836   2352 v7  Is+  17:21    0:00.00 /usr/libexec/getty Pc ttyv7
root  2159   0.0  0.3   16496   4616  0  Ss   17:23    0:00.04 -csh (csh)
root  2204   0.0  0.2   13444   3120  0  R+   17:41    0:00.00 ps -aux
root  2205   0.0  0.1   12812   2420  0  S+   17:41    0:00.00 grep root
```

### g. Displays cron processes

```console
root@ns1:~ # ps aux | grep cron
root   866   0.0  0.1   12908   2544  -  Is   17:21    0:00.00 /usr/sbin/cron -s
root  2211   0.0  0.1   12812   2428  0  S+   17:43    0:00.00 grep cron
```

Apart from the command above, there are lots of ps options, below we will give examples of several options from the ps command that you can try.

```console
root@ns1:~ # ps aux | less
```
```console
root@ns1:~ # ps -x
```
```console
root@ns1:~ # ps -t pts/0
```
```console
root@ns1:~ # ps -fL -C sshd
```
```console
root@ns1:~ # ps -eo pid,ppid,user
```
```console
root@ns1:~ # ps -A | grep -i sshd
 814  -  Is    0:00.00 sshd: /usr/local/sbin/sshd [listener] 0 of 10-100 startups (sshd)
2156  -  Ss    0:00.04 sshd: root@pts/0 (sshd)
2236  0  S+    0:00.00 grep -i sshd
```

The ps command is a very powerful tool for managing processes in FreeBSD. Whether you want to monitor a specific process, find processes that are taking up too much memory or CPU, or monitor all processes running on your system, the ps command provides the information you need. This is an essential tool for every FreeBSD administrator.
