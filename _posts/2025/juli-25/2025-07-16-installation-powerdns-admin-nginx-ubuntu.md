---
title: PowerDNS Admin Installation Process on Ubuntu
date: "2025-07-16 07:57:32 +0100"
updated: "2025-10-19 10:31:12 +0100"
id: installation-powerdns-admin-nginx-ubuntu
lang: en
author: Iwan Setiawan
robots: index, follow
categories: Linux
tags: DNSServer
background: https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/14API_PpwerDNS.jpg
toc: true
comments: true
published: true
excerpt: PowerDNS-Admin is a web-based interface for managing PowerDNS DNS servers. It allows users to manage DNS zones and records through an easy-to-use web interface. The interface is written in Python and uses the Flask framework and a SQL database to store data
keywords: powerdns, power dns admin, ubuntu, linux, dns server, dns, query, nginx, apache
---

PowerDNS-Admin is a web-based administration interface for PowerDNS. Unlike other legacy front-end applications for PowerDNS, which often write directly to the PowerDNS database, this application uses the PowerDNS application programming interface introduced in PowerDNS 3.x and 4.x.
<br/>

## 1. System Requirements

- A working PowerDNS DNS server
- A MariaDB or MySQL database server.
- Git for source code.
- A Python development environment.
- Development libraries for MariaDB, SASL, LDAP, and SSL.
- A Python uWSGI application web server.
- An Nginx web server as a reverse proxy to the web application.
<br/>

## 2. About PowerDNS Admin

PowerDNS-Admin is a web-based interface for managing PowerDNS DNS servers. It allows users to manage DNS zones and records through an easy-to-use web interface. The interface is written in Python and uses the Flask framework and a SQL database to store data. In a Kubernetes environment, PowerDNS-Admin can be used to manage DNS records for a cluster and its resources through [ExternalDNS](https://github.com/PowerDNS-Admin/PowerDNS-Admin).

The PowerDNS Admin web interface has advanced features, including:

- Provides forward and reverse zone management.
- Provides zone template features.
- Provides user management with role-based access control.
- Provides zone-specific access control.
- Provides activity logging.
- Authentication can be performed using:
    1. Dukungan Pengguna Lokal.
    2. Dukungan SAML
    3. Dukungan LDAP: OpenLDAP / Active Directory
    4. Dukungan OAuth: Google / GitHub / Azure / OpenID
- Two-factor authentication (TOTP) support.
- PDNS service configuration and statistics monitoring.
- DynDNS 2 protocol support.
- Easy editing of IPv6 PTR records.
- Provides APIs for zone and record management, among other features.
- Full IDN/Punycode support

In the following diagram, you can see that PowerDNS-Admin calls the API from the PowerDNS Server via a secret key (see red box). The secret key will be set in the PowerDNS Server configuration.

<br/>

![API Power DNS](https://gitlab.com/unixbsdshell/unixbsdshell.gitlab.io/-/raw/main/images/14API_PpwerDNS.jpg)

<br/>


The first step is to generate a random password for the database user (16 characters recommended). Follow the script below to generate a random password.

```console
$ pwgen -cns 16 1
```
Also generate a random Flask secret app key (24 characters recommended).

```console
$ pwgen -cns 24 1
```
<br/>

## 3. Database

While PowerDNS stores its data in a MariaDB database, PowerDNS-Admin uses its own database to store users, permissions, and other information about the domains (zones) it manages.

To create the database used by the PowerDNS-Admin application, start an interactive session with root privileges on your database server.

```console
$ mysql -u root -p
Enter password: ********
```

The command above is used to log in to the MariaDB database server, using the password you created earlier. Once you've successfully logged in to the MariaDB database, continue with the following SQL command.

```sql
mysql> CREATE DATABASE powerdnsadmin;
mysql> GRANT ALL PRIVILEGES ON powerdnsadmin.* TO 'powerdnsadmin'@'localhost'
                IDENTIFIED BY '********';
mysql> FLUSH PRIVILEGES;
mysql> quit
```
<br/>

## 4. PowerDNS Admin Installation Process

Before you run the PowerDNS Admin installation process, first install the dependencies required by PowerDNS Admin, as shown in the example below.

```console
$ sudo apt-get install libsasl2-dev libldap2-dev libmariadbclient-dev
```
On Ubuntu, PowerDNS Admin isn't available in the default repositories; you'll need to download it from the official website or through GitHub. Here's an example of installing PowerDNS Admin from the GitHub repository.

```console
$ cd /usr/local/lib
$ sudo git clone https://github.com/ngoduykhanh/PowerDNS-Admin.git
$ sudo chown -R www-data:www-data PowerDNS-Admin
```
Run the sudo command to use the web server, in this article we use NGINX.

```console
$ sudo -u www-data -Hs
```
Create a new virtual Python environment named flask and activate it.

```console
$ cd /usr/local/lib/PowerDNS-Admin
$ virtualenv --python=python2.7 flask
$ source ./flask/bin/activate
```
You can now verify that you're working in the Python virtual environment by viewing your system's command prompt. If you've successfully logged into the Python virtual environment, your shell menu should look like the one below.

```console
(flask) $
```
In the python virtual environment, install the required Python packages PowerDNS Admin.

```console
(flask) $ pip install -r requirements.txt
(flask) $ pip install mysql
```
<br/>

## 5. PowerDNS Admin Configuration Process

To begin configuring PowerDNS admin, the first step is to copy the sample configuration and edit it.

```console
(flask) $ cp config_template.py config.py
```
<br/>
```php
import os
basedir = os.path.abspath(os.path.dirname(__file__))

# BASIC APP CONFIG
WTF_CSRF_ENABLED = True
SECRET_KEY = 'We are the world'
BIND_ADDRESS = '127.0.0.1'
PORT = 9393
LOGIN_TITLE = "PDNS"


# TIMEOUT - for large zones
TIMEOUT = 10

# LOG CONFIG
LOG_LEVEL = 'DEBUG'
LOG_FILE = 'logfile.log'
# For Docker, leave empty string
#LOG_FILE = ''

# Upload
UPLOAD_DIR = os.path.join(basedir, 'upload')

# DATABASE CONFIG
#You'll need MySQL-python
SQLA_DB_USER = 'powerdnsadmin'
SQLA_DB_PASSWORD = 'powerdnsadminpassword'
SQLA_DB_HOST = 'mysqlhostorip'
SQLA_DB_NAME = 'powerdnsadmin'

#MySQL
SQLALCHEMY_DATABASE_URI = 'mysql://'+SQLA_DB_USER+':'\
    +SQLA_DB_PASSWORD+'@'+SQLA_DB_HOST+'/'+SQLA_DB_NAME
#SQLite
#SQLALCHEMY_DATABASE_URI = 'sqlite:////path/to/your/pdns.db'
SQLALCHEMY_MIGRATE_REPO = os.path.join(basedir, 'db_repository')
SQLALCHEMY_TRACK_MODIFICATIONS = True

## LDAP CONFIG
#LDAP_TYPE = 'ldap'
#LDAP_URI = 'ldaps://your-ldap-server:636'
#LDAP_USERNAME = 'cn=dnsuser,ou=users,ou=services,dc=duykhanh,dc=me'
#LDAP_PASSWORD = 'dnsuser'
#LDAP_SEARCH_BASE = 'ou=System Admins,ou=People,dc=duykhanh,dc=me'
## Additional options only if LDAP_TYPE=ldap
#LDAP_USERNAMEFIELD = 'uid'
#LDAP_FILTER = '(objectClass=inetorgperson)'

## AD CONFIG
#LDAP_TYPE = 'ad'
#LDAP_URI = 'ldaps://your-ad-server:636'
#LDAP_USERNAME = 'cn=dnsuser,ou=Users,dc=domain,dc=local'
#LDAP_PASSWORD = 'dnsuser'
#LDAP_SEARCH_BASE = 'dc=domain,dc=local'
## You may prefer 'userPrincipalName' instead
#LDAP_USERNAMEFIELD = 'sAMAccountName'
## AD Group that you would like to have accesss to web app
#LDAP_FILTER = 'memberof=cn=DNS_users,ou=Groups,dc=domain,dc=local'

# Github Oauth
GITHUB_OAUTH_ENABLE = False
GITHUB_OAUTH_KEY = 'G0j1Q15aRsn36B3aD6nwKLiYbeirrUPU8nDd1wOC'
GITHUB_OAUTH_SECRET = '0WYrKWePeBDkxlezzhFbDn1PBnCwEa0vCwVFvy6iLtgePlpT7WfUlAa9sZgm'
GITHUB_OAUTH_SCOPE = 'email'
GITHUB_OAUTH_URL = 'http://127.0.0.1:5000/api/v3/'
GITHUB_OAUTH_TOKEN = 'http://127.0.0.1:5000/oauth/token'
GITHUB_OAUTH_AUTHORIZE = 'http://127.0.0.1:5000/oauth/authorize'

#Default Auth
BASIC_ENABLED = True
SIGNUP_ENABLED = True

# POWERDNS CONFIG
PDNS_STATS_URL = 'http://172.16.214.131:8081/'
PDNS_API_KEY = 'you never know'
PDNS_VERSION = '3.4.7'

# RECORDS ALLOWED TO EDIT
RECORDS_ALLOW_EDIT = ['A', 'AAAA', 'CNAME', 'SPF', 'PTR', 'MX', 'TXT']

# EXPERIMENTAL FEATURES
PRETTY_IPV6_PTR = False
```

### a. Basic Settings

- Enable CSRF (Cross-Site Request Forgery) protection for HTML forms. The default is True.
- Set a secret key to sign the user's browser cookies to protect user sessions.
- The address and port where the application's web interface will listen for incoming requests.

```console
# BASIC APP CONFIG
WTF_CSRF_ENABLED = True
SECRET_KEY = 'We are the world'
BIND_ADDRESS = '127.0.0.1'
PORT = 9393
LOGIN_TITLE = "PDNS"
```
<br/>

### b. Connection to the database

<br/>

```console
# DATABASE CONFIG
#You'll need MySQL-python
SQLA_DB_USER = 'powerdnsadmin'
SQLA_DB_PASSWORD = 'powerdnsadminpassword'
SQLA_DB_HOST = 'mysqlhostorip'
SQLA_DB_NAME = 'powerdnsadmin'
```
Script di atas membutuhkan kata sandi acak yang telah anda buat pada bagian sebelumnya.


### c. Disable LDAP Connection

In this article, we don't have or use LDAP, so we'll disable it by commenting out the relevant entry.

```console
#LDAP_URI = 'ldaps://your-ldap-server:636'
#LDAP_USERNAME = 'cn=dnsuser,ou=users,ou=services,dc=duykhanh,dc=me'
#LDAP_PASSWORD = 'dnsuser'
#LDAP_SEARCH_BASE = 'ou=System Admins,ou=People,dc=duykhanh,dc=me'
## Additional options only if LDAP_TYPE=ldap
#LDAP_USERNAMEFIELD = 'uid'
#LDAP_FILTER = '(objectClass=inetorgperson)'

## AD CONFIG
```
<br/>

### d. PowerDNS API Server Connection

This is how the web application connects to the PowerDNS server API interface. The settings must match your PowerDNS REST-API server configuration.

```console
# POWERDNS CONFIG
PDNS_STATS_URL = 'http://172.16.214.131:8081/'
PDNS_API_KEY = 'you never know'
PDNS_VERSION = '3.4.7'
```
Allowed DNS record types. The defaults ('A', 'AAAA', 'CNAME', 'SPF', 'PTR', 'MX', 'TXT') are very limited. A list of all supported DNS record types is available in the PowerDNS server documentation.

We recommend the following:

- A (maps hostnames to IPv4 addresses).
- AAAA (maps hostnames to IPv6 addresses).
- CERT (for storing SSL/TLS certificates in DNS).
- CNAME (hostname alias).
- MX (email exchange server).
- NAPTR (reverse mapping of phone numbers to VoIP addresses).
- NS (name servers responsible for the domain).
- OPENPGPKEY (stores PGP keys in DNS).
- PTR (reverse mapping of IP addresses to hostnames).
- SPF (Sender Policy Framework against email spam).
- SSHFP (for storing SSH public key fingerprints in DNS).
- SRV (maps service connections in the domain).
- T-LSA (SSL/TLS certificates authorized for the service to serve to clients).
- TXT (stores text in DNS).


The following may also be used on our domain, but should not be edited by users, as they are managed elsewhere.

- CDNSKEY (related to DNSSEC).
- CDS (related to DNSSEC).
- DNSKEY (related to DNSSEC, managed by pdnsutil).
- KEY (related to DNSSEC).
- NSEC, NSEC3, NSEC3PARAM (related to DNSSEC, managed by pdnsutil).
- RRSIG (related to DNSSEC, managed by pdnsutil).
- SOA (Start of Authority, defines domains in DNS).
- TKEY, TSIG (keys for signing and authenticating communications between a legitimate DNS server and a client).


```console
# RECORDS ALLOWED TO EDIT
RECORDS_ALLOW_EDIT = ['A', 'AAAA', 'CNAME', 'SPF', 'PTR', 'MX', 'TXT']
```

### e. Database Initialization

Create a database record.

```
(flask) $ ./create_db.py
```

We create an administrative user:

```
(flask) $ ./start.py
```
After running the "start.py" script, open Google Chrome and type http://192.0.2.41:9393 to create your first user account, which will automatically have administrative privileges.

Exit your browser and stop the server by pressing CTRL-C in your session.
<br/>

## 6. Configure uWSGI
Create a uWSGI application configuration file in `/etc/uwsgi/apps-available/powerdns-admin.ini` with the following content.

```console
; PowerDNS-Admin
[uwsgi]
plugins = python27

;uid=www-data
;gid=www-data

chdir = /usr/local/lib/PowerDNS-Admin/
pythonpath = /usr/local/lib/PowerDNS-Admin/
virtualenv = /usr/local/lib/PowerDNS-Admin/flask

mount = /pdns=run.py
manage-script-name = true
callable = app

vacuum = true
harakiri = 20
post-buffering = 8192

;socket = /run/uwsgi/app/%n/%n.socket
;chown-socket = www-data

;pidfile = /run/uwsgi/app/%n/%n.pid

;daemonize = /var/log/uwsgi/app/%n.log

enable-threads =
```

The commented line is already defined in the system-wide default settings. Create a symbolic link to enable it.

```
$ cd /etc/uwsgi/
$ sudo ln -s apps-available/powerdns-admin.ini apps-enabled/
```

Now we start running uwsgi:

```console
$ sudo service uwsgi start powerdns-admin
```
<br/>

## 7. NGINX Configuration

Create the file /etc/nginx/webapps/powerdns-admin.conf. An example script is shown below.

```html
#
# PowerDNS-Admin
# a web-based user interface to PowerDNS API server
#

location /dns {
    try_files $uri @powerdns-admin;
}

location @powerdns-admin {
   include uwsgi_params;
   uwsgi_pass unix:/run/uwsgi/app/powerdns-admin/powerdns-admin.socket;
}

location /dns/static/ {
   alias /usr/local/lib/PowerDNS-Admin/app/static/;
}
```

Include the file in the appropriate Nginx server definition.


```
# PowerDNS-Admin
include     webapps/powerdns-admin.conf;
```

Run and restart the Nginx configuration:

```
$ sudo service nginx conftest && sudo service nginx reload
```
<br/>

## 8. Dynamic Updates

Your public IPv4 address may change from time to time. We need to ensure that if this happens, our DNS records are updated to the new address as quickly as possible.

Since we run our own DNS server, we can do this directly on the server, or more specifically, in its MySQL database. The MySQL query to do this looks like this.

```console
UPDATE `records` SET content = "<NEW IP ADDRESS>", change_date "<TIME_NOW>"
    WHERE `type` = "A" AND `content` = "<OLD IP ADDRESS>";
```

This replaces the IPv4 address on every host (A) record in all domains we are authorized to use. To do this automatically, a small script can be run as a cronjob every five minutes, which does the following:

- Check the public IP address.
- Compare it to a known address.
- If it's different, update the database record; otherwise, exit.
- Exit.

### a. Updating Shell Script

```bash
#!/bin/bash
#
# PowerDNS Dynamic IP Updates

# Host to query for stored public IP address
KNOWN_HOST=www.example.net

# Router to query for current IP
ROUTER_IP=192.0.2.1
ROUTER_USER=pdns_updater
ROUTER_SSH_KEY=$HOME/.ssh/pdns_updater_rsa
ROUTER_IFC=sfp1
# Display IP Address on MicroTik Routers
ROUTER_CMD=":put [/ip address get [find interface=\"$ROUTER_IFC\"] address];"

# Our domain name master server to ask stored IP
DNS_MASTER=2001:db8::41

# MySQL server
MYSQL_HOST=localhost
MYSQL_USER=pdns_updater
MYSQL_PASSWORD=********
MYSQL_DB=pdns

# Ask router for current interface IP
READ_WAN_IP=`ssh $ROUTER_USER@$ROUTER_IP -i $ROUTER_SSH_KEY $ROUTER_CMD`

# Strip netmask ("/24") from IP
CURRENT_IP=`expr "$READ_WAN_IP" : '\([0-9\.]*\)'`

# Get current DNS address
DNS_IP=`dig +short @${DNS_MASTER} $KNOWN_HOST A`

# Compare the IPs
if [ $CURRENT_IP == $DNS_IP ]; then
	#echo "*** IPs are the same :) ***"
	exit
else
	echo "*** ALERT! Our WAN IP has changed! ***"
	echo "Old IP Address: $DNS_IP"
	echo "New IP Address: $CURRENT_IP"

	# Update all records in PowerDNS database which use the old IP
	mysql -u $MYSQL_USER -p${MYSQL_PASSWORD} -h $MYSQL_HOST $MYSQL_DB -e \
	   "UPDATE \`records\` 
	    	SET \`content\` = \"$CURRENT_IP\", \`change_date\`=\"`date +%s`\"
        	WHERE \`type\` = \"A\" AND \`content\` = \"$DNS_IP\";" \
    && echo "All DNS records with the old IP where updated." \
    || echo "*** Update of DNS records failed! ***"
fi
```

### b. Database User

Create a database user called pdns_updater with a very restrictive set of privileges.

```console
CREATE USER 'pdns_updater'@'localhost'
    IDENTIFIED BY '********';
GRANT SELECT (`type`, `content`), UPDATE (`content`, `change_date`)
    ON `pdns`.`records` TO 'pdns_updater'@'localhost';
FLUSH PRIVILEGES;
```

### c. Create a crontab update schedule

To define a cronjob that runs the update process every five minutes.

```console
$ crontab -e
*/5 * * * * /$HOME/bin/pdns_update.sh
```

## 9. Publish the SSH Server Key

By publishing your SSH server's public key in DNS, connecting clients can verify the server's identity without having to distribute and update your server's public key to all clients. You should already have a DNSSEC-secure DNS server set up for your server domain.

```
sshfp -s server.example.net
# server.example.net SSH-2.0-OpenSSH_6.6.1p1 Ubuntu-2ubuntu2
server.example.net IN SSHFP 1 1 5E677..............................21447
```
If you are using a PowerDNS server with the poweradmin web interface, add the following note.

Name                                        Type                    Content

server.example.net                    SSHFP                1 1 5E677…………………………21447


In conclusion, installing PowerDNS and PowerDNS-Admin on Ubuntu is a simple process that involves adding the PowerDNS repository, installing the PowerDNS package, and configuring the database. Once installed, you can use the dig command to query DNS servers, and the PowerDNS-Admin interface to manage them.