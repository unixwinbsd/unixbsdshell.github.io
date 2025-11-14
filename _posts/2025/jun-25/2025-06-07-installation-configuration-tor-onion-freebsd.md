---
title: TOR Installation And Configuration On FreeBSD Server
date: "2025-06-07 10:10:15 +0100"
updated: "2025-06-07 10:10:15 +0100"
id: installation-configuration-tor-onion-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: Anonymous
background: https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets%2Fimages%2F28TOR%20Network.jpg&commit=365cf83f5aa87d3870dc265fe9cfb349b0758202
toc: true
comments: true
published: true
excerpt: Tor is a tool for organizations and individuals who want to increase the comfort and security of surfing the Internet. Using Tor can help you anonymize web browsing and browsing, sending email, IRC, SSH, and more. Tor also provides a platform where software developers can build new applications with built-in anonymity, security, and privacy features.
keywords: tor, onion, network, i2p, anonymous, freebsd, installation, configuration, article
---

Tor is a tool for organizations and individuals who want to increase the comfort and security of surfing the Internet. Using Tor can help you anonymize web browsing and browsing, sending email, IRC, SSH, and more. Tor also provides a platform where software developers can build new applications with built-in anonymity, security, and privacy features.

Tor is a free, open-source utility and open network that enables anonymous communication. When combined, these two components help defend against various forms of traffic analysis and network surveillance. Trying to explain Tor comprehensively again is beyond the scope of this article, you can read about it through the literature provided by the project website and The Electronic Frontier Foundation (EFF) before installing it.

Before we start, you should know what TOR and ProxyChains are. Here is a brief overview of the anonymous application.
- **TOR:** A network that enables anonymous communication by routing traffic through a series of volunteer servers.
- **ProxyChains:** A tool that forces network connections through a proxy server, often used with TOR to add an extra layer of anonymity.

In this article, we will try to cover how to install and configure the TOR application on a FreeBSD 13.2 Stable server.


## A. System Specifications
- OS: FreeBSD 13.2 Stable
- Motherboard: MSI 870-C45 (VGA OffBoard)
- Processor: AMD Phenom II X4 965 3400 MHz
- Memory: 2 GB
- LAN IP: 192.168.5.2
- Domain: unixexplore.com
- Hostname: ns1

After we determine the type of computer that will be used to run TOR, we continue by installing the TOR application.

<br/>
![tor onion network](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets%2Fimages%2F28TOR%20Network.jpg&commit=365cf83f5aa87d3870dc265fe9cfb349b0758202)
<br/>


## B. Installing & Configuring TOR
The first step to installing Tor on FreeBSD is to decide whether you want to install a pre-compiled package with pkg, or whether you want to compile it yourself from the FreeBSD Ports Collection. The differences between the two installation processes will be demonstrated in this article.

If you are using Windows for the TOR installation, use the PuTTY remote console to make the installation easier. In the PuTTY application, log in as root with the FreeBSD IP address. The following is an example of installing Tor using the pkg package via putty.

```console
root@ns1:~ # pkg update
root@ns1:~ # pkg upgrade
root@ns1:~ # pkg install tor
```
We recommend installing your TOR using the ports system. In this example, we will install TOR with FreeBSD ports. Here is how to install TOR using the `FreeBSD ports` system.

```console
root@ns1:~ # cd /usr/ports/security/tor
root@ns1:/usr/ports/security/tor # make install clean

===>  Installing for tor-0.4.8.7
===>  Checking if tor is already installed
===>   Registering installation for tor-0.4.8.7
Installing tor-0.4.8.7...
===> Creating groups.
Using existing group '_tor'.
===> Creating users
Using existing user '_tor'.
===> Creating homedir(s)
To enable the tor server, set tor_enable="YES" in your /etc/rc.conf
and edit /usr/local/etc/tor/torrc as desired. (However, note that the
/usr/local/etc/rc.d/tor rc.subr script can override some torrc
options: see that script for details.) To use the torify script, install
the net/torsocks port.

Tor users are strongly advised to prevent traffic analysis that
exploits sequential IP IDs by setting:

sysctl net.inet.ip.random_id=1

(see sysctl.conf(5)).

In order to run additional, independent instances of tor on the same machine
set tor_instances="inst1 inst2 ..." in your /etc/rc.conf, and create the
corresponding additional configuration files /usr/local/etc/tor/torrc@inst1, ...

Alternatively, you can use the extended instance definition to specify all
instance parameteres explicitly:
inst_name{:inst_conf:inst_user:inst_group:inst_pidfile:inst_data_dir}

===> SECURITY REPORT:
      This port has installed the following files which may act as network
      servers and may therefore pose a remote security risk to the system.
/usr/local/bin/tor-resolve
/usr/local/bin/tor-gencert
/usr/local/bin/tor

      If there are vulnerabilities in these programs there may be a security
      risk to the system. FreeBSD makes no guarantee about the security of
      ports included in the Ports Collection. Please type 'make deinstall'
      to deinstall the port if this is a concern.

      For more information, and contact details about the security
      status of this software, see the following webpage:
https://www.torproject.org/
===>  Cleaning for tor-0.4.8.7
```
The next step is, edit the rc.conf file in the "/etc" folder and enter the script below into the `"/etc/rc.conf"` file.

```console
root@ns1:~ # ee /etc/rc.conf

tor_enable="YES"
tor_setuid="YES"
```
After that, you enter the script `net.inet.ip.random_id=1` in the file `/etc/sysctl.conf`.

```console
root@ns1:/usr/ports/security/tor # sysctl net.inet.ip.random_id=1
```
The final step in the TOR installation process is to edit the `/usr/local/etc/tor/torrc` file. Enable some scripts that we need by removing the **"#"** sign at the beginning of the script. The following is an example of a script that we must enable in `"/usr/local/etc/tor/torrc"`.
<br/>

> SOCKSPort 192.168.5.2:9050
>
> SOCKSPolicy accept 192.168.5.0/24

> Log debug file /var/log/tor/debug.log

> RunAsDaemon 1
>
>DataDirectory /var/db/tor

<br/>

After we edit the file `"/usr/local/etc/tor/torrc"` as in the example above, then run the TOR program with the command `"service"`.

```console
root@ns1:~ # service tor restart
Stopping tor.
Waiting for PIDS: 2116.
Starting tor.
Oct 28 12:50:02.150 [notice] Tor 0.4.8.7 running on FreeBSD with Libevent 2.1.12-stable, OpenSSL 1.1.1t-freebsd, Zlib 1.2.13, Liblzma 5.4.1, Libzstd 1.5.5 and BSD 1302001 as libc.
Oct 28 12:50:02.150 [notice] Tor can't help you if you use it wrong! Learn how to be safe at https://support.torproject.org/faq/staying-anonymous/
Oct 28 12:50:02.150 [notice] Read configuration file "/usr/local/etc/tor/torrc".
Oct 28 12:50:02.156 [notice] You configured a non-loopback address '192.168.5.2:9050' for SocksPort. This allows everybody on your local network to use your machine as a proxy. Make sure this is what you wanted.
Oct 28 12:50:02.156 [notice] Opening Socks listener on 192.168.5.2:9050
Oct 28 12:50:02.156 [notice] Opened Socks listener connection (ready) on 192.168.5.2:9050
```


## C. Create TOR Log File
Log files are very useful for monitoring TOR activities. All activities carried out by TOR will be stored properly in the log file. Here's how to create a `log` file for TOR.

```console
root@ns1:/usr/ports/security/tor # mkdir -p /var/log/tor
root@ns1:/usr/ports/security/tor # touch /var/log/tor/debug.log
```
After we create the log file `"/var/log/tor/debug.log"`, the next step is to create user rights in the `/var/db/tor` and `/usr/local/etc/tor` folders.

```console
root@ns1:~ # chown -R _tor:_tor  /var/db/tor
root@ns1:~ # chown -R _tor:_tor /usr/local/etc/tor
root@ns1:~ # chown -R _tor:_tor  /var/log/tor/debug.log
```
Tor is a panacea for all anonymity problems, it can be said that there is no perfect anonymity other than TOR. Using TOR to surf the internet is very safe, because all our identities are hidden by TOR. Currently, TOR is even available in the form of a browser program, such as TOR Browser which can be installed on Windows and Linux.

**The following is a complete script from the torrc file in the `/usr/local/etc/tor` folder**

```console
## Configuration file for a typical Tor user
## Last updated 28 February 2019 for Tor 0.3.5.1-alpha.
## (may or may not work for much older or much newer versions of Tor.)
##
## Lines that begin with "## " try to explain what's going on. Lines
## that begin with just "#" are disabled commands: you can enable them
## by removing the "#" symbol.
##
## See 'man tor', or https://www.torproject.org/docs/tor-manual.html,
## for more options you can use in this file.
##
## Tor will look for this file in various places based on your platform:
## https://support.torproject.org/tbb/tbb-editing-torrc/

## Tor opens a SOCKS proxy on port 9050 by default -- even if you don't
## configure one below. Set "SOCKSPort 0" if you plan to run Tor only
## as a relay, and not make any local application connections yourself.
SOCKSPort 192.168.5.2:9050
#SOCKSPort 192.168.0.1:9100 # Bind to this address:port too.

## Entry policies to allow/deny SOCKS requests based on IP address.
## First entry that matches wins. If no SOCKSPolicy is set, we accept
## all (and only) requests that reach a SOCKSPort. Untrusted users who
## can access your SOCKSPort may be able to learn about the connections
## you make.
#SOCKSPolicy accept 192.168.5.0/24
#SOCKSPolicy accept6 FC00::/7
#SOCKSPolicy reject *

## Logs go to stdout at level "notice" unless redirected by something
## else, like one of the below lines. You can have as many Log lines as
## you want.
##
## We advise using "notice" in most cases, since anything more verbose
## may provide sensitive information to an attacker who obtains the logs.
##
## Send all messages of level 'notice' or higher to /var/log/tor/notices.log
#Log notice file /var/log/tor/notices.log
## Send every possible message to /var/log/tor/debug.log
Log debug file /var/log/tor/debug.log
## Use the system log instead of Tor's logfiles
#Log notice syslog
## To send all messages to stderr:
#Log debug stderr

## Uncomment this to start the process in the background... or use
## --runasdaemon 1 on the command line. This is ignored on Windows;
## see the FAQ entry if you want Tor to run as an NT service.
RunAsDaemon 1

## The directory for keeping all the keys/etc. By default, we store
## things in $HOME/.tor on Unix, and in Application Data\tor on Windows.
DataDirectory /var/db/tor

## The port on which Tor will listen for local connections from Tor
## controller applications, as documented in control-spec.txt.
#ControlPort 9051
## If you enable the controlport, be sure to enable one of these
## authentication methods, to prevent attackers from accessing it.
#HashedControlPassword 16:872860B76453A77D60CA2BB8C1A7042072093276A3D701AD684053EC4C
#CookieAuthentication 1

############### This section is just for location-hidden services ###

## Once you have configured a hidden service, you can look at the
## contents of the file ".../hidden_service/hostname" for the address
## to tell people.
##
## HiddenServicePort x y:z says to redirect requests on port x to the
## address y:z.

#HiddenServiceDir /var/db/tor/hidden_service/
#HiddenServicePort 80 127.0.0.1:80

#HiddenServiceDir /var/db/tor/other_hidden_service/
#HiddenServicePort 80 127.0.0.1:80
#HiddenServicePort 22 127.0.0.1:22

################ This section is just for relays #####################
#
## See https://community.torproject.org/relay for details.

## Required: what port to advertise for incoming Tor connections.
#ORPort 9001
## If you want to listen on a port other than the one advertised in
## ORPort (e.g. to advertise 443 but bind to 9090), you can do it as
## follows.  You'll need to do ipchains or other port forwarding
## yourself to make this work.
#ORPort 443 NoListen
#ORPort 127.0.0.1:9090 NoAdvertise
## If you want to listen on IPv6 your numeric address must be explicitly
## between square brackets as follows. You must also listen on IPv4.
#ORPort [2001:DB8::1]:9050

## The IP address or full DNS name for incoming connections to your
## relay. Leave commented out and Tor will guess.
#Address noname.example.com

## If you have multiple network interfaces, you can specify one for
## outgoing traffic to use.
## OutboundBindAddressExit will be used for all exit traffic, while
## OutboundBindAddressOR will be used for all OR and Dir connections
## (DNS connections ignore OutboundBindAddress).
## If you do not wish to differentiate, use OutboundBindAddress to
## specify the same address for both in a single line.
#OutboundBindAddressExit 10.0.0.4
#OutboundBindAddressOR 10.0.0.5

## A handle for your relay, so people don't have to refer to it by key.
## Nicknames must be between 1 and 19 characters inclusive, and must
## contain only the characters [a-zA-Z0-9].
## If not set, "Unnamed" will be used.
#Nickname ididnteditheconfig

## Define these to limit how much relayed traffic you will allow. Your
## own traffic is still unthrottled. Note that RelayBandwidthRate must
## be at least 75 kilobytes per second.
## Note that units for these config options are bytes (per second), not
## bits (per second), and that prefixes are binary prefixes, i.e. 2^10,
## 2^20, etc.
#RelayBandwidthRate 100 KBytes  # Throttle traffic to 100KB/s (800Kbps)
#RelayBandwidthBurst 200 KBytes # But allow bursts up to 200KB (1600Kb)

## Use these to restrict the maximum traffic per day, week, or month.
## Note that this threshold applies separately to sent and received bytes,
## not to their sum: setting "40 GB" may allow up to 80 GB total before
## hibernating.
##
## Set a maximum of 40 gigabytes each way per period.
#AccountingMax 40 GBytes
## Each period starts daily at midnight (AccountingMax is per day)
#AccountingStart day 00:00
## Each period starts on the 3rd of the month at 15:00 (AccountingMax
## is per month)
#AccountingStart month 3 15:00

## Administrative contact information for this relay or bridge. This line
## can be used to contact you if your relay or bridge is misconfigured or
## something else goes wrong. Note that we archive and publish all
## descriptors containing these lines and that Google indexes them, so
## spammers might also collect them. You may want to obscure the fact that
## it's an email address and/or generate a new address for this purpose.
##
## If you are running multiple relays, you MUST set this option.
##
#ContactInfo Random Person <nobody AT example dot com>
## You might also include your PGP or GPG fingerprint if you have one:
#ContactInfo 0xFFFFFFFF Random Person <nobody AT example dot com>

## Uncomment this to mirror directory information for others. Please do
## if you have enough bandwidth.
#DirPort 9030 # what port to advertise for directory connections
## If you want to listen on a port other than the one advertised in
## DirPort (e.g. to advertise 80 but bind to 9091), you can do it as
## follows.  below too. You'll need to do ipchains or other port
## forwarding yourself to make this work.
#DirPort 80 NoListen
#DirPort 127.0.0.1:9091 NoAdvertise
## Uncomment to return an arbitrary blob of html on your DirPort. Now you
## can explain what Tor is if anybody wonders why your IP address is
## contacting them. See contrib/tor-exit-notice.html in Tor's source
## distribution for a sample.
#DirPortFrontPage /usr/local/etc/tor/tor-exit-notice.html

## Uncomment this if you run more than one Tor relay, and add the identity
## key fingerprint of each Tor relay you control, even if they're on
## different networks. You declare it here so Tor clients can avoid
## using more than one of your relays in a single circuit. See
## https://support.torproject.org/relay-operators/multiple-relays/
## However, you should never include a bridge's fingerprint here, as it would
## break its concealability and potentially reveal its IP/TCP address.
##
## If you are running multiple relays, you MUST set this option.
##
## Note: do not use MyFamily on bridge relays.
#MyFamily $keyid,$keyid,...

## Uncomment this if you want your relay to be an exit, with the default
## exit policy (or whatever exit policy you set below).
## (If ReducedExitPolicy, ExitPolicy, or IPv6Exit are set, relays are exits.
## If none of these options are set, relays are non-exits.)
#ExitRelay 1

## Uncomment this if you want your relay to allow IPv6 exit traffic.
## (Relays do not allow any exit traffic by default.)
#IPv6Exit 1

## Uncomment this if you want your relay to be an exit, with a reduced set
## of exit ports.
#ReducedExitPolicy 1

## Uncomment these lines if you want your relay to be an exit, with the
## specified set of exit IPs and ports.
##
## A comma-separated list of exit policies. They're considered first
## to last, and the first match wins.
##
## If you want to allow the same ports on IPv4 and IPv6, write your rules
## using accept/reject *. If you want to allow different ports on IPv4 and
## IPv6, write your IPv6 rules using accept6/reject6 *6, and your IPv4 rules
## using accept/reject *4.
##
## If you want to _replace_ the default exit policy, end this with either a
## reject *:* or an accept *:*. Otherwise, you're _augmenting_ (prepending to)
## the default exit policy. Leave commented to just use the default, which is
## described in the man page or at
## https://support.torproject.org/relay-operators
##
## Look at https://support.torproject.org/abuse/exit-relay-expectations/
## for issues you might encounter if you use the default exit policy.
##
## If certain IPs and ports are blocked externally, e.g. by your firewall,
## you should update your exit policy to reflect this -- otherwise Tor
## users will be told that those destinations are down.
##
## For security, by default Tor rejects connections to private (local)
## networks, including to the configured primary public IPv4 and IPv6 addresses,
## and any public IPv4 and IPv6 addresses on any interface on the relay.
## See the man page entry for ExitPolicyRejectPrivate if you want to allow
## "exit enclaving".
##
#ExitPolicy accept *:6660-6667,reject *:* # allow irc ports on IPv4 and IPv6 but no more
#ExitPolicy accept *:119 # accept nntp ports on IPv4 and IPv6 as well as default exit policy
#ExitPolicy accept *4:119 # accept nntp ports on IPv4 only as well as default exit policy
#ExitPolicy accept6 *6:119 # accept nntp ports on IPv6 only as well as default exit policy
#ExitPolicy reject *:* # no exits allowed

## Bridge relays (or "bridges") are Tor relays that aren't listed in the
## main directory. Since there is no complete public list of them, even an
## ISP that filters connections to all the known Tor relays probably
## won't be able to block all the bridges. Also, websites won't treat you
## differently because they won't know you're running Tor. If you can
## be a real relay, please do; but if not, be a bridge!
##
## Warning: when running your Tor as a bridge, make sure than MyFamily is
## NOT configured.
#BridgeRelay 1
## By default, Tor will advertise your bridge to users through various
## mechanisms like https://bridges.torproject.org/. If you want to run
## a private bridge, for example because you'll give out your bridge
## address manually to your friends, uncomment this line:
#BridgeDistribution none

## Configuration options can be imported from files or folders using the %include
## option with the value being a path. This path can have wildcards. Wildcards are
## expanded first, using lexical order. Then, for each matching file or folder, the following
## rules are followed: if the path is a file, the options from the file will be parsed as if
## they were written where the %include option is. If the path is a folder, all files on that
## folder will be parsed following lexical order. Files starting with a dot are ignored. Files
## on subfolders are ignored.
## The %include option can be used recursively.
#%include /etc/torrc.d/*.conf
```
We hope this article can help you in the process of installing and configuring TOR. With the TOR program on the FreeBSD system you can improve your computer's security system, because TOR can hide your IP address and there are many more advantages of TOR that you can try.