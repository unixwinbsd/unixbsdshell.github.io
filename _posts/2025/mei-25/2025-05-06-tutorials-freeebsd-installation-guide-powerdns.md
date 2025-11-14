---
title: Tutorials FreeBSD - Installation Guide PowerDNS
date: "2025-05-06 11:19:39 +0100"
updated: "2025-05-06 11:19:39 +0100"
id: tutorials-freeebsd-installation-guide-powerdns
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DNSServer
background: https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/9FreeBSD%20PowerDNS%20Install.jpg&commit=8253baaa6e40474a4e694f003f27154a68a58e4f
toc: true
comments: true
published: true
excerpt: Swoole is a framework for PHP based on asynchronous co-routines. Swoole is specifically designed to build large-scale concurrent systems
keywords: dns server, powerdns, power dns, freebsd, tutorials, article, installation, configuration
---

Officially, PowerDNS consists of Authoritative Server and Recursor. PowerDNS is a DNS server written in C++ and licensed under the GPL. You can use both PowerDNS functions above or just one. The authoritative server will answer questions about the authoritative domain, namely the name server. Meanwhile, the Recursor function will ask other name servers on the Internet to find out about the query being asked.

Using PowerDNS can use other DNS servers such as Bind for recursion or use PowerDNS Recursor (pdns_recursor) which is run separately. PowerDNS written by Bert Hubert is a product of a Dutch company called powerdns.com. B.V. Currently, the PowerDNS community has spread widely with many contributors from the Open Source community.

For those of you who use Unix systems such as FreeBSD, OpenBSD and others, PowerDNS is the best DNS server solution that offers simplicity, stability and reliability. Instead of using text files, PowerDNS uses a database backend to store its data. Database servers supported by PowerDNS include MariaDB, MySQL, PostgreSQL, and SQLite3.

In this post, I’ll show you how to install PowerDNS with a MySQL server as the backend on FreeBSD 13.3. I’ll also cover using pdnsutil to manage zones and create domain names, and dig to check DNS connections and troubleshoot DNS servers.

![diagram powerdns master replication](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/9FreeBSD%20PowerDNS%20Install.jpg&commit=8253baaa6e40474a4e694f003f27154a68a58e4f)


## 1. System Requirements

- OS: FreeBSD 13.3
- Hostname: ns3
- IP server: 192.168.5.2
- MySQL server version: mysql80-server
- CPU: AMD Phenom II X4 965 3400 MHz


## 2. Setting up FQDN

FQDN (Fully Qualified Domain Name) is a name that uniquely identifies a host on the Internet. FQDN must include the parent domain name. Fully Qualified Domain Name in DNS must end with a dot that indicates the root domain name. When you delegate a domain name, the name server or NS will be treated as the FQDN, which is the fully qualified domain name with a dot at the end.

Before you assign an FQDN to a FreeBSD server, check the FQDN name that is currently in use with the following command.

```console
root@ns3:~ # hostname
ns5.unixwinbsd.com
```
In the command above we can see, the current active Hostname is "ns5" and the domain is "unixwinbsd.com".

If you want to make the FQDN name permanent, in FreeBBSD the FQDN name is placed in the rc.conf file. Now run the following command to create a permanent FQDN configuration on FreeBSD.

```console
root@ns3:~ # sysrc hostname="ns3.datainchi.com"
hostname: ns3.datainchi.com -> ns3.datainchi.com
```
After that, using the "ee" editor, open the `/etc/hosts` file, and type the script below.

```console
root@ns3:~ # ee /etc/hosts
127.0.0.1		        localhost localhost.datainchi.com
192.168.5.2		ns3 ns3.datainchi.com
```
Next, to verify the domain name on your FreeBSD system, run the following command.

```console
root@ns3:~ # hostname -d
root@ns3:~ # hostname -f
```


## 3. Install PowerDNS

After you have finished configuring the FQDN domain that will be used on your FreeBSD server, proceed to the next step, namely installing PowerDNS. On FreeBSD, the PowerDNS repository is available in the PKG and Ports package managers. You can install PowerDNS in one of these ways. In this article we will install PowerDNS with a ports system.

You can install PowerDNS in two different ways: via the `PKG package manager and Ports`. In this example, you will install PowerDNS via PKG from the FreeBSD repository. To install PowerDNS on FreeBSD, follow this Guide.

```console
root@ns3:~ # cd /usr/ports/dns/powerdns
root@ns3:/usr/ports/dns/powerdns # make install clean
```
Don't forget, also install powerdns-recursor, to activate PowerDNS Recursor.

```console
root@ns3:/usr/ports/dns/powerdns # cd /usr/ports/dns/powerdns-recursor
root@ns3:/usr/ports/dns/powerdns-recursor # make install clean
```
You also install the dig utility, to check the PowerDNS connection.

```console
root@ns3:~ # pkg install -y bind-tools
```
If the installation process is complete, continue by activating PowerDNS.

```console
root@ns3:~ # ee /etc/rc.conf
pdns_enable="YES"
pdns_conf="/usr/local/etc/pdns/pdns.conf"
pdns_recursor_enable="YES"
pdns_recursor_conf="/usr/local/etc/pdns/recursor.conf"
```


## 4. Create Database PowerDNS server

You need to pay attention, PowerDNS uses a database server to store zone files. In this example we will use a MySQL database as the PowerDNS backend. But in this article, we are not discussing how to install MySQL, we will just assume that your FreeBSD server has MySQL server installed and is running normally. So we just create a database for PowerDNS. Follow the command script below.

```console
root@ns3:~ # mysql -u root -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 11
Server version: 8.0.35 Source distribution

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

root@localhost [(none)]> CREATE DATABASE pdns;
Query OK, 1 row affected (0.25 sec)

root@localhost [(none)]> CREATE USER userpdns@localhost IDENTIFIED BY 'router123';
Query OK, 0 rows affected (0.12 sec)

root@localhost [(none)]> GRANT ALL PRIVILEGES ON pdns.* TO userpdns@localhost;
Query OK, 0 rows affected (0.05 sec)

root@localhost [(none)]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.04 sec)

root@localhost [(none)]> quit;
Bye
root@ns3:~ #
```
On FreeBSD the MySQL schema file is stored in `/usr/local/share/doc/powerdns`. Run the schema file with MySQL, as in the example below.

```console
root@ns3:~ # mysql -u userpdns -p pdns < /usr/local/share/doc/powerdns/schema.mysql.sql
```
You can verify the MySQL database schema that will be used to store PowerDNS zones.

```console
root@ns3:~ # mysqlshow -u userpdns -p pdns
Enter password:
Database: pdns
+----------------+
|     Tables     |
+----------------+
| comments       |
| cryptokeys     |
| domainmetadata |
| domains        |
| records        |
| supermasters   |
| tsigkeys       |
+----------------+
```

## 5. Setting Up PowerDNS

The next step, you have to configure PowerDNS. The configuration files for the configuration are located at `/usr/local/etc/pdns`. Open the pdns.conf file and add the MySQL script as in the example below.

```console
root@ns3:~ # cd /usr/local/etc/pdns
root@ns3:/usr/local/etc/pdns # ee pdns.conf
allow-axfr-ips=0.0.0.0/0

allow-recursion=0.0.0.0/0

# cache-ttl	Seconds to store packets in the PacketCache
cache-ttl=20

config-dir=/usr/local/etc/pdns
control-console=no
daemon=yes
default-soa-name=ns3.datainchi.com

# default-ttl	Seconds a result is valid if not set otherwise
default-ttl=3600
guardian=no

launch=gmysql
# gmysql parameters
gmysql-host=127.0.0.1
gmysql-port=3306
gmysql-dbname=pdns
gmysql-user=userpdns
gmysql-password=router123
gmysql-dnssec=yes

local-address=127.0.0.1, 192.168.5.2
# local-ipv6=

local-port=5353
logfile=/var/log/pdns/pdns.log
loglevel=9

master=yes
max-queue-length=5000
max-tcp-connections=10
recursor=127.0.0.1

setgid=pdns
setuid=pdns

slave=yes
slave-cycle-interval=600

smtpredirector=
soa-expire-default=604800
soa-minimum-ttl=3600
soa-refresh-default=10800
soa-retry-default=3600
soa-serial-offset=0
socket-dir=/var/run/pdns

# use-logfile	Use a log file
use-logfile=yes


version-string=powerdns
webserver=yes
webserver-address=192.168.5.2
# webserver-password=
webserver-port=8081
webserver-print-arguments=yes
```
After that, you change the `recursor.conf` file script.

```console
root@ns3:/usr/local/etc/pdns # ee recursor.conf
allow-from=127.0.0.0/8, 10.0.0.0/8

hint-file=/usr/local/etc/pdns/root.zone

local-address=127.0.0.1
local-port=53

max-tcp-clients=128


setgid=pdns
setuid=pdns_recursor

socket-dir=/var/run/pdns

version-string=PowerDNS Recursor
```

After that, you run the pdns_server command, to connect PowerDNS to the MySQL server and verify the database that PowerDNS will use.

```console
root@ns3:/usr/local/etc/pdns # pdns_server --daemon=no --guardian=no --loglevel=9
```
Create a PowerDNS log file.

```console
root@ns3:~ # mkdir -p /var/log/pdns
root@ns3:~ # touch /var/log/pdns/pdns.log
root@ns3:~ # touch /var/log/pdns/pdns_recursor.log
```
Activate the log file in the `/etc/syslog.conf` file.

```console
root@ns3:~ # ee /etc/syslog.conf
!pdns
*.*      /var/log/pdns/pdns.log

!pdns_recursor
*.*      /var/log/pdns/pdns_recursor.log
```
Next, set the log file rotation, type the script below into the `/etc/newsyslog.conf` file.

```console
root@ns3:~ # ee /etc/newsyslog.conf
/var/log/pdns/*.log			644  7	   *	@T00  GJC
Run the PowerDNS log file `(/etc/newsyslog.conf)`

```console
root@ns3:~ # service syslogd restart
Stopping syslogd.
Waiting for PIDS: 4712.
Starting syslogd.
root@ns3:~ # service newsyslog restart
Creating and/or trimming log files.
```
When the installation process is complete, PoerDNS automatically creates a new user and group called `"pdns"`. Run the chown command to assign users and groups to PowerDNS.

```console
root@ns3:~ # chown -R pdns:pdns /var/run/pdns
root@ns3:~ # chown -R pdns:pdns /usr/local/etc/pdns/pdns.conf
root@ns3:~ # chown -R pdns_recursor:pdns /usr/local/etc/pdns/recursor.conf
root@ns3:~ # chown -R pdns:pdns /var/log/pdns
```
The next step, run PowerDNS with the service command.

```console
root@ns3:~ # service pdns-recursor restart
root@ns3:~ # service pdns restart
```
To check whether port 53 is open or not, you can check it with the following command.

```console
root@ns3:~ # sockstat -4 -p 53
```


## 6. Creating Forward Zone

Before you create a `"forward zone"` download the `root.zone` file first. Follow the example below.

```console
root@ns3:/usr/local/etc/pdns # wget ftp://ftp.rs.internic.net/domain/root.zone.gz && gunzip root.zone.gz
```
Once the PowerDNS server is active and running normally on FreeBSD, the next step is to create a name server, which can be done with the pdnsutil command. Pdnsutil is a command line for managing PowerDNS records and controlling DNSSEC commands.

```console
root@ns3:~ # pdnsutil create-zone datainchi.com ns3.datainchi.com
root@ns3:~ # pdnsutil add-record datainchi.com ns3 A 192.168.5.2
root@ns3:~ # pdnsutil list-zone datainchi.com
```
Final step, Finally, run the dig command to check the A and SOA records for the ns3.datainchi.com name server.

```console
root@ns3:~ # dig ns3.datainchi.com @127.0.0.1
root@ns3:~ # dig SOA ns3.datainchi.com @127.0.0.1
```
We proceed by running the command below to check the zone configuration on your PowerDNS server. Then, verify the list of DNS records in the datainchi.com zone.

```console
root@ns3:~ # pdnsutil check-all-zones
root@ns3:~ # pdnsutil list-zone datainchi.com
```


## 7. Creating PTR Record

The final step is to create reverse zones or PTR records which will handle the translation of IP addresses to domain names. This section is the most important part of PowerDNS configuration. Run the command below to create a new reverse zone.

```console
root@ns3:/usr/local/etc/pdns # pdnsutil create-zone 5.168.192.in-addr.arpa ns3.datainchi.com
```
Add a record for name server ns3.datainchi.com to IP address `192.168.5.2`.

```console
root@ns3:/usr/local/etc/pdns # pdnsutil add-record 5.168.192.in-addr.arpa ns3 A 192.168.5.2
```
Next, run the command below to create a new PTR record for each of your domain names.

```console
root@ns3:/usr/local/etc/pdns # pdnsutil add-record 5.168.192.in-addr.arpa 80 PTR ns3.datainchi.com
root@ns3:/usr/local/etc/pdns # pdnsutil add-record 5.168.192.in-addr.arpa 25 PTR ns3.datainchi.com
root@ns3:/usr/local/etc/pdns # pdnsutil add-record 5.168.192.in-addr.arpa 35 PTR ns3.datainchi.com
root@ns3:/usr/local/etc/pdns # pdnsutil add-record 5.168.192.in-addr.arpa 30 PTR ns3.datainchi.com
```
The Domain Name System (DNS) is very vulnerable. because if DNS is down then your website services that use DNS automatically cannot be used. PowerDNS provides the perfect solution, with backend database support making this DNS server the main choice for those of you who are designing a DNS server for reliable website needs.
