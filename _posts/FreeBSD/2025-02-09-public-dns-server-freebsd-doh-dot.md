---
title: Best free Public DNS Server with DOH and DOT encryption
date: "2025-02-09 12:17:10 +0100"
id: public-dns-server-freebsd-doh-dot
lang: en
layout: single
author_profile: true
categories:
  - FreeBSD
tags: "DNSServer"
excerpt: The main advantage of using DNS servers that support DOH (DNS over HTTPS) and DOT (DNS over TLS) is
keywords: public, command, dns, server, freebsd, string, integer, doh, dot
---

In this article we will discuss the list of free public DNS with a high level of security. The content of this article is intended for those who prefer to use external DNS servers that have DOH and DOT encryption on their devices.

The main advantage of using DNS servers that support DOH (DNS over HTTPS) and DOT (DNS over TLS) is the inability to recognize and change your DNS queries along the data path between your device and the DNS server. That is, only your computer (smartphone) and the DNS server know about your request.

DOT technology works directly in the Android operating system starting from version 9. This, in particular, allows you to block ads at the DNS level on non-rooted smartphones.

![doh and dot](/img/Public-DNS-DOH-and-DOT.jpg)

DNS server DOH, not only can be run on Ubuntu or FreeBSD Desktop, for Windows users can also use Public DNS DOH. On the Windows 11 operating system, the DOH DNS server runs very well and can be relied on to improve the security of your Windows network.

In addition, Keenetic and Mikrotik series home routers can use DOH and DOT to protect all DNS requests from your home network. Not only that, other advantages of the DOH DNS server can also be applied in the FireFox, Opera and Chrome Browsers.

Its function is beyond doubt, it's time for you to switch to DNS with DOH and DOT support, then where can I get a reliable, fast and free DNS server with DOT and DOH support?.<br><br/>
## 1. Reliable DOH DOT DNS server with encryption
Microsoft's new Windows 11 operating system supports by default DNS servers with DOH encryption from Cloudflare, Google, and Quad9.

I have been using DOH and DOT servers from various providers to protect DNS requests for about 2 years now. And Cloudflare, Google, and Quad9 are also in the TOP.

**List of recommended free DNS servers with DOT encryption:**<br><br/>

| Provider       | IPv4 address          | Port        |  DNS / TLS        |
| ----------- | -----------   | ----------- | ----------- |
| CloudFlare          | 1.1.1.1          | 853          | cloudflare-dns.com          |
| CloudFlare          | 1.0.0.1      | 853          | cloudflare-dns.com          |
| Google          | 8.8.8.8          | 853          | dns.google          |
| Google          | 8.8.4.4      | 853          | dns.google          |
| Quad9          | 9.9.9.9          | 853          | dns.quad9.net          |
| Quad9          | 149.112.112.112      | 853          | dns.quad9.net          |
| Yandex          | 77.88.8.8          | 853          | common.dot.dns.yandex.net          |

The information in the table may be redundant for configuring your device. The minimum list looks like this:

-   tls://cloudflare-dns.com
-   tls://dns.google
-   tls://dns.quad9.net
-   common.dot.dns.yandex.net

**List of recommended free DNS servers with DOH encryption:**

| Provider       | IPv4 address          | Port        |  DNS query        |
| ----------- | -----------   | ----------- | ----------- |
| CloudFlare          | 1.1.1.1          | 443          | https://cloudflare-dns.com/dns-query          |
| CloudFlare          | 1.0.0.1      | 443          | https://cloudflare-dns.com/dns-query          |
| Google          | 8.8.8.8          | 443          | https://dns.google/dns-query          |
| Google          | 8.8.4.4      | 443          | https://dns.google/dns-query          |
| Quad9          | 9.9.9.9          | 443          | https://dns.quad9.net/dns-query          |
| Quad9          | 149.112.112.112      | 443          | https://dns.quad9.net/dns-query          |
| Yandex          | 77.88.8.8          | 443          | https://common.dot.dns.yandex.net/dns-query          |

The information in the table may be excessive for setting up your device. The minimum list looks like this:

-   https://cloudflare-dns.com/dns-query
-   https://dns.google/dns-query
-   https://dns.quad9.net/dns-query
-   https://common.dot.dns.yandex.net/dns-query

## 2. Alternative DNS servers with DOT and DOH encryption
In addition to the top three, there are alternative fast, stable and free DNS servers with DOT and DOH encryption support. I have been using them for about a year, and have no particular complaints about them.

| Provider       | DNS over TLS          | DNS over HTTPS        | 
| ----------- | -----------   | ----------- |
| AdGuard          | tls://dns.adguard.com          | https://dns.adguard.com/dns-query          |
| Comss.one DNS          | tls://dns.comss.one      | https://dns.comss.one/dns-query          |
| NextDNS          | tls://dns.nextdns.io     | https://dns.nextdns.io          |
| Cisco OpenDNS          | -          | https://doh.opendns.com/dns-query  


There are many other decent DNS services that support encryption, but I have not tested them and therefore they are not included in this article.


Choose Which DOH or DOT or Which is better DOH or DOT?

In terms of network security, DoT is probably better. It can also often be faster than DoH.

From a privacy perspective, DoH is preferable because DoH DNS queries use port 443 and are therefore hidden in the vast stream of HTTPS traffic.

The article lists DNS servers with DOT and DOH encryption without any analysis of their operation. This list is based on my personal experience. All services are listed in the "default" mode, which usually means partial blocking of some resources.
