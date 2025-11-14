---
title: Setup DNSCrypt Proxy With Knot Reolver Kresd On FreeBSD
date: "2025-05-31 07:01:10 +0100"
updated: "2025-05-31 07:01:10 +0100"
id: dnscrypt-proxy-knot-resolver-dns-freebssd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DNSServer
background: https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/18diagram%20knot%20resolver.jpg&commit=5f79804a8721e71786ac64dd501c28906c3e2255
toc: true
comments: true
published: true
excerpt: DNSCrypt is an application implemented in unbundled software, such as dnsdist, dnscrypt-wrapper, and dnscrypt-proxy. The application supports modern encrypted DNS protocols DNSCrypt v2, DNS-over-HTTPS, and Anonymous DNSCrypt.
keywords: knot, resolver, dns, caching, name server, kresd, implementation, freebsd, openbsd, dnscrypt, proxy, dnscrypt proxy
---

DNSCrypt is an application implemented in unbundled software, such as dnsdist, dnscrypt-wrapper, and dnscrypt-proxy. The application supports modern encrypted DNS protocols DNSCrypt v2, DNS-over-HTTPS, and Anonymous DNSCrypt.

DNSCrypt-proxy is a dynamic and flexible DNS proxy service. This application can be installed on almost all computers, routers on all operating systems. Its ease of installation makes DNSCrypt-proxy so popular, as you can block unwanted content locally, find out where your device is sending data, speed up applications by caching DNS responses, and increase security and privacy by communicating with DNS servers over a secure channel and trustworthy.

In the previous video, the installation process for DNSCrypt-proxy with Unbound and PFSense was explained. In this article, we will review the DNSCrypt proxy installation process with Knot Resolver. In this discussion we will use DNSCrypt-proxy as the backend of the `Knot Resolver` DNS server.
Look at the image below.

<br/>
<img alt="Diagram Knot Resolver" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/18diagram%20knot%20resolver.jpg&commit=5f79804a8721e71786ac64dd501c28906c3e2255' | relative_url }}">
<br/>

## 1. System Specifications

- OS: FreeBSD 13.2
- Domain: datainchi.com
- IP address: 192.168.5.2
- Hostname: ns3
- Knot resolver version:  knot-resolver-5.7.0_1
- DNSCrypt proxy version: dnscrypt-proxy2-2.1.5_2


## 2. Install DNSCrypt-Proxy

FreeBSD makes it easy for you to install DNSCrypt-proxy, because dnscrypt-proxy is available in the official repo. To start the installation process, you can use the ports system or the FreeBSD PKG package. In this article we will use the ports system for the DNSCrypt-proxy installation process.

If you are using a Windows system to run the FReeBSD server, open the Putty application, and in the Putty shell type the following command.
```console
root@ns3:~ # cd /usr/ports/dns/dnscrypt-proxy2
root@ns3:/usr/ports/dns/dnscrypt-proxy2 # make config
root@ns3:/usr/ports/dns/dnscrypt-proxy2 # make install clean
```
After the installation process is complete, you create Start Up rc.d, so that DNSCrypt-proxy can run automatically. To make it, you only need to edit the `/etc/rc/conf` file and enter the script below into the file.

```
dnscrypt_proxy_enable="YES"
dnscrypt_proxy_conf =""/usr/local/etc/dnscrypt-proxy/dnscrypt-proxy.toml"
dnscrypt_proxy_uid="_dnscrypt-proxy"
```

With the script above, when your computer restarts or turns it off, DNSCrypt-proxy will automatically run, according to the script in the `/etc/rc/conf` file.

The next step, you change the DNSCrypt-proxy configuration file. The config file is located in the `/usr/local/etc/dnscrypt-proxy` directory. You open the `dnscrypt-proxy.toml` file then just change a few scripts, like the example below.

```
server_names = ['scaleway-fr', 'google', 'yandex', 'cloudflare']
listen_addresses = ['127.0.0.1:5353']
```

Leave the other scripts at default, you only need to change the 2 scripts above.

If you have finished configuring everything, perform the `Restart` command on `DNSCrypt-proxy`.
```
root@ns3:~ # service dnscrypt-proxy restart
```


## 3. Knot Resolver Configuration

In this article we will not explain the Knot Reslover installation process. If you need an explanation of Knot Resolver installation, you can read our previous article.

[FreeBSD Knot Resolver - DNS Caching Resolver Implementation](https://unixwinbsd.site/freebsd/knot-resolver-dns-caching-freebssd/)

The process of configuring "Knot Resolver" so that it can connect to the `DNSCrypt-proxy` server is very easy. You just need to change the basic configuration file of Knot Resolver which is `kresd.conf`. Open the `/usr/local/etc/knot-resolver/kresd.conf` file and delete all the contents of the script then replace it with the script below.

```
net.listen('192.168.5.2', 53, { kind = 'dns' })


-- Load useful modules
modules = {
	
	'policy',                    -- Block queries to local zones/bad sites
        'hints > iterate',       -- Allow loading /etc/hosts or custom root hints
        'serve_stale < cache',   -- Allows stale-ness by up to one day, after roughly four seconds trying to contact the servers
        'workarounds < iterate', -- Alters resolver behavior on specific broken sub-domains
        'predict',               -- Prefetch expiring/frequent records
        'stats',                 -- Track internal statistics
        'cache',
}

internal_domains = policy.todnames({
  'datainchi.com.'
})

-- Answers for reverse queries about the 192.168.1.0/24 subnet
-- are to be obtained from IP address 127.0.0.1 port 5353(dnscrypt-proxy) 
-- or port 5053(cloudflared-tunnel)
-- This disables DNSSEC validation !!!

policy.add(policy.all(policy.FORWARD({'127.0.0.1@5353'})))

-- policy.add(policy.suffix(policy.PASS, {todname('1.168.192.in-addr.arpa')}))

-- Cache size
cache.size = 100 * MB
```

End of configuration in this article, RESTART `Knot Resolver` and `DNSCrypt-proxy`.
```console
root@ns3:~ # service kresd restart
root@ns3:~ # service dnscrypt-proxy restart
```
The installation and configuration process is complete. Your FreeBSD server now has Knot Resolver running which forwards to the `DNSCrypt-proxy` server.

You now have a secure DNS resolver configured in the cloud, as well as a local proxy client connected to it. Using a DNSCrypt server and client, you can easily provide privacy and security for both server clusters and home networks.




