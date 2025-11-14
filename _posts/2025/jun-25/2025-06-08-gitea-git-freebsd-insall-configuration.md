---
title: Running Gitea on FreeBSD - Installation and Configuration
date: "2025-06-08 07:50:15 +0100"
updated: "2025-06-08 07:50:15 +0100"
id: gitea-git-freebsd-insall-configuration
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: DataBase
background: https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets%2Fimages%2F29rest%20api%20gitea%20server.jpg&commit=fcfcba847d5fec341ef3e93a7b5750346850bbfe
toc: true
comments: true
published: true
excerpt: Gitea is a free, lightweight, universal and official Open Source system. Gitea covers Git hosting, team collaboration, CI/CD and code review. Gitea is written in Go and is a community-based, lightweight code hosting solution published under the MIT license
keywords: gitea, git, github, gitflic, static page, repository, freebsd, clone, gitlab
---

Gitea is a free, lightweight, universal and official Open Source system. Gitea covers Git hosting, team collaboration, CI/CD and code review. Gitea is written in Go and is a community-based, lightweight code hosting solution published under the MIT license. Not only that, Gitea can manage Git repositories, supports authentication via third-party services, including Oauth, which allows you to use Casdoor for authentication. This is a fork of another lightweight system, namely Gogs.

Gitea as a fork of Gogs was developed on October 17, 2016 by people who were tired of the restrictions in Git repository development. The Gitea system is indispensable for developers to organize all work related to Git repositories. With your own private server, Gitea can be deployed as a service similar to GitHub and other services on your hardware.

Gitea has advantages that other software does not have, among the advantages of Gitea that you should know include:
- Compactness - Can be run on low-spec hardware, but its functionality is not affected and remains quite extensive.
- User friendly and easy to use interface.
- Integration - Can be connected to social media platforms such as Discord, Linkedin and others.
- Installation and configuration are very easy and can also be run on almost all operating systems such as Windows, BSD, Linux and MacOS.

<br/>

![rest api gitea server](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets%2Fimages%2F29rest%20api%20gitea%20server.jpg&commit=fcfcba847d5fec341ef3e93a7b5750346850bbfe)

<br/>


## 1. Gitea database

Gitea supports various databases, SQLite3, MySQL/MariaDB and PostgreSQL. This database will be used as a backend to store all information carried out by users. In this article, we will use SQLite3 as the database for Gitea. If your FreeBSD server does not have SQLite3 installed, you can run pkg install to install SQLite3.

```console
root@ns3:~ # pkg install sqlite3
```
Check the SQLite version.

```console
root@ns3:~ # sqlite3 --version
3.44.0 2023-11-01 11:23:50 17129ba1ff7f0daf37100ee82d507aef7827cf38de1866e2633096ae6ad8alt1 (64-bit)
```
The first step in installing Gitea is to install git and other dependencies that will form the library files.

```console
root@ns3:~ # pkg install go git git-lfs ca_root_nss openssl
```


## 2. Installation Gitea

Before installing Gitea, you must create users and groups for Gitea. We will create a user and group called `"git"` for Gitea. Run the command below to create a git user and group.

```console
root@ns3:~ # pw add group git
root@ns3:~ # pw add user -n git -g git -s /sbin/nologin -c "user and group git"
```
After that, you can continue installing Gitea. On FreeBSD, the Gitea repository is available in the FreeBSD ports. Use the ports system to install Gitea.

```console
root@ns3:~ # cd /usr/ports/www/gitea
root@ns3:/usr/ports/www/gitea # make install clean
```
In database, conf and log files, you provide file ownership rights and access rights.

```console
root@ns3:/usr/ports/www/gitea # chown -R git:git /var/db/gitea
root@ns3:/usr/ports/www/gitea # chown -R git:git /var/log/gitea
root@ns3:/usr/ports/www/gitea # chown -R git:git /usr/local/etc/gitea/conf
root@ns3:/usr/ports/www/gitea # chmod -R 775 /var/db/gitea
root@ns3:/usr/ports/www/gitea # chmod -R 775 /var/log/gitea
```


## 3. Gitea Configuration

The location of the Gitea configuration file is `/usr/local/etc/gitea/conf/app.ini`, and the configuration file is named **"app.ini"**. Open the file and edit the script to suit your system specifications. Below is an example of an "app.ini" script, which uses a SQLite3 database and a private IP address.

```console
root@ns3:~ # ee /usr/local/etc/gitea/conf/app.ini
APP_NAME = Gitea: Git with a cup of tea
RUN_USER = git
RUN_MODE = prod

[database]
DB_TYPE  = sqlite3
HOST     = 127.0.0.1:3306
NAME     = gitea
PASSWD   = 
PATH     = /var/db/gitea/gitea.db
SSL_MODE = disable
USER     = root

[indexer]
ISSUE_INDEXER_PATH = /var/db/gitea/indexers/issues.bleve

[log]
ROOT_PATH = /var/log/gitea
MODE      = file
LEVEL     = Info

[mailer]
ENABLED = false

[oauth2]
JWT_SECRET = D56bmu6xCtEKs9vKKgMKnsa4X9FDwo64HVyaS4fQ4mY

[picture]
AVATAR_UPLOAD_PATH      = /var/db/gitea/data/avatars
DISABLE_GRAVATAR        = false
ENABLE_FEDERATED_AVATAR = false

[repository]
ROOT = /var/db/gitea/gitea-repositories
# Gitea's default is 'bash', so if you have bash installed, you can comment
# this out.
SCRIPT_TYPE = sh

[repository.upload]
TEMP_PATH = /var/db/gitea/data/tmp/uploads

[security]
INSTALL_LOCK = true
INTERNAL_TOKEN = 1FFhAklka01JhgJTRUrFujWYiv4ijqcTIfXJ9o4n1fWxz+XVQdXhrqDTlsnD7fvz7gugdhgkx0FY2Lx6IBdPQw==
SECRET_KEY   = ChangeMeBeforeRunning

[session]
PROVIDER = file
PROVIDER_CONFIG = /var/db/gitea/data/sessions

[server]
DOMAIN       = localhost
HTTP_ADDR    = 192.168.5.2
HTTP_PORT    = 3000
ROOT_URL     = http://192.168.5.2:3000/
DISABLE_SSH  = false
SSH_DOMAIN   = %(DOMAIN)s
SSH_PORT     = 22
OFFLINE_MODE = false
APP_DATA_PATH = /var/db/gitea/data

[service]
REGISTER_EMAIL_CONFIRM = false
ENABLE_NOTIFY_MAIL     = false
DISABLE_REGISTRATION   = false
ENABLE_CAPTCHA         = true
REQUIRE_SIGNIN_VIEW    = false
```


## 4. Run Gitea

After that, you continue by running Gitea. Before you run Gitea, you must activate Gitea so that it can run automatically. Type the script below in the `/etc/rc.conf` file.

```console
root@ns3:~ # ee /etc/rc.conf
gitea_enable="YES"
gitea_user="git"
gitea_facility="daemon"
gitea_priority="debug"
gitea_shared="/usr/local/share/gitea"
gitea_custom="/usr/local/etc/gitea"
```
Run Gitea with the service command.

```console
root@ns3:~ # service gitea restart
```
To see the results, you can open Google Chrome, and type **"http://192.168.5.2:3000/"**, on your monitor screen it will appear as in the image below.


![git gitea hosted](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets%2Fimages%2F30git%20gitea%20hosted.jpg&commit=d5e84f608c3f984df7c76105f72b7016bb83a117)


In this article, we have discussed what the Gitea installation process is and why Gitea is indispensable for many developers. Overall, Github and Gitea offer the best services for managing your software development projects. However, both have advantages and disadvantages, which you can consider depending on the type of work being done. Your experience and ability in using Git greatly influences which platform is right for your future project.
