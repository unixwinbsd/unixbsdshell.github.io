---
title: Fully Encrypt Your Home DNS Traffic With CoreDNS
date: "2025-10-18 08:39:47 +0100"
updated: "2025-10-18 08:39:47 +0100"
id: fully-encrypt-home-dns-traffic-with-coredns
lang: en
author: Iwan Setiawan
robots: index, follow
categories: linux
tags: DNSServer
background: /img/oct-25/oct-25-112.jpg
toc: true
comments: true
published: true
excerpt: To fully secure your DNS, you'll need two pieces of software CoreDNS and DNSProxy, both high-performance GoLang-based DNS programs that you can download from their respective GitHub Releases pages.
keywords: fully, encrypt dns, trafficcoredns, linux, ubuntu, debian, dns server, doh, dot, dnssec, validation, resolver
---

Traditionally, DNS requests and replies are made in plain text. These requests and replies are sent over the internet without any encryption or protection, even when you're accessing a secure website. This has significant security and privacy implications, as these requests can be subject to surveillance, spoofing, and tracking by malicious actors, advertisers, ISPs, and others.

Your DNS server knows a lot about you—it even knows every website you visit. Between ISPs intercepting valid and invalid domains, and the possibility of selling your browsing history to advertisers, it's both prudent and very easy to encrypt all your DNS to prevent this and, more importantly, to encrypt this typically plain text data to prevent spying.

<br/>
{% lazyload data-src="/img/oct-25/oct-25-112.jpg" src="/img/oct-25/oct-25-112.jpg" alt="Fully Encrypt Your Home DNS Traffic With CoreDNS" %}
<br/>

## 1. SOFTWARE and HARDWARE

To fully secure your DNS, you'll need two pieces of software: CoreDNS and DNSProxy, both high-performance GoLang-based DNS programs that you can download from their respective GitHub Releases pages.

With these two programs, we'll set up a DNS server, DNS over TLS, and DNS over HTTPS.

Because CoreDNS and DNSProxy are so lightweight and low-resource requirements, we can easily run a fully secure local DNS server on something as small as a Raspberry Pi (I recommend a Pi 4 with 2GB for the ethernet connection only), or as something more robust like a local VM, LXD, or even a Docker container!.


## 2. CONFIGURATION

Configuring CoreDNS and DNS Proxy is fairly straightforward, but for DoH and DoT, you'll need a valid TLS certificate. You can use my guide to create a CA and sign a certificate, or if you plan to use an existing domain with my partial plugin, you can sign your certificate with certbot.

### a. COREDNS

Once you've obtained a valid certificate, you can download CoreDNS from the Releases page on GitHub for your platform: https://github.com/coredns/coredns/releases. Copy this binary to /usr/bin and mark it as executable.

```console
$ wget https://github.com/coredns/coredns/releases/download/v1.8.4/coredns_1.8.4_linux_amd64.tgz
$ tar -xf coredns_1.8.4_linux_amd64.tgz
$ chmod +x coredns
$ mv coredns /usr/binSet
```

For security reasons, we'll run CoreDNS with its own user. On Ubuntu, we can easily create this new user as follows:

```console
$ useradd -Umrs /bin/false coredns
```

Create a directory to store your CoreDNS configuration, and set its ownership to CoreDNS.

```console
$ mkdir -p /etc/coredns
$ chown root:coredns
```

Next, create `/etc/coredns/Corefile` and place the following in it. Note that in this example, we're using a LetsEncrypt certificate make sure you adjust the path as needed.

```
.:1054 {
	reload
    errors

    forward . tls://1.1.1.1 tls://1.0.0.1 {
            tls_servername cloudflare-dns.com
            health_check 5s
            expire 3600s
    }

	cache 30
}

tls://.:853 {
	reload
	errors
	
	tls /opt/letsencrypt/live/coredns.example.com/fullchain.pem /opt/letsencrypt/live/coredns.example.com/privkey.pem {
		client_auth verify_if_given
	}

    forward . 127.0.0.1:1054 {
            health_check 5s
            expire 3600s
            policy sequential
    }
}

.:53 {
	reload
	errors
    forward . 127.0.0.1:1054 {
            health_check 5s
            expire 3600s
            policy sequential
    }
}
```

Before we continue, let's break down what it does from bottom to top:

### b. DNS Resolver

Here we have a standard DNS resolver that forwards everything it receives to internal port 1054. Since most requests are unencrypted, this will ensure that all requests to your DNS server are forwarded to an upstream server that will ensure that the request is encrypted before leaving your network.

```
.:53 {
	reload
	errors
    forward . 127.0.0.1:1054 {
            health_check 5s
            expire 3600s
            policy sequential
    }
}
```

### c. DoT Resolver

Applications that support it can use the DNS over TLS (DoT) resolver, which does exactly the same thing as a standard DNS resolver – forwards all traffic to our upstream server on port 1054 which will encrypt everything beyond it.


```
tls://.:853 {
	reload
	errors
	
	tls /opt/letsencrypt/live/coredns.example.com/fullchain.pem /opt/letsencrypt/live/coredns.example.com/privkey.pem {
		client_auth verify_if_given
	}

    forward . 127.0.0.1:1054 {
            health_check 5s
            expire 3600s
            policy sequential
    }
}
```

### d. Internal Forwarding Server

Finally, we run an internal forwarding server on port 1054. This is used internally only and ensures that all requests are forwarded to a trusted DNS server over TLS. In this example, I'm using Cloudflare, but you can use any upstream provider you prefer.

Also, if you want to add custom rules or activate any plugins, add them before the forwarding section.


```
.:1054 {
	reload
    errors

    forward . tls://1.1.1.1 tls://1.0.0.1 {
            tls_servername cloudflare-dns.com
            health_check 5s
            expire 3600s
    }

	cache 30
}
```

Next, we need to create a systemd file to start and manage CoreDNS. You can place it at `/etc/systemd/system/coredns.service`.

```sh
[Unit]
Description=CoreDNS DNS server
Documentation=https://coredns.io
After=network.target

[Service]
PermissionsStartOnly=true
LimitNOFILE=1048576
LimitNPROC=512
CapabilityBoundingSet=CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_BIND_SERVICE
NoNewPrivileges=true
User=coredns
WorkingDirectory=/tmp
ExecStart=/usr/bin/coredns -conf=/etc/coredns/Corefile
ExecReload=/bin/kill -SIGUSR1 $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Finally, open the firewall on your computer for 53 and 853, and start the service.

```sh
$ ufw allow 53
$ ufw allow 853

$ systemctl daemon-reload
$ systemctl enable coredns
$ systemctl start coredns
```
<br/>
Validate CoreDNS is running with journalctl vial, systemd status, or by checking if the process is running `(ps aux | grep coredns)`, then you can validate it is working using `dig and kdig`.
<br/>
### e. DNSPROXY

While CoreDNS provides DNS and DoT resolvers, it doesn't provide DNS over HTTPS or DoH resolvers, which Firefox and Chrome use as part of their "secure DNS" options. Fortunately, these are fairly easy to set up and enable.

First, download and install DNSProxy from the GitHub page in `/usr/local/bin`.

```
$ wget https://github.com/AdguardTeam/dnsproxy/releases/download/v0.38.1/dnsproxy-linux-amd64-v0.38.1.tar.gz
$ mv path/to/dnsproxy /usr/local/bin
$ chmod +x /usr/local/bin/dnsproxySetda
```

DNSProxy is quite easy to set up, meaning we can put all our configuration into the systemd file at `/etc/systemd/system/dnsproxy.service`. Typically, it creates DoH resolvers on ports 443 and 8443 for QUIC, which forward everything to CoreDNS, ensuring that everything is fully encrypted.

```sh
[Unit]
Description=DNSProxy - DoH and DoQ Proxy for CoreDNS
Documentation=https://github.com/AdguardTeam/dnsproxy
After=network.target

[Service]
PermissionsStartOnly=true
LimitNOFILE=1048576
LimitNPROC=512
CapabilityBoundingSet=CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_BIND_SERVICE
NoNewPrivileges=true
User=coredns
WorkingDirectory=/tmp
ExecStart=/usr/local/bin/dnsproxy -l 0.0.0.0 --tls-min-version=1.2 --quic-port=8853 --https-port=443 --tls-crt=/opt/letsencrypt/live/coredns.example.com/fullchain.pem --tls-key=/opt/letsencrypt/live/coredns.example.com/privkey.pem -u 127.0.0.1:53 -p 0
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Finally, open the ports and start the service and you have a fully encrypted local DNS.

```
$ ufw allow 443
$ ufw allow 8443
$ systemctl enable dnsproxy
$ systemctl start dnsproxy
```

Don't forget to update your resolve.conf file to point to your new DNS servers, or to apply your configuration network-wide, update your router configuration to advertise the IP of your DNS server running CoreDNS.

### f. Validation

We can validate our configuration using dig, kdig, and curl for DNS, DoT, and DoH.

Normal DNS validation is quite straightforward:

```
dig www.google.com @127.0.0.1SeSe
```

DoT validation requires knot-dns, but once installed it can be checked by running the following command.

```
kdig www.google.com @coredns.example.com +tls
```

DoH validation is just as easy, but I personally prefer using the dog tool to validate it.

```
dog example.com --https @https://coredns.example.com/dns-query
```
Of course, you can use something like dog to validate TLS and UDP endpoints as well as TCP.

### g. Modzilla Firefox and Google Chrome

Firefox and Chrome provide a few guides on how to configure them with custom DoH providers.

For Google Chrome, go to the security settings and change DoH to Custom, using the following customized URL: https://coredns.example.com/dns-query. For Firefox, the changes are identical.

The easiest way to verify Firefox is working properly is to visit about:networking#dns and see if TRR (Trusted Recursive Resolver) returns true for any domain.

Using encrypted DNS traffic is a great way to increase your privacy and security while browsing the internet. Remember that no matter which type of DNS encryption you choose, it's more secure than no encryption at all. A proper DNS traffic filtering system can keep you and your organization safe from DNS attacks and help you save valuable resources.