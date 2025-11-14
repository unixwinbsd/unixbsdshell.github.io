---
title: Running Linux with Bitcoin Full Node - Installation and Configuration
date: "2025-08-08 13:21:15 +0100"
updated: "2025-10-02 09:35:33 +0100"
id: linux-bitcoin-full-node-installation
lang: en
author: Iwan Setiawan
robots: index, follow
categories: Linux
tags: Anonymous
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/A_full_node_is_a_program_that_validates_transactions.jpg" src="/img/oct-25/oct-25-132.jpg
toc: true
comments: true
published: true
excerpt: A full node is a program that fully validates transactions and blocks. Almost all full nodes also contribute to the network by receiving transactions and blocks from other full nodes, validating them, and then forwarding them to other full nodes.
keywords: bitcoin, btc, bitcoind, full node, tor, network, linux, ubuntu, debian, crypto, coin
---

Bitcoin Full Node has been upgraded to the latest Bitcoin Core V0.25, along with bitcoin-qt, bitcoin-cli, and bitcoin-wallet, on Ubuntu 24.04. This version also includes the latest Ordinal installed, a numbering scheme for satoshis that allows tracking and transferring individual satoshis. For more information, please visit [the Ordinal documentation](https://docs.ordinals.com/overview.html).

A full node is a program that fully validates transactions and blocks. Almost all full nodes also contribute to the network by receiving transactions and blocks from other full nodes, validating them, and then forwarding them to other full nodes.

Most full nodes also serve light clients by allowing them to submit their transactions to the network and notifying them when transactions affect their wallets. If there aren't enough nodes performing these functions, clients won't be able to connect through the peer-to-peer network and will have to use centralized services instead.

Many people and organizations have volunteered to run Bitcoin Full Nodes using their spare computing resources and bandwidth, but more volunteers are needed for Bitcoin to continue growing. This document explains how you can help and how much it will cost you to do so.

<br/>

{% lazyload data-src="https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/A_full_node_is_a_program_that_validates_transactions.jpg" src="/img/oct-25/oct-25-132.jpg" alt="A full node is a program that validates transactions" %}

<br/>

Bitcoin full nodes are accessible via IPv4, IPv6, and as a hidden service over the Tor network. In this article, we'll install what's known as a Bitcoin full node.


## 1. Storage Space

The Bitcoin blockchain is enormous and continues to grow. This is because every Bitcoin mined and every transaction ever made is recorded in the blockchain. As of April 2015, the blockchain was 32 gigabytes in size. Together with the index and other data, a single full node occupies approximately 42 gigabytes of disk space on the server.

You can track the blockchain's growth over time on the Bitcoin Blockchain Size website. To check the available disk space on your server, which will house the Bitcoin database.

```sh
runtu@runtu-desktop:~$ df -h /var/lib
Filesystem                   Size  Used Avail Use% Mounted on
/dev/mapper/server--vg-root  456G  102G  331G  24% /
```

You can check the disk space used by running nodes with the following command:

```sh
runtu@runtu-desktop:~$ sudo du -hs /var/lib/bitcoind/*|sort -h
0       /var/lib/bitcoind/db.log
20K     /var/lib/bitcoind/fee_estimates.dat
84K     /var/lib/bitcoind/wallet.dat
212K    /var/lib/bitcoind/debug.log
952K    /var/lib/bitcoind/peers.dat
732M    /var/lib/bitcoind/chainstate
41G     /var/lib/bitcoind/blocks
```

## 2. IP Address

This guide assumes that we allocate the following IP addresses for the Bitcoin daemon we will be running.
- 2001:db8::39 is the global public IPv6 address.
- 192.0.2.39 is the local private IPv4 address (port forwarded from the public IPv4 address).
- 36.90.10.34 is the dynamic public Internet address provided by your internet provider.

Once we know the IP address, it's time to determine the IP on the server that will be used.

```
runtu@runtu-desktop:~$ sudo ip addr add 192.0.2.39/24 dev eth0
runtu@runtu-desktop:~$ sudo ip addr add 2001:db8::39/64 dev eth0
```

Don't forget to also add it to the /etc/network/interfaces file to keep it static even if the system is restarted.

```
# btc.example.net
iface eth0 inet static
    address 192.0.2.39/24
iface eth0 inet6 static
address 2001:db8::39/64
```

In your DNS server settings, add the IP4 and IP6 addresses for the Bitcoin server.

| Name       | Type          | Content        |  Priority        |  TTL        |
| ----------- | -----------   | ----------- | ----------- | ----------- |
| BTC          | A          | 198.51.100.240          |           | 300          |
| BTC          | AAAA      | 2001:db8::39          |           |           |


Please note that the Bitcoin daemon listens for incoming connections on TCP ports 8333 and 18333. Therefore, you must forward these ports to Bitcoin.

IPv4 NAT port forwarding (private).

| Protocol       | Port No.          | Forward To        |  Description        |
| ----------- | -----------   | ----------- | ----------- | 
| TCP          | 8333          | 192.0.2.39          | Bitcoin network          |
| 8333          | 18333      | 192.0.2.39          | Bitcoin TEST Network          |

Also allow connections for IP6

| Protocol       | Port No.          | Destination        |  Description        |
| ----------- | -----------   | ----------- | ----------- |
| TCP          | 8333          | 2001:db8::39          | Bitcoin Network          |
| TCP          | 18333      | 2001:db8::39          | Bitcoin Test Network          |


## 3. Tor Hidden Service

To enhance the security of a Bitcoin full node, enable `TOR`, which anonymizes your network. To do this, edit `/etc/tor/torrc`.

```
# BitCoin Full Node Hidden Service for btc.example.net
HiddenServiceDir /var/lib/tor/hidden_services/bitcoin
HiddenServicePort 8333
HiddenServicePort 18333
```

Restart the TOR application that you activated above.

```
runtu@runtu-desktop:~$ sudo service tor reload
```
You can see the TOR host name (.onion) that you created above with the following command.

```
runtu@runtu-desktop:~$ sudo cat /var/lib/tor/hidden_services/bitcoin/hostname
duskgytldkxiuqc6.onion
```

## 4. Create a User Who Can Access the Bitcoin Server

For security reasons, it's recommended that you run the Bitcoin daemon with a non-privileged user profile. Create a user that can access the Bitcoin daemon on your Ubuntu server system with the following command.

```
runtu@runtu-desktop:~$ sudo adduser --system --group --home /var/lib/bitcoind bitcoin
```

## 5. Bitcoin Full Node Installation Process

Almost all Linux systems, even BSD, don't have the Bitcoin package available by default in their repositories. To install Bitcoin, you must first install the Bitcoin package on your Linux/Ubuntu system.

```
runtu@runtu-desktop:~$ sudo apt-add-repository ppa:bitcoin/bitcoin
runtu@runtu-desktop:~$ sudo apt-get update
runtu@runtu-desktop:~$ sudo apt-get install bitcoind
```

After the Bitcoin installation process is complete, create an empty configuration directory and configuration file, then assign access rights to these files.

```
runtu@runtu-desktop:~$ sudo mkdir /etc//bitcoin
runtu@runtu-desktop:~$ sudo touch /etc/bitcoin/bitcoin.conf
runtu@runtu-desktop:~$ sudo chmod 600 /etc/bitcoin/bitcoin.conf
```

We need a password for remote procedure calls to the Bitcoin daemon. You must create this password manually by opening the `"/etc/bitcoin/bitcoin.conf"` file and adding the following script.

```
rpcuser=bitcoinuser
rpcpassword=bitcoinpassword
```
Below we provide a complete example of the `"/etc/bitcoin/bitcoin.conf"` file script.

```
# Bitcoind Daemon Configuration
#

# General options
datadir=/var/lib/bitcoind
alertnotify=echo %s | mail -s "Bitcoin Alert" root

# Connection options
bind=192.0.2.39
bind=[2001:db8::39]
externalip=btc.example.net

# Tor Hidden Service Options
onion=127.0.0.1:9150
bind=127.0.0.1
externalip=duskgytldkxiuqc6.onion

# Long running Bitcoin Nodes on the Tor Network
# http://nodes.bitcoin.st/tor/
addnode=pqosrh6wfaucet32.onion
addnode=btc4xysqsf3mmab4.onion
addnode=gb5ypqt63du3wfhn.onion
addnode=3lxko7l4245bxhex.onion

# Verified Online Bitcoin nodes on the Tor Network from 
# https://rossbennetts.com/2015/04/running-bitcoind-via-tor/
addnode=kjy2eqzk4zwi5zd3.onion
addnode=it2pj4f7657g3rhi.onion

# Verified Online Bitcoin nodes on the Tor Network from 
# https://en.bitcoin.it/wiki/Fallback_Nodes#Tor_nodes
addnode=hhiv5pnxenvbf4am.onion
addnode=bpdlwholl7rnkrkw.onion
addnode=vso3r6cmjoomhhgg.onion
addnode=kjy2eqzk4zwi5zd3.onion

# Verified Online Bitcoin nodes on the Tor Network from 
# https://sky-ip.org
addnode=h2vlpudzphzqxutd.onion
addnode=xyp7oeeoptq7jllb.onion

# RPC server options
rpcuser=bitcoinrpc
rpcpassword=HkFbv9YaWgEgyy7X4B9vi3GsENtGWgPNpwUf2ehsvXX1

# Maintain a full index of historical transaction IDs
# Required by Electrum Server
txindex=1
```

After that, you give ownership rights to files and folders to the Bitcoin daemon.

```
runtu@runtu-desktop:~$ sudo chown -R bitcoin:bitcoin /etc/bitcoin
```

## 6. Ubuntu Upstart

The Bitcoin Project recommends running the daemon as an Upstart service on Ubuntu and setting up an Upstart script for bitcoind. Download and install the Upstart script.

```
runtu@runtu-desktop:~$ cd downloads
runtu@runtu-desktop:~$ wget https://raw.githubusercontent.com/bitcoin/bitcoin/0.10/contrib/init/bitcoind.conf
runtu@runtu-desktop:~$ sudo cp bitcoind.conf /etc/init/
```

The final step is to run Bitcoind.

```
runtu@runtu-desktop:~$ sudo start bitcoind
bitcoind start/running, process 17019
```
If the message `"bitcoind start/running, process 17019"` appears, it means your Bitcoind daemon is running normally.

## 7. Monitoring

Running a Bitcoin daemon wouldn't be complete without monitoring it. The monitoring process is also useful for checking each running log. These logs allow you to check for any errors on the Bitcoin server.


```
runtu@runtu-desktop:~$ sudo -u bitcoin multitail /var/lib/bitcoind/debug.log
```

To see if your node is known and reachable in the Bitcoin network, check the Bitnodes website.

https://getaddr.bitnodes.io/nodes/192.0.2.39-8333/
https://getaddr.bitnodes.io/nodes/2001:db8::39-8333/

You can also check your Tor Hidden Service *.onion node by entering its address in the form at the bottom of the page and clicking the "Check Node" button. However, no details will be displayed except for whether the node is accepting connections.

To view transactions processed by your IPv4 node.

https://blockchain.info/ip-address/192.0.2.39

IPv6 and Tor Hidden Service Nodes are not supported by blockchain.info, so full details cannot be displayed.

As mentioned previously, the database that stores the Bitcoin blockchain is very large. However, because it is a publicly available, distributed, peer-to-peer database, it does not need to be backed up by individual nodes. If data is lost on one node, other nodes can also be used, and any node can redownload and reprocess the blockchain at any time.