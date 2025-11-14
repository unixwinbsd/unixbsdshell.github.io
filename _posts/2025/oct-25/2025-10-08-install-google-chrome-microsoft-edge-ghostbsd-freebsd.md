---
title: How to Install Google Chrome and Microsoft Edge on GhostBSD FreeBSD Desktop
date: "2025-10-08 08:09:33 +0100"
updated: "2025-10-08 08:09:33 +0100"
id: install-google-chrome-microsoft-edge-ghostbsd-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: /img/oct-25/oct-25-58.jpg
toc: true
comments: true
published: true
excerpt: In this article we will learn how to install and configure the Google Chrome and Microsoft Edge web browsers. Because these two programs can only be run on Linux, it is recommended that you read the previous article about installing Linux Binary on FreeBSD. If you haven't read this article, don't continue reading it. The entire contents of this article run with FreeBSD Desktop GhostBSD 23.06.01 A simple, elegant desktop BSD Operating System.
keywords: freebsd, tutorials, google, chrome, microsoft, edge, ghostbsd, desktop, embed
---

By default the FreeBSD system does not include the Google Chrome and Microsoft Edge repositories in system ports or pkg packages. Both programs can be run on FreeBSD with the help of Linux Binary.

In this article we will learn how to install and configure the Google Chrome and Microsoft Edge web browsers. Because these two programs can only be run on Linux, it is recommended that you read the previous article about installing Linux Binary on FreeBSD. If you haven't read this article, don't continue reading it. The entire contents of this article run with FreeBSD Desktop GhostBSD 23.06.01 "A simple, elegant desktop BSD Operating System".



## 1. Ubuntu Configuration

By default, GhostBSD has Binary Linux and Ubuntu programs installed, so just adjust a few scripts so that Google Chrome and Microsoft Edge can run on GhostBSD. The first step that must be taken is to replace the script file `/usr/local/etc/rc.d/ubuntu`.


```
root@ns3:~ # cd /usr/local/etc/rc.d
root@ns3:/usr/local/etc/rc.d # cp ubuntu ubuntu.back
root@ns3:/usr/local/etc/rc.d # rm -f ubuntu
```

The script above is to backup ubuntu files with ubuntu.back and delete ubuntu files. After you delete the default Ubuntu file from GhostBSD, create a new Ubuntu file and enter the script below.


```
root@ns3:/usr/local/etc/rc.d # touch ubuntu
root@ns3:/usr/local/etc/rc.d # ee ubuntu

#!/bin/sh
#
# PROVIDE: ubuntu
# REQUIRE: archdep mountlate
# KEYWORD: nojail
#
# This is a modified version of /etc/rc.d/linux from FreeBSD 12.2-RELEASE
#
. /etc/rc.subr

name="ubuntu"
desc="Enable Ubuntu chroot, and Linux ABI"
rcvar="ubuntu_enable"
start_cmd="${name}_start"
stop_cmd=":"

unmounted()
{
	[ `stat -f "%d" "$1"` == `stat -f "%d" "$1/.."` -a \
	  `stat -f "%i" "$1"` != `stat -f "%i" "$1/.."` ]
}

ubuntu_start()
{
	local _emul_path _tmpdir

	load_kld -e 'linux(aout|elf)' linux
	case `sysctl -n hw.machine_arch` in
	amd64)
		load_kld -e 'linux64elf' linux64
		;;
	esac
	if [ -x @CHROOT_PATH@/sbin/ldconfigDisabled ]; then
		_tmpdir=`mktemp -d -t linux-ldconfig`
		@CHROOT_PATH@/sbin/ldconfig -C ${_tmpdir}/ld.so.cache
		if ! cmp -s ${_tmpdir}/ld.so.cache @CHROOT_PATH@/etc/ld.so.cache; then
			cat ${_tmpdir}/ld.so.cache > @CHROOT_PATH@/etc/ld.so.cache
		fi
		rm -rf ${_tmpdir}
	fi

	# Linux uses the pre-pts(4) tty naming scheme.
	load_kld pty

	# Handle unbranded ELF executables by defaulting to ELFOSABI_LINUX.
	if [ `sysctl -ni kern.elf64.fallback_brand` -eq "-1" ]; then
		sysctl kern.elf64.fallback_brand=3 > /dev/null
	fi

	if [ `sysctl -ni kern.elf32.fallback_brand` -eq "-1" ]; then
		sysctl kern.elf32.fallback_brand=3 > /dev/null
	fi
	sysctl compat.linux.emul_path=/compat/ubuntu

	_emul_path="/compat/ubuntu"
	unmounted "${_emul_path}/proc" && (mount -t linprocfs linprocfs "${_emul_path}/proc" || exit 1)
	unmounted "${_emul_path}/sys" && (mount -t linsysfs linsysfs "${_emul_path}/sys" || exit 1)
	unmounted "${_emul_path}/dev" && (mount -t devfs devfs "${_emul_path}/dev" || exit 1)
	unmounted "${_emul_path}/dev/fd" && (mount -o linrdlnk -t fdescfs fdescfs "${_emul_path}/dev/fd" || exit 1)
	unmounted "${_emul_path}/dev/shm" && (mount -o mode=1777 -t tmpfs tmpfs "${_emul_path}/dev/shm" || exit 1)
	unmounted "${_emul_path}/tmp" && (mount -t nullfs /tmp "${_emul_path}/tmp" || exit 1)
	unmounted /dev/fd && (mount -t fdescfs null /dev/fd || exit 1)
	unmounted /proc && (mount -t procfs procfs /proc || exit 1)
	true
}

load_rc_config $name
run_rc_command "$1"
```


After that create a directory for ubuntu.

```
root@ns3:~ # mkdir -p /compat/ubuntu/dev/fd && mkdir /compat/ubuntu/dev/shm && mkdir /compat/ubuntu/proc && mkdir /compat/ubuntu/sys && mkdir /compat/ubuntu/home && mkdir /compat/ubuntu/tmp
```

Then install the file system in the directory created above.

```
root@ns3:~ # mount -t linprocfs linprocfs /compat/ubuntu/proc
root@ns3:~ # mount -t linsysfs linsysfs /compat/ubuntu/sys
root@ns3:~ # mount -t devfs devfs /compat/ubuntu/dev
root@ns3:~ # mount -o linrdlnk -t fdescfs fdescfs /compat/ubuntu/dev/fd
root@ns3:~ # mount -o mode=1777 -t tmpfs tmpfs /compat/ubuntu/dev/shm
root@ns3:~ # mount -t nullfs /home /compat/ubuntu/home
root@ns3:~ # mount -t nullfs /tmp /compat/ubuntu/tmp
```

Continue by installing debootstrap linux-steam-utils.

```
root@ns3:~ # pkg install debootstrap linux-steam-utils
```

After that, you can proceed to install and configure an Ubuntu-based Linux environment (bionic or focal version).

```
root@ns3:~ # debootstrap --arch=amd64 --no-check-gpg focal /compat/ubuntu
root@ns3:~ # printf 'deb http://archive.ubuntu.com/ubuntu/ focal multiverse main universe restricted\n' > /compat/ubuntu/etc/apt/sources.list
root@ns3:~ # printf 'deb http://archive.ubuntu.com/ubuntu/ focal-updates main restricted universe multiverse\n' >> /compat/ubuntu/etc/apt/sources.list
root@ns3:~ # printf 'deb http://archive.ubuntu.com/ubuntu/ focal-security main restricted universe multiverse\n' >> /compat/ubuntu/etc/apt/sources.list
root@ns3:~ # printf '0.0 0 0.0\n0\nUTC\n' > /compat/ubuntu/etc/adjtime
```

After that, continue with the script below to make corrections to the Ubuntu repository.

```
root@ns3:~ # cd /compat/ubuntu/lib64/
root@ns3:/compat/ubuntu/lib64 # rm ./ld-linux-x86-64.so.2
root@ns3:/compat/ubuntu/lib64 # ln -s ../lib/x86_64-linux-gnu/ld-2.31.so ld-linux-x86-64.so.2
```

Create an rc.d startup file in the `/etc/rc.conf` file, so that the Ubuntu daemon can run automatically when the computer is turned off or restarted.
 
```
root@ns3:~ # sysrc ubuntu_enable=YES
 ```
 
Give file permissions to the /usr/local/etc/rc.d/ubuntu file and restart Ubuntu.

```
root@ns3:~ # chmod +x /usr/local/etc/rc.d/ubuntu
```

```
root@ns3:~ # service ubuntu restart
compat.linux.emul_path: /compat/ubuntu -> /compat/ubuntu
```

The next step is to update and upgrade and install several Ubuntu programs.

```
root@ns3:/compat/ubuntu/lib64 # chroot /compat/ubuntu /bin/bash
root@ns3:/# dpkg-reconfigure locales
root@ns3:/# dpkg-reconfigure tzdata
Current default time zone: 'Asia/Jakarta'
Local time is now:      Sat Aug 19 13:30:37 WIB 2023.
Universal Time is now:  Sat Aug 19 06:30:37 UTC 2023.
root@ns3:/# apt update
root@ns3:/# apt upgrade
root@ns3:/# apt install -y pulseaudio
root@ns3:/# apt install -y fonts-symbola
root@ns3:/# apt install -y gnupg
root@ns3:/# exit
```

For sound to work in applications installed in the Ubuntu environment, you must use the pulseaudio server. Create the following script in the file /compat/ubuntu/usr/local/bin/pulseaudio.

```
root@ns3:~ # ee /compat/ubuntu/usr/local/bin/pulseaudio
#!/bin/sh

get_pa_sock_path()
{
    PA_SOCK_PATH=$(sockstat | awk -v me=$(whoami) -F'[ \t]+' '
        $1 == me && $2 == "pulseaudio" && $6 ~ /native/ {
            print $6;
            exit 0
        }'
    )
}

get_pa_sock_path
if [ ! -S "$PA_SOCK_PATH" ]; then
    while killall pulseaudio; do
        sleep 0.5
    done
    pulseaudio --start
    get_pa_sock_path
fi
[ -S "$PA_SOCK_PATH" ] && export PULSE_SERVER=unix:$PA_SOCK_PATH

START_SCRIPT=$1
shift
$START_SCRIPT $*

root@ns3:~ # chmod +x /compat/ubuntu/usr/local/bin/pulseaudio
```

At this point, the Ubuntu installation on FreeBSD is complete. Now you can install various Ubuntu applications on FreeBSD.


## 2. Google Chrome Installation and Configuration

The first step to installing Google Chrome is to download the program. Follow the instructions below to download Google Chrome.

```
root@ns3:~ # printf "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /compat/ubuntu/etc/apt/sources.list.d/google-chrome.list
root@ns3:~ # fetch -o /tmp/ https://dl.google.com/linux/linux_signing_key.pub
/tmp/linux_signing_key.pub                              14 kB 3016 kBps    00s
```

After that, install the file in the Ubuntu environment.

```
root@ns3:/# chroot /compat/ubuntu /bin/bash
root@ns3:/# apt-key add /tmp//linux_signing_key.pub
OK
root@ns3:/# apt update
root@ns3:/# apt install -y google-chrome-stable
root@ns3:/# exit
```

After that, create a script in the file /usr/local/share/applications/linux-chrome.desktop.

```
root@ns3:~ # ee /usr/local/share/applications/linux-chrome.desktop

[Desktop Entry]
Type=Application
Version=1.0
Encoding=UTF-8
Name=Google Chrome
Comment=unixwinbsd.blogspot.com
Icon=/compat/ubuntu/opt/google/chrome/product_logo_16.png
Exec=/usr/local/bin/linux-chrome
Categories=Application;Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;
StartupNotify=true
```

Create another script in the /usr/local/bin/linux-chrome file.

```
root@ns3:~ # ee /usr/local/bin/linux-chrome

#!/bin/sh

chroot_path=/compat/ubuntu

get_pa_sock_path()
{
        PA_SOCK_PATH=$(sockstat | awk -v me=$(whoami) -F'[ \t]+' '
                $1 == me && $2 == "pulseaudio" && $6 ~ /native/ {
                        print $6;
                        exit 0
                }'
        )
}

get_pa_sock_path
if [ ! -S "$PA_SOCK_PATH" ]; then
        while killall pulseaudio; do
                sleep 0.5
        done
        pulseaudio --start
        get_pa_sock_path
fi
[ -S "$PA_SOCK_PATH" ] && export PULSE_SERVER=unix:$PA_SOCK_PATH
${chroot_path}/bin/chrome
```

Create file permissions on the file.

```
root@ns3:~ # chmod +x /usr/local/share/applications/linux-chrome.desktop
root@ns3:~ # chmod +x /usr/local/bin/linux-chrome
```

Finally, finished installing Google Chrome on GhostBSD. To run Google Chrome, you just click on the application menu on the GhostBSD desktop.


## 3. Microsoft Edge Installation and Configuration

Edge web browser is a program made by Microsoft, Inc. This program was created to replace Internet Explorer, which has long accompanied Microsoft Windows 95 and Windows XP. Similar to the Google Chrome program, Microsoft Edge can only be installed on Linux-based systems.

For FreeBSD lovers, don't worry, with the help of Linux binary this program can run normally and smoothly. The following is how to install Microsoft Edge on GhostBSD.

```
root@ns3:~ # chroot /compat/ubuntu /bin/bash
root@ns3:/# apt install -y apt-transport-https curl pgp
root@ns3:/# apt install software-properties-common apt-transport-https wget
root@ns3:/# wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -
OK
root@ns3:/# add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main"
root@ns3:/# apt update
root@ns3:/# apt install microsoft-edge-stable
root@ns3:/# exit
```

After that, enter the following script in the file /usr/local/share/applications/linux-edge.desktop.

```
root@ns3:~ # ee /usr/local/share/applications/linux-edge.desktop
[Desktop Entry]
Type=Application
Version=1.0
Encoding=UTF-8
Name=Microsoft Edge
Comment=unixwinbsd.blogspot.com
Icon=/compat/ubuntu/opt/microsoft/msedge/product_logo_128.png
Exec=/usr/local/bin/linux-edge
Categories=Application;Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;
StartupNotify=true
```

Then create a file `/usr/local/bin/linux-edge`, and enter the script below.

```
root@ns3:~ # ee /usr/local/bin/linux-edge
#!/bin/sh

chroot_path=/compat/ubuntu

get_pa_sock_path()
{
	PA_SOCK_PATH=$(sockstat | awk -v me=$(whoami) -F'[ \t]+' '
		$1 == me && $2 == "pulseaudio" && $6 ~ /native/ {
			print $6;
			exit 0
		}'
	)
}

get_pa_sock_path
if [ ! -S "$PA_SOCK_PATH" ]; then
	while killall pulseaudio; do
		sleep 0.5
	done
	pulseaudio --start
	get_pa_sock_path
fi
[ -S "$PA_SOCK_PATH" ] && export PULSE_SERVER=unix:$PA_SOCK_PATH
${chroot_path}/opt/microsoft/msedge/msedge
```

The final step is to `restart/reboot` your computer.

```
root@ns3:~ # reboot
```

Run Microsoft Edge, until the image like the one below appears.

![oct-25-58](/img/oct-25/oct-25-58.jpg)



If it appears like the image above, it means Microsoft Edge is running. If the image above does not appear, replace the **`/usr/local/bin/linux-edge`** script with the script below.


```
root@ns3:~ # ee /usr/local/bin/linux-edge
#!/compat/ubuntu/bin/bash

export START_PATH="/opt/microsoft/msedge/msedge"
export CHROME_WRAPPER="`readlink -f "$0"`"
export LD_LIBRARY_PATH=/usr/local/steam-utils/lib64/fakeudev
export LD_PRELOAD=/usr/local/steam-utils/lib64/webfix/webfix.so
export LIBGL_DRI3_DISABLE=1

exec -a "$0" "$START_PATH" --no-sandbox --no-zygote --test-type --v=0 "$@"
```

The installation and configuration of Microsoft Edge is complete. Now your FreeBSD server can run Ubuntu programs, namely Microsoft Edge and Google Chrome. So for those of you who love FreeBSD, don't be discouraged, one of the advantages of FreeBSD is that it can run Ubuntu applications with the help of Linux Binaries.