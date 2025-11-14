---
title: Installation Guide and How to Use Redmine on FreeBSD
date: "2025-09-11 08:57:03 +0100"
updated: "2025-09-11 08:57:03 +0100"
id: installation-guide-redmine-on-freebsd
lang: en
author: Iwan Setiawan
robots: index, follow
categories: freebsd
tags: WebServer
background: /img/Logo.png
toc: true
comments: true
published: true
excerpt: Redmine is open source software or application that uses the Ruby On Rails Framework. Redmine is a project management or project tracking application which requires a DB server when running the application
keywords: redmine, system, monitoring, tools, freebsd, utility, webserver
---

Building a software system project is not easy, this is due to the level of consumer needs which are becoming more and more complex day by day, in addition to the development of application software itself which is increasing in number and must always be updated. In creating software systems, project management can be applied which can specifically monitor the performance of the software application system creator. With project management, a project manager can track bugs, find out the personnel involved, analyze the progress of the project and carry out project documentation.

One alternative project management system application that can be used is Redmine, which has several features including the use of multiple projects/issues, access control rules, issue search, project statistics, project work schedule, document archives (both old/new documents), notifications via email or xml, integration with Subversion.

Redmine is open source software or application that uses the Ruby On Rails Framework. Redmine is a project management or project tracking application which requires a DB server when running the application, where the technology can be used remotely which definitely makes your work easier anywhere because it has a wide reach.

Redmine is a very flexible web-based project management application. Written using the Ruby on Rails framework, Redmine is cross-platform and cross-database. Redmine is open source and released under the GNU General Public License v2 (GPL).

This utility is often used as a project management system that can be configured according to needs, so that project management can work effectively according to needs. Redmine is an alternative for other project management such as: JIRA, Basecamp, Trello, Asana, etc. This system is equipped with various plugins which are very useful and can help users to make their project management run more smoothly. Redmine is suitable as a project management system that is suitable for small-scale firms to large-scale companies. Redmine is an open source alternative to similar project management solutions such as Atlassian JIRA, Basecamp, Trello, Slack, Asana, Breeze, etc.


## 1. System Requirements

- OS: FreeBSD 13.2
- IP address: 192.168.5.2
- Hostname: ns3
- Ruby version: ruby 3.1.4p223 (2023-03-30 revision 957bb7cb81) [amd64-freebsd13]
- Redmine version: redmine50
- Rails version: rails7
- Database Server: mysql-server8
- Dependencies: rubygem-bundler_ext rubygem-bundler rubygem-rails70 rubygem-jquery-rails rubygem-coderay rubygem-request_store rubygem-mime-types rubygem-protected_attributes rubygem-mimemagic rubygem-mail rubygem-i18n rubygem-rails-html-sanitizer rubygem-rbpdf rubygem-ruby-openid rubygem-rack-openid rubygem-rake rubygem-redcarpet

## 2. Install Ruby

Because Redmine runs using the Ruby Framework, the first step we have to do is install Ruby. Ruby is a dynamic, simple and high productivity programming language. Ruby has an elegant syntax, is easy to read, write and another advantage is that it is open source. Run the following command to install Ruby.

```yml
root@ns3:~ # cd /usr/ports/lang/ruby32
root@ns3:/usr/ports/lang/ruby31 # make install clean
```

If you want to use the PKG package, run the following command.

```yml
root@ns3:~ #  pkg install ruby32
```

After that install some standard libraries to run Ruby.

```yml
root@ns3:~ # cd /usr/ports/databases/rubygem-dbm
root@ns3:/usr/ports/databases/rubygem-dbm # make install clean
root@ns3:/usr/ports/databases/rubygem-dbm # cd /usr/ports/databases/rubygem-gdbm
root@ns3:/usr/ports/databases/rubygem-gdbm # make install clean
```

Check the Ruby version.

```yml
root@ns3:~ # ruby -v
ruby 3.1.4p223 (2023-03-30 revision 957bb7cb81) [amd64-freebsd13]
```

Ruby checking can also be done by creating a simple program. We will create a `"Hello World"` program to ensure Ruby is running on FreeBSD. All programs that run Ruby have the extension `*.rb` and on FreeBSD all files resulting from Ruby installation are stored in the `/usr/local/share/examples/ruby32` directory. Follow the guide below to create a Ruby program.

```console
root@ns3:~ # cd /usr/local/share/examples/ruby32
root@ns3:/usr/local/share/examples/ruby32 # ee rubytest.rb
msg = Class.send(:new, String);
mymsg = msg.send(:new, "Hello Ruby World !\n");
STDOUT.send(:write, mymsg)
```

Run the Ruby Program.

```yml
root@ns3:/usr/local/share/examples/ruby32 # ruby rubytest.rb
Hello Ruby World !
```

## 3. Setting up Redmine

Redmine is a cross-platform and cross-database web application. In this section we will set up Redmine on FreeBSD. In this article, we will connect Redmine to the Apache24 web server and MySQL database.

### a. Install Dependencies

After you have finished installing Ruby, we continue with installing Redmine. Before you start installing Redmine, first install some Redmine dependencies. Run the following command to install Redmine dependencies.

```yml
root@ns3:~ # pkg install rubygem-bundler_ext rubygem-bundler rubygem-rails70 rubygem-jquery-rails rubygem-coderay rubygem-request_store rubygem-mime-types rubygem-protected_attributes rubygem-mimemagic rubygem-mail rubygem-i18n rubygem-rails-html-sanitizer rubygem-rbpdf rubygem-ruby-openid rubygem-rack-openid rubygem-rake rubygem-redcarpet
```

### b. Install Redmine

To install Redmine on FreeBSD, we recommend that you use the PKG package, because when using ports, there are often problems with the Redmine version and other dependencies. Run the command below to install Redmine with PKG.

```yml
root@ns3:~ # pkg install redmine50
```

All files resulting from the Redmine installation above will be stored in the `/usr/local/www/redmine` directory. After that, create a Start up script `rc.d`, so that Redmine can run automatically. Type the script below in the rc.conf file.

```yml
root@ns3:~ # ee /etc/rc.conf
redmine_enable="YES"
redmine_flags="-a 192.168.5.2 -p 3000 -e production"
redmine_user="redmine"
redmine_group="redmine"
```

### c. Create User and Group "redmine"

By default, FreeBSD installs Redmine with the user and group `"www:www"`, almost the same as Apache24. To avoid this, we will create a new user and group for Redmine.

```
root@ns3:~ # pw add group redmine
root@ns3:~ # pw add user -n redmine -g redmine -s /sbin/nologin -c "redmine"
```

### d. Create Database "redmine"

The Redmine server requires a database server, you can use Mysql, MariaDBSQLite or PostgreSQL. All database servers are supported by Redmine. In this article we will use a commonly used database server, namely MySQL. Run the command below to create a redmine database.

```console
root@ns3:~ # mysql -u root -p
Enter password:
root@localhost [(none)]> CREATE DATABASE redmine CHARACTER SET utf8;
root@localhost [(none)]> CREATE USER 'useredmine'@'localhost' IDENTIFIED BY 'router123';
root@localhost [(none)]> GRANT ALL PRIVILEGES ON redmine.* TO 'useredmine'@'localhost';
root@localhost [(none)]> FLUSH PRIVILEGES;
root@localhost [(none)]> exit;
Bye
root@ns3:~ #
```

Open the database.yml file, replace the production database script with the script below, adapt it to the MySQL database you created above.

```console
root@ns3:~ # cd /usr/local/www/redmine/config
root@ns3:/usr/local/www/redmine/config # ee database.yml
production:
  adapter: mysql2
  database: redmine
  host: localhost
  username: useredmine
  password: "router123"
  # Use "utf8" instead of "utfmb4" for MySQL prior to 5.7.7
  encoding: utf8mb4

```

### e. Redmine configuration

After you have set up the MySQL database in the `database.yml` file, next we configure Redmine with Ruby. The first step is to update the gem.

```yml
root@ns3:~ # cd /usr/local/www/redmine
root@ns3:/usr/local/www/redmine # gem update --system 3.5.7
```

Continue by installing the gem.

```yml
root@ns3:/usr/local/www/redmine # bundle install --gemfile /usr/local/www/redmine/Gemfile
```

The next step is to set up Redmine to connect to Ruby.

```yml
root@ns3:~ # cd /usr/local/www/redmine
root@ns3:/usr/local/www/redmine # bundle install --without development test
root@ns3:/usr/local/www/redmine # bundle exec rake generate_secret_token
root@ns3:/usr/local/www/redmine # bundle exec rake db:migrate RAILS_ENV="production"
```

Change ownership and permissions Redmine.

```yml
root@ns3:~ # chown -R redmine:redmine files log tmp public
root@ns3:~ # chmod -R 755 files log tmp public
```

### f. Run configuration

The next step, run Redmine.

```yml
root@ns3:/usr/local/www/redmine # service redmine restart
root@ns3:/usr/local/www/redmine # ruby bin/rails server -e production
```

To open Redmine, open the Google Chrome web browser, type "http://192.168.5.2:3000/", If there are no errors in the above settings, your monitor screen will display the Redmine Dashboard.

After that, click the `"Sign in"` menu in the top right corner.


In the Login and password menu, type:
Login : admin
Password: admin
After that, a menu will appear to change the default password.

With the continued increase in website needs, you can make Redmine a complete solution for project management and problem tracking. The features offered by Redmine are very complete, easy to use and free. You can save a lot of costs by choosing Redmine. Apart from that, you can increase productivity regarding the quality of your website, so that your business and enterprise can continue to grow.