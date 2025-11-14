---
title: How to Install MariaDB Database Server on Linux Ubuntu
date: "2025-10-25 08:45:10 +0100"
updated: "2025-10-25 08:45:10 +0100"
id: how-to-install-database-server-mariadb-on-linux-ubuntu
lang: en
author: Iwan Setiawan
robots: index, follow
categories: linux
tags: DataBase
background: /img/oct-25/oct-25-134.jpg
toc: true
comments: true
published: true
excerpt: By default, the MariaDB package isn't available in the Ubuntu repository; you'll need to get the latest, stable version directly from the official MariaDB project website or GitHub. To install MariaDB on a Linux system like Ubuntu, Debian, or another system, follow the script below.
keywords: database, mariadb, server, mysql, query, linux, ubuntu, unix
---

Databases are key to the success of any business. They are the heart of all applications, whether mobile, web, or IoT. Whether you use a mobile phone, fill a prescription, or conduct a financial transaction, you'll find a MariaDB database behind it. With over 1 billion downloads, nearly 200,000 open source contributions, and reaching over 1 billion users through Linux distributions, MariaDB isn't just serving the relational database market; we're helping shape its future.

MariaDB is a database. It's very similar to MySQL (a database management system) and, in fact, a fork of MySQL. MariaDB databases are used for a variety of purposes, including data warehousing, e-commerce, enterprise-level features, and record-keeping applications.

MariaDB will efficiently enable you to meet all your workloads; it works on any cloud database and at any scale, whether small or large. MariaDB is a community-developed fork of the MySQL relational database management system and is intended to remain free under the GNU GPL license.

As a fork of the leading open-source software system, MariaDB is notable for being led by the original MySQL developers, who forked it due to concerns about its acquisition by Oracle.

<br/>
<img alt="MariaDB Software Installation" width="99%" class="lazyload" style="display: block; margin: auto;" src="{{ '/img/oct-25/oct-25-134.jpg' | relative_url }}">
<br/>

## 1. MariaDB Software Installation

By default, the MariaDB package isn't available in the Ubuntu repository; you'll need to get the latest, stable version directly from the official MariaDB project website or GitHub. To install MariaDB on a Linux system like Ubuntu, Debian, or another system, follow the script below.


```yml
$ curl --silent https://supplychain.mariadb.com/MariaDB-Server-GPG-KEY \
    | gpg --dearmor | \
    sudo tee /etc/apt/keyrings/MariaDB-Server.gpg > /dev/null

$ curl --silent https://supplychain.mariadb.com/MariaDB-MaxScale-GPG-KEY \
    | gpg --dearmor | \
    sudo tee /etc/apt/keyrings/MariaDB-MaxScale.gpg > /dev/null

$ curl --silent https://supplychain.mariadb.com/MariaDB-Enterprise-GPG-KEY \
    | gpg --dearmor | \
    sudo tee /etc/apt/keyrings/MariaDB-Enterprise.gpg > /dev/null
```

After you have installed the GPG-KEY key, continue by opening the MariaDB file in the `/etc/apt/sources.list.d/mariadb.sources` folder.

```yml
# MariaDB Server
# To use a different major version of the server, or to pin to a specific minor
# version, change URI below.
Types: deb
URIs: https://dlm.mariadb.com/repo/mariadb-server/10.11/repo/ubuntu
Suites: jammy
Components: main
Architectures: amd64 arm64
Signed-By: /etc/apt/keyrings/MariaDB-Server.gpg

# MariaDB MaxScale
# To use the latest stable release of MaxScale, use "latest" as the version
# To use the latest beta (or stable if no current beta) release of MaxScale, use
# "beta" as the version
Types: deb
URIs: https://dlm.mariadb.com/repo/maxscale/latest/apt
Suites: jammy
Components: main
Architectures: amd64 arm64
Signed-By: /etc/apt/keyrings/MariaDB-MaxScale.gpg

# MariaDB Tools
# MariaDB Tools are a collection of advanced command-line tools.
Types: deb
URIs: http://downloads.mariadb.com/Tools/ubuntu
Suites: jammy
Components: main
Architectures: amd64
Signed-By: /etc/apt/keyrings/MariaDB-Enterprise.gpg

# -*- mode: debsources; indent-tabs-mode: nil; tab-width: 4; -*-
```

After that create a preferences file to give packages from the MariaDB repository the highest priority, to avoid conflicts with packages from other OS and repositories.

Open the file `/etc/apt/preferences.d/mariadb.pref`, and type the script below.

```yml
Package: *
Pin: origin dlm.mariadb.com
Pin-Priority: 1000
```

After that, you run the update process.

```yml
$ sudo apt update
```
Once the key and repository are added and the package database is updated, you can directly install MariaDB with the following command.

```yml
$ sudo apt install mariadb-server
```

**Note:**
If an Oracle MySQL server is already installed, it will be removed, but not deleted without confirmation. The MySQL server configuration file will be saved and used by MariaDB.

On Ubuntu systems, MariaDB runs as a Systemd service named mariadb.service. The service cannot be started directly, you must issue a command to start MariaDB.

```yml
$ systemctl status mariadb.service
? mariadb.service - MariaDB 10.10.2 database server
    Loaded: loaded (/lib/systemd/system/mariadb.service; enabled; vendor preset: enabled)
    Drop-In: /etc/systemd/system/mariadb.service.d
            +-migrated-from-my.cnf-settings.conf
    Active: inactive (dead)
    Docs: man:mariadbd(8)
            https://mariadb.com/kb/en/library/systemd/
```

## 2. MariaDB Configuration

The configuration presented here differs significantly from what software packages typically install by default. This is preparation for the tasks the server must perform.

On Ubuntu systems, MariaDB is started and controlled by systemd as the mariadb.service service unit. To start, stop, or restart the MariaDB server, you can use the systemctl command.

```yml
$ systemctl start mariadb.service
$ systemctl restart mariadb.service
$ systemctl stop mariadb.service
```

The `reload` command is not supported on MariaDB services. You can view status and error messages written to the systemd journal, and to monitor the server, you can use the journalctl command.

```yml
$ journalctl -u mariadb.service
$ journalctl -f -u mariadb.service
```

### a. MariaDB Systemd Customization

The MariaDB service unit file is located in the `/lib/systemd/system` folder, named `mariab.service`. Custom options must be applied for MariaDB to run properly; modify the `/lib/systemd/system/mariab.service` file.

```yml
$ sudo edit mariab.service
```

You can see an example of the systemd script below.

```yml
# /etc/systemd/system/mariadb.service.d/override.conf
[Unit]
After=sys-devices-virtual-net-wg0.device unbound.service
BindsTo=sys-devices-virtual-net-wg0.device
```

### b. mysqld_safe

Prior to MariaDB version 10.1.8, the server was started by an init script or as an upstart service on most UNIX systems. This script also applied options found in the MySQL configuration file in the `[mysqld_safe]` or `[safe_mysqld]` section.

**Note:**
To edit the mysqld_safe file, the convention is to always prefix variable names with an '_' and options with a '-'.

Always use a '?' (hyphen) when setting options in configuration files or command-line options, such as key-buffer-size = 64K.

Always use an '_' (underscore) in SQL queries on the server, such as SHOW VARIABLES LIKE 'key_buffer_size';

The main MariaDB configuration file is called `/etc/mysql/mariadb.cnf`; you can modify it as needed. Below is an example of the `/etc/mysql/mariadb.cnf` file script that we have adapted to our current system.

```yml
#
# MariaDB database server version 10.10.2 configuration file.
#
# For explanations see:
#  * https://roll.urown.net/server/mariadb/
#  * https://mariadb.com/kb/en/library/server-system-variables/
#


[client]
#
# Character-Set
# Default: Latin1
default-character-set = utf8mb4

#
# UNIX Sockets & TCP/IP
port = 3306
socket = /run/mysqld/mysqld.sock


[mysqld]
#
# Basic Settings
#
user = mysql
pid-file = /run/mysqld/mysqld.pid
basedir = /usr
datadir = /var/lib/mysql
tmpdir = /tmp
lc_messages_dir = /usr/share/mysql
lc_messages = en_US
#
# If applications support it, this stricter sql_mode prevents some
# mistakes like inserting invalid dates etc.
#sql_mode       = NO_ENGINE_SUBSTITUTION,TRADITIONAL

# The default storage engine. The default storage engine must be enabled at
# server startup or the server won't start.
# Default: InnoDB
default_storage_engine = InnoDB

#
# Character-Set
# Default: Latin1
character-set-server = utf8mb4
collation-server = utf8mb4_general_ci

#
# UNIX Sockets & TCP/IP
#
socket = /run/mysqld/mysqld.sock

# By default, the MariaDB server listens for TCP/IP connections on a network
# socket bound to a single address, 0.0.0.0. You can specify an alternative when
# the server starts using this option; either a host name, an IPv4 or an IPv6
# address. In Debian and Ubuntu, the default bind_address is 127.0.0.1, which
# binds the server to listen on localhost only.
# Debian-Default: 127.0.0.1
# Default: 0.0.0.0 / :: (All available IPv4 and IPv6 interfaces)
bind-address = ::
port = 3306

# If set to ON, only IP addresses are used for connections. Host names are not
# resolved. All host values in the GRANT tables must be IP addresses (or
# localhost).
# Default: OFF
skip-name-resolve = ON

# Set longer periods to avoid timeout errors
connect_timeout = 600
wait_timeout = 28800


# This was formally known as [safe_mysqld]. Both versions are currently parsed.
[mysqld_safe]
socket = /run/mysqld/mysqld.sock
nice = 0


[mysqldump]
quick
quote-names
max_allowed_packet = 16M


[mysql]
#no-auto-rehash # faster start of mysql but no tab completion


[isamchk]
key_buffer = 16M

#
# Additional settings will override anything in this file!
# The files must end with '.cnf', otherwise they'll be ignored.
#
!includedir /etc/mysql/conf.d/

# -*- mode: ini; tab-width: 4; indent-tabs-mode: nil -*-
```

Important settings in the script above are as follows:
- **skip-name-resolve = ON**, because our DNS server will get its data from its database.
- **bind-address**, Set to listen on all interfaces. This is because we need network access for replication with other servers. Unfortunately, you can configure only one interface (usually localhost) or all of them. Since we need both localhost and external access, and not all of our clients can use UNIX sockets, we need to open all of them. This means we need to carefully manage the user permissions on our database server, and we need a firewall to block unwanted remote access.
In the example script above, we left the debian.cnf and debian-start files unchanged. You can also create additional files in /etc/mysql/conf.d/ and /etc/mysql/mariadb.conf.d/ to ensure MariaDB remains compatible with Oracle MySQL servers.

Configuration settings compatible with both products should be stored in `/etc/mysql/conf.d/`, while settings that only work with MariaDB should be stored in `/etc/mysql/mariadb.conf.d/`. The `/etc/mysql/conf.d/mariadb.cnf` file will contain these, but only for MariaDB-compatible products.

### c. Character Sets

To use character sets, you must always use UTF-8 instead of Latin1 as the default for both the server and client. Then, open `/etc/mysql/my.cnf` and uncomment the three UTF-8 lines. As shown in the example below.

```yml
[client]
#
# Character-Set
# Default: Latin1
default-character-set = utf8mb4

[mysqld]
#
# Character-Set
# Default: Latin1
character-set-server = utf8mb4
collation-server = utf8mb4_general_ci
```
Once you have finished configuring, restart the MariaDB server, with the following command.

```yml
$ sudo systemctl restart mariadb.service
```

### d. UNIX Sockets & TCP/IP

Current versions of MariaDB and MySQL servers can be configured to listen on none, a single IP address, or all, regardless of IP version.

So, for a multi-host host listening on both IPv6 and IPv4, or a host that must be reachable on both `localhost/127.0.0.1` and a real network interface, the server must be configured to listen on all interfaces. The server cannot be limited to listening on, for example, localhost and a single IP address. It can listen on one or all.

Edit the relevant sections of the `/etc/mysql/my.cnf` file as shown below.

```yml
[client]

#
# UNIX Sockets & TCP/IP
port = 3306
socket = /run/mysqld/mysqld.sock

[mysqld]
# UNIX Sockets & TCP/IP
#
socket = /run/mysqld/mysqld.sock

# By default, the MariaDB server listens for TCP/IP connections on a network
# socket bound to a single address, 0.0.0.0. You can specify an alternative when
# the server starts using this option; either a host name, an IPv4 or an IPv6
# address. In Debian and Ubuntu, the default bind_address is 127.0.0.1, which
# binds the server to listen on localhost only.
# Debian-Default: 127.0.0.1
# Default: 0.0.0.0 / :: (All available IPv4 and IPv6 interfaces)
bind-address = ::
port = 3306

# If set to ON, only IP addresses are used for connections. Host names are not
# resolved. All host values in the GRANT tables must be IP addresses (or
# localhost).
# Default: OFF
skip-name-resolve = ON

# Set longer periods to avoid timeout errors
connect_timeout = 600
wait_timeout = 28800
```

Using MariaDB is almost the same as MySQL Server, as they both come from the same foundation. MariaDB also offers robust features and flexibility, and all of its features are nearly identical to those of MySQL Server.

Whether you're a database administrator, developer, or simply curious about open-source databases, MariaDB offers a compelling option with community-driven development, robust performance, and a wide range of use cases.