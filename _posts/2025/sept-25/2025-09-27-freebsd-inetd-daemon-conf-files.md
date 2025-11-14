---
title: FreeBSD INETD Daemon and inetd conf Configuration Files
date: "2025-09-27 15:14:29 +0100"
updated: "2025-09-27 15:14:29 +0100"
id: freebsd-inetd-daemon-conf-files
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: UnixShell
background: /img/oct-25/oct-25-70.jpg
toc: true
comments: true
published: true
excerpt: Inetd waits for connections on multiple ports, and when it receives a service request, it determines which application should handle the request and launches an instance of that program.
keywords: freebsd, inetd, daemon, configuration, conf, file, protocol, rc.d
---

On the FreeBSD operating system, there are many daemons with files with the .conf extension located in the /etc directory and other directories. Among these daemons, the most important and sensitive one that deserves serious attention is inetd, often called the "super server." Its job is to listen for connections on a specific set of network ports and launch the appropriate server process when a request comes in.

For example, inetd is responsible for telnet connections. If your FreeBSD system allows telnet, you can open a telnet connection and receive a login prompt without a telnetd process running on the server. Each time the system receives a connection request on port 23, it creates a new telnetd process to handle the connection.

So it's no surprise that many people refer to inetd as the Internet Super-Server because it manages connections for multiple services. When a connection is received by inetd, it determines which program the connection is for, then launches a specific process and delegates a socket to it.

When a peer connects to a port managed by inetd, inetd executes commands in a subprocess to handle the incoming request. The subprocess is assigned socket file descriptors for standard input, standard output, and standard error. Once the subprocess completes, for example, after printing the requested web page to its STDOUT, it exits, returning control to inetd.

In a traditional Unix scenario, a single server process (daemon) monitors connections on a specific port and handles incoming requests. In this case, if a server offers multiple services, many daemon processes must be started, most of which are in a waiting state but still consume resources, such as memory. The internet superserver, inetd, is an approach to addressing this problem.

Inetd waits for connections on multiple ports, and when it receives a service request, it determines which application should handle the request and launches an instance of that program.


![inetd conf freebsd](/img/oct-25/oct-25-70.jpg)


## 1. Inetd Configuration

The inetd configuration file is located at `/etc/inetd.conf`. Each line in this configuration file represents an application that inetd can run. By default, each line begins with a comment **(#)**, which means inetd is not listening for any applications. If you want to enable a specific application or port in inetd, remove the **"#"** at the beginning of the script.

Pay attention to the contents of the `/etc/inetd.conf` file script.


```
root@ns1:~ # ee /etc/inetd.conf
# $FreeBSD$
#
# Internet server configuration database
#
# Define *both* IPv4 and IPv6 entries for dual-stack support.
# To disable a service, comment it out by prefixing the line with '#'.
# To enable a service, remove the '#' at the beginning of the line.
#
#ftp    stream  tcp     nowait  root    /usr/libexec/ftpd       ftpd -l
#ftp    stream  tcp6    nowait  root    /usr/libexec/ftpd       ftpd -l
#ssh    stream  tcp     nowait  root    /usr/sbin/sshd          sshd -i -4
#ssh    stream  tcp6    nowait  root    /usr/sbin/sshd          sshd -i -6
#telnet stream  tcp     nowait  root    /usr/libexec/telnetd    telnetd
#telnet stream  tcp6    nowait  root    /usr/libexec/telnetd    telnetd
#shell  stream  tcp     nowait  root    /usr/local/sbin/rshd    rshd
#shell  stream  tcp6    nowait  root    /usr/local/sbin/rshd    rshd
#login  stream  tcp     nowait  root    /usr/local/sbin/rlogind rlogind
#login  stream  tcp6    nowait  root    /usr/local/sbin/rlogind rlogind
#finger stream  tcp     nowait/3/10 nobody /usr/libexec/fingerd fingerd -k -s
#finger stream  tcp6    nowait/3/10 nobody /usr/libexec/fingerd fingerd -k -s
#
# run comsat as root to be able to print partial mailbox contents w/ biff,
# or use the safer tty:tty to just print that new mail has been received.
#comsat dgram   udp     wait    tty:tty /usr/libexec/comsat     comsat
#
# ntalk is required for the 'talk' utility to work correctly
#ntalk  dgram   udp     wait    tty:tty /usr/libexec/ntalkd     ntalkd
#tftp   dgram   udp     wait    root    /usr/libexec/tftpd      tftpd -l -s /tftpboot
#tftp   dgram   udp6    wait    root    /usr/libexec/tftpd      tftpd -l -s /tftpboot
#bootps dgram   udp     wait    root    /usr/libexec/bootpd     bootpd
```

If you want any of the above applications to be active and usable, remove the `"#"` sign. After that, to enable the inetd superserver, you must enter the following script in the `/etc/rc.conf` file.


```
root@ns1:~ # ee /etc/rc.conf
inetd_enable="YES"
```

Restart so that inetd can run automatically.

```
root@ns1:~ # service inetd restart
Stopping inetd.
Waiting for PIDS: 2500.
Starting inetd.
```

## 2. How to read the inetd.conf script

In the `/etc/inetd.conf` file above, we can see that the file contents consist of three columns, as in the following example (taken from the `/etc/inetd.conf` file above).

```
#ftp    stream  tcp     nowait  root    /usr/libexec/ftpd       ftpd -l
```
Okay, now let's discuss what each column means.

### a. Service-name

The service name or program name that reflects the port number on which inetd should listen for incoming connections. This can be a decimal number or the service name specified in `/etc/services`, such as ftp, ssh, telnet, login, and so on.

### b. socket-type

The socket type used by inetd for communication. The socket type must be one of stream, dgram, raw, rdm, and seqpacket.

- stream is used for stream sockets.
- dgram is used for UDP services.
- raw is used for binary sockets.
- rdm is used to guarantee message delivery to the recipient, and
- seqpacket is used for reserved packet sockets.

The most common socket types are stream and dgram.

### c. Protocol

The protocol type used by Inetd can be TCP or UDP, either IP4 or IP6.

### d. wait/nowait

This field tells inetd whether to wait for the server program to return or immediately resume processing new connections. Many server connections require a response after data transfer is complete, while others may continue transferring data continuously. In the latter case, the situation is **"nowait," and in the former, "wait"**.

In most cases, this value corresponds to the socket type; for example, a streaming connection would correspond to **"nowait"**.


### e. username[:group]

The name of the user or group used by inetd.

### f. server program

The directory location of the program to be run or executed by inetd.

### g. argument-list

This last column lists the arguments for running the program, including the program name and any additional program arguments the system administrator may need to provide.

In inetd, all services or daemons run by inetd must match the services listed in the `/etc/services` file. This determines which inetd port listens for incoming connections to that service. When using custom services, they must first be added to `/etc/services`.

Although inetd is considered a superserver, in reality, many daemons run by inetd are not security-conscious. Some daemons, such as fingerd, can provide information that could be useful to attackers. Enable only necessary services and monitor the system for excessive connection attempts.