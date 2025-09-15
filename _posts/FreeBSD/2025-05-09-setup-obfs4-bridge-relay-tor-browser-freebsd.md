---
title: How to Setup OBFS4 Bridge Relay for TOR Browser on FreeBSD 14
date: "2025-05-09 10:55:21 +0100"
id: setup-obfs4-bridge-relay-tor-browser-freebsd
lang: en
layout: single
author_profile: true
categories:
  - FreeBSD
tags: "Anonymous"
excerpt: Browsing the web with Tor can be done anonymously, Tor offers many ways to make your web traffic anonymous, either with a proxy or bridge relay mode. If you use bridge mode, you must install OBFS4 so that your data and identity are invisible and faster.
keywords: tor, obfs4, bridge, relay, browser, tor browser, onion, go, golang, google, web application, app, web app, script, freebsd, creating
---

Browsing the web with Tor can be done anonymously, Tor offers many ways to make your web traffic anonymous, either with a proxy or bridge relay mode. If you use bridge mode, you must install OBFS4 so that your data and identity are invisible and faster.

What is OBFS4, also known as Plug-gable Transport taken from the text OBFS4 Proxy. OBFS4 Proxy is a tool that tries to circumvent censorship by converting Tor traffic between the client and the bridge. This way, sensors, which normally monitor traffic between the client and the bridge, will see seamlessly altered traffic, not actual Tor traffic.

Every time you use Tor, our internet traffic will pass through three servers. There is an entry node, a relay in the middle, and an exit node where your traffic to the outside internet will pass through. By hosting your bridge, you are essentially running an entry node on Tor. If you have a server with enough spare resources and bandwidth, it will increase Tor's speed significantly. We can even share the Tor bridge/relay with friends or even make it a public bridge.

<br/>

![OBFS4 Bridge Relay tor for freebsd](https://raw.githubusercontent.com/unixwinbsd/unixwinbsd.github.io/refs/heads/master/Image/OBFS4%20Bridge%20Relay%20tor%20for%20freebsd.jpg)

<br/>

In this article we try to review Tor configuration techniques as Bridge mode. In its application, bridge mode browsing can only be used on the Tor Browser. OK, let's get straight to the main discussion.



## 1. TOR & OBFS4PROXY Installation

Before using Tor as a bridge/relay, you must first install the basic program, namely Tor:

```console
root@router2:~ # cd /usr/ports/security/tor
root@router2:/usr/ports/security/tor # make install clean

root@router2:~ # cd /usr/ports/security/obfs4proxy-tor
root@router2:/usr/ports/security/obfs4proxy-tor # make install clean
```

After the installation process is complete, edit the torrc file in the `/usr/local/etc/tor folder`.

```console
root@router2:~ # cd /usr/local/etc/tor
root@router2:/usr/ports/security/tor # ee torrc
```

Type the script below in the /usr/local/etc/tor/torrc file.

```
SOCKSPort 192.168.9.3:9050
DNSPort 192.168.5.3:9053
ControlPort 9051
RunAsDaemon 1
BridgeRelay 1
ORPort 9001
ServerTransportPlugin obfs4 exec /usr/local/bin/obfs4proxy -enableLogging=true -logLevel INFO managed
ServerTransportListenAddr obfs4 192.168.9.3:9000
ExtORPort auto
PublishServerDescriptor 0
ExitRelay
ContactInfo datainchi@gmail.com
Nickname unixdotbsd
Log notice file /var/log/tor/notices.log
SOCKSPolicy accept 192.168.9.3/24
```

Create a start up script for the Tor daemon, enter the following script in the /etc/rc.conf file.

```console
root@router2:~ # ee /etc/rc.conf

tor_enable="YES"
tor_setuid="YES"
```
The script above is used so that the Tor program can run automatically when the computer restarts/reboots. Once we have finished configuring the Tor daemon, reboot your FreeBSD server.

```console
root@router2:~ # reboot
```

Up to this point, you have successfully created the Tor daemon as a bridge/relay for the Tor browser program. To implement the Tor daemon as a bridge/relay, you can see the script in the /var/db/tor and /var/db/tor/pt_state folders. Please open the obfs4_bridgeline.txt file in the /var/db/tor/pt_state folder.

To make it easier to edit the script, please copy and paste the script into the notepad program.

Now you open the fingerprint file in the /var/db/tor folder.

With these two files we will get the following script:

```
Bridge obfs4 192.168.9.3:9000 unixdotbsd DBA4B882FAE797A657F3A4E78BA6169CE7F7766D cert=IKbwxBdbnHqqlzGQVLG/4XhgHbMk83/z2DWRRINmyEEWOmUeh9SKUWjWQXIdW86D8tCiUA iat-mode=0
```

Well, now you have a Tor daemon script for Bridge/Relay. You can directly copy and paste this script in the Tor Browser.

Now Open `Tor Browser`, and see what appears.

Done, now your Tor Browser is RUNNING with OBFS4 Proxy and as a private bridge/relay from your TOR Browser.

It turns out that it is very easy to create a bridge/relay, with a bridge/relay in your Tor Browser, the security of your data and personal identity will be kept strictly confidential, because now your internet connection does not use the Public IP from the provider where you subscribe to the internet.

When you access the internet, you will use a foreign public IP that has been automatically set by Tor. To check your Public IP, open `https://icanhazip.com/ and https://check.torproject.org/`.


The complete source code of the torrc script file is in the `/usr/local/etc/tor` folder.

```
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
## https://www.torproject.org/docs/faq#torrc

## Tor opens a SOCKS proxy on port 9050 by default -- even if you don't
## configure one below. Set "SOCKSPort 0" if you plan to run Tor only
## as a relay, and not make any local application connections yourself.
SOCKSPort 192.168.9.3:9050 # Default: Bind to localhost:9050 for local connections.
#SOCKSPort 192.168.0.1:9100 # Bind to this address:port too.

## Entry policies to allow/deny SOCKS requests based on IP address.
## First entry that matches wins. If no SOCKSPolicy is set, we accept
## all (and only) requests that reach a SOCKSPort. Untrusted users who
## can access your SOCKSPort may be able to learn about the connections
## you make.
SOCKSPolicy accept 192.168.9.3/24
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
Log notice file /var/log/tor/notices.log
## Send every possible message to /var/log/tor/debug.log
#Log debug file /var/log/tor/debug.log
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
ControlPort 9051
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
## See https://www.torproject.org/docs/tor-doc-relay for details.

## Required: what port to advertise for incoming Tor connections.
ORPort 9001
ServerTransportPlugin obfs4 exec /usr/local/bin/obfs4proxy -enableLogging=true -logLevel INFO managed
ServerTransportListenAddr obfs4 192.168.9.3:9000
ExtORPort auto
PublishServerDescriptor 0

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
Nickname unixdotbsd

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
ContactInfo datainchi@gmail.com

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
## https://www.torproject.org/docs/faq#MultipleRelays
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
ExitRelay 1

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
## https://www.torproject.org/documentation.html
##
## Look at https://www.torproject.org/faq-abuse.html#TypicalAbuses
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
BridgeRelay 1
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

Through analysis of Obfs4 Bridge, we know that it can protect Tor traffic from being identified and blocked by censors because:
- Obfs4 encrypts Tor traffic and obfuscates packet sizes by adding padding data, including in handshake packets.
- Large Obfs4 packets can be split with IAT mode to mask the network.
- In addition to the built-in Obfs4 Bridge, Tor provides three other ways to get additional private Obfs4 Bridges.