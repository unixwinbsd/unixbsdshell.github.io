---
title: Dynamic DNS with GoDNS as an Alternative to ddclient on FreeBSD
date: "2025-10-17 07:46:33 +0100"
updated: "2025-10-17 07:46:33 +0100"
id: dynamic-dns-server-he-net-godns-go-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DNSServer
background: /img/oct-25/oct-25-109.jpg
toc: true
comments: true
published: true
excerpt: In this tutorial, we'll learn how to install and configure Dynamic DNS (DDNS) on a FreeBSD server using GoDNS and HE.net.
keywords: dynamic, dynamic dns, godns, alternative, ddclient, freebsd, dns server, he.net, he net
---

GoDNS is a dynamic DNS (DDNS) client tool. It's written in GoLang and is part of the open-source DynDNS project. GoDNS supports multiple domain providers and allows for notification of changes via email (SMTP) or services like Discord, Pushover, Slack, and Telegram.

GoDNS supports multiple platforms, including Linux, FreeBSD, macOS, Windows, and more. This application has proven to be highly robust, stable, and lightweight. In fact, GoDNS can replace ddclient, the long-standing Dynamic DNS (DDNS) application.

Like ddclient, GoDNS also supports multiple DNS providers. The image below shows the DNS providers supported by GoDNS.

In this tutorial, we'll learn how to install and configure Dynamic DNS (DDNS) on a FreeBSD server using GoDNS and HE.net.

To use GoDNS on FreeBSD, we'll assume:

- The GO application has been installed on FreeBSD.
- You have registered (now own) a domain.
- The domain has been delegated to a supported DNS provider, such as HE.net or Cloudflare.
- If you don't have a domain yet, you can also log in to DuckDNS (with a social account) and get a free subdomain at duckdns.org.

## A. System Specifications

- OS: FreeBSD 13.2
- domain: datainchi.com
- Hostname: ns7
- IP Address: 192.168.5.2
- Land Card: nfe0
- Provider DDNS: HE.net



## B. How to Install GoDNS on FreeBSD

Before we start the installation process, you should read the article on [how to install and configure GO ](https://unixwinbsd.site/freebsd/go-lang-freebsd14-golang-install) on FreeBSD.

Since GoDNS is written in Go, make sure you have GO installed on FreeBSD. On FreeBSD, the GoDNS repository is available in the system ports, but I prefer installing it via binary packages. You can package the entire library on the official GitHub site and run it in Go. This method ensures the latest version.

```sh
root@ns7:~ # cd /usr/local/etc
root@ns7:/usr/local/etc # git clone https://github.com/TimothyYe/godns.git
Cloning into 'godns'...
remote: Enumerating objects: 3196, done.
remote: Counting objects: 100% (277/277), done.
remote: Compressing objects: 100% (90/90), done.
remote: Total 3196 (delta 200), reused 236 (delta 181), pack-reused 2919
Receiving objects: 100% (3196/3196), 1.72 MiB | 433.00 KiB/s, done.
Resolving deltas: 100% (1660/1660), done.
```

After cloning godns from the Github repository, proceed with the `“go build”` and `“go install”` commands.

```sh
root@ns7:/usr/local/etc # cd godns/cmd/godns
root@ns7:/usr/local/etc/godns/cmd/godns # go mod download
root@ns7:/usr/local/etc/godns/cmd/godns # go build
root@ns7:/usr/local/etc/godns/cmd/godns # go install
```

<br/>

```sh
root@ns7:~ # mkdir -p /var/run/godns
root@ns7:~ # chmod +x /var/run/godns
```

The go mod download command will install the GoDNS dependency files, while the go install command will generate the "godns" bin file. Run the move command to make the "godns" bin file run on a FreeBSD system.

```sh
root@ns7:/usr/local/etc/godns/cmd/godns # mv /root/go/bin/godns /usr/local/bin
```


## C. How to Configure GoDNS

Before configuring, let's take a look at the guide to using GoDNS.

```
root@ns7:/usr/local/etc/godns/cmd/godns # godns -h

 ¦¦¦¦¦¦+  ¦¦¦¦¦¦+ ¦¦¦¦¦¦+ ¦¦¦+   ¦¦+¦¦¦¦¦¦¦+
¦¦+----+ ¦¦+---¦¦+¦¦+--¦¦+¦¦¦¦+  ¦¦¦¦¦+----+
¦¦¦  ¦¦¦+¦¦¦   ¦¦¦¦¦¦  ¦¦¦¦¦+¦¦+ ¦¦¦¦¦¦¦¦¦¦+
¦¦¦   ¦¦¦¦¦¦   ¦¦¦¦¦¦  ¦¦¦¦¦¦+¦¦+¦¦¦+----¦¦¦
+¦¦¦¦¦¦+++¦¦¦¦¦¦++¦¦¦¦¦¦++¦¦¦ +¦¦¦¦¦¦¦¦¦¦¦¦¦
 +-----+  +-----+ +-----+ +-+  +---++------+

GoDNS 0.1
https://github.com/TimothyYe/godns

Usage of godns:
  -c string
        Specify a config file (default "./config.json")
  -h    Show help
```

Create a `config.json` file and place it in the `"/usr/local/etc/godns"` folder.

```sh
root@ns7:~ # touch /usr/local/etc/godns/godns-config.json
root@ns7:~ # chmod -R 777 /usr/local/etc/godns/godns-config.json
```

Here is an example script from the file `"/usr/local/etc/godns/godns-config.json"`.

{% raw %}
```
{
  "provider": "HE",
  "password": "maCpVY9JnjEXJCi1",
  "email": "kanakarobih",
  "domains": [
    {
      "domain_name": "datainchi.com",
      "sub_domains": ["www"]
    }
  ],
  "ip_urls": [
    "https://dns.he.net"
  ],
  "ipv6_urls": ["https://ipify.org"],
  "ip_type": "IPv4",
  "interval": 300,
  "resolver": "8.8.8.8",
  "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2125.111 Safari/537.36",
  "ip_interface": "nfe0",
  "socks5_proxy": "",
  "use_proxy": false,
  "debug_info": true,
  "proxied": false,
  "notify": {
    "telegram": {
      "enabled": false,
      "bot_api_key": "",
      "chat_id": "",
      "message_template": ""
    },
    "mail": {
      "enabled": false,
      "smtp_server": "",
      "smtp_username": "",
      "smtp_password": "",
      "smtp_port": 25,
      "send_from": "",
      "send_to": ""
    }
  },
  "webhook": {
    "enabled": false,
    "url": "http://localhost:5000/api/v1/send",
    "request_body": "{ \"domain\": \"{{.Domain}}\", \"ip\": \"{{.CurrentIP}}\", \"ip_type\": \"{{.IPType}}\" }"
  }
}
```
{% endraw %}

In the script above, `"password" and "email"` come from the HE.net DDNS provider. The email comes from the [HE.net](http://HE.net) Account Name.

<br/>

![dynamic dns he net](/img/oct-25/oct-25-109.jpg)

<br/>

Run GoDNS,

```
root@ns7:~ # godns -c=/usr/local/etc/godns/godns-config.json
INFO[0000] Creating DNS handler with provider: HE
INFO[0000] GoDNS started, starting the DNS manager...
DEBU[0001] get ip success by: https://dns.he.net, online IP: 192.168.0.1
DEBU[0001] get ip success by: https://dns.he.net, online IP: 192.168.0.1
INFO[0002] Update IP success: badauth
DEBU[0002] Cached IP address: 192.168.0.1
DEBU[0002] DNS update loop finished, will run again in 300 seconds
```

You've successfully run GoDNS on your FreeBSD server. Unfortunately, the GoDNS daemon doesn't start automatically. Okay, now we'll automate the GoDNS daemon using the rc.d script.

Create a godns `rc.d` file in the `/usr/local/etc/rc.d` folder.

```
root@ns7:~ # touch /usr/local/etc/rc.d/godns
root@ns7:~ # chmod +x /usr/local/etc/rc.d/godns
```

In the file `"/usr/local/etc/rc.d/godns"` write the script below.

```sh
#!/bin/sh

# PROVIDE: godns
# REQUIRE: DAEMON LOGIN
# KEYWORD: shutdown

#
# Add the following line to /etc/rc.conf to enable godns:
# godns_enable (bool):		Set to "NO" by default.
#				Set it to "YES" to enable godns.
# godns_flags (str):		Custom additional arguments to be passed
#				to godns (default empty).
# godns_conf_dir (str):		Directory where ${name} configuration
#				data is stored.

. /etc/rc.subr

name="godns"
rcvar=godns_enable

load_rc_config ${name}

: ${godns_enable:="NO"}
: ${godns_user:="nobody"}
: ${godns_group:="nogroup"}
: ${godns_conf_dir="/usr/local/etc"}

start_precmd=godns_precmd
stop_postcmd=godns_stop_postcmd

procname="/usr/local/bin/${name}"
pidfile="/var/run/${name}/${name}.pid"
logfile="/var/log/${name}/${name}.log"

required_files="${godns_conf_dir}/${name}-config.json"

command="/usr/sbin/daemon"
command_args="-f -t ${name} -o ${logfile} -p ${pidfile} ${procname} -c ${required_files} ${godns_args}"

godns_precmd()
{
	local rundir=${pidfile%/*}
	if [ ! -d $rundir ] ; then
		install -d -m 0755 -o ${godns_user} -g ${godns_group} $rundir
	fi
	local logdir=${logfile%/*}
	install -d -m 0750 -o ${godns_user} -g ${godns_group} $logdir
}

godns_stop_postcmd()
{
	rm -f "$rundir"
}

run_rc_command "$1"

```

Then in the file `"/etc/rc.conf"`, add the following script.

```sh
root@ns7:~ # ee /etc/rc.conf
godns_enable="YES"
godns_user="nobody"
godns_group="nogroup"
godns_conf_dir="/usr/local/etc/godns"
```

The final step is to run GoDNS, whether it can run automatically on the FreeBSD server.

```sh
root@ns7:~ # service godns restart
```

With the `rc.d` script, your GoDNS can run automatically. You no longer need to run it manually.

All of GoDNS's features are on par with similar applications, such as ddclient. You should definitely try it to experience the benefits of GoDNS. We've tried it, and the results are very satisfying.