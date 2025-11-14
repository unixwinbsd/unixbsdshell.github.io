---
title: FreeBSD Crypto - How to Install BTCD Full Node Bitcoin with Go Lang
date: "2025-08-04 09:03:21 +0100"
updated: "2025-08-04 09:03:21 +0100"
id: freebsd-install-bitcoin-btc-with-go-lang
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: Anonymous
background: /img/oct-25/Logo.png
toc: true
comments: true
published: true
excerpt: One fundamental difference between BTCD and Bitcoin Core is that BTCD does not include a wallet function, a decision made by the BTCD developers to differentiate between Bitcoin Core and BTCD. Without a wallet function, you cannot make or receive payments directly with BTCD
keywords: bitcoin, btc, freebsd, crypto, currency, go, lang, language, installation, configuration
---

btcd is an alternative full-node Bitcoin implementation written in the Go programming language (Go Lang). The btcd project is under active development and is in Beta status. Its stability is comparable to Bitcoin Core, and it has been in production use since October 2013.

When you use Bitcoin Core or any other Bitcoin protocol implementation, you trust the software to implement the protocol correctly and handle all operations correctly. One of the most impressive advantages of the Bitcoin network is that it can protect itself from malicious or misbehaving nodes.

The first full-node client implementation, and one that remains popular today, is Bitcoin. Bitcoin Core is the original client released by Satoshi Nakamoto. The Bitcoin project is open-source and actively maintained by the Bitcoin community. Installable binaries are available on bitcoin.org for any platform of choice.

Besides Bitcoin Core, another well-known client is BTCD by Conformal Systems. BTCD implements most of the core node functionality except for the wallet and on-chain functionality. The team instead separated the wallet functionality into a separate wallet application called btcwallet. The btcd client application also has slight differences from Bitcoin Core, such as enabling TLS for RPC connections by default and accepting HTTP and Websocket requests.

BTC Wallet is a hierarchical deterministic (HD) Bitcoin wallet client for a single user. The application acts as an RPC client for btcd and an RPC server for wallet clients and legacy RPC applications. btcWAllet uses HD paths for BIP0044 address derivation and encrypts private keys and public data.

BTCD can correctly download, validate, and serve blockchains using the same block acceptance rules as Bitcoin Core. In working on this project, the development team took great care to prevent BTCD from causing a fork in the blockchain. This work includes a comprehensive block validation testing framework containing all the 'official' block acceptance tests (and several additional tests) that are run on every withdrawal request to help ensure it follows consensus correctly. Furthermore, BTCD can pass all JSON test data within the Bitcoin Core code.

BTCD's advantages extend beyond this: BTCD clients can correctly submit newly mined blocks, maintain transaction pools, and submit individual transactions that have not yet been included in blocks. This ensures that all individual transactions accepted into the pool follow the blockchain's required rules and also includes stricter vetting by filtering transactions based on miner requirements.


## 1. Btcd Installation Process
One fundamental difference between BTCD and Bitcoin Core is that BTCD does not include a wallet function, a decision made by the BTCD developers to differentiate between Bitcoin Core and BTCD. Without a wallet function, you cannot make or receive payments directly with BTCD. This functionality is provided by the BTCWallet and Paymetheus projects (for Windows only), both of which are still in active development.

Since Btcd is written in Go, the primary requirement for installing it is that Go must be installed on the FreeBSD server. You can read our previous article on [the Go installation process on FreeBSD](https://unixwinbsd.site/freebsd/go-lang-freebsd14-golang-install/).

For those of you familiar with installing Bitcoin Core or other cryptocurrencies, installing Btcd will be very easy. Despite its many feature abstractions, the configuration process is nearly identical to Bitcoin Core. Btcd also has an RPC interface compatible with Bitcoin Core. Aside from the wallet and blockchain features, everything else is nearly identical to Bitcoin Core.

FreeBSD doesn't provide a PKG package or porting system for Btcd; you'll need to download it from the official Btcd repository on GitHub. Follow the instructions below to get started configuring Btcd.

```yml
root@ns7:~ # cd /usr/local/etc
root@ns7:/usr/local/etc # git clone https://github.com/btcsuite/btcd.git
root@ns7:/usr/local/etc # cd btcd
root@ns7:/usr/local/etc/btcd #
```

Run the following commands to update btcd, all dependencies, and install it on `FreeBSD`.

```console
root@ns7:/usr/local/etc/btcd # mkdir -p bin
root@ns7:/usr/local/etc/btcd # git pull

Already up to date.
root@ns7:/usr/local/etc/btcd # go install -v . ./cmd/...
```

The install command above will create an executable bin file. On FreeBSD, the location of the Btcd bin file is `/root/go/bin`. It's up to you whether you want to move the bin file or not. We recommend moving it to the Btcd folder.

```console
root@ns7:/usr/local/etc/btcd # mv /root/go/bin/* /usr/local/etc/btcd/bin
```

## 2. Btcd Configuration Process

Since Btcd and Bitcoin Core are in the same family, the configuration methods are almost identical. On FreeBSD, the location of the Btcd data file is **/root/.btcd**. Copy the file **/usr/local/etc/btcd/sample-btcd.conf** to the **/root/.btcd** folder. Use the following commands to copy it.

```yml
root@ns7:/usr/local/etc/btcd # mkdir -p /root/.btcd
root@ns7:/usr/local/etc/btcd # mkdir -p /root/.btcd/data
root@ns7:/usr/local/etc/btcd # cp /usr/local/etc/btcd/sample-btcd.conf /root/.btcd/btcd.conf
```

The above command creates the .btcd folder and copies and renames the `sample-btcd.conf`file to btcd.conf.

To better understand how to configure Btcd, run the btcd -help command to see where we'll place our configuration options.

```console
root@ns7:/usr/local/etc/btcd # cd bin
root@ns7:/usr/local/etc/btcd/bin # ./btcd -h
Usage:
  btcd [OPTIONS]

Application Options:
      --addcheckpoint=        Add a custom checkpoint.  Format: '<height>:<hash>'
  -a, --addpeer=              Add a peer to connect with at startup
      --addrindex             Maintain a full address-based transaction index which makes the searchrawtransactions RPC available
      --agentblacklist=       A comma separated list of user-agent substrings which will cause btcd to reject any peers whose user-agent contains any of the blacklisted
                              substrings.
      --agentwhitelist=       A comma separated list of user-agent substrings which will cause btcd to require all peers' user-agents to contain one of the whitelisted
                              substrings. The blacklist is applied before the blacklist, and an empty whitelist will allow all agents that do not fail the blacklist.
      --banduration=          How long to ban misbehaving peers.  Valid time units are {s, m, h}.  Minimum 1 second (default: 24h0m0s)
      --banthreshold=         Maximum allowed ban score before disconnecting and banning misbehaving peers. (default: 100)
      --blockmaxsize=         Maximum block size in bytes to be used when creating a block (default: 750000)
      --blockminsize=         Minimum block size in bytes to be used when creating a block
      --blockmaxweight=       Maximum block weight to be used when creating a block (default: 3000000)
      --blockminweight=       Minimum block weight to be used when creating a block
      --blockprioritysize=    Size in bytes for high-priority/low-fee transactions when creating a block (default: 50000)
      --blocksonly            Do not accept transactions from remote peers.
  -C, --configfile=           Path to configuration file (default: /root/.btcd/btcd.conf)
      --connect=              Connect only to the specified peers at startup
      --cpuprofile=           Write CPU profile to the specified file
      --memprofile=           Write memory profile to the specified file
  -b, --datadir=              Directory to store data (default: /root/.btcd/data)
      --dbtype=               Database backend to use for the Block Chain (default: ffldb)
  -d, --debuglevel=           Logging level for all subsystems {trace, debug, info, warn, error, critical} -- You may also specify <subsystem>=<level>,<subsystem2>=<level>,...
                              to set the log level for individual subsystems -- Use show to list available subsystems (default: info)
      --dropaddrindex         Deletes the address-based transaction index from the database on start up and then exits.
      --dropcfindex           Deletes the index used for committed filtering (CF) support from the database on start up and then exits.
      --droptxindex           Deletes the hash-based transaction index from the database on start up and then exits.
      --externalip=           Add an ip to the list of local addresses we claim to listen on to peers
      --generate              Generate (mine) bitcoins using the CPU
      --limitfreerelay=       Limit relay of transactions with no transaction fee to the given amount in thousands of bytes per minute (default: 15)
      --listen=               Add an interface/port to listen for connections (default all interfaces port: 8333, testnet: 18333)
      --logdir=               Directory to log output. (default: /root/.btcd/logs)
      --maxorphantx=          Max number of orphan transactions to keep in memory (default: 100)
      --maxpeers=             Max number of inbound and outbound peers (default: 125)
      --miningaddr=           Add the specified payment address to the list of addresses to use for generated blocks -- At least one address is required if the generate option
                              is set
      --minrelaytxfee=        The minimum transaction fee in BTC/kB to be considered a non-zero fee. (default: 1e-05)
      --nobanning             Disable banning of misbehaving peers
      --nocfilters            Disable committed filtering (CF) support
      --nocheckpoints         Disable built-in checkpoints.  Don't do this unless you know what you're doing.
      --nodnsseed             Disable DNS seeding for peers
      --nolisten              Disable listening for incoming connections -- NOTE: Listening is automatically disabled if the --connect or --proxy options are used without also
                              specifying listen interfaces via --listen
      --noonion               Disable connecting to tor hidden services
      --nopeerbloomfilters    Disable bloom filtering support
      --norelaypriority       Do not require free or low-fee transactions to have high priority for relaying
      --nowinservice          Do not start as a background service on Windows -- NOTE: This flag only works on the command line, not in the config file
      --norpc                 Disable built-in RPC server -- NOTE: The RPC server is disabled by default if no rpcuser/rpcpass or rpclimituser/rpclimitpass is specified
      --nostalldetect         Disables the stall handler system for each peer, useful in simnet/regtest integration tests frameworks
      --notls                 Disable TLS for the RPC server -- NOTE: This is only allowed if the RPC server is bound to localhost
      --onion=                Connect to tor hidden services via SOCKS5 proxy (eg. 127.0.0.1:9050)
      --onionpass=            Password for onion proxy server
      --onionuser=            Username for onion proxy server
      --profile=              Enable HTTP profiling on given port -- NOTE port must be between 1024 and 65536
      --proxy=                Connect via SOCKS5 proxy (eg. 127.0.0.1:9050)
      --proxypass=            Password for proxy server
      --proxyuser=            Username for proxy server
      --prune=                Prune already validated blocks from the database. Must specify a target size in MiB (minimum value of 1536, default value of 0 will disable
                              pruning)
      --regtest               Use the regression test network
      --rejectnonstd          Reject non-standard transactions regardless of the default settings for the active network.
      --rejectreplacement     Reject transactions that attempt to replace existing transactions within the mempool through the Replace-By-Fee (RBF) signaling policy.
      --relaynonstd           Relay non-standard transactions regardless of the default settings for the active network.
      --rpccert=              File containing the certificate file (default: /root/.btcd/rpc.cert)
      --rpckey=               File containing the certificate key (default: /root/.btcd/rpc.key)
      --rpclimitpass=         Password for limited RPC connections
      --rpclimituser=         Username for limited RPC connections
      --rpclisten=            Add an interface/port to listen for RPC connections (default port: 8334, testnet: 18334)
      --rpcmaxclients=        Max number of RPC clients for standard connections (default: 10)
      --rpcmaxconcurrentreqs= Max number of concurrent RPC requests that may be processed concurrently (default: 20)
      --rpcmaxwebsockets=     Max number of RPC websocket connections (default: 25)
      --rpcquirks             Mirror some JSON-RPC quirks of Bitcoin Core -- NOTE: Discouraged unless interoperability issues need to be worked around
  -P, --rpcpass=              Password for RPC connections
  -u, --rpcuser=              Username for RPC connections
      --sigcachemaxsize=      The maximum number of entries in the signature verification cache (default: 100000)
      --simnet                Use the simulation test network
      --signet                Use the signet test network
      --signetchallenge=      Connect to a custom signet network defined by this challenge instead of using the global default signet test network -- Can be specified multiple
                              times
      --signetseednode=       Specify a seed node for the signet network instead of using the global default signet network seed nodes
      --testnet               Use the test network
      --torisolation          Enable Tor stream isolation by randomizing user credentials for each connection.
      --trickleinterval=      Minimum time between attempts to send new inventory to a connected peer (default: 10s)
      --utxocachemaxsize=     The maximum size in MiB of the UTXO cache (default: 250)
      --txindex               Maintain a full hash-based transaction index which makes all transactions available via the getrawtransaction RPC
      --uacomment=            Comment to add to the user agent -- See BIP 14 for more information.
      --upnp                  Use UPnP to map our listening port outside of NAT
  -V, --version               Display version information and exit
      --whitelist=            Add an IP network or IP that will not be banned. (eg. 192.168.1.0/24 or ::1)

Help Options:
  -h, --help                  Show this help message
```


You can now edit the btcd.conf file. Adjust the configuration to suit your computer's hardware and FreeBSD server specifications.

Once everything is configured, run Btcd with the command `"./btcd"`.

```console
root@ns7:/usr/local/etc/btcd/bin # ./btcd --configfile=/root/.btcd/btcd.conf
2024-01-11 17:21:32.586 [INF] BTCD: RPC service is disabled
2024-01-11 17:21:32.586 [INF] BTCD: Version 0.24.0-beta
2024-01-11 17:21:32.586 [INF] BTCD: Loading block database from '/root/.btcd/data/mainnet/blocks_ffldb'
2024-01-11 17:21:32.647 [INF] BTCD: Block database loaded
2024-01-11 17:21:32.673 [INF] INDX: Committed filter index is enabled
2024-01-11 17:21:32.673 [INF] CHAN: Pre-alloacting for 251 MiB:
2024-01-11 17:21:32.805 [INF] INDX: Catching up indexes from height -1 to 0
2024-01-11 17:21:32.805 [INF] INDX: Indexes caught up to height 0
2024-01-11 17:21:32.805 [INF] CHAN: Chain state (height 0, hash 000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f, totaltx 1, work 4295032833)
2024-01-11 17:21:32.806 [INF] AMGR: Loaded 0 addresses from file '/root/.btcd/data/mainnet/peers.json'
2024-01-11 17:21:32.806 [INF] CMGR: Server listening on [::]:8333
2024-01-11 17:21:32.807 [INF] CMGR: Server listening on 0.0.0.0:8333
2024-01-11 17:21:33.065 [INF] CMGR: 40 addresses found from DNS seed seed.bitnodes.io
2024-01-11 17:21:33.178 [INF] CMGR: 37 addresses found from DNS seed seed.bitcoinstats.com
2024-01-11 17:21:33.345 [INF] CMGR: 37 addresses found from DNS seed seed.btc.petertodd.net
2024-01-11 17:21:33.480 [INF] CMGR: 37 addresses found from DNS seed seed.bitcoin.jonasschnelli.ch
2024-01-11 17:21:34.456 [INF] CMGR: 39 addresses found from DNS seed seed.bitcoin.sipa.be
2024-01-11 17:21:34.643 [INF] CMGR: 31 addresses found from DNS seed dnsseed.bluematt.me
2024-01-11 17:21:37.933 [INF] SYNC: New valid peer 155.137.251.136:8333 (outbound) (/Satoshi:25.0.0/)
2024-01-11 17:21:37.933 [INF] SYNC: Syncing to block height 825278 from peer 155.137.251.136:8333
2024-01-11 17:21:37.933 [INF] SYNC: Downloading headers for blocks 1 to 11111 from peer 155.137.251.136:8333
2024-01-11 17:21:38.174 [INF] SYNC: New valid peer 93.176.165.238:8333 (outbound) (/Satoshi:25.0.0/)
2024-01-11 17:21:38.196 [INF] SYNC: New valid peer 89.149.200.202:8333 (outbound) (/Satoshi:24.0.1/)
2024-01-11 17:21:38.217 [INF] SYNC: New valid peer 81.106.103.172:8333 (outbound) (/Satoshi:25.1.0/)
2024-01-11 17:21:38.245 [INF] SYNC: New valid peer 65.21.199.219:8333 (outbound) (/Satoshi:24.0.1/)
2024-01-11 17:21:38.530 [INF] SYNC: Verified downloaded block header against checkpoint at height 11111/hash 0000000069e244f73d78e8fd29ba2fd2ed618bd6fa2ee92559f542fdb26e7c1d
2024-01-11 17:21:38.530 [INF] SYNC: Received 11111 block headers: Fetching blocks
2024-01-11 17:21:38.641 [INF] SYNC: Lost peer 81.106.103.172:8333 (outbound)
2024-01-11 17:21:39.161 [INF] SYNC: New valid peer 131.188.40.47:8333 (outbound) (/Satoshi:26.0.0/)
2024-01-11 17:21:39.169 [INF] SYNC: Lost peer 89.149.200.202:8333 (outbound)
2024-01-11 17:21:42.374 [INF] CHAN: Verified checkpoint at height 11111/block 0000000069e244f73d78e8fd29ba2fd2ed618bd6fa2ee92559f542fdb26e7c1d
2024-01-11 17:21:42.374 [INF] SYNC: Downloading headers for blocks 11112 to 33333 from peer 155.137.251.136:8333
2024-01-11 17:21:42.891 [INF] CMGR: 1 addresses found from DNS seed dnsseed.bitcoin.dashjr.org
2024-01-11 17:21:43.222 [INF] SYNC: Verified downloaded block header against checkpoint at height 33333/hash 000000002dd5588a74784eaa7ab0507a18ad16a236e7b1ce69f00d7ddfb5d0a6
2024-01-11 17:21:43.222 [INF] SYNC: Received 22222 block headers: Fetching blocks
^C2024-01-11 17:21:43.577 [INF] BTCD: Received signal (interrupt).  Shutting down...
2024-01-11 17:21:43.578 [INF] BTCD: Gracefully shutting down the server...
2024-01-11 17:21:43.578 [WRN] SRVR: Server shutting down
2024-01-11 17:21:43.578 [INF] SYNC: Lost peer 155.137.251.136:8333 (outbound)
2024-01-11 17:21:43.578 [INF] SYNC: Sync manager shutting down
2024-01-11 17:21:43.581 [INF] SYNC: Syncing to block height 825279 from peer 65.21.199.219:8333
2024-01-11 17:21:43.581 [INF] SYNC: Downloading headers for blocks 11112 to 33333 from peer 65.21.199.219:8333
2024-01-11 17:21:43.581 [INF] CHAN: Flushing UTXO cache of 98 MiB with 10594 entries to disk. For large sizes, this can take up to several minutes...
```

The synchronization process can take 3-4 days, depending on your internet connection and machine specifications. However, you can start testing blockchain data while the synchronization is in progress. Use the Bitcoin testnet by adding the --testnet flag to btcd. This way, you can easily test transactions with the testnet coins.