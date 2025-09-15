---
title: Installing rtorrent and ruTorrent with FreeBSD and Apache Web Server
date: "2025-05-02 16:10:35 +0100"
id: rtorrent-ruTorrent-with-freebsd-and-apache
lang: en
layout: single
author_profile: true
categories:
  - FreeBSD
tags: "WebServer"
excerpt: In the Torrent application environment, Rtorrent is the most stable and efficient. One of the main advantages of Rtorrent is its very flexible configuration and automation capabilities
keywords: rtorrent, ruTorrent, freebsd, apache, php, php-fpm, fpm, web server, server, download, web browser
---

Rtorrent is a BitTorrents client program written in C++ for unix and uses the ncurses library to provide a textual user interface. Rtorrent can be used in a terminal session (SSH) together with a terminal multiplexer such as tmux, which provides a very efficient bittorrent solution. Using the XMLRPC remote control API, an alternative user interface can be provided by a web client such as ruTorrent, or a command line client such as pyrocore and its rtcontrol command.

In the Torrent application environment, Rtorrent is the most stable and efficient. One of the main advantages of Rtorrent is its very flexible configuration and automation capabilities. In addition, Rtorrent also has several features that are not inferior to the uTorrent and bitTorrent clients.

The main features of rtorrent and ruTorrent are:
- Use URL or file path to add torrents at runtime.
- Stop/remove/resume torrents.
- Optionally auto-load/save/remove torrents in session directory.
- Secure fast resume support.
- Peer download speed is calculated from incoming HAVE messages.
- Download Results Report.

## 1. Rtorrent Installation Process

In this article we will learn the installation technique, configuration and application of Rtorrent in a web browser to download torrent files. To run Rtorrent, we must install the application and its supporting repositories, such as apache24, php, php mod and scgi mod.

Okay, now we start installing Rtorent from the FreeBSD port. The system used in writing this article uses FreeBSD 13 which is used to run Rtorrent. IP LAN server 192.168.9.3.

```
root@router2:~ # cd /usr/ports/net-p2p/rtorrent
root@router2:/usr/ports/net-p2p/rtorrent # make install clean

root@router2:~ # cd /usr/ports/sysutils/screen
root@router2:/usr/ports/sysutils/screen # make install clean
```
After Torrent is successfully installed on the FreeBSD 13 system, we continue by installing the php mod and scgi mod.

```
root@router2:~ # cd /usr/ports/lang/php82
root@router2:/usr/ports/lang/php82 # make install clean
root@router2:~ # cd /usr/ports/www/mod_php82
root@router2:/usr/ports/www/mod_php82 # make install clean
root@router2:~ # cd /usr/ports/www/mod_scgi
root@router2:/usr/ports/www/mod_scgi # make install clean
```


## 2. Create User and Directory rtorrent

After installing all the required packages, we will create a user that will run rtorrent. In creating a user there are no standard rules, to make the configuration easier we simply create a user with the name "rtorrent".

```
root@router2:~ # pw useradd rtorrent -s /sbin/nologin
```

Then create a directory or folder to place the Rtorrent file.

```
root@router2:~ # mkdir -p /usr/local/etc/rtorrent/downloads
root@router2:~ # mkdir -p /usr/local/etc/rtorrent/sessions
root@router2:~ # chown -R rtorrent:rtorrent /usr/local/etc/rtorrent/
```

The chown script above is used to assign the username and group "rtorrent" to the /usr/local/etc/rtorrent folder and the files and folders inside. Meanwhile, the download folder is used to store downloaded files.

## 3. Create Start Up Script rc.d

Usually other applications always create rc.d script at the end of installation, rtorrent at the end of installation does not create rc.d script, we must create rc.d script to run rtorrent as daemon. To create it, open the /local/etc/rc.d folder and create rtorrent.sh file.

```
root@router2:~ # ee /usr/local/etc/rc.d/rtorrent.sh

#!/bin/sh
##
# PROVIDE: rtorrent
# REQUIRE: LOGIN
# KEYWORD: shutdown
. /etc/rc.subr

name="rtorrent"
rcvar=`set_rcvar`

load_rc_config $name

: ${rtorrent_enable="NO"}
: ${rtorrent_downloads="/usr/local/etc/rtorrent/downloads"}
: ${rtorrent_sessions="/usr/local/etc/rtorrent/sessions"}
: ${rtorrent_scgi_port=""}
: ${rtorrent_encoding_list="UTF-8;cp1251;koi8-r"}
: ${rtorrent_args=""}
: ${rtorrent_user="rtorrent"}
: ${rtorrent_autoload_dir=""}

command="/usr/local/bin/rtorrent"
screen="/usr/local/bin/screen"

rtorrent_args="-d ${rtorrent_downloads} -s ${rtorrent_sessions} ${rtorrent_args}"

[ -n "${rtorrent_autoload_dir}" ] && rtorrent_args="-O schedule='watch_directory,5,5,load_start=${rtorrent_autoload_dir}' ${rtorrent_args}"
[ -n "${rtorrent_scgi_port}" ] && rtorrent_args="-O scgi_port='${rtorrent_scgi_port}' ${rtorrent_args}"
[ -n "${rtorrent_encoding_list}" ] && rtorrent_args="-O encoding_list='${rtorrent_encoding_list}' ${rtorrent_args}"

start_cmd="echo Starting ${name}.; su -m ${rtorrent_user} -c \"${screen} -A -m -d -S rtorrent ${command} ${rtorrent_args}\""

run_rc_command "$1"
```

Give permission to the rtorrent.sh file.

```
root@router2:~ # chmod +x /usr/local/etc/rc.d/rtorrent.sh
```
To have the script in the rtorrent.sh file run automatically when your FreeBSD computer is restarted/rebooted, add the following script to the rc.conf file.

```
root@router2:~ # ee /etc/rc.conf
rtorrent_enable="YES"
rtorrent_scgi_port="192.168.9.3:5000"
rtorrent_user="rtorrent"
```

## 4. Configuring the httpd.conf File (Apache24)

In this article we will not discuss the installation of apache24, we will assume that our FreeBSD server has apache24 installed. Because Rtorrent runs on a web browser, a web server application is needed so that Rtorrent can run properly on web browsers such as Yandex, Firefox and others. Open the /usr/local/etc/apache24/httpd.conf file and insert the following script at the end of the httpd.conf file.


```
Alias /rutorrent/ "/usr/local/www/ruTorrent/"
<Directory "/usr/local/www/ruTorrent/">
 AllowOverride None
    Options None
    Require all granted
</Directory>

<FilesMatch "\.php$">
    SetHandler application/x-httpd-php
</FilesMatch>
<FilesMatch "\.phps$">
    SetHandler application/x-httpd-php-source
</FilesMatch>

AddType application/x-compress .Z
AddType application/x-gzip .gz .tgz

AddType application/x-httpd-php .php
AddType application/x-httpd-php .php .phtml .php3
AddType application/x-httpd-php-source .phps

LoadModule scgi_module libexec/apache24/mod_scgi.so
```

The next step is to create a configuration file for the SCGI mod (authorization is required for security) in the /usr/local/etc/apache24/Includes/scgi.conf folder and insert the following script:

```
root@router2:~ # ee  /usr/local/etc/apache24/Includes/scgi.conf
<IfModule mod_scgi.c>
SCGIMount /RPC2 192.168.9.3:5000
SCGIServerTimeout 60

 <Location /RPC2>
 Allow from all
 ###########Enable only authorized users
 #AuthName "Enter password for torrent"
 #AuthType Basic
 #AuthUserFile /usr/local/www/rutorrent/.htpasswd
 #require valid-user
 SetHandler scgi-handler
 SCGIServer serv0:5000
 SCGIHandler On
 Options -Multiviews
 </Location>

</IfModule>
```

## 5. Installation Process of rtorrent Web Based Control Panel

To install the Web Based Control Panel, we can download it on GitHub.

```
root@router2:~ # cd /usr/local/www
root@router2:/usr/local/www # git clone https://github.com/Novik/ruTorrent.git
```

Give ownership to the /usr/local/www/ruTorrent file and create a log file.

```
root@router2:~ # touch /var/log/rutorrent-errors.log
root@router2:~ # chown -R www:www /usr/local/www/ruTorrent/
root@router2:~ # chown -R www:www /var/log/rutorrent-errors.log
```

Edit the file /usr/local/www/ruTorrent/conf/config.php.


```
$log_file = '/var/log/rutorrent-errors.log';
$scgi_port = 5000;
$scgi_host = "192.168.9.3";
$router2 = array(			
		"192.168.9.3",
		"router2",
);
```

The next step is to copy the file /usr/local/share/examples/rtorrent/rtorrent.rc to /usr/local/etc/rtorrent.

```
root@router2:~ # cp /usr/local/share/examples/rtorrent/rtorrent.rc /usr/local/etc/rtorrent
```

Edit the /usr/local/etc/rtorrent/rtorrent.rc file by following the script below.


```
#############################################################################
# This is an (old) example resource file for rTorrent.
# Copy to ~/.rtorrent.rc and enable/modify the options as needed.
# Remember to uncomment the options you wish to enable.
#
# See 'rtorrent.rc-example' for a newer, basic configuration.
#
#   Sample: https://github.com/rakshasa/rtorrent/wiki/CONFIG-Template
# Complete: https://rtorrent-docs.readthedocs.io/en/latest/cmd-ref.html
#   Useful: https://rtorrent-docs.readthedocs.io/en/latest/use-cases.html
#   Manual: https://rtorrent-docs.readthedocs.io/en/latest/
#  Convert: https://github.com/rakshasa/rtorrent/wiki/rTorrent-0.9-Comprehensive-Command-list-(WIP)
# Handbook: https://media.readthedocs.org/pdf/rtorrent-docs/latest/rtorrent-docs.pdf
#     File: https://github.com/rakshasa/rtorrent/blob/master/doc/rtorrent.rc
#############################################################################

# Maximum and minimum number of peers to connect to per torrent.
#
#throttle.min_peers.normal.set = 40
#throttle.max_peers.normal.set = 100

# Same as above but for seeding completed torrents.
# "-1" = same as downloading.
#
throttle.min_peers.seed.set = 10
throttle.max_peers.seed.set = 50

# Maximum number of simultaneous uploads per torrent.
#
throttle.max_uploads.set = 15

# Global upload and download rate in KiB.
# "0" for unlimited.
#
#throttle.global_down.max_rate.set_kb = 0
#throttle.global_up.max_rate.set_kb = 0

# Default directory to save the downloaded torrents.
#
directory.default.set = /usr/local/etc/rtorrent/downloads

# Default session directory. Make sure you don't run multiple instance
# of rTorrent using the same session directory. Perhaps using a
# relative path?
#
session.path.set = /usr/local/etc/rtorrent/sessions

# Watch a directory for new torrents, and stop those that have been
# deleted.
#
#schedule2 = watch_directory,5,5,load.start=./watch/*.torrent

# Close torrents when disk-space is low.
#
#schedule2 = low_diskspace,5,60,close_low_diskspace=100M

# The IP address reported to the tracker.
#
network.local_address.set = 192.168.9.3
#network.local_address.set = rakshasa.no

# The IP address the listening socket and outgoing connections is
# bound to.
#
#network.bind_address.set = 127.0.0.1
#network.bind_address.set = rakshasa.no

# Port range to use for listening.
#
#network.port_range.set = 6890-6999

# Start opening ports at a random position within the port range.
#
#network.port_random.set = no

# Check hash for finished torrents. Might be useful until the bug is
# fixed that causes lack of disk-space not to be properly reported.
#
#pieces.hash.on_completion.set = no

# Set whether the client should try to connect to UDP trackers.
#
#trackers.use_udp.set = yes

# Alternative calls to bind and IP that should handle dynamic IP's.
#
#schedule2 = ip_tick,0,1800,ip=rakshasa
#schedule2 = bind_tick,0,1800,bind=rakshasa

# Encryption options, set to none (default) or any combination of the following:
# allow_incoming, try_outgoing, require, require_RC4, enable_retry, prefer_plaintext
#
# The example value allows incoming encrypted connections, starts unencrypted
# outgoing connections but retries with encryption if they fail, preferring
# plain-text to RC4 encryption after the encrypted handshake.
#
# protocol.encryption.set = allow_incoming,enable_retry,prefer_plaintext

# Enable DHT support for trackerless torrents or when all trackers are down.
# May be set to "disable" (completely disable DHT), "off" (do not start DHT),
# "auto" (start and stop DHT as needed), or "on" (start DHT immediately).
# The default is "off". For DHT to work, a session directory must be defined.
#
dht.mode.set = auto

# UDP port to use for DHT.
#
#dht.port.set = 6881

# Enable peer exchange (for torrents not marked private).
#
#protocol.pex.set = yes

# Set download list layout style ("full", "compact").
#
#ui.torrent_list.layout.set = "full"

# Run rTorrent as a daemon, controlled via XMLRPC.
#
#system.daemon.set = false

# SCGI Connectivity (for alternative rtorrent interfaces, XMLRPC)
# Use a IP socket with scgi_port, or a Unix socket with scgi_local.
# schedule can be used to set permissions on the unix socket.
#
network.scgi.open_port = "192.168.9.3:5000"
#network.scgi.open_local = (cat,(session.path),/rpc.sock)
#schedule2 = socket_chmod, 0, 0, "execute.nothrow=chmod,770,(cat,(session.path),/rpc.sock)"
```


Once everything is done, reboot the FreeBSD computer.

```
root@router2:~ # reboot
```


## 6. Downloading Files with rtorrent

After the FreeBSD computer returns to normal, before we do the test by downloading torrent files, we first restart apache24 and rtorrent.

```
root@router2:~ # service rtorrent.sh restart
root@router2:~ # service apache24 restart
```

Now let's do a trial by downloading a torrent file, make sure you have a torrent file, if you don't have a torrent file, please download it from https://rutracker.org/. In this study, I have 2 torrent files, namely Windows 7 SP1 52in1 (x86 x64) + - Office 2019 by Eagle123 (04.2023) [Ru En] [rutracker-6356940].torrent and WinRAR 6.22 x86 x64 RePack (& ​​​​Portable) by TryRooM [05.2023, Multi + RUS] [rutracker-6370744].torrent.

To download both of these files, open the Google Chrome web browser and on the address bar menu type "http://192.168.9.3/rutorrent/".

Downloading torrent files with rtorrent with apache24 Web Server provides excellent speed and stability, after seeing the download results above, you can try it and make rtorrent your main choice for downloading files with torrent extension.
