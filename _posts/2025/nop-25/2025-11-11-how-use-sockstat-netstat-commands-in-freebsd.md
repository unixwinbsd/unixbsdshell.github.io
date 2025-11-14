---
title: How to Use the Sockstat and Netstat Commands in FreeBSD
date: "2025-11-11 10:11:52 +0000"
updated: "2025-11-11 10:11:52 +0000"
id: how-use-sockstat-netstat-commands-in-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: https://i.sstatic.net/AS4QH.png
toc: true
comments: true
published: true
excerpt: This article will explain how to use the sockstat and netstat commands on FreeBSD. To make it easier for readers to understand these two basic commands, we've tried to keep this article simple without skimping on detail.
keywords: netstat, sockstat, command, cmd, unix, bsd, freebsd, shell, script
---

This article will explain how to use the sockstat and netstat commands on FreeBSD. To make it easier for readers to understand these two basic commands, we've tried to keep this article simple without skimping on detail.

## 1. Understanding Sockstat and Netstat

For a system administrator, these two commands are crucial. Imagine dealing with a server computer, and we certainly wouldn't know what applications are running on it. With socksstat and netstat, a system administrator can find out which socket ports and applications/programs are running on the server computer, allowing us to perform maintenance accordingly.

Sockstat is a versatile command-line utility used to display open or in-use network sockets, ports, and programs in FreeBSD. If you're using the FreeBSD operating system, you don't need to install the socksstat command. Sockstat is already installed by default, so you can simply use it.

The sockstat command can also list open sockets by protocol version, connection status, and the port on which the daemon or program is running. With socksstat, you can also display interprocess communication sockets, known as Unix domain sockets or IPC. The socksstat command, combined with the grep filter or the awk utility through a pipeline, turns out to be a powerful tool for local network management.

Meanwhile, netstat is used to view network status, including open ports, TCP/UDP connections, and more. The network statistics (netstat) command can also be used for troubleshooting and configuration, and it can also serve as a monitoring tool for network connections. It displays incoming and outgoing connections, routing tables, read ports, and statistics on the protocols used.

## 2. How to Use Sockstat

Before we learn how to use Sockstat, here's a list of commands you can use to work with Sockstat.

```console
DESCRIPTION
     The sockstat command lists open Internet or UNIX domain sockets.

     The following options are available:

     -4          Show AF_INET (IPv4) sockets.

     -6          Show AF_INET6 (IPv6) sockets.

     -C          Display the congestion control module, if applicable.  This
                 is currently only implemented for TCP.

     -c          Show connected sockets.

     -i          Display the inp_gencnt.

     -j jail     Show only sockets belonging to the specified jail ID or name.

     -L          Only show Internet sockets if the local and foreign addresses
                 are not in the loopback network prefix 127.0.0.0/8, or do not
                 contain the IPv6 loopback address ::1.

     -l          Show listening sockets.

     -n          Do not resolve numeric UIDs to user names.

     -p ports    Only show Internet sockets if the local or foreign port
                 number is on the specified list.  The ports argument is a
                 comma-separated list of port numbers and ranges specified as
                 first and last port separated by a dash.

     -P protocols
                 Only show sockets of the specified protocols.  The protocols
                 argument is a comma-separated list of protocol names, as they
                 are defined in protocols(5).

     -q          Quiet mode, do not print the header line.

     -S          Display the protocol stack, if applicable.  This is currently
                 only implemented for TCP.

     -s          Display the protocol state, if applicable.  This is currently
                 only implemented for SCTP and TCP.

     -U          Display the remote UDP encapsulation port number, if
                 applicable.  This is currently only implemented for SCTP and
                 TCP.

     -u          Show AF_LOCAL (UNIX) sockets.

     -v          Verbose mode.

     -w          Use wider field size for displaying addresses.
```

The following is an example of using the sockstat command.

### a. View all open ports

```console
root@ns1:~ # sockstat
USER     COMMAND    PID   FD PROTO  LOCAL ADDRESS         FOREIGN ADDRESS      
root     sshd       45933 4  tcp4   192.168.5.2:22        192.168.5.4:59217
root     sshd       45933 8  stream (not connected)
root     sshd       815   4  tcp6   *:22                  *:*
root     sshd       815   5  tcp4   *:22                  *:*
unbound  unbound    760   3  udp4   192.168.5.2:53        *:*
unbound  unbound    760   4  tcp4   192.168.5.2:53        *:*
unbound  unbound    760   5  udp4   192.168.5.2:853       *:*
unbound  unbound    760   6  tcp4   192.168.5.2:853       *:*
_tor     tor        1014  5  tcp4   192.168.5.2:9050      *:*
_tor     tor        1014  6  udp4   192.168.5.2:9053      *:*
root     syslogd    751   6  udp6   *:514                 *:*
root     syslogd    751   7  udp4   *:514                 *:*
ldap     slapd      542   6  stream /var/run/openldap/ldapi
ldap     slapd      542   7  tcp4   *:389                 *:*
```

In the example above we can explain it as follows.

- **USER:** The owner or user who owns the socket/port.
- **COMMAND:** The program that opened the socket/port.
- **PID:** The process ID of the command that owns the socket.
- **FD:** The socket's file descriptor number.
- **PROTO:** The transport protocol (usually TCP/UDP) associated with the open socket or the socket type in the case of Unix-domain sockets (datagram, stream, or seqpac) for UNIX sockets.
- **LOCAL ADDRESS:** The IP address and port used by the socket.
- **FOREIGN ADDRESS:** The remote IP address to which the socket is connected.

### b. View Open IP4 Ports

```console
root@ns1:~ # sockstat -4
USER     COMMAND    PID   FD PROTO  LOCAL ADDRESS         FOREIGN ADDRESS      
root     sshd       922   4  tcp4   192.168.5.2:22        192.168.5.4:55525
www      httpd      917   4  tcp4   *:80                  *:*
www      httpd      916   4  tcp4   *:80                  *:*
www      httpd      915   4  tcp4   *:80                  *:*
www      httpd      914   4  tcp4   *:80                  *:*
www      httpd      913   4  tcp4   *:80                  *:*
root     httpd      894   4  tcp4   *:80                  *:*
root     sshd       828   5  tcp4   *:22                  *:*
root     syslogd    760   7  udp4   *:514                 *:*
ldap     slapd      313   7  tcp4   *:389                 *:*
```

### c. Displaying Open IP6 Ports

```console
root@ns1:~ # sockstat -6
USER     COMMAND    PID   FD PROTO  LOCAL ADDRESS         FOREIGN ADDRESS      
www      httpd      917   3  tcp6   *:80                  *:*
www      httpd      916   3  tcp6   *:80                  *:*
www      httpd      915   3  tcp6   *:80                  *:*
www      httpd      914   3  tcp6   *:80                  *:*
www      httpd      913   3  tcp6   *:80                  *:*
root     httpd      894   3  tcp6   *:80                  *:*
root     sshd       828   4  tcp6   *:22                  *:*
root     syslogd    760   6  udp6   *:514                 *:*
```

### d. View Open TCP/UDP Protocols

```console
root@ns1:~ # sockstat -P tcp
USER     COMMAND    PID   FD PROTO  LOCAL ADDRESS         FOREIGN ADDRESS      
root     sshd       922   4  tcp4   192.168.5.2:22        192.168.5.4:55525
www      httpd      917   3  tcp6   *:80                  *:*
www      httpd      917   4  tcp4   *:80                  *:*
www      httpd      915   3  tcp6   *:80                  *:*
www      httpd      915   4  tcp4   *:80                  *:*
www      httpd      914   3  tcp6   *:80                  *:*
www      httpd      914   4  tcp4   *:80                  *:*
www      httpd      913   3  tcp6   *:80                  *:*
www      httpd      913   4  tcp4   *:80                  *:*
root     httpd      894   3  tcp6   *:80                  *:*
root     httpd      894   4  tcp4   *:80                  *:*
```

```console
root@ns1:~ # sockstat -P udp
USER     COMMAND    PID   FD PROTO  LOCAL ADDRESS         FOREIGN ADDRESS      
root     syslogd    760   6  udp6   *:514                 *:*
root     syslogd    760   7  udp4   *:514                 *:*
```

### e. Viewing Specific TCP/UDP Ports

```yml
root@ns1:~ # sockstat -P tcp -p 443
root@ns1:~ # sockstat -P udp -p 53
root@ns1:~ # sockstat -P tcp -p 443,53,80,21
```

### f. View Open and Connected Ports

```console
root@ns1:~ # sockstat -P tcp -p 22 -c
USER     COMMAND    PID   FD PROTO  LOCAL ADDRESS         FOREIGN ADDRESS      
root     sshd       922   4  tcp4   192.168.5.2:22        192.168.5.4:55525

root@ns1:~ # sockstat -P tcp -c
USER     COMMAND    PID   FD PROTO  LOCAL ADDRESS         FOREIGN ADDRESS      
root     sshd       922   4  tcp4   192.168.5.2:22        192.168.5.4:55525
```

### g. Viewing UNIX Socket and Pipe Names

```console
root@ns1:~ # sockstat -u
USER     COMMAND    PID   FD PROTO  LOCAL ADDRESS         FOREIGN ADDRESS      
root     sshd       922   8  stream (not connected)
root     syslogd    760   8  dgram  /var/run/log
root     syslogd    760   9  dgram  /var/run/logpriv
root     devd       549   4  stream /var/run/devd.pipe
root     devd       549   5  seqpac /var/run/devd.seqpacket.pipe
root     devd       549   8  dgram  -> /var/run/logpriv
ldap     slapd      313   6  stream /var/run/openldap/ldapi
```

### h. View Programs/Applications that Open Ports

```yml
root@ns1:~ # sockstat -46 | grep nginx
root@ns1:~ # sockstat -46 | grep ssh
root@ns1:~ # sockstat -46 | grep unbound
```

### i. View Connected Programs/Applications and Open Ports

```yml
root@ns1:~ # sockstat -46 -c| grep nginx
root@ns1:~ # sockstat -46 -c | grep ssh
```

In addition to the commands shown above, you can also try other commands, such as the following.

```console
root@ns1:~ # sockstat -46 -s -P TCP -p 22 -c
root@ns1:~ # sockstat -46 -c | egrep '22|389' | awk '{print $7}' | uniq -c | sort -nr
root@ns1:~ # sockstat -46 -c -p 22,389 | grep -v ADDRESS|awk '{print $7}' | uniq -c | sort -nr
root@ns1:~ # sockstat -46 -l -s
root@ns1:~ # sockstat -4 -l | grep :22
```

## 3. How to Use Netstat
Before we practice how to use sockstat, here is a list of commands you can use to work with netstat.

```console
usage: netstat [-46AaCcLnRSTWx] [-f protocol_family | -p protocol]
               [-M core] [-N system]
       netstat -i | -I interface [-46abdhnW] [-f address_family]
               [-M core] [-N system]
       netstat -w wait [-I interface] [-46d] [-M core] [-N system]
               [-q howmany]
       netstat -s [-46sz] [-f protocol_family | -p protocol]
               [-M core] [-N system]
       netstat -i | -I interface -s [-46s]
               [-f protocol_family | -p protocol] [-M core] [-N system]
       netstat -m [-M core] [-N system]
       netstat -B [-z] [-I interface]
       netstat -r [-46AnW] [-F fibnum] [-f address_family]
               [-M core] [-N system]
       netstat -rs [-s] [-M core] [-N system]
       netstat -g [-46W] [-f address_family] [-M core] [-N system]
       netstat -gs [-46s] [-f address_family] [-M core] [-N system]
       netstat -Q
```

The following is an example of using the sockstat command.

### a. View all ports and connections

```console
root@ns1:~ # netstat -a
Active Internet connections (including servers)
Proto Recv-Q Send-Q Local Address          Foreign Address        (state)    
tcp4       0     44 ns1.ssh                192.168.5.4.55525      ESTABLISHED
tcp4       0      0 *.http                 *.*                    LISTEN     
tcp6       0      0 *.http                 *.*                    LISTEN     
tcp4       0      0 *.ssh                  *.*                    LISTEN     
tcp6       0      0 *.ssh                  *.*                    LISTEN     
tcp4       0      0 *.ldap                 *.*                    LISTEN     
udp4       0      0 *.syslog               *.*                    
udp6       0      0 *.syslog               *.*                    
Active UNIX domain sockets
Address          Type   Recv-Q Send-Q            Inode             Conn             Refs          Nextref Addr
fffff80012530600 stream      0      0                0                0                0                0
fffff80012530c00 stream      0      0 fffff80012b6b7a0                0                0                0 /var/run/devd.pipe
fffff80012530d00 stream      0      0 fffff80012b697a0                0                0                0 /var/run/openldap/ldapi
fffff8001255ba00 dgram       0      0                0 fffff800126e8b00                0                0
fffff800126e8b00 dgram       0      0 fffff80012a201e8                0 fffff8001255ba00                0 /var/run/logpriv
fffff80012530700 dgram       0      0 fffff80012a205b8                0                0                0 /var/run/log
fffff80012530b00 seqpac      0      0 fffff80012b6b3d0                0                0                0 /var/run/devd.seqpacket.pipe
```

### b. View Open Connections

```console
root@ns1:~ # netstat -na -f inet
Active Internet connections (including servers)
Proto Recv-Q Send-Q Local Address          Foreign Address        (state)    
tcp4       0     44 192.168.5.2.22         192.168.5.4.15414      ESTABLISHED
tcp4       0      0 *.80                   *.*                    LISTEN     
tcp4       0      0 *.22                   *.*                    LISTEN     
tcp4       0      0 *.389                  *.*                    LISTEN     
udp4       0      0 *.514                  *.*                    
```

### c. Displays Kernel Memory Used by the Network

```console
root@ns1:~ # netstat -m
257/1018/1275 mbufs in use (current/cache/total)
256/506/762/109049 mbuf clusters in use (current/cache/total/max)
256/506 mbuf+clusters out of packet secondary zone in use (current/cache)
0/508/508/54524 4k (page size) jumbo clusters in use (current/cache/total/max)
0/0/0/16155 9k jumbo clusters in use (current/cache/total/max)
0/0/0/9087 16k jumbo clusters in use (current/cache/total/max)
576K/3298K/3874K bytes allocated to network (current/cache/total)
0/0/0 requests for mbufs denied (mbufs/clusters/mbuf+clusters)
0/0/0 requests for mbufs delayed (mbufs/clusters/mbuf+clusters)
0/0/0 requests for jumbo clusters delayed (4k/9k/16k)
0/0/0 requests for jumbo clusters denied (4k/9k/16k)
0 sendfile syscalls
0 sendfile syscalls completed without I/O request
0 requests for I/O initiated by sendfile
0 pages read by sendfile as part of a request
0 pages were valid at time of a sendfile request
0 pages were valid and substituted to bogus page
0 pages were requested for read ahead by applications
0 pages were read ahead by sendfile
0 times sendfile encountered an already busy page
0 requests for sfbufs denied
0 requests for sfbufs delayed
```

### d. Display Network Statistics

```console
root@ns1:~ # netstat -i
Name    Mtu Network       Address              Ipkts Ierrs Idrop    Opkts Oerrs  Coll
nfe0   1500 <Link#1>      00:24:21:88:69:24    65877     0     0      322     0     0
nfe0      - 192.168.5.0/2 ns1                    259     -     -      317     -     -
lo0   16384 <Link#2>      lo0                      0     0     0        0     0     0
lo0       - localhost     localhost                0     -     -        0     -     -
lo0       - fe80::%lo0/64 fe80::1%lo0              0     -     -        0     -     -
lo0       - your-net      localhost                0     -     -        0     -     -
```

### e. Display Socket Information

```console
root@ns1:~ # netstat -lx
Active Internet connections
Proto Recv-Q Send-Q Local Address                                 Foreign Address                               R-MBUF S-MBUF R-CLUS S-CLUS R-HIWA S-HIWA R-LOWA S-LOWA R-BCNT S-BCNT R-BMAX S-BMAX   rexmt persist    keep    2msl  delack rcvtime
tcp4       0     44 ns1.ssh                                       192.168.5.4.15414                                  0      1      0      0  65700  33580      1   2048      0    256 525600 268640    0.23    0.00 5321.34    0.00    0.00    0.00
Active UNIX domain sockets
Address          Type   Recv-Q Send-Q            Inode             Conn             Refs          Nextref Addr
fffff8000b472100 stream      0      0                0                0                0                0
fffff8000b546b00 stream      0      0 fffff8000b6f5000                0                0                0 /var/run/devd.pipe
fffff8000b546c00 stream      0      0 fffff8000b46b3d0                0                0                0 /var/run/openldap/ldapi
fffff8000b472600 dgram       0      0                0 fffff8000b472b00                0 fffff8000b472800
fffff8000b472800 dgram       0      0                0 fffff8000b472b00                0                0
fffff8000b472b00 dgram       0      0 fffff8000bfcc3d0                0 fffff8000b472600                0 /var/run/logpriv
fffff8000b472d00 dgram       0      0 fffff8000bfcc7a0                0                0                0 /var/run/log
fffff8000b546a00 seqpac      0      0 fffff8000b51ab70                0                0                0 /var/run/devd.seqpacket.pipe
```

While the netstat command is a powerful system administrator tool, you don't need to be a sysadmin to use it. As we've seen, netstat is useful in many scenarios, even if your goal is simply to secure your daily browsing activities.

However, netstat shouldn't be limited to the commands discussed here; options and flags can significantly expand the scope of what the netstat command can do.
