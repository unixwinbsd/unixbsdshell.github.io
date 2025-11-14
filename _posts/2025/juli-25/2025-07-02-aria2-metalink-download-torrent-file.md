---
title: Using Aria2 Metalink on FreeBSD to download torrent files
date: "2025-07-02 12:10:41 +0100"
updated: "2025-10-01 14:45:03 +0100"
id: aria2-metalink-download-torrent-file
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: Anonymous
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/5_Aria2_Meatalink_Setup.jpg
toc: true
comments: true
published: true
excerpt: This article will explain how to configure Aria2 as a tool for downloading torrent files. In practice, we will run Aria2 via the HTTP/HTTPS protocol on ports 80 and 443. With an elegant Web GUI, Aria offers speed and stability in downloading torrent files
keywords: torrent, aria, aria2, metalink, download, apache, web server, freebsd, openbsd
---

Aria2 is a utility for downloading torrent files. Supported protocols are HTTP(S), FTP, SFTP, BitTorrent, and Metalink. The advantage of Aria2 is that it can download files from various protocols by utilizing the maximum download bandwidth of your internet network.

Another advantage of Aria2 is that it supports downloading files from various protocols such as HTTP(S)/FTP/SFTP and BitTorrent simultaneously, while data downloaded from HTTP(S)/FTP/SFTP is uploaded to the BitTorrent network. By using the Metalink chunk checksum, aria2 automatically validates data chunks when downloading files like BitTorrent.

This article will explain how to configure Aria2 as a tool for downloading torrent files. In practice, we will run Aria2 via the HTTP/HTTPS protocol on ports 80 and 443. With an elegant Web GUI, Aria offers speed and stability in downloading torrent files.

<br/>
<img alt="Aria2 Meatalink Setup" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/5_Aria2_Meatalink_Setup.jpg' | relative_url }}">
<br/>

## 1. Aria2 Installation
In the aria2 installation stage, the system used is FreeBSD 13.2 with the Lan Server IP 192.168.9.3. Because we will run Aria2 on the HTTP/HTTPS protocol, we need a Web Server such as Apache or NGINX that bridges Aria2 with a web browser so that Aria2 can run on ports 80 and 443.

Before we start installing aria2, we first install apache24, php mod and scgi mod. In this article we will not explain how to configure Apache24, you can read the previous article that discusses the installation and configuration of Apache24. Okay, let's start the installation.


```console
root@router2:~ # cd /usr/ports/sysutils/screen
root@router2:/usr/ports/sysutils/screen # make install clean

root@router2:~ # cd /usr/ports/lang/php82
root@router2:/usr/ports/lang/php82 # make install clean

root@router2:~ # cd /usr/ports/www/mod_php82
root@router2:/usr/ports/www/mod_php82 # make install clean

root@router2:~ # cd /usr/ports/www/mod_scgi
root@router2:/usr/ports/www/mod_scgi # make install clean

root@router2:~ # cd /usr/ports/security/ca_root_nss
root@router2:/usr/ports/security/ca_root_nss # make install clean
```
After we have successfully installed all the applications above, we continue by installing aria2.

```console
root@router2:~ # cd /usr/ports/www/aria2
root@router2:/usr/ports/www/aria2 # make install clean
```
Wait until the installation process is complete. After the installation process is complete, try opening the file `/usr/local/etc/rc.d/aria2`. If you look at the script, it says user and group script. At the end of the installation, aria2 does not create users and groups, unlike **apache24** which automatically creates www users and groups. We have to create users and groups for Aria2 manually, the script is as follows.

```console
root@router2:~ # pw useradd aria2 -s /sbin/nologin
```

## 2. Configure php and scgi mods
These php and scgi mods are needed for aria2 to connect to web browsers like Yandex or Google Chrome. We will configure both of these mods with apache24. Now you open the file `/usr/local/etc/apache24/httpd.conf`, place the following script at the very end or bottom of the `httpd.conf` file.

```console
Alias /webui-aria2/ "/usr/local/www/webui-aria2/docs/"
<Directory "/usr/local/www/webui-aria2/docs">
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

After that, create a file `/usr/local/etc/apache24/Includes/scgi.conf` for the scgi mod (authorization is required for security) and insert the script below.

```console
root@router2:~ # touch /usr/local/etc/apache24/Includes/scgi.conf
root@router2:~ # ee /usr/local/etc/apache24/Includes/scgi.conf
<IfModule mod_scgi.c>
SCGIMount /RPC2 192.168.9.3:6800
SCGIServerTimeout 60

 <Location /RPC2>
 Allow from all
 SetHandler scgi-handler
 SCGIServer serv0:6800
 SCGIHandler On
 Options -Multiviews
 </Location>

</IfModule>
```
<br/>
## 3. Aria2 Configuration
The next step is to configure aria2. In order for aria2 to run automatically when the computer is turned on, create the following script in the `rc.conf` file.

```console
root@router2:~ # ee /etc/rc.conf
aria2_enable="YES"
aria2_config="/usr/local/etc/aria2/aria2.conf"
aria2_user="aria2"
aria2_group="aria2"
```

Create a folder to put the downloaded files and the `aria2.conf` configuration file.

```console
root@router2:~ # mkdir -p /usr/local/etc/aria2/downloads
root@router2:~ # mkdir -p /usr/local/etc/aria2/sessions
```
Because at the end of the aria2 installation, the configuration file, namely the `aria2.conf` file, is not included, so we create the `aria2.conf` file in the `/usr/local/etc/aria2` folder.

```console
root@router2:~ # touch /usr/local/etc/aria2/aria2.conf
root@router2:~ # touch /usr/local/etc/aria2/aria2.log
root@router2:~ # chown -R aria2:aria2 /usr/local/etc/aria2/
```
The above chown script will provision the users and groups in the `"/usr/local/etc/aria2"` folder along with the files in that folder. Now we edit the `aria2.conf` file and insert the following script in the `aria2.conf` file.

```console
root@router2:~ # ee /usr/local/etc/aria2/aria2.conf
dir=/usr/local/etc/aria2/downloads
file-allocation=trunc
continue=true
daemon=true
## Logs
log=/usr/local/etc/aria2/aria2.log
console-log-level=warn
log-level=notice
## Some Limits
max-concurrent-downloads=5
max-connection-per-server=5
min-split-size=20M
split=4
disable-ipv6=true
##
#input-file=/home/user/.aria2/aria2.session
#save-session=/home/user/.aria2/aria2.session
#save-session-interval=30
## RPC
enable-rpc=true
rpc-allow-origin-all=true
rpc-listen-all=true
# Port for JSON RPC
rpc-listen-port=6800
rpc-secret=rVD+dqH5Zcf2tPXH8pWPpz/IctF1OMSt/O+2dCyxMV0=
# Your Certificate file
#rpc-certificate=/usr/local/etc/aria2/aria2.pfx
ca-certificate=/etc/ssl/cert.pem
# Enable encryption
#rpc-secure=true
## Torrents Settings
follow-torrent=mem
follow-metalink=mem
enable-dht6=false
peer-id-prefix=-TR2770-
user-agent=Transmission/2.77
seed-time=0
#seed-ratio=1.0
bt-seed-unverified=true
bt-save-metadata=true
bt-force-encryption=true
# Torrent TCP port
listen-port=6801
# Torrent UDP port
dht-listen-port=6801
```
Next we will create a token that we will use to configure the aria2 Web GUI, because if this token is not created, aria2 will not connect to the Web GUI.

```console
root@router2:~ # openssl rand -base64 32
rVD+dqH5Zcf2tPXH8pWPpz/IctF1OMSt/O+2dCyxMV0=
root@router2:~ #
```

To make it easier for you, save the token in Notepad. You enter the token `"rVD+dqH5Zcf2tPXH8pWPpz/IctF1OMSt/O+2dCyxMV0="` into the `aria2.conf` file above, namely in the script `rpc-secret=rVD+dqH5Zcf2tPXH8pWPpz/IctF1OMSt/O+2dCyxMV0=`

## 4. Aria2 Web Based Control Panel Configuration
This control panel will appear in the Web Browser, with this control panel we can add to delete torrent files and others. To configure the control panel, you can download the file on Github.

```console
root@router2:~ # cd /usr/local/www
root@router2:~ # git clone https://github.com/ziahamza/webui-aria2.git
root@router2:~ # chown -R www:www /usr/local/www/webui-aria2
root@router2:~ # chmod -R 777 /usr/local/www/webui-aria2
```
Once everything is configured, the next step is to `restart/reboot` your computer.

```console
root@router2:~ # reboot
```
After the computer is back to normal, before we test, you first restart aria2.

```console
root@router2:~ # service aria2 restart
root@router2:~ # service apache24 restart
```
After that we TEST by downloading the torrent file, open Yandex Web Browser or Google Chrome, type `"http://192.168.9.3/webui-aria2/"`. If the configuration above is not complete, a display like the following image will appear.

<br/>
<img alt="Test Aria2 Metalink" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/6_Test_Aria2_Metalink.jpg' | relative_url }}">
<br/>


The image above is the aria2 Web GUI display. We continue by setting up the Web GUI, click the Settings menu then click the Connection Settings menu, you set it as shown in the following image.

<br/>
<img alt="aria2 metalink connection" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/7_aria2_metalink_connection.jpg' | relative_url }}">
<br/>

Enter host is the IP of FreeBSD Lan Server, enter port is the rpc port and enter secret is the token that we have created earlier for the `aria2.conf` file then click Save Connection configuration. Now your aria2 server is **RUNNING**, you can download torrent files as you wish. The downloaded files will later be saved in the `/usr/local/etc/aria2/downloads` folder.