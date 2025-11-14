---
title: Securing OpenBSD DNS Servers with DNSProxy and DNS Over HTTPS
date: "2025-10-18 13:36:17 +0100"
updated: "2025-10-18 13:36:17 +0100"
id: securing-openbsd-dns-server-with-dnsproxy-doh
lang: en
author: Iwan Setiawan
robots: index, follow
categories: openbsd
tags: DNSServer
background: /img/oct-25/oct-25-113.jpg
toc: true
comments: true
published: true
excerpt: This article will explain the installation and configuration process for DNSProxy and DNS Over HTTPS software on an OpenBSD system. We will also explain how to use both applications on a DNS server called ISC-Bind.
keywords: securing, openbsd, dns servers, dnsproxy, dns over https, tls, doh, doh
---

As we know, SSH port 22 and HTTP port 80 are highly vulnerable to hackers. These two ports are very popular because they are considered the right choice for accessing other people's internet networks. Furthermore, DNS port 53 is also highly favored by intruders who want to steal all our data. Therefore, we must protect port 53 to keep it safe from intruders.

There are many ways to improve port 53 security. Some use firewalls to encrypt DNS servers, while others use paid methods. However, did you know that there is a cheaper and free way to secure our DNS server network? There are many applications that can encrypt DNS server traffic.

One common one is to redirect DNS ports to Domain over TLS or Domain over HTTPS. With DOT and DOH, we can encrypt all traffic accessing port 53 from our server.

This article will explain the installation and configuration process for DNSProxy and DNS Over HTTPS software on an OpenBSD system. We will also explain how to use both applications on a DNS server called ISC-Bind. In our implementation, we will use a DNS server called Bind as the frontend for DNSProxy and DNS Over HTTPS.

<br/>
![openbsd dnsproxy](/img/oct-25/oct-25-113.jpg)
<br/>


## 1. Go Path Environment

Before we install DNSProxy, you'll need to create a Go environment path using Bash. Why? Because both applications we'll discuss are written in Go, and by default, OpenBSD places the Go path in `/root`. As we know, with the default OpenBSD installation, `/root` is very small, so it may not be large enough to store the Go path.


```console
ns3# pkg_add bash
ns3# touch /root/.bash_profile
```

In the `/root/.bash_profile` file, type the script below.


```console
export GOVERSION=go1.22+
export GOCACHE=/var/go/.cache/go-build
export GOENV=/var/go/env
export GOMODCACHE=/var/go/pkg/mod
export GOPATH=/var/go
export GOROOT=/usr/local/go
export GOHOSTOS=openbsd
export GOTOOLDIR=/usr/local/go/pkg/tool/openbsd_amd64
```

To activate the Go environment path, you run Bash followed by the source command to execute it.


```bash
ns3# bash
bash-5.2# source /root/.bash_profile
```


## 2. Setup DNSProxy

In this first section, we'll discuss DNSProxy. OpenBSD, unlike FreeBSD, boasts a rich software offering, with hundreds of software packages available in the FreeBSD repositories. However, OpenBSD offers very limited software support.

One such software is the software we'll discuss in this article. DNSProxy isn't available in the OpenBSD repositories. If you want to use this software, you'll need to clone it from GitHub.

### a. Install DNSProxy

Before we discuss configuration further, the first step is to clone the DNSProxy software from GitHub. Use the command below to download DNSProxy from GitHub.

```console
ns3# cd /etc
ns3# git clone https://github.com/AdguardTeam/dnsproxy.git
```

Once the download is complete, please proceed with the installation process. For guidance, you can follow the instructions below.


```bash
ns3# bash
bash-5.2# go version      
bash-5.2# cd /etc/dnsproxy
bash-5.2# go build -v ./...
```

When the DNSProxy creation process is complete, we will run the gmake command to continue the installation process.

```console
bash-5.2# gmake
bash-5.2# gmake build
```

The above build process will generate a `"dnsproxy"` binary file. You'll need to move this binary file to run it on all user levels.


```console
bash-5.2# mv /etc/dnsproxy/dnsproxy /usr/local/bin/
bash-5.2# exit
```

### b. DNSProxy Configuration

If you're new to DNSProxy, you might be confused about how to use it. That confusion will soon disappear if you continue learning and read this article to the end. There's an easy guide to running DNSProxu; simply type the following command.

```console
ns3# dnsproxy -help
```

By default the main configuration file is `/etc/dnsproxy/config.yaml`.dist, to avoid typing errors in the script, you should backup this file.

```console
ns3# cp -R /etc/dnsproxy/config.yaml.dist /etc/dnsproxy/config.yaml.dist.back
```

Now try opening the `/etc/dnsproxy/config.yaml.dist` file and then enter the script as below.


```yml
bootstrap:
   - "8.8.8.8:53"
listen-addrs:
  -  "192.168.5.3"
listen-ports:
  -  8553
max-go-routines: 0
ratelimit: 0
ratelimit-subnet-len-ipv4: 24
#ratelimit-subnet-len-ipv6: 64
udp-buf-size: 0
upstream:
  - "tls://dns.adguard.com"
  - "tcp://dns.google"
  - "tcp://1.1.1.1"
  - "https://dns.google/dns-query"
  - "https://dns.adguard.com/dns-query"  
  - "udp://dns.google"  
  - "sdns://AQMAAAAAAAAAETk0LjE0MC4xNC4xNDo1NDQzINErR_JS3PLCu_iZEIbq95zkSV2LFsigxDIuUso_OQhzIjIuZG5zY3J5cHQuZGVmYXVsdC5uczEuYWRndWFyZC5jb20"
  - "sdns://AgcAAAAAAAAABzEuMC4wLjGgENk8mGSlIfMGXMOlIlCcKvq7AVgcrZxtjon911-ep0cg63Ul-I8NlFj4GplQGb_TTLiczclX57DvMV8Q-JdjgRgSZG5zLmNsb3VkZmxhcmUuY29tCi9kbnMtcXVlcnk"
  - "9.9.9.9:53"
  - "1.0.0.1:53"
timeout: '10s'
#http3: 'yes'
https-port:
   - 443
tls-port:
   - 853
#dnscrypt-port: 
#    - 5353
##tls-crt: "/etc/ssl/dnsproxy/ssl2/etcd/certs/ca.pem"
##tls-key: "/etc/ssl/dnsproxy/ssl2/etcd/certs/ca-key.pem"
##tls-cert-bundle: /etc/ssl/dnsproxy/ssl1/ca.crt

tls-crt: "/etc/ssl/dnsproxy/ca.pem"
tls-key: "/etc/ssl/dnsproxy/ca-key.pem"

#tls-min-version: 1.0
#tls-max-version: 1.3
```



### c. Create a TLS/SSL Certificate

Since DNSProxy will be running the TLS protocol, you'll need to create a TLS/SSL certificate first. This certificate will encrypt all your DNS traffic. In this article, we'll be using a CloudFlare CFSSL certificate.

For complete information on installing and configuring a CloudFlare CFSSL certificate on OpenBSD, please see the link below.

[OpenBSD CloudFlare CFSSL Certificate - Creating a CA Private PKI TLS Certificate For DNS Server Clients](https://unixwinbsd.site/openbsd/openbsd-cloudflare-cfssl-certificate-pki-tls/)

We created four JSON files: `ca.json, cfssl.json, dns-host.json, and intermediate-ca.json`. Follow the instructions below to create the four JSON files.

```console
ns3# mkdir -p /etc/ssl/dnsproxy
ns3# touch /etc/ssl/dnsproxy/ca.json
ns3# touch /etc/ssl/dnsproxy/cfssl.json
ns3# touch /etc/ssl/dnsproxy/dns-host.json
ns3# touch /etc/ssl/dnsproxy/intermediate-ca.json
```

<br/>

```console
ns3# chown -R 770 /etc/ssl/dnsproxy/ca.json
ns3# chown -R 770 /etc/ssl/dnsproxy/cfssl.json
ns3# chown -R 770 /etc/ssl/dnsproxy/dns-host.json
ns3# chown -R 770 /etc/ssl/dnsproxy/intermediate-ca.json
```

In all four json files, insert the script below.

```console
{
    "CN": "kursor.my.id",
    "key": {
      "algo": "ecdsa",
      "size": 256
    },
    "names": [
    {
      "C":  "LI",
      "L":  "Vaduz",
      "O":  "Internet Widgets, Inc.",
      "OU": "WWW"
    }
   ]
  }
```

<br/>

```console
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "intermediate_ca": {
        "usages": [
            "signing",
            "digital signature",
            "key encipherment",
            "cert sign",
            "crl sign",
            "server auth",
            "client auth"
        ],
        "expiry": "8760h",
        "ca_constraint": {
            "is_ca": true,
            "max_path_len": 0, 
            "max_path_len_zero": true
        }
      },
      "peer": {
        "usages": [
            "signing",
            "digital signature",
            "key encipherment", 
            "client auth",
            "server auth"
        ],
        "expiry": "8760h"
      },
      "server": {
        "usages": [
          "signing",
          "digital signing",
          "key encipherment",
          "server auth"
        ],
        "expiry": "8760h"
      },
      "client": {
        "usages": [
          "signing",
          "digital signature",
          "key encipherment", 
          "client auth"
        ],
        "expiry": "8760h"
      }
    }
  }
}
```
<br/>

```console
{
  "CN": "ns3.kursor.my.id",
  "key": {
    "algo": "ecdsa",
    "size": 256
  },
  "names": [
  {
    "C":  "LI",
    "L":  "Vaduz",
    "O":  "Internet Widgets, Inc.",
    "OU": "WWW"
  }
 ],
 "hosts": [
  "ns3.kursor.my.id"
  ]
}
```
<br/>

```console
{
  "CN": "kursor.my.id",
  "key": {
    "algo": "ecdsa",
    "size": 256
  },
  "names": [
  {
    "C":  "LI",
    "L":  "Vaduz",
    "O":  "Internet Widgets, Inc.",
    "OU": "WWW"
  }
 ],
  "ca": {
    "expiry": "42720h"
  }
}
```

Generate a TLS certificate. For this example, I'll use a self-signed certificate. Root CA.

```console
ns3# cd /etc/ssl/dnsproxy
ns3# cfssl gencert -initca ca.json | cfssljson -bare ca
ns3# cfssl gencert -initca intermediate-ca.json | cfssljson -bare intermediate_ca
ns3# cfssl sign -ca ca.pem -ca-key ca-key.pem -config cfssl.json -profile intermediate_ca intermediate_ca.csr | cfssljson -bare intermediate_ca
ns3# cfssl gencert -ca intermediate_ca.pem -ca-key intermediate_ca-key.pem -config cfssl.json -profile=server dns-host.json | cfssljson -bare dns-server dnsproxy
```

### d. Run DNSProxy

You'll need to create an rc.d script so DNSProxy can run automatically on OpenBSD. You can open the `/etc/rc.d` directory to create an automatic boot script. We'll create the `/etc/rc.d/dns_proxy` file.


```console
ns3# touch /etc/rc.d/dns_proxy
ns3# chmod -R +x /etc/rc.d/dns_proxy
```

In the `/etc/rc.d/dns_proxy` file you include the script to boot. You can see a sample script below.


```console
#!/bin/ksh

daemon="/usr/local/bin/dnsproxy"
daemon_flags="--config-path=/etc/dnsproxy/config.yaml.dist"

. /etc/rc.d/rc.subr

pexp="${daemon}${daemon_flags:+ ${daemon_flags}}.*"

rc_bg=YES
rc_reload=NO

rc_cmd $1
```

Enable and run DNSProxy.

```console
ns3# rcctl enable dns_proxy
ns3# rcctl restart dns_proxy
dns_proxy(ok)
dns_proxy(ok)
```

The next step is to test DNSProxy, whether DNSProxy is running or not.

```console
ns3# dig -p 8553 yahoo.com @192.168.5.3
```

## 3. Configure dns-over-https

In the next lesson, we'll install `"dns-over-https"` on OpenBSD. dns-over-https is a high-performance DNS over HTTPS client and server. This software includes two main configuration files: doh-ser and doh-client. Like DNSProxy, dns-over-https is not available in the OpenBSD repositories. You can download it from the GitHub repository.

## a. Instal dns-over-https

The DNS-over-https installation process is almost identical to DNSProxy. We still use Bash to install DNS-over-https. The configuration process is exactly the same; there are no differences in the installation and configuration between DNS-over-https and DNSProxy.


```console
ns3# cd /usr/local
ns3# git clone https://github.com/m13253/dns-over-https.git
ns3# cd dns-over-https
```

To install DNS-over-https, we use go and gmake. Follow the guide below to begin the DNS-over-https installation process.

```console
ns3# bash
bash-5.2# cd /usr/local/dns-over-https
bash-5.2# go build -v ./...
bash-5.2# gmake
bash-5.2# gmake install
```

## b. Create a TLS/SSL Certificate for DNS-over-https

Creating a DNS-over-https TLS/SSL certificate is almost the same as creating a DNSProxy certificate. You can read about (c. Creating a TLS/SSL Certificate) in the DNSProxy discussion. We'll place the DNS-over-https certificate in the `/etc/ssl/dns-over-https` directory.


```console
ns3# mkdir -p /etc/ssl/dns-over-https
ns3# cd /etc/ssl/dns-over-https 
ns3# cp -R /etc/ssl/dnsproxy/ca.json /etc/ssl/dns-over-https/
ns3# cp -R /etc/ssl/dnsproxy/cfssl.json /etc/ssl/dns-over-https/
ns3# cp -R /etc/ssl/dnsproxy/dns-host.json /etc/ssl/dns-over-https/
ns3# cp -R /etc/ssl/dnsproxy/intermediate-ca.json /etc/ssl/dns-over-https/
```

<br/>

```console
ns3# cd /etc/ssl/dns-over-https
ns3# cfssl gencert -initca ca.json | cfssljson -bare ca
ns3# cfssl gencert -initca intermediate-ca.json | cfssljson -bare intermediate_ca
ns3# cfssl sign -ca ca.pem -ca-key ca-key.pem -config cfssl.json -profile intermediate_ca intermediate_ca.csr | cfssljson -bare intermediate_ca
ns3# cfssl gencert -ca intermediate_ca.pem -ca-key intermediate_ca-key.pem -config cfssl.json -profile=server dns-host.json | cfssljson -bare dns-server dnsproxy
```