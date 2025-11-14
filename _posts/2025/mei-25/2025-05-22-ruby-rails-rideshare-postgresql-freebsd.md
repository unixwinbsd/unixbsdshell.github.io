---
title: Configuring Ruby Rails With Rideshare PostgreSQL On FreeBSD
date: "2025-05-22 11:55:35 +0100"
updated: "2025-05-22 11:55:35 +0100"
id: ruby-rails-rideshare-postgresql-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: Ruby on Rails or commonly called Rails is a full-stack framework written in the Ruby programming language. Ruby on Rails or RoR is available for several operating systems such as FreeBSD, Linux, Windows and Mac OS and backend to build static websites.
keywords: freebsd, php, php-fpm, ruby, rails, rideshare, postgresql, database, sql, web server, nginx, apache
---

Ruby on Rails is not a computer programming language, but rather a website application framework. Ruby on Rails is an excellent framework for developing web applications using the Ruby language. Many people use Ruby as a language to create static websites. With the help of ruby on rails you can develop static web applications faster as compared to other frameworks. Ruby on Rails is a friendly, easy to use web framework that makes life easier by doing most of your website development work.

Ruby on Rails or commonly called Rails is a full-stack framework written in the Ruby programming language. Ruby on Rails or RoR is available for several operating systems such as FreeBSD, Linux, Windows and Mac OS and backend to build static websites.

Ruby on Rails was created based on a set of predefined patterns, libraries and frameworks that allow beginners and professionals to quickly implement various functions such as sending emails or reading data from MySQL, MariaDB or PostgreSQL databases. For example, Rails implements an object-relational mapper (ORM) pattern called Active Record, which makes it easy for developers to interact with databases using Ruby objects.

Before you dive into Rails, you need to know a little about the Ruby language. Ruby is an open source and general purpose programming language used for website development, automation, data processing and more. Ruby is a programming language that is very flexible and portable, meaning you can run it on almost any operating system. Ruby is almost the same as Python, namely it runs dynamically and uses minimalist syntax. In summary, it uses spaces to organize code instead of brackets or other symbols to define blocks in a script.

In this tutorial we will explain how to set up the Ruby on Rails framework on your FreeBSD machine and deploy a web application with a postgreSQL database. Why PostgreSQL? Many people like it and you need it for example for deployments on heroku and your website development environment.

In this article, we will demonstrate how to install Rideshare with Ruby on Rails and a PostgreSQL database. The entire content of this article was written using the following tools:
- Operating system: FreeBSD 13.3
- IP Addres: 192.168.5.2
- Name server: ns3
- Ruby version: ruby 3.1.4p223 (2023-03-30 revision 957bb7cb81) [amd64-freebsd13]
- Bundler version: Bundler 2.3.6
- Gem version: gems 3.5.7
- Database: Postgresql15-server


## 1. Create Database Rideshare

As explained above, we will use a PostgreSQL database to connect to the Rideshare application. In this article we assume, you have installed a PostgeSQL database. Before you install Ruby and others, first create a Rideshare database with PostgreSQL. Follow these commands to create a Rideshare database.

```
root@ns3:~ # su - postgres
$ createuser userrideshare
$ createdb rideshare -O userrideshare encoding='UTF8'
$ psql rideshare
psql (15.5)
Type "help" for help.

rideshare=# alter user userrideshare with password 'router123';
ALTER ROLE
rideshare=# exit
$ exit
root@ns3:~ #
```
The command above is used to create a Rideshare database with the following conditions:
user: userrideshare
database: rideshare
host: localhost
password: router123


## 2. Install Ruby on Rails

To install the Ruby on Rails environment, you must install Ruby on your FreeBSD machine. You need to know, in FreeBSD there are many versions of Ruby that will be installed automatically, to overcome this, you have to determine the version of Ruby that will be used on the FreeBSD machine. Add the script below to the **/etc/make.conf** file.

```
root@ns3:~ # ee /etc/make.conf
DEFAULT_VERSIONS+=ruby=3.1
```
After you have determined the version of Ruby you will use, namely Ruby31, run the Ruby installation process.

```
root@ns3:~ # pkg install ruby
```
After that, you install the bundler and Gems.

```
root@ns3:~ # pkg install rubygem-bundler ruby31-gems
```
You also install Rails, to run Ruby applications.

```
root@ns3:~ # pkg install rubygem-rails60
```


## 3. Cloning / Install Rideshare

On FreeBSD servers, rideshare is not available in the PKG repository or ports. You have to download it from the official site or Github server. In this article, we will clone rideshare from a Github server. Before you clone rideshare, run the command to install rideshare dependencies.

```
root@ns3:~ # pkg install graphviz rubygem-ruby-graphviz rbenv
```
After that, you download rideshare from the Github server, we will place all the rideshare files in the /usr/local/www directory, run the command below.

```
root@ns3:~ # cd /usr/local/www
root@ns3:/usr/local/www # git clone https://github.com/andyatkinson/rideshare.git
```


## 4. Setup Rideshare

Rideshare adalah aplikasi Ruby on Rails untuk buku, yang diciptakan pada tahun 2024 oleh Pragmatic Programmers. Diperlukan database PostgreSQL untuk menjalankan rideshare, karena rideshare termasuk salah satu aplikasi "High Performance PostgreSQL for Rails", yang dapat dijalankan di sistem BSD, Linux, Windows dan MaxOS.

Run the command below to install rideshare on FreeBSD.

```
root@ns3:/usr/local/www/rideshare # gem update --system
root@ns3:/usr/local/www/rideshare # bundle install
root@ns3:/usr/local/www/rideshare # gem install error_highlight -v 0.4.0
root@ns3:/usr/local/www/rideshare # bundle binstubs pgslice --force
root@ns3:/usr/local/www/rideshare # bundle update
```
After that, run the import schema postgresql command.

```
root@ns3:/usr/local/www/rideshare # cd db
root@ns3:/usr/local/www/rideshare/db # pg_dump -U userrideshare -W -F p -d rideshare > create_role_owner.sql
root@ns3:/usr/local/www/rideshare/db # pg_dump -U userrideshare -W -F p -d rideshare > create_role_app_user.sql
root@ns3:/usr/local/www/rideshare/db # pg_dump -U userrideshare -W -F p -d rideshare > create_role_app_readonly.sql
root@ns3:/usr/local/www/rideshare/db # pg_dump -U userrideshare -W -F p -d rideshare > alter_default_privileges_readwrite.sql
root@ns3:/usr/local/www/rideshare/db # pg_dump -U userrideshare -W -F p -d rideshare > alter_default_privileges_readonly.sql
root@ns3:/usr/local/www/rideshare/db # pg_dump -U userrideshare -W -F p -d alter_default_privileges_public.sql
root@ns3:/usr/local/www/rideshare/db # pg_dump -U userrideshare -W -F p -d create_database.sql
root@ns3:/usr/local/www/rideshare/db # pg_dump -U userrideshare -W -F p -d revoke_drop_public_schema.sql
root@ns3:/usr/local/www/rideshare/db # pg_dump -U userrideshare -W -F p -d create_schema.sql
root@ns3:/usr/local/www/rideshare/db # pg_dump -U userrideshare -W -F p -d create_grants_database.sql
root@ns3:/usr/local/www/rideshare/db # pg_dump -U userrideshare -W -F p -d create_grants_schema.sql
```
Run migrations Rails the standard way.

```
root@ns3:/usr/local/www/rideshare # bin/rails db:migrate
```
Run Rideshare.

```
root@ns3:/usr/local/www/rideshare # rails s -b 192.168.5.2
```
Build faster, more reliable Rails Rideshare applications by leveraging the best of PostgreSQL and Active Record capabilities, and use them to solve your application's scale and growth challenges. Now you have successfully run the Rails Rideshare Application for the book "High Performance PostgreSQL for Rails" on the FreeBSD server.
