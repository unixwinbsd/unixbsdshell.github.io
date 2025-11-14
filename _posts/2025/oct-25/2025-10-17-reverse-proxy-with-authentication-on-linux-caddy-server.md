---
title: Reverse Proxy with Authentication on Linux Caddy Server
date: "2025-10-17 15:12:25 +0100"
updated: "2025-10-17 15:12:25 +0100"
id: reverse-proxy-with-authentication-on-linux-caddy-server
lang: en
author: Iwan Setiawan
robots: index, follow
categories: linux
tags: WebServer
background: /img/oct-25/oct-25-110.jpg
toc: true
comments: true
published: true
excerpt: This article discusses reverse proxies using a Caddy server, which uses a robust authentication system to determine user access rights. In this discussion, we'll use the external DNS server penaadventure.com and the internal DNS server unixwinbsd.site as an example. For further clarification, see the image below.
keywords: reverse, proxy, authentication, linux, caddy server, caddy, web server
---

This article discusses reverse proxies using a Caddy server, which uses a robust authentication system to determine user access rights. In this discussion, we'll use the external DNS server penaadventure.com and the internal DNS server unixwinbsd.site as an example. For further clarification, see the image below.

<br/>
{% lazyload data-src="/img/oct-25/oct-25-110.jpg" src="/img/oct-25/oct-25-110.jpg" alt="Reverse proxy Caddy Server" %}
<br/>

The local internal DNS server is configured using views so that the media server's internal hostname unixwinbsd.site and the external DNS name penaadventure.com reserved for the project are pointed to the same local LAN IP address. This means that accessing unixwinbsd.site or penaadventure.com on the local LAN in a browser will result in a connection to the unixwinbsd server on the local LAN.


## 1. Dynamic DNS

You could register a regular domain name for the project, but the idea was to minimize resource costs and setup complexity, so the final option was to use an online dynamic DNS service (DDNS).

In reality, dynamic DNS doesn't refer to the typical DNS server-side updates to IP address reservations, but rather to an online service that exposes programming hooks that can be used to update the external IP address of a domain name provided by a "dynamic DNS provider," a task easily accomplished using tools like ddclient.

This means that the setup described in this document uses only two domain names, penaadventure.com, and auth.penaadventure.com, without registering additional subdomain names for each server (Sonarr, Lidarr, etc.). Fortunately, most dynamic DNS services allow subdomains of reserved domains, such as media or auth. One trick is to configure the media and auth subdomains to be pointers (PTRs) or canonical names (CNAMEs) of a reserved top-level dynamic DNS server, such as penaadventure.com.

By configuring the subdomains as pointers or canonical names of the top-level domain, every time the IP address is updated using a tool like ddclient, the other subdomain names will point to the updated IP address. A potential mistake is creating A records for media and auth, as A records can be configured separately to point to different IP addresses, so there's no guarantee that ddclient will update them.

In conclusion, the following DNS records are created:

**penaadventure.com.      A            EXTERNAL_IP**

**media                   PTR          penaadventure.com.**

**auth                    PTR          penaadventure.com.**


## 2. Preparing the Servarr Installation

The configuration of each instance is not critical, except that it must be configured to use the base path, not the root path.

This means that all Servarr servers will be configured to have a baseURL, so the following host and path pairs must be equivalent:

**media.tld/sonarr, media.penaadventure.com/sonarr**

**media.tld/radarr, media.penaadventure.com/radarr**


and so on for all Servarr servers.

This can be configured in the "General" section of each Servarr.

When setting up all Servarr, you can disable authentication entirely, or create the necessary exceptions for non-routable LAN IP addresses to bypass authentication and then access Servarr directly.

## 3. Setting up a Reverse Proxy

For convenience, two reverse proxies are configured using caddy. The first reverse proxy will reside on the internal server's media.tld and will allow access to the Servarr instance using the baseURL path.

Here's an example configuration for caddy that will `reverse-proxy` multiple Servarr services so that they can be accessed via the LAN FQDN of the `"media"` server plus the baseURL configured for the corresponding Servarr:

Now, according to the first line in the **127.0.0.1:32400** configuration, the default destination for any HTTP requests to the media server on port 80 will be redirected to port 32400 on the local machine, which is the default listening port for the Plex Media server.

The second reverse proxy server to be installed will be on the front-facing Internet gateway and will reverse proxy external requests to the media server's internal servers. The reason for adding another caddy server to the setup is separation of concerns, where the media server is a stand-alone entity that can be part of any LAN (e.g., a container, like a virtual machine).

Meanwhile, the caddy on the Internet gateway will act for a specifically configured LAN. The limitation, of course, is that the HTTP and HTTPS ports are unique, and other services may need to be exposed within the LAN.

The reverse proxy caddy gateway will also be responsible for authenticating clients outside the local LAN, as it is easier to protect the entire Servarr allocation than to go through all services and enable authentication and protection.

Even if authentication is enabled for all Servarr, as well as additional services that don't even have built-in authentication, it still represents another level of separation, where requests coming over the external Internet connection will be processed on the front-facing server and not simply NATed to the local network (specifically, the media server).

Thus, here is the complete configuration for the caddy on the Internet-facing gateway:

```console
{
        log {
                output file /var/log/caddy/access.log {
                        roll_size 250mb
                        roll_keep 5
                        roll_keep_for 720h
                }
        }

        order authenticate before respond
        order authorize before reverse_proxy

        security {
                local identity store localdb {
                        realm local
                        #path /tmp/users.json
                        path /etc/caddy/auth/local/users.json
                }
                authentication portal media {
                        enable identity store localdb
                        cookie domain media.home.entertainment.tld
                        cookie lifetime 86400
                        ui {
                                theme basic
                                links {
                                        "Services" /services
                                }
                        }
                }
                authorization policy admin_policy {
                        set auth url https://auth.home.entertainment.tld
                        allow roles authp/user authp/admin
                }
        }

        order replace after encode
}

auth.home.entertainment.tld {
        tls some@email.tld
        
        authenticate with media
}

media.home.entertainment.tld {
        tls some@email.tld

        # Expose iCal without authorization and only based on API key authentication.
        # /sonarr/feed/calendar/Sonarr.ics?apikey=
        # /radarr/feed/v3/calendar/Radarr.ics?apikey=
        @noauth {
                not path_regexp \/.+?\/feed(/.*?)*\/calendar\/.+?\.ics$
                not remote_ip 192.168.0.1/24
        }

        handle @noauth {
                authorize with admin_policy
        }

        reverse_proxy media.tld {
                header_up Host {host}
                header_up X-Real-IP {remote}
                header_up X-Forwarded-Host {hostport}
                header_up X-Forwarded-For {remote}
                header_up X-Forwarded-Proto {scheme}
        }
}
```

When a request arrives at the forward-facing Internet gateway, the caddy server, based on the previous configuration, will perform the following steps, in sequence:

- The authentication cookie is checked on the browser accessing the Caddy server, as well as the browser's IP address.
- If the cookie is present or the request originates from the local network 192.168.1.0/24, the request is forwarded to the media server at media.tld.
- If the authentication cookie is not present on the browser and the request is outside the local LAN, Caddy will redirect the request to auth.home.entertainment.tld, where the user will be prompted to authenticate using a forms-based authenticator.
- Upon successful authentication, the user will be redirected to the original FQDN and URL requested, hopefully reaching one of the servers.

The only step missing is the following exception:

```console
not path_regexp \/.+?\/feed(/.*?)*\/calendar\/.+?\.ics$
```

which allows Servarr paths to match regular expressions, such as:

```console
# /sonarr/feed/calendar/Sonarr.ics?apikey=
# /radarr/feed/v3/calendar/Radarr.ics?apikey=
```

Generally, this is fine, because accessing the iCal service for all servers requires an API key, so even if the service is publicly available, users will need an API key to effectively retrieve the iCal calendar. Furthermore, given that Caddy is configured with Email TLS through the settings,

Caddy will automatically generate SSL/TLS certificates for the domains media.home.entertainment.tld and auth.home.entertainment.tld. You can also set up a wildcard SSL/TLS certificate, but that requires a provider like CloudFlare to address the challenges of LetsEncrypt or ZeroDNS certificate generation.