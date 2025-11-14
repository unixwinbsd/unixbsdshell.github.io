---
title: GitLab Installation Guide on FreeBSD Server
date: "2025-05-07 11:35:22 +0100"
updated: "2025-05-07 11:35:22 +0100"
id: gitLab-installation-guide-freebsd-server
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: SysAdmin
background: https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/NugetArticle/Process%20of%20Installing%20Gitlab%20on%20FreeBSD.jpg&commit=af864b0188f7e96be6438b0579f8e29be3445973
toc: true
comments: true
published: true
excerpt: To be able to use Git, there are currently various services available to store and share the code. For example, GitLab, GitHub, Bitbucket, and Gitorous. Among these options, GitLab is one of the Git storage services that is on the rise and has many users.
keywords: gitlab, github, freebsd, installation, git, ruby, gem, bundler, repository, ci, cid, remote
---

Gitlab is a service that provides remote access to Git repositories. In addition to being a place to store your code, this service also provides additional features designed to help manage the software development cycle. Git is a tool that functions to make it easier for developers. This tool is useful as a Version Control System (VCS) which is tasked with tracking changes to code files. For developers, the existence of Git makes it very easy for them to collaborate to complete projects with other developers or on their own projects.

Tools like Git allow developers to make changes to certain source codes. They don't need to worry about conflicts in merging the codes. Because by using Git, all changes to the source code can be tracked.

To be able to use Git, there are currently various services available to store and share the code. For example, GitLab, GitHub, Bitbucket, and Gitorous. Among these options, GitLab is one of the Git storage services that is on the rise and has many users.

Git is a source code versioning system that allows you to track changes locally and push or pull changes from remote resources.

<br/>
![Process of Installing Gitlab on FreeBSD](https://gitflic.ru/project/unixbsdshell/ruby-static-page-jekyll-rb-openbsd/blob/raw?file=assets/images/NugetArticle/Process%20of%20Installing%20Gitlab%20on%20FreeBSD.jpg&commit=af864b0188f7e96be6438b0579f8e29be3445973)
<br/>

GitLab is a github-like service that organizations can use to provide internal management of git repositories. It is a self-hosted Git repository management system that keeps user code private and can easily deploy code changes. Here are some of the benefits of using Gitlab:
- Open-source Gitlab CE available.
- Real-time logging.
- Supports Parallel Builds.
- Facilitates collaboration between developers

## 1. Install PostgreSQL Database
All Gitlab features will work well if you use PostgreSQL database. So we recommend using PostgreSQL database that will connect with Gitlab. You can use MySQL Database, but some Gitlab features will not work well.

In FreeBSD PostgreSQL repository is available, you can install PostgreSQL with PKG or port. But it is better to install PostgreSQL with system port. There are two PostgreSQL that you must install, namely PostgreSQL client and PostgreSQL server. Here is how to install PostgreSQL on FreeBSD.

```console
root@ns3:~ # cd /usr/ports/databases/postgresql15-client
root@ns3:/usr/ports/databases/postgresql15-client # make install clean
root@ns3:/usr/ports/databases/postgresql15-client # cd /usr/ports/databases/postgresql15-server
root@ns3:/usr/ports/databases/postgresql15-server # make install clean
```
In this article, we do not fully explain how to install and use PostgreSQL, you can read the previous article "[How to Install and Configure PostgreSQL on FreeBSD 14](https://unixwinbsd.site/en/freebsd/2025/05/07/howto-install-and-configure-postgresql-freebsd)"


## 2. Creating PostgreSQL
In this section we will create a database that will be used by Gitlab to communicate with PostgreSQL. Here is the database that we will create with PostgreSQL.

- user: `usergitlab`
- database: `gitlab`
- host: `localhost`
- password: `router123`

Run the command below to create a PostgreSQL database.

```console
root@ns3:~ # su - postgres
$ createuser usergitlab
$ createdb gitlab -O usergitlab encoding='UTF8'
$ psql gitlab
psql (15.5)
Type "help" for help.

gitlab=# alter user usergitlab with password 'router123';
ALTER ROLE
gitlab=#
```
The above command is used to connect to a PostgreSQL database, and create a database, user, and password.


## 3. Install Redis
Gitlab uses Redis to store all its caches. The goal is to speed up Gitlab performance. Run the following command to install Redis.

```console
root@ns3:~ # cd /usr/ports/databases/redis
root@ns3:/usr/ports/databases/redis # make install clean
```
After that, configure Redis, open the redis.conf file and activate it by removing the "#" sign at the beginning of the script. Here's the script you need to activate.

```console
root@ns3:~ # cd /usr/local/etc
root@ns3:/usr/local/etc # ee redis.conf
unixsocket /var/run/redis/redis.sock
unixsocketperm 770
requirepass foobared
#bind 127.0.0.1 -::1
```
Allow Redis to start by adding the script below to the `/etc/rc.conf` file.

```console
root@ns3:~ # ee /etc/rc.conf
redis_enable="YES"
```

Start Redis with the restart command.

```console
root@ns3:~ # service redis restart
```

## 4. Install gitlab-ce
Before you install gitlab-ce, first install the dependencies required by gitlab-ce. Here's how to install gitlab-ce dependencies.

```console
root@ns3:~ # pkg install re2 html2text rubygem-re2 rubygem-gitlab-glfm-markdown rubygem-prometheus-client-mmap gpgme rubygem-rugged rubygem-charlock_holmes rubygem-plist rubygem-nkf rubygem-rouge rubygem-wmi-lite rubygem-net-ssh rubygem-lockbox rubygem-unf_ext
```
After that, you can run the gitlab-ce install command.

```console
root@ns3:~ # cd /usr/ports/www/gitlab-ce
root@ns3:/usr/ports/www/gitlab-ce # make install clean
```
Or, if you want to use the PKG package, run the command below.

```console
root@ns3:~ # pkg install gitlab-ce
root@ns3:~ # pkg install www/gitlab
```


## 5. Gitlab Configuration
In this section, we will explain how to configure Gitlab on FreeBSD. Since you have to do a lot of configuration, we recommend that you follow each step we describe so that you don't miss a single script.

### 5.1. Make Connection
After the gitlab-ce installation process is complete, open the gitlab installation directory and edit the configuration file, you follow the instructions at the top of the file. In the `gitlab.yml` file, activate the script below.

```console
root@ns3:~ # cd /usr/local/www/gitlab-ce/config
root@ns3:/usr/local/www/gitlab-ce/config # ee gitlab.yml
connect_src: "'self' http://192.168.5.2:* ws://192.168.5.2:* wss://192.168.5.2:*"
allowed_hosts: [192.168.5.2]
gitlab:
    host: 192.168.5.2
    port: 8080
email_from: datainchi@gmail.com
email_reply_to: datainchi@gmail.com
user: git
time_zone: 'UTC'

### 5.2. Create Database Connection
In the `database.yml` file, change the database script according to the PostgreSQL database you created above.

```console
root@ns3:~ # cd /usr/local/www/gitlab-ce/config
root@ns3:/usr/local/www/gitlab-ce/config # ee database.yml
production:
  main:
    adapter: postgresql
    encoding: unicode
    database: gitlab
    username: usergitlab
    password: "router123"
    host: localhost
```

### 5.3. Create global git settings
We will use the git command to initialize Gitlab, running the following commands to switch to the git user and update some of its global git settings.

```console
root@ns3:~ # mkdir -p /usr/local/git/repositories
root@ns3:~ # mkdir -p /usr/home/git && mkdir -p /usr/home/git/gitlab
root@ns3:~ # chown -R git:git /usr/local/git/repositories
root@ns3:~ # chown -R git:git /usr/home/git/
```
```console
root@ns3:~ # su - git
$ git config --global core.autocrlf input
$ git config --global gc.auto 0
$ git config --global repack.writeBitmaps true
$ git config --global receive.advertisePushOptions true
$ git config --global core.fsync objects,derived-metadata,reference
$ exit
root@ns3:~ #
```

### 5.4. Change ownership and permissions
On some Gitlab directories and files, you need to change file ownership and file permissions.

```console
root@ns3:~ # chown -R git:git /usr/local/www/gitlab-ce/log
root@ns3:~ # chown -R git:git /usr/local/www/gitlab-ce/tmp
root@ns3:~ # chown -R git:git /usr/local/www/gitlab-ce/public
root@ns3:~ # chown -R git:git /usr/local/www/gitlab-ce/builds
root@ns3:~ # chown -R git:git /usr/local/www/gitlab-ce/shared
```
```console
root@ns3:~ # chmod -R 770 /usr/local/www/gitlab-ce/log
root@ns3:~ # chmod -R 770 /usr/local/www/gitlab-ce/tmp
root@ns3:~ # chmod -R 770 /usr/local/www/gitlab-ce/public
root@ns3:~ # chmod -R 770 /usr/local/www/gitlab-ce/builds
root@ns3:~ # chmod -R 770 /usr/local/www/gitlab-ce/shared
root@ns3:~ # chmod -R 770 /usr/local/www/gitlab-ce/config
```

### 5.5. Install rubygems library
To prevent hangs during Gitlab installation, configure rubygems to use installed libraries.

```console
root@ns3:~ # cd /usr/local/www/gitlab-ce
root@ns3:/usr/local/www/gitlab-ce # bundle config build.gpgme "--use-system-libraries"
root@ns3:/usr/local/www/gitlab-ce # bundle config build.rugged "--use-system-libraries"
root@ns3:/usr/local/www/gitlab-ce # bundle config build.re2 "--use-system-libraries"
root@ns3:/usr/local/www/gitlab-ce # bundle config build.charlock_holmes "--use-system-libraries"
root@ns3:/usr/local/www/gitlab-ce # bundle config build.gitlab-glfm-markdown "--use-system-libraries"
root@ns3:/usr/local/www/gitlab-ce # bundle config build.nkf "--use-system-libraries"
root@ns3:/usr/local/www/gitlab-ce # bundle config build.rouge "--use-system-libraries"
root@ns3:/usr/local/www/gitlab-ce # bundle config build.wmi-lite "--use-system-libraries"
root@ns3:/usr/local/www/gitlab-ce # bundle config build.plist "--use-system-libraries"
root@ns3:/usr/local/www/gitlab-ce # bundle config build.net-ssh "--use-system-libraries"
root@ns3:/usr/local/www/gitlab-ce # bundle config build.lockbox "--use-system-libraries"
root@ns3:/usr/local/www/gitlab-ce # bundle config build.unf_ext "--use-system-libraries"
root@ns3:/usr/local/www/gitlab-ce # bundle config build.prometheus-client-mmap "--use-system-libraries"
```
If there is still an "error", you can try the command below.

```console
root@ns3:/usr/local/www/gitlab-ce # bundle config build.prometheus-client-mmap "--platform ruby"
root@ns3:/usr/local/www/gitlab-ce # bundle config build.gitlab-glfm-markdown "--platform ruby"
root@ns3:/usr/local/www/gitlab-ce # gem install prometheus-client-mmap --platform ruby
root@ns3:/usr/local/www/gitlab-ce # gem install gitlab-glfm-markdown --platform ruby
```
### 5.6. Install gems for PostgreSQL
GitLab Shell is an SSH access and repository management software developed specifically for GitLab. First of all, we have to install Ruby Gems.

```console
root@ns3:/usr/local/www/gitlab-ce # bundle install --without development test
```
Run the installation command for gitlab-shell.

```console
root@ns3:/usr/local/www/gitlab-ce # bundle exec rake gitlab:shell:install REDIS_URL=unix:/var/run/redis/redis.sock RAILS_ENV=production SKIP_STORAGE_VALIDATION=true
```

### 5.7. Create rc.d script
To make Gitlab run automatically on FreeBSD server, you need to create rc.d script. Follow the command below.

Enable gitlab to run automatically on FreeBSD. In `/etc/rc.conf` file, type the script below.

```console
root@ns3:~ # ee /etc/rc.conf
gitlab_enable="YES"
gitlab_authBackend="http://192.168.5.2:8080"
gitlab_workhorse_tcp="NO"
gitlab_workhorse_addr="192.168.5.2:8181"
gitlab_mail_room_enable="NO"
gitlab_allow_conflicts="NO"
gitlab_wait="120"

gitlab_pages_enable="YES"
gitlab_pages_dir="/var/tmp/gitlab_pages"
gitlab_pages_user="gitlab-pages"
gitlab_pages_group="gitlab-pages"
gitlab_pages_logfile="/var/log/gitlab_pages.log"
gitlab_pages_args="-config=/usr/local/share/gitlab-pages/gitlab-pages.conf"
```

### 5.8. Run Gitlab
The next step is to set up Redmine to connect to Ruby.

```console
root@ns3:/usr/local/www/gitlab-ce # bundle exec rake generate_secret_token
root@ns3:/usr/local/www/gitlab-ce # bundle exec rake db:migrate RAILS_ENV="production"
```
The final step is to run gitlab-ce.

```console
root@ns3:/usr/local/www/gitlab-ce # service gitlab restart
root@ns3:/usr/local/www/gitlab-ce # ruby bin/rails server -e production
```
After you finish reading this article, your server now has a fully functional GitLab hosted on your own server. You can start importing or creating new projects and sharing access to them with your team members. Gitlab will be adding new features and updating the platform regularly, so it doesn’t hurt to visit the GitLab platform page often to check the project homepage for the latest information on important fixes or notifications.