---
title: How to Install an Anonymous Bitcoin Wallet with FeeBSD and TOR
date: "2025-07-28 11:54:21 +0100"
updated: "2025-07-28 11:54:21 +0100"
id: bitcoin-anonymous-wallet-on-freebsd-tor
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: Anonymous
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: Bitcoin, as a conditionally anonymous cryptocurrency, means that transactions do not reveal the name of the wallet owner. At the same time, information about ongoing transactions is available to everyone, as records are kept in a public register
keywords: bitcoin, crypto, freebsd, tor, network, onion, proxy, install, configuration
---

Bitcoin isn't anonymous, but rather pseudo-anonymous—most experienced members of the Bitcoin community know this. However, most people don't understand why Bitcoin isn't anonymous, how Bitcoin users can be identified, and what can be done to prevent it.

Bitcoin, as a conditionally anonymous cryptocurrency, means that transactions do not reveal the name of the wallet owner. At the same time, information about ongoing transactions is available to everyone, as records are kept in a public register. This allows the owner's identity to be tracked and compared with ongoing Bitcoin transactions.

Attempts to convert cryptocurrency through exchanges into fiat money (dollars, euros, rubles, and other "traditional" currencies) can lead to the identification of the wallet owner.

In late June 2017, victims of the NotPetya ransomware paid attackers approximately $10,000 in Bitcoin to ransom their files. The creators of the malicious software disguised as ransomware managed to anonymously withdraw funds from their Bitcoin wallets on July 4, 2017, despite law enforcement efforts to track down the owners.

To cover their tracks, the hackers used a method called bitcoin mixing, often referred to as a bitcoin tumbler. This procedure allows users to transfer cryptocurrency into a system that distributes the funds to hundreds of thousands of wallets. The bitcoins then end up in the sender's designated storage.


There are three reasons why Bitcoin is considered anonymous:
- `First,` unlike bank accounts and most other payment systems, Bitcoin addresses are not tied to user identities at the protocol level. Anyone can create a new, randomly generated Bitcoin address (and associated private key) at any time without having to provide any personal information to anyone.
- `Second,` transactions are also not tied to user identities. This way, if a miner agrees to include a transaction in a block, anyone can transfer bitcoins from one address to another without revealing any personal information. Just like cash, the recipient doesn't need to know the sender.
- `And third,` Bitcoin transaction information is sent through randomly selected P2P network nodes. Although Bitcoin nodes are connected to each other via IP addresses, they don't know whether the transactions they receive were initiated by the node that sent the information or simply forwarded it.

In this cryptocurrency article, we'll discuss how to create an anonymous Bitcoin using the Tor application. In practice, the FreeBSD 13.2 operating system was used to create an anonymous Bitcoin at the time of writing.


## 1. TOR Installation and Configuration Process
Okay, first let's start by installing TOR Network, here's how to install TOR on a FreeBSD system.

```console
root@ns1:~ # pkg install tor
Updating FreeBSD repository catalogue...
FreeBSD repository is up to date.
All repositories are up to date.
Checking integrity... done (0 conflicting)
The following 1 package(s) will be affected (of 0 checked):

New packages to be INSTALLED:
	tor: 0.4.7.13
```
The command above shows how to install TOR using the pkg package. For those of you who prefer to install using the ports system, here's the command.

```yml
root@ns1:~ # cd /usr/ports/security/tor
root@ns1:/usr/ports/security/tor # make install clean
```
The next step after the installation process is complete is to configure TOR. For more information on the TOR installation and configuration process, you can read the article [TOR Installation And Configuration On FreeBSD Server](https://unixwinbsd.site/openbsd/using-grafana-and-prometheus-monitor-openbsd-activity/).

The main TOR configuration file is located at `/usr/local/etc/tor/torrc`. Edit that file and enable the script below.

```console
root@ns1:~ # ee /usr/local/etc/tor/torrc
SOCKSPort 192.168.5.2:9050
SOCKSPolicy accept 192.168.5.2/24
DNSPort 192.168.5.2:9053
Log notice syslog
RunAsDaemon 1
DataDirectory /var/db/tor
ControlPort 9051
HiddenServiceDir /var/db/tor/bitcoin/
HiddenServicePort 8333 192.168.5.2:8333
```

Then activate the rc.d start up, so that TOR can run automatically when the computer is rebooted or restarted.

```yml
root@ns1:~ # ee /etc/rc.conf
tor_enable="YES"
tor_instances=""
tor_conf="/usr/local/etc/tor/torrc"
tor_user="_tor"
tor_group="_tor"
tor_datadir="/var/db/tor"
```


## 2. Bitcoin Installation and Configuration Process
To install Bitcoin, it's recommended to use the ports system, as this method ensures all Bitcoin dependencies are installed seamlessly. Here's how to install Bitcoin using the FreeBSD ports system.

```yml
root@ns1:~ # cd /usr/ports/net-p2p/bitcoin
root@ns1:/usr/ports/net-p2p/bitcoin # make install clean
```
During installation, options will appear that you can choose according to your needs, in this article we will examine all of these options.

Bitcoin installation can also be done in other ways. You can read a complete explanation regarding Bitcoin installation in the article [How to Configure and Install Bitcoin on OpenBSD](https://unixwinbsd.site/openbsd/how-to-install-bitcoin-btc-on-openbsd/). In this article, we assume you have read the article, so we immediately configure Bitcoin so that it can connect to the TOR Network network.


## 3. How to Connect Bitcoin with TOR
In part 3, we'll cover how to connect your Bitcoin Core Wallet to the TOR Network server. The main Tor onion file is located at `/var/db/tor/bitcoin/hostname`.

```console
root@ns1:~ # ee /var/db/tor/bitcoin/hostname
zywbdxiug6353tvks46c6gzpr3t2jhc4mm6e2pa5pftbnd3yykmkctyd.onion
```

The contents of this file will anonymously connect Bitcoin to the TOR network. Once we have the .onion file, we'll proceed to configure the `/usr/local/etc/bitcoin.conf` file.

```console
root@ns1:~ # ee /usr/local/etc/bitcoin.conf
rpcuser=iwanse1212
rpcpassword=iwanse_1212
#rpcbind=127.0.0.1, 192.168.5.2
rpcallowip=127.0.0.1
server=1
daemon=1
gen=0
port=8333
rpcport=8332

proxy=192.168.5.2:9050
listen=1
bind=192.168.5.2
discover=1
externalip=zywbdxiug6353tvks46c6gzpr3t2jhc4mm6e2pa5pftbnd3yykmkctyd.onion
onlynet=onion

addnode=sato7wjyyc5wr7ssj24q4yeiwsd4vp7ruc6sea2vztwkikbhx5mslnad.onion:8333
addnode=shinjxqy427avxlboncgwutwl53ynfgzhh4ev246ncvdwl4pwmx4rlqd.onion:8333
addnode=nakaiqmpnvtryxsr4ed4g3poko4swq5d2hqzz6fqhmtl7plii5hi34ad.onion:8333
addnode=motozgkgpbhhxs3ize3eudhgwz277l3q7r6jspewjdtfzzbmtni7x6ad.onion:8333
addnode=26dclk7xbzy4f6gaspbxzsmhhb332ozcjhaaksyq4x66ia5ckfdsryad.onion:8333
addnode=2it222nsdjr6xeamcynu2ddsctbovdgfgy5dcstw6u6k44pnxjcttmad.onion:8333
addnode=2jmtxvyup3ijr7u6uvu7ijtnojx4g5wodvaedivbv74w4vzntxbrhvad.onion:8333
addnode=sato7wjyyc5wr7ssj24q4yeiwsd4vp7ruc6sea2vztwkikbhx5mslnad.onion:8333
addnode=shinjxqy427avxlboncgwutwl53ynfgzhh4ev246ncvdwl4pwmx4rlqd.onion:8333
addnode=nakaiqmpnvtryxsr4ed4g3poko4swq5d2hqzz6fqhmtl7plii5hi34ad.onion:8333
addnode=motozgkgpbhhxs3ize3eudhgwz277l3q7r6jspewjdtfzzbmtni7x6ad.onion:8333
```

After that we create a symlink to the `/root` folder.

```console
root@ns1:~ # ln -s /var/db/bitcoin /root/.bitcoin
root@ns1:~ # ln -s /usr/local/etc/bitcoin.conf /root/.bitcoin
```

If the symlink file has been created, the next step is to create a rc.d start up in the `/etc/rc.conf` file.

```yml
root@ns1:~ # ee /etc/rc.conf
bitcoind_enable="YES"
bitcoind_user="bitcoin"
bitcoind_group="bitcoin"
bitcoind_data_dir="/var/db/bitcoin"
```

The final step in the configuration is to reboot the computer, or you can also restart Bitcoin, but it's best to `reboot/restart` the computer at the beginning of the configuration. The command below is used to restart the Bitcoin program.

```yml
root@ns1:~ # service bitcoind restart
```

## 4. Test Bitcoin
Once the steps above have been completed and nothing has been missed, let's test whether Bitcoin is connected to the TOR network. Type the following command to view the Bitcoin and TOR networks.

```console
root@ns1:~ # service bitcoind restart
root@ns1:~ # bitcoin-cli getblockchaininfo
{
  "chain": "main",
  "blocks": 185008,
  "headers": 806682,
  "bestblockhash": "000000000000068b678282b2ec7d5e3f17add5ce1cc3dcf71d6f48ffbb9bc896",
  "difficulty": 1583177.847444009,
  "time": 1339955740,
  "mediantime": 1339953777,
  "verificationprogress": 0.004859871523494127,
  "initialblockdownload": true,
  "chainwork": "00000000000000000000000000000000000000000000001366594d3db4970233",
  "size_on_disk": 2122223223,
  "pruned": false,
  "warnings": ""
}
```

Pay attention to the script writing `185008`, currently our Bitcoin network has been synchronized up to block 185008. Wait for about 3 or 5 minutes, if this number increases, it means our Bitcoin network can now connect to TOR.

```console
root@ns1:~ # bitcoin-cli getblockchaininfo
{
  "chain": "main",
  "blocks": 186698,
  "headers": 806682,
  "bestblockhash": "00000000000007b5e6a1cd7ed89e63e7d63659ee1bce8dd65ec83d58b86c48b8",
  "difficulty": 1726566.55919348,
  "time": 1340936488,
  "mediantime": 1340933909,
  "verificationprogress": 0.005239946366819443,
  "initialblockdownload": true,
  "chainwork": "000000000000000000000000000000000000000000000014105088546ee78a1c",
  "size_on_disk": 2291710528,
  "pruned": false,
  "warnings": ""
}
```

After 3 or 5 minutes, the block number will have changed, meaning we've successfully created Anonymous Bitcoin via the TOR network. Now let's check the Bitcoin network to see if there are any proxy and .onion tags. Type the following command to check the Bitcoin network.

```console
root@ns1:~ # bitcoin-cli getnetworkinfo
{
  "version": 250000,
  "subversion": "/Satoshi:25.0.0/",
  "protocolversion": 70016,
  "localservices": "0000000000000409",
  "localservicesnames": [
    "NETWORK",
    "WITNESS",
    "NETWORK_LIMITED"
  ],
  "localrelay": true,
  "timeoffset": -1,
  "networkactive": true,
  "connections": 11,
  "connections_in": 0,
  "connections_out": 11,
  "networks": [
    {
      "name": "ipv4",
      "limited": true,
      "reachable": false,
      "proxy": "192.168.5.2:9050",
      "proxy_randomize_credentials": true
    },
    {
      "name": "ipv6",
      "limited": true,
      "reachable": false,
      "proxy": "192.168.5.2:9050",
      "proxy_randomize_credentials": true
    },
    {
      "name": "onion",
      "limited": false,
      "reachable": true,
      "proxy": "192.168.5.2:9050",
      "proxy_randomize_credentials": true
    },
    {
      "name": "i2p",
      "limited": true,
      "reachable": false,
      "proxy": "",
      "proxy_randomize_credentials": false
    },
    {
      "name": "cjdns",
      "limited": true,
      "reachable": false,
      "proxy": "192.168.5.2:9050",
      "proxy_randomize_credentials": true
    }
  ],
  "relayfee": 0.00001000,
  "incrementalfee": 0.00001000,
  "localaddresses": [
    {
      "address": "zywbdxiug6353tvks46c6gzpr3t2jhc4mm6e2pa5pftbnd3yykmkctyd.onion",
      "port": 8333,
      "score": 4
    }
  ],
  "warnings": ""
}
```

It turns out it says proxy and .onion, meaning our Core Bitcoin Wallet is now anonymous. We just need to wait for the synchronization process so the Bitcoin Core wallet can be used to receive and transfer Bitcoin. Keep in mind that this Bitcoin synchronization process can take days, due to the large number of blocks. It can even take 3 or 4 days if your internet connection is slow.

While TOR has its drawbacks and isn't a 100% effective solution for securing the Bitcoin network, it does provide more protection than simply running a Bitcoin Core wallet without TOR.