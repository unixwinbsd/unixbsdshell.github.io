---
title: FreeBSD Bitcoin BTC - Installation and Configuration Guide for Mining Bitcoin
date: "2025-07-29 07:56:21 +0100"
updated: "2025-07-29 07:56:21 +0100"
id: configuration-guide-mining-bitcoin-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: Anonymous
background: https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQaUx-YKo8_UjiPCOXDd3RqXFHp14-VCq0m6A&s
toc: true
comments: true
published: true
excerpt: Bitcoin (BTC) is a cryptocurrency, a virtual currency designed to act as money and a form of payment outside the control of any single person, group, or entity, eliminating the need for third-party involvement in financial transactions. Bitcoin is awarded to blockchain miners for their work verifying transactions and can be purchased on several exchanges.
keywords: bitcoin, btc, minning, bitcoin, crypto, freebsd, tor, network, onion, proxy, install, configuration
---

Bitcoin (BTC) is a cryptocurrency, a virtual currency designed to act as money and a form of payment outside the control of any single person, group, or entity, eliminating the need for third-party involvement in financial transactions. Bitcoin is awarded to blockchain miners for their work verifying transactions and can be purchased on several exchanges.

Bitcoin was introduced to the public in 2009 by an anonymous developer or group of developers using the name Satoshi Nakamoto. Since its introduction, Bitcoin has become the world's most well-known cryptocurrency. Its popularity has inspired the development of many other cryptocurrencies. These competitors are trying to replace it as a payment system or are used as utility or security tokens in other blockchains and emerging financial technologies.

For FreeBSD systems, we rarely found articles covering Bitcoin installation, configuration, and mining. Bitcoin is more widely discussed on Linux systems like Ubuntu and Debian. We found numerous articles explaining how to install, configure, and mine Bitcoin.

From an operating system perspective, FreeBSD is very stable for running crypto wallets like [Bitcoin, DogeCoin, XMR RIG](https://unixwinbsd.site/freebsd/install-xmrig-and-cpuminer-crypto-mining-freebsd/), and others. Furthermore, when it comes to crypto mining, I prefer FreeBSD.

In this article, we'll try to cover Bitcoin in more depth and detail, particularly regarding installation and configuration. This article will guide you through setting up Bitcoin on a FreeBSD system. In this case, the FreeBSD version used is FreeBSD 13.2 Stable.

Okay, let's get started installing and configuring Bitcoin on a FreeBSD 13.2 Stable system.


## 1. Bitcoin Installation Process on FreeBSD
To run Bitcoin on FreeBSD, you'll need to install the Bitcoin application. Before installing Bitcoin, make sure your FreeBSD system is up to date. If not, run the following command.

```console
root@router2:~ # pkg update
Updating FreeBSD repository catalogue...
FreeBSD repository is up to date.
All repositories are up to date.
root@router2:~ # pkg upgrade -y
Updating FreeBSD repository catalogue...
FreeBSD repository is up to date.
All repositories are up to date.
Updating database digests format: 100%
Checking for upgrades (203 candidates): 100%
Processing candidates (203 candidates): 100%
Checking integrity... done (0 conflicting)
Your packages are up to date.
root@router2:~ #
```

After the update and upgrade process is complete, install other supporting applications. These applications are crucial, as without them, Bitcoin will not run on a FreeBSD system.

```yml
root@router2:~ # pkg install autoconf automake boost-libs git libevent libtool pkgconf
root@router2:~ # pkg install libzmq4  miniupnpc norm openpgm python39 sqlite3 db5 gmake
```

After that create an account for the user and group with the name **"bitcoin"**.

```console
root@router2:~ # adduser
Username: bitcoin
Full name: bitcoin wallet
Uid (Leave empty for default):
Login group [bitcoin]:
Login group is bitcoin. Invite bitcoin into other groups? []:
Login class [default]:
Shell (sh csh tcsh bash rbash git-shell nologin) [sh]:
Home directory [/home/bitcoin]:
Home directory permissions (Leave empty for default):
Use password-based authentication? [yes]: no
Lock out the account after creation? [no]:
Username   : bitcoin
Password   : <disabled>
Full Name  : bitcoin wallet
Uid        : 1018
Class      :
Groups     : bitcoin
Home       : /home/bitcoin
Home Mode  :
Shell      : /bin/sh
Locked     : no
OK? (yes/no): yes
adduser: INFO: Successfully added (bitcoin) to the user database.
Add another user? (yes/no): no
Goodbye!
```

Once the Bitcoin user and group have been created, it's time to install Bitcoin. Follow the script below to install Bitcoin. To install Bitcoin, you can copy the complete files from `https://github.com/bitcoin/bitcoin`.

```yml
root@router2:~ # cd /usr/local/etc
root@router2:/usr/local/etc/bitcoin # git clone https://github.com/bitcoin/bitcoin.git
root@router2:/usr/local/etc/bitcoin # cd bitcoin
root@router2:/usr/local/etc/bitcoin # ./autogen.sh
root@router2:/usr/local/etc/bitcoin # ./configure --disable-hardening MAKE="gmake" CFLAGS="-I/usr/local/include" CXXFLAGS="-I/usr/local/include -I/usr/local/include/db5" LDFLAGS="-L/usr/local/lib -L/usr/local/lib/db5"
root@router2:/usr/local/etc/bitcoin # gmake
root@router2:/usr/local/etc/bitcoin # gmake check
root@router2:/usr/local/etc/bitcoin # gmake install
```

At this point, if there are no errors when running the gmake syntax, Bitcoin should be installed on your FreeBSD system, but it won't run yet. Let's continue with configuring Bitcoin.


## 2. How to Configure Bitcoin
The first step in the configuration process is to create a Bitcoin Start Up script. We add this script to the `/etc/rc.conf` file. Add the following script to the `/etc/rc.conf` file.

```yml
bitcoin_enable="YES"
bitcoin_user="bitcoin"
bitcoin_group="bitcoin"
bitcoin_config="/usr/home/bitcoin/.bitcoin/bitcoin.conf"
bitcoin_datadir="/usr/home/bitcoin/.bitcoin"
```

The next step is to create folders and files that are used to store Bitcoin blockchain files.

```yml
root@router2:~ # mkdir -p /usr/home/bitcoin/.bitcoin
root@router2:~ # touch /usr/home/bitcoin/.bitcoin/bitcoin.conf
root@router2:~ # touch /usr/home/bitcoin/.bitcoin/debug.log
root@router2:~ # chmod -R +x /usr/home/bitcoin/.bitcoin/debug.log
root@router2:~ # chown -R bitcoin:bitcoin /usr/home/bitcoin/.bitcoin/
```
Before we move on to the next step, create a symlink to the `/root` folder.

```yml
root@router2:~ # ln -s /usr/home/bitcoin/.bitcoin /root
```

Continue by creating the Start Up `rc.d` script. This script is useful for running commands to start, restart, and stop the Bitcoin daemon. Furthermore, the Start Up `rc.d` script is also used to autoload so that the Bitcoin daemon always runs when the server computer is shut down or restarted. In Start Up `rc.d`, we will name the file bitcoind. Follow these steps to create the `rc.d` script.

```yml
root@router2:~ # touch /usr/local/etc/rc.d/bitcoin
root@router2:~ # chmod -R +x /usr/local/etc/rc.d/bitcoin
```

Type the script below in the file `"/usr/local/etc/rc.d/bitcoind"`.

```console
#!/bin/sh

# PROVIDE: bitcoind
# REQUIRE: LOGIN cleanvar
# KEYWORD: shutdown

#
# Add the following lines to /etc/rc.conf to enable :
# bitcoind_enable (bool):	Set to "NO" by default.
#				Set it to "YES" to enable bitcoind
# bitcoind_user (str)		Set to "bitcoin" by default.
# bitcoind_group (str)		Set to "bitcoin" by default.
# bitcoind_conf (str)		Set to "/usr/local/etc/bitcoind.conf" by default.
# bitcoind_data_dir (str)	Set to "/var/db/bitcoin" by default.
# bitcoindlimits_enable (bool)	Set to "NO" by default.
#				Set it to "YES" to enable bitcoindlimits
# bitcoindlimits_args		Set to "-e -U ${bitcoind_user}" by default


. /etc/rc.subr

name="bitcoind"
rcvar=bitcoind_enable

start_precmd="bitcoind_precmd"
start_cmd="bitcoind_start"
restart_precmd="bitcoind_checkconfig"
reload_precmd="bitcoind_checkconfig"
configtest_cmd="bitcoind_checkconfig"
status_cmd="bitcoind_status"
stop_cmd="bitcoind_stop"
stop_postcmd="bitcoind_wait"
command="/usr/local/bin/bitcoind"
daemon_command="/usr/sbin/daemon"
pidfile="/var/run/${name}.pid"
extra_commands="configtest"


: ${bitcoind_enable:="NO"}
: ${bitcoindlimits_enable:="NO"}

load_rc_config ${name}

: ${bitcoind_user:="bitcoin"}
: ${bitcoind_group:="bitcoin"}
: ${bitcoind_data_dir:="/var/db/bitcoin"}
: ${bitcoind_config_file:="/usr/local/etc/bitcoin.conf"}
: ${bitcoindlimits_args:="-e -U ${bitcoind_user}"}

# set up dependant variables
procname="${command}"
required_files="${bitcoind_config_file}"


bitcoind_checkconfig()
{
  echo "Performing sanity check on bitcoind configuration:"
  if [ ! -d "${bitcoind_data_dir}" ]
  then
    echo "Missing data directory: ${bitcoind_data_dir}"
    exit 1
  fi
  chown -R "${bitcoind_user}:${bitcoind_group}" "${bitcoind_data_dir}"

  if [ ! -f "${bitcoind_config_file}" ]
  then
    echo "Missing configuration file: ${bitcoind_config_file}"
    exit 1
  fi
  if [ ! -x "${command}" ]
  then
    echo "Missing executable: ${command}"
    exit 1
  fi
  return 0
}

bitcoind_cleanup()
{
  rm -f "${pidfile}"
}

bitcoind_precmd()
{
  bitcoind_checkconfig

  pid=$(check_pidfile "${pidfile}" "${procname}")
  if [ -z "${pid}" ]
  then
    echo "Bitcoind is not running"
    rm -f "${pidfile}"
  fi

  if checkyesno bitcoindlimits_enable
  then
    eval $(/usr/bin/limits ${bitcoindlimits_args}) 2>/dev/null
  else
    return 0
  fi
}

bitcoind_status()
{
  local pid
  pid=$(check_pidfile "${pidfile}" "${procname}")
  if [ -z "${pid}" ]
  then
    echo "Bitcoind is not running"
    return 1
  else
    echo "Bitcoind running, pid: ${pid}"
  fi
}

bitcoind_start()
{
  echo "Starting bitcoind:"
  cd "${bitcoind_data_dir}" || return 1
  ${daemon_command} -u "${bitcoind_user}" -p "${pidfile}" -f \
    ${command} \
    -conf="${bitcoind_config_file}" \
    -datadir="${bitcoind_data_dir}"
}

bitcoind_stop()
{
  echo "Stopping bitcoind:"
  pid=$(check_pidfile "${pidfile}" "${procname}")
  if [ -z "${pid}" ]
  then
    echo "Bitcoind is not running"
    return 1
  else
    kill ${pid}
  fi
}

bitcoind_wait()
{
  local n=60
  echo "Waiting for bitcoind shutdown:"
  while :
  do
    printf '.'
    pid=$(check_pidfile "${pidfile}" "${procname}")
    if [ -z "${pid}" ]
    then
      printf '\n'
      break
    fi
    sleep 1
    n=$((${n} - 1))
    if [ ${n} -eq 0 -a -f "${pidfile}" ]
    then
      printf "\nForce shutdown"
      kill -9 $(cat "${pidfile}")
      for n in 1 2 3
      do
        printf '.'
        sleep 1
      done
      printf '\n'
      break
    fi
  done
  rm -f "${pidfile}"
  echo "Shutdown complete"
}

run_rc_command "$1"
```

Once you've finished creating the `rc.d` Start Up script, continue by creating a configuration file, which we'll name bitcoind.conf. Place the `bitcoin.conf` file in the `/usr/home/bitcoin/.bitcoin` folder. The following is the script file `/usr/home/bitcoin/.bitcoin/bitcoin.conf`.

```console
root@router2:~ # ee /usr/home/bitcoin/.bitcoin/bitcoin.conf

listen=1
port=8333

rpcallowip=192.168.9.3
rpcpassword=jakasetiawan
rpcuser=iwanse1212
rpcport=8332

conf=/usr/home/bitcoin/.bitcoin/bitcoin.conf
daemon=1
server=1

debuglogfile=/usr/home/bitcoin/.bitcoin/debug.log
datadir=/usr/home/bitcoin/.bitcoin
pid=/usr/home/bitcoin/.bitcoin/bitcoin.pid
addnode=seed.bitcoin.sipa.be
addnode=54.38.85.30:8333
addnode=46.19.137.74:8333
addnode=141.98.219.12:8333
addnode=50.107.158.135:8333
addnode=76.150.98.135:8333
addnode=166.70.145.151:8333
addnode=96.74.179.132:8333
addnode=34.75.215.83:8333
```

IP 192.168.9.3 is the FreeBSD server's LAN IP. You can change the IP to match your FreeBSD server's IP. The next step is to restart/reboot the FreeBSD server.

```yml
root@router2:~ # reboot
```

Once the FreeBSD server computer is back to normal, start the Bitcoin daemon.

```yml
root@router2:~ # service bitcoin start
```


## 3. How to Mine Bitcoin on FreeBSD
To mine Bitcoin, you can use the CPUminer program. cpuminer is a simple daemon that runs Bitcoin or Litecoin. Cpuminer can be used for solo mining or pooled mining. Here's how to install cpuminer on a FreeBSD system.

```yml
root@ns1:~ # cd /usr/ports/net-p2p/cpuminer
root@ns1:/usr/ports/net-p2p/cpuminer # make install clean
```

Cpuminer can also be installed with the FreeBSD native package.

```yml
root@ns1:~ # pkg install net-p2p/cpuminer
```

For now, if you're considering Bitcoin mining, consider carefully. Besides the high cost of computer spare parts, the difficulty of obtaining Bitcoins through the mining process is also increasing.