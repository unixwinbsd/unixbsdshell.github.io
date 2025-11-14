---
title: How to Install and Configure DOGE Coin on FreeBSD
date: "2025-07-27 11:54:21 +0100"
updated: "2025-07-27 11:54:21 +0100"
id: installation-and-configuration-doge-coin-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: Anonymous
background: https://cdn.prod.website-files.com/63d3a51793749b0d8dd77ce4/65a5948e49590487ae5b1db6_how-to-mine-dogecoin.webp
toc: true
comments: true
published: true
excerpt: Doge Coin is an open-source, peer-to-peer digital currency loved by Shiba Inu enthusiasts around the world. Essentially, Dogecoin is an accidental crypto move that makes people smile! It's also an open-source, peer-to-peer cryptocurrency that uses blockchain technology, a highly secure, decentralized system of storing information as a public ledger maintained by a network of computers called nodes.
keywords: dofecoin, doge, minning, bitcoin, crypto, freebsd, tor, network, onion, proxy, install, configuration
---

Doge Coin is an open-source, peer-to-peer digital currency loved by Shiba Inu enthusiasts around the world.

Essentially, Dogecoin is an accidental crypto move that makes people smile! It's also an open-source, peer-to-peer cryptocurrency that uses blockchain technology, a highly secure, decentralized system of storing information as a public ledger maintained by a network of computers called nodes. But more than that, there's the Dogecoin ethos encapsulated in the Dogecoin Manifesto and its incredible, vibrant community of friendly, energetic people.

This article is a continuation of a previous article discussing Bitcoin on FreeBSD. Similar to the previous Bitcoin article, this time we'll learn how to install and configure the Dogecoin Core Wallet on a FreeBSD machine. In this article, the latest version of FreeBSD is being used, FreeBSD 13.2.

Although there are slight differences, the steps for [installing Dogecoin are almost the same as installing Bitcoin on a FreeBSD system](https://unixwinbsd.site/linux/linux-bitcoin-full-node-installation/).


## 1. Dogecoin Core Wallet Installation
As usual, before installing Dogecoin, you must first install the Dogecoin supporting software. Clang is the built-in CC language compiler used to compile Dogecoin files. Clang is also useful for compiling the dependencies required by Dogecoin. Follow the script below to begin installing Dogecoin on FreeBSD.

```yml
root@router2:~ # pkg install autoconf automake libtool pkgconf
root@router2:~ # pkg install boost-libs openssl libevent
root@router2:~ # pkg install gmake db5
```

Once everything is installed successfully, let's begin installing Dogecoin. You can download the complete files and the final version of Dogecoin on the GitHub website. Go to the following GitHub URL: `https://github.com/dogecoin/dogecoin` and download all the files with the script below.

```yml
root@router2:~ # cd /usr/local/etc
root@router2:~ # git clone https://github.com/dogecoin/dogecoin.git
```

Once we have downloaded the file, proceed with the script.

```yml
root@router2:~ # cd /usr/local/etc/dogecoin
root@router2:/usr/local/etc/dogecoin # ./autogen.sh
root@router2:/usr/local/etc/dogecoin # ./configure --with-incompatible-bdb --disable-tests --disable-hardening MAKE="gmake" CFLAGS="-I/usr/local/include" CXXFLAGS="-I/usr/local/include -I/usr/local/include/db5" LDFLAGS="-L/usr/local/lib -L/usr/local/lib/db5"
root@router2:/usr/local/etc/dogecoin # gmake
root@router2:/usr/local/etc/dogecoin # gmake check
root@router2:/usr/local/etc/dogecoin # gmake install 
```

This installation process takes a long time, so be patient and wait until the Dogecoin installation process is complete.


## 2. Dogecoin Core Wallet Configuration
Make sure you haven't missed any of the steps above. If you do, you can't expect Dogecoin to run properly on FreeBSD. Next, we'll start configuring the Dogecoin Core Wallet. Create a user and group named Dogecoin.

```console
root@router2:~ # adduser
Username: dogecoin
Full name: dogecoin wallet
Uid (Leave empty for default):
Login group [dogecoin]:
Login group is dogecoin. Invite dogecoin into other groups? []:
Login class [default]:
Shell (sh csh tcsh bash rbash git-shell nologin) [sh]:
Home directory [/home/dogecoin]:
Home directory permissions (Leave empty for default):
Use password-based authentication? [yes]: no
Lock out the account after creation? [no]:
Username   : dogecoin
Password   : <disabled>
Full Name  : dogecoin wallet
Uid        : 1017
Class      :
Groups     : dogecoin
Home       : /home/dogecoin
Home Mode  :
Shell      : /bin/sh
Locked     : no
OK? (yes/no): yes
adduser: INFO: Successfully added (dogecoin) to the user database.
Add another user? (yes/no): no
Goodbye!
```

Once the dogecoin user and group have been successfully created, proceed to create the `/usr/home/dogecoin/.dogecoin` folder. This folder will store all Dogecoin blockchain files, including wallet files with the `.dat` extension.

```yml
root@router2:~ # mkdir -p /usr/home/dogecoin/.dogecoin
root@router2:~ # touch /usr/home/dogecoin/.dogecoin/debug.log
```

Don't forget to create a configuration file named dogecoin.conf, save this file in the `/usr/home/dogecoin/.dogecoin` folder.

```yml
root@router2:~ # touch /usr/home/dogecoin/.dogecoin/dogecoin.conf
root@router2:~ # chmod -R +x /usr/home/dogecoin/.dogecoin/dogecoin.conf
root@router2:~ # chmod -R 777 /usr/home/dogecoin/.dogecoin/debug.log
root@router2:~ # chown -R dogecoin:dogecoin /usr/home/dogecoin/.dogecoin/
```

The next step is to create a dogecoin.conf script. This script contains any configurations or commands you'll apply to the Dogecoin daemon. Place the following script in the `/usr/local/etc/dogecoin.conf` file.

```console
root@router2:~ # ee /usr/home/dogecoin/.dogecoin/dogecoin.conf
listen=1
port=22556

rpcallowip=192.168.9.3
rpcpassword=jakasetiawan
rpcuser=iwanse1212
rpcport=22555

conf=/usr/home/dogecoin/.dogecoin/dogecoin.conf
daemon=1
server=1

printtoconsole=/usr/home/dogecoin/.dogecoin/debug.log
datadir=/usr/home/dogecoin/.dogecoin
pid=/usr/home/dogecoin/.dogecoin/dogecoind.pid

addnode=seed.multidoge.org
addnode=1.seed.dogecoin.gg
addnode=2.seed.dogecoin.gg
addnode=3.seed.dogecoin.gg
addnode=4.seed.dogecoin.gg
```

When creating the dogecoin.conf configuration file, ensure there are no typos, especially regarding the location of the dogecoin folder. Note the script above; the Dogecoin file is stored in the `.dogecoin` folder. Notice the dot at the beginning of the **dogecoin** sentence. The next step is to create a symlink file to the `/root` folder.

```yml
root@router2:~ # ln -s /usr/home/dogecoin/.dogecoin /root
```

## 3. Create a Start Up Script rc.d
On the FreeBSD system, the rc.d script plays a crucial role. Almost every application running on FreeBSD has an rc.d script. This script is useful for automatically activating programs. This means we don't need to execute the program to activate it. Simply create an rc.d script, and any program can run automatically when the computer is shut down or restarted.

Now, let's create an `rc.d` script for the Dogecoin program and name it dogecoin. Please follow these steps to automatically run Dogecoin.

```yml
root@router2:~ # touch /usr/local/etc/rc.d/dogecoin
root@router2:~ # chmod -R +x /usr/local/etc/rc.d/dogecoin
```

After dogecoin script `rc.d` successfully created, enter the following script in the file `/usr/local/etc/rc.d/dogecoin`.

```console
#!/bin/sh

# PROVIDE: dogecoin
# REQUIRE: LOGIN
# KEYWORD: shutdown

#
# Add the following lines to /etc/rc.conf.local or /etc/rc.conf
# to enable this service:
#
# dogecoin_enable (bool):	Set to NO by default.
#				Set it to YES to enable dogecoin.
# dogecoin_config (path):	Set to /usr/home/dogecoin/.dogecoin/dogecoin.conf
#				by default.
# dogecoin_user:	The user account dogecoin daemon runs as
#				It uses 'root' user by default.
# dogecoin_group:	The group account dogecoin daemon runs as
#				It uses 'wheel' group by default.
# dogecoin_datadir (str):	Default to "/home/dogecoin/.dogecoin"
#				Base data directory.

. /etc/rc.subr

name=dogecoin
rcvar=dogecoin_enable

: ${dogecoin_enable:=NO}
: ${dogecoin_config=/usr/home/dogecoin/.dogecoin/dogecoin.conf}
: ${dogecoin_datadir=/usr/home/dogecoin/.dogecoin}
: ${dogecoin_user="dogecoin"}
: ${dogecoin_group="dogecoin"}

required_files=${dogecoin_config}
command=/usr/local/bin/dogecoind
dogecoin_chdir=${dogecoin_datadir}
pidfile="${dogecoin_datadir}/dogecoind.pid"
stop_cmd=dogecoin_stop
command_args="-conf=${dogecoin_config} -datadir=${dogecoin_datadir} -noupnp -daemon -pid=${pidfile}"
start_precmd="${name}_prestart"

dogecoin_create_datadir()
{
	echo "Creating data directory"
	eval mkdir -p ${dogecoin_datadir}
	[ $? -eq 0 ] && chown -R ${dogecoin_user}:${dogecoin_group} ${dogecoin_datadir}
}

dogecoin_prestart()
{
	if [ ! -d "${dogecoin_datadir}/." ]; then
		dogecoin_create_datadir || return 1
	fi
}

dogecoin_requirepidfile()
{
	if [ ! "0`check_pidfile ${pidfile} ${command}`" -gt 1 ]; then
		echo "${name} not running? (check $pidfile)."
		exit 1
	fi
}

dogecoin_stop()
{
    dogecoin_requirepidfile

	echo "Stopping ${name}."
	eval ${command} -conf=${dogecoin_config} -datadir=${dogecoin_datadir} stop
	wait_for_pids ${rc_pid}
}

load_rc_config $name
run_rc_command "$1"
```

If you have finished scripting the dogecoin `rc.d` file, continue by editing the `rc.conf` file to create the Dogecoin Start Up daemon. Enter the script below into the `/etc/rc.conf` file.

```yml
root@router2:~ # ee /etc/rc.conf
dogecoin_enable="YES"
dogecoin_config="/usr/local/etc/dogecoin.conf"
dogecoin_datadir="/home/dogecoin/.dogecoin"
dogecoin_user="dogecoin"
dogecoin_group="dogecoin"
```

The final step is to `reboot/restart` the FreeBSD server computer.

```yml
root@router2:~ # reboot
```

Once the computer is back to normal, run the Dogecoin daemon.

```yml
root@router2:~ # service dogecoin start
```

If you haven't missed any of the steps above, you've successfully installed the Dogecoin daemon, and your FreeBSD server is now running the Dogecoin daemon application. The next step is to create a Dogecoin wallet address. This wallet address is essential for storing and transferring your assets.


## 4. How to Create a Doge Coin Wallet Address
To receive DOGE, you need an address securely derived from a private key through a series of automated cryptographic operations. The address can be shared with anyone to receive DOGE, but the private key is sensitive information that allows anyone who knows it to spend DOGE at the associated address.

Before creating a Dogecoin wallet address, the most important thing is to create a key or password for your Dogecoin Wallet Core. This password will protect and safeguard your Dogecoin Wallet Core from those who want to steal your Dogecoin assets. With this password, no one can access your Dogecoin Wallet Core; only you can access it. Keep this password safe and don't lose it, because if you lose or forget it, your assets will also be lost, as you won't be able to transfer them anywhere else. Here's how to create a key/password for your Dogecoin Wallet Core.

```yml
root@router2:~ # dogecoin-cli encryptwallet "passwordsaya"
wallet encrypted; Dogecoin server stopping, restart to run with encrypted wallet. The keypool has been flushed and a new HD seed was generated (if you are using HD). You need to make a new backup.
root@router2:~ # service dogecoin stop
root@router2:~ # service dogecoin start
```

`mypassword` is your Dogecoin Wallet Core password. Keep this password safe and secret so that no one else knows it. Now let's move on to creating a Dogecoin Wallet Core wallet address.

By default, the Dogecoin Core software will automatically generate a wallet address for you and securely store the private key in the wallet.dat file. Follow the instructions below to create a Dogecoin wallet address.

```console
root@router2:~ # root@router2:~ # cd /usr/local/bin
root@router2:/usr/local/bin # dogecoin-cli getaddressesbyaccount ""
[
  "D8S9uKQFvTmCw626puN3Z253BAtjn8sD5j"
]
root@router2:/usr/local/bin #
```

The wallet address `D8S9uKQFvTmCw626puN3Z253BAtjn8sD5j` is your Dogecoin wallet address, which is automatically assigned by the Dogecoin daemon when we install it. By the way, you can also create your own Dogecoin address.

```console
root@router2:/usr/local/bin # dogecoin-cli getnewaddress
DLTQKTorf3oHL3F4hcjLJPugfTMA8nPeXn
root@router2:/usr/local/bin #
```

Now, our Dogecoin wallet has two addresses. You can choose whichever one you like. Both addresses can be used to store and transfer your Dogecoin assets. Please note: Once you've created a password and wallet address, back up the wallet.dat file in the `/usr/home/dogecoin/.dogecoin` folder.

If possible, save the wallet.dat file to your Google Drive to keep it safe and prevent it from being lost. It's important to remember that if you've created a password and wallet address, you should back up your wallet.dat file in your Google Drive.