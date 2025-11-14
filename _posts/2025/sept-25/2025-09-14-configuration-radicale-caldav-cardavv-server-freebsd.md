---
title: How to Configure FreeBSD with Radicale CalDAV CardDAV Server
date: "2025-09-14 07:35:11 +0100"
updated: "2025-09-14 07:35:11 +0100"
id: configuration-radicale-caldav-cardavv-server-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/14_FreeBSD_Radicale_Cover.jpg
toc: true
comments: true
published: true
excerpt: Radicale is run with the help of the Apache or NGINX web server, so it can be operated either as a standalone package using its internal http/https server or can be integrated with existing web servers such as Nextcloud or Owncloud
keywords: caldav, cardavv, server, freebsd, email, calendar, contact
---

Radicale is a calendar and contact server designed to support the CalDav and CardDav protocols. Radicale's configuration is very simple and easy to install, as it does not have a graphical administration interface. This application is written in Python, so it can be used on operating systems such as Linux, BSD, macOS, and Windows.

As a free, open source, simple and powerful CalDAV and CardDAV server, Radicale is a complete solution for storing calendars and contacts on websites. With Radicale you share calendars and contact lists via CalDAV, CardDAV via http or https.

In use, Radicale has very high security features, namely through TLS connection and authentication. Additionally, it works with many CalDAV and CardDAV clients such as gnome calendar, Mozilla thunderbird, DAVx (for android), evolution, etc.

Radicale is run with the help of the Apache or NGINX web server, so it can be operated either as a standalone package using its internal http/https server or can be integrated with existing web servers such as Nextcloud or Owncloud.

<br/>
<img alt="freebsd radicale cardav" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/14_FreeBSD_Radicale_Cover.jpg' | relative_url }}">
<br/>

Radicale can be used for your various activities such as:

1. Supports events, tasks, journal entries and business cards.
2. Can be run directly, does not require complicated settings or configuration.
3. Can be used by multiple users with authentication.
4. Have file encryption with TLS.
5. Works with multiple CalDAV and CardDAV clients.
6. Stores all data on the file system in a simple folder structure.
7. Expandable with plugins.
8. As free software licensed under GPLv3.

In this article, we will guide you through how to install and configure Radicale on a FreeBSD server.


## 1. Installing Radicale CalDAV/CardDAV server

Before you install Radicale, we recommend installing several dependency packages for the Radicale installation. Because it is written in Python, Python dependencies are required to run Radicale. The following commands are the dependencies that you must install

```yml
root@ns3:~ # pkg install python39 py39-setuptools py39-bcrypt py39-passlib py39-vobject py39-dateutil py39-defusedxml
```

On FreeBSD servers, by default the Radicale package is available in the PKG and Port package repositories. We install Radicale with the FReeBSD ports system.

```yml
root@ns3:~ # cd /usr/ports/www/radicale
root@ns3:/usr/ports/www/radicale # make install clean
```

After the installation is complete, you have to run Radicale automatically, namely by adding some scripts to activate Radicale in `/etc/rc.conf`.

```yml
root@ns3:/usr/ports/www/radicale # ee /etc/rc.conf
radicale_enable="YES"
radicale_config="/usr/local/etc/radicale/config"
radicale_user="radicale"
radicale_group="radicale"
```

Run Redicale (Restart Radicale).

```yml
root@ns3:~ # service radicale restart
```

## 2. Radicale Configuration

After you have completed the first part, continue by editing the default radicale configuration available in `'/usr/local/etc/radicale`. The configuration file called Radicale is called `"config"`, open the file and change the script as in the example below.


```console
root@ns3:~ # cd /usr/local/etc/radicale
root@ns3:/usr/local/etc/radicale # ee config
[server]
hosts = localhost:5232
max_connections = 20
max_content_length = 100000000
timeout = 30

[encoding]
request = utf-8
stock = utf-8

[auth]
type = http_x_remote_user
htpasswd_filename = /usr/local/etc/radicale/users
htpasswd_encryption = md5
delay = 1
realm = Radicale - Password Required

[rights]
type = authenticated
file = /usr/local/etc/radicale/rights

[storage]
type = multifilesystem
filesystem_folder = /usr/local/share/radicale/collections
max_sync_token_age = 2592000

[web]
type = internal

[logging]
level = warning
mask_passwords = True

[headers]
Access-Control-Allow-Origin = *
```

In the above script [auth] we use `"type=htpasswd"` to manage users. All Radicale usernames will be stored in the `"users"` file, create a users file to hold all the usernames.

```yml
root@ns3:~ # touch /usr/local/etc/radicale/users
```

After that, you create a username that will access Radicale. Run the following command to add a new user to Radicale.

```yml
root@ns3:~ # htpasswd -B -c /usr/local/etc/radicale/users mary
```

If you want to add another username, htpasswd is used again but without any additional modifiers.

```yml
root@ns3:~ # htpasswd -B /usr/local/etc/radicale/users charles
root@ns3:~ # htpasswd -B /usr/local/etc/radicale/users john
```

Continue by granting ownership rights to a file or directory.

```yml
root@ns3:~ # chown -R radicale:radicale /usr/local/etc/radicale
```

## 3. Setting up Apache reverse proxy

In this article we will run Redicale with `"Apache reverse proxy"`. You must activate Vhost Apache first by activating the script below in the `httpd.conf` file.

```yml
root@ns3:~ # ee /usr/local/etc/apache24/httpd.conf
LoadModule vhost_alias_module libexec/apache24/mod_vhost_alias.so
LoadModule alias_module libexec/apache24/mod_alias.so
Include etc/apache24/extra/httpd-vhosts.conf
```

After that, open the `httpd-vhosts.conf` file, and type the script below.

```console
root@ns3:~ # ee /usr/local/etc/apache24/extra/httpd-vhosts.conf
<VirtualHost *:80>
        
    ServerName datainchi.com
    ServerAdmin datainchi@gmail.com

    ProxyRequests Off
    <Proxy *>
        Order deny,allow
        Allow from all
    </Proxy>

    RewriteEngine On
    RewriteRule ^/radicale$ /radicale/ [R,L]

    <Location "/radicale/">
        AuthType     Basic
        AuthName     "Radicale - Password Required"
        AuthUserFile "/usr/local/etc/radicale/users"
        Require      valid-user

        ProxyPass        http://localhost:5232/ retry=0
        ProxyPassReverse http://localhost:5232/
        RequestHeader    set X-Script-Name /radicale
        RequestHeader    set X-Remote-User expr=%{REMOTE_USER}
    </Location>

    <Location />
        Order allow,deny
        Allow from all
    </Location>

</VirtualHost>
```

Run Radicale and Apache24 servers.

```yml
root@ns3:~ # service radicale start
root@ns3:~ # service apache24 start
```

## 4. Test Radicale

If you have done all the configurations above and haven't missed anything, now is the time for us to test the Radicale server. Because Radicale runs on the Apache web server, we use Google Chrome or Modzilla Firefox for testing. In the address bar menu, type `"http://192.168.5.2/radicale"`, your monitor screen will appear as shown in the image below.

<br/>
<img alt="menu login radicale" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/14menu_login.jpg' | relative_url }}">
<br/>

Type in the username and password that you created above. After that it will appear as shown in the image below.

<br/>
<img alt="CalDAV CardDAV Server collection" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ 'https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/img/14CalDAV_CardDAV_Server_collection.jpg' | relative_url }}">
<br/>

You can directly create or upload an `"addressbook or calendar"` by clicking on the options displayed by the Radicale server.

Radicale is very light and very easy to configure, for the next stage you can use the Radicale server that you have installed and configured on FreeBSD. You can safely use the CalDAV/CardDAV client from a Windows computer or FreeBSD Desktop.