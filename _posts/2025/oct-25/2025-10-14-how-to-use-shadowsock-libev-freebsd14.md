---
title: How to Use Shadowsocks-libev on FreeBSD 14
date: "2025-10-14 20:02:15 +0100"
updated: "2025-10-14 20:02:15 +0100"
id: how-to-use-shadowsock-libev-freebsd14
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: Anonymous
background: /img/oct-25/oct-25-73.jpg
toc: true
comments: true
published: true
excerpt: In this tutorial, we'll show you how to install Shadowsocks-libev on a FreeBSD server, configure it, and use a client to connect to the proxy. All instructions in this article run on a FreeBSD 13.2 server. In this article, we'll use the private IP address 192.168.5.2, the ns6 server name, and the unixwinbsd.site domain.
keywords: freebsd, Shadowsocks-libev, Shadowsocks, libev, vpn, openvpn, tunnel
---

Shadowsocks is a secure socks5 proxy designed to protect your internet traffic. Shadowsocks can function as a tunnel proxy that can help you bypass firewalls. On FreeBSD, Shadowsocks is known as Shadowsocks-libev, written in the C programming language based on libev, prioritizing embedded devices and low-end boxes.

Shadowsocks can encrypt traffic between you and the server, preventing your Internet Service Provider from spying on you. Once your ISP doesn't know what's running on your computer, they won't intercept your traffic, allowing you to bypass ISP restrictions and easily bypass corporate firewalls and access censored sites.

For example, if you're in a situation where OpenVPN traffic is blocked or throttled, Shadowsocks is a good alternative to a VPN. It can be installed on a PFSense router to tunnel all network traffic.

![shadowsocks-libev](/img/oct-25/oct-25-73.jpg)


**Shadowsocks key features:**
- Super Fast.
- Cross-Platform.
- Flexible Encryption.
- Open Source.
- Mobile Ready.
- Easy to use.

## 1. Specifications of the System Used

In this tutorial, we'll show you how to install Shadowsocks-libev on a FreeBSD server, configure it, and use a client to connect to the proxy. All instructions in this article run on a FreeBSD 13.2 server.

In this article, we'll use the private IP address 192.168.5.2, the ns6 server name, and the unixwinbsd.site domain.

The recommended Shadowsocks-libev installation process on FreeBSD uses the ports system. As a first step, we'll update and upgrade the FreeBSD ports system. Run the command below.

```
root@ns6:~ # portmaster -af
root@ns6:~ # portupgrade -af
```

Before installing Shadowsocks-libev, you are required to install the Shadowsocks-libev library. Use the command below to install the Shadowsocks-libev library on your FreeBSD server.

```
root@ns6:~ # pkg install asciidoc xmlto libev mbedtls pcre libsodium c-ares
```

Once the library package is installed, run the following `“make”` command in your command line terminal to install Shadowsocks-libev.

```
root@ns6:~ # cd /usr/ports/net/shadowsocks-libev
root@ns6:~ # make config
```

<br/>

```
root@ns6:/usr/ports/net/shadowsocks-libev # make install clean
```

## 2. How to Configure Shadowsocks-libev

At this stage of the configuration, we will enable shadowocks-libev in `/etc/rc.conf`.

```
root@ns6:/usr/ports/net/shadowsocks-libev # ee /etc/rc.conf
shadowsocks_libev_enable="YES"
shadowsocks_libev_config="/usr/local/etc/shadowsocks-libev/config.json"
```

With the script above, shadowsocks can run automatically on a FreeBSD server.

Now, before we start shadowsocks on our server, let's edit the JSON file and insert the following configuration content. It contains your server's hostname or IP (IPv4/IPv6), server port number, local port number, password used to encrypt the transfer, connection timeout, and encryption method such as `"aes-256-cfb", "bf-cfb", "des-cfb", or "rc4"`.

Add the following code to the file `"/usr/local/etc/shadowsocks-libev/config.json"`.

```
{
    "server":["::1", "127.0.0.1"],
    "mode":"tcp_and_udp",
    "server_port":8388,
    "local_port":1080,
    "local_address": "192.168.5.2",
    "password":"router",
    "timeout":86400,
    "method":"chacha20-ietf-poly1305",
    "nameserver":"1.1.1.1",
    "fast_open": true

}
```


`"local address 192.168.5.2"` is the private IP address, and `"nameserver 1.1.1.1"` is Cloudflare's DNS server.

Okay, now let's start the Shadowsocks server:

```
root@ns6:~ # service shadowsocks_libev restart
Stopping shadowsocks_libev.
Waiting for PIDS: 45942.
Starting shadowsocks_libev.
 2023-12-09 14:09:13 INFO: binding to outbound IPv4 addr: 192.168.5.2
```

Shadowsocks is now running and will start automatically upon system startup. You can now use Shadowsocks-libev for proxy connections. To connect to the Shadowsocks proxy server, you'll need a client.


## 3. Run the Shadowsocks Client
Shadowsocks is supported by a number of different clients and devices. Install your preferred client and test the connection.

By default, shadowocks-libev runs as a server on FreeBSD. If you want to run shadowocks-libev in client mode, you need to configure the `/usr/local/etc/rc.d/shadowsocks_libev` file.

Open the `/usr/local/etc/rc.d/shadowsocks_libev` file and replace the `ss-server` script with `ss-local`.

```
root@ns6:~ # ee /usr/local/etc/rc.d/shadowsocks_libev
# command="/usr/local/bin/ss-server"
command="/usr/local/bin/ss-local"
```

Change the script `command="/usr/local/bin/ss-server"` to `command="/usr/local/bin/ss-local"`. Place a **"#"** around the script `command="/usr/local/bin/ss-server"`.

Restart shadowocks-libev.

```
root@ns6:~ # service shadowsocks_libev restart
```

Let's summarize. Shadowsocks is a powerful tool for combating digital censorship. With Shadowsocks, we can create anonymity on the internet, making it difficult for malicious actors to hack.