---
title: FreeBSD How to Install XMRIG and CPUMiner for Crypto Mining
date: "2025-08-07 07:45:35 +0100"
updated: "2025-08-07 07:45:35 +0100"
id: install-xmrig-and-cpuminer-crypto-mining-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: Anonymous
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/Install_xmrif_xmr_on_freebsd.jpg
toc: true
comments: true
published: true
excerpt: Initially, this application was often used to mine Monero coins, but over time, as more and more new coins emerged, XMRIG became more widely used for mining Monero coins. Many other coins based on the CryptoNight algorithm can be mined with XMRIG.
keywords: xmrig, xmr, mining, coin, crypto, freebsd, cpuminer, cpu miner, mining, bitcoin
---

This article will explain how to install and configure XMRIG and CPUMiner on FreeBSD. XMRIG and CPUMiner are commonly used by miners to mine cryptocurrency coins.

## 1. About XMRIG and CPUMiner

Initially, this application was often used to mine Monero coins, but over time, as more and more new coins emerged, XMRIG became more widely used for mining Monero coins. Many other coins based on the CryptoNight algorithm can be mined with XMRIG.

XMRig is a high-performance Monero (XMR) miner. Mining with XMRIG can be done using only the CPU or with the help of a graphics card such as an NVIDIA GPU/AMD GPU. Although the yields obtained from CPU mining are significantly lower than those obtained using an NVIDIA GPU/AMD GPU, many miners still mine using CPUs.

XMRIG can run on almost all applications, including Windows, FreeBSD, DragonflyBSD, Linux, and macOS. In general, miners prefer to use XMRIG on Ubuntu Linux and Microsoft Windows.

XMRIG is an open-source application with extremely high performance and maximum hash reading capabilities, making it suitable for various coins with the integrated CPU/GPU mining platforms RandomX, KawPow, CryptoNight, and GhostRider, as well as the RandomX benchmark. Furthermore, XMRig CPU Miner can be used to mine CryptoNight variants with CPUs. The miner allows you to set up a failover backup pool, intelligent automatic CPU configuration, and is open-source. The default fee is 5%, but can be adjusted to 1%.

![Install xmrif xmr on freebsd](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/Install_xmrif_xmr_on_freebsd.jpg)


Meanwhile, CPUMiner is a software program used to generate cryptocurrency using a central processing unit (CPU). Specialized CPUs and software are required to mine some cryptocurrencies, due to their processing speed.

There are various software programs developed for mining purposes, each offering different features to miners. There are two main mining models: solo mining or participating in a mining pool. The latter option is recommended because it can help achieve better results and share mining efforts with other users.

CPUminer is a simple client program that performs pooled mining, or solo mining. The program receives proposed block data from the server and attempts to guess the nonce value that will produce a valid block. If a block hash with at least 32 consecutive zeros is found, the block data containing the guessed nonce value is sent back to the server. When used in pooled mining mode, these blocks are called "shares" because the server is supposed to credit registered user accounts according to the number of shares contributed by the user, and ultimately transfer a certain amount of coins to the addresses of users mining in the pool.

CPUMiner has been largely superseded by the cgminer fork Con Kolivas (with GPU support) and the BFGMiner fork Luke-Jr (with FPGA support).


## 2. XMRIG Installation
On FreeBSD, the process of installing XMRIG using a CPU is not overly complicated. Miners will have difficulty mining XMRIG using a video card, as in addition to installing the XMRIG program, miners must also install the video card driver for the specific video card.

Here's how to install XMRIG on a FreeBSD system.


```
root@ns1:~ # pkg update
root@ns1:~ # pkg upgrade
root@ns1:~ # pkg install git libuv openssl automake libtool autoconf
root@ns1:~ # pkg install cmake hwloc libmicrohttpd
```

The above script updates the FreeBSD software system and installs the repositories required for XMRIG to run on FreeBSD. To install XMRIG, you need to download the XMRIG master file, which can be downloaded from the official XMRIG website or GitHub. In this article, we will download the XMRIG master file from GitHub and place it in the `/usr/local/etc` folder. Follow the steps below to install XMRIG.

```
root@ns1:~ # cd /usr/local/etc
root@ns1:/usr/local/etc # git clone https://github.com/xmrig/xmrig.git
Cloning into 'xmrig'...
remote: Enumerating objects: 27868, done.
remote: Counting objects: 100% (202/202), done.
remote: Compressing objects: 100% (119/119), done.
remote: Total 27868 (delta 99), reused 153 (delta 82), pack-reused 27666
Receiving objects: 100% (27868/27868), 13.22 MiB | 9.00 MiB/s, done.
Resolving deltas: 100% (20409/20409), done.
root@ns1:/usr/local/etc # cd xmrig
root@ns1:/usr/local/etc/xmrig # mkdir build && cd build
root@ns1:/usr/local/etc/xmrig/build # cmake ..
root@ns1:/usr/local/etc/xmrig/build # make -j4
```

The script `"make -j4"` refers to the number of processor threads used. Since I'm using a processor with 4 threads in this installation, I'll write -j4. If you're using a processor with 8 threads, the script would be `"make -j8"`.

If the above installation fails, try another method.


```
root@ns1:/usr/local/etc # cd xmrig
root@ns1:/usr/local/etc/xmrig # cd build
root@ns1:/usr/local/etc/xmrig/build # cmake -DCMAKE_C_COMPILER=gcc -DCMAKE_CXX_COMPILER=g++ ..
root@ns1:/usr/local/etc/xmrig/build # make -j4
```

After the installation is complete, you'll be prompted to create a JSON file. A JSON file contains your coin addresses, mining pool users, and more. We recommend creating three Jason files. Here's a guide on how to create three Jason files in different folders.

```
root@ns1:~ # touch /usr/local/etc/xmrig/build/config.json
root@ns1:~ # touch /root/.xmrig.json
root@ns1:~ # mkdir /root/.config
root@ns1:~ # touch /root/.config/xmrig.json
```

In the script above, we create three JSON files: `config.json, .xmrig.json, and xmrig.json`. Once you've created the JSON files, enter the script below.

```
{
    "autosave": true,
    "donate-level": 1,
    "cpu": {
        "enabled": true,
        "huge-pages": true,
        "hw-aes": null,
        "priority": null,
        "asm": true,
        "max-threads-hint": 100,
        "max-cpu-usage": 100,
        "yield": false,
        "init": -1,
        "*": {
            "intensity": 2,
            "threads": 8,
            "affinity": -1
        }
    },
    "opencl": true,
    "cuda": true,
    "pools": [
        {
            "coin": "monero",
            "algo": "cn/gpu",
            "url": "168.235.86.33:3393",
            "user": "SK_QzApkbVGsAxyQykaWSnEF.umaroh1976",
            "pass": "x",
            "tls": false,
            "keepalive": true,
            "nicehash": false
        }
    ]
}
```

The script above is just an example; you can adjust it depending on the mining pool you'll be using. In the script above, I'm using the mining pool from `autofaucet.org`. If you're using a different mining pool, you'll need to change the script highlighted in red.

You can now start mining. Here's how to mine XMRIG: follow the script below.

```
root@ns1:~ # cd /usr/local/etc/xmrig/build
root@ns1:/usr/local/etc/xmrig/build # ./xmrig
 * ABOUT        XMRig/6.20.0 clang/14.0.5
 * LIBS         libuv/1.46.0 OpenSSL/1.1.1u hwloc/1.11.13
 * HUGE PAGES   supported
 * 1GB PAGES    unavailable
 * CPU          Intel(R) Core(TM)2 Duo CPU E8400 @ 3.00GHz (1) 64-bit -AES
                L2:6.0 MB L3:0.0 MB 2C/2T NUMA:1
 * MEMORY       1.1/1.7 GB (65%)
                DIMM0: 1 GB DDR2 @ 667 MHz                       
                DIMM1: 1 GB DDR2 @ 667 MHz                       
 * MOTHERBOARD  Acer - MMCP73VEM
 * DONATE       1%
 * ASSEMBLY     auto:none
 * POOL #1      168.235.86.33:3393 coin Monero
 * COMMANDS     hashrate, pause, resume, results, connection
[2023-08-03 13:31:24.966]  config   configuration saved to: "/usr/local/etc/xmrig/build/config.json"
```

The `./xmrig` script (red) is to start mining.


## 3. CPUMiner Installation Process
To install CPUMiner on FreeBSD, we need to download the CPUMiner root package. In this article, we'll download the CPUMiner root package from GitHub. Follow these steps.

```
root@ns1:~ # cd /usr/local/etc
root@ns1:/usr/local/etc # git clone https://github.com/pooler/cpuminer.git
Cloning into 'cpuminer'...
remote: Enumerating objects: 1529, done.
remote: Total 1529 (delta 0), reused 0 (delta 0), pack-reused 1529
Receiving objects: 100% (1529/1529), 628.14 KiB | 1.36 MiB/s, done.
Resolving deltas: 100% (995/995), done.
```

In the script above, the downloaded files are stored in the `/usr/local/etc` folder. Once the download is complete, the next step is to install CPUMiner. Follow the script below to run the CPUMiner installation process.

```
root@ns1:~ # cd /usr/local/etc
root@ns1:/usr/local/etc # cd cpuminer
root@ns1:/usr/local/etc/cpuminer # ./autogen.sh
root@ns1:/usr/local/etc/cpuminer # ./configure
root@ns1:/usr/local/etc/cpuminer # make
root@ns1:/usr/local/etc/cpuminer # make install
Making install in compat
Making install in jansson
 ./install-sh -c -d '/usr/local/bin'
  /usr/bin/install -c minerd '/usr/local/bin'
 ./install-sh -c -d '/usr/local/share/man/man1'
 /usr/bin/install -c -m 644 minerd.1 '/usr/local/share/man/man1'
```

To start mining, you can run the `./minerd` script file. Here's an example of how to start mining with CPUMiner on the mining pool `"mining-dutch.nl"`.

```
root@ns1:~ # cd /usr/local/etc/cpuminer
root@ns7:/usr/local/etc/cpuminer # ./minerd --url=stratum+tcp://singapore.mining-dutch.nl:8888 --userpass=umaroh1076.worker1:d=128000
[2024-01-10 06:56:14] Binding thread 1 to cpu 1
[2024-01-10 06:56:14] Binding thread 0 to cpu 0
[2024-01-10 06:56:14] Starting Stratum on stratum+tcp://singapore.mining-dutch.nl:8888
[2024-01-10 06:56:14] 2 miner threads started, using 'scrypt' algorithm.
[2024-01-10 06:56:20] Stratum requested work restart
[2024-01-10 06:56:21] thread 1: 4104 hashes, 6.19 khash/s
[2024-01-10 06:56:21] thread 0: 4104 hashes, 5.07 khash/s
[2024-01-10 06:56:30] Stratum requested work restart
[2024-01-10 06:56:30] thread 1: 43248 hashes, 4.90 khash/s
[2024-01-10 06:56:30] thread 0: 44592 hashes, 5.15 khash/s
[2024-01-10 06:56:31] Stratum requested work restart
[2024-01-10 06:56:31] thread 1: 4560 hashes, 6.33 khash/s
[2024-01-10 06:56:31] thread 0: 3816 hashes, 5.09 khash/s
[2024-01-10 06:56:44] Stratum requested work restart
[2024-01-10 06:56:44] thread 1: 85968 hashes, 6.34 khash/s
[2024-01-10 06:56:44] thread 0: 69912 hashes, 5.17 khash/s
[2024-01-10 06:56:46] Stratum requested work restart
[2024-01-10 06:56:46] thread 1: 10044 hashes, 6.34 khash/s
[2024-01-10 06:56:46] thread 0: 8256 hashes, 5.21 khash/s
[2024-01-10 06:56:49] Stratum requested work restart
[2024-01-10 06:56:49] thread 0: 15984 hashes, 4.67 khash/s
[2024-01-10 06:56:49] thread 1: 21708 hashes, 6.33 khash/s
[2024-01-10 06:56:55] Stratum requested work restart
[2024-01-10 06:56:55] thread 0: 24804 hashes, 4.63 khash/s
[2024-01-10 06:56:55] thread 1: 33924 hashes, 6.33 khash/s
[2024-01-10 06:57:08] Stratum requested work restart
[2024-01-10 06:57:08] thread 0: 63096 hashes, 4.69 khash/s
[2024-01-10 06:57:08] thread 1: 85104 hashes, 6.33 khash/s
```

In the script `--url=http://myminingpool.com:9332 --userpass=my.worker:password`, you must change it to match the name of the mining pool you are using.

If you are focused on becoming a cryptocurrency miner, it is recommended to use a video card for mining. This is because with a video card, you can earn coins faster due to the higher hash rate generated by a video card compared to a CPU processor.