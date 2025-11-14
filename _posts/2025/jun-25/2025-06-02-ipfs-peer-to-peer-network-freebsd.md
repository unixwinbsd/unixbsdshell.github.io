---
title: How to Install IPFS Peer to Peer Networking on FreeBSD
date: "2025-06-02 08:23:11 +0100"
updated: "2025-09-10 11:45:03 +0100"
id: ipfs-peer-to-peer-network-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: Anonymous
background: https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/20http-vs-ipfs%20on%20freebsd.jpg&commit=ca2dd5f899232a3c6599934133a9cb99a3ca0ef1
toc: true
comments: true
published: true
excerpt: If you are running an IPFS node that serves many requests, such as a public HTTP gateway, IPFS can speed up queries by maintaining long-term connections to IPFS nodes that serve many CIDs. Using IPFS, you can prioritize connections to specific peers called Peering
keywords: ipfs, peer to peer, peer, network, freensd, torrent, web3, connection
---
Using a copy of the data CID or content identifier, IPFS helps you request data from each IPFS node. This process usually involves searching a distributed hash table and may also require creating a new connection to the node that holds the content.

If you are running an IPFS node that serves many requests, such as a public HTTP gateway, IPFS can speed up queries by maintaining long-term connections to IPFS nodes that serve many CIDs. Using IPFS, you can prioritize connections to specific peers called Peering. The Peering process will tell IPFS which peers to prioritize by editing the Peering configuration in your IPFS configuration file.

IPFS offers several advantages including faster data transfer, reduced fault tolerance, and reduced server load. Not only that, IPFS also has the ability to access data even when disconnected from the Internet or when the data server is unavailable.

In this article, we will learn how to install and use IPFS on a FreeBSD server. Before discussing IPFS further, it doesn't hurt to get to know IPFS first.

## 1. What is Inter Planetary File System (IPFS)
IPFS (InterPlanetary File System) is a modular protocol suite that builds a peer-to-peer network with resources addressed by their content, rather than physical location as in HTTP. IPFS can organize and transfer data, designed from the ground up with the principles of content addressing and peer-to-peer networking.

Since IPFS is open source, there are several implementations of IPFS. Although IPFS has more than one use case, its primary use case is for publishing data (files, directories, and websites) in a decentralized manner. IPFS provides us with some of the blockchain guarantees such as decentralization and immutable storage at a much lower price than the transaction fees and participation in the free IPFS network.

<br/>
![http vs ipfs on freebsd](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/20http-vs-ipfs%20on%20freebsd.jpg&commit=ca2dd5f899232a3c6599934133a9cb99a3ca0ef1)
<br/>

The important thing to understand about IPFS is that when you add files through an IPFS node, the IPFS network does not store your files. The files you add remain on your computer and others can read your files. However, when you turn off your computer or turn off an IPFS node on your local network, others cannot read your files until you come back online. Unless you store your files on an external IPFS node, any files you add will remain unreadable to others.

While there are storage providers that are built with IPFS support (often known as embedding services), IPFS itself is a protocol, not a provider. IPFS can be used and complements cloud infrastructure, but IPFS itself is not a cloud service provider.

## 2. How to Install and Configure IPFS
On FreeBSD, IPFS runs in GO, so before you install IPFS on a FreeBSD server, the GO Lang application must be installed first. Read the previous article about ["How to Install GOLANG GO Language on FreeBSD 14"](https://unixwinbsd.site/en/freebsd/2024/12/24/go-lang-freebsd14-golang-install/).

IPFS on FreeBSD 13.2 can only run with the Go language version: go119.

After you read the article above, we continue with installing IPFS. If you are using PUTTY, type the command below in the PuTTY shell menu.

### 2.1 Create Go lang symlink.
```console
root@ns1:~ # rm -R -f /usr/local/bin/go
root@ns1:~ # ln -s /usr/local/bin/go119 /usr/local/bin/go
```
<br/>
### 2.2. Install IPFS with the FreeBSD ports system.

```console
root@ns6:~ # cd /usr/ports/sysutils/ipfs-go
root@ns6:/usr/ports/sysutils/ipfs-go # make install clean
```

<br/>
### 2.3. Run IPFS with the rc.d script, add the script below to the /etc/rc.conf file.

```console
root@ns6:/usr/ports/sysutils/ipfs-go # ee /etc/rc.conf

ipfs_go_enable="YES"
ipfs_go_user="ipfs-go"
ipfs_go_group="ipfs-go"
ipfs_go_path="/var/db/ipfs-go/.ipfs"
ipfs_go_syslog_priority="info"
ipfs_go_syslog_facility="daemon"
ipfs_go_syslog_tag="ipfs-go"
```

The script above is used to run IPFS automatically on a local computer. Take a look at the script above, in the script we can see that the IPFS configuration file is in the `/var/db/ipfs-go` folder. To make editing easier, use WINSCP, open the folder with WINSCP. See the image below.

<br/>
![directory ipfs on freebsd](https://cdn.publish0x.com/prod/fs/cachedimages/1981597517-b409ac9a52d2f321659f0b73b52a92839a84e3022670e68fa320046fc1e73669.webp)
<br/>


Open the configuration file `/var/db/ipfs-go/.ipfs/config`, and edit its contents according to the script below.

```console
{
  "API": {
    "HTTPHeaders": {
      "Access-Control-Allow-Methods": [
        "PUT",
        "POST"
      ],
      "Access-Control-Allow-Origin": [
        "http://192.168.5.2:5001",
        "http://localhost:3000",
        "http://127.0.0.1:5001",
        "https://webui.ipfs.io"
      ]
    }
  },
  "Addresses": {
    "API": "/ip4/192.168.5.2/tcp/5001",
    "Announce": [],
    "AppendAnnounce": [],
    "Gateway": "/ip4/192.168.5.2/tcp/8080",
    "NoAnnounce": [],
    "Swarm": [
      "/ip4/0.0.0.0/tcp/4001",
      "/ip6/::/tcp/4001",
      "/ip4/0.0.0.0/udp/4001/quic",
      "/ip4/0.0.0.0/udp/4001/quic-v1",
      "/ip4/0.0.0.0/udp/4001/quic-v1/webtransport",
      "/ip6/::/udp/4001/quic",
      "/ip6/::/udp/4001/quic-v1",
      "/ip6/::/udp/4001/quic-v1/webtransport"
    ]
  },
  "AutoNAT": {},
  "Bootstrap": [
    "/dnsaddr/bootstrap.libp2p.io/p2p/QmNnooDu7bfjPFoTZYxMNLWUQJyrVwtbZg5gBMjTezGAJN",
    "/dnsaddr/bootstrap.libp2p.io/p2p/QmQCU2EcMqAqQPR2i9bChDtGNJchTbq5TbXJJ16u19uLTa",
    "/dnsaddr/bootstrap.libp2p.io/p2p/QmbLHAnMoJPWSCR5Zhtx6BHJX9KiKNN6tpvbUcqanj75Nb",
    "/dnsaddr/bootstrap.libp2p.io/p2p/QmcZf59bWwK5XFi76CZX8cbJ4BhTzzA3gU1ZjYZcYW3dwt",
    "/ip4/104.131.131.82/tcp/4001/p2p/QmaCpDMGvV2BGHeYERUEnRQAwe3N8SzbUtfsmvsqQLuvuJ",
    "/ip4/104.131.131.82/udp/4001/quic/p2p/QmaCpDMGvV2BGHeYERUEnRQAwe3N8SzbUtfsmvsqQLuvuJ"
  ],
  "DNS": {
    "Resolvers": {}
  },
  "Datastore": {
    "BloomFilterSize": 0,
    "GCPeriod": "1h",
    "HashOnRead": false,
    "Spec": {
      "mounts": [
        {
          "child": {
            "path": "blocks",
            "shardFunc": "/repo/flatfs/shard/v1/next-to-last/2",
            "sync": true,
            "type": "flatfs"
          },
          "mountpoint": "/blocks",
          "prefix": "flatfs.datastore",
          "type": "measure"
        },
        {
          "child": {
            "compression": "none",
            "path": "datastore",
            "type": "levelds"
          },
          "mountpoint": "/",
          "prefix": "leveldb.datastore",
          "type": "measure"
        }
      ],
      "type": "mount"
    },
    "StorageGCWatermark": 90,
    "StorageMax": "10GB"
  },
  "Discovery": {
    "MDNS": {
      "Enabled": true
    }
  },
  "Experimental": {
    "AcceleratedDHTClient": true,
    "FilestoreEnabled": false,
    "GraphsyncEnabled": false,
    "Libp2pStreamMounting": false,
    "P2pHttpProxy": false,
    "StrategicProviding": false,
    "UrlstoreEnabled": false
  },
  "Gateway": {
    "APICommands": [],
    "HTTPHeaders": {
      "Access-Control-Allow-Headers": [
        "X-Requested-With",
        "Range",
        "User-Agent"
      ],
      "Access-Control-Allow-Methods": [
        "GET"
      ],
      "Access-Control-Allow-Origin": [
        "*"
      ]
    },
    "NoDNSLink": false,
    "NoFetch": false,
    "PathPrefixes": [],
    "PublicGateways": {
      "https://ipfs.io/": {
        "Paths": [
          "/ipfs",
          "/ipns"
        ],
        "UseSubdomains": true
      }
    },
    "RootRedirect": ""
  },
  "Identity": {
    "PeerID": "12D3KooWQkFkABHUCULXkPyRfrLA81dHXgC8evRhdYHWdMRrVcMX",
    "PrivKey": "CAESQNAw3t1E9zNXln5PV5RsoKpK6ewLYMmkNjm0m+5XRNys3dG3lvylqCjlHt88TbEkZDmu5n71YG9JLGMj1gbm5AI="
  },
  "Internal": {},
  "Ipns": {
    "RecordLifetime": "",
    "RepublishPeriod": "",
    "ResolveCacheSize": 128
  },
  "Migration": {
    "DownloadSources": [],
    "Keep": ""
  },
  "Mounts": {
    "FuseAllowOther": false,
    "IPFS": "/ipfs",
    "IPNS": "/ipns"
  },
  "Peering": {
    "Peers": null
  },
  "Pinning": {
    "RemoteServices": {}
  },
  "Plugins": {
    "Plugins": null
  },
  "Provider": {
    "Strategy": ""
  },
  "Pubsub": {
    "DisableSigning": false,
    "Router": ""
  },
  "Reprovider": {},
  "Routing": {
    "Methods": null,
    "Routers": null
  },
  "Swarm": {
    "AddrFilters": null,
    "ConnMgr": {},
    "DisableBandwidthMetrics": false,
    "DisableNatPortMap": false,
    "RelayClient": {},
    "RelayService": {},
    "ResourceMgr": {
      "Limits": {}
    },
    "Transports": {
      "Multiplexers": {},
      "Network": {},
      "Security": {}
    }
  }
}
```

Note the blue writing, the number `192.168.5.2` is your computer's local IP address. After that we run the `ipfs-go init` command.

```console
root@ns6:~ # ipfs-go init
root@ns6:~ # ipfs-go config --json API.HTTPHeaders.Access-Control-Allow-Origin '["http://192.168.5.2:5001", "http://localhost:3000", "http://127.0.0.1:5001", "https://webui.ipfs.io"]'
root@ns6:~ # ipfs-go config --json API.HTTPHeaders.Access-Control-Allow-Methods '["PUT", "POST"]'
```

Then you continue by creating an IPFS symlink file to `/root`.

```console
root@ns6:~ # rm -rf /root/.ipfs
root@ns6:~ # ln -s /var/db/ipfs-go/.ipfs /root
```

After that, you create another file `/var/db/ipfs-go/.ipfs/api`.

```console
root@ns6:/var/db/ipfs-go/.ipfs/ipfs # touch /var/db/ipfs-go/.ipfs/api
root@ns6:/var/db/ipfs-go/.ipfs/ipfs # ee /var/db/ipfs-go/.ipfs/api

/ip4/192.168.5.2/tcp/5001
```

After that we continue by running IPFS.

```console
root@ns6:/var/db/ipfs-go/.ipfs/ipfs # service ipfs-go restart
```

<br/>
## 3. Test IPFS
Once everything is configured, the last step is to test whether the IPFS server is running or not. Basic proof that 'ipfs is working' locally. The first step is to create a folder `/var/db/ipfs-go/.ipfs/ipfs` to store all IPFS data.

```console
root@ns6:~ # mkdir -p /var/db/ipfs-go/.ipfs/ipfs
root@ns6:~ # cd /var/db/ipfs-go/.ipfs/ipfs
root@ns6:/var/db/ipfs-go/.ipfs/ipfs #
```

After that we create IPFS data, this data will later be used on the peer to peer network via the IPFS Node.

```console
root@ns6:/var/db/ipfs-go/.ipfs/ipfs # echo "FreeBSD IPFS local server" > TestIPFS
root@ns6:/var/db/ipfs-go/.ipfs/ipfs # ipfs-go add TestIPFS
added QmNeCaGW44nddxLZGQmk6GagSafb8gZwcou8YbvhW1wt5b TestIPFS
 26 B / 26 B [==========================================================================================================================================================] 100.00%
root@ns6:/var/db/ipfs-go/.ipfs/ipfs # ipfs-go cat QmNeCaGW44nddxLZGQmk6GagSafb8gZwcou8YbvhW1wt5b
FreeBSD IPFS local server
root@ns6:/var/db/ipfs-go/.ipfs/ipfs #
```

<br/>
```console
root@ns6:/var/db/ipfs-go/.ipfs/ipfs # echo "Test IPFS on FreeBSD" > FreeBSDTest.txt
root@ns6:/var/db/ipfs-go/.ipfs/ipfs # ipfs-go add FreeBSDTest.txt
added QmZiaPkqkAsgcCyc84wLnbQnweSj9s2CuJbBSXVzyihshk FreeBSDTest.txt
 21 B / 21 B [==========================================================================================================================================================] 100.00%
root@ns6:/var/db/ipfs-go/.ipfs/ipfs # ipfs-go cat QmZiaPkqkAsgcCyc84wLnbQnweSj9s2CuJbBSXVzyihshk
Test IPFS on FreeBSD
root@ns6:/var/db/ipfs-go/.ipfs/ipfs #
```

Restart IPFS

```console
root@ns6:/var/db/ipfs-go/.ipfs/ipfs # chown -R ipfs-go:ipfs-go /var/db/ipfs-go/.ipfs/
root@ns6:/var/db/ipfs-go/.ipfs/ipfs # service ipfs-go restart
```

Now let's try to connect to the http port on the web browser. Open Google Chrome or Yandex web browser, type `http://192.168.5.2:5001/webui`.

<br/>
![testipfs](https://cdn.publish0x.com/prod/fs/cachedimages/258001144-95e0edde55e76fcac82a70f10bf9c8b743df18f6ba3e901a161ac169564675cb.webp)
<br/>

Once you are connected to the IPFS Node, now try typing the CIDS from the `FreeBSDTest.txt and TestIPFS` files we created earlier, notice the CIDS in blue above.

In `Yandex Browser` or `Google Chrome` enter the following command:

```
http://192.168.5.2:8080/ipfs/QmNeCaGW44nddxLZGQmk6GagSafb8gZwcou8YbvhW1wt5b
http://192.168.5.2:8080/ipfs/QmZiaPkqkAsgcCyc84wLnbQnweSj9s2CuJbBSXVzyihshk
```

I run an IPFS node on a FreeBSD 13.2 machine and I have no major issues with it, everything works fine. For programmatic access, you can make the IPFS gateway scriptable and use the IPFS HTTP API. There are many creative use cases for IPFS.

